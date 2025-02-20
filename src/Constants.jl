
# Punctuation

const _ALLPUNCTUATION = """()[]{}·⸁.,᾽';"?·!–—⸂⸃"""

const _MISCPUNCTUATION = """()[]{}⸁᾽'"?!–—⸂⸃"""

const _COLONPUNCTUATION = """·.,;·!"""

const _SEPARATORS = """ \t\n\r"""

# Character types

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

const _DIACRITICALS = [
  ")", # smooth breathing
  "(", # rough breathing
  "/", # acute
  "=", # circumflex
  "\\", # grave
  "+", # diaeresis
  "|", # iota subscript
  "?", # dot below
]

# Candidates for… 
const _SYNIZESIS = [
	"ew",
	"he"
]

# Candidates for…
const _HIATUS = [
	"hi"
]

# RULES 
const _RULES  = [
	"long vowel",
	"short vowel",
	"diphthong",
	"circumflex",
	"circumflex on diphthong",
	"hiatus", #diphthong treated as two syllabic vowels
	"hiatus, diaeresis in edition",
	"ellision",
	"closed syllable",
	"synizesis", # discrete vowels turned into diphthon/long-vowel
	"correption, values swapped", # e.g. "-ου ε-" -> short-long, see 1.14
	"correption, both short", # e.g. "-ει ε-" -> short short
	"long by position", # e.g. final-foot trochee
	"rho cluster", 
	"lambda cluster", 
	"sigma cluster",
	"alpha treated short",
	"alpha treated long",
	"iota treated short",
	"iota treated long",
	"upsilon treated short",
	"upsilon treated long",
	"sponaic 5th foot",
	"short scans long for no reason",
]

