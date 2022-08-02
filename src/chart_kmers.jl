run(`./scripts/download_sample_fasta.bash`)

if length(ARGS) >= 1
    klength = parse(Int64, ARGS[1])
else
    klength = 1
end
if length(ARGS) >= 2
    seqnum = parse(Int64, ARGS[2])
else
    seqnum = 1
end

# finding where the requested sequance starts
linenum = 0
for line in eachline("./sample.fasta")
    global linenum += 1
    if first(line, 1) == ">"
        global seqnum
        if seqnum <= 1
            global startline = linenum + 1
            break
        else
            global seqnum -= 1
        end
    end
end

# this combines the whole file into a string.
# doing this is easy, but for larger files,
# the computer's memory may get overloaded.
# we should try to iterate line to line 
# properly so that the program can drastically
# drop in ram usage.

nucleos = ""
status = "searching"
for line in eachline("./sample.fasta")
    global status
    if status == "searching"
        global startline
        if startline == 1
            status = "iterating"
        else
            startline -= 1
        end
    end
    # if it was one, the program will go from
    # the previous if directly into this one
    # without iterating again
    if status == "iterating"
        if first(line, 1) == ">"
            status = "done"
        else
            global nucleos *= line
        end
    end
end

println(nucleos)