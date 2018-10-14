export ingredients, merge!, similarname, alcohols, sides


using Lazy: @forward
@forward DrinkBook.recipes (Base.length, Base.iterate, Base.getindex)
@forward Systembolag.alcohols (Base.length, Base.iterate, Base.getindex)
@forward Supermarket.sides (Base.length, Base.iterate, Base.getindex)

ingredients(r::Recipe) = [r.alcohols; r.sides]
alcohols(v)            = [i for i in v if i isa Alcohol]
sides(v)               = [i for i in v if i isa Side]
Base.length(r::Recipe) = length(r.alcohols) + length(r.sides)

Base.:(==)(x::Systembolag, y::Systembolag) = x.alcohols == y.alcohols
Base.:(==)(x::Supermarket, y::Supermarket) = x.sides == y.sides
Base.:(==)(x::BarCabinet, y::BarCabinet) = x.sides == y.sides && x.alcohols == y.alcohols
Base.:(==)(x::DrinkBook, y::DrinkBook) = x.recipes == y.recipes

Base.:(==)(x::Ingredient, y::Ingredient) = x.name == y.name
function Base.:(==)(x::Recipe, y::Recipe)
    x.name == y.name &&
    x.ingredients == y.ingredients &&
    x.description == y.description
end

name(dc::DrinkComponent) = name(dc.ingredient)
name(x::ElementType) = x.name
name(s::String) = s

function Base.iterate(b::BarCabinet, state=1)
    state == length(b) && return nothing
    state <= length(b.alcohols) && return b.alcohols[state], state+1
    return b.sides[state - length(b.alcohols)], state+1
end
Base.length(b::BarCabinet) = length(b.alcohols) + length(b.sides)



function Base.push!(db::DrinkBook, x::Recipe)
    fuzzyin(name(x), db) && return false
    push!(db.recepies, x)
    return true
end

function Base.push!(db::Systembolag, x::Alcohol)
    fuzzyin(x, db) && return false
    push!(db.alcohols, x)
    return true
end

function Base.push!(db::Supermarket, x::Side)
    fuzzyin(x, db) && return false
    push!(db.sides, x)
    return true
end

function Base.push!(db::BarCabinet, x::Ingredient)
    fuzzyin(x, db) && return false
    x isa Alcohol && push!(db.alcohols, x)
    x isa Side && push!(db.sides, x)
    return true
end


function similarname(c1::T) where T <: ElementType
    function (c2::T)
        s = compare(Levenshtein(), lowercase(name(c1)), lowercase(name(c2)))
        s > SIMILARITY_THRESHOLD
    end
end
similarname(c1::T,c2::T) where T <: ElementType = similarname(c1)(c2)

function fuzzyin(item, collection)
    sim = similarname(item)
    any(sim(c) for c in collection)
end

"""
`push!`es all elements in `x2` into `x1`
"""
function Base.merge!(x1::T,x2::T) where T <: ContainerType
    foreach(e->push!(x1,e), x2)
end
