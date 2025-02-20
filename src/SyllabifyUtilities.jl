
"Return a copy of a Vector{AlignedChar} for syllabification. The first Bool param determines whether accents and breathings are preserved or not; the second determines whether the diaeresis is preserved; the third determines whether punctuation is preserved."
function synapheia(charvec::Vector{AlignedChar}, diacriticals = true, diaeresis = true, punctuation = false)::Synapheia

	justchars = begin
		if (punctuation == false)
			filter(charvec) do cv 
				cv.type == "text"
			end
		else
			filter(charvec) do cv 
				cv.type != "separator"
			end
		end
	end

	returnchars = begin
		if (diacriticals == false)
			newchars = []
			for i in eachindex(justchars)
				newcharstring = begin 
					if (diaeresis)
						replace(justchars[i].charstring, r"[()/\\=|?]" => "")
					else
						replace(justchars[i].charstring, r"[()/\\=|?+]" => "")
					end
				end
				push!(newchars, AlignedChar(
					newcharstring,
					justchars[i].tokenindex,
					justchars[i].type,
					justchars[i].terminator
				))
			end
			newchars
		else
			justchars
		end
	end

	Synapheia(returnchars, charvec)

end

"Given a Vector{AlignedChar}, return a String of just the characters."
function showChars(charvec::Vector{AlignedChar})::String
		justchars = map(charvec) do cv 
			cv.charstring
		end |> join
end

"Given a single AlignedChar, return a String of just the characters."
function showChars(char::AlignedChar)::String
		showChars([char])
end

"Does a beta-code string contain a vowel?"
function containsvowel(s::String)::Bool
	fs = filter(s) do c 
		lowercase(string(c)) in _VOWELS
	end
	length(fs) > 0
end

"Does a vector of beta-code strings contain a vowel?"
function containsvowel(vs::Vector{String})::Bool
	fs = filter(vs) do c 
		containsvowel(c)
	end
	length(fs) > 0
end

"Does a an AlignedChar object contain a vowel?"
function containsvowel(ac::AlignedChar)::Bool
	containsvowel(ac.charstring)
end


"Does a vector of AlignedChar objects contain a vowel?"
function containsvowel(vac::Vector{AlignedChar})::Bool
	fs = filter(vac) do c 
		containsvowel(c.charstring)
	end
	length(fs) > 0
end


"Is a beta-code string-representation of a character a vowel (and only one vowel)?"
function isavowel(s::String)::Bool
	fs = filter(s) do c 
		containsvowel(string(c))
	end
	length(fs) == 1
end

"In a Vector of beta-code string-representations is there one and only one vowel?"
function isavowel(vs::Vector{String})::Bool
	fs = filter(vs) do c 
		containsvowel(c)
	end
	length(fs) == 1
end

"Is an AlignedChar object  one and only one vowel?"
function isavowel(ac::AlignedChar)::Bool
	fs = filter(ac.charstring) do c 
		containsvowel(string(c))
	end
	length(fs) == 1
end

"In a Vector of AlignedChar objects is there one and only one vowel?"
function isavowel(vac::Vector{AlignedChar})::Bool
	fs = filter(vac) do c 
		containsvowel(c.charstring)
	end
	length(fs) == 1
end

"Is a beta-code string-representation of a character a consonent?"
function isaconsonant(s::String)::Bool
	fs = filter(s) do c 
		lowercase(string(c)) in _CONSONANTS
	end
	length(fs) > 0
end

"Is a beta-code string-representation of a character a consonent?"
function isaconsonant(ac::AlignedChar)::Bool
	isaconsonant(ac.charstring)	
end

"Is a beta-code string-representation of two characters a possibly a diphthong?"
function isdiphthong(s::String)::Bool
	dp = lowercase(s)
	# diacriticals on first vowel mean no diphthong
	if ( match(r"([a-z])[)/\\=]+([a-z])", dp) != nothing ) 
		return false
	else 
		sdp = replace(dp, r"[)(/\\=)]" => "")
		if ( contains(sdp, "+") ) #diaeresis means no diphthong
			return false 	
		else
			return sdp in _DIPHTHONGS
		end
	end	
end

"Is a Vector of beta-code string-representations of two characters a possibly a diphthong?"
function isdiphthong(vs::Vector{String})::Bool
	fs = filter(vs) do c
		isavowel(lowercase(string(c)))
	end
	dp = join(fs) |> lowercase
	isdiphthong(dp)
end

"Is a Vector of AlignedChar objects a possibly a diphthong?"
function isdiphthong(vac::Vector{AlignedChar})::Bool
	vs = map(vac) do ac 
		ac.charstring
	end
	isdiphthong(vs)
end

"Is a beta-code representation of a character a vowel or consonant?"
function getchartype(s::String)
	if isavowel(s) "vowel"
	elseif isaconsonant(s) "consonant"
	else "other"
	end
end

"Is an AlignedChar a vowel or consonant?"
function getchartype(ac::AlignedChar)
	if isavowel(ac) "vowel"
	elseif isaconsonant(ac) "consonant"
	else "other"
	end
end
