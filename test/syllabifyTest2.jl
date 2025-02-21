@testset "syllabifytests2" begin

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

	# Testing synapheia()

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		synf.synapheia[1].charindex == synf.context[1].charindex
	end

	# Testing syllabify4poetry()

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[2].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[3].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[4].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

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

	@test begin 

		mysylls = testsylls[1] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[2] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[2].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[3] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[3].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[4] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[4].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[5] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[5].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[6] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[6].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[7] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[7].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[8] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[8].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[9] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[9].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[10] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[10].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		println("Returned $(sylls |> length) syllables.")
		println(MeterReader.showsyllable(sylls, false))
		println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	# Testing Syllable Quantity

	# Setup Iliad 1.1
		# Synapheia
	quant_test_synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		# Syllabify (first cut)
	quant_test_sylls::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(quant_test_synf)	
		# Get the index of a test syllable
		

	@test begin 
		tsi::Int = 1
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "long"
	end

	@test begin 
		tsi::Int = 2
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "ambiguous"
	end

	@test begin 
		tsi::Int = 3
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "ambiguous"
	end

	@test begin 
		tsi::Int = 4
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "long"
	end

	@test begin 
		tsi::Int = 5
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "short"
	end

	@test begin 
		tsi::Int = 6
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "short"
	end

	@test begin 
		tsi::Int = 7
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "ambiguous"
	end

	@test begin 
		tsi::Int = 8
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "long"
	end

	@test begin 
		tsi::Int = 9
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "long"
	end

	@test begin 
		tsi::Int = 10
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.quantity
		as.quantity == "ambiguous"
	end


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