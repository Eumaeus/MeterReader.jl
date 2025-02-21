### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 6466482e-2710-40be-a9e1-a67d76b62d86
begin
	using Random
	using Unicode
	using Base.Iterators: product
	using BetaReader
	using CitableText
end

# ╔═╡ e8b7e05f-3515-4786-a242-223b8d31a976
md"""
## Test BetaReader
"""

# ╔═╡ 2ef4f016-1d99-4a3c-9a2a-f4a3d3773709
BetaReader.betaToUnicode("mh=nin")

# ╔═╡ a171a4f7-20a0-47eb-bbe8-21ee43fe6b83
BetaReader.unicodeToBeta("μῆνιν")

# ╔═╡ 62e6251b-1595-41e4-b272-77842eae1c98
md"""
## Data Structures & Constants
"""

# ╔═╡ c93e1d85-9caa-46d6-824a-ef24234c0027
struct Foot
    meter::String
end

# ╔═╡ 7650b41b-b818-493c-bcf7-071be9ebc251
struct HexameterLine
    feet::Vector{Foot}
end

# ╔═╡ fa556c01-69d6-4dbf-bbf9-1b7f685f115c
begin
	DACTYL = Foot("-,,")
	SPONDEE = Foot("--")
	TROCHEE = Foot("-,")
end

# ╔═╡ 78253de4-f4f5-4043-8c4d-7b2736909f2a
struct IndexedString
	i::Int64
	s::String
	type::String # types: text, separator, punctuation
end

# ╔═╡ e8135c67-b65d-44c5-98ff-c05a250acb3c
struct AlignedChar
	charstring::String
	charindex::Int
	tokenindex::Int
	type::String # types: text, separator, punctuation
end

# ╔═╡ b83a7edc-8dbc-48be-8630-72f8a4d7ed82
struct PoeticLine
 	urn::CtsUrn
	text::String
	wordtokens::Vector{IndexedString}
	chars::Vector{AlignedChar}
end

# ╔═╡ b62b1830-bf18-4970-880b-dd145b7113fb
md"""
## Capture a Poetic Line
"""

# ╔═╡ 442460a4-1ea6-43bb-ac7c-674d7294d383
"Given a token, categorize it as 'text', 'separator', or 'punctuation'."
function typeToken(s::String)::String 
	puncs = """()[]{}·⸁.,;"?·!–—⸂⸃"""
	seps = """ \n\t"""
	firstChar = string(s[1])
	category = begin
		if (contains(puncs, firstChar))
			"punctuation"
		elseif (contains(seps,firstChar))
			"separator"
		else
			"text"
		end 
 	end
end

# ╔═╡ b62999e7-1824-4b92-9bb6-5718552c0324
function makePoeticLine(urnstring::String, text::String)
	u = CtsUrn(urnstring)
	makePoeticLine(u, text)
end

