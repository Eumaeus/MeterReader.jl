function sayhi()

		println("Hi, from MeterReader!")
		"Hi"

end 

#= *******************
			Structures
   ******************* =#

"For the `wordtokens` property of a PoeticLine"
struct IndexedString
	i::Int64
	s::String
	type::String # types: text, separator, punctuation
end

"For the `chars` property of a PoeticLine"
struct AlignedChar
	charstring::String # in BetaCode
	tokenindex::Int
	type::String # types: text, separator, punctuation
	terminator::Bool # is this the last char in a word-token?
	charindex::Int # when we filter a Vector{AlignedChar}, we can still navigate the unfiltered Vector.
end

"Create an AlignedChar when we don't (yet) know its indexing."
function AlignedChar(charstring::String, tokenindex::Int, type::String, terminator::Bool)
	AlignedChar(charstring, tokenindex, type, terminator, 0)
end

"The basic unit we are analyzing."
struct PoeticLine
   urn::CtsUrn
	text::String
	wordtokens::Vector{IndexedString}
	chars::Vector{AlignedChar}
end

"The basis for a `syllable`, a Vector of Aligned Chars, with their context attached in the form of the `synapheia()` that created them. An intermediate structure."
struct BasicSyllable
	chars::Vector{AlignedChar} # The AlignedChars that form the syllable
	synapheia::Vector{AlignedChar} # The Vector from which the syllable was created
	context::Vector{AlignedChar} # The whole Vector, the context for the synapheia
end

#= ******************* 
	Constructors
   ******************* =#

"Given a CEX fragment, with urn and text and a '#' delimiter, return a textNode"
function citablePassage(s::String)::CitablePassage
	urnString = split(s, "#")[1]
	text = split(s, "#")[2]
	urn::CtsUrn = CtsUrn(urnString)
	CitablePassage(urn, text)
end

"Given a Vector of IndexedString, return a vector of AlignedChar objects, aligned to each IndexedString"
function alignChars(vis::Vector{IndexedString})::Vector{AlignedChar}
	# Get characters for each indexed token
	#		treat sigmas, probably unneccesary
	#		Assign token-index and type 
	vvac::Vector{Vector{AlignedChar}} = map(vis) do tok

		tokchars::Vector{AlignedChar} = map( eachindex(collect(tok.s))) do c 
			charString = string(collect(tok.s)[c]) |> unicodeToBeta
			if (c == length(collect(tok.s)))
				 AlignedChar(charString, tok.i, tok.type, true)
			else
				 AlignedChar(charString, tok.i, tok.type, false)
			end
		end

	end

	# Flatten
	vac::Vector{AlignedChar} = vcat(vvac...)
	# Beta-code, then…
	# Treat double-consonants and iota-subscripts
	newVec = [] 
	for i in eachindex(vac)
		charString = vac[i].charstring
		# Catch double-chars and deal with them…
		if (contains( "zcy", charString))
			if (vac[i].charstring == "c")
				cc = AlignedChar( "k", vac[i].tokenindex, vac[i].type, false )
				push!(newVec, cc)
				cc = AlignedChar( "s", vac[i].tokenindex, vac[i].type, vac[i].terminator )
				push!(newVec, cc)
			elseif (vac[i].charstring == "z")
				cc = AlignedChar( "s", vac[i].tokenindex, vac[i].type, false )
				push!(newVec, cc)
				cc = AlignedChar( "d", vac[i].tokenindex, vac[i].type, vac[i].terminator )
				push!(newVec, cc)
			elseif (vac[i].charstring == "y")
				cc = AlignedChar( "p", vac[i].tokenindex, vac[i].type, false )
				push!(newVec, cc)
				cc = AlignedChar( "s", vac[i].tokenindex, vac[i].type, vac[i].terminator )
				push!(newVec, cc)
			end
		# Iota-subscripts to adscripts
		elseif ( contains( charString, "|" ) )
			removeIota = replace(charString, "|" => "")
			newUC = removeIota
			cc = AlignedChar( newUC, vac[i].tokenindex, vac[i].type, false )
			push!(newVec, cc)
			cc = AlignedChar( "i", vac[i].tokenindex, vac[i].type, vac[i].terminator )
			push!(newVec, cc)
		else
			cc = AlignedChar( charString, vac[i].tokenindex, vac[i].type, vac[i].terminator )
			push!(newVec, cc)
		end
	end

	## re-index newVec
	indexedVec = []
	for i in eachindex(newVec)
			cc = AlignedChar( newVec[i].charstring, newVec[i].tokenindex, newVec[i].type, newVec[i].terminator, i )
			push!(indexedVec, cc)
	end

	return indexedVec

end

"Given a CITE CitablePassage, return a PoeticLine"
function makePoeticLine(citablePassage::CitablePassage)
	makePoeticLine(citablePassage.urn, string(citablePassage.text))
end

"Given a CITE CitablePassage's parts, URN and Text, return a PoeticLine"
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

"Create a PoeticLine from a string-represention of a CTS-URN and a String"
function makePoeticLine(urnstring::String, text::String)
	u = CtsUrn(urnstring)
	makePoeticLine(u, text)
end

" Given a String, categorize it as 'punctuation', 'separator', 'colon', or 'text'. 'colon' is any punctuation that marks a break in syntax or pause in the poetic line. This depends on constants defined in Constants.jl"
function typeToken(s::String)::String 
	
	seps = """ \n\t"""
	firstChar = string(s[1])
	category = begin
		if (contains(_MISCPUNCTUATION, firstChar))
			"punctuation"
		elseif (contains(_SEPARATORS, firstChar))
			"separator"
		elseif (contains(_COLONPUNCTUATION,firstChar))
			"colon"
		else
			"text"
		end 
 	end
end

#= ******************* 
	Functions
   ******************* =#


"Given a PoeticLine and a token-index, return a Vector{AlignedChar} of the charcters associated with that token."
function charsForToken(poeticline::PoeticLine, token::Int64)::Vector{AlignedChar}

	returnVec::Vector{AlignedChar} = filter(poeticline.chars) do c 
		c.tokenindex == token
	end
end

"Given a PoeticLine and a range of token-indices, return a Vector{AlignedChar} of the charcters associated with that range of token."
function charsForToken(poeticline::PoeticLine, tokens::UnitRange{Int64})::Vector{AlignedChar}

	returnVec::Vector{AlignedChar} = filter(poeticline.chars) do c 
		c.tokenindex in tokens
	end
end

"Given a Vector{AlignedChar} and a token-index, return a Vector{AlignedChar} of the charcters associated with that token."
function charsForToken(chars::Vector{AlignedChar}, token::Int64)::Vector{AlignedChar}

	returnVec::Vector{AlignedChar} = filter(chars) do c 
		c.tokenindex == token
	end
end

"Given a Vector{AlignedChar} and a range of token-indices, return a Vector{AlignedChar} of the charcters associated with that range of token."
function charsForToken(chars::Vector{AlignedChar}, tokens::UnitRange{Int64})::Vector{AlignedChar}

	returnVec::Vector{AlignedChar} = filter(chars) do c 
		c.tokenindex in tokens
	end
end

#"Given a PoeticLine, return version containing only text-tokens "
#function justWords(poeticline::PoeticLine)::PoeticLine
#	
#end

