DEFINT A-Z
DECLARE SUB CopyPal (FromPal() AS ANY, IntoPal() AS ANY)
DECLARE SUB InvertPal (WhatPal() AS ANY)
DECLARE SUB RndCol (Clr AS ANY)
DECLARE SUB MakePal (WhatPal() AS ANY)
DECLARE SUB RotatePal (WhatPal() AS ANY)
DECLARE SUB FillPal (WhatPal() AS ANY)
DECLARE SUB DumpPal (WhatPal() AS ANY)
DECLARE SUB FadeIn (WhatPal() AS ANY)
DECLARE SUB FadeOut (WhatPal() AS ANY)
DECLARE SUB FadeInto (FromPal() AS ANY, IntoPal() AS ANY)
DECLARE SUB GetPal (Col%, R%, G%, B%)
DECLARE SUB SetPal (Col%, R%, G%, B%)
TYPE PalType
  R AS INTEGER
  G AS INTEGER
  B AS INTEGER
END TYPE

RANDOMIZE TIMER
DIM Pal(255) AS PalType, Pal1(255) AS PalType, Pal2(255) AS PalType
SCREEN 13: CLS                       '320x200x256
FillPal Pal()                        'Get current palette

CopyPal Pal(), Pal1()                'Copy palettes
CopyPal Pal(), Pal2()
InvertPal Pal2()                     'Invert palette 2

FOR x = 1 TO 40                      'generate random backround
  FOR y = 1 TO 25
    Char = INT(RND * 27) + 65        'random letter
    Col = INT(RND * 256)             'random color
    LOCATE y, x: COLOR Col: PRINT CHR$(Char);
  NEXT y
NEXT x
FOR a = 0 TO 20000
  x = INT(RND * 320)                  'random point
  y = INT(RND * 200)
  Col = INT(RND * 256)
  PSET (x, y), Col
NEXT a
FOR a = 32 TO 288                    'show palette at bottom of screen
  LINE (a, 180)-(a, 200), a - 32
NEXT a
SLEEP 1

BEEP '---------------
FadeOut Pal1()                       'fade out from Pal1
BEEP '---------------
FadeIn Pal1()                        'fade back into Pal1
BEEP '---------------
FadeInto Pal1(), Pal2()              'fade from Pal1 to Pal2
BEEP '---------------
FadeOut Pal2()                       'fade out from Pal2
BEEP '---------------
RndCol Pal2(0): Pal2(255) = Pal2(0)  'random color at beginning & end of
MakePal Pal2()                       'palette to generate a flowing palette
FadeIn Pal2()                        'fade into new palette
BEEP '---------------
RndCol Pal1(0): Pal1(255) = Pal1(0)  'generate new random palette
MakePal Pal1()
FadeInto Pal2(), Pal1()              'fade from Pal2 into Pal1
BEEP '---------------
RndCol Pal2(0): Pal2(255) = Pal2(0)  'generate another random palette
MakePal Pal2()
FadeInto Pal1(), Pal2()              'fade from Pal1 into new Pal2
BEEP '---------------
RndCol Pal1(0): Pal1(255) = Pal1(0)  'another random palette
MakePal Pal1()
FadeInto Pal2(), Pal1()              'fade
BEEP '---------------
FOR a = 0 TO 255                     'rotate palette once through
  RotatePal Pal1()
  DumpPal Pal1()
NEXT a
BEEP '---------------
FadeOut Pal1()                       'fade out
CLS
DumpPal Pal()                        'restore old palette
BEEP '---------------

COLOR 7
SCREEN 2: SCREEN 0                   'easy switching back to screen 0
SYSTEM                               'programs's over

SUB CopyPal (FromPal() AS PalType, IntoPal() AS PalType)
IF UBOUND(FromPal) <> UBOUND(IntoPal) THEN EXIT SUB

FOR a = 0 TO UBOUND(FromPal)
  IntoPal(a) = FromPal(a)
NEXT a
END SUB

SUB DumpPal (WhatPal() AS PalType)
FOR a = 0 TO UBOUND(WhatPal)
  SetPal a, WhatPal(a).R, WhatPal(a).G, WhatPal(a).B
NEXT a
END SUB

SUB FadeIn (WhatPal() AS PalType)
DIM WorkPal(UBOUND(WhatPal)) AS PalType

DO
  Count = 0
  FOR a = 0 TO UBOUND(WhatPal)
    IF WorkPal(a).R < WhatPal(a).R THEN WorkPal(a).R = WorkPal(a).R + 1: Count = Count + 1
    IF WorkPal(a).G < WhatPal(a).G THEN WorkPal(a).G = WorkPal(a).G + 1: Count = Count + 1
    IF WorkPal(a).B < WhatPal(a).B THEN WorkPal(a).B = WorkPal(a).B + 1: Count = Count + 1
  NEXT a
  DumpPal WorkPal()
LOOP UNTIL Count = 0
END SUB

SUB FadeInto (FromPal() AS PalType, IntoPal() AS PalType)
IF UBOUND(FromPal) <> UBOUND(IntoPal) THEN EXIT SUB
DIM WorkPal(UBOUND(FromPal)) AS PalType, Direc(UBOUND(FromPal)) AS PalType

