module MeterReader

using Unicode
using BetaReader
using CitableText
using CitableCorpus

include("TextPrep.jl")
include("PrettyPrint.jl")
include("Constants.jl")
include("Utilities.jl")
include("SyllabifyUtilities.jl")
include("Syllabify.jl")
include("Parse.jl")

export split_and_retain
export eachwithindex
export PoeticLine

end # module
