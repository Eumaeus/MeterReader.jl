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
	using MeterReader

	
end

# ╔═╡ e62b66dc-148c-4308-b60b-bc247e6f0c4b
md"""
# MeterReader.jl

[![version 0.3.2](https://img.shields.io/badge/version-0.3-blue.svg)](https://shields.io/) [![175 tests](https://img.shields.io/badge/tests-175-teal.svg)](https://shields.io/) 

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

# ╔═╡ 3ad55654-ef28-415f-8c6f-d7c17a5d1399
md"""
## Playground

Use this area to experiment and test.
"""

# ╔═╡ f9951389-c9da-4a4e-9327-7fe24725b2b0

begin
	v = ["a", "b", "c", "d", "e"]
	slidingv = collect( Iterators.partition(v, 2) )
end

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
occursin("a", "xyz")

# ╔═╡ Cell order:
# ╟─e62b66dc-148c-4308-b60b-bc247e6f0c4b
# ╟─bcd8bdcc-41c3-4e2d-99f1-800b9bd6af20
# ╠═65f585e0-f011-11ef-04ad-23d3a38f9e69
# ╟─d0b2dfce-b64b-4b52-be63-6dc6c8462657
# ╠═8ff4a69c-a659-4aef-9880-111d79af5828
# ╟─3ad55654-ef28-415f-8c6f-d7c17a5d1399
# ╠═f9951389-c9da-4a4e-9327-7fe24725b2b0
# ╠═0d0402b1-3822-4a6a-ba00-1870179d2eb5
# ╠═854130f5-6e88-4bc1-91f4-c6ab49147082
# ╠═340eba5b-e3a7-40e7-9817-391ab30f0d4a
# ╠═bd871bcc-8366-41dc-a917-2718eb8e0ec7
# ╠═1b58510c-e7ba-4570-9a0d-7f4ed84f78a4
# ╠═6cfd3542-6b12-40e5-9f29-b5bb5ba4405a
# ╠═565df2d9-629b-4acd-9320-44e5f512c655
# ╠═a3a8aee8-352f-439f-b347-862a54cc9e2d
