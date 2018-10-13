using Test, DrinkGuiden
path = joinpath(@__DIR__, "..")
# include("../src/types.jl")
# include("../src/logiclayer.jl")
# include("../src/datalayer.jl")
loader = XMLLayer(path)

filename = "testdatabas.xml"
xdoc = DrinkGuiden.parse_file(joinpath(loader.path,filename))

# get the root element
xroot = DrinkGuiden.root(xdoc)  # an instance of XMLElement
@test xroot isa DrinkGuiden.XMLElement

systembolagxml = DrinkGuiden.get_elements_by_tagname(xroot, "Systembolaget")[1]
cabinetxml = DrinkGuiden.get_elements_by_tagname(xroot, "Barskapet")[1]
drinkbookxml = DrinkGuiden.get_elements_by_tagname(xroot, "Drinkboken")[1]

@test systembolagxml isa DrinkGuiden.XMLElement
@test cabinetxml isa DrinkGuiden.XMLElement
@test drinkbookxml isa DrinkGuiden.XMLElement

sysing = DrinkGuiden.get_ingredients(systembolagxml)
@test sysing isa Vector{DrinkGuiden.Ingredient}
@test length(sysing) == 57
systembolag = Systembolag(sysing)
@test systembolag isa Systembolag
supermarket = Supermarket(sysing)
@test supermarket isa Supermarket
cabinet = BarCabinet(DrinkGuiden.get_ingredients(cabinetxml))
@test cabinet isa BarCabinet

drinkbook = DrinkBook(DrinkGuiden.get_recepies(drinkbookxml))
@test length(drinkbook) == 61

systembolag, supermarket, cabinet, drinkbook = load_legacy_database(loader, filename)


json = JSONLayer(path)
save(json, "test.json", drinkbook)
@test isfile(joinpath(path, "test.json"))
@test load(json, "test.json") == drinkbook


save(json, "test.json", systembolag)
@test load(json, "test.json") == systembolag

save(json, "test.json", cabinet)
@test load(json, "test.json") == cabinet

rm(joinpath(path, "test.json"), force=true)
