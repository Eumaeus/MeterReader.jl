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
		#println("testing syllabifytests2")
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
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[2].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[3].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, true))
		typeof(sylls) == Vector{MeterReader.BasicSyllable}
	end

	@test begin 
		synf = MeterReader.synapheia(iliadPoeticLines[4].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, true))
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
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[2] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[2].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[3] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[3].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[4] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[4].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[5] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[5].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[6] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[6].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[7] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[7].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[8] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[8].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[9] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[9].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	@test begin 

		mysylls = testsylls[10] |> BetaReader.unicodeToBeta # wrong, but this is a first-cut!

		synf = MeterReader.synapheia(iliadPoeticLines[10].chars)
		sylls = MeterReader.syllabify4poetry(synf)	
		#println("Returned $(sylls |> length) syllables.")
		#println(MeterReader.showsyllable(sylls, false))
		#println(mysylls)
		MeterReader.showsyllable(sylls, false) == mysylls
	end

	# Testing Syllable Quantity

	# Setup Iliad 1.1
		# Synapheia
	quant_test_synf = MeterReader.synapheia(iliadPoeticLines[1].chars)
		# Syllabify (first cut)
	quant_test_sylls::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(quant_test_synf)	
	
	
	@test begin 
		tsi::Int = 1 # does have circumflex!
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test for circumflex
		MeterReader.containscircumflex(as.syllable) == true
	end

	@test begin 
		tsi::Int = 2 # does not have circumflex!
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test for circumflex
		MeterReader.containscircumflex(as.syllable) == false
	end


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


	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 8
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
		#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end
		#println("---- nextyll = `$(MeterReader.showsyllable(nextsyll))`")

		MeterReader.showsyllable(nextsyll) == "lh"
	end

	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 16
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
		#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end
		#println("---- nextyll = `$(MeterReader.showsyllable(nextsyll))`")

		MeterReader.showsyllable(nextsyll) == "os"
	end

	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 17
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
		#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end
		#println("---- nextyll = $nextsyll`")

		nextsyll == nothing
	end

	# Test Flags

	@test begin 
		tsi::Int = 1
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.flags
		("possible_ellision" in as.flags) == false
	end 

	@test begin 
		tsi::Int = 3
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Test as.flags
		("possible_ellision" in as.flags) == true
	end 



	# Test my 'nextsyll' code in evaluate()
	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 1
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
	#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end
		#println("----> nextyll = `$(MeterReader.showsyllable(nextsyll))`")
		#println("----------> $(nextsyll.chars[1].charstring)")
		#println("--------------> $(nextsyll.chars[1] |> MeterReader.isavowel)")

		MeterReader.showsyllable(nextsyll) == "ni"
	end

	# Test my 'nextsyll' code in evaluate()
	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 3
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
	#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end
		#println("----> nextyll = `$(MeterReader.showsyllable(nextsyll))`")
		#println("----------> $(nextsyll.chars[1].charstring)")
		#println("--------------> $(nextsyll.chars[1] |> MeterReader.isavowel)")

		MeterReader.showsyllable(nextsyll) == "ei"
	end


	# Does a syllable begin with a vowel?
	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 3 # "na"
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
	#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end # "ei"
		#println("----> nextyll = `$(MeterReader.showsyllable(nextsyll))`")
		#println("----------> $(nextsyll.chars[1].charstring)")
		#println("--------------> $(nextsyll.chars[1] |> MeterReader.isavowel)")

		MeterReader.beginswithvowel(nextsyll) == true
	end

	# Does a syllable begin with a vowel?
	@test begin
		# quant_test_sylls::Vector{MeterReader.BasicSyllable}
		index = 1 # "mh="
		vbs = quant_test_sylls
		thissyll::MeterReader.BasicSyllable = vbs[index]
	#println("---- thissyll = `$(MeterReader.showsyllable(thissyll))`")
		nextsyll::Union{MeterReader.BasicSyllable, Nothing} = begin
			if (index >= length(vbs)) nothing
			else (vbs[index+1])
			end
		end # "ni"
		#println("----> nextyll = `$(MeterReader.showsyllable(nextsyll))`")
		#println("----------> $(nextsyll.chars[1].charstring)")
		#println("--------------> $(nextsyll.chars[1] |> MeterReader.isavowel)")

		MeterReader.beginswithvowel(nextsyll) == false
	end


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



	# Test Pretty-printing

	@test begin 
		tsi::Int = 12 
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(test_sylls_2, tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end 

	@test begin 
		tsi::Int = 11
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(test_sylls_2, tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end 

	@test begin 
		tsi::Int = 7
		# Get an AnnotatedSyllable
		as::MeterReader.AnnotatedSyllable = MeterReader.evaluate(quant_test_sylls, tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end 

	@test begin 
		tsi::Vector{Int} = collect(1:3)
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(4:5)
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(6:8)
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(9:10)
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(11:13)
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)
		# Uncomment below
		# println(MeterReader.show(as))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(1:3)
		seq::Int = 1
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)

		pf::MeterReader.MetricalFoot = MeterReader.MetricalFoot(seq, vas)	
		# Uncomment below
		#println(MeterReader.show(pf))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(4:5)
		seq::Int = 2
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)

		pf::MeterReader.MetricalFoot = MeterReader.MetricalFoot(seq, vas)	
		# Uncomment below
		#println(MeterReader.show(pf))
		true
	end

	@test begin 
		tsi::Vector{Int} = collect(6:8)
		seq::Int = 3
		# Get an AnnotatedSyllable
		vas::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi)

		pf::MeterReader.MetricalFoot = MeterReader.MetricalFoot(seq, vas)	
		# Uncomment below
		#println(MeterReader.show(pf))
		true
	end

	@test begin 
		tsi1::Vector{Int} = collect(1:3)
		seq1::Int = 1
		vas1::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi1)
		pf1::MeterReader.MetricalFoot = MeterReader.MetricalFoot(seq1, vas1)	

		tsi2::Vector{Int} = collect(4:5)
		seq2::Int = 2
		vas2::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi2)
		pf2::MeterReader.MetricalFoot = MeterReader.MetricalFoot(seq2, vas2)	

		tsi3::Vector{Int} = collect(6:8)
		seq3::Int = 3
		vas3::Vector{MeterReader.AnnotatedSyllable} = map( i -> MeterReader.evaluate(test_sylls_2, i), tsi3)
		pf3::MeterReader.MetricalFoot = MeterReader.MetricalFoot(seq3, vas3)	

		vpf::Vector{MeterReader.MetricalFoot} = [
			pf1,
			pf2,
			pf3
		]
		# Uncomment below
		println("\n" * MeterReader.show(vpf) * "\n")
		true
	end


	# Test Flags

	@test begin
		index = 7 # 
		vbs = test_sylls_9
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	@test begin
		index = 16 # 
		vbs = test_sylls_8
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	@test begin
		index = 14 # 
		vbs = test_sylls_8
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == false
	end broken = false

	@test begin
		index = 15 # 
		vbs = test_sylls_7
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	@test begin
		index = 4 # 
		vbs = test_sylls_2
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	@test begin
		index = 15 # 
		vbs = test_sylls_2
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	@test begin
		index = 16 # 
		vbs = test_sylls_9
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == false
	end broken = false

	@test begin 
		l = iliadPoeticLines[2]
		vac::MeterReader.AlignedChar = l.chars[10] # comma
		MeterReader.iscolon(vac) == true
	end

	@test begin 
		l = iliadPoeticLines[2]
		vac::MeterReader.AlignedChar = l.chars[2] # "ῆ"
		MeterReader.iscolon(vac) == false
	end

	@test begin 
		l = iliadPoeticLines[7]
		vac::MeterReader.AlignedChar = l.chars[43] # period
		#println(vac.charstring)
		MeterReader.iscolon(vac) == true
	end

	# Test wordbreakafter()
	@test begin
		index = 5 # 
		vbs = test_sylls_7
		syll = vbs[index]
		MeterReader.wordbreakafter(syll) == true
	end broken = false

	@test begin
		index = 2 # 
		vbs = test_sylls_7
		syll = vbs[index]
		MeterReader.wordbreakafter(syll) == false
	end broken = false

	@test begin
		index = 4 # 
		vbs = test_sylls_7
		syll = vbs[index]
		MeterReader.wordbreakafter(syll) == true
	end broken = false

	@test begin
		index = 6 # 
		vbs = test_sylls_7
		syll = vbs[index]
		MeterReader.wordbreakafter(syll) == false
	end broken = false

	@test begin
		index = 5 # 
		vbs = test_sylls_7
		syll = vbs[index]
		MeterReader.wordbreakafter(syll) == true
	end broken = false

		@test begin
		index = 7 # 
		vbs = test_sylls_9
		syll = vbs[index]
		MeterReader.wordbreakafter(syll) == true
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