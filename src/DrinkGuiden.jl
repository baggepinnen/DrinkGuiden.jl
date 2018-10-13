__precompile__()
module DrinkGuiden
using StringDistances

const SIMILARITY_THRESHOLD = 0.8 # Similar names if above

include("types.jl")
include("datalayer.jl")
include("logiclayer.jl")
include("presentationlayer.jl")
include("show.jl")

end
