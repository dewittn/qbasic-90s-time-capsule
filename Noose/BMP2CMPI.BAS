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
DECLARE SUB LoadBmp (file$, xpos%, ypos%, mx%, my%)
TYPE PalType
  R AS INTEGER
  G AS INTEGER
  B AS INTEGER
END TYPE
TYPE StackType
  x1 AS INTEGER
  y1 AS INTEGER
  x2 AS INTEGER
  y2 AS INTEGER
END TYPE

RANDOMIZE TIMER
DIM Stack(255) AS StackType
DIM Pal(255) AS PalType
SCREEN 13

LOCATE 25, 2: PRINT "Loading...";
'Load Piture
LoadBmp "EVA256.BMP", -2, -2, mx, my
'Get Picture palette
FillPal Pal()
'Draw screen
mx = mx - 2: my = my - 2
LINE (160, 0)-(160, 188), 15
LINE (0, 188)-(320, 188), 15
FOR y = my TO 0 STEP -1
  FOR x = 0 TO mx
    PSET (x + 161, y), POINT(x, y)
  NEXT x
NEXT y
'Here we go... (say: heeweego)
LOCATE 25, 2: PRINT "Scanning mosaic level frames ..."; '<--- doesn't that sound cool? :)

'Stack(0).x1 = 0: Stack(0).x2 = mx
'Stack(0).y1 = 0: Stack(0).y2 = my
'Sp = 1
'DO
'SKPT:
'  Sp = Sp - 1
'  'LOCATE 20, 1: PRINT Sp
'  IF Sp = -1 THEN EXIT DO
'  x1 = Stack(Sp).x1: y1 = Stack(Sp).y1
'  x2 = Stack(Sp).x2: y2 = Stack(Sp).y2
'  xc = (x2 - x1) \ 2 + x1
'  yc = (y2 - y1) \ 2 + y1
'  IF xc = x1 OR yc = y1 THEN GOTO SKPT
'  Stack(Sp).x1 = x1: Stack(Sp).y1 = y1
'  Stack(Sp).x2 = xc: Stack(Sp).y2 = yc
'  Sp = Sp + 1
'  'LOCATE 20, 1: PRINT Sp
'  Stack(Sp).x1 = xc: Stack(Sp).y1 = y1
'  Stack(Sp).x2 = x2: Stack(Sp).y2 = yc
'  Sp = Sp + 1
'  'LOCATE 20, 1: PRINT Sp
'  Stack(Sp).x1 = x1: Stack(Sp).y1 = yc
'  Stack(Sp).x2 = xc: Stack(Sp).y2 = y2
'  Sp = Sp + 1
'  'LOCATE 20, 1: PRINT Sp
'  Stack(Sp).x1 = xc: Stack(Sp).y1 = yc
'  Stack(Sp).x2 = x2: Stack(Sp).y2 = y2
'  Sp = Sp + 1
'  'LOCATE 20, 1: PRINT Sp
'  Cnt& = 0
'  Rd& = 0: Gd& = 0: Bd& = 0
'  FOR x = x1 TO x2
'    FOR y = y1 TO y2
'      c = POINT(x, y)
'      GetPal c, nR, nG, nB
'      Rd& = Rd& + nR
'      Gd& = Gd& + nG
'      Bd& = Bd& + nB
'      Cnt& = Cnt& + 1
'    NEXT y
'  NEXT x
'  nR = Rd& \ Cnt&
'  nG = Gd& \ Cnt&
'  nB = Bd& \ Cnt&
'  cPos = 0
'  bR = 64: bG = 64: bB = 64
'  FOR a = 0 TO 255
'    diR = ABS(nR - Pal(a).R)
'    diG = ABS(nG - Pal(a).G)
'    diB = ABS(nB - Pal(a).B)
'    IF diR < bR THEN bR = diR
'    IF diG < bG THEN bG = diG
'    IF diB < bB THEN bB = diB
'    IF diR = bR AND diG = bG AND diB = bB THEN cPos = a
'  NEXT a
'  'LOCATE 20, 1: PRINT cPos
'  LINE (161 + x1, y1)-(161 + x2, y2), cPos, BF
'LOOP UNTIL Sp = 0

