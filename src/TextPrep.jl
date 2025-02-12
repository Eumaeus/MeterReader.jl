function sayhi()

		println("Hi, from MeterReader!")
		"Hi"

end 

#=
			Structures
=#

struct IndexedString
	i::Int64
	s::String
	type::String # types: text, separator, punctuation
end

struct AlignedChar
	charstring::String
	charindex::Int
	tokenindex::Int
	type::String # types: text, separator, punctuation
end

struct PoeticLine
   urn::CtsUrn
	text::String
	wordtokens::Vector{IndexedString}
	chars::Vector{AlignedChar}
end

function alignChars(vis::Vector{IndexedString})
	# Get characters for each indexed token
	#		lower-case and swap all sigmas for lunate forms
	#		Assign token-index and type 
	vvac::Vector{Vector{AlignedChar}} = map(vis) do tok
		newTokString = replace(tok.s, r"[σς]" => "ϲ") |> lowercase
		tokchars::Vector{AlignedChar} = map(collect(newTokString)) do c
			AlignedChar(string(c), 0, tok.i, tok.type)
		end
	end
	# Flatten
	vac::Vector{AlignedChar} = vcat(vvac...)
	# Re-index sequentially, catching double-consonants
	newVec = [] 
	for i in eachindex(vac)
		# Catch double-chars and deal with them…
		if (contains( "ζξψ", vac[i].charstring))
			if (vac[i].charstring == "ξ")
				cc = AlignedChar( "κ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
				cc = AlignedChar( "ϲ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
			elseif (vac[i].charstring == "ζ")
				cc = AlignedChar( "ϲ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
				cc = AlignedChar( "δ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
			elseif (vac[i].charstring == "ψ")
				cc = AlignedChar( "π", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
				cc = AlignedChar( "ϲ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
			end
		else
			cc = AlignedChar( vac[i].charstring, i, vac[i].tokenindex, vac[i].type )
			push!(newVec, cc)
		end
	end

	return newVec

end

function makePoeticLine(urn::CtsUrn, text::String)
	tokenized = split_and_retain(text)
	wtoks::Vector{IndexedString} = begin
		ewi = eachwithindex(tokenized)
		map(ewi) do e
			IndexedString(e[1], e[2], typeToken(e[2]))
		end
	end
	chars = alignChars(wtoks)
	PoeticLine(urn, text, wtoks, chars)
end

function makePoeticLine(urnstring::String, text::String)
	u = CtsUrn(urnstring)
	makePoeticLine(u, text)
end



function typeToken(s::String)::String 
	puncs = """()[]{}·⸁.,;"?·!–—⸂⸃"""
	seps = """ \n\t"""
	firstChar = string(s[1])
	category = begin
		if (contains(puncs, firstChar))
			"punctuation"
		elseif (contains(seps,firstChar))
			"separator"
		else
			"text"
		end 
 	end
end

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
const_splitters = """\n\t(){}[]·⸁.,; "?·!–—⸂⸃"""

" Escape a string, for splitting"
function escape_string(c::String)::String
    # Escape special regex characters
    return occursin(r"[\^$.|?*+(){}[\]\\]", c) ? "\\" * c : c
end

" Split string, retaining the characters on which you split"
function split_and_retain(my_text::String, split_characters::String = """\n()[]·⸁.,; "?·!–—⸂⸃""")::Vector{String}

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


