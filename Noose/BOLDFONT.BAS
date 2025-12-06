DEFINT A-Z
DECLARE SUB BoldFont (text$, xTxt%, yTxt%, Clr%, dir%)
'
'    *** Bold Font ***
'   by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This program displays text$ in a bold font at position xTxt,yTxt in the
'foreground color Clr in any screen mode with a character box size of
'8x16 except 0. The argument dir means in which direction the text font
'should be extended. It dir is positive the font is exteded to the right,
'if it is negative the font will be extended to the left.
'



SCREEN 12: CLS
PRINT "Press any key...": SLEEP
BoldFont "Hello and Welcome to this Program!", 10, 10, 15, -1
BoldFont "This program displays a BOLD font!", 10, 12, 15, 1

SUB BoldFont (text$, xTxt, yTxt, Clr, dir)
IF xTxt < 1 OR xTxt + LEN(text$) > 80 OR yTxt < 1 OR yTxt > 25 THEN EXIT SUB
dir = SGN(dir): IF dir = 0 THEN EXIT SUB
x1 = (xTxt - 1) * 8: y1 = (yTxt - 1) * 16
x2 = x1 + (LEN(text$) * 8) + 1: y2 = y1 + 16
IF dir = 1 THEN SWAP x1, x2

LOCATE yTxt, xTxt: COLOR Clr: PRINT text$
FOR x = x1 TO x2 STEP -dir
  FOR y = y1 TO y2
    cP1 = (POINT(x, y) = Clr)
    cP2 = (POINT(x + dir, y) = Clr)
    cP3 = (POINT(x + 2 * dir, y) = Clr)
    IF cP1 AND (NOT cP2) AND (NOT cP3) THEN
      PSET (x + dir, y), Clr
    END IF
  NEXT y
NEXT x
END SUB

