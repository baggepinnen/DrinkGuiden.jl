using Test, DrinkGuiden
path = joinpath(@__DIR__, "..")
loader = XMLLayer(path)

filename = "testdatabas.xml"
systembolag, supermarket, cabinet, drinkbook = load_legacy_database(loader, filename)

@test similarname(Alcohol("Hej"), Alcohol("Hej"))
@test !similarname(Alcohol("Hej"), Alcohol("På dej"))
for i in cabinet
    i isa Alcohol && @test i ∈ systembolag
    i isa Side    && @test i ∈ supermarket
end
