#=
			Functions
=#

# Implemenent eachwithindex(v::Vector[Any]) like in Scala

function eachwithindex(v::Vector)::Vector{Tuple{Int64, Any}}
    map(eachindex(v)) do i 
        (i, v[i])
    end
end

# Big one: split_and_retain 

" All-purpose list of punctuation "
const_splitters = """\n\t(){}[]᾽'·⸁.,; "?·!–—⸂⸃"""

" Escape a string, for splitting"
function escape_string(c::String)::String
    # Escape special regex characters
    return occursin(r"[\^$.|?*+(){}[\]\\]", c) ? "\\" * c : c
end

" Split string, retaining the characters on which you split"
function split_and_retain(my_text::String, split_characters::String = """\n()[]·⸁.᾽',; "?·!–—⸂⸃""")::Vector{String}

	# Escape each character in split_characters to handle special regex characters
    escaped_splitters = join([escape_string(string(c)) for c in split_characters], "")
	# Turn my_text into an array of Char
	my_text_chars = collect(my_text)
    
	   
    # Initialize result and tracking index
    result = String[]
    last_index = 1
    
    # Iterate through each match of the split_regex
    for c in eachindex(my_text_chars)
		if ( contains(escaped_splitters, my_text_chars[c] ) )
			# get previous chunk
			prevchunk = join(my_text_chars[last_index:c-1])
			if (length(prevchunk) > 0)
				push!(result, prevchunk)
			end
			# add splitter
			push!(result, string(my_text_chars[c]))
			# update lastindex
			last_index = c + 1
		end		
	end
	
	# Add any remaining text after the last match
    if last_index <= length(my_text_chars)
        push!(result, join( my_text_chars[last_index:end]) )
    end
	
	result

end


