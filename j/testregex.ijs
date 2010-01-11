makeRGB=: 0&$: : (($,)~ ,&3)
fillRGB=: makeRGB }:@$
setPixels=: (1&{::@[)`(<"1@(0&{::@[))`]}
getPixels=: <"1@[ { ]

NB. =========================================================
NB. http://rosettacode.org/wiki/Grayscale_image#J

NB. converts the image to grayscale according to formula
NB. L = 0.2126*R + 0.7152*G + 0.0722*B
toGray=: <.@:(+/)@:(0.2126 0.7152 0.0722 & *)"1 

NB. converts grayscale image to the color image, with all channels equal
toColor=: 3&$"0

NB. =========================================================
NB. http://rosettacode.org/wiki/Write_ppm_file#J

require 'files'

NB.*writeppm v Write PPM format image file
NB. result: bytes written or _1 if error
NB. y is: file name to write
NB. x is: RGB data HxWx3
NB. ($x) is height, width, colors per pixel
writeppm=:dyad define
  header=. 'P6',LF,(":1 0{$x),LF,'255',LF
  (header,,x{a.) fwrite y
)

NB. =========================================================
NB. http://rosettacode.org/wiki/Read_ppm_file#J

NB.*readppm v Read a PPM format image file to RGB structure
NB. result: RGB data HxWx3
NB. y is: file name to read
readppm=: monad define
  dat=. fread y                                           NB. read from file
  msk=. 1 ,~ (*. 3 >: +/\) (LF&=@}: *. '#'&~:@}.) dat     NB. mark field ends
  't wbyh maxval dat'=. msk <;._2 dat                     NB. parse
  'wbyh maxval'=. 2 1([ {. [: _99&". (LF,' ')&charsub)&.> wbyh;maxval  NB. convert to numeric
  if. (_99 0 +./@e. wbyh,maxval) +. 'P6' -.@-: 2{.t do. _1 return. end.
  (a. i. dat) makeRGB |.wbyh                              NB. convert to basic bitmap format
)

require 'viewmat'
viewRGB=: [: viewrgb 256&#.

NB. nth hamming number (per Roger Hui)
nh=: 3 : 0 " 0
 hi=. (1.56 1.693{~y>5e4) -~ 3%:6*y**/'ln2 ln3 ln5'=. ^.2 3 5
 k=. i.1+<.hi%ln5                NB. exponents for 5
 m=. 1+<.ln3%~hi-k*ln5
 j=. ;i.&.>m                     NB. exponents for 3
 k=. m#k
 s=. <.p=. ln2%~hi-(j*ln3)+k*ln5
 i=. >.p-ln2%~(0.2 0.01{~y>5e4)  NB. exponents for 2
 z=. (i=s)#i,.j,.k
 */2 3 5x ^ (y-~(#s)++/s) { :: 0: z\:z+/ .*^.2 3 5 
)

NB. Test string
''    NB. that is an empty string
'This is a string'
'This is a string including an apostrophe '' within it.'
'This line is an incomplete string
This should not complete the incomplete string on last line'

NB. Test Comments
NB Here is not a comment
testNB.    Here is not a comment
54.3NB.    Here is not a comment (ill-formed number: see above)
test NB.   Here is a comment
'test'NB.  Here is a comment
test*NB.   Here is a comment
test i.NB. Here is a comment

NB.test argument keywords
testconj=: 2 : 0
  leftverb=. u
  rightverb=. v
  leftnoun=. n x
  rightnoun=. m y
  #y i.y # y i. y  #y* +y 3{y }:y }y *&y %y $y !y "y ?y `y ~y NB. valid
  #dy # dy #yd # y. #y3   NB. invalid (don't highlight)
)

for. for_myvar. for_my30_983.       NB. valid for.
dafor_myvar. for_3493. for befor    NB. invalid for.
be4for forasj.                      NB. invalid for.

myverb3_dsk myverb3_45_

NB. where var is any valid name
*var #var var3#.var var #. var p.var {.var var{.var  NB. valid primitives
varp.var  var4p.var   NB. invalid primitives

4x 49393x 45r212 0j29 1e7 1e_7 1r_7 16b34ab 
45.3e5 45.3r5.2 

   8befjg1          NB. valid number 66369
   8.0befjg1        NB. valid number 66369
   _8.0befjg1       NB. valid number 50753
   _8.0bef34jg1     NB. valid number 3189825
   _8.0b_ef34jg1    NB. valid number _3189825
   _8.0b_ef.34jg1   NB. valid number 97.3457336426
   _ _ __           NB. valid numbers infinity & neg. infinity

432r 4b             NB. ill-formed numbers, highlight all or none

i.456 #345 "2       NB. just numbers should be highlighted
__&". _". _&".      NB. underscores are numbers
'string'"_          NB. underscore is number
('string'"_)        NB. underscore is number
'string'"_ 1        NB. underscore is number
^:_                 NB. underscore is number
_".                 NB. underscore is number
_.  _:              NB. underscores are not numbers

'\b_?[0-9]+\.?[a-z]*'
'\b_?\d+\.?\d*'
'\b_?\d+\.?\d*(?=\s|[^\d\.a-z])'
'\b_?\d+(\.\d+)?e_?\d+'  NB.  Exponent format numbers
'\b_?\d+(\.\d+)?[\da-z]+(_?\d+)?(\.\d+)?'
'\b_?\d+\.?[\da-z]*'
'\b_?\d+\.?[\da-z]*\d*x?'
'\b_?\d+(\.\d+)?[\da-z\._]*'  NB. All nums - this is pretty good
'\b_?\d+[\da-z\._]*'  NB. All nums - same but simpler - using
NB. only highlights valid numbers except _ and __
'\b_?\d+(\.\d+)?(x|[bejprx]_?[\da-z]+(\.[\da-z]+)?)?(?!\w|\.)'

NB. test Note - multiline comments
Note 'some text'
This is commment text
 */~ i.4    NB. this whole line is comment text
This shouldn't be formatted as an incomplete string. Line should be comment text.
'This shouldn''t be formatted as a string. Line should be comment text'
This is last line of comment text
)

This is not a string or a comment

Note ''
This is commment text
This is last line of comment text
)
*/ >:i.5 NB. before this comment should be code
Note 1
This is commment text
This is last line of comment text
   )

'This is a string not a comment'
Note 1 3
This is commment text
This is last line of comment text
  )   

'This is a string not a comment'
Note <*1 3
This is commment text
This is last line of comment text
)
'This is a string not a comment'