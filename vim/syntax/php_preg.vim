" Vim syntax file
" Langauge: Perl-Compatible Regular Expressions extension for PHP
" Maintainer:	Peter Hodge <toomuchphp-vim@yahoo.com>
" Last Change: June 15 2006
"
" Note: This syntax file is part of the php syntax, please see php.vim for
"	    	more information.
"
"	Apology: for the somewhat messy state of this file, I finished this
"	         working alpha version at 2AM last night so I could get it up
"	         on vim.org today, and haven't had time to clean it up yet.
"	         - Peter
"
" ===================================================
"
"
"
"
" This is my 10-minute guide to Perl-Compatible Regular Expressions, and a quick refresher
"	NOTE: PHP double-quoted strings recognize many escape sequences, and I am not
"	even going to TRY and support them yet.  For now, you will have to live with
"	single-quoted strings in one piece (no concatenation using 'this' . 'that' sorry).
"	I hope to add support for double-quoted and multi-part strings in a later version.
"	TODO: Add support for multi-part single-quoted strings.
"	TODO: Add support for double-quoted strings.

function! s:PCREGuide()
	"
	" I. PHP ESCAPING
	"	PHP's single-quoted strings recognize two escape sequences, \\ and \',
	"	and any other escape sequence retains both the backslash and the escaped
	"	character. Therefore the following guidelines apply:
	"		1)	\'		translates as a single quote char to PCRE
	"
	"		2)	\\\'	translates as a backslash and single-quote character to PCRE
	"
	"		3)	\\\\	translates as two backslash characters to PCRE
	"
	"		4)	\a		translates as '\a' to PCRE
	"
	"	-- Ambiguous Escape Sequences: --
	"
	"		5)	\\		translates as a single backslash char to PCRE.  However, this
	"					could also have been written as <backslash> followed by whatever
	"					character you wanted to come next, so you have no need for this 
	"					escape sequence, except as part of \\\\ or \\\'.  Having to
	"					recognize \d and \\d as the same thing would be too much wasted
	"					effort, so I am highlighting this sequence in the 'avoid/ambiguous'
	"					colour.
	"					NOTE: There is an exception to this: once I add support for
	"					multi-part single-quoted strings, you may need \\ before string
	"					concatenation:
	"						preg_match('/\\' . $chr . '/', $subject);
	"				 
	"		6)	\\a		also translates as '\a' to PCRE, so it is highlighted as ambiguous
	"
	"		7)	\\\d	translates to '\\a' to PCRE, which should be done using '\\\\a', so
	"			        it is also highlighted as ambiguous.
	"
	" II. PCRE DELIMITER
	"	According to the PCRE manual this can be any non-alphanumeric character
	"	except backslash: i.e., <space> and the following: !"#$%&'*+,-./:;=?@^_`|~
	"	You can also use <>, (), [], or {} as delimiters.
	"	NOTE: To start with, I am only supporting / and ! as delimiters, which
	"	is already going to mean I have to define several syntax items twice.
	"	I have chosen '/' because it is the most common and it has no other special
	"	meaning, and '!' because it is also common.
	"	NOTE: Even when I DO add support for the remaining delimiters, I will
	"	deliberately ignore the following:
	"
	"		1) <space>	... because even if it *is* valid for PCRE, it's invisible
	"					which makes it very hard to read, and would just be
	"					confusing when there are other delimiters which are much
	"					more readable.
	"					TODO: find out if <space> does work as a delimiter.
	"
	"		2) <single-quote>	... because PCRE pattern /say 'hello'/i
	"							turns into
	"								PCRE 'say \'hello\''i
	"							which becomes
	"								PHP preg_match('\'say \\\'hello\\\'\.\'i', ...);
	"							and *why* you would want to have that horrid mess in
	"							your code is beyond me.
	"
	"		3) ]		... because it breaks character class support.
	"
	"
	" III. PCRE ESCAPING
	"	PCRE has it's own set of escaping rules as well.  Once you've worked out
	"	how PHP's escaped characters will translate into a PCRE regular expression,
	"	you must understand how PCRE will deal with the backslash characters it
	"	receives from PHP.
	"		1) \\	matches a single '\' in the subject
	"
	"		2) \*	or any other non-alphanumeric character matches that character literally.
	"				This form of escaping is safe and consistent for every non-alphanumeric
	"				character and you would do well to use it *everywhere* you want to match
	"				a non-alphanumeric character literally.
	"
	"		3) \<delimiter>	always matches the delimiter character literally.  E.g., If you
	"				use a special character like '*' for the delimiter, you will be unable to
	"				use '*' as a quantifier throughout the rest of the pattern.
	"
	"		4) \x<up to 2 hex digits> is interpreted as the character with that hexidecimal
	"				value.  Naturally, this means that \x, \x0 and \x00 are the same thing.
	"
	"		5) The following escape sequences are interpreted as atoms with special meanings.
	"			\r	...  hex 0D carriage-return
	"			\n	...  hex 0A newline
	"			\t	...  hex 09 tab
	"			\d | \D  any decimal digit | not a decimal digit
	"			\s | \S  any whitespace character | any non-whitespace character
	"			\w | \W  Any word character | any non-word character
	"			\b | \B  Word boundary | not a word boundary
	"			\A  ...  Start of subject
	"			\Z  ...  end of subject with a possible ending \n character.
	"			\z  ...  end of subject WITHOUT an ending \n character.
	"			NOTE: These are valid too, but I have not yet implimented them.
	"			TODO: add these to the guide and syntax.
	"			\a	\c	\e	\f
	"
	"		6) \b is recognized as <backspace> (hex 08) inside a character class. [\b]
	"
	"	-- Escaped Digit Sequences: --
	"
	"		7) \1 through \9 will match previous sub-patterns in the expression.
	"
	"		8) \0<1-2 octal digits> is always interpreted as the character with that
	"				octal value.
	"
	"		9) Any other combination of \<2-3 digits> has a fuzzy interpretation. If the
	"				number could not be octal (contains 8 or 9), then it will only be
	"				interpreted by PCRE as a backreference. Otherwise it will try to be
	"				interpreted as a backreference, but if the sub-pattern hasn't been
	"				captured, then it becomes octal.
	"				NOTE: Therefore, although it might be valid, I will highlight these
	"				fuzzy escape sequence as Ambiguous, because 1) you probably won't
	"				need more than 9 back-references, and 2) you can easily use \x
	"				instead of the octal value.
	"
	"	-- Other Escape Sequences: --
	"
	"		NOTE: Any other escape sequence not mentioned above should be avoided
	"		because they may receive special meaning in a future version of PCRE.
	"		I will highlight them in the Ambiguous/Avoid colour.  (Remember that
	"		this is only referring to <backslash> followed by an alphanumeric
	"		character.
	"
	" IV. PCRE SPECIAL CHARACTERS
	"		* + ? {} are quantifiers.
	"		. is the match-anything wildcard
	"		^ and $ match the start-of-line or end-of-line, respectively
	"		( and ) are the sub-pattern delimiters
	"		[ and ] surround a character class.
	"		# is the comment character, when the 's' option is present, but I
	"			doubt you will use it, so I won't be supporting it yet.
	"
	" V. PCRE SPECIAL SEQUENCES
	"		1) ?	... can follow any other quantifier to make them un-greedy.
	"
	"		2) (?:	... sub-pattern is not captured.
	"
	"		3) (?>	... makes a sub-pattern uncooperative: once it finds a match it will not
	"					retry to help the rest of the pattern match.
	"
	"		4) (?<options>:  ... sub-pattern is not captured and makes use of <options>.
	"
	"		5) (?<options>)  ... Internal options settings, e.g., (?i-m) turns ignore-case ON and multi-line OFF
	"
	"		6) (?= and (?!   ... treat the sub-pattern as a look-ahead assertion.
	"
	"		7) (?<= and (?<! ... treat the sub-pattern as a look-behind assertion.
	"
	"		8) (?(1) yes-pattern | no-pattern)  ... is a conditional sub-pattern which
	"												depends on whether or not the
	"												backreference \1 exists.
	"
	"		9) (?(?=foo) yes-pattern | no-pattern)	...	is another conditional sub-pattern
	"													which depends on the lookahead
	"													assertion succeeding.
	"
	"		10) (?#foo)	... is ignored: it is a form of commenting
	"
	"		11) (?R)	... is a recursive match of the parent sub-expression - it is only
	"						valid inside a sub-pattern.
	"
	"		NOTE: <options> can be any also be in the form of:
	"			(?<options to activate>-<options to turn off>)
	"		So you can use ((?-i)foo) to match 'foo' while ignoring case
	"		sensitivity.
	"
	" VI. PCRE OPTIONS
	"		1)  e	Evaluate replacement strings in preg_replace().
	"				I've never tried this, sounds dangerous though. >8-D
	"
	"		2)  i	Ignore case.
	"
	"		3)  m	Multi-line subject: allows ^ and $ to match at \n chars.
	"
	"		4)  s	Forces . wildcard to match \n chars also.  Probably more
	"				useful within the search pattern than as /foo.bar/s
	"
	"		5)  x	Allows commenting with '#' inside the pattern, useful
	"				for complex, multi-line patterns.
	"				NOTE: I'm explicitly disallowing this flag with the
	"				'ambiguous' highlighting. Version 1 of the PCRE syntax
	"				is not going to support this feature, sorry. You can still
	"				use the (?#comment text) syntax if you want.
	"				TODO: Add support for flag 'x'
	"
	"		6)	u	Pattern is treated as UTF-8 encoding.
	"
	"		7)	A	Anchored: pattern only matches at start of subject.
	"
	"		8)	D	Forces $ to match only at the absolute end of subject.
	"   			Can be overridden by the 'm' option.
	"
	"		9)	S	Perform extra analysis on pattern. Apparently this is good
	"				for finding multiple matches with a variable starting character.
	"
	"		10)	X	Makes invalid escape sequences trigger an error.
	"
	"		11) U	Make the quantifiers 'ungreedy' and makes ungreedy matches like
	"					(foo)*?
	"				behave like greedy matches.
	"
	" ===================================================
	"
	" HOW THE FINISHED COLOURING SHOULD LOOK:
	"
	"	1)	The surrounding single-quote characters will be highlighted
	"		in the regular PHP colour.
	"
	"	2)	The delimiter will have its own colour and will also appear
	"		in this colour when it is escaped inside the pattern.
	"
	"	3)	The options characters will have their own colour and will
	"		be highlighted after the ending delimiter and also when
	"		they appear inside the pattern.
	"
	"	4)	Escape characters which match literally will have their own
	"		colour.
	"
	"	5)	Character class delimiters will have their own colour, which
	"		will be shared with the circumflex when it is used to invert
	"		the character class, and also the - when it is used to indicate
	"		a character range inside the character class.
	"
	" ===================================================
	"
	" The syntax file is written in the following order:
	"
	" 1) match group for the PCRE functions and the single-quoted string
	"		which is the PCRE pattern.
	" 2) match group for the possible delimiters inside the pattern.
	" 3) match group for escaped special characters inside the pattern
	" 4) match group for quantifiers inside the pattern
	" 5) match group for character classes inside the pattern
	"	a) match group for - when it is used as a range indicator
	"	b) match group for \ when it is used to add a special character
	"		to the character class literally
	"	c) match group for \b inside character classes.
	"
	"
	" 998) match group for super-escape sequences inside the pattern.
	" 999) match group for the escaped delimiter inside the pattern.
