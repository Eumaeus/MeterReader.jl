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

# Function to parse a line into possible metrical feet
function parse_dactylic_hexameter(syllables::Vector{AnnotatedSyllable})::Vector{Vector{MetricalFoot}}

	# initialize an empty vector of vectors, to hold results
	all_parsings = Vector{Vector{MetricalFoot}}() 

	function recursive_parse(
	  remaining_syllables::Vector{AnnotatedSyllable},
	  current_feet::Vector{MetricalFoot},
	  state::Symbol  # e.g., :looking_for_long, :looking_for_short, etc.
	)

		# Base case: if we have 6 feet, save the parsing
		if length(current_feet) == 6
				# maybe make a foot of remaining_syllables and tack on?
		   push!(all_parsings, copy(current_feet))
		   return
		end

		# If no more syllables but we don't have 6 feet, return an invalid hexameter
		if isempty(remaining_syllables)
		   return
		end

		current_syllable = remaining_syllables[1]
		rest_syllables = remaining_syllables[2:end]

		if state == :looking_for_long
			# Try to start a foot with a long syllable
		   if current_syllable.quantity == "long" || can_be_long(current_syllable)
		       # Try a spondee (long-long) or dactyl (long-short-short)
		       try_spondee_or_dactyl(current_syllable, rest_syllables, current_feet, :looking_for_long)
		   elseif current_syllable.quantity == "short" || can_be_short(current_syllable)
		       # If it's short, it could be part of a dactyl (but only if we already have a long)
		       # This might require backtracking or adjusting the state
		       try_dactyl(current_syllable, rest_syllables, current_feet, :looking_for_short)
		   elseif current_syllable.quantity == "ambiguous"
		       # Branch into long and short possibilities
		       recursive_parse(remaining_syllables, current_feet, :looking_for_long)  # Try as long
		       recursive_parse(remaining_syllables, current_feet, :looking_for_short)  # Try as short
		   end # current_syllable.quantity
		elseif state == :looking_for_short
			# Looking for second or third syllable of a dactyl
		   if current_syllable.quantity == "short" || can_be_short(current_syllable)
		       # Continue building dactyl or finalize foot
		       try_dactyl(current_syllable, rest_syllables, current_feet, :looking_for_short)
		   elseif current_syllable.quantity == "ambiguous"
		       # Branch into short and long possibilities
		       recursive_parse(remaining_syllables, current_feet, :looking_for_short)  # Try as short
		       recursive_parse(remaining_syllables, current_feet, :looking_for_long)    # Try as long
		   end
		end # if - elseif state
	end # function recursive_parse()

	# Helper functions to handle specific cases
	function try_spondee_or_dactyl(first_syllable::AnnotatedSyllable, rest::Vector{AnnotatedSyllable}, feet::Vector{MetricalFoot}, state::Symbol)

		# Possible spondee
		if !isempty(rest) && (rest[1].quantity == "long" || can_be_long(rest[1]))
		  rule = determine_rule(rest[1])  # Function to determine the rule based on syllable properties
		  weight = get(METRICAL_WEIGHTS, rule, 1)  # Default weight of 1 if rule not in dictionary
		  # If we are rearranging syllables, do that with a function here.
		  new_feet = push!(copy(feet), MetricalFoot("spondee", [first_syllable, rest[1]], [rule], weight))
		  recursive_parse(rest[2:end], new_feet, :looking_for_long)
		end

		# Possible dactyl
		if length(rest) >= 2 && 
		 (rest[1].quantity == "short" || can_be_short(rest[1])) && 
		 (rest[2].quantity == "short" || can_be_short(rest[2]))
		  rule = determine_rule(rest[1], rest[2])  # Function to determine the rule
		  # If we are rearranging syllables, do that with a function here.
		  weight = get(METRICAL_WEIGHTS, rule, 1)
		  new_feet = push!(copy(feet), MetricalFoot("dactyl", [first_syllable, rest[1], rest[2]], [rule], weight))
		  recursive_parse(rest[3:end], new_feet, :looking_for_long)
		end

		# Possible trochee?

		# Error?

	end # function try_spondee_or_dactyl()

	function try_dactyl(syllable::AnnotatedSyllable, rest::Vector{AnnotatedSyllable}, feet::Vector{MetricalFoot}, state::Symbol)
	  # Logic to continue or complete a dactyl
	  # This would depend on the current state and remaining syllables
	  # (Implementation would need to track whether we’re building a dactyl or handling ambiguities)
	end  # function try_dactyl(

	function can_be_long(syllable::AnnotatedSyllable)::Bool
	  # Implement rules for when a syllable can be long (e.g., diphthongs, long vowels, synizesis)
	  # Check flags like "possible synizesis" or syllable properties
	  return syllable.quantity == "long" || (syllable.quantity == "ambiguous" && has_long_flag(syllable))
	end # function can_be_long()

	function can_be_short(syllable::AnnotatedSyllable)::Bool
	  # Implement rules for when a syllable can be short (e.g., correption, short vowels)
	  # Check flags like "possible correption" or syllable properties
	  return syllable.quantity == "short" || (syllable.quantity == "ambiguous" && has_short_flag(syllable))
	end # function can_be_short()

	# Start the recursion with the first syllable, looking for a long
	recursive_parse(syllables, Vector{MetricalFoot}(), :looking_for_long)
	return all_parsings

end # function parse_dactylic_hexameter()