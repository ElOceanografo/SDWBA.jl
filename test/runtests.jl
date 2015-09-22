using SDWBA
using Base.Test

# write your own tests here
@test 1 == 1

include("test_bent_cylinder.jl")

println("\nPassed all tests.")