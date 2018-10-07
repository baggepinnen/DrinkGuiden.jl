using LightXML

struct XMLLoader <: DataLoader
    path::String
end

function get_ingredients(xml::XMLElement)
    list = get_elements_by_tagname(xml, "Ingredients")[1]
    ing = get_elements_by_tagname(list, "Ingredient")
    Ingredient.(ing)
end

function get_recepies(xml::XMLElement)
    list = get_elements_by_tagname(xml, "Ingredients")[1]
    get_elements_by_tagname(list, "Ingredient")
end

function load_legacy_database(loader::XMLLoader, filename)

    xdoc = parse_file(joinpath(loader.path,"filename"))

    # get the root element
    xroot = root(xdoc)  # an instance of XMLElement
    # print its name
    println(name(xroot))  # this should print: bookstore


    systembolagxml = get_elements_by_tagname(xroot, "Systembolaget")[1]
    cabinetxml = get_elements_by_tagname(xroot, "Barskapet")[1]
    drinkbookxml = get_elements_by_tagname(xroot, "Drinkboken")[1]

    sysing = get_ingredients(systembolagxml)
    systembolag = Systembolag(sysing)
    supermarket = Supermarket(sysing)
    cabinet = BarCabinet(get_ingredients(cabinetxml))

    return systembolag, supermarket, cabinet, drinkbook
end


function Ingredient(ing::XMLElement)
    name = content.(get_elements_by_tagname(ing, "Name"))[]

    ad = attributes_dict(ing)
    if ad["type"] == "Sprit"
        sort = content.(get_elements_by_tagname(ing, "Spritsort"))[]
        return Alcohol(name)
    end
    Side(name)
end
