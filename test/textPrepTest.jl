@testset "basictests" begin


	# Tests of split_and_retain
	
	@test begin
			 s = "Ἀτρεΐδης· ὃ γὰρ ἦλθε θοὰς ἐπὶ νῆας Ἀχαιῶν"
			 sar = MeterReader.split_and_retain(s, MeterReader.const_splitters)
			 length(sar) == 16
	end

	@test begin
			 s = "Ἀτρεΐδης· ὃ γὰρ ἦλθε θοὰς ἐπὶ νῆας Ἀχαιῶν"
			 sar = MeterReader.split_and_retain(s)
			 length(sar) == 16
	end

	@test begin
			 s = "Ἀτρεΐδης· ὃ γὰρ ἦλθε θοὰς ἐπὶ νῆας Ἀχαιῶν"
			 sar = split_and_retain(s)
			 length(sar) == 16
	end

	# Test of other general functions

	@test begin
			 a = ["a","b","c","d"]
			 ewi = eachwithindex(a)
			 ewi[2] == (2, "b")
	end

	@test begin
		MeterReader.typeToken("Ἀτρεΐδης") == "text"
	end

	@test begin
		MeterReader.typeToken(" ") == "separator"
	end

	@test begin
		MeterReader.typeToken("·") == "punctuation"
	end

	@test begin
		MeterReader.typeToken("\n") == "separator"
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.text == "οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
	end
	
	@test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.wordtokens[1].s == "οὐλομένην"
	end		

	@test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.wordtokens[2].type == "punctuation"
	end	

	@test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.wordtokens[6].s== "μυρί᾽"
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2"),
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.chars[38].charstring == "ε"
	end	

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2"),
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.chars[38].type == "text"
	end

	# Test for doubles
	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[20].charstring == "π"
	end

	# Test for doubles
	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[21].charstring == "ϲ"
	end


end 

#= 

urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.1#Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2#οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3#πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.4#ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν

=#