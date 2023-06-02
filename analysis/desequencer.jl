import Pkg; Pkg.add("Distributions"); Pkg.add("Random")
using Distributions, Random

"""
Get the terminal arguments.

Returns:
    (Int64, Range)
    The number of reads and the range of possible read lengths.
"""
function getargs()
    
    if length(ARGS) >= 1
        readnum = parse(Int64, ARGS[1])
    else
        readnum = 100
    end
    if length(ARGS) >= 2
        low, high = split(ARGS[2], ":")
        readlenrange = range(parse(Int64, low), parse(Int64, high), step=1)
    else
        readlenrange = 20:50
    end

    return readnum, readlenrange
end

"""
Replaces each nucleotide in a sequence with its compliment.

Takes a sequence.

Returns the inversed sequence.
"""
function compliment(seq)
    return replace(
        seq,
        "A" => "T",
        "T" => "A",
        "G" => "C",
        "C" => "G"
    )
end

"""Downloads a sample fasta and turns it into a string."""
function getsequence()
    run(`./scripts/download_sample_fasta.bash`)
    
    sequence = ""
    for line in readlines("./sample.fasta")
        if !startswith(line, ">")
            sequence *= strip(line)
        end
    end
    return sequence
end

"""Builds a list of reads from a sequence and settings"""
function buildreads(readnum, readlenrange, sequence)
    reads = Vector{String}()
    for _ in 1:readnum
        pos = rand(1:length(sequence))
        toright = rand(Bool)
        if toright
            readrange = pos:min(pos + rand(readlenrange), length(sequence))
            push!(reads, sequence[readrange])
        else
            readrange = max(pos - rand(readlenrange), 1):pos
            push!(reads, reverse(compliment(sequence[readrange])))
        end
    end
    return reads
end

"""Uses the pareto distribution and log to return an accuracy thats usually close to 95 (highest accuracy)"""
function randaccuracy()
    pareto = Distributions.Pareto{Float64}(0.3, 1.0)
    raw = rand(pareto)
    short = trunc(Int, log(raw) * 4)
    low_capped = max(short, 0)
    high_capped = min(low_capped, 94)
    return 95 - high_capped
end

"""Determines whether or not to scramble based on if `rand(1:100)` is less than y where `y = 1/5000x^(11/4)`"""
function shouldscramble(accuracy)
    threshhold = floor(Int, (1/5000)*((95 - accuracy)^(11/4)))
    return rand(1:100) < threshhold
    # return true
end

"""Converts a number from 1 to 95 to the corresponding fastq confidence value"""
function toscore(accuracy)
    vals = [
        ' ', '!', '"', '#', '$', '%', '&', '\'', '(', 
        ')', '*', '+', ',', '-', '.', '/', '0', '1', 
        '2', '3', '4', '5', '6', '7', '8', '9', ':', 
        ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 
        'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 
        'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 
        'V', 'W', 'X', 'Y', 'Z', '[', '\\', ']', '^', 
        '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 
        'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 
        'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 
        'z', '{', '|', '}', '~'
    ]
    return vals[accuracy]
end

"""Takes a list of reads and scrambles it, returning a list of pairs, keys being the possibly modified nucleotides and values being the confidence `Char`s."""
function scrambleread(read)
    scrambled = Vector{Pair{Char, Char}}()
    for nucleo in read
        accuracy = randaccuracy()
        if shouldscramble(accuracy)
            nucleo = ['a', 't', 'g', 'c'][rand(1:4)]
        end
        push!(scrambled, nucleo => toscore(accuracy))
    end
    return scrambled
end

"""Takes a list of reads, scrambles them and then returns them as a formatted fastq"""
function tofastq(reads)
    final = ""
    for (i, read) in enumerate(reads) 
        scrambled = scrambleread(read)
        nucleos = [x.first for x in scrambled]
        confidences = [x.second for x in scrambled]
        indicator = "@"*string(i)
        final *= indicator * "\n" * join(nucleos) * "\n+\n"* join(confidences) * "\n"
    end
    return final
end

function main()
    readnum, readlenrange = getargs()
    sequence = getsequence()
    reads = buildreads(readnum, readlenrange, sequence)
    println(tofastq(reads))
end

main()
