using Lazy: @forward
@forward DrinkBook.recipes (Base.:(==), Base.length, Base.iterate, Base.getindex)
@forward Systembolag.alcohols (Base.:(==), Base.length, Base.iterate, Base.getindex)
@forward Supermarket.sides (Base.:(==), Base.length, Base.iterate, Base.getindex)

Base.:(==)(x::Systembolag, y::Systembolag) = x.alcohols == y.alcohols
Base.:(==)(x::Supermarket, y::Supermarket) = x.sides == y.sides
Base.:(==)(x::BarCabinet, y::BarCabinet) = x.sides == y.sides && x.alcohols == y.alcohols



ingredients(r::Recipe) = [r.alcohols; r.sides]
Base.length(r::Recipe) = length(r.alcohols) + length(r.sides)

Base.:(==)(x::Ingredient, y::Ingredient) = x.name == y.name
function Base.:(==)(x::Recipe, y::Recipe)
    x.name == y.name &&
    x.alcohols == y.alcohols &&
    x.sides == y.sides &&
    x.description == y.description
end
