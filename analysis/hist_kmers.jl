import Pkg
Pkg.add("Dictionaries")
Pkg.add("Plots")

using Plots; gr()

run(`./scripts/download_sample_fasta.bash`)

if length(ARGS) >= 1
    klength = parse(Int64, ARGS[1])
else
    klength = 1
end

klength = 7

filename = "./sample.fastq"
kmers = Dict{String,Int64}()

lines_until_read = 1
for line in eachline(filename)
    global lines_until_read
    if lines_until_read == 0
        line = strip(line)
        for i in 1:(length(line)-klength+1)
            kmer = SubString(line, i:(i+klength-1))
            if haskey(kmers, kmer)
                kmers[kmer] += 1
            else
                kmers[kmer] = 1
            end
        end
        lines_until_read = 3
    else
        lines_until_read -= 1
    end
end

# prints the output dict
vals = collect(values(kmers))

println(vals)

# tries to display a graph (takes forever for some reason)
display(histogram(
    vals,
    xscale=:log10,
    yscale=:log10,
    )
) # x axis log scale

# apparently this stops the display from immediatly closing
readline()