" Vim syntax file
" Language:	Gosu
" Maintainer:   vim-gosu community	
" URL:		http://github.com/colmcdonagh/vim-gosu/syntax/gosu.vim

" Please check :help gosu.vim for comments on some of the options available.

" quit when a syntax file was already loaded
if !exists("main_syntax")
  if exists("b:current_syntax")
    finish
  endif
  " we define it here so that included files can test for it
  let main_syntax='gosu'
  syn region gosuFold start="{" end="}" transparent fold
endif

let s:cpo_save = &cpo
set cpo&vim

" some characters that cannot be in a java program (outside a string)
syn match gosuError "[@`]"
syn match gosuError "<<<\|\.\.\|=>\|||=\|&&=\|\*\/"

syn match gosuOK "\.\.\."
syn match gosuOK "<>"

" use separate name so that it may be deleted in compiler gosu.vim, if
" implemented at later point.
syn match   gosuError2 "#\|=<"
hi def link gosuError2 gosuError


" keyword definitions
" gosu definitions
syn keyword gosuType            var property get set delegate
syn keyword gosuStorageClass    readonly
syn keyword gosuSpecial         in as using represents
syn keyword gosuFunc            print construct function
syn keyword gosuExternal        uses
syn keyword gosuConstant        classpath
syn keyword gosuRepeat		params
syn match gosuShebang		"#!\s.*$"		 
syn keyword gosuOperator	\->
syn keyword gosuClassDecl	enhancement

" java definitions
syn keyword javaExternal	native package
syn match javaExternal		"\<import\>\(\s\+static\>\)\?"
syn keyword javaError		goto const
syn keyword javaConditional	if else switch
syn keyword javaRepeat		while for do
syn keyword javaBoolean		true false
syn keyword javaConstant	null
syn keyword javaTypedef		this super
syn keyword javaOperator	new instanceof
syn keyword javaType		boolean char byte short int long float double
syn keyword javaType		void
syn keyword javaStatement	return
syn keyword javaStorageClass	static synchronized transient volatile final strictfp serializable
syn keyword javaExceptions	throw try catch finally
syn keyword javaAssert		assert
syn keyword javaMethodDecl	synchronized throws
syn keyword javaClassDecl	extends implements interface
" to differentiate the keyword class from MyClass.class we use a match here
syn match   javaTypedef		"\.\s*\<class\>"ms=s+1
syn keyword javaClassDecl	enum
syn match   javaClassDecl	"^class\>"
syn match   javaClassDecl	"[^.]\s*\<class\>"ms=s+1
syn match   javaAnnotation	"@\([_$a-zA-Z][_$a-zA-Z0-9]*\.\)*[_$a-zA-Z][_$a-zA-Z0-9]*\>\(([^)]*)\)\=" contains=javaString
syn match   javaClassDecl	"@interface\>"
syn keyword javaBranch		break continue nextgroup=gosuUserLabelRef skipwhite
syn match   gosuUserLabelRef	"\k\+" contained
syn match   javaVarArg		"\.\.\."
syn keyword javaScopeDecl	public protected private abstract

if exists("gosu_highlight_java_lang_ids")
  let gosu_highlight_all=1
endif
if exists("gosu_highlight_all")  || exists("gosu_highlight_java")  || exists("gosu_highlight_java_lang") 
  " java.lang.*
  syn match javaLangClass "\<System\>"

  syn keyword javaLangObject clone equals finalize getClass hashCode
  syn keyword javaLangObject notify notifyAll toString wait
  hi def link javaLangObject		     javaConstant
  syn cluster javaTop add=javaLangObject
endif

if exists("gosu_space_errors")
  if !exists("gosu_no_trail_space_error")
    syn match	javaSpaceError	"\s\+$"
  endif
  if !exists("gosu_no_tab_space_error")
    syn match	javaSpaceError	" \+\t"me=e-1
  endif
endif

syn region  gosuLabelRegion	transparent matchgroup=gosuLabel start="\<case\>" matchgroup=NONE end=":" contains=javaNumber,javaCharacter,javaString
syn match   gosuUserLabel	"^\s*[_$a-zA-Z][_$a-zA-Z0-9_]*\s*:"he=e-1 contains=gosuLabel
syn keyword gosuLabel		default

" highlighting C++ keywords as errors removed, too many people find it
" annoying.  Was: if !exists("java_allow_cpp_keywords")

" The following cluster contains all java groups except the contained ones
syn cluster javaTop add=gosuExternal,javaExternal,gosuError,javaError,javaError,javaBranch,gosuLabelRegion,gosuLabel,javaConditional,javaRepeat,javaBoolean,gosuConstant,javaConstant,javaTypedef,javaOperator,gosuType,gosuSpecial,javaType,javaType,javaStatement,gosuStorageClass,javaStorageClass,javaAssert,javaExceptions,gosuFunc,javaMethodDecl,javaClassDecl,javaClassDecl,javaClassDecl,javaScopeDecl,javaError,javaError2,gosuUserLabel,javaLangObject,javaAnnotation,javaVarArg


