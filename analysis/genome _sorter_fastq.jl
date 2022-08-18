
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

input = read("sample.fasta")
counter = Dict()
countline(input, counter)
countline(input, counter)
for line in eachline("sample.fasta")
    countline(line, counter)
end
counter

