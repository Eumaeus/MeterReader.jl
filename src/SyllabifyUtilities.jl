
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

"Strip a beta-code string of diacriticals"
function stripdiacriticals(s::String)::String 
	replace(s, r"[()/\\=|?]" => "")
end

"Strip a the .charstring property of an AlignedChar of diacriticals"
function stripdiacriticals(ac::AlignedChar)::String 
	replace(ac.charstring, r"[()/\\=|?]" => "")
end

"Given a Vector{AlignedChar} return the .charstrings stripped of diacriticals"
function stripdiacriticals(vac::Vector{AlignedChar})::String 
	vs::String = map(vac) do ac
		ac.charstring
	end |> join
	replace(vs, r"[()/\\=|?]" => "")
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

"Does a beta-code string contain a diphthong? (Must be contiguous characters!)"
function containsdiphthong(s::String)::Bool
	lcs = lowercase(s)
	vowelsanddiacritics = filter(lcs) do c 
		!occursin(string(c), _ALLPUNCTUATION) &&
		!occursin(string(c), _SEPARATORS) &&
		!(string(c) in _CONSONANTS)
	end |> join

	# First see if there might be a diphthong, irrespective of diacriticals
	justvowels::String = MeterReader.stripdiacriticals(vowelsanddiacritics)
	# Get a vector of each pair of characters
	letterpairs::Vector{Vector{String}} = sliding([string(c) for c in justvowels], 2)
	# Is one a diphthong?
	possibledt = filter(letterpairs) do lp 
		isdiphthong(join(lp))
	end
	# If not, no diphthong
	if ( length(possibledt) == 0)
		return false
	else # maybe…
		certaindt = filter(possibledt) do dt 
			firsti::Int = [i for (i, c) in enumerate(s) if c == dt[1][1]][1]
			secondi::Int = [i for (i, c) in enumerate(s) if c == dt[2][1]][1]
			news::String = s[firsti:secondi]
			isdiphthong(news)
		end
		length(certaindt) > 0
	end

end

"Does a vector of beta-code strings contain a diphthong? (Must be contiguous characters!"
function containsdiphthong(vs::Vector{String})::Bool
	false
end

"Does a vector of AlignedChar objects contain a diphthong?"
function containsdiphthong(vac::Vector{AlignedChar})::Bool
	false
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


"Is a beta-code string-representation of a character a long-vowel, short-vowel, ambiguous-vowel, or none?"
function vowelquantity(s::String)::String
	basestring = filter(stripdiacriticals(s)) do sd
		lowercase(string(sd)) in _VOWELS # remember when you filter a string, you are working with characters!
	end |> lowercase
	if (isavowel(s) == false) 
		"error"
	else
		if (basestring in _LONG_VOWELS) "long"	
		elseif (basestring in _SHORT_VOWELS) "short"
		elseif (basestring in _AMBIGUOUS_VOWELS)
			# If there is only one vowel (not a diphthong), and our edition has a circumflex, it must be long	
			if (contains(s, "=")) "long"
			else "ambiguous"
			end

		else "error"
		end
	end
end

"Is a an AlignedChar a long-vowel, short-vowel, ambiguous-vowel, or none?"
function vowelquantity(ac::AlignedChar)::String
	s::String = ac.charstring
	vowelquantity(s)
end

"Is a Vector{AlignedChar} a long-vowel, short-vowel, ambiguous-vowel, or none?"
function vowelquantity(vac::Vector{AlignedChar})::String
	s::String = map(vac) do ac
		ac.charstring
	end |> join
	vowelquantity(s)
end

"Does a beta-code string representation of a syllable have a circumflex?"
function containscircumflex(s::String)
	occursin("=", s)
end

"Does an AlignedChar have a circumflex?"
function containscircumflex(ac::AlignedChar)
	containscircumflex(ac.charstring)
end

"Does a Vector{AlignedChar} have a circumflex?"
function containscircumflex(vac::Vector{AlignedChar})
	cc::String = map(ac -> ac.charstring, vac) |> join
	containscircumflex(cc)
end

"Does a BasicSyllable have a circumflex?"
function containscircumflex(bs::BasicSyllable)
	cc::Vector{AlignedChar} = bs.chars
	containscircumflex(cc)
end


"Is a beta-code string representation of a syllable 'closed'?"
function isclosedsyllable(s::String)::Bool
	lc::String = last(s) |> string |> lowercase
	isaconsonant(lc)
end

"Does a Vector{AlignedChar} represent a 'closed' syllable?"
function isclosedsyllable(vac::Vector{AlignedChar})::Bool
	lc::String = last(vac).charstring |> lowercase
	isaconsonant(lc)
end

"Does a BasicSyllable represent a 'closed' syllable?"
function isclosedsyllable(bs::BasicSyllable)::Bool
	vac::Vector{AlignedChar} = bs.chars
	lc::String = last(vac).charstring |> lowercase
	isaconsonant(lc)
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

"Is a beta-code string-representation of TWO (and only two) characters a possibly a diphthong?"
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
		( (isavowel(lowercase(string(c)))) || (isaconsonant(lowercase(string(c)))) )
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

"Is a pair of AlignedCharacters possibly a diphthong?"
function isdiphthong(ac1::AlignedChar, ac2::AlignedChar)
	isdiphthong([ac1, ac2])
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

"Does a BasicSyllable begin with a vowel?"
function beginswithvowel(bs::BasicSyllable)
		bs.chars[1] |> isavowel
end

"Safety."
function beginswithvowel(n::Nothing)
		false
end


"Is a character a 'colon', a punctuation mark that defines a phrase or clause?"
function iscolon(ac::AlignedChar)::Bool
	ac.type == "colon"
end

"Is there a word-break after this syllable?"
function wordbreakafter(bs::BasicSyllable)::Bool
	lastindex = last(bs.chars).charindex
	nextindex = begin 
		if (lastindex == length(bs.context))
			lastindex
		else
			lastindex + 1
		end
	end

	# If the last char of this syllable has `.terminator == true`… true
	if (last(bs.chars).terminator == true) true
	# If this syllable is the last of the line… true
	elseif ( last(bs.chars).charindex == length(bs.context) ) true
	# If the first char of the _next_ syllable has `.terminator == true`… true
	elseif ( bs.context[nextindex].terminator == true ) true
	# Else false
	else false end

end

"Does a BasicSyllable end with a colon punctuation (period, comma, etc?)"
function endswithcolon(bs::BasicSyllable)::Bool
	lastindex = last(bs.chars).charindex
	#Three possibilities…
	# 1. There is punctuation right after the last char of the syllable.
	next1index = begin
		if ( (lastindex + 1) > length(bs.context) )
			lastindex
		else (lastindex + 1)
		end
	end
	# 2. The next syllable begins with a consonant, with punctuation after that. This is a function of how we initially syllabify "closed" syllables
	next2index = begin
		if ( (lastindex + 2) > length(bs.context) )
			next1index
		else (lastindex + 2)
		end
	end

	nextchar = bs.context[next1index]
	next2char = bs.context[next2index]

	( (iscolon(nextchar)) || (iscolon(next2char)) )

end