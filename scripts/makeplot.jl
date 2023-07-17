# Script to Make a Plot
using CSV, DataFrames, Plots
println("hello")
df = DataFrame(CSV.File("out.csv"))
x = df.item
y = df.count
plot(x,y)