function show(pf::MetricalFoot)::String
	sylstrings::Vector{String} = map(pf.syllables) do s
		show(s)
	end
	scanline::String = begin 
		scans::Vector{String} = map(sylstrings) do ss
			split(ss, "\n")[1]
		end
		join(scans, "   ")
	end
	sylline::String = begin
		syls::Vector{String} = map(sylstrings) do sl
			split(sl, "\n")[2]
		end
		join(syls, " - ")
	end
	seqline::String = begin
		len::Int = length(scanline)
		before::String = repeat(" ", (Int(floor(len/2)-1)))
		after::String = repeat(" ", (Int(floor(len/2))))
		if ( (len % 2) == 0 )
			before * string(pf.seq) * after
		else 
			after * string(pf.seq) * after
		end
	end
	(seqline * "\n" * scanline * "\n" * sylline)
end

function show(vpf::Vector{MetricalFoot})
	footstrings::Vector{String} = map(pfs -> show(pfs), vpf)
	v1::Vector{String} = map(footstrings) do fs 
		string(split(fs, "\n")[1])
	end
	line1::String = join(v1, "   ")
	v2::Vector{String} = map(footstrings) do fs 
		string(split(fs, "\n")[2])
	end
	line2::String = join(v2, " | ")
	v3::Vector{String} = map(footstrings) do fs 
		string(split(fs, "\n")[3])
	end
	line3::String = join(v3, "   ")
	join([line1, line2, line3], "\n")
end

"Pretty-print BasicSyllable; just join the charstring values of each in .chars"
function showsyllable(annsyll::AnnotatedSyllable)::String
	charstring = map(bsc -> bsc.charstring, annsyll.syllable.chars) |> join |> BetaReader.betaToUnicode
	caesura_after::Bool = "caesura_after" in annsyll.flags
	quantstring = _QUANTITIES[annsyll.quantity][2]
	paddedquant = begin
		if (isclosedsyllable(annsyll.syllable)) 
			repeat(" ", (length(charstring)- 2)) * quantstring * " "
		else 
			repeat(" ", (length(charstring)-1)) * quantstring
		end
	end
	caesurastring = begin
		if (caesura_after)
			" $(_QUANTITIES["caesura"][2]) "
		else
			""
		end
	end

	paddedquant * caesurastring * "\n" * charstring * caesurastring
end

function show(vas::Vector{AnnotatedSyllable})::String 

	allsylls::Vector{String} = map(as -> show(as), vas)
	splitsylls = map(vc -> split(vc, "\n"), allsylls)
	allquants = map( ss -> ss[1], splitsylls)
	alltext = map( ss -> ss[2], splitsylls)
	return (join(allquants, "   ") * "\n" * join(alltext, " - ") )



end

function show(as::AnnotatedSyllable)::String
	showsyllable(as)
end

"Pretty-print a Vector of BasicSyllables"
function showsyllable(vas::Vector{AnnotatedSyllable}, unicode = true)
	stringvec::Vector{String} = map(vas) do as
		showsyllable(as)
	end

	if (unicode)
		BetaReader.betaToUnicode(join(stringvec, " - "))
	else
		join(stringvec, " - ")
	end
end