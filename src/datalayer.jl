export XMLLayer, JSONLayer, load_legacy_database, save, load

import LightXML, JSON
import LightXML: parse_file, get_elements_by_tagname, root, content, XMLElement, attributes_dict, child_elements

struct XMLLayer <: DataLayer
    path::String
end

function get_ingredients(systembolagxml::XMLElement)
    ing = getr(systembolagxml, "Ingredient")
    Ingredient.(ing)
end

function get_recepies(drinkbookxml::XMLElement)
    drinks = getr(drinkbookxml, "Drink")
    Recipe.(drinks)
end

function load_legacy_database(loader::XMLLayer, filename)

    xdoc = parse_file(joinpath(loader.path,filename))
    xroot = root(xdoc)

    systembolagxml = get_elements_by_tagname(xroot, "Systembolaget")[1]
    cabinetxml = get_elements_by_tagname(xroot, "Barskapet")[1]
    drinkbookxml = get_elements_by_tagname(xroot, "Drinkboken")[1]

    sysing = get_ingredients(systembolagxml)
    systembolag = Systembolag(sysing)
    supermarket = Supermarket(sysing)
    cabinet = BarCabinet(get_ingredients(cabinetxml))
    for a in cabinet.alcohols
        push!(systembolag,a)
    end
    for s in cabinet.sides
        push!(supermarket,s)
    end
    drinkbook = DrinkBook(get_recepies(drinkbookxml))

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

function Recipe(drink::XMLElement)
    ings       = Ingredient.(getr(drink, "Ingredient"))
    quantities = content.(getr(drink, "Quantity"))
    mand       = parse.(Bool,content.(getr(drink, "Mandatory")))
    desciption = content(getr(drink, "Description")[])
    name       = content(getr(drink, "Name")[1])
    Recipe(name, DrinkComponent.(ings, mand, quantities), desciption)
end

"""
getr(root::XMLElement, tag::String)
Breadth first tree search for `tag`
"""
function getr(root::XMLElement, tag)
    ret = []
    queue = collect(child_elements(root))
    while !isempty(queue)
        e = popfirst!(queue)
        if LightXML.name(e) == tag
            push!(ret, e)
        else
            queue = vcat(queue, collect(child_elements(e)))
        end
    end
    ret
end




struct JSONLayer <: DataLayer
    path::String
end


function save(saver::JSONLayer, filename, object)
    file = joinpath(saver.path, filename)
    open(file, "w") do f
        print(f, object)
    end
end


function load(saver::JSONLayer, filename)
    file = joinpath(saver.path, filename)
    l = readlines(file)
    recipes = eval(Meta.parse(l[1]))
end
