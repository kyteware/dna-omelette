
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

function reverse_sequence(seq)
    newseq = ""
    for nucleo in reverse(seq)
        if nucleo == 'A'
            newseq *= 'T'
        elseif nucleo == 'T'
            newseq *= 'A'
        elseif nucleo == 'G'
            newseq *= 'C'
        else
            newseq *= 'G'
        end
    end
    return newseq
end

function main()
    run(`./scripts/download_sample_fasta.bash`)
    readnum, readlenrange = getargs()
    reads = Vector{String}()

    # left = rand(round(readnum*0.25) : round(readnum*0.75))
    # right = length(sample) - left

    sequence = ""
    for line in readlines("./sample.fasta")
        if !startswith(line, ">")
            sequence *= strip(line)
        end
    end

    for _ in 1:readnum
        pos = rand(1:length(sequence))
        toright = rand(Bool)
        if toright
            readrange = pos:min(pos + rand(readlenrange), length(sequence))
            push!(reads, sequence[readrange])
        else
            readrange = max(pos - rand(readlenrange), 1):pos
            push!(reads, reverse_sequence(sequence[readrange]))
        end
    end
    println(reads)
end

main()