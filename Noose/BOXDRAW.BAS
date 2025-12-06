DEFINT A-Z
DECLARE SUB Box (X1%, Y1%, X2%, Y2%, Version%, Clr1%, Clr2%)
'
' *** Text Boxes ***
' by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This program draws a simple text box at the coordinates x1,y1 to x2,y2.
'The arguments Clr1 and Clr2 are fore- and background colors, and Version
'is the type of the box.
'

CLS
FOR a = 1 TO 8
  Box 25, 8, 50, 12, a, 15, a
  LOCATE 10, 30: PRINT "Press any key..."
  DO: LOOP UNTIL INKEY$ <> ""
NEXT a

'-----------------------------------------------------------
DataBox:
DATA Ú, Ä, ¿, ³, À, Ù
DATA É, Í, », º, È, ¼
DATA Õ, Í, ¸, ³, Ô, ¾
DATA Û, Û, Û, Û, Û, Û
DATA ², ², ², ², ², ²
DATA ±, ±, ±, ±, ±, ±
DATA °, °, °, °, °, °
DATA +, -, +, |, +, +
'===========================================================

SUB Box (X1, Y1, X2, Y2, Version, Clr1, Clr2)
' ********************
' * Draw a framework *
' ********************
' X1, Y1 - coordinates of upper left corner of framework
' X2, Y2 - coordinates of right lower corner of framework
' Version - form of framework
' Clr1, Clr2 -framework's fore- and background colors

REDIM B$(8, 6)
RESTORE DataBox
FOR I = 1 TO 8
        FOR J = 1 TO 6
                READ B$(I, J)
        NEXT J
NEXT I
COLOR Clr1, Clr2
LOCATE Y1, X1
PRINT B$(Version, 1);
PRINT STRING$(X2 - X1 - 1, B$(Version, 2));
PRINT B$(Version, 3);
FOR Y = Y1 + 1 TO Y2 - 1
        LOCATE Y, X1
        PRINT B$(Version, 4);
        PRINT SPACE$(X2 - X1 - 1);
        PRINT B$(Version, 4);
NEXT Y
LOCATE Y2, X1
PRINT B$(Version, 5);
PRINT STRING$(X2 - X1 - 1, B$(Version, 2));
PRINT B$(Version, 6);
END SUB

