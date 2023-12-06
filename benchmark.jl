start = time_ns() / 1e9
for i in 1:1000000000 end
end_time = (time_ns() / 1e9) - start
println("Contei até ", 1000000000, " em ", end_time, " segundos.")