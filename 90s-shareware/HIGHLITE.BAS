DEFINT A-Z
DECLARE SUB Highlight (x%, y%, Hlen%, FG%, BG%)
'
'*** Text Highlighting ***
'   by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling.
'  All Rights Reserved.
'
'
'This program is very simple: it changes the color of the text at position
'x, y (length Hlen) to FG, BG. It also empties the keyboard buffer for
'error reduction (in case someone falls asleep on the down arrow). Works
'only in screen mode 0.
'

SCREEN 0: CLS
PRINT "          *** Menu System ***"
PRINT
PRINT "            - Selection 1 -"
PRINT "            - Selection 2 -"
PRINT "            - Selection 3 -"
PRINT "            - Selection 4 -"
PRINT "            - Selection 5 -"
PRINT
PRINT "Move cursor with 8(up) and 2(dn), select with <ENTER>."
CurSel = 1
LastSel = 1
Highlight 14, CurSel + 2, 13, 15, 7
DO
  a$ = UCASE$(INKEY$)
  SELECT CASE a$
    CASE "8"
      CurSel = CurSel - 1
      IF CurSel = 0 THEN CurSel = 5
      Highlight 14, CurSel + 2, 13, 15, 7
      Highlight 14, LastSel + 2, 13, 7, 0
      LastSel = CurSel
    CASE "2"
      CurSel = CurSel + 1
      IF CurSel = 6 THEN CurSel = 1
      Highlight 14, CurSel + 2, 13, 15, 7
      Highlight 14, LastSel + 2, 13, 7, 0
      LastSel = CurSel
   CASE CHR$(13)
      FinalSel = CurSel: EXIT DO
  END SELECT
LOOP
LOCATE 10, 1
PRINT "You selected"; FinalSel; "."

SUB Highlight (x, y, Hlen, FG, BG)
IF x > 80 OR x < 1 OR y > 25 OR y < 1 OR x + Hlen > 80 THEN EXIT SUB
COLOR FG, BG
FOR a = x TO x + Hlen - 1
  NoKey$ = INKEY$
  LOCATE y, a
  PRINT CHR$(SCREEN(y, a));
NEXT a
END SUB

