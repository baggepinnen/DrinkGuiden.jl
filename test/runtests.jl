using DrinkGuiden
using Test

@testset "DrinkGuiden.jl" begin

@testset "Datalayer" begin
include("testdata.jl")
end

@testset "Logiclayer" begin
include("testlogic.jl")
end

@testset "Presentationlayer" begin
include("testpresentation.jl")
end

end
