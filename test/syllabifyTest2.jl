@testset "syllabifytests2" begin

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

	# Test as we build…
	
	@test begin
		println("testing syllabifytests2")
		true
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		synf.synapheia[1].charindex == synf.context[1].charindex
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[2].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[3].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[4].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

end