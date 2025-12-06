DECLARE SUB vSetMode (a%, oMaxColors%, oMaxX%, oMaxY%, oMaxXt%, oMaxYt%)
DECLARE SUB vCursorType (StartLine%, EndLine%)
DECLARE SUB vLine (xs%, ys%, xe%, ye%, c%)
DECLARE SUB vLocate (x%, y%)
DECLARE SUB vPrint (text$, fg%, bg%)
DECLARE FUNCTION vGetChar% (x%, y%)
DECLARE FUNCTION vGetMode% ()
DECLARE FUNCTION vGetPage% ()
DECLARE SUB vPset (x%, y%, c%)
DECLARE SUB vPage (WhatPage%)
DECLARE FUNCTION vPoint% (x%, y%)
DECLARE SUB vScrollUp (x1%, y1%, x2%, y2%, howmany%)
DEFINT A-Z
'$INCLUDE: 'qb.bi'
'
' *** Graphics Support Routines ***
'      by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'SUPER GRAPHICS LIBRARY WITH SVGA SUPPORT!
'WARNING: There is _no_guarantee_ that this will work
'or not harm your computer! If your screen goes blank
'or gets messed up, just wait a few seconds and then
'press any key. That should restore the normal mode.
'Also, the SVGA rountines have only been tested on
'VESA and Tseng cards, and it is not known how many
'SVGA pages are allowed, so you only have two (1 and 0).
'You might get strange results on any of the commands,
'that may be because your card is not compatible with
'the mode you picked.
'

RANDOMIZE TIMER
vSetMode 3, dummy, dummy, dummy, dummy, dummy: CLS
PRINT "         Display     Number     Adapter Cards    Maximum Pages"
PRINT "Mode      Lines    of Colors                        Allowed   "
PRINT "--------------------------------------------------------------"
PRINT "  0       40x25     B&W text    CGA, EGA, VGA        8        "
PRINT "  1       40x25     Color text  CGA, EGA, VGA        8        "
PRINT "  2       80x25     B&W text    CGA, EGA, VGA        8        "
PRINT "  3       80x25     Color text  CGA, EGA, VGA        8        "
PRINT "  4      320x200      4         CGA, EGA, VGA        1        "
PRINT "  5      320x200     Mono       CGA, EGA, VGA        1        "
PRINT "  6      640x200     Mono       CGA, EGA, VGA        1        "
PRINT "  7       80x25     B&W text    MGA, EGA, VGA        8        "
PRINT "  &HD    320x200      16        EGA, VGA             8        "
PRINT "  &HE    640x200      16        EGA, VGA             4        "
PRINT "  &HF    640x350     Mono       EGA, VGA             2        "
PRINT "  &H10   640x350      16        EGA, VGA             2        "
PRINT "  &H11   640x480     Mono       VGA                  1        "
PRINT "  &H12   640x480      16        VGA                  1        "
PRINT "  &H13   320x200      256       VGA                  1        "
PRINT "  &H5E   800x600      256       SVGA - Trident                "
PRINT "  &H6A   800x600      16        SVGA - VESA(or unknown)       "
PRINT "  &H30   800x600      256       SVGA - Tseng                  "
PRINT "  &H63   800x600      256       SVGA - ATI                    "
PRINT "--------------------------------------------------------------"

INPUT "Mode? ", ScrMode
vSetMode ScrMode, MaxColors, MaxX, MaxY, MaxXt, MaxYt

vCursorType 15, 15
'Color palette
FOR a = 0 TO MaxColors
  vLine a, 0, a, 100, a
NEXT a
'A little text
vLocate 5, 8
vPrint "SUPER GRAPHICS FUNCTIONS!", 1, 0

'A neat & colorful figure
CStep! = MaxColors / 360
FOR rad = 1 TO 360 STEP 3
   Xto = 150 + COS(rad / 3.141593) * 50
   Yto = 200 + SIN(rad / 3.141593) * 50
   vLine 150, 200, Xto, Yto, rad * CStep!
NEXT rad

a$ = INPUT$(1)
vSetMode 3, dummy, dummy, dummy, dummy, dummy: CLS
SYSTEM

SUB vCurPos (x, y)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
inregs.ax = &H300
inregs.bx = CurPage * &H100
CALL INTERRUPT(&H10, inregs, outregs)
x = (outregs.dx AND &HFF) + 1
y = (outregs.dx \ &H100) + 1
CurX = x: CurY = y
END SUB

