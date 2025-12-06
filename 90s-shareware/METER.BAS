DEFINT A-Z
DECLARE SUB Meter (Xp%, Yp%, CurVal%, MaxVal%, FGC%, BGC%)
'
'   *** Percentage Meter ***
'     by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling.
'  All Rights Reserved.
'
'
'This program displayes a percentage meter (20 character length plus 5 for
'percent value) in screen mode 0 only. Xp any Yp are the X and Y coordinates
'of the meter, CurVal is how much of MaxVal has been processed, and FGC and
'BGC are the foreground and background colors.
'

CLS
FOR a = 1 TO 12345
  Meter 10, 10, a, 12345, 7, 0
NEXT a

SUB Meter (Xp, Yp, CurVal, MaxVal, FGC, BGC)
IF Xp > 55 OR Xp < 1 OR Yp > 25 OR Yp < 1 THEN EXIT SUB
PerVal = (CurVal / MaxVal) * 100
IF PerVal > 100 THEN EXIT SUB
COLOR FGC, BGC
LOCATE Yp, Xp
PRINT STRING$(PerVal \ 5, "Û"); STRING$(20 - PerVal \ 5, "°"); " ";
IF PerVal = 100 THEN PRINT "Done";  ELSE PRINT LTRIM$(RTRIM$(STR$(PerVal))) + "%";
END SUB

