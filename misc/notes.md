# Notes

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

I got a lot of great ideas, particulary the ranking of candidate parsings, from the brilliant and clearly documented Python code by [Hope Ranker](https://github.com/epilanthanomai), generously [published openly](https://github.com/epilanthanomai/hexameter).


