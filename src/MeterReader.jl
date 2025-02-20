module MeterReader

using Unicode
using BetaReader
using CitableText
using CitableCorpus

include("TextPrep.jl")
include("Constants.jl")
include("Utilities.jl")
include("SyllabifyUtilities.jl")
include("Syllabify.jl")

export split_and_retain
export eachwithindex
export PoeticLine

end # module
