@testset "ParseTests" begin

	testLineStrings = [
	# spondaic line
	"urn:cts:eumaeus:testgroup.testwork.ed:spondaic#βη γω, δη θω, κη λω, μη νω, πη σω, χη βη",
	# dactylic line
	"urn:cts:eumaeus:testgroup.testwork.ed:normal2#βη γε γο, γη δε δο, θη κη, λη με νο, πη πε πο, τη τε το",
	# like Iliad 1.1
	"urn:cts:eumaeus:testgroup.testwork.ed:normal3#βηγε γογηδε δοθη κηλημενοπη πεποτητω",
	# synizesis 1
	"urn:cts:eumaeus:testgroup.testwork.ed:syniz4#βη γη, δε ε κη, λη μη, νη πη, πω σε τε, χη βη",
	# synizesis 2
	"urn:cts:eumaeus:testgroup.testwork.ed:syniz2#βε ο γη, δη θη, κη λη, μη νη, πη σε τε, χη βη",
	# two dactyls
	"urn:cts:eumaeus:testgroup.testwork.ed:two_dact#Μῆνιν ἄειδε θε",
	# dactyl-spondee
	"urn:cts:eumaeus:testgroup.testwork.ed:dact_spond#οὐλομένην, ἣ",
	# two spondees
	"urn:cts:eumaeus:testgroup.testwork.ed:two_spond#Λητοῦς νοῦσων"
	# ambiguous alpha -> short
	# ambiguous alpha -> long
	]




	testLineNodes::Vector{CitablePassage} = begin
		testLines::Vector{String} = testLineStrings
		testNodes::Vector{CitablePassage} = map(testLines) do il 
			MeterReader.citablePassage(il)
		end
	end

	testPoeticLines::Vector{PoeticLine} = begin
		plVec = map(testLineNodes) do iln 
			MeterReader.makePoeticLine(iln)
		end
	end	


	# Setup some Iliad lines
		# Synapheia
	test_synf_1 = MeterReader.synapheia(testPoeticLines[1].chars)
		# First-cut syllabify
	test_sylls_1::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_1)	

	test_synf_2 = MeterReader.synapheia(testPoeticLines[2].chars)
	test_sylls_2::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_2)	
	test_synf_3 = MeterReader.synapheia(testPoeticLines[3].chars)
	test_sylls_3::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf_3)	

	# Testing for colon, just to see if this is all working…

	@test begin
		index = 3 # 
		vbs = test_sylls_2
		syll = vbs[index]
		MeterReader.endswithcolon(syll) == true
	end broken = false

	# Example of showing some feet…

	@test begin 
		# Get a AnnotatedSyllables for the fake Iliad 1.1 line
		vas::Vector{MeterReader.AnnotatedSyllable} = map( eachindex(test_sylls_3) ) do i 
			MeterReader.evaluate(test_sylls_3, i)
		end 

		# Make feet: This will be handled by function parse_dactylic_hexameter() in Parse.jl
		sylls_for_feet::Vector{UnitRange{Int64}} = [
			1:3,
			4:6,
			7:8,
			9:11,
			12:14,
			15:16
		]
		six_feet::Vector{MeterReader.MetricalFoot} = map( eachindex(sylls_for_feet)) do i
			sylls::Vector{MeterReader.AnnotatedSyllable} = map( collect(sylls_for_feet[i]) ) do syll 
				vas[syll]	
			end
			MeterReader.MetricalFoot(i, sylls)
		end

		# Display
		println(MeterReader.show(six_feet))
		true
	end

	# Test basic workflow up to the parsing step…
	@test begin 

		# Get a line of poetry as a String, urn#text
		test_line_string::String = testLineStrings[1]

		# Make it a CitablePassage object
		test_citable_passage::CitablePassage = MeterReader.citablePassage(test_line_string)

		# Make it a PoeticLine
		test_poetic_line::MeterReader.PoeticLine = MeterReader.makePoeticLine(test_citable_passage)

		# Synapheia: Run the characters together without punctuation or spaces
		test_synf::MeterReader.Synapheia = MeterReader.synapheia(test_poetic_line.chars)

		# Do a first-cut syllabification into a Vector{BasicSyllable}
		test_sylls::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf)

		# Do a first-cut analysis for quantity and flags
		test_vas::Vector{MeterReader.AnnotatedSyllable} = map( eachindex(test_sylls) ) do i 
			MeterReader.evaluate(test_sylls, i)
		end 

		true	
	end

	# The above is a lot of steps!! We need one function. Let's test it.
	@test begin 
		test_line_string::String = testLineStrings[1]
		test_sylls::Vector{MeterReader.AnnotatedSyllable} = MeterReader.prepare_to_parse(test_line_string)
		true
	end

	# Do we get the same thing?
	@test begin 
		# Get a line of poetry as a String, urn#text
		test_line_string::String = testLineStrings[1]

		# Make it a CitablePassage object
		test_citable_passage::CitablePassage = MeterReader.citablePassage(test_line_string)

		# Make it a PoeticLine
		test_poetic_line::MeterReader.PoeticLine = MeterReader.makePoeticLine(test_citable_passage)

		# Synapheia: Run the characters together without punctuation or spaces
		test_synf::MeterReader.Synapheia = MeterReader.synapheia(test_poetic_line.chars)

		# Do a first-cut syllabification into a Vector{BasicSyllable}
		test_sylls::Vector{MeterReader.BasicSyllable} = MeterReader.syllabify4poetry(test_synf)

		# Do a first-cut analysis for quantity and flags
		evaluate_the_hard_way::Vector{MeterReader.AnnotatedSyllable} = map( eachindex(test_sylls) ) do i 
			MeterReader.evaluate(test_sylls, i)
		end 

		# Use our function to do it the easy way
		evaluate_the_easy_way::Vector{MeterReader.AnnotatedSyllable} = MeterReader.prepare_to_parse(test_line_string)

		evaluate_the_hard_way === evaluate_the_hard_way

	end

	@test begin 
		test_line_string::String = testLineStrings[1]
		test_line::Vector{MeterReader.AnnotatedSyllable} = MeterReader.prepare_to_parse(test_line_string)

		results = MeterReader.preprocess_quantities(test_line)
		true

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