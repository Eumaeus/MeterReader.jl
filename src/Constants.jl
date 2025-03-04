
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
	"long" => ("-", "—"),
	"short" => ("v", "⏑"),
	"ambiguous" => ("?", "⏓"),
	"error" => ("err", "?"),
	"caesura" => (":", "⁝")
)

const _FOOTLABLE = Dict(
	"spondee" => ("— —"),
	"dactyl" => ("— ⏑ ⏑"),
	"trochee" => ("— ⏑"),
	"iamb" => ("⏑ —"),
	"tribrach" => ("⏑ ⏑ ⏑"),
	"anapaest" => ("⏑ ⏑ —"),
	"amphibrach" => ("⏑ — ⏑"),
	"bacchius" => ("⏑ — —"),
	"cretic" => ("— ⏑ —"),
	"antibacchius" => ("— ⏑ ⏑"),
	"molossus" => ("— — —"),
	"error" => ("xxx")
)

# Reference ⏐ ⏑ ⏒ ⏓ ⏔ ⏕ ⏖ —


# RULES 
const _FLAGS  =  Dict(
	"possible_ellision" => 0,
	"possible_correption" => 0,
	"possible_hiatus" => 0,
	"possible_synizesis" => 0,
	"ambiguous_vowel" => 0,
	"wordbreak_after" => 0,
	"caesurea_after" => 0,
	"colon_after" => 0,
	"closed_syllable" => 0,
	"trochaic_sixth" => 0,
	"spondaic_sixth" => 0
)

# RULES 
const _RULES  =  Dict(
	"long_vowel" => 0,
	"short_vowel" => 0,
	"closed_syllable" => 0, 
	"diphthong" => 0,
	"circumflex" => 0,
	"circumflex_on_diphthong" => 0,
	"hiatus" => 4, #diphthong treated as two syllabic vowels
	"hiatus_w_diaeresis" => 1, 
	"hiatus_w_punctuation" => 2,
	"ellision_short" => 1, # two short vowels to one short vowel
	"synizesis" => 2, # discrete vowels turned into diphthon/long-vowel
	"correption_swapped" => 2, # e.g. "-ου ε-" -> short-long, see 1.14
	"correption_short" => 2, # e.g. "-ει ε-" -> short short
	"attic_correption" => 2, # vowel-mute-liquid-short = short-long, Aphrodite
	"word-initial_cluster" => 2, # [Sk-], [Sd-], etc. treated as one consonant
	"long_by_position" => 0, # e.g. final-foot trochee treated as spondee
	"stop_rho_short" => 1, 
	"stop_lambda_short" => 1, 
	"short_oi_diphthong" => 1,
	"sigma_stop_short" => 1,
	"long_before_rho" => 1,
	"long_before_lambda" => 1,
	"long_before_mu" => 1,
	"long_before_nu" => 1,
	"long_before_sigma" => 1,
	"long_before_delta" => 1,
	"long_final_alpha" => 1,
	"long_final_alpha_after_epsilon" => 1,
	"final_iota_long" => 1,
	"alpha_short" => 0,
	"alpha_long" => 0,
	"iota_short" => 0,
	"iota_long" => 0,
	"upsilon_short" => 0,
	"upsilon_long" => 0,
	"sponaic_5th" => 1,
	"arsis" => 3, # ??? short acting as long arsis
	"arsis_before_hws" => 2,
	"arsis_after_long_vowel" => 2,
	"arsis_final_with_nu" => 2,# e.g. ἔφαν ἀπιόντες
)

