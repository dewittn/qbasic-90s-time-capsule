DECLARE SUB ResetFont ()
DECLARE SUB SetChar (WhatChar%, holder AS STRING)
DEFINT A-Z
'$INCLUDE: 'qb.bi'
DIM SHARED inregs AS RegTypeX
DIM SHARED outregs AS RegTypeX

NewChar$ = SPACE$(16)
FOR a = 1 TO 16
  READ tmp
  NewChar$ = NewChar$ + CHR$(tmp)
NEXT a


CLS
LOCATE 1, 1: PRINT STRING$(80, 255)
SLEEP
SetChar 255, NewChar$
SLEEP
ResetFont


DATA 28 ,34 ,34 ,28 ,8  ,8  ,62 ,73 ,73 ,73 ,73 ,28 ,34 ,65 ,65 ,65

SUB ResetFont
 inregs.ax = &H3     'BIOS function to reset the video display to 80
				 'cols x 25 lines
 CALL INTERRUPTX(&H10, inregs, outregs)
END SUB

SUB SetChar (WhatChar, holder AS STRING)

 inregs.ax = &H1100           'BIOS function to load new char definition
 inregs.bx = 16 * 256         '16 bytes/char - for 256 characters
 inregs.cx = 1                'number of characters to change
 inregs.dx = WhatChar              'the character to change
 inregs.es = VARSEG(holder)   'segment of holder
 inregs.bp = VARPTR(holder)   'offset of holder
 CALL INTERRUPTX(&H10, inregs, outregs)

END SUB