" Comments
syn keyword gosuTodo		 contained TODO FIXME XXX
if exists("gosu_comment_strings")
  syn region  gosuCommentString    contained start=+"+ end=+"+ end=+$+ end=+\*/+me=s-1,he=s-1 contains=javaSpecial,javaCommentStar,javaSpecialChar,@Spell
  syn region  javaComment2String   contained start=+"+	end=+$\|"+  contains=javaSpecial,javaSpecialChar,@Spell
  syn match   javaCommentCharacter contained "'\\[^']\{1,6\}'" contains=javaSpecialChar
  syn match   javaCommentCharacter contained "'\\''" contains=javaSpecialChar
  syn match   javaCommentCharacter contained "'[^\\]'"
  syn cluster javaCommentSpecial add=gosuCommentString,javaCommentCharacter,javaNumber
  syn cluster javaCommentSpecial2 add=javaComment2String,javaCommentCharacter,javaNumber
endif
syn region  javaComment		 start="/\*"  end="\*/" contains=@javaCommentSpecial,javaTodo,@Spell
syn match   javaCommentStar	 contained "^\s*\*[^/]"me=e-1
syn match   javaCommentStar	 contained "^\s*\*$"
syn match   javaLineComment	 "//.*" contains=@javaCommentSpecial2,javaTodo,@Spell
hi def link gosuCommentString javaString
hi def link javaComment2String javaString
hi def link javaCommentCharacter javaCharacter

syn cluster javaTop add=javaComment,javaLineComment

" match the special comment /**/
syn match   javaComment		 "/\*\*/"

" Strings and constants
syn match   javaSpecialError	 contained "\\."
syn match   javaSpecialCharError contained "[^']"
syn match   javaSpecialChar	 contained "\\\([4-9]\d\|[0-3]\d\d\|[\"\\'ntbrf]\|u\x\{4\}\)"
syn region  javaString		start=+"+ end=+"+ end=+$+ contains=javaSpecialChar,javaSpecialError,@Spell
" next line disabled, it can cause a crash for a long line
"syn match   javaStringError	  +"\([^"\\]\|\\.\)*$+
syn match   javaCharacter	 "'[^']*'" contains=javaSpecialChar,javaSpecialCharError
syn match   javaCharacter	 "'\\''" contains=javaSpecialChar
syn match   javaCharacter	 "'[^\\]'"
syn match   javaNumber		 "\<\(0[bB][0-1]\+\|0[0-7]*\|0[xX]\x\+\|\d\(\d\|_\d\)*\)[lL]\=\>"
syn match   javaNumber		 "\(\<\d\(\d\|_\d\)*\.\(\d\(\d\|_\d\)*\)\=\|\.\d\(\d\|_\d\)*\)\([eE][-+]\=\d\(\d\|_\d\)*\)\=[fFdD]\="
syn match   javaNumber		 "\<\d\(\d\|_\d\)*[eE][-+]\=\d\(\d\|_\d\)*[fFdD]\=\>"
syn match   javaNumber		 "\<\d\(\d\|_\d\)*\([eE][-+]\=\d\(\d\|_\d\)*\)\=[fFdD]\>"

" unicode characters
syn match   javaSpecial "\\u\d\{4\}"

syn cluster javaTop add=javaString,javaCharacter,javaNumber,javaSpecial,javaStringError

if exists("gosu_highlight_functions")
  if gosu_highlight_functions == "indent"
    syn match  javaFuncDef "^\(\t\| \{8\}\)[_$a-zA-Z][_$a-zA-Z0-9_. \[\]<>]*([^-+*/]*)" contains=javaScopeDecl,gosuSpecial,javaType,javaStorageClass,@javaClasses,javaAnnotation
    syn region javaFuncDef start=+^\(\t\| \{8\}\)[$_a-zA-Z][$_a-zA-Z0-9_. \[\]<>]*([^-+*/]*,\s*+ end=+)+ contains=javaScopeDecl,gosuSpecial,javaType,javaStorageClass,@javaClasses,javaAnnotation
    syn match  javaFuncDef "^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]<>]*([^-+*/]*)" contains=javaScopeDecl,gosuSpecial,javaType,javaStorageClass,@javaClasses,javaAnnotation
    syn region javaFuncDef start=+^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]<>]*([^-+*/]*,\s*+ end=+)+ contains=javaScopeDecl,gosuSpecial,javaType,javaStorageClass,@javaClasses,javaAnnotation
  else
    " This line catches method declarations at any indentation>0, but it assumes
    " two things:
    "	1. class names are always capitalized (ie: Button)
    "	2. method names are never capitalized (except constructors, of course)
    "syn region javaFuncDef start=+^\s\+\(\(public\|protected\|private\|static\|abstract\|final\|native\|synchronized\)\s\+\)*\(\(void\|boolean\|char\|byte\|short\|int\|long\|float\|double\|\([A-Za-z_][A-Za-z0-9_$]*\.\)*[A-Z][A-Za-z0-9_$]*\)\(<[^>]*>\)\=\(\[\]\)*\s\+[a-z][A-Za-z0-9_$]*\|[A-Z][A-Za-z0-9_$]*\)\s*([^0-9]+ end=+)+ contains=javaScopeDecl,javaType,javaStorageClass,javaComment,javaLineComment,@javaClasses
    syn region javaFuncDef start=+^\s\+\(\(public\|protected\|private\|static\|abstract\|final\|native\|synchronized\)\s\+\)*\(<.*>\s\+\)\?\(\(void\|boolean\|char\|byte\|short\|int\|long\|float\|double\|\([A-Za-z_][A-Za-z0-9_$]*\.\)*[A-Z][A-Za-z0-9_$]*\)\(<[^(){}]*>\)\=\(\[\]\)*\s\+[a-z][A-Za-z0-9_$]*\|[A-Z][A-Za-z0-9_$]*\)\s*(+ end=+)+ contains=javaScopeDecl,gosuSpecial,javaType,javaStorageClass,javaComment,javaLineComment,@javaClasses,javaAnnotation
  endif
  syn match javaLambdaDef "[a-zA-Z_][a-zA-Z0-9_]*\s*->"
  syn match  javaBraces  "[{}]"
  syn cluster javaTop add=javaFuncDef,javaBraces,javaLambdaDef