# ╔═╡ fb5cfdfb-e267-4b7d-9424-695f8d4c473f
function alignChars(vis::Vector{IndexedString})
	# Get characters for each indexed token
	#		lower-case and swap all sigmas for lunate forms
	#		Assign token-index and type 
	vvac::Vector{Vector{AlignedChar}} = map(vis) do tok
		newTokString = replace(tok.s, r"[σς]" => "ϲ") |> lowercase
		tokchars::Vector{AlignedChar} = map(collect(newTokString)) do c
			AlignedChar(string(c), 0, tok.i, tok.type)
		end
	end
	# Flatten
	vac::Vector{AlignedChar} = vcat(vvac...)
	# Re-index sequentially, catching double-consonants
	newVec = [] 
	for i in eachindex(vac)
		# Catch double-chars and deal with them…
		if (contains( "ζξψ", vac[i].charstring))
			if (vac[i].charstring == "ξ")
				cc = AlignedChar( "κ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
				cc = AlignedChar( "ϲ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
			elseif (vac[i].charstring == "ζ")
				cc = AlignedChar( "ϲ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
				cc = AlignedChar( "δ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
			elseif (vac[i].charstring == "ψ")
				cc = AlignedChar( "π", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
				cc = AlignedChar( "ϲ", i, vac[i].tokenindex, vac[i].type )
				push!(newVec, cc)
			end
		else
			cc = AlignedChar( vac[i].charstring, i, vac[i].tokenindex, vac[i].type )
			push!(newVec, cc)
		end
	end

	return newVec

end

# ╔═╡ 25965162-18b3-4dd8-87f1-ab3d2c40802f
begin
	u1 = CtsUrn("urn:cts:greekLit:tlg0012.tlg001:1.2")
	s1 = "οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"
	u2 = CtsUrn("urn:cts:greekLit:tlg0012.tlg001:1.3")
	s2 = "πολλὰς δ᾽ ἰφθίμους ψυχὰς Ἄϊδι προΐαψεν"
end

# ╔═╡ ea6dbe5b-d968-42d3-a683-2e288f29a754


# ╔═╡ d5b86821-4d9d-4b03-a41a-c1db3c3c6f68
md"""
## Metrical Functions
"""

# ╔═╡ d0015e2a-d5f8-4785-969a-fc87dfde33e3
function is_valid_hexameter(line::HexameterLine)::Bool
    if length(line.feet) != 6
        return false
    end
    
    # Check the first five feet
    for i in 1:5
        if line.feet[i].meter ∉ ["-,,", "--"]
            return false
        end
    end
    
    # The last foot can be either a spondee or a trochee
    if line.feet[6].meter ∉ ["--", "-,"]
        return false
    end
    
    return true
end

# ╔═╡ c56f7313-4197-4101-b67f-d99b6d70a649
function meter_string(line::HexameterLine)
    return join([meter_string(foot) for foot in line.feet])
end

# ╔═╡ 07cb55ab-20a0-4d74-9c5d-eb7f6866cbce
function meter_string(foot::Foot)
    return foot.meter
end

# ╔═╡ 29442d1a-752e-4412-8aa6-5d74e72a663e
line = HexameterLine([DACTYL, DACTYL, DACTYL, DACTYL, DACTYL, SPONDEE])

# ╔═╡ 839eea8f-d037-410d-b66f-f62f9bffeb04
# Generate all combinations
combinations = collect(product([DACTYL, SPONDEE], [DACTYL, SPONDEE], [DACTYL, SPONDEE], [DACTYL, SPONDEE], [DACTYL, SPONDEE], [SPONDEE, TROCHEE]))

# ╔═╡ c36f8ac0-4c43-495f-817a-192cfa5f054f
md"""
## Some Useful Functions
"""

# ╔═╡ 9b6f9b64-f3be-4539-9b2b-d0152e8ee82b
# Implemenent eachwithindex(v::Vector[Any]) like in Scala
function eachwithindex(v::Vector)::Vector{Tuple{Int64, Any}}
    map(eachindex(v)) do i 
        (i, v[i])
    end
end

# ╔═╡ cc28d8b5-bcaf-445a-bc9d-637e1fc7c410
# Convert to HexameterLine
all_lines = [HexameterLine([Foot(meter_string(f)) for f in comb]) for comb in combinations]

# ╔═╡ 52f90a90-5f0b-4e78-8afb-fcf0539518bc
# Display the first few lines for confirmation
for line in all_lines[1:5]
    println(meter_string(line))
end

# ╔═╡ c52302da-c73e-4f39-87f7-839342c1f3f7
length(combinations)

# ╔═╡ d2ae2423-b057-4352-9219-c313c85d4166
md"## Split & Retain"

# ╔═╡ 05f45b8b-430b-45fb-9e3f-028cd96c20ae
" All-purpose list of punctuation "
const_splitters = """\n()[]·⸁.,; "?·!–—⸂⸃"""


# ╔═╡ 0e714275-9f45-46b5-96a4-761a8f265909
" Escape a string, for splitting"
function escape_string(c::String)::String
    # Escape special regex characters
    return occursin(r"[\^$.|?*+(){}[\]\\]", c) ? "\\" * c : c
end

# ╔═╡ 7cc57aae-3e74-4b8a-ac0a-fe6d03e88d90
" Split string, retaining the characters on which you split"
function split_and_retain(my_text::String, split_characters::String = """\n\t()[]·⸁.,; "?·!–—⸂⸃""")::Vector{String}

	# Escape each character in split_characters to handle special regex characters
    escaped_splitters = join([escape_string(string(c)) for c in split_characters], "")
	# Turn my_text into an array of Char
	my_text_chars = collect(my_text)
    
	   
    # Initialize result and tracking index
    result = String[]
    last_index = 1
    
    # Iterate through each match of the split_regex
    for c in eachindex(my_text_chars)
		if ( contains(escaped_splitters, my_text_chars[c] ) )
			# get previous chunk
			prevchunk = join(my_text_chars[last_index:c-1])
			if (length(prevchunk) > 0)
				push!(result, prevchunk)
			end
			# add splitter
			push!(result, string(my_text_chars[c]))
			# update lastindex
			last_index = c + 1
		end		
	end
	
	# Add any remaining text after the last match
    if last_index <= length(my_text_chars)
        push!(result, join( my_text_chars[last_index:end]) )
    end
	
	result

end

# ╔═╡ a9453df4-ebe9-497b-857d-8f9fb72646ea
"""Given a URN and a string, create a PoeticLine structure (see definition above). """
function makePoeticLine(urn::CtsUrn, text::String)
	tokenized = split_and_retain(text)
	wtoks::Vector{IndexedString} = begin
		ewi = eachwithindex(tokenized)
		map(ewi) do e
			IndexedString(e[1], e[2], typeToken(e[2]))
		end
	end
	chars = alignChars(wtoks)
	PoeticLine(urn, text, wtoks, chars)
end

# ╔═╡ 95c84f7a-b35d-4984-a9aa-bd501a0386f0
pl = makePoeticLine(u2, s2)

# ╔═╡ bebe3e74-f1d3-4ac6-bb5f-16af579cf810


# ╔═╡ 8ed701f9-364a-4cc5-a36d-9f51eea5ffd1
iliadString = """
Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος
οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,
πολλὰς δ᾽ ἰφθίμους πσυχὰς Ἄϊδι προΐαπσεν
ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν
οἰωνοῖσί τε πᾶσι, Διὸς δ᾽ ἐτελείετο βουλή,
"""

# ╔═╡ 5413e075-5a9b-476d-a1ae-7cde1235baed
iliadLines = split(iliadString, "\n")

# ╔═╡ 0e21304f-bf0d-497e-8b73-2d931e748abb


# ╔═╡ 0af04859-b342-4d3c-b7cf-1891e8e68c27


# ╔═╡ 9d3bcf80-9601-4fa7-9601-4c3160af97ca
split_and_retain(iliadString, const_splitters)

# ╔═╡ 62f50f61-d483-460a-b12d-c30ad3d4d0be
md"""
## Syllabify Workshop
"""

# ╔═╡ b77b41de-0b7d-45be-b4a1-07eefc40beca
whichline = 3

# ╔═╡ cbe410ff-7bcc-4043-81ff-1198babd45c8
ilchars = begin
	allchars = split(iliadLines[whichline], "")
	betachars = map( split(iliadLines[whichline], "") ) do c
		BetaReader.unicodeToBeta(c) |> lowercase
	end
	justchars = filter(betachars) do c
	 	( contains(" ,.';:-–—", c) == false ) &&
		( c != " )")
	end
	justchars
end

# ╔═╡ feefac3f-f62e-4783-8264-86b54a08ba3b
begin
	const _VOWELS = [
	"a",
	"e",
	"h",
	"i",
	"o",
	"u",
	"w"
]

const _CONSONANTS	= [
	"b",
	"g",
	"d",
	"z",
	"q",
	"k",
	"l",
	"m",
	"n",
	"c",
	"p",
	"r",
	"s",
	"t",
	"f",
	"x",
	"y",
	"v" # digamma
]

const _DIPHTHONGS	= [
	"ai",
	"au",
	"ei",
	"eu",
	"hi",
	"hu",
	"oi",
	"ou",
	"ui",
	"wi"
]

end

# ╔═╡ 43ed1d11-f987-4cf1-b575-8e0c49a068d4
function isvowel(s::String)::Bool
	ts = replace(s, r"[()/\\=|?+]" => "")
	ts in _VOWELS
end

# ╔═╡ b9bd7f24-cf50-437e-bbc8-911f5a578fe5


# ╔═╡ 36d2f75f-ba4a-46d6-a3f5-0aa9d041e13a
function containsvowel(s::String)::Bool
	fs = filter(s) do c 
		c in _VOWELS
	end
	length(fs) > 0
end

# ╔═╡ bd45d99d-2194-488e-98d1-56ee5cd6f180
function isconsonant(s::String)::Bool
	ts = replace(s, r"[()/\\=|?+]" => "")
	ts in _CONSONANTS
end

# ╔═╡ 162347d7-5779-4eae-8228-060f26857aae
contains("a", r"[/\\=]")

# ╔═╡ 2cc3cc8d-86d4-4fda-9b2e-cf60d3e9c97e
function getchartype(s::String)
	if isvowel(s) "vowel"
	elseif isconsonant(s) "consonant"
	else "other"
	end
end

# ╔═╡ d4b6ef06-3af2-48b2-ad0f-2d56c26e8a16
function stripdiacritics(s::String)::String
	ts = replace(s, r"[()/\\=|?+]" => "")	
end 

# ╔═╡ a7cceb2a-7986-4f8e-915c-4b10d1a22dd3
function isdiphthong(v1::String, v2::String)::Bool
	if (contains(v2, "+"))
		false
	elseif (contains(v1, r"[/\\=]")) # accents on first indicate no diphthong
		false
	else
		ts = ( last(stripdiacritics(v1)) ) * (  last(stripdiacritics(v2))  )
		ts in _DIPHTHONGS
	end
end

# ╔═╡ 2c06cbcc-3bce-4d7d-bac6-963414fc8a74


# ╔═╡ 1fa553e1-b23f-4baf-9bf1-97686b944ce5
"Syllabify a line. Assumes separators and punctuation are removed. Accepts an array of strings, each element being a beta-code representation of a characters and any diacriticals."
function testsyll(chars::Vector{String})
	mysylls = []
	prevchartype = ""
	for c in eachindex(chars)

		lastchar = begin
			if (c > 1) chars[c-1]
			else ""
			end
		end
		next1char = begin
			if (c+1 > length(chars)) ""
			else chars[c+1]
			end
		end
		next2char = begin
			if (c+2 > length(chars)) ""
			else chars[c+2]
			end
		end

		

		if isempty(mysylls) # first char of the line
			push!(mysylls, chars[c]) # start a new syllable
			prevchartype = getchartype(chars[c]) # go ahead and update this!
		else # syllabification is under way
			if (isconsonant(chars[c])) #consonant?

				# end of line; close the previous syllable
				if (c == length(chars)) 
					println("1. $prevchartype -- $(chars[c]) -- $next1char ($(getchartype(next1char))) ")
					tempstr = last(mysylls)
					newstr = tempstr * chars[c]
					pop!(mysylls)
					push!(mysylls, newstr)
					prevchartype = getchartype(chars[c])
				# double-consonant; close the previous syllable
				elseif ( (prevchartype == "vowel") && ( isconsonant(next1char) )) 
					println("2. $prevchartype -- $(chars[c]) -- $next1char ($(getchartype(next1char))) ")
					tempstr = last(mysylls)
					newstr = tempstr * chars[c]
					pop!(mysylls)
					push!(mysylls, newstr)
					prevchartype = getchartype(chars[c])
				# one consonant before a vowel; start a new syllable
				elseif ( (prevchartype == "vowel") && ( isvowel(next1char) ) )  
					println("3. $prevchartype -- $(chars[c]) -- $next1char ($(getchartype(next1char))) ")
					push!(mysylls, chars[c]) # start a new syllable
					prevchartype = getchartype(chars[c]) # go ahead and update this!
				# 3rd in a consonant cluster; add to last
				elseif  ( (prevchartype == "consonant") && ( length(last(mysylls)) == 1 ) ) # add to last
					println("4. $prevchartype -- $(chars[c]) -- $next1char ($(getchartype(next1char))) ")
					tempstr = last(mysylls)
					newstr = tempstr * chars[c]
					pop!(mysylls)
					push!(mysylls, newstr)
					prevchartype = getchartype(chars[c])
				# consonant after closed syllable; start new syllable 
				elseif  ( (prevchartype == "consonant") && ( isvowel(next1char) ) ) 
					println("5. $prevchartype -- $(chars[c]) -- $next1char ($(getchartype(next1char))) ")
					push!(mysylls, chars[c]) # start a new syllable
					prevchartype = getchartype(chars[c]) # go ahead and update this!
				# 2nd consonant in cluster of 3+; start a new syllable; anything else
				else 
					println("6. $prevchartype -- $(chars[c]) -- $next1char ($(getchartype(next1char))) ")
					push!(mysylls, chars[c]) # start a new syllable
					prevchartype = getchartype(chars[c]) # go ahead and update this!
				
				end
				
			else # got a vowel!
				if ( prevchartype == "vowel" ) # gotta check for a diphthong
					if (isdiphthong(last(mysylls), chars[c])) # diphthong, add to previous syllable
						tempstr = last(mysylls)
						newstr = tempstr * chars[c]
						pop!(mysylls)
						push!(mysylls, newstr)
						prevchartype = getchartype(chars[c])
					else # not diphthong; new syllable
						push!(mysylls, chars[c]) # start a new syllable
						prevchartype = getchartype(chars[c]) # go ahead and update this!			
					end

				else # Not dealing with a diphthong
					if (containsvowel(last(mysylls))) 
						push!(mysylls, chars[c]) # start a new syllable
						prevchartype = getchartype(chars[c]) # go ahead and update this!
					else # add to previous
						tempstr = last(mysylls)
						newstr = tempstr * chars[c]
						pop!(mysylls)
						push!(mysylls, newstr)
						prevchartype = getchartype(chars[c])
					end
				end
			end
				
		end
			
		
	end
	mysylls
end 

# ╔═╡ 625c506a-93aa-456e-a5ce-c042cc988077
#=
typeoflast = begin
			lastchar = last(last(mysylls))
			if (lastchar in _CONSONANTS) "consonant"
			else "vowel"
			end
		end
=#

# ╔═╡ 9e8dcb73-725f-447f-8666-e342c5408411
testsyll(ilchars)

# ╔═╡ 87ed2d9f-8ab7-45ee-8a64-0cf4254b4535
xx = ["abc","bcd","cde"]

# ╔═╡ 1b8cfd0b-395b-4a01-a190-b024053338d1
m = match(r"([a-z])[)/\\=]+([a-z])", "ai")

# ╔═╡ 58419859-140f-42b4-b716-51dad4379462
m == nothing

# ╔═╡ b0c8f19e-3115-4ead-931e-9b5a025e3768
replace("a)/i", r"[)(/\\=|]" => "")


# ╔═╡ fc336075-5dd9-4fad-9ee2-84fc964dd2dd
x = split("ε᾽","")

# ╔═╡ 89fc7e92-6cc0-4784-a7f3-7242270fbf89
x[2][1]

# ╔═╡ 7f61b3c7-bee7-4ddc-af27-6f34daa1957f
last([1,2,3])

# ╔═╡ 9e12239b-8d7f-4661-82e6-075931f35289
un::Union{String, Nothing} = "dogs"

# ╔═╡ a5ccfd14-79aa-4686-b564-02c2d66d5261
typeof(un)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BetaReader = "e5583720-4bc8-44d1-bd9a-9734450b0166"
CitableText = "41e66566-473b-49d4-85b7-da83b66615d8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Unicode = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[compat]
BetaReader = "~1.0.0"
CitableText = "~0.16.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "384dc404dbd1120a8eb8e82621c1db7445e3965a"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "50c3c56a52972d78e8be9fd135bfb91c9574c140"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.1.1"

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

    [deps.Adapt.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BetaReader]]
deps = ["Compat", "DocStringExtensions", "Documenter", "IterTools", "PolytonicGreek", "Test", "TestSetExtensions", "Unicode"]
git-tree-sha1 = "2a7b80b8cac05ce67b3e398a31c7c716bbe95eb5"
uuid = "e5583720-4bc8-44d1-bd9a-9734450b0166"
version = "1.0.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "deddd8725e5e1cc49ee205a1964256043720a6c3"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.15"

[[deps.CitableBase]]
deps = ["DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "eec0c6a088940306a72f965fe5f9d81cda597d25"
uuid = "d6f014bd-995c-41bd-9893-703339864534"
version = "10.4.0"

[[deps.CitableCorpus]]
deps = ["CitableBase", "CitableText", "CiteEXchange", "DocStringExtensions", "Documenter", "HTTP", "Tables", "Test"]
git-tree-sha1 = "f400484e7b0fc1707f9dfd288fa297a4a2d9a2ad"
uuid = "cf5ac11a-93ef-4a1a-97a3-f6af101603b5"
version = "0.13.5"

[[deps.CitableText]]
deps = ["CitableBase", "DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "00ddf4c75f3e2b8dd54a4e4808b8ec27053d9bb3"
uuid = "41e66566-473b-49d4-85b7-da83b66615d8"
version = "0.16.2"

[[deps.CiteEXchange]]
deps = ["CSV", "CitableBase", "DocStringExtensions", "Documenter", "HTTP", "Test"]
git-tree-sha1 = "da30bc6866a19e0235319c7fa3ffa6ab7f27e02e"
uuid = "e2e9ead3-1b6c-4e96-b95f-43e6ab899178"
version = "0.10.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "545a177179195e442472a1c4dc86982aa7a1bef0"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.7"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DeepDiffs]]
git-tree-sha1 = "9824894295b62a6a4ab6adf1c7bf337b3a9ca34c"
uuid = "ab62b9b5-e342-54a8-a765-a90f495de1a6"
version = "1.2.0"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "1cdab237b6e0d0960d5dcbd2c0ebfa15fa6573d9"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.4.4"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "Base64", "Dates", "DocStringExtensions", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
git-tree-sha1 = "39fd748a73dce4c05a9655475e437170d8fb1b67"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "0.27.25"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "2ec417fc319faa2d768621085cc1feebbdee686b"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.23"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "c67b33b085f6e2faf8bf79a61962e7339a81129c"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.15"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+3"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.Orthography]]
deps = ["CitableBase", "CitableCorpus", "CitableText", "Compat", "DocStringExtensions", "Documenter", "OrderedCollections", "StatsBase", "Test", "TestSetExtensions", "TypedTables", "Unicode"]
git-tree-sha1 = "a337b43561a8b40890720d21fc2b866424465129"
uuid = "0b4c9448-09b0-4e78-95ea-3eb3328be36d"
version = "0.21.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.PolytonicGreek]]
deps = ["Compat", "DocStringExtensions", "Documenter", "Orthography", "Test", "TestSetExtensions", "Unicode"]
git-tree-sha1 = "fdd1745051464dfc6fa35d6c870cb5b82b48a290"
uuid = "72b824a7-2b4a-40fa-944c-ac4f345dc63a"
version = "0.21.10"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "712fb0231ee6f9120e005ccd56297abbc053e7e0"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.8"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "c06d695d51cfb2187e6848e98d6252df9101c588"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "29321314c920c26684834965ec2ce0dacc9cf8e5"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.4"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TestSetExtensions]]
deps = ["DeepDiffs", "Distributed", "Test"]
git-tree-sha1 = "3a2919a78b04c29a1a57b05e1618e473162b15d0"
uuid = "98d24dd4-01ad-11ea-1b02-c9a08f80db04"
version = "2.0.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.TypedTables]]
deps = ["Adapt", "Dictionaries", "Indexing", "SplitApplyCombine", "Tables", "Unicode"]
git-tree-sha1 = "84fd7dadde577e01eb4323b7e7b9cb51c62c60d4"
uuid = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"
version = "1.4.6"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╠═6466482e-2710-40be-a9e1-a67d76b62d86
# ╟─e8b7e05f-3515-4786-a242-223b8d31a976
# ╠═2ef4f016-1d99-4a3c-9a2a-f4a3d3773709
# ╠═a171a4f7-20a0-47eb-bbe8-21ee43fe6b83
# ╟─62e6251b-1595-41e4-b272-77842eae1c98
# ╠═c93e1d85-9caa-46d6-824a-ef24234c0027
# ╠═7650b41b-b818-493c-bcf7-071be9ebc251
# ╠═fa556c01-69d6-4dbf-bbf9-1b7f685f115c
# ╠═78253de4-f4f5-4043-8c4d-7b2736909f2a
# ╠═e8135c67-b65d-44c5-98ff-c05a250acb3c
# ╠═b83a7edc-8dbc-48be-8630-72f8a4d7ed82
# ╟─b62b1830-bf18-4970-880b-dd145b7113fb
# ╠═442460a4-1ea6-43bb-ac7c-674d7294d383
# ╠═a9453df4-ebe9-497b-857d-8f9fb72646ea
# ╠═b62999e7-1824-4b92-9bb6-5718552c0324
# ╠═fb5cfdfb-e267-4b7d-9424-695f8d4c473f
# ╠═25965162-18b3-4dd8-87f1-ab3d2c40802f
# ╠═95c84f7a-b35d-4984-a9aa-bd501a0386f0
# ╠═ea6dbe5b-d968-42d3-a683-2e288f29a754
# ╠═d5b86821-4d9d-4b03-a41a-c1db3c3c6f68
# ╠═d0015e2a-d5f8-4785-969a-fc87dfde33e3
# ╠═c56f7313-4197-4101-b67f-d99b6d70a649
# ╠═07cb55ab-20a0-4d74-9c5d-eb7f6866cbce
# ╠═29442d1a-752e-4412-8aa6-5d74e72a663e
# ╠═839eea8f-d037-410d-b66f-f62f9bffeb04
# ╟─c36f8ac0-4c43-495f-817a-192cfa5f054f
# ╠═9b6f9b64-f3be-4539-9b2b-d0152e8ee82b
# ╠═cc28d8b5-bcaf-445a-bc9d-637e1fc7c410
# ╠═52f90a90-5f0b-4e78-8afb-fcf0539518bc
# ╠═c52302da-c73e-4f39-87f7-839342c1f3f7
# ╠═d2ae2423-b057-4352-9219-c313c85d4166
# ╠═05f45b8b-430b-45fb-9e3f-028cd96c20ae
# ╠═0e714275-9f45-46b5-96a4-761a8f265909
# ╠═7cc57aae-3e74-4b8a-ac0a-fe6d03e88d90
# ╠═bebe3e74-f1d3-4ac6-bb5f-16af579cf810
# ╠═8ed701f9-364a-4cc5-a36d-9f51eea5ffd1
# ╠═5413e075-5a9b-476d-a1ae-7cde1235baed
# ╠═0e21304f-bf0d-497e-8b73-2d931e748abb
# ╠═0af04859-b342-4d3c-b7cf-1891e8e68c27
# ╠═9d3bcf80-9601-4fa7-9601-4c3160af97ca
# ╠═62f50f61-d483-460a-b12d-c30ad3d4d0be
# ╠═b77b41de-0b7d-45be-b4a1-07eefc40beca
# ╠═cbe410ff-7bcc-4043-81ff-1198babd45c8
# ╠═feefac3f-f62e-4783-8264-86b54a08ba3b
# ╠═43ed1d11-f987-4cf1-b575-8e0c49a068d4
# ╠═b9bd7f24-cf50-437e-bbc8-911f5a578fe5
# ╠═36d2f75f-ba4a-46d6-a3f5-0aa9d041e13a
# ╠═bd45d99d-2194-488e-98d1-56ee5cd6f180
# ╠═a7cceb2a-7986-4f8e-915c-4b10d1a22dd3
# ╠═162347d7-5779-4eae-8228-060f26857aae
# ╠═2cc3cc8d-86d4-4fda-9b2e-cf60d3e9c97e
# ╠═d4b6ef06-3af2-48b2-ad0f-2d56c26e8a16
# ╠═2c06cbcc-3bce-4d7d-bac6-963414fc8a74
# ╠═1fa553e1-b23f-4baf-9bf1-97686b944ce5
# ╠═625c506a-93aa-456e-a5ce-c042cc988077
# ╠═9e8dcb73-725f-447f-8666-e342c5408411
# ╠═87ed2d9f-8ab7-45ee-8a64-0cf4254b4535
# ╠═1b8cfd0b-395b-4a01-a190-b024053338d1
# ╠═58419859-140f-42b4-b716-51dad4379462
# ╠═b0c8f19e-3115-4ead-931e-9b5a025e3768
# ╠═fc336075-5dd9-4fad-9ee2-84fc964dd2dd
# ╠═89fc7e92-6cc0-4784-a7f3-7242270fbf89
# ╠═7f61b3c7-bee7-4ddc-af27-6f34daa1957f
# ╠═9e12239b-8d7f-4661-82e6-075931f35289
# ╠═a5ccfd14-79aa-4686-b564-02c2d66d5261
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
