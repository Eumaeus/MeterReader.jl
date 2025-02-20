
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

const _LONG_VOWELS = [
	"h",
	"w"
]

const _SHORT_VOWELS = [
	"e",
	"o"
]

const _AMBIGUOUS_VOWELS = [
	"a",
	"i",
	"u"
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

# Quantities: long, short, ambiguous
const _QUANTITIES = Dict(
	"long" => ("-", ""),
	"short" => ("v", ""),
	"ambiguous" => ("?", ""),
	"error" => ("err", "err")
)



# RULES 
const _FLAGS  =  Dict(
	"ellision" => 0,
	"correption" => 0,
	"hiatus" => 0,
	"ambiguous_vowel" => 0
)

# RULES 
const _RULES  =  Dict(
	"long_vowel" => 0,
	"short_vowel" => 0,
	"closed" => 0,
	"diphthong" => 0,
	"circumflex" => 0,
	"circumflex_on_diphthong" => 0,
	"hiatus" => 0, #diphthong treated as two syllabic vowels
	"hiatus_diaeresis" => 0,
	"hiatus_punctuation" => 0,
	"ellision" => 0,
	"closed_syllable" => 0,
	"synizesis" => 0, # discrete vowels turned into diphthon/long-vowel
	"correption_swapped" => 0, # e.g. "-ου ε-" -> short-long, see 1.14
	"correption_2_short" => 0, # e.g. "-ει ε-" -> short short
	"long_by_position" => 0, # e.g. final-foot trochee
	"rho_cluster" => 0, 
	"lambda_cluster" => 0, 
	"sigma_cluster" => 0,
	"alpha_short" => 0,
	"alpha_long" => 0,
	"iota_short" => 0,
	"iota_long" => 0,
	"upsilon_short" => 0,
	"upsilon_long" => 0,
	"sponaic_5th" => 0,
	"short_no_reason" => 0
)

