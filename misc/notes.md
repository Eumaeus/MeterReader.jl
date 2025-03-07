# Notes

## Vowel Collisions

### First pass…

each d
	-> d (lv)
	-> sv (e.g. -ει-, -οι-, etc.)
	-> sv + sv (hiatus); score determined by punctuation and colons

each ambiguous vowel
	-> sv
	-> lv

### Second pass…

lv + lv
sv + sv
lv + sv
sv + lv


lv + lv
	-> lv (synizesis) score 3
	-> lv + lv (hiatus) score 1
	-> sv + lv (correption) score 2

sv + sv
	-> lv (synizesis) score 2
	-> sv (ellision) score 2
	-> sv + sv (hiatus) score 1

lv + sv
	-> lv (synizesis) score 2
	-> lv + sv (hiatus) score 1
	-> sv + lv (correption) score 3
	-> sv + sv (correption) score 3

sv + lv
	-> lv (synizesis) score 2
	-> sv + lv (hiatus) score 1

## Consonant Clusters

p + l/s

p + l/s
	-> vp - lv
	-> v - plv

## So…

- Pass
	- Closed syllables + next
	- stop - liquid/s?
		vowel+stop, l/s+vowel, mark first closed (score 1)
		vowel, p+p/s+vowel, mark both by basic rules (score 2)
	- otherwise 
		- mark long (score 1)
- Pass
	- each dipthong…
		- no iota? mark long (score 1)
		- iota? mark long( score 1)
		- mark short (only with iota?) score 2 
		- split with hiatus (score 4, w/colon -2, w/diaeresis -3)
			- mark ambiguous vowels in result
- Pass
	- each ambiguous
		- mark long (score 1)
		- mark short (score 2)
- Pass
	- each short
		- mark short(score 1)
		- mark long (score 10)
- Pass
	- each (v + v)
		- see above







## Correption: 

In Latin and Greek poetry, correption (Latin: correptiō [kɔrˈrɛpt̪ioː], "a shortening") is the shortening of a long vowel at the end of one word before a vowel at the beginning of the next. Vowels next to each other in neighboring words are in hiatus.

Homer uses correption in dactylic hexameter:

> Ἄνδρα μοι ἔννεπε, Μοῦσα, πολύτροπον, ὃς μάλα πολλὰ
> πλάγχθ**η, ἐ**πεὶ Τροίης ἱερὸν πτολίεθρον ἔπερσε·
> — Odyssey 1.2

## Synizesis

Synizesis (/ˌsɪnəˈziːsɪs/) is a sound change (metaplasm) in which two originally syllabic vowels (hiatus) are pronounced instead as a single syllable.

## Links

[Good stuff](https://github.com/epilanthanomai/hexameter/blob/master/hexameter.py)

[Scanned Iliad, for reference](https://hypotactic.com/homer/scanned/iliad1scanned.html)

[Dickenson has some good rules](https://dcc.dickinson.edu/grammar/monro/elision-crasis-synizesis)

## Description

To understand Greek epic poetry, it seems necessary to include the metrical scansion of each line along with considerations of vocabulary, morphology, and syntax. A line of text with a schematic representation of scansion is not sufficient for this kind of integrated analysis. This package intends to analyze lines of dactylic hexameter while retaining a *citable* connection between half-line, foot, half-foot, syllable and the text. 

### Discoverable, falsifiable examples.

### Data & Process

- `CitableNode`
- `PoeticLine`
- `IndexedString` & categorized tokens
- `AlignedChar`
- `BasicSyllable`
- `AnnotatedSyllable`
- `PoeticFoot`

Syllabify and initial quantifying.
Parsing via non-deterministic automaton.

["Nondeterministic finite automaton"](https://en.wikipedia.org/wiki/Nondeterministic_finite_automaton). Introduced in 1959 by Michael O. Rabin and Dana Scott: Rabin, M. O.; Scott, D. (April 1959). "Finite Automata and Their Decision Problems". *IBM Journal of Research and Development*. 3 (2): 114–125. doi:10.1147/rd.32.0114

I got a lot of great ideas, particulary the ranking of candidate parsings, from the brilliant and clearly documented Python code by [Hope Ranker](https://github.com/epilanthanomai), generously [published openly](https://github.com/epilanthanomai/hexameter).

## Grok

https://x.com/i/grok/share/rFhVNIGMeZmLkdRQMNDfGyg2F

https://x.com/i/grok/share/WxJDUGsv9tcmJqU7E2D3KFfzu

https://x.com/i/grok/share/tiS6JjhYrebzCewyQDsETSnIl


