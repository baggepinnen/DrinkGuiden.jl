abstract type DataLoader end    # For dispatch
abstract type Presenter end     # For dispatch


abstract type Ingredient end

struct Alcohol <: Ingredient
    name::String
end

struct Side <: Ingredient
    name::String
end

struct Recipe
    algohols::Vector{Alcohol}
    sides::Vector{Side}
    description::String
end

ingredients(r::Recipe) = [r.alcohols; r.sides]
Base.length(r::Recipe) = length(r.alcohols) + length(r.sides)

struct DrinkBook
    recepies::Vector{Recipe}
end

struct BarCabinet
    algohols::Vector{Alcohol}
    sides::Vector{Side}
end

function BarCabinet(ing::Vector{Ingredient})
    BarCabinet(alcohols(ing), sides(ing))
end

struct Systembolag
    alcohols::Vector{Alcohol}
end
Systembolag(ing::Vector{Ingredient}) = Systembolag(alcohols(ing))

struct Supermarket
    sides::Vector{Side}
end
Supermarket(ing::Vector{Ingredient}) = Supermarket(sides(ing))

alcohols(v) = [i for i in v if i isa Alcohol]
sides(v) = [i for i in v if i isa Side]
