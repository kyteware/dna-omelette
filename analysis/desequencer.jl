
function getargs()
    if length(ARGS) >= 1
        readlen = ARGS[1]
    else
        readlen = 50
    end
    if length(ARGS) >= 2
        overlap = ARGS[2]
    else
        overlap = 20
    end

    return readlen, overlap
end

function main()
    run(`./scripts/download_sample_fasta.bash`)
    # overlaps not implemented yet
    readlen, overlap = getargs()
    sample = read("./sample.fasta", String)
    fasta = IOBuffer(sample)

    reads = Vector{String}()
    currentread = Vector{Char}()
    countdown = 0
    for letter in fasta
        if peek(fasta) === nothing
            countdown = 0
        end

        if countdown == 0
            append!(reads, join(currentread))
            countdown = rand(Int, readlen*0.5, readlen*1.5)
        else
            countdown -= 1
            append!(currentread, letter)
        end
    end
    println(reads)
end

main()