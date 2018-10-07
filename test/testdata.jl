
path = joinpath(@__DIR__, "..")
loader = XMLLoader(path)

filename = "databas.xml"
xdoc = parse_file(joinpath(loader.path,filename))

# get the root element
xroot = root(xdoc)  # an instance of XMLElement
# print its name
println(name(xroot))

systembolagxml = get_elements_by_tagname(xroot, "Systembolaget")[1]
cabinetxml = get_elements_by_tagname(xroot, "Barskapet")[1]
drinkbookxml = get_elements_by_tagname(xroot, "Drinkboken")[1]

sysing = get_ingredients(systembolagxml)
systembolag = Systembolag(sysing)
supermarket = Supermarket(sysing)
cabinet = BarCabinet(get_ingredients(cabinetxml))

drinkbook = get_recepies(drinkbookxml)

ing = ing[1]


a = Ingredient.(ing)



load_legacy_database(loader, filename)
