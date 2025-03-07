# MeterReader.jl

[![version 0.4.1](https://img.shields.io/badge/version-0.4-blue.svg)](https://shields.io/) [![234 tests](https://img.shields.io/badge/tests-234-teal.svg)](https://shields.io/)

A [Julia](https://julialang.org) library and Pluto notebooks for working with Ancient Greek Dactylic Hexameter, using the [CITE Architecture](https://github.com/cite-architecture) to maintain alignment between analysis and the original text.

**Very much a work-in-progress.**

| Task | Status |
|------|--------|
| Tokenize a line | **tested** |
| Categorize each token | **tested** |
| Index and categorize each character | **tested** |
| Expand "double" consonants | **tested** |
| Align characters to tokens | **tested** |
| Synaphoreia of tokens in poetic line | **tested** |
| Basic poetic syllabification | **tested** |
| Quantification of syllables | **tested** |
| Identification of edge cases | in progress  |
| Parsing | in progress |
| Evaulation of candidates | in progress |
| Serialization of parsed poetic lines | partially tested |
| Examples of use | TBD |

## The Pluto Tutorial Notebook

Run the Pluto notebook like this:

- In a terminal, navigate to the `MeterReader.jl` directory.
- At the terminal prompt (`$` or whatever it is), `julia` to start Julia.
- (You can also double-click the Julia icon, if you have installed Julia that way.)
- At the `julia>` prompt, hit `]` to enter package-mode: `pkg>` 
- `pkg> activate .`
- Hit `backspace` to exit package-mode and return to `julia>`
- `julia> Using Pluto`
- `julia> Pluto.run()`
- Your browser should open. In the "Open a notebook" dialog, navigate to `notebooks/Tutorial.jl`. Open it.
- Click "Run notebook code" in the upper-right.
- The notebook should load and run, and you can take it from there.
