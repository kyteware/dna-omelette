#!/usr/bin/julia

if length(ARGS) > 0
    fp = ARGS[1]
    if last(fp) != "/"
        fp*="/"
    end
else
    fp = "./"
end

if isfile(fp*"generated.fasta")
    println("Random FASTA file already generated, skipping...")
else
    fasta = join([join(rand("ATGC", 80)) for x in 1:1000], "\n")
    println(fasta)
    write(
        fp*"generated.fasta", 
        ">Totally random string of nucleotides\n"*fasta)
end