endfunction

if 0
function! s:everything()
	" look for an escaped special character inside the string
	syntax match pregEscape /\c\\[^\\a-z0-9_ ]/ containedin=@pregString_any nextgroup=@pregQuantifier_any

	" highlight regular atoms
	"syntax match pregAtom /\c[^\\]/ containedin=@pregString_any nextgroup=@pregQuantifier_any

	" look for special characters and escape sequences
	syntax match pregSpecial /[$^|.]/ containedin=@pregString_any

	"syntax region phpPREGStringContents matchgroup=Statement start=/'\@<=\z([^"'a-z0-9\\]\)/ end=/\z1/ contained nextgroup=phpPREGStringFlagsError oneline
	"syntax match phpPREGStringContentsBetween /\v\\(.).{-}\\\1/me=e-2 contained nextgroup=phpPREGStringContentsBetween,phpPREGStringContentsToEnd keepend
	"syntax match phpPREGStringContentsToEnd /\v\\(.)%([^\\]|\\.\1@<!){-}\1@=/ contained nextgroup=phpPREGStringContentsEnd keepend
	"syntax match phpPREGStringContentsEnd /./ contained nextgroup=phpPREGStringFlagsError
	"syntax match phpPREGStringContentsStart /\v\c\'@<=([^"'a-z0-9\\]).{-}\\\1/me=e-2 contained nextgroup=phpPREGStringContentsBetween,phpPREGStringContentsToEnd keepend
	"syntax match phpPREGStringContentsAtOnce /\v\c\'@<=([^"'a-z0-9\\])\1@=/ contained nextgroup=phpPREGStringFlagsError keepend
	"%([^\\]|\\\1@!.)?
	"hi link phpPREGStringContentsAtOnce pregDelimiter
	"hi link phpPREGStringContentsStart phpPREGStringContentsAtOnce
	"hi link phpPREGStringContentsBetween phpPREGStringContentsStart
	"hi link phpPREGStringContentsToEnd phpPREGStringContentsBetween
	"hi link phpPREGStringContentsEnd phpPREGStringContentsBetween

	" highlight characters inside the string
	"syntax match phpPREGStringContentsAll /\(.\).\{-}\1/ms=s+1,me=e-1 containedin=phpPREGStringContentsAtOnce
	"syntax match phpPREGStringContentsAll /\(.\).\{-}\\\1/ms=s+1,me=e-2 containedin=phpPREGStringContentsStart
	"syntax match phpPREGStringContentsAll /\\\(.\).\{-}\\\1/ms=s+2,me=e-2 containedin=phpPREGStringContentsBetween
	"syntax match phpPREGStringContentsAll /\\\(.\).\{-}\1/ms=s+2,me=e-1 containedin=phpPREGStringContentsToEnd
	"hi link phpPREGStringContentsAll pregError

	" special characters in the string
	" the '.' wildcard can be followed by a quantifier
	"syntax match phpPREGSpecial /[.|^$]/ contained containedin=phpPREGStringContentsAll
	"hi link phpPREGSpecial pregSpecial

	" regular atoms elements
	" TODO: look these up in the manual
	syntax match phpPREGStringChar /[^)\]}\\*?+|.]/ contained containedin=phpPREGStringContentsAll
	hi link phpPREGStringChar pregPattern

	" valid escape sequences under this match
	" TODO: look these up in the manual
	syntax match phpPREGEscapeSequenceWithoutQuantifier /\\([^a-zA-Z0-9_]|[dsw])[{*+?]\@!/ contained containedin=phpPREGStringContentsAll
	hi link phpPREGEscapeSequenceWithoutQuantifier pregEscape



	" highlight '(' and ')' with optional lookahead '(?'

	" highlight sets [a-z]
	"syntax region phpPREGSetExclusive matchgroup=pregSetParent start=/\[\^/ end=/\]/ containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierOnly
	"hi link phpPREGSetInclusive pregSetInclusive
	"hi link phpPREGSetExclusive pregSetExclusive


	" quantifiers: * + ? and {1,2}
	"syntax cluster pregQuantifier_any add=pregQuantifierSimple
	"syntax match pregQuantifierIllegal /[*+?]/ containedin=@pregString_any
	"hi link pregQuantifierSimple pregQuantifier
	"hi link pregQuantifierComplex pregQuantifier
	"hi link pregQuantifierIllegal pregError

	" TODO: look up real basic atoms using manual
	"syntax match phpPREGAtomWithQuantifier /\c[a-z0-9_ #/][{*+?]/ contained containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"syntax match phpPREGAtomWithQuantifier /\C\\[s][{*+?]/ contained containedin=phpPREGStringContentsAll
	"syntax match phpPREGAtomWithQuantifier /\\\\\\\\[{*+?]/ contained containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"syntax match phpPREGAtomWithQuantifier /\\\\\\\'[{*+?]/ contained containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"syntax match phpPREGAtomWithQuantifier /\\\'[{*+?]/ contained containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"syntax match phpPREGAtomWithQuantifier /\.[{*+?]/ contained containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"syntax match phpPREGAtomWithQuantifier /\\[$^:.*+?{}()\[\]dsw][{*+?]/ contained containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"hi link phpPREGAtomWithQuantifier pregQuantifier

	" allow the quantifier all on its own if preceded by an escaped character (this is
	" to match the circumstance where the delimiter is repeated)
	"syntax match phpPREGQuantifierAfterDelimiter /\v%(\\.)@<=[{*+?]/ containedin=phpPREGStringContentsAll nextgroup=phpPREGQuantifierComplex
	"hi link phpPREGQuantifierAfterDelimiter pregQuantifier

	"syntax match phpPREGQuantifierComplex /\v\{@<=\d*%(,\d*)?\}/ contained
	"syntax match phpPREGQuantifierComplex /\V4}/ contained
	"syntax match phpPREGQuantifierComplexTail /\}/ containedin=phpPREGQuantifierComplex
	"syntax match phpPREGQuantifierComplexComma /,/ containedin=phpPREGQuantifierComplex
	"hi link phpPREGQuantifierComplex pregQuantifierComplex
	"hi link phpPREGQuantifierComplexTail pregQuantifier
	"hi link phpPREGQuantifierComplexComma pregQuantifier

	" quantifier on its own ... needs to be included by a 'nextgroup='
	"syntax match phpPREGQuantifierOnly /[{*+?]/ contained nextgroup=phpPREGQuantifierComplex
	"hi link phpPREGQuantifierOnly pregQuantifier

	" The string '/\\\x/' is ambiguous, but the only way to find it is like this:
	" (doing it like the other Avoid above will cause matches at the escaped delimiters)
	"syntax match phpPREGAtomAfterAmbiguousEscape /\v%([^\\]\\\\)@<=\\[^\\]/ contained containedin=phpPREGStringContentsAll
	"hi link phpPREGAtomAfterAmbiguousEscape pregAvoid

	" delimiters are here at the end to make sure they match with highest priority:


	" look for a character class (set)
	syntax cluster pregSetContents add=pregSetInc_2f,pregSetExc_2f
	syntax region pregSetInc_2f matchgroup=pregSetParent start=/\v\[\^@!/ end=/\]/ skip=/\\]/ containedin=pregString_2f
	syntax region pregSetExc_2f matchgroup=pregSetParent start=/\v\[\^/   end=/\]/ skip=/\\]/ containedin=pregString_2f
	hi link pregSetInc_2f pregSetInc
	hi link pregSetExc_2f pregSetExc

	" range character in a character class.
	syntax match pregSetRange /-/ containedin=@pregSetContents

	" invalid escape sequences (all by default)
	syntax match pregSetEscapeInvalid /\\./ containedin=@pregSetContents
	hi link pregSetEscapeInvalid pregAmbiguous

	" literal escape sequences (give the escaped character its
	" literal meaning)
	syntax match pregSetEscapeLiteral /\\[\-\^\\\]]/ containedin=@pregSetContents

	" special escape sequences (give the escaped chracter a special meaning)
	syntax match pregSetEscapeSpecial /\C\\[rntdDsSwWb]/ containedin=@pregSetContents

	" TODO: add hex digit matching here

	" look for the escaped delimiter
	syntax match pregDelimiterEscaped +\\/+ containedin=pregString_2f,pregSetInc_2f,pregSetExc_2f nextgroup=@pregQuantifier_any

	" look for super escaping in ranges
	"syntax match pregSetEscapeSuper /\\\\\\[\\']/ containedin=@pregSetContents contains=pregSetEscapeSuperEscapedPart
	"syntax match pregSetEscapeSuperEscapedPart /\\./hs=s+1 contained
	"syntax match pregEscapeSuper /\\'/ containedin=@pregString_any contains=pregEscapeSuperAtomPart nextgroup=@pregQuantifier_any
	"syntax match pregEscapeSuperAtomPart /\\./hs=s+1
	"hi link pregSetEscapeSuperEscapedPart pregSetEscapeLiteral
	"hi link pregSetEscapeSuperAtomPart pregSetAtom

	" super-escaping to avoid:
	syntax match pregEscapeSuperAmbiguous /\\\\[^\\]/ containedin=@pregString_any
	syntax match pregEscapeSuperAmbiguous /\\\\\\[^\\']/ containedin=@pregString_any


	" highlight linkings:

	hi link pregPattern Normal

	"hi link pregPattern Normal

	hi link pregEscapeLiteral Comment
	hi link pregEscapeSpecial Special

	hi link pregEscapePHP Type
	hi link pregEscapeAmbiguous pregAmbiguous
	hi link pregEscapeUnknown pregAmbiguous

	hi link pregSpecial Operator
	"hi link pregParent Identifier
	hi link pregSetParent Operator
	hi link pregSetInc PreProc
	hi link pregSetExc String
	hi link pregSetRange Operator
	hi link pregSetEscapeAmbiguous pregAmbiguous
	hi link pregSetEscapeLiteral pregEscapeLiteral
	hi link pregSetEscapeSpecial pregEscapeSpecial
	hi link pregSetEscapeDelimiter pregDelimiterEscaped
	"hi link pregSetInclusive Normal
	"hi link pregSetExclusive Normal
endfunction
endif

function! s:FindPregParens()
	syntax match pregParens /(?\?/ containedin=@pregString_any
	syntax match pregParens /)/ containedin=@pregString_any
endfunction

function! s:FindPregOptions()
	" highlight options
	syntax match pregOptionError /[^']*/ contained contains=pregOption
	syntax match pregOption /\C[eimsuxADSUX]\+/ contained
endfunction

function! s:FindPregSpecial()
	" look for special characters
	syntax match pregSpecial /[$^|.]/ containedin=@pregString_any

	" look for the dash inside a class
	syntax match pregSpecial /-/ containedin=@pregClass_any
endfunction

function! s:FindPregEscape()
	" look for any escape sequence inside the pattern and mark them as errors
	" by default, all escape sequences are errors
	syntax match pregEscapeUnknown /\\./ containedin=@pregString_any

	syntax cluster pregClass_any add=@pregClassInc_any,@pregClassExc_any

	syntax match pregClassEscapeUnknown /\\[^\^\-\]]/ containedin=@pregClass_any
	syntax match pregClassEscape /\\[\^\-\]]/he=s+1 containedin=@pregClass_any
	syntax match pregClassIncEscapeKnown /\C\\[brntdswDSW]/ containedin=@pregClassInc_any
	syntax match pregClassExcEscapeKnown /\C\\[brntdswDSW]/ containedin=@pregClassExc_any

	syntax match pregClassEscapeSingleQuote /\\'/ transparent containedin=@pregClass_any contains=pregEscapePHP
	syntax match pregClassEscapeSingleQuoteAmbiguous /\\\\\\'/ containedin=@pregClass_any
	hi link pregClassEscapeSingleQuoteAmbiguous pregEscapeAmbiguous

	syntax match pregClassEscapeDouble1 /\v\\\\(\\\\)@=/ containedin=@pregClass_any contains=pregEscapePHP
		\ nextgroup=pregClassEscapeDouble2
	syntax match pregClassEscapeDouble2 /\\\\/ transparent contained contains=pregEscapePHP
	hi link pregClassEscapeDouble1 pregClassEscape

	" in the unknown escapes, match those that make a special character
	" take on its literal meaning (except for <single-quote> which is covered next)
	syntax match pregEscapeLiteral /\c\v\\[^a-z0-9_']/ containedin=pregEscapeUnknown
	syntax match pregEscapeLiteral /\\\\\\[\\']/ containedin=pregEscapeUnknown

	syntax match pregEscapeSingleQuote /\\'/ containedin=pregEscapeUnknown

	" match the escaped strings which are known
	syntax match pregEscapeSpecial /\C\\[rntdswbzDSWBAZ]/ containedin=pregEscapeUnknown
	syntax match pregBackreference /\\[1-9][0-9]\@!/ containedin=pregEscapeUnknown

	" match the PHP escaping in literal escapes
	syntax match pregEscapePHP /\\[\\']/he=s+1 containedin=pregEscapeLiteral,pregEscapeSingleQuote
	"syntax match pregEscapeSuperMatch /\\'/ transparent containedin=pregEscapeLiteral contains=pregEscapeSuper
	"syntax match pregEscapeSuper /\\./he=s+1 containedin=pregEscapeSuperMatch

	" these can be found inside super-escapes and give the escaped
	" characer the correct colour

	" this captures confusing usage of escape characters
	syntax match pregEscapeAmbiguous /\\\\[^\\]/ containedin=@pregString_any
	syntax match pregEscapeAmbiguous /\\\\\\[^\\']/ containedin=@pregString_any
endfunction

function! s:FindPregQuantifiers()
	syntax match pregQuantifier /[*+?]?\?/ containedin=@pregString_any
	syntax match pregQuantifierComplex /{\d*\(,\d*\)\?}/ containedin=@pregString_any
	syntax match pregQuantifier /\d\+/ containedin=pregQuantifierComplex
endfunction

function! s:FindPregStrings()
	" TODO: impliment functions other than preg_match
	syntax case ignore
	syntax keyword phpPREGFunctions containedin=phpParent,phpRegion nextgroup=phpPREGOpenParent
		\ preg_match preg_split preg_match_all preg_replace preg_replace_callback

	" highlight the opening parenthesis (just because I have to)
	syntax match phpPREGOpenParent "(" contained nextgroup=phpPREGStringSingle

	" match a phpString (single-quoted) which is able to contain a pregString_any
	syntax region phpPREGStringSingle matchgroup=phpQuoteSingle start=+'+ skip=+\\\\\|\\'+ end=+'+ keepend
		\ contained contains=@pregString_any
endfunction

function! s:FindPregDelimiter()
	call s:FindPregDelimiter_21()
	call s:FindPregDelimiter_2f()
	call s:FindPregDelimiter_7e()

	syntax match pregEscapeDelimiter /\\./he=s+1 containedin=@pregEscapeDelimiter_any
endfunction

function! s:FindPregDelimiter_any(name, findchar)
	" look for a / delimiter inside the string
	let l:exec = 'function! s:FindPregDelimiter_' . a:name . '()'
		\ . "\n"
		\ . 'syntax cluster pregString_any add=pregString_' . a:name
		\ . "\n"
		\ . 'syntax region pregString_' . a:name
		\ . ' matchgroup=pregDelimiter'
		\ . " start=\"'\@<=" . a:findchar . '"'
		\ . ' skip="\\\\\|\\' . a:findchar . '"'
		\ . ' end="' . a:findchar . '"'
		\ . ' contained keepend contains=pregEscapeDelimiter_' . a:name
		\ . ' nextgroup=pregOptionError'
		\ . "\n"
		\ . 'hi link pregString_' . a:name . ' pregPattern'
		\ . "\n"

	" match for the escaped delimiter
	"syntax cluster pregEscapeDelimiter add=pregEscapeDelimiter_2f
	"syntax match pregEscapeDelimiter_2f +\\/+he=s+1 contained
	let l:exec .= 'syntax cluster pregEscapeDelimiter_any add=pregEscapeDelimiter_' . a:name
		\ . "\n"
		\ . 'syntax match pregEscapeDelimiter_' . a:name
		\ . ' "\\' . a:findchar . '" contained containedin=pregString_' . a:name
		\ . "\n"
		\ . 'hi link pregEscapeDelimiter_' . a:name . ' pregEscapeLiteral'
		\ . "\n"
		\ . 'endfunction'

	execute l:exec
endfunction

function! s:FindPregDelimiter_2f()
	" look for a / delimiter inside the string
	syntax cluster pregString_any add=pregString_2f
	syntax region pregString_2f matchgroup=pregDelimiter start=+'\@<=/+ skip=+\\\\\|\\/+ end=+/+
		\ contained keepend contains=pregEscapeDelimiter_2f nextgroup=pregOptionError
	hi link pregString_2f pregPattern

	" match for the escaped delimiter
	"syntax cluster pregEscapeDelimiter add=pregEscapeDelimiter_2f
	"syntax match pregEscapeDelimiter_2f +\\/+he=s+1 contained
	syntax cluster pregEscapeDelimiter_any add=pregEscapeDelimiter_2f
	syntax match pregEscapeDelimiter_2f +\\/+ contained containedin=pregString_2f
	hi link pregEscapeDelimiter_2f pregEscapeLiteral

	" add a match group for the class set
	syntax cluster pregClassInc_any add=pregClassInc_2f
	syntax region pregClassInc_2f matchgroup=pregClassParent start=/\[\^\@!/ end=/\]/ skip=/\\]/
		\ containedin=pregString_2f
	hi link pregClassInc_2f pregClassInc

	syntax cluster pregClassExc_any add=pregClassExc_2f
	syntax region pregClassExc_2f matchgroup=pregClassParent start=/\[\^/ end=/\]/ skip=/\\]/
		\ containedin=pregString_2f
	hi link pregClassExc_2f pregClassExc

	" add a match for the escaped delimiter inside a class set
	syntax match pregClassEscapeDelimiter_2f +\\/+he=s+1 containedin=pregClassInc_2f,pregClassExc_2f
		\ contains=pregEscapeDelimiter
endfunction

function! s:FindPregDelimiter_7e()
	" look for a ~ delimiter inside the string
	syntax cluster pregString_any add=pregString_7e
	syntax region pregString_7e matchgroup=pregDelimiter start=+'\@<=\~+ skip=+\\\\\|\\\~+ end=+\~+
		\ contained keepend contains=pregEscapeDelimiter_7e nextgroup=pregOptionError
	hi link pregString_7e pregPattern

	" match for the escaped delimiter
	"syntax cluster pregEscapeDelimiter add=pregEscapeDelimiter_7e
	"syntax match pregEscapeDelimiter_7e +\\\~+he=s+1 contained
	syntax cluster pregEscapeDelimiter_any add=pregEscapeDelimiter_7e
	syntax match pregEscapeDelimiter_7e +\\\~+ contained containedin=pregString_7e
	hi link pregEscapeDelimiter_7e pregEscapeLiteral

	" add a match group for the class set
	syntax cluster pregClassInc_any add=pregClassInc_7e
	syntax region pregClassInc_7e matchgroup=pregClassParent start=/\[\^\@!/ end=/\]/ skip=/\\]/
		\ containedin=pregString_7e
	hi link pregClassInc_7e pregClassInc

	syntax cluster pregClassExc_any add=pregClassExc_7e
	syntax region pregClassExc_7e matchgroup=pregClassParent start=/\[\^/ end=/\]/ skip=/\\]/
		\ containedin=pregString_7e
	hi link pregClassExc_7e pregClassExc

	" add a match for the escaped delimiter inside a class set
	syntax match pregClassEscapeDelimiter_7e +\\\~+he=s+1 containedin=pregClassInc_7e,pregClassExc_7e
		\ contains=pregEscapeDelimiter
