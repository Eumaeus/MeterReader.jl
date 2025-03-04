
"Syllabify a line. Assumes separators, punctuation, and cola are removed (see `synapheia()`. Accepts a Tuple of Vectors of AlignedChars, each element including `charstring`, a beta-code representation of a characters and any diacriticals. Returns a Vector{BasicSyllable}"
function syllabify4poetry(snf::Synapheia)::Vector{BasicSyllable}
	ss::Vector{AlignedChar} = snf.synapheia

	mysylls::Vector{Vector{AlignedChar}} = []
	prevchartype = ""

	for ac in eachindex(ss) 

		# Get the previous character before starting
		lastchar = begin
			if (ac > 1) ss[ac-1]
			else ""
			end
		end

		# We'll look ahead two characters…
		next1char = begin
			if (ac+1 > length(ss)) ""
			else ss[ac+1]
			end
		end
		next2char = begin
			if (ac+2 > length(ss)) ""
			else ss[ac+2]
			end
		end

		if isempty(mysylls) # first AlignedChar of the line
			# Remember, we are pushing Vectors into a Vector! So… [ss[ac]]
			# Start a new syllable by pushing the current AlignedChar as a single-element Vector onto the end of `myslls`.
			push!(mysylls, [ss[ac]]) 
			prevchartype = getchartype(ss[ac]) # go ahead and update this!
		else # syllabification is under way
			if (isaconsonant(ss[ac])) #consonant?

				# end of line; add to last (close the previous syllable)
				if (ac == length(ss)) 	
					#println("1. $prevchartype -- $(ss[ac]) -- $next1char ($(getchartype(next1char))) ")
					tempsylvec = last(mysylls) # get the syllable-in-progress
					newsylvec = push!(tempsylvec, ss[ac]) # add the current AlignedChar to it
					pop!(mysylls) # remove the current, not-updated syllable-in-progress
					push!(mysylls, newsylvec) # replace it with the updated one.
					prevchartype = getchartype(ss[ac]) # always update this!
				# double-consonant; add to last (close the previous syllable)
				elseif ( (prevchartype == "vowel") && ( isaconsonant(next1char) )) 
					#println("2. $prevchartype -- $(ss[ac]) -- $next1char ($(getchartype(next1char))) ")
					tempsylvec = last(mysylls)
					newsylvec = push!(tempsylvec, ss[ac])
					pop!(mysylls)
					push!(mysylls, newsylvec)
					prevchartype = getchartype(ss[ac])
				# one consonant before a vowel; start a new syllable
				elseif ( (prevchartype == "vowel") && ( isavowel(next1char) ) ) 
					#println("3. $prevchartype -- $(ss[ac]) -- $next1char ($(getchartype(next1char))) ")
					push!(mysylls, [ss[ac]]) # start a new syllable
					prevchartype = getchartype(ss[ac]) # go ahead and update this!

				# 3rd in a consonant cluster; add to last
				elseif  ( (prevchartype == "consonant") && ( length(last(mysylls)) == 1 ) ) # add to last
					#println("4. $prevchartype -- $(ss[ac]) -- $next1char ($(getchartype(next1char))) ")
					tempsylvec = last(mysylls)
					newsylvec = push!(tempsylvec, ss[ac])
					pop!(mysylls)
					push!(mysylls, newsylvec)
					prevchartype = getchartype(ss[ac])

				# consonant after closed syllable; start new syllable 
				elseif  ( (prevchartype == "consonant") && ( isavowel(next1char) ) ) 
					#println("5. $prevchartype -- $(ss[ac]) -- $next1char ($(getchartype(next1char))) ")
					push!(mysylls, [ss[ac]]) # start a new syllable
					prevchartype = getchartype(ss[ac]) # go ahead and update this!

				# 2nd consonant in cluster of 3+; start a new syllable; anything else
				else 
					#println("6. $prevchartype -- $(ss[ac]) -- $next1char ($(getchartype(next1char))) ")	
					push!(mysylls, [ss[ac]]) # start a new syllable
					prevchartype = getchartype(ss[ac]) # go ahead and update this!

				end # end 'if' (ac == length(ss)) 	

			else # got a vowel!
				if ( prevchartype == "vowel" ) # gotta check for a diphthong
					if (isdiphthong(last(last(mysylls)), ss[ac])) # diphthong, add to previous syllable
						tempsylvec = last(mysylls)
						newsylvec = push!(tempsylvec, ss[ac])
						pop!(mysylls)
						push!(mysylls, newsylvec)
						prevchartype = getchartype(ss[ac])

					else # not diphthong; new syllable
						push!(mysylls, [ss[ac]]) # start a new syllable
						prevchartype = getchartype(ss[ac]) # go ahead and update this!

					end # if (isdiphthong(last(mysylls), ss[ac]))

				else # Not dealing with a diphthong

					if (containsvowel(last(mysylls))) 
						push!(mysylls, [ss[ac]]) # start a new syllable
						prevchartype = getchartype(ss[ac]) # go ahead and update this!
					else # add to previous
						tempsylvec = last(mysylls)
						newsylvec = push!(tempsylvec, ss[ac])
						pop!(mysylls)
						push!(mysylls, newsylvec)
						prevchartype = getchartype(ss[ac])

					end # (containsvowel(last(mysylls)))

				end # if ( prevchartype == "vowel" )

			end # isaconsonant 'if'
		end # big 'if' starting with isempty(mysylls)

	end # big for-loop


	returnsylls = map(mysylls) do ms 
		makesyll(ms, snf)
	end

	return returnsylls
