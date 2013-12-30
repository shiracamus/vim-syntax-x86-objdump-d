" Vim syntax file
" Language:     x86/x64 GNU Disassembler (objdump -d -Mintel)
" Maintainer:   @shiracamus <shiracamus@gmail.com>
" Last Change:  2013 Dec 30

" For version 5.x: Clear all syntax items
" For version 6.0 and later: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

syn match disOffset     "[+-]"
syn match disNumber     "[+-]\?\<0x[0-9a-f]\+\>" contains=disOffset
syn match disNumber     "[+-]\?\<[0-9a-f]\+\>" contains=disOffset

syn match disRegister   "\<[re]\?[abcd][xhl]\>"
syn match disRegister   "\<[re]\?[sd]il\?\>"
syn match disRegister   "\<[re]\?[sbi]pl\?\>"
syn match disRegister   "\<r[0-9]\+[dwb]\?\>"
syn match disRegister   "[^\t]\<[cdefgs]s\>"hs=s+1

syn match disAt         "@"
syn match disSection    " \.[a-z][a-z_\.-]*:"he=e-1
syn match disSection    "@[a-z0-9_][a-z0-9_-]\+"hs=s+1 contains=disAt,disNumber

syn match disLabel      "<[a-z0-9_.][a-z0-9_.@+-]\+>"hs=s+1,he=e-1 contains=disNumber,disSection
syn match disHexDump    ":\t\([0-9a-f][0-9a-f] \)\+"hs=s+1

syn match disError      "<internal disassembler error>"
syn match disError      "(bad)"

syn keyword disTodo     contained TODO

syn region disComment   start="/\*" end="\*/" contains=disTodo
syn match disComment    "[#;!|].*" contains=disLabel,disTodo

syn match disSpecial    display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn region disString    start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=disSpecial
syn region disString    start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=disSpecial

syn match disFormat     ": \+file format "
syn match disTitle      "^[^ ]\+: \+file format .*$" contains=disFormat

syn match disMacro      "FWORD"
syn match disMacro      "QWORD"
syn match disMacro      "DWORD"
syn match disMacro      "BYTE"
syn match disMacro      "PTR"

syn match disData       ".word"
syn match disData       ".short"
syn match disData       ".byte"

" Opecode matched disNumber
syn match disOpecode    "\<add "
syn match disOpecode    "\<adc "
syn match disOpecode    "\<dec "
syn match disOpecode    "\<fadd "

syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_dis_syntax_inits")
  if version < 508
    let did_dis_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  " Comment
  HiLink disComment     Comment
  " Constant: String, Character, Number, Boolean, Float
  HiLink disNumber      Number
  HiLink disString      String
  " Identifier: Function
  HiLink disHexDump     Identifier
  "Statement: Conditional, Repeat, Label, Operator, Keyword, Exception
  HiLink disLabel       Label
  " PreProc: Include, Define, Macro, PreCondit
  HiLink disData        Define
  HiLink disMacro       Macro
  " Type: StorageClass, Structure, Typedef
  HiLink disRegister    StorageClass
  HiLink disTitle       Typedef
  " Special: SpecialChar, Tag, Delimiter, SpecialComment, Debug
  HiLink disSpecial     SpecialChar
  HiLink disSection     Special
  " Underlined
  " Ignore
  " Error
  HiLink disError       Error
  " Todo
  HiLink disTodo        Todo

  delcommand HiLink
endif

let b:current_syntax = "dis"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8 sts=4 sw=2
