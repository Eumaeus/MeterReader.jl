#= FOR REFERENCE

struct AnnotatedSyllable
	syllable::BasicSyllable
	quantity::String
	flags::Vector{String}
	rules::Vector{String}
end

struct MetricalFoot
	seq::Int
	syllables::Vector{AnnotatedSyllable}
end

=#

# Recursive function to pre-process a line into every possible syllable quantity
function preprocess_quantities(syllables::Vector{AnnotatedSyllable})::Vector{Vector{AnnotatedSyllable}}

	all_possibles::Vector{Vector{AnnotatedSyllable}} = Vector{Vector{AnnotatedSyllable}}()
	

end # function preprocess_quantities()


"Given a CitablePassage, process it into a Vector{AnnotatedSyllable}"
function prepare_to_parse(cp::CitablePassage)::Vector{AnnotatedSyllable}	

	# Make it a PoeticLine
	poetic_line::MeterReader.PoeticLine = MeterReader.makePoeticLine(cp)

	# Synapheia: Run the characters together without punctuation or spaces
	synaph::MeterReader.Synapheia = MeterReader.synapheia(poetic_line.chars)

	# Do a first-cut syllabification into a Vector{BasicSyllable}
	sylls::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(synaph)

	# Do a first-cut analysis for quantity and flags
	vas::Vector{MeterReader.AnnotatedSyllable} = map( eachindex(sylls) ) do i 
		MeterReader.evaluate(sylls, i)
	end

	return vas

end

function prepare_to_parse(s::String)::Vector{AnnotatedSyllable}
	# Make it a PoeticLine
	cp::CitablePassage = citablePassage(s)
	# Go from here…
	prepare_to_parse(cp)
end	