endfunction

function! s:FindPregDelimiter_21()
	" look for a ! delimiter inside the string
	syntax cluster pregString_any add=pregString_21
	syntax region pregString_21 matchgroup=pregDelimiter start=+'\@<=!+ skip=+\\\\\|\\!+ end=+!+
		\ contained keepend contains=pregEscapeDelimiter_21 nextgroup=pregOptionError
	hi link pregString_21 pregPattern

	" match for the escaped delimiter
	"syntax cluster pregEscapeDelimiter add=pregEscapeDelimiter_21
	"syntax match pregEscapeDelimiter_21 +\\!+he=s+1 contained
	syntax cluster pregEscapeDelimiter_any add=pregEscapeDelimiter_21
	syntax match pregEscapeDelimiter_21 +\\!+ contained containedin=pregString_21
	hi link pregEscapeDelimiter_21 pregEscapeLiteral

	" add a match group for the class set
	syntax cluster pregClassInc_any add=pregClassInc_21
	syntax region pregClassInc_21 matchgroup=pregClassParent start=/\[\^\@!/ end=/\]/ skip=/\\]/
		\ containedin=pregString_21
	hi link pregClassInc_21 pregClassInc

	syntax cluster pregClassExc_any add=pregClassExc_21
	syntax region pregClassExc_21 matchgroup=pregClassParent start=/\[\^/ end=/\]/ skip=/\\]/
		\ containedin=pregString_21
	hi link pregClassExc_21 pregClassExc

	" add a match for the escaped delimiter inside a class set
	syntax match pregClassEscapeDelimiter_21 +\\!+he=s+1 containedin=pregClassInc_21,pregClassExc_21
		\ contains=pregEscapeDelimiter
