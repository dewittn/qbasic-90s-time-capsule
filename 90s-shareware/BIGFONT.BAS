DEFINT A-Z
DECLARE SUB BigFont (text$, xTxt%, yTxt%, Xpos%, Ypos%, FGC%, BGC%, Fill%)
'
'  *** Big Font ***
' by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling.
'  All Rights Reserved.
'
'
'This program generates a font double the size of the normal font. Works
'in any screen mode with 8x16 character box size except 0. Arguments are:
'text$ - The text to be displayed
'xTxt - The X position for the normal size text (has to be displayed in
'       order to generate the big font)
'yTxt - The Y positon of the normal size text
'Xpos - The X coordinate for the big text
'Ypos - The Y coordinate for the big text
'FGC - foreground color
'BGC - background color
'Fill - Look at the example.
'

SCREEN 12: CLS : PRINT "Press any key...": SLEEP
BigFont "This is a pretty big font!", 1, 25, 10, 20, 12, 15, 0
BigFont "Yeah, it's cool, man!", 1, 25, 10, 160, 9, 15, -1

SUB BigFont (text$, xTxt, yTxt, Xpos, Ypos, FGC, BGC, FillOut)
xTxto = xTxt: yTxto = yTxt
LOCATE yTxt, xTxt: COLOR 15: PRINT text$;
xTxt = (xTxt - 1) * 8 - 2: yTxt = (yTxt - 1) * 16
xTxt2 = xTxt + 8 * LEN(text$) + 3
FOR x = xTxt TO xTxt2
  FOR y = yTxt TO yTxt + 16
    Xp = (x - xTxt) * 2 + Xpos: Yp = (y - yTxt) * 2 + Ypos
    IF POINT(x, y) = 15 THEN CL = FGC ELSE CL = BGC
    PSET (Xp, Yp), CL
    IF FillOut THEN PSET (Xp + 1, Yp), CL: PSET (Xp, Yp + 1), CL: PSET (Xp + 1, Yp + 1), CL
  NEXT y
NEXT x
LOCATE yTxto, xTxto: PRINT SPACE$(LEN(text$));
END SUB

