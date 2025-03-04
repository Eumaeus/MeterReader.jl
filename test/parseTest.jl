@testset "ParseTests" begin

	testLineStrings = [
	# spondaic line
	"urn:cts:eumaeus:testgroup.testwork.ed:normal1#βη γω, δη θω, κη λη, μη νη, πη σε τε, χη βη",
	# dactylic line
	"urn:cts:eumaeus:testgroup.testwork.ed:normal1#βη γε γο, γη δε δο, θη κη, λη με νο, πη πε πο, τη τω",
	# synizesis 1
	"urn:cts:eumaeus:testgroup.testwork.ed:syniz1#βη γη, δε ε κη, λη μη, νη πη, πω σε τε, χη βη",
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