
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

input = read(# link your file)
counter = Dict()
countline(input, counter)
countline(input, counter)
for line in eachline(# link the file you want)
    countline(line, counter)
end
counter