endfunction

function! s:HiLinks()
	command -nargs=+ HiLink hi link <args>

	HiLink phpPREGFunctions phpFunctions
	HiLink phpPREGOpenParent phpParent
	HiLink phpPREGStringSingle phpStringSingle

	HiLink pregError Error
	HiLink pregAmbiguous Todo

	HiLink pregDelimiter Statement

	HiLink pregOptionError Error
	HiLink pregOption Type

	HiLink pregEscapeDelimiter pregDelimiter
	HiLink pregEscapeUnknown pregAmbiguous
	HiLink pregEscapeLiteral Comment
	HiLink pregEscapeSpecial pregSpecial
	HiLink pregEscapePHP Type
	HiLink pregEscapeSingleQuote pregPattern
	HiLink pregEscapeAmbiguous pregAmbiguous

	HiLink pregPattern Normal
	HiLink pregSpecial PreProc
	HiLink pregParens pregSpecial
	HiLink pregBackreference pregParens

	HiLink pregQuantifier pregBackreference
	HiLink pregQuantifierComplex pregBackreference

	HiLink pregClassParent pregParens
	HiLink pregClassInc Function
	HiLink pregClassExc String
	HiLink pregClassEscape pregParens
	HiLink pregClassIncEscapeKnown Type
	HiLink pregClassExcEscapeKnown Statement
	HiLink pregClassEscapeUnknown pregAmbiguous

	delcommand HiLink
endfunction

call s:FindPregEscape()
call s:FindPregSpecial()
call s:FindPregQuantifiers()
call s:FindPregParens()

call s:FindPregStrings()
call s:FindPregDelimiter()
call s:FindPregOptions()

call s:HiLinks()
"
" vim: ts=2 sts=2 sw=2 expandtab
