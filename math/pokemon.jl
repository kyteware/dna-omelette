import Pkg
Pkg.add("Plots")
using Plots

function main()

    bin = Vector()
    for _ in 1:10000
        pokemon = Vector()
        while true
            new = rand(1:1500)
            if new in pokemon
                break
            end
            push!(pokemon, new)
        end
        push!(bin, length(pokemon))
    end
    println(bin)
    display(Plots.histogram(bin))
end
main()