endif

if exists("gosu_mark_braces_in_parens_as_errors")
  syn match javaInParen		 contained "[{}]"
  hi def link javaInParen	javaError
  syn cluster javaTop add=javaInParen
endif

" catch errors caused by wrong parenthesis
syn region  javaParenT	transparent matchgroup=javaParen  start="(" end=")" contains=@javaTop,javaParenT1
syn region  javaParenT1 transparent matchgroup=javaParen1 start="(" end=")" contains=@javaTop,javaParenT2 contained
syn region  javaParenT2 transparent matchgroup=javaParen2 start="(" end=")" contains=@javaTop,javaParenT  contained
syn match   javaParenError	 ")"
" catch errors caused by wrong square parenthesis
syn region  javaParenT	transparent matchgroup=javaParen  start="\[" end="\]" contains=@javaTop,javaParenT1
syn region  javaParenT1 transparent matchgroup=javaParen1 start="\[" end="\]" contains=@javaTop,javaParenT2 contained
syn region  javaParenT2 transparent matchgroup=javaParen2 start="\[" end="\]" contains=@javaTop,javaParenT  contained
syn match   javaParenError	 "\]"

hi def link javaParenError	javaError

if exists("gosu_highlight_functions")
   syn match javaLambdaDef "([a-zA-Z0-9_<>\[\], \t]*)\s*->"
   " needs to be defined after the parenthesis error catcher to work
endif

if !exists("gosu_minlines")
  let gosu_minlines = 10
endif
exec "syn sync ccomment javaComment minlines=" . gosu_minlines

" The default highlighting.
" gosu definitions
hi def link gosuFunc            Function
hi def link gosuSpecial         Special
hi def link gosuType            Type
hi def link gosuStorageClass            StorageClass
hi def link gosuExternal                Include
hi def link gosuConstant                Constant	
hi def link gosuRepeat          Repeat
hi def link gosuShebang         SpecialComment
hi def link gosuClassDecl               StorageClass

" java definitions
hi def link javaLambdaDef               Function
hi def link javaFuncDef         Function
hi def link javaVarArg			Function
hi def link javaBraces			Function
hi def link javaBranch			Conditional
hi def link gosuUserLabelRef		gosuUserLabel
hi def link gosuLabel			Label
hi def link gosuUserLabel		Label
hi def link javaConditional		Conditional
hi def link javaRepeat			Repeat
hi def link javaExceptions		Exception
hi def link javaAssert			Statement
hi def link javaStorageClass		StorageClass
hi def link javaMethodDecl		javaStorageClass
hi def link javaClassDecl		javaStorageClass
hi def link javaScopeDecl		javaStorageClass
hi def link javaBoolean		Boolean
hi def link javaSpecial		Special
hi def link javaSpecialError		Error
hi def link javaSpecialCharError	Error
hi def link javaString			String
hi def link javaCharacter		Character
hi def link javaSpecialChar		SpecialChar
hi def link javaNumber			Number
hi def link javaError			Error
hi def link javaStringError		Error
hi def link javaStatement		Statement
hi def link javaOperator		Operator
hi def link javaComment		Comment
hi def link javaDocComment		Comment
hi def link javaLineComment		Comment
hi def link javaConstant		Constant
hi def link javaTypedef		Typedef
hi def link javaTodo			Todo
hi def link javaAnnotation		PreProc

hi def link javaCommentTitle		SpecialComment
hi def link javaDocTags		Special
hi def link javaDocParam		Function
hi def link javaDocSeeTagParam		Function
hi def link javaCommentStar		javaComment

hi def link javaType			Type
hi def link javaExternal		Include

hi def link htmlComment		Special
hi def link htmlCommentPart		Special
hi def link javaSpaceError		Error

let b:current_syntax = "gosu"

if main_syntax == 'gosu'
  unlet main_syntax
endif

let b:spell_options="contained"
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8
