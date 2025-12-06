'$DYNAMIC$
DEFINT A-Z
DECLARE FUNCTION ScrollBox% (x1%, y1%, x2%, y2%, line$())
'
'   *** Scroll Box ***
'   by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling.
'  All Rights Reserved.
'
'
'This program generates a selection box from which the user can select
'a entry. Arguments x1 thru y2 are the box's corners and line$() is
'an array containing the lines that are displayed in the scroll box.
'

DIM temp$(800)
CLS
LOCATE , , 0
INPUT "Filename? ", file$
OPEN file$ FOR INPUT AS #1
t = 0
WHILE ((t < 800) AND (NOT EOF(1)))
   LINE INPUT #1, temp$(t)
   t = t + 1
WEND
CLOSE 1
DIM txt$(t)
FOR a = 0 TO t
  txt$(a) = LEFT$(temp$(a), 80)
NEXT a
ERASE temp$

selected = ScrollBox(10, 3, 70, 20, txt$())
COLOR 2, 0: CLS
IF selected = 0 THEN
  PRINT "You aborted."
ELSE
  PRINT "You hit ENTER on array item"; STR$(selected%); "."
END IF

FUNCTION ScrollBox (x1, y1, x2, y2, line$())
 
  'set up vars
  maxlines = UBOUND(line$) - 1
  high = y2 - y1: wide = x2 - x1
  linview = high - 2: top = 0: sel = 0
 
  IF maxlines = 0 OR wide < 5 OR high < 5 OR wide > 79 OR high > 24 THEN EXIT FUNCTION

  'draw box
  COLOR 7, 1
  LOCATE y1, x1, 0
  PRINT "Ú"; STRING$(wide - 1, "Ä"); "¿";
  FOR y = y1 + 1 TO y2 - 1
        LOCATE y, x1
        PRINT "³"; SPACE$(wide - 1); "³";
  NEXT y
  LOCATE y2, x1
  PRINT "À"; STRING$(wide - 1, "Ä"); "Ù";

  'it's quite useful to remove unwanted chars from the lines so they
  ' don't mess up the box
  FOR a = 1 TO maxlines
    FOR b = 1 TO LEN(line$(a))
      IF ASC(MID$(line$(a), b, 1)) < 32 THEN MID$(line$(a), b, 1) = " "
    NEXT b
  NEXT a
 
  GOSUB DrawLines
  'main proc

  DO
    key$ = INKEY$
    SELECT CASE key$
     CASE CHR$(0) + "H" 'up
       IF sel > 0 THEN sel = sel - 1
       IF sel < top THEN top = sel
       GOSUB DrawLines
     CASE CHR$(0) + "P" 'dn
       IF sel < maxlines THEN sel = sel + 1
       IF sel > top + linview THEN top = sel - linview
       GOSUB DrawLines
     CASE CHR$(0) + "I" 'pgup
       IF top - linview - 1 >= 0 THEN
         top = top - linview - 1: sel = sel - linview - 1
       ELSE
         top = 0: sel = 0
       END IF
       GOSUB DrawLines
     CASE CHR$(0) + "Q" 'pgdn
       IF top + linview + 1 <= maxlines THEN
         top = maxlines - linview: sel = top
       ELSE
         top = top + linview + 1: sel = sel + linview + 1
       END IF
       GOSUB DrawLines
     CASE CHR$(13)   'enter
       sel = sel + 1: EXIT DO
     CASE CHR$(27)     'esc
       sel = 0: EXIT DO
    END SELECT

  LOOP

  ScrollBox = sel
  EXIT FUNCTION
 
  'Subproc
DrawLines:
  LOCATE y1, x1 + 2: COLOR 15, 1: PRINT sel + 1; : COLOR 7, 1: PRINT "Ä";
  maxdraw = top + linview
  yloc = y1
  FOR a = top TO maxdraw
    IF a > maxlines THEN EXIT FOR
    yloc = yloc + 1
    LOCATE yloc, x1 + 1
    IF a = sel THEN COLOR 15, 3 ELSE COLOR 7, 1
    PRINT LEFT$(line$(a), wide - 1);
    IF LEN(line$(a)) < wide - 1 THEN PRINT SPACE$(wide - 1 - LEN(line$(a)));
  NEXT a
RETURN

END FUNCTION

