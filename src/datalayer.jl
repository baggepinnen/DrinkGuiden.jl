using LightXML, JSON

struct XMLLayer <: DataLayer
    path::String
end

function get_ingredients(xml::XMLElement)
    list = get_elements_by_tagname(xml, "Ingredients")[1]
    ing = get_elements_by_tagname(list, "Ingredient")
    Ingredient.(ing)
end

function get_recepies(xml::XMLElement)
    drinks = getr(drinkbookxml, "Drink")
    Recipe.(drinks)
end

function load_legacy_database(loader::XMLLayer, filename)

    xdoc = parse_file(joinpath(loader.path,filename))
    xroot = root(xdoc)
    @info(name(xroot))

    systembolagxml = get_elements_by_tagname(xroot, "Systembolaget")[1]
    cabinetxml = get_elements_by_tagname(xroot, "Barskapet")[1]
    drinkbookxml = get_elements_by_tagname(xroot, "Drinkboken")[1]

    sysing = get_ingredients(systembolagxml)
    systembolag = Systembolag(sysing)
    supermarket = Supermarket(sysing)
    cabinet = BarCabinet(get_ingredients(cabinetxml))
    drinkbook = get_recepies(drinkbookxml)

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
    ings = Ingredient.(getr(drink, "Ingredient"))
    desciption = content(getr(drink, "Description")[])
    name = content(getr(drink, "Name")[1])
    Recipe(name, alcohols(ings), sides(ings), desciption)
end


function getr(root::XMLElement, tag)
    ret = []
    queue = XMLElement[]
    queue = vcat(queue, collect(child_elements(root)))
    while !isempty(queue)
        e = popfirst!(queue)
        if name(e) == tag
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
