#= FOR REFERENCE

struct AnnotatedSyllable
	syllable::BasicSyllable
	quantity::String
	flags::Vector{String}
	rules::Vector{String}
end

=#

function startparse(vas::Vector{MeterReader.AnnotatedSyllable})::Vector{MeterReader.MetricalFoot}

end