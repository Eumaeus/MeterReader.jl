@testset "ParseTests" begin

	iliadLineStrings = """urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.1#Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2#οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.3#πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.4#ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.5#οἰωνοῖσί τε πᾶσι, Διὸς δ᾽ ἐτελείετο βουλή,
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.6#ἐξ οὗ δὴ τὰ πρῶτα διαστήτην ἐρίσαντε
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.7#Ἀτρεΐδης τε ἄναξ ἀνδρῶν καὶ δῖος Ἀχιλλεύς.
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.8#Τίς τάρ σφωε θεῶν ἔριδι ξυνέηκε μάχεσθαι;
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.9#Λητοῦς καὶ Διὸς υἱός· ὃ γὰρ βασιλῆϊ χολωθεὶς
urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.10#νοῦσον ἀνὰ στρατὸν ὄρσε κακήν, ὀλέκοντο δὲ λαοί,"""

	testsylls = [
		"Μῆ - νι - νἄ - ει - δε - θε - ὰ - Πη - λη - ϊ - ά - δε - ω - Ἀ - χι - λῆ - ος",
		"οὐ - λο - μέ - νη - νἣ - μυ - ρί - Ἀ - χαι - οῖ - ςἄλ - γε - ἔ - θη - κε",
		"πολ - λὰς - δἰφ - θί - μους - πςυ - χὰ - ςἌ - ϊ - διπ - ρο - ΐ - απ - σεν",
		"ἡ - ρώ - ω - ναὐ - τοὺς - δὲ - ἑ - λώ - ρι - α - τεῦ - χε - κύ - νεσ - σιν",
		"οἰ - ω - νοῖ - σί - τε - πᾶ - σι - Δι - ὸς - δἐ - τε - λεί - ε - το - βου - λή",
		"ἐκ - σοὗ - δὴ - τὰπ - ρῶ - τα - δι - ασ - τή - τη - νἐ - ρί - σαν - τε",
		"Ἀτ - ρε - ΐ - δης - τε - ἄ - νακ - σἀν - δρῶν - καὶ - δῖ - ο - ςἈ - χιλ - λεύς",
		"Τίσ - τάρ - σφω - ε - θε - ῶ - νἔ - ρι - δικ - συ - νέ - η - κε - μά - χεσ - θαι",
		"Λη - τοῦς - καὶ - Δι - ὸ - ςυἱ - ό - ςὃ - γὰρ - βα - σι - λῆ - ϊ - χο - λω - θεὶς",
		"νοῦ - σο - νἀ - νὰσ - τρα - τὸ - νὄρ - σε - κα - κή - νὀ - λέ - κον - το - δὲ - λα - οί",
	]


	mysylls = [
		"Μῆ - νι - νἄ - ει - δε - θε - ὰ - Πη - λη - ϊ - ά - δε - ω - Ἀ - χι - λῆ - ος",
		"οὐ - λο - μέ - νη - νἣ - μυ - ρί - Ἀχ - αι - οῖς - ἄλγ - ε - ἔ - θη - κε",
		"πολ - λὰς - δἰφ - θί - μους - πςυ - χὰ - ςἌ - ϊ - διπ - ρο - ΐ - απ - σεν",
		"ἡρ - ώ - ων - αὐ - τοὺς - δὲ - ἑ - λώ - ρι - α - τεῦ - χε - κύ - νεσ - σιν",
		"οἰ - ω - νοῖ - σί - τε - πᾶ - σι - Δι - ὸς - δἐ - τε - λεί - ε - το - βου - λή",
		"ἐκ - σοὗ - δὴ - τὰπ - ρῶ - τα - δι - ασ - τή - τη - νἐ - ρί - σαν - τε",
		"Ἀτ - ρε - ΐ - δης - τε - ἄ - νακ - σἀν - δρῶν - καὶ - δῖ - ο - ςἈ - χιλ - λεύς",
		"Τίσ - τάρ - σφω - ε - θε - ῶ - νἔ - ρι - δικ - συ - νέ - η - κε - μά - χεσ - θαι",
		"Λη - τοῦς - καὶ - Δι - ὸς - υἱ - ό - ςὃ - γὰρ - βα - σι - λῆ - ϊ - χο - λω - θεὶς",
		"νοῦ - σο - νἀ - νὰσ - τρα - τὸ - νὄρ - σε - κα - κή - νὀ - λέ - κον - το - δὲ - λα - οί",
	]

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

	# Testing word-breaks and colons

	# Setup Iliad 1.9
		# Synapheia
	test_synf_9 = MeterReader.synapheia(iliadPoeticLines[9].chars)
		# Syllabify (first cut)
		# Λητοῦς καὶ Διὸς υἱός· ὃ γὰρ βασιλῆϊ χολωθεὶς
		# Λη-τοῦς-καὶ-Δι-ὸ-ςυἱ-ό-ς·ὃ-γὰρ-βα-σι-λῆ-ϊ-χο-λω-θεὶς
	test_sylls_9::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_9)	
		# Get the index of a test syllable

	test_synf_7 = MeterReader.synapheia(iliadPoeticLines[7].chars)
	test_sylls_7::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_7)	
	test_synf_8 = MeterReader.synapheia(iliadPoeticLines[8].chars)
	test_sylls_8::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_8)	
	test_synf_2 = MeterReader.synapheia(iliadPoeticLines[2].chars)
	test_sylls_2::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_2)	

	@test begin
		index = 7 # 
		vbs = test_sylls_9
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	

end

#=
1.1   Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
1.2   οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
1.3   πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν
1.4   ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν
1.5   οἰωνοῖσί τε πᾶσι, Διὸς δ᾽ ἐτελείετο βουλή,
1.6   ἐξ οὗ δὴ τὰ πρῶτα διαστήτην ἐρίσαντε
1.7   Ἀτρεΐδης τε ἄναξ ἀνδρῶν καὶ δῖος Ἀχιλλεύς.
1.8   Τίς τάρ σφωε θεῶν ἔριδι ξυνέηκε μάχεσθαι;
1.9   Λητοῦς καὶ Διὸς υἱός· ὃ γὰρ βασιλῆϊ χολωθεὶς
1.10  νοῦσον ἀνὰ στρατὸν ὄρσε κακήν, ὀλέκοντο δὲ λαοί,
=#