'FOR bs = 15 TO 1 STEP -2
'  FOR y = 0 TO my + bs STEP bs
'  'LOCATE 20, 1: PRINT my + bs
'    FOR x = 0 TO mx + bs STEP bs
'      x1 = x: x2 = x + bs - 1
'      y1 = y: y2 = y + bs - 1
'      IF x2 > mx THEN x2 = mx + 1
'      IF y2 > my THEN y2 = my + 1
'      Cnt& = 0
'      Rd& = 0: Gd& = 0: Bd& = 0
'      FOR xc = x1 TO x2
'        FOR yc = y1 TO y2
'          c = POINT(xc, yc)
'          'PSET (xc + 161, yc), 0
'          GetPal c, nR, nG, nB
'          Rd& = Rd& + nR
'          Gd& = Gd& + nG
'          Bd& = Bd& + nB
'          Cnt& = Cnt& + 1
'        NEXT yc
'      NEXT xc
'      IF Cnt& = 0 THEN Cnt& = 1
'      nR = Rd& \ Cnt&
'      nG = Gd& \ Cnt&
'      nB = Bd& \ Cnt&
'      cPos = 0
'      bR = 64: bG = 64: bB = 64
'      FOR a = 0 TO 255
'        diR = ABS(nR - Pal(a).R)
'        diG = ABS(nG - Pal(a).G)
'        diB = ABS(nB - Pal(a).B)
'        IF diR < bR THEN bR = diR
'        IF diG < bG THEN bG = diG
'        IF diB < bB THEN bB = diB
'        IF diR = bR AND diG = bG AND diB = bB THEN cPos = a
'      NEXT a
'      LINE (161 + x1, y1)-(161 + x2, y2), cPos, BF
'      Bk& = Bk& + 1
'    NEXT x
'  NEXT y
'EndItNow:
'NEXT bs

LOCATE 25, 2: PRINT "                                ";
DO: LOOP UNTIL INKEY$ <> ""
SCREEN 2: SCREEN 0

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

SUB LoadBmp (file$, xpos, ypos, mx, my)
IF LTRIM$(RTRIM$(file$)) = "" THEN EXIT SUB
FFile = FREEFILE
OPEN file$ FOR BINARY AS #FFile
IF LOF(FFile) = 0 THEN
 PRINT "Error: "; file$; " not found!"
 CLOSE
 KILL file$
 EXIT SUB
END IF
table$ = INPUT$(54, #FFile)  'Get the file header (54 bytes)
DIM table&(30)           'Create numerical array for header
DEF SEG = VARSEG(table&(1))
pointer% = VARPTR(table&(1))

'Poke the data from string "table$" into numerical array "table&"
FOR x% = 0 TO 51
 POKE pointer% + x%, ASC(MID$(table$, x% + 3, 1))
NEXT
DEF SEG

'Check for valid file type
IF MID$(table$, 1, 2) <> "BM" OR table&(4) <> 40 THEN
   PRINT "Error while loading "; file$: EXIT SUB
END IF
IF table&(8) <> 0 THEN
   PRINT "Error while loading "; file$: EXIT SUB
END IF
Hcol = 2 ^ ASC(MID$(table$, 29, 1))
IF Hcol <> 256 AND Hcol <> 16 THEN
   PRINT "Only 256 or 16 colors supported!": EXIT SUB
END IF

thecolors$ = INPUT$(table&(3) - 54, #FFile) 'Read in pallette info
DIM byte AS STRING * 1
FOR K = 0 TO Hcol - 1
   GET FFile, 55 + 4 * K, byte
   B = ASC(byte) \ 4
   GET FFile, 56 + 4 * K, byte
   G = ASC(byte) \ 4
   GET FFile, 57 + 4 * K, byte
   R = ASC(byte) \ 4
   OUT &H3C8, K
   OUT &H3C9, R
   OUT &H3C9, G
   OUT &H3C9, B
NEXT K

'Read in Bitmap data and set pixels accordingly
y% = table&(6) 'Put number of vertical pixels into y%
my = y
IF Hcol = 16 THEN
 xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
 IF (table&(5) \ 2) < LEN(xdata$) THEN
   linelength% = table&(5) \ 2
 ELSE
   linelength% = LEN(xdata$)
 END IF
ELSE
 xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1), #1)
 IF (table&(5)) < LEN(xdata$) THEN
   linelength% = table&(5)
 ELSE
   linelength% = LEN(xdata$)
 END IF
END IF
IF linelength > mx THEN mx = linelength
DO
    IF Hcol = 16 THEN
      xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
      IF (table&(5) \ 2) < LEN(xdata$) THEN
        linelength% = table&(5) \ 2
      ELSE
        linelength% = LEN(xdata$)
      END IF
    ELSE
      xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1), #1)
      IF (table&(5)) < LEN(xdata$) THEN
        linelength% = table&(5)
      ELSE
        linelength% = LEN(xdata$)
      END IF
    END IF
    IF linelength > mx THEN mx = linelength
   
    FOR x% = 1 TO linelength%
      pixel% = ASC(MID$(xdata$, x%, 1))
      IF Hcol = 16 THEN
        PSET (x% * 2 + 1 + xpos, y% + ypos), pixel% AND 15
        PSET (x% * 2 + xpos, y% + ypos), pixel% \ 16
      ELSE
        PSET (x% + xpos, y% + ypos), pixel%
      END IF
     NEXT
    y% = y% - 1
LOOP UNTIL EOF(FFile)
CLOSE #FFile
ERASE table&
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

