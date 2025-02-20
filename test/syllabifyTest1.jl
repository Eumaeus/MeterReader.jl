@testset "syllabifytests1" begin


iliadLineStrings = """urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.1#Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2#οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3#πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.4#ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν"""

iliadLineNodes::Vector{CitablePassage} = begin
	iliadLines::Vector{String} = split(iliadLineStrings, "\n")
	iliadNodes::Vector{CitablePassage} = map(iliadLines) do il 
		MeterReader.citablePassage(il)
	end
end

iliadPoeticLines::Vector{PoeticLine} = begin
	plVec = map(iliadLineNodes) do iln 
		MeterReader.makePoeticLine(iln)
	end
end

# Test making some data
	
	@test begin
		length(split(iliadLineStrings, "\n")) == length(iliadNodes)
	end

	@test begin
		iliadPoeticLines[1].text == "Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος"
	end 

	@test begin
		iliadPoeticLines[1].chars[1].charstring == "M"
	end 

# Test showing and transforming data
	@test begin
		justchars = MeterReader.showChars(iliadPoeticLines[1].chars)
		# # println(justchars)
		justchars == "Mh=nin a)/eide qea\\ Phlhi+a/dew A)xilh=os"
	end

	@test begin
		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		synf.synapheia[1].charindex == synf.context[1].charindex
	end

	@test begin
		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		nthindex = 29 # "i"
		nthchar1 = filter(ct -> ct.charindex == 29, synf.synapheia)[1]
		nthchar2 = filter(ct -> ct.charindex == 29, synf.context)[1]
		nthchar1 == nthchar2
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[1].chars).synapheia
		# println(MeterReader.showChars(justchars))
		MeterReader.showChars(justchars) == "Mh=nina)/eideqea\\Phlhi+a/dewA)xilh=os"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[2].chars).synapheia
		# println(MeterReader.showChars(justchars))
		MeterReader.showChars(justchars) == "ou)lome/nhnh(\\muri/A)xaioi=sa)/lgee)/qhke"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[2].chars, true, true, true).synapheia
		ts = """ou)lome/nhn,h(\\muri/'A)xaioi=sa)/lge'e)/qhke,"""
		MeterReader.showChars(justchars) == ts
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[1].chars, false).synapheia
		# println(MeterReader.showChars(justchars))
		MeterReader.showChars(justchars) == "MhninaeideqeaPhlhi+adewAxilhos"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[1].chars, false, false).synapheia
		# println(MeterReader.showChars(justchars))
		MeterReader.showChars(justchars) == "MhninaeideqeaPhlhiadewAxilhos"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[2].chars, false).synapheia
		# println(MeterReader.showChars(justchars))
		MeterReader.showChars(justchars) == "oulomenhnhmuriAxaioisalgeeqhke"
	end

	@test begin
		cft = MeterReader.charsForToken(iliadPoeticLines[1], 3)
		# println(MeterReader.showChars(cft))
		MeterReader.showChars(cft) == "a)/eide"
	end

	@test begin
		cft = MeterReader.charsForToken(iliadPoeticLines[1], 1:3)
		# println(MeterReader.showChars(cft))
		MeterReader.showChars(cft) == "Mh=nin a)/eide"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[1].chars).synapheia
		cft = MeterReader.charsForToken(justchars, 3)
		# println(MeterReader.showChars(cft))
		MeterReader.showChars(cft) == "a)/eide"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[1].chars).synapheia
		cft = MeterReader.charsForToken(justchars, 1:3)
		# println(MeterReader.showChars(cft))
		MeterReader.showChars(cft) == "Mh=nina)/eide"
	end

	@test begin
		justchars = MeterReader.synapheia(iliadPoeticLines[1].chars).synapheia
		cft = MeterReader.charsForToken(justchars, 1:3)
		# println(MeterReader.showChars(cft))
		MeterReader.showChars(cft) == "Mh=nina)/eide"
	end

	# Test getting types of characters

	@test begin
		c = "a)/"
		MeterReader.containsvowel(c)
	end

	@test begin
		c = "a|)/"
		MeterReader.containsvowel(c)
	end

	@test begin
		c = "H"
		MeterReader.containsvowel(c)
	end

	@test begin
		c = "A)/|"
		MeterReader.containsvowel(c)
	end

	@test begin
		c = "a"
		MeterReader.containsvowel(c)
	end

	@test begin
		c = ")/"
		!(MeterReader.containsvowel(c))
	end

	@test begin
		c = "d"
		!(MeterReader.containsvowel(c))
	end

	@test begin
		c = "a)/eide"
		MeterReader.containsvowel(c)
	end

	@test begin
		c = "fq"
		!(MeterReader.containsvowel(c))
	end

	@test begin
		c = ["fq", "a)/", "e"]
		(MeterReader.containsvowel(c))
	end

	@test begin
		c = ["f", "A)/", "d"]
		(MeterReader.containsvowel(c))
	end

	@test begin
		c = ["fq", "d", "l"]
		!(MeterReader.containsvowel(c))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[1:2]
		cc::Vector{String} = map(ac) do c
			# println("charstring: $(c.charstring)")
			c.charstring
		end
		MeterReader.containsvowel(cc)
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[5:6]
		cc::Vector{String} = map(ac) do c
			c.charstring
		end
		MeterReader.containsvowel(cc)
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[3:4]
		cc::Vector{String} = map(ac) do c
			c.charstring
		end
		!(MeterReader.containsvowel(cc))
	end

	@test begin
		l = iliadPoeticLines[2]
		ac = l.chars[20:21] # Αχ
		cc::Vector{String} = map(ac) do c
			# println("-- charstring: $(c.charstring)")
			c.charstring
		end
		MeterReader.containsvowel(cc)
	end

	@test begin
		c = "a//"
		(MeterReader.isavowel(c))
	end

	@test begin
		c = "f"
		!(MeterReader.isavowel(c))
	end

	@test begin
		c = "ai)/"
		!(MeterReader.isavowel(c))
	end

	@test begin
		c = ["a", "d", "c"]
		(MeterReader.isavowel(c))
	end

	@test begin
		c = ["b", "d", "c"]
		!(MeterReader.isavowel(c))
	end

	@test begin
		c = ["a", "e", "c"]
		!(MeterReader.isavowel(c))
	end

	@test begin
		c = ["a)/", "d", "c"]
		(MeterReader.isavowel(c))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[2] # "o"
		(MeterReader.isavowel(ac))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[3] # "l"
		!(MeterReader.isavowel(ac))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[1:3] # "pol"
		(MeterReader.isavowel(ac))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[2] # "pol"
		(MeterReader.isavowel(ac))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[3:4] # "ll"
		!(MeterReader.isavowel(ac))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[2:5] # "olla"
		!(MeterReader.isavowel(ac))
	end

	@test begin
		c = "d"
		MeterReader.isaconsonant(c)
	end

	@test begin
		c = "a"
		!(MeterReader.isaconsonant(c))
	end

	@test begin
		c = "a\\"
		!(MeterReader.isaconsonant(c))
	end

	@test begin
		c = "v"
		MeterReader.isaconsonant(c)
	end

	@test begin
		c = "V"
		MeterReader.isaconsonant(c)
	end

	@test begin
		c = "v"
		!(MeterReader.isavowel(c))
	end

	@test begin
		c = "V"
		!(MeterReader.isavowel(c))
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[3] # "l"
		MeterReader.isaconsonant(ac)
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[2] # "o"
		!(MeterReader.isaconsonant(ac))
	end

	@test begin
		l = iliadPoeticLines[1]
		ac = l.chars[1] # "M"
		MeterReader.isaconsonant(ac)
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[5] # "a\\"
		!(MeterReader.isaconsonant(ac))
	end

	@test begin
		s = "ei"
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = "eio"
		!(MeterReader.isdiphthong(s))
	end

	@test begin
		s = "ie"
		!(MeterReader.isdiphthong(s))
	end

	@test begin
		s = "ai"
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = "ai)/"
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = "a)/i"
		!(MeterReader.isdiphthong(s))
	end

	@test begin
		s = ["a", "i"]
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = ["a", "i)/"]
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = ["a)/", "i"]
		MeterReader.isdiphthong(s) == false
	end

	@test begin
		s = ["h", "i"]
		MeterReader.isdiphthong(s) 
	end

	@test begin
		s = ["h", "i+"]
		MeterReader.isdiphthong(s) == false
	end

	@test begin
		s = ["h/", "i"]
		MeterReader.isdiphthong(s) == false
	end

	@test begin
		s = ["a", "i)/"]
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = ["W", "i"]
		MeterReader.isdiphthong(s)
	end

	@test begin
		s = ["O", "i"]
		MeterReader.isdiphthong(s)
	end

	@test begin
		l = iliadPoeticLines[2]
		vac = l.chars[1:2] # "ou)"
		MeterReader.isdiphthong(vac)
	end

	@test begin
		l = iliadPoeticLines[1]
		vac = l.chars[7:8] # "ae"
		MeterReader.isdiphthong(vac) == false
	end

	@test begin
		l = iliadPoeticLines[1]
		vac = l.chars[8:9] # "ei"
		MeterReader.isdiphthong(vac) == true
	end

	@test begin
		l = iliadPoeticLines[2]
		vac = l.chars[1:2] # "ou)"
		MeterReader.isdiphthong(vac)
	end

	@test begin
		l = iliadPoeticLines[2]
		ac1 = l.chars[23] # "i"
		ac2 = l.chars[24] # "o"
		MeterReader.isdiphthong(ac1, ac2) == false
	end

	@test begin
		l = iliadPoeticLines[2]
		ac1 = l.chars[1] # "o"
		ac2 = l.chars[2] # "u)"
		MeterReader.isdiphthong(ac1, ac2)
	end


	@test begin
		l = iliadPoeticLines[2]
		vac = l.chars[1:2] # "ou)"
		MeterReader.isdiphthong(vac)
	end

	@test begin
		s = "a"
		MeterReader.getchartype(s) == "vowel"
	end

	@test begin
		s = "a)/"
		MeterReader.getchartype(s) == "vowel"
	end

	@test begin
		s = "p"
		MeterReader.getchartype(s) == "consonant"
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[3] # "l"
		MeterReader.getchartype(ac) == "consonant"
	end

	@test begin
		l = iliadPoeticLines[3]
		ac = l.chars[5] # "a\\"
		MeterReader.getchartype(ac) == "vowel"
	end



end 

#= 

urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.1#Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2#οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3#πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.4#ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν

=#