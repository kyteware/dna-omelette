# import Pkg
# Pkg.add("Plots")
# using Plots

function main()

    bin = Vector()
    for _ in 1:100000
        pokemon = Set{Int32}()
        tries = 0
        while true
            tries += 1
            new = rand(1:100000)
            if new in pokemon
                break
            end
            push!(pokemon, new)
        end
        push!(bin, tries)
    end
    println(sum(bin) / length(bin))
    
end
main()