FOR a = 0 TO UBOUND(FromPal)
  Direc(a).R = SGN(FromPal(a).R - IntoPal(a).R)
  Direc(a).G = SGN(FromPal(a).G - IntoPal(a).G)
  Direc(a).B = SGN(FromPal(a).B - IntoPal(a).B)
  WorkPal(a) = FromPal(a)
NEXT a

DO
  Count = 0
  FOR a = 0 TO UBOUND(FromPal)
    IF WorkPal(a).R <> IntoPal(a).R THEN WorkPal(a).R = WorkPal(a).R - Direc(a).R: Count = Count + 1
    IF WorkPal(a).G <> IntoPal(a).G THEN WorkPal(a).G = WorkPal(a).G - Direc(a).G: Count = Count + 1
    IF WorkPal(a).B <> IntoPal(a).B THEN WorkPal(a).B = WorkPal(a).B - Direc(a).B: Count = Count + 1
  NEXT a
  DumpPal WorkPal()
LOOP UNTIL Count = 0

END SUB

SUB FadeOut (WhatPal() AS PalType)
DIM WorkPal(UBOUND(WhatPal)) AS PalType

FOR a = 0 TO UBOUND(WhatPal)
  WorkPal(a) = WhatPal(a)
NEXT a

DO
  Count = 0
  FOR a = 0 TO UBOUND(WhatPal)
    IF WorkPal(a).R THEN WorkPal(a).R = WorkPal(a).R - 1: Count = Count + 1
    IF WorkPal(a).G THEN WorkPal(a).G = WorkPal(a).G - 1: Count = Count + 1
    IF WorkPal(a).B THEN WorkPal(a).B = WorkPal(a).B - 1: Count = Count + 1
  NEXT a
  DumpPal WorkPal()
LOOP UNTIL Count = 0
END SUB

SUB FillPal (WhatPal() AS PalType)
FOR a = 0 TO UBOUND(WhatPal)
  GetPal a, WhatPal(a).R, WhatPal(a).G, WhatPal(a).B
NEXT a
END SUB

SUB GetPal (Col, R, G, B)
OUT &H3C7, Col
R = INP(&H3C9)
G = INP(&H3C9)
B = INP(&H3C9)
END SUB

SUB InvertPal (WhatPal() AS PalType)
FOR a = 0 TO UBOUND(WhatPal)
  WhatPal(a).R = 63 - WhatPal(a).R
  WhatPal(a).G = 63 - WhatPal(a).G
  WhatPal(a).B = 63 - WhatPal(a).B
NEXT a
END SUB

SUB MakePal (WhatPal() AS PalType)
  x = 0: y = UBOUND(WhatPal)
  DIM cStack(256) AS STRING * 2
 
  TopStack = 0
  cStack(TopStack) = CHR$(x) + CHR$(y)
  TopStack = TopStack + 1
  DO UNTIL TopStack = 0
RePalMake:
    TopStack = TopStack - 1
    IF TopStack = -1 THEN EXIT DO
    tmp$ = cStack(TopStack)
    x = ASC(LEFT$(tmp$, 1))
    y = ASC(RIGHT$(tmp$, 1))

    z = (x + y) \ 2
    IF x = y OR x = z OR y = z THEN GOTO RePalMake
    q = ABS(x - y) \ 8
    '*** red
    R = (WhatPal(x).R + WhatPal(y).R) \ 2 + (INT(RND * 3) - 1) * q
    IF R < 0 THEN R = 0
    IF R > 63 THEN R = 63
    WhatPal(z).R = R
    '*** green
    G = (WhatPal(x).G + WhatPal(y).G) \ 2 + (INT(RND * 3) - 1) * q
    IF G < 0 THEN G = 0
    IF G > 63 THEN G = 63
    WhatPal(z).G = G
    '*** blue
    B = (WhatPal(x).B + WhatPal(y).B) \ 2 + (INT(RND * 3) - 1) * q
    IF B < 0 THEN B = 0
    IF B > 63 THEN B = 63
    WhatPal(z).B = B
    '***
    cStack(TopStack) = CHR$(x) + CHR$(z)
    TopStack = TopStack + 1
    cStack(TopStack) = CHR$(z) + CHR$(y)
    TopStack = TopStack + 1
  LOOP
END SUB

SUB RndCol (Clr AS PalType)
R = RND * 64
G = RND * 64
B = RND * 64
Clr.R = R: Clr.G = G: Clr.B = B
END SUB

SUB RotatePal (WhatPal() AS PalType)
FOR a = UBOUND(WhatPal) - 1 TO 0 STEP -1
  SWAP WhatPal(a), WhatPal(a + 1)
NEXT a
END SUB

SUB SetPal (Col, R, G, B)
OUT &H3C8, Col
OUT &H3C9, R
OUT &H3C9, G
OUT &H3C9, B
END SUB

SUB SwapPal (Pal1() AS PalType, Pal2() AS PalType)
IF UBOUND(Pal1) <> UBOUND(Pal2) THEN EXIT SUB

FOR a = 0 TO UBOUND(Pal1)
  SWAP Pal1(a), Pal2(a)
NEXT a
END SUB

