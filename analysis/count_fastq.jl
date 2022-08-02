run(`./scripts/download_sample_fastq.bash`)

totallines = 0
for line in eachline("./sample.fastq")
    if line == "+"
        global totallines += 1
    end
end

println(totallines)