SUB vCursorType (StartLine, EndLine)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF StartLine < 0 OR StartLine > 15 THEN EXIT SUB
IF EndLine < 0 OR EndLine > 15 THEN EXIT SUB
inregs.ax = &H100
inregs.cx = StartLine * &H100 + EndLine
CALL INTERRUPT(&H10, inregs, outregs)
END SUB

FUNCTION vGetChar (x, y)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF x < 1 OR x > MaxXt THEN vGetChar = -1: EXIT FUNCTION
IF y < 1 OR y > MaxYt THEN vGetChar = -1: EXIT FUNCTION
inregs.ax = &H800
inregs.bx = CurPage * &H100
CALL INTERRUPT(&H10, inregs, outregs)
vChar = outregs.ax AND &HFF
END FUNCTION

FUNCTION vGetMode
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
inregs.ax = &HF00
CALL INTERRUPT(&H10, inregs, outregs)
vGetMode = outregs.ax AND &HFF
END FUNCTION

FUNCTION vGetPage
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
inregs.ax = &HF00
CALL INTERRUPT(&H10, inregs, outregs)
vGetPage = (outregs.bx \ &H100) AND &HFF
END FUNCTION

SUB vLine (xs, ys, xe, ye, c)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
    IF ys > ye THEN SWAP ys, ye
    IF xs > xe THEN SWAP xs, xe
    IF xs < 0 OR xs > MaxX THEN EXIT SUB
    IF xe < 0 OR xe > MaxX THEN EXIT SUB
    IF ys < 0 OR ys > MaxY THEN EXIT SUB
    IF ye < 0 OR ye > MaxY THEN EXIT SUB
    IF c < 0 OR c > MaxColors THEN EXIT SUB
   
    IF ys = ye THEN
      FOR x = xs TO xe
	vPset x, ys, c
      NEXT x
    END IF

    IF ys < 0 THEN
	xs = xs + ((xe - xs) * -ys) \ (ye - ys)
	ys = 0
    END IF

    xd = xe - xs
    yd = ye - ys

    IF yd <> 0 THEN xi = xd \ yd: xrs = ABS(xd MOD yd)

    xr = -yd \ 2

    IF ye > MaxY THEN ye = MaxY

    xdirect = SGN(xd) + xi

    xo = xs
    FOR y = ys TO ye
	IF ABS(xs - xo) > 1 THEN
	  FOR xn = xo + 1 TO xs - 1
	    vPset xn, y, c
	  NEXT xn
	END IF
	vPset xs, y, c
       
	xo = xs
	xr = xr + xrs
	IF xr > 0 THEN
	    xr = xr - yd
	    xs = xs + xdirect
	ELSE
	    xs = xs + xi
	END IF
    NEXT
END SUB

SUB vLocate (x, y)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF x < 1 OR x > MaxXt THEN EXIT SUB
IF y < 1 OR y > MaxYt THEN EXIT SUB
CurX = x: CurY = y
inregs.ax = &H200
inregs.bx = CurPage * &H100
inregs.dx = (y - 1) * &H100 + (x - 1)
CALL INTERRUPT(&H10, inregs, outregs)
END SUB

SUB vPage (WhatPage)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF WhatPage < 0 OR WhatPage > Pages THEN EXIT SUB
inregs.ax = &H500 + WhatPage
CALL INTERRUPT(&H10, inregs, outregs)
CurPage = WhatPage
END SUB

FUNCTION vPoint (x, y)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF x < 0 OR x > MaxX THEN vPoint = -1: EXIT FUNCTION
IF y < 0 OR y > MaxY THEN vPoint = -1: EXIT FUNCTION
inregs.ax = &HD00
inregs.bx = CurPage * &H100
inregs.cx = x                        ' select x coord
inregs.dx = y                        ' select y coord
CALL INTERRUPT(&H10, inregs, outregs)' set pixel
vPoint = outregs.ax AND &HFF
END FUNCTION

SUB vPrint (text$, fg, bg)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF fg < 0 OR fg > MaxColors THEN EXIT SUB
IF bg < 0 OR bg > MaxColors THEN EXIT SUB
FOR a = 1 TO LEN(text$)
  IF CurX > MaxXt THEN CurY = CurY + 1: CurX = 1
  IF CurY > MaxYt THEN vScrollUp 1, 1, MaxXt, MaxYt, 1: CurY = MaxYt
  vLocate CurX, CurY
  inregs.ax = &HA00 + ASC(MID$(text$, a, 1))
  inregs.bx = bg * &H100 + fg
  inregs.cx = 1
  CALL INTERRUPT(&H10, inregs, outregs)
  CurX = CurX + 1
NEXT a
CurX = 1: CurY = CurY + 1
END SUB

