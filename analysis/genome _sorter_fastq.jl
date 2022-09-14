function countline(data)
    counter = Dict()
    for bp in data
        bp = Char(bp)
        bp = uppercase(bp)
        counter[bp] = get(counter, bp, 0) + 1
    end
    return counter
end

function countline(data, counter)
    for bp in data
        bp = Char(bp)
        bp = uppercase(bp)
        counter[bp] = get(counter, bp, 0) + 1
    end
    return counter
end
download("https://zenodo.org/record/3736457/files/1_control_psbA3_2019_minq7.fastq?download=1")
input = read("sample.fastq")
counter = Dict()
index = 1
for line in eachline("sample.fastq")
    global index
    if index == 2 
        countline(line, counter)
        println(line)
    elseif index == 4 
        index = 0
    end
    index += 1
end
counter
println(counter)
