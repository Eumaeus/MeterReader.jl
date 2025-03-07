### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 65f585e0-f011-11ef-04ad-23d3a38f9e69
begin
	import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
    Pkg.instantiate()

	using Random
	using Unicode
	using Base.Iterators: product
	using BetaReader
	using CitableText
	using CitableCorpus
	using MeterReader

	
end

# ╔═╡ e62b66dc-148c-4308-b60b-bc247e6f0c4b
md"""
# MeterReader.jl

[![version 0.4.1](https://img.shields.io/badge/version-0.4-blue.svg)](https://shields.io/) [![234 tests](https://img.shields.io/badge/tests-234-teal.svg)](https://shields.io/) 

[GitHub](https://github.com/Eumaeus/MeterReader.jl): <https://github.com/Eumaeus/MeterReader.jl>

A [Julia](https://julialang.org) library and [Pluto](https://plutojl.org) notebooks for working with Ancient Greek Dactylic Hexameter, using the [CITE Architecture](https://github.com/cite-architecture) to maintain alignment between analysis and the original text.

## Tutorial

This [Pluto](https://plutojl.org) Notebook provides a tutorial for using [Julia](https://julialang.org) to produce citable metrical analyses of Greek dactylic hexameter.

"""

# ╔═╡ bcd8bdcc-41c3-4e2d-99f1-800b9bd6af20
md"""

### Initialize the Environment

Activate the environment and load some necessary packages.

"""

# ╔═╡ d0b2dfce-b64b-4b52-be63-6dc6c8462657
md"""

### Confirm that it works

`MeterReader` includes a function, `sayhi()`, that exists merely to confirm that everything is loaded correctly. If you see ""Hi, from MeterReader!" in a console, everything is set up right!

"""

# ╔═╡ 8ff4a69c-a659-4aef-9880-111d79af5828
MeterReader.sayhi()

# ╔═╡ 7546b652-9202-407b-8daa-7eb436f734d7
md"""
### Get One Line of Poetry

We can start from plain-test Strings, or from CitablePassage objects (a part of the CITE Architecture library CitableCorpus). 

A CitablePassage consists of a **citation**, in the form of a CTS URN, and some **text**, as a String.

Let's start with a String, and turn it into a CitablePassage. We'll use *Iliad* 1.2.


"""

# ╔═╡ 2a16661b-54b2-4cbb-9114-29714b1e7d50
one_line::String = "urn:cts:greekLit:tlg0012.tlg001.perseus_grc2:1.2#οὐλομένην, ἣ μυρί᾽ Ἀχαιοῖς ἄλγε᾽ ἔθηκε,"

# ╔═╡ 6bfe2b42-08e8-4556-b245-30df1f019203
md"""The string `one_line` has a URN and some poetry, separated by a `#` delimiter. From this String, we can make a CitablePassage."""

# ╔═╡ 92baff16-ab4f-424b-9afd-3fe6813ee8c8
one_citable_object::CitableCorpus.CitablePassage = begin
	
	# Get the URN-string from before the '#' delimiter
	urnstring::String = split(one_line, "#")[1]
	# Turn it into a CtsUrn object
	urn::CtsUrn = CitableText.CtsUrn(urnstring)
	# Get the text of the poetic line from after the '#' delimiter
	mytext::String = split(one_line, "#")[2]
	# Use these to make a CitablePassage
	CitableCorpus.CitablePassage(urn, mytext)
end

# ╔═╡ 47050662-8397-419b-92bd-36b3e993d5d1
md"""
### Prepare for Parsing

A lot of things have to happen before we can parse this line of poetry. 

We could just work with a string-version of the text, but we would lose the ability to relate syllables, quantity, feet, dactyls, spondess, etc. to the characters and words of the original line. 

The library takes care of all of this, with the function `prepare_to_parsing(cp::CitablePassage)` in the file `Parse.jl`.

"""

# ╔═╡ ccff1817-f314-4efb-bb42-671a49c49c36
md"""

#### Our Starting Point for Parsing

We aren't parsing a String, but a `Vector{AnnotatedSyllable}`.

These are initially defined before parsing, and modified as we parse for meter.

"""

# ╔═╡ 7184a27f-ec42-47bf-a9bb-1abc78a37ab1
annotated_syllables::Vector{MeterReader.AnnotatedSyllable} = MeterReader.prepare_to_parse(one_citable_object)

# ╔═╡ 3ad55654-ef28-415f-8c6f-d7c17a5d1399
md"""
## Playground

Use this area to experiment and test.
"""

# ╔═╡ 802f9ac8-d67e-4906-92fa-63ea626dfb79
md"""
#### Sliding, techniques
"""

# ╔═╡ 12f1e8bb-2764-446b-a8be-8f998876aa4e


# ╔═╡ f9951389-c9da-4a4e-9327-7fe24725b2b0
begin
	v = ["a", "b", "c", "d", "e"]
	sliding_windows = slidingv = collect( Iterators.partition(v, 2) )
end

# ╔═╡ c348e5b3-5e73-4500-930e-d38325f02ab4
sliding_windows[1]

# ╔═╡ 6305be43-f842-45cb-8dd0-338624601195
md"""Or we can write a function that does it like Scala."""

# ╔═╡ 0d0402b1-3822-4a6a-ba00-1870179d2eb5
"Implement `sliding()` like in Scala"
function sliding(arr, size, step=1)
    return [arr[i:i+size-1] for i in 1:step:length(arr)-size+1]
end

# ╔═╡ 854130f5-6e88-4bc1-91f4-c6ab49147082
ss = sliding(v, 2)

# ╔═╡ 340eba5b-e3a7-40e7-9817-391ab30f0d4a
s = "μῆνιν"

