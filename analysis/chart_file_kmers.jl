import Pkg
Pkg.add("Dictionaries")
Pkg.add("Plots")
using Plots, Dictionaries

klength = parse(Int64, ARGS[1])
filename = ARGS[2]

function main(klength, filename)
    kmers = Dict{String,Int64}()
    kmer = ""
    file = open(filename)

    while !eof(file)
        c = string(read(file, Char))
        if length(kmer) >= klength
            if haskey(kmers, kmer)
                kmers[kmer] += 1
            else
                kmers[kmer] = 1
            end
            kmer = chop(kmer, head = 1)
        end

        kmer *= string(c)
    end

    # prints the output dict
    println(kmers)

    # sorts the values
    sorted = sort(Dictionary(kmers), by = x->-x)

    # tries to display a graph (takes forever for some reason)
    display(bar(collect(keys(sorted)), collect(values(sorted))))

    # apparently this stops the display from immediatly closing
    readline()
end

main(klength, filename)