end

"Refactored this out… create a BasicSyllable"
function makesyll(vac::Vector{AlignedChar}, snf::Synapheia )
	BasicSyllable(vac, snf.synapheia, snf.context)
end

"Given a Vector{BasicSyllable} and an index, evaluate the syllable and return an AnnotatedSyllable"
function evaluate(vbs::Vector{BasicSyllable}, index::Int)::AnnotatedSyllable
	# BasicSyllable -> .chars::Vector{AnnotatedChar}
	thissyll::BasicSyllable = vbs[index] 
	cc::Vector{AlignedChar} = thissyll.chars
	flags::Vector{String} = []
	rules::Vector{String} = []
	nextsyll::Union{BasicSyllable, Nothing} = begin
		if (index == length(vbs)) nothing
		else (vbs[index+1])
		end
	end

	# Is it followed by a colon? If so, flag that.
	if (endswithcolon(thissyll)) push!(flags, "colon_after") end
	# Is it followed by a word-break? If so, flag that.
	if (wordbreakafter(thissyll)) push!(flags, "wordbreak_after") end

	quantity::String = begin
		# Is it obviously short and un-closed? Mark short
		if ( (vowelquantity(cc) == "short") && (isclosedsyllable(cc) == false) ) 
			push!(rules, "short_vowel")
			# Is it followed by a vowel or diphthong? If so flag for possible synizesis
			if ( beginswithvowel(nextsyll) )
				push!(flags, "possible_ellision")
				push!(flags, "possible_synizesis")
			end

			"short"

		# Is is inherently long?
		elseif ( vowelquantity(cc) == "long" )
			push!(rules, "long_vowel")
			# Is it un-closed and followed by a vowel? If so, flag for correption and synizesis
			if ( (isclosedsyllable(cc) == false) && ( beginswithvowel(nextsyll)) )
				push!(flags, "possible_synizesis")
				push!(flags, "possible_correption")
				push!(rules, "closed_syllable")
			end

			"long"

		# Is it a diphthong? Mark long but flag for possible hiatus
		elseif ( isdiphthong(cc) )
			push!(rules, "diphthong")
			# Is it un-closed and followed by a vowel? If so, flag for correption and synizesis
			if ( (isclosedsyllable(cc) == false) && ( beginswithvowel(nextsyll)) )
				push!(flags, "possible_synizesis")
				push!(flags, "possible_correption")
			end			
			if ( containscircumflex(cc) == false )
				push!(flags, "possible_hiatus")
			else
				push!(rules,"circumflex_on_diphthong")
			end

			"long"

		# Is it closed? Mark long.
		elseif ( isclosedsyllable(cc) )

			"long"

		elseif ( (vowelquantity(cc) == "ambiguous") && (isclosedsyllable(cc) == false) )
			if ( beginswithvowel(nextsyll) )
				push!(flags, "possible_ellision")
				push!(flags, "possible_synizesis")
			end

			if ( containscircumflex(cc) )
				push!(rules, "circumflex")
				"long"
			else
				"ambiguous"
			end

		else
			"error"

		end # big "if"

	end # quantity assignment
	as = AnnotatedSyllable( thissyll, quantity, flags, rules)
	return as

end