# ╔═╡ bd871bcc-8366-41dc-a917-2718eb8e0ec7
char_to_find = 'ῆ'

# ╔═╡ 1b58510c-e7ba-4570-9a0d-7f4ed84f78a4
pos = [i for (i, c) in enumerate(s) if c == char_to_find]

# ╔═╡ 6cfd3542-6b12-40e5-9f29-b5bb5ba4405a
push!(v, "f")

# ╔═╡ 565df2d9-629b-4acd-9320-44e5f512c655
xx = ["possible_ellision", "possible_synizesis"]

# ╔═╡ a3a8aee8-352f-439f-b347-862a54cc9e2d


# ╔═╡ cafa3450-895f-4c4a-a082-0eb8fb3a4120
sss = "string"

# ╔═╡ 0a3116a9-256b-4ab8-8159-b6fa813a2947
const _QUANTITIES = Dict(
	"long" => ("-", "—"),
	"short" => ("v", "⏑"),
	"ambiguous" => ("?", "⏓"),
	"error" => ("err", "?"),
	"caesura" => (":", ":")
)

# ╔═╡ 1a27ccf5-035c-42b6-ac56-cdead7d123e1
_QUANTITIES["long"][2]

# ╔═╡ 7eafbca3-9867-473b-bcc4-28a3ba425b12
begin
	x::Int = 7
	y::Int = floor(x / 2)
end

# ╔═╡ a4ab0816-df2d-47ce-afc4-d80ca6af10a9
8 % 2

# ╔═╡ 987f132d-d3f3-4b3f-811c-e7d5412b25b3
repeat("x", 2)

# ╔═╡ 79cc7cd5-42b3-4e63-a80a-0410717376d5
xxx::Int = 8/2

# ╔═╡ d205f472-c8b2-4c12-b659-f7a2b290c79d
floor(7/2) |> typeof

# ╔═╡ 87bef7ee-8525-4b21-af78-11e42aa02498
myvec = [1, 2, 3, 4]

# ╔═╡ 4296616a-cf13-4497-8359-fa0b723829be
map( eachindex(myvec) ) do i
	println(myvec[i])
	myvec[i]
end

# ╔═╡ 4528b3c2-aacb-4436-aeae-9adc536e6665
v1 = [1,2,3,4]

# ╔═╡ 14c905f5-4f71-4a9a-9f93-7ed9e4f40585
v2 = [5,6,7,8]

# ╔═╡ aa8cdd28-502f-42e6-bc1b-c6259c7efabc
union(v1, v2)

# ╔═╡ Cell order:
# ╟─e62b66dc-148c-4308-b60b-bc247e6f0c4b
# ╟─bcd8bdcc-41c3-4e2d-99f1-800b9bd6af20
# ╠═65f585e0-f011-11ef-04ad-23d3a38f9e69
# ╟─d0b2dfce-b64b-4b52-be63-6dc6c8462657
# ╠═8ff4a69c-a659-4aef-9880-111d79af5828
# ╟─7546b652-9202-407b-8daa-7eb436f734d7
# ╠═2a16661b-54b2-4cbb-9114-29714b1e7d50
# ╟─6bfe2b42-08e8-4556-b245-30df1f019203
# ╠═92baff16-ab4f-424b-9afd-3fe6813ee8c8
# ╟─47050662-8397-419b-92bd-36b3e993d5d1
# ╟─ccff1817-f314-4efb-bb42-671a49c49c36
# ╠═7184a27f-ec42-47bf-a9bb-1abc78a37ab1
# ╟─3ad55654-ef28-415f-8c6f-d7c17a5d1399
# ╟─802f9ac8-d67e-4906-92fa-63ea626dfb79
# ╠═12f1e8bb-2764-446b-a8be-8f998876aa4e
# ╠═f9951389-c9da-4a4e-9327-7fe24725b2b0
# ╠═c348e5b3-5e73-4500-930e-d38325f02ab4
# ╠═6305be43-f842-45cb-8dd0-338624601195
# ╠═0d0402b1-3822-4a6a-ba00-1870179d2eb5
# ╠═854130f5-6e88-4bc1-91f4-c6ab49147082
# ╠═340eba5b-e3a7-40e7-9817-391ab30f0d4a
# ╠═bd871bcc-8366-41dc-a917-2718eb8e0ec7
# ╠═1b58510c-e7ba-4570-9a0d-7f4ed84f78a4
# ╠═6cfd3542-6b12-40e5-9f29-b5bb5ba4405a
# ╠═565df2d9-629b-4acd-9320-44e5f512c655
# ╠═a3a8aee8-352f-439f-b347-862a54cc9e2d
# ╠═cafa3450-895f-4c4a-a082-0eb8fb3a4120
# ╠═0a3116a9-256b-4ab8-8159-b6fa813a2947
# ╠═1a27ccf5-035c-42b6-ac56-cdead7d123e1
# ╠═7eafbca3-9867-473b-bcc4-28a3ba425b12
# ╟─a4ab0816-df2d-47ce-afc4-d80ca6af10a9
# ╠═987f132d-d3f3-4b3f-811c-e7d5412b25b3
# ╠═79cc7cd5-42b3-4e63-a80a-0410717376d5
# ╠═d205f472-c8b2-4c12-b659-f7a2b290c79d
# ╠═87bef7ee-8525-4b21-af78-11e42aa02498
# ╠═4296616a-cf13-4497-8359-fa0b723829be
# ╠═4528b3c2-aacb-4436-aeae-9adc536e6665
# ╠═14c905f5-4f71-4a9a-9f93-7ed9e4f40585
# ╠═aa8cdd28-502f-42e6-bc1b-c6259c7efabc
