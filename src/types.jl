export Alcohol, Side, DrinkComponent, Recipe, DrinkBook, BarCabinet, Systembolag, Supermarket

abstract type DataLayer end    # For dispatch
abstract type Presenter end     # For dispatch
abstract type Ingredient end

struct Alcohol <: Ingredient
    name::String
end

struct Side <: Ingredient
    name::String
end

struct DrinkComponent
    ingredient::Ingredient
    mandatory::Bool
    quantity
end

struct Recipe
    name::String
    ingredients::Vector{DrinkComponent}
    description::String
end

struct DrinkBook
    recipes::Vector{Recipe}
end

struct BarCabinet
    alcohols::Vector{Alcohol}
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





const ContainerType = Union{DrinkBook, BarCabinet, Systembolag, Supermarket}
# All types in ContainerType implements push!, merge!

const ElementType = Union{Ingredient, Alcohol, Side, DrinkComponent, Recipe}
# All types in ElementType implements name(e), similarname(e)
