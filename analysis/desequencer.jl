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

function main() 
    readnum, readlenrange = getargs()
    sequence = getsequence()
    reads = buildreads(readnum, readlenrange, sequence)    

    final = ""
    for (i, read) in enumerate(reads)
        final *= "@"*string(i, base=10, pad=1)*"\n"*read*"\n+\n"*("~"^length(read))*"\n"
    end
    println(final)
end

main()