SUB vPset (x, y, c)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
IF c < 0 OR c > MaxColors THEN EXIT SUB
inregs.ax = &HC00 + c                ' set up function+color
inregs.bx = CurPage * &H100
inregs.cx = x                        ' select x coord
inregs.dx = y                        ' select y coord
CALL INTERRUPT(&H10, inregs, outregs)' set pixel
END SUB

SUB vScrollDown (x1, y1, x2, y2, howmany)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
inregs.ax = &H700 + howmany
inregs.bx = &H0
inregs.cx = (y1 - 1) * &H100 + (x1 - 1)
inregs.dx = (y2 - 1) * &H100 + (x2 - 1)
CALL INTERRUPT(&H10, inregs, outregs)
END SUB

SUB vScrollUp (x1, y1, x2, y2, howmany)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
inregs.ax = &H600 + howmany
inregs.bx = &H0
inregs.cx = (y1 - 1) * &H100 + (x1 - 1)
inregs.dx = (y2 - 1) * &H100 + (x2 - 1)
CALL INTERRUPT(&H10, inregs, outregs)
END SUB

SUB vSetMode (a, oMaxColors, oMaxX, oMaxY, oMaxXt, oMaxYt)
SHARED MaxColors, CurX, CurY, CurPage, MaxX, MaxY, MaxXt, MaxYt, Pages
DIM inregs  AS RegType, outregs AS RegType
SELECT CASE a
  CASE 0
    MaxColors = 1:   MaxX = -1:  MaxY = -1:  MaxXt = 40: MaxYt = 25: Pages = 8
  CASE 1
    MaxColors = 15:  MaxX = -1:  MaxY = -1:  MaxXt = 40: MaxYt = 25: Pages = 7
  CASE 2
    MaxColors = 1:   MaxX = -1:  MaxY = -1:  MaxXt = 80: MaxYt = 25: Pages = 7
  CASE 3
    MaxColors = 15:  MaxX = -1:  MaxY = -1:  MaxXt = 80: MaxYt = 25: Pages = 7
  CASE 4
    MaxColors = 3:   MaxX = 319: MaxY = 199: MaxXt = 40: MaxYt = 25: Pages = 0
  CASE 5
    MaxColors = 1:   MaxX = 319: MaxY = 199: MaxXt = 40: MaxYt = 25: Pages = 0
  CASE 6
    MaxColors = 1:   MaxX = 639: MaxY = 199: MaxXt = 80: MaxYt = 25: Pages = 0
  CASE 7
    MaxColors = 1:   MaxX = -1:  MaxY = -1:  MaxXt = 80: MaxYt = 25: Pages = 7
  CASE &HD
    MaxColors = 15:  MaxX = 319: MaxY = 199: MaxXt = 40: MaxYt = 25: Pages = 7
  CASE &HE
    MaxColors = 15:  MaxX = 639: MaxY = 199: MaxXt = 80: MaxYt = 25: Pages = 3
  CASE &HF
    MaxColors = 1:   MaxX = 639: MaxY = 349: MaxXt = 80: MaxYt = 25: Pages = 1
  CASE &H10
    MaxColors = 15:  MaxX = 639: MaxY = 349: MaxXt = 80: MaxYt = 25: Pages = 1
  CASE &H11
    MaxColors = 1:   MaxX = 639: MaxY = 479: MaxXt = 80: MaxYt = 30: Pages = 0
  CASE &H12
    MaxColors = 15:  MaxX = 639: MaxY = 479: MaxXt = 80: MaxYt = 30: Pages = 0
  CASE &H13
    MaxColors = 255: MaxX = 319: MaxY = 199: MaxXt = 40: MaxYt = 25: Pages = 0
  CASE &H5E, &H30, &H63
    MaxColors = 255: MaxX = 799: MaxY = 599: MaxXt = 100: MaxYt = 37: Pages = 1
  CASE &H6A
    MaxColors = 15:  MaxX = 799: MaxY = 599: MaxXt = 100: MaxYt = 35: Pages = 1
  CASE ELSE
    MaxColors = 255: MaxX = 319: MaxY = 199: MaxXt = 40: MaxYt = 25: Pages = 0
    'EXIT SUB
END SELECT

inregs.ax = a                                        ' Set for screen mode
CALL INTERRUPT(&H10, inregs, outregs)                ' Change mode
CurX = 1: CurY = 1: CurPage = 0
vLocate 1, 1: vPage 0
oMaxColors = MaxColors: oMaxX = MaxX: oMaxY = MaxY: oMaxXt = MaxXt: oMaxYt = MaxYt
END SUB

