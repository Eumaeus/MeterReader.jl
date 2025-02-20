@testset "textprepests" begin

	# Misc. Tests


	@test begin
		s = "ἄλγε᾽"
		bc = BetaReader.unicodeToBeta(s)
		bc == "a)/lge'"
	end

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
		MeterReader.typeToken("'") == "punctuation"
	end

	@test begin
		MeterReader.typeToken("·") == "colon"
	end

	@test begin
		MeterReader.typeToken(",") == "colon"
	end

	@test begin
		MeterReader.typeToken(";") == "colon"
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
		pl.wordtokens[2].type == "colon"
	end	

   @test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.wordtokens[3].type == "separator"
	end	

   @test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.wordtokens[7].type == "punctuation"
	end	

	@test begin
		pl = MeterReader.makePoeticLine(
			"urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2",
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.wordtokens[6].s== "μυρί"
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2"),
			"οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
		)
		pl.chars[38].charstring == "e"
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
		pl.chars[20].charstring == "p"
	end

	# Test for doubles
	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[21].charstring == "s"
	end

# Test for terminators
	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[6].terminator == true
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[25].terminator == true
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[2].terminator == false
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3"),
			"πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν,"
		)
		pl.chars[8].terminator == true
	end

	# Test for iota-subscrdipts
	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.15"),
			"χρυσέῳ ἀνὰ σκήπτρῳ, καὶ λίσσετο πάντας Ἀχαιούς,"
		)
		pl.chars[7].charstring == "i"
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.15"),
			"χρυσέῳ ἀνὰ σκήπτρῳ, καὶ λίσσετο πάντας Ἀχαιούς,"
		)
		pl.chars[6].charstring == "w"
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.15"),
			"χρυσέῳ ἀνὰ σκήπτρῳ, καὶ λίσσετο πάντας Ἀχαιούς,"
		)
		pl.chars[7].terminator == true
	end

	@test begin
		pl = MeterReader.makePoeticLine(
			CitableText.CtsUrn("urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.15"),
			"χρυσέῳ ἀνὰ σκήπτρῳ, καὶ λίσσετο πάντας Ἀχαιούς,"
		)
		#print(pl)
		pl.chars[6].terminator == false
	end

end 

#= 

urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.1#Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2#οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3#πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.4#ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν

=#