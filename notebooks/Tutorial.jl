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

# ╔═╡ Cell order:
# ╟─e62b66dc-148c-4308-b60b-bc247e6f0c4b
# ╟─bcd8bdcc-41c3-4e2d-99f1-800b9bd6af20
# ╠═65f585e0-f011-11ef-04ad-23d3a38f9e69
# ╟─d0b2dfce-b64b-4b52-be63-6dc6c8462657
# ╠═8ff4a69c-a659-4aef-9880-111d79af5828
