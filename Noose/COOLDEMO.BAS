DEFINT A-Z
'$DYNAMIC
DECLARE SUB EmptyBuff ()
DECLARE SUB DrawLogo (sig%, col%)
DECLARE SUB DrawVIVID.BMP (Xpos%, Ypos%)
DECLARE SUB SFTwinkleDown (Star() AS ANY)
DECLARE SUB SFDraw (Star() AS ANY)
DECLARE SUB SFPull (Star() AS ANY)
DECLARE SUB SFExpl (Star() AS ANY)
DECLARE SUB SFBlackHole (Star() AS ANY)
DECLARE SUB SFInitBoom (Star() AS ANY, x%, y%)
DECLARE SUB SFBoom (Star() AS ANY)
DECLARE SUB SFBounce (Star() AS ANY)
DECLARE SUB SFClear (Star() AS ANY)
DECLARE SUB SFStd (Star() AS ANY)
DECLARE SUB SFInit (Star() AS ANY, x1%, y1%, x2%, y2%)
DECLARE SUB SFSuck (Star() AS ANY)
DECLARE SUB SFTwinkle (Star() AS ANY)
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
DECLARE SUB GetPal (col%, r%, G%, b%)
DECLARE SUB SetPal (col%, r%, G%, b%)
TYPE PalType
  r AS INTEGER
  G AS INTEGER
  b AS INTEGER
END TYPE
TYPE StarType
  x AS INTEGER   'current screen pos
  y AS INTEGER   '
  s AS INTEGER   'speed (x speed)
  b AS INTEGER   'bounce (y speed)
  c AS INTEGER   'color
  x1 AS INTEGER  'field borders
  y1 AS INTEGER
  x2 AS INTEGER
  y2 AS INTEGER
  xc AS INTEGER  'center of field
  yc AS INTEGER
  v AS INTEGER   'current explosion status
  d AS INTEGER   'distance to explode
  sx AS INTEGER  'spray distance
  sy AS INTEGER
  xv AS INTEGER  'explosion center
  yv AS INTEGER
  xd AS INTEGER  'destination
  yd AS INTEGER
END TYPE
TYPE CoordType
  x AS INTEGER
  y AS INTEGER
END TYPE
RANDOMIZE TIMER
DIM Pal(255) AS PalType
DIM oPal(255) AS PalType
DIM mPal(255) AS PalType
DIM dPal(255) AS PalType
FOR a = 0 TO 255
  READ oPal(a).r
  READ oPal(a).G
  READ oPal(a).b
NEXT a
SCREEN 13
FillPal Pal()
MakePal mPal()
mPal(0) = Pal(0)
mPal(1) = Pal(15)
DumpPal mPal()
FadeOut mPal()
CLS
CopyPal Pal(), dPal()
FOR T = 1 TO 20
  dPal(T + 200).r = T * 3 + 3
  dPal(T + 200).G = T * 3 + 3
  dPal(T + 200).b = T * 3 + 3
NEXT

DrawLogo -1, 1
'---<fill>---
FOR y = 0 TO 200
  x = -1
  DO
    x = x + 1
    IF POINT(x, y) = 1 THEN
      FOR x2 = x TO 321
        IF POINT(x2, y) = 0 THEN EXIT FOR
      NEXT x2
      LINE (x, y)-(x2 - 1, y), y
      x = x2
    END IF
  LOOP UNTIL x > 320
NEXT y
COLOR 1: LOCATE 25, 2: PRINT "Press any key...";
FadeIn mPal()
eT! = TIMER + 10
EmptyBuff
DO
  RotatePal mPal()
  DumpPal mPal()
LOOP UNTIL INKEY$ <> "" OR TIMER >= eT!
LOCATE 25, 2: PRINT "                ";
EmptyBuff
FOR a = 0 TO 200
 FOR y = 11 + a TO 0 + a STEP -2
  FOR x = 0 TO 320
    c = POINT(x, y)
    IF c > 0 THEN
      x2 = x + RND * 8 - 4
      y2 = y - RND * 2 + 1
      PSET (x, y), 0
      PSET (x2, y2), c
    END IF
  NEXT x
 IF INKEY$ <> "" THEN GOTO GettingBored:
 NEXT y
 RotatePal mPal()
 DumpPal mPal()
NEXT a
GettingBored:
FadeOut mPal()
CLS
s$ = "This is a really cool demo!"
COLOR 1: LOCATE 1, 1: PRINT s$
s = 0
FOR y = 0 TO 16
 FOR x = 0 TO LEN(s$) * 8
  IF POINT(x, y) = 1 THEN s = s + 1
 NEXT x
NEXT y
DIM Stars(s) AS StarType
SFInit Stars(), 0, 0, 320, 188
'DumpPal dPal()
s = 0
FOR y = 0 TO 16
 FOR x = 0 TO LEN(s$) * 8
  IF POINT(x, y) = 1 THEN s = s + 1: Stars(s).xd = 80 + x: Stars(s).yd = 80 + y  ': PSET (x, y), 100
 NEXT x
NEXT y
LOCATE 1, 1: PRINT SPACE$(LEN(s$))
'SFInitBoom Stars(), Stars(a).xc, Stars(a).yc
SFDraw Stars()
FOR a = 1 TO UBOUND(Stars): Stars(a).v = 0: NEXT a
ns = 0
RESTORE TextData
READ x$, y$
TXT$ = x$ + " " + y$
FadeIn dPal()
rtc = 25
sP = 0
scrTXTstat = 345
EmptyBuff
DO
  SELECT CASE ns
    CASE 0                 'Standrad starfield
      SFStd Stars()
    CASE 1                 'Pull
      IF mc = 0 THEN
        FOR a = 1 TO UBOUND(Stars): Stars(a).v = 0: NEXT a
      END IF
      SFPull Stars()
      mc = mc + 1
      IF mc = 200 THEN
        FOR a = 1 TO UBOUND(Stars)
          IF Stars(a).x <> Stars(a).xd OR Stars(a).y <> Stars(a).yd THEN
            PSET (Stars(a).x, Stars(a).y), 0
            Stars(a).x = Stars(a).xd
            Stars(a).y = Stars(a).yd
          END IF
        NEXT a
        SFDraw Stars()
      END IF
    CASE 2
      SFSuck Stars()
      mc = mc + 1
      IF mc = 110 THEN mc = 0: ns = 3
    CASE 3                 'Explode
      IF mc = 0 THEN FOR a = 1 TO UBOUND(Stars): Stars(a).v = 0: NEXT a
      SFBoom Stars()
    CASE 4                 'Bounce
      SFBounce Stars()
    CASE 5
      SFSuck Stars()       'Suck
    CASE 101               'Single explosion
      IF mc = 0 THEN SFClear Stars(): SFInitBoom Stars(), Stars(1).xc, Stars(1).yc
      SFBoom Stars()
      mc = mc + 1
      IF mc = 300 THEN mc = 0: ns = 0
    CASE 102
      IF mc >= 0 AND mc < 25 THEN
        SFSuck Stars()
      ELSE
        SFBoom Stars()
      END IF
      mc = mc + 1
      IF mc = 25 + rtc THEN mc = 0: rtc = rtc + RND * 5
    CASE 103
      SFTwinkleDown Stars()
    CASE 123
      'Here's the big show! we don't need the main loop now since we don't
      'need the scrolltext multitasking or any stuff like that.
      '* Fade out and get rid of the stuff on the screen
       FadeOut dPal(): CLS
      '* Movie credits... :)
       COLOR 15: LOCATE 9, 21: PRINT "a"
       DrawVIVID.BMP 111, 73
       COLOR 15: LOCATE 18, 16: PRINT "production"
       FadeIn Pal(): SLEEP 4: FadeOut Pal(): CLS
       COLOR 15: LOCATE 10, 16: PRINT "written by"
       LOCATE 11, 12: PRINT "Hauke Daempfling"
       FadeIn Pal(): SLEEP 4: FadeOut Pal(): CLS
       DrawLogo 0, 15
       FadeIn Pal()
       PLAY "mbl8t255o3bo4cdo3bo4co3abgaf#t120gbt200dp8t255o4cdecdo3bo4co3abgt120f#at200dp8t255ef#gdef#gef#g#aef#g#ag#abo4co3bo4cdeco3af#gdgbt120g"
       SLEEP 1: FadeOut Pal(): CLS
       FOR a = 72 TO 1 STEP -1
         c = a \ 3 + 31
         CIRCLE (160, 100), a, c
         PAINT (160, 100), c, c
       NEXT a
       PAINT (160, 100), 15, c
       FadeIn oPal()
       DIM rPal(255) AS PalType
       CopyPal oPal(), rPal()
       T$ = "Super Palette Procedures"
       LOCATE 1, 20 - LEN(T$) \ 2
       FOR a = 1 TO LEN(T$)
         COLOR a + 31
         PRINT MID$(T$, a, 1);
       NEXT a
       COLOR 14: PRINT "!"
       FOR b = 1 TO 24
         FOR a = 32 TO 55 'STEP -1
           SWAP rPal(a), rPal(a + 1)
           DumpPal rPal()
         NEXT a
       NEXT b
       FadeOut rPal()
       CLS
       ERASE rPal
       FOR a = 1 TO 72
         CIRCLE (160, 100), a, 0
       NEXT a
       RESTORE TunnelCoord
       DIM cP(60) AS CoordType
       FOR a = 0 TO 49
         READ cP(a).x, cP(a).y
       NEXT a
       a = -1
       DumpPal oPal()
       cc = 10
       DO
         cc = cc + 1
         IF cc > 10 THEN
           a = a + 1
           IF a = 51 THEN a = 0
           cc = 1
         END IF
         s = a - 1: IF s = -1 THEN s = 50
         Ox = -cP(s).x: Oy = -cP(s).y
         r = 161
         FOR b = 0 TO 7
            s = b + a: IF s > 50 THEN s = s - 50
            Cx = cP(s).x + 160 + Ox: Cy = cP(s).y + 100 + Oy
            CIRCLE (Cx, Cy), r + cc * 2, 0
            r = r - 19
         NEXT b
         r = 161
         Ox = -cP(a).x: Oy = -cP(a).y
         FOR b = 1 TO 8
            s = b + a: IF s > 50 THEN s = s - 50
            Cx = cP(s).x + 160 + Ox: Cy = cP(s).y + 100 + Oy
            CIRCLE (Cx, Cy), r + cc * 2, b + 47
            r = r - 19
         NEXT b
       LOOP UNTIL INKEY$ <> ""
       ERASE cP
       FadeOut oPal(): CLS : DumpPal Pal()
      '* We're done. Now we can set up normal scrolltext...
       FadeOut Pal(): CLS
       SFInit Stars(), 0, 0, 320, 188
       SFDraw Stars()
       FadeIn dPal()
       mc = 0: ns = 0
       scrTXTstat = 345
       RESTORE EndTextData
    CASE 109
      EXIT DO
  END SELECT
  a$ = INKEY$
  IF scrTXTstat = 345 THEN eT! = TIMER + .3: scrTXTstat = -123
  IF scrTXTstat = -123 THEN
    IF TIMER >= eT! OR a$ = " " THEN
      'LOCATE 1, 1: PRINT sP
      sP = sP + 1
      IF sP + 38 > LEN(TXT$) THEN
        'RESTORE TextData
        READ x$
        TXT$ = TXT$ + " " + x$
      END IF
      IF sP > 100 THEN TXT$ = MID$(TXT$, sP):  sP = 1
      p$ = MID$(TXT$, sP, 38)
      IF RIGHT$(p$, 1) = "~" THEN p$ = LEFT$(p$, 37)
      IF RIGHT$(p$, 1) = "^" THEN p$ = LEFT$(p$, 37)
      IF MID$(p$, 37, 1) = "~" THEN
        mc = 0
        ns = 100 + VAL(MID$(p$, 38, 1))
        MID$(TXT$, sP + 36, 2) = "  "
        p$ = LEFT$(p$, 35)
      END IF
      IF MID$(p$, 37, 1) = "^" THEN
        mc = 0
        ns = VAL(MID$(p$, 38, 1))
        MID$(TXT$, sP + 36, 2) = "  "
        p$ = LEFT$(p$, 36)
      END IF
      IF RIGHT$(p$, 1) = "ø" THEN
        mc = 0
        ns = 123
        sP = sP + 37
        p$ = LEFT$(p$, 37)
        scrTXTstat = 444
        sP = 0
        TXT$ = ""
      END IF
      COLOR 15
      LOCATE 25, 2
      PRINT p$; SPACE$(38 - LEN(p$));
      eT! = TIMER + .2
    END IF
  END IF
LOOP UNTIL a$ = CHR$(27)

FadeOut dPal()
CLS
MakePal mPal()
mPal(0) = Pal(0)
mPal(1) = Pal(15)
COLOR 1
LOCATE 2, 2: PRINT "THIS IS THE END OF THE DEMO (DUH)."
LOCATE 4, 2: PRINT "I hoped you liked it and weren't too"
LOCATE 5, 2: PRINT "bored. Just a reminder that this"
LOCATE 6, 2: PRINT "contains a lot of good procedures"
LOCATE 7, 2: PRINT "I wrote, so I'd appreciate it if"
LOCATE 8, 2: PRINT "you gave me crdit somewhere in your"
LOCATE 9, 2: PRINT "program if you use them. Thanks!"
LOCATE 13, 20: PRINT "- Hauke"
LOCATE 11, 22: PRINT "See ya!"
FOR y = 0 TO 200
  x = -1
  DO
    x = x + 1
    IF POINT(x, y) = 1 THEN
      FOR x2 = x TO 321
        IF POINT(x2, y) = 0 THEN EXIT FOR
      NEXT x2
      LINE (x, y)-(x2 - 1, y), y
      x = x2
    END IF
  LOOP UNTIL x > 320
NEXT y
FadeIn mPal()
COLOR 1: LOCATE 25, 2: PRINT "Press any key...";
eT! = TIMER + 30
EmptyBuff
DO
  RotatePal mPal()
  DumpPal mPal()
LOOP UNTIL INKEY$ <> "" OR TIMER >= eT!
FadeOut mPal()
SCREEN 2: SCREEN 0: CLS
PRINT "Goodbye!"
SYSTEM

'***>--- Colors:
'0          = black
'1   to 31  = white to black
'32  to 46  = white to red
'47  to 56  = red to black
'57  to 63  = orange to black
'64  to 71  = white to yellow
'72  to 87  = yellow to black
'88  to 104 = yellow to green
'105 to 120 = white to green
'121 to 127 = green to black
'128 to 144 = white to blue
'145 to 159 = blue to black
'160 to 166 = white to purple
'167 to 175 = purple to black
'176 to 181 = white to cyan
'182 to 191 = cyan to white
'192 to 206 = white to lt. blue
'207 to 223 = lt. blue to black
'224 to 236 = white to peach (skin color)
'237 to 256 = peach to black

'0          = black
DATA 00,00,00

'1   to 31  = white to black
DATA 63,63,63, 60,60,60, 58,58,58, 56,56,56, 53,53,53, 51,51,51
DATA 49,49,49, 47,47,47, 44,44,44, 42,42,42, 40,40,40, 37,37,37
DATA 35,35,35, 33,33,33, 31,31,31, 29,29,29, 27,27,27, 25,25,25
DATA 23,23,23, 21,21,21, 19,19,19, 17,17,17, 15,15,15, 13,13,13
DATA 11,11,11, 09,09,09, 07,07,07, 05,05,05, 03,03,03, 01,01,01
DATA 00,00,00

'32  to 46  = white to red
DATA 63,58,58, 62,53,53, 61,48,48, 60,44,44
DATA 59,40,40, 58,35,35, 57,31,31, 57,27,27, 56,23,23, 55,19,19
DATA 54,16,16, 53,12,12, 52,08,08, 51,05,05, 50,02,02, 50,00,00

'47  to 56  = red to black
DATA 46,00,00, 42,00,00, 38,00,00, 33,00,00, 29,00,00, 25,00,00
DATA 21,00,00, 17,00,00, 13,00,00

'57  to 63  = orange to black
DATA 63,29,00, 55,25,00, 48,22,00
DATA 40,18,00, 33,15,00, 25,11,00, 18,08,00

'64  to 71  = white to yellow
DATA 63,63,54, 63,63,46
DATA 62,63,38, 62,63,30, 62,63,22, 61,63,14, 61,63,06, 59,61,00

'72  to 87  = yellow to black
DATA 59,59,00, 56,55,00, 53,51,00, 50,46,00, 47,42,00, 44,38,00
DATA 41,34,00, 38,31,00, 34,26,00, 30,22,00, 26,18,00, 22,15,00
DATA 18,11,00, 14,08,00, 10,05,00, 06,03,00

'88  to 104 = yellow to green
DATA 54,63,22, 49,59,17
DATA 45,56,13, 41,52,10, 37,49,06, 33,45,03, 29,42,01, 26,39,00
DATA 21,36,00, 19,33,00, 18,31,00, 17,29,00, 16,27,00, 14,25,00
DATA 13,23,00, 12,21,00, 11,19,00

'105 to 120 = white to green
DATA 47,62,47, 39,60,38, 32,58,31
DATA 23,56,23, 16,55,16, 11,53,10, 10,50,09, 08,47,08, 07,45,07
DATA 06,42,06, 05,39,04, 04,36,04, 03,34,03, 02,31,02, 02,28,02
DATA 01,26,01

'121 to 127 = green to black
DATA 01,23,01, 01,20,00, 00,17,00, 00,15,00, 00,12,00
DATA 00,09,00, 00,07,00

'128 to 144 = white to blue
DATA 60,60,63, 56,56,63, 51,51,63, 47,47,63
DATA 43,44,63, 39,40,63, 35,35,63, 31,32,63, 27,28,63, 23,24,63
DATA 19,20,63, 15,16,63, 11,12,63, 07,08,63, 03,04,63, 00,01,63
DATA 00,00,63

'145 to 159 = blue to black
DATA 00,00,59, 00,00,55, 00,00,51, 00,00,47, 00,00,43
DATA 00,00,39, 00,00,36, 00,00,32, 00,00,28, 00,00,24, 00,00,20
DATA 00,00,16, 00,00,12, 00,00,08, 00,00,05

'160 to 166 = white to purple
DATA 60,54,63, 57,46,63
DATA 54,39,63, 52,31,63, 50,23,63, 47,16,63, 45,08,63

'167 to 175 = purple to black
DATA 42,00,63
DATA 38,00,57, 32,00,50, 27,00,43, 21,00,35, 15,00,27, 10,00,20
DATA 06,00,12, 02,00,05

'176 to 181 = white to cyan (lt. blue + lt. green)
DATA 51,63,63, 45,59,59, 39,56,56, 34,53,53
DATA 29,50,50, 25,47,47

'182 to 191 = cyan to white
DATA 20,43,43, 17,40,40, 13,36,36, 09,31,31
DATA 07,27,27, 04,23,23, 02,19,19, 01,15,15, 00,11,11, 00,07,07

'192 to 206 = white to lt. blue
DATA 58,60,62, 54,58,61, 49,55,61, 45,53,61, 41,51,60, 37,49,60
DATA 33,48,60, 29,46,59, 25,44,59, 21,43,59, 17,41,58, 13,40,58
DATA 10,38,58, 06,37,57, 02,36,57

'207 to 223 = lt. blue to black
DATA 01,33,54, 01,31,51, 00,29,48
DATA 00,27,45, 00,25,43, 00,23,40, 00,21,37, 00,20,34, 00,18,31
DATA 00,16,28, 00,14,24, 00,12,21, 00,10,18, 00,08,15, 00,06,12
DATA 00,05,09, 00,03,06

'224 to 236 = white to peach (skin color)
DATA 63,58,55, 63,55,51, 63,53,48, 63,51,44
DATA 63,49,41, 63,47,37, 63,45,34, 63,43,31, 63,41,27, 63,39,24
DATA 60,37,23, 58,36,22, 56,34,21

'237 to 256 = peach to black
DATA 54,33,20, 52,32,20, 50,31,19
DATA 47,29,17, 44,27,16, 41,26,14, 38,24,13, 35,22,12, 32,21,10
DATA 29,19,09, 26,17,08, 23,15,07, 20,13,06, 17,12,05, 14,10,03
DATA 11,08,03, 09,06,02, 06,04,01, 0,0,0

TextData:                   
'DATA "                                    Hi! It's me, Hauke from VIVID"
'DATA "software! I've never written a^4demo before, so I^0just thought I'd write one! I'm putting^4in as many"
'DATA "effects as I can like multiple^0starfields, and super fast palette"
'DATA "manipulation. This program^4is probably a big memory hog because"
'DATA "a single star takes about 100 bytes... ~1 Anyway, I took about ten"
'DATA "thousand little^4programs I wrote and pieced them all together to"
'DATA "make - tah-dah^1- this demo! Also, I think this is one of the best"
'DATA "scrolltext thingys^2I've ever written, because I can control the"
'DATA "effects out of the scrolltext! Like this...           ~1that should"
'DATA "have been something cool... :)^4Well, I think I should go back to"
'DATA "writing some new effects...  ~2                             um..."
'DATA "anyone have any^0suggestions for how I can make a fill^4procedure"
'DATA "that's faster than PAINT?... ^1 Ugh, QB :)...       Well, QB does"
'DATA "have some advantages, like: the^3source code comes with it and uh..."
'DATA "well... like... yeah! I've^0watched the demo a few times by now and"
DATA "I have the feeling this is getting boring... so here comes the big"
DATA "show! Sit back, I'm shutting~3off the scrolltext now. Heeweego... ø"
EndTextData:
DATA "                                   That was the big show... how'd ya"
DATA "like it? See ya later!   THE END    ~9                              "
DATA "                                                                    "

PicVIVID.BMPdata:
DATA 103, 57
DATA FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F777777
DATA 777777777777777777777777777777777777777777777777778F7777777777777
DATA 77777777777777777777777777777777777777777778F77FFFF87777777777777
DATA 77777777777777777777FFFF8777777777778F77F777877777777777777777777
DATA 7777777777777F7778777777777778F77F777FF77777777777777777777777777
DATA 777777F7778777777777778F77F77777FFFF7777777777777777777777777777F
DATA 7778777777777778F77F777777777FFFF777777777777777777777777F7778777
DATA 777777778F77F7777777777777FFFF77777777777777777777F77787777777777
DATA 78F77F77777777777777777FFFF7777777777777777F7778777777777778F77F7
DATA 77888777777777777777FFF7777777777777F7778777777777778F77F77787788
DATA 8877777777777777FFFF777777777F7778777777777778F77F777877777788887
DATA 7777777777777FFFF77777F7778777777777778F77F7778777777777788887777
DATA 7777777777FFFF7F7778777777777778F77F77787777777777777788877777777
DATA 7777777FF7778777777777778F77F777877777777777777777888877777777777
DATA 777778777777777778F77F7778777777777777777777777888877777777777787
DATA 77777777778F77F77787777777777777777777777777888877777777877777777
DATA 7778F77F7778777777777777777777777FFFF7777777777778777777777778F77
DATA F777877777777777777777FFFF77777777777777778777777777778F77F777877
DATA 777777777777FFF7777777777777778F7778777777777778F77F7778777777777
DATA 7FFFF7777777777777788887F7778777777777778F77F7778777777FFFF777777
DATA 77777777888877777F7778777FF77F7778F77F777877FFFF77777777777777888
DATA 8777777777F777877F78F77F778F77F777FFF7777777777777778887777777777
DATA 777F777877F87F87F878F77F7777777777777777788887777777777777777F777
DATA 877F87F87F878F77F7777777777777888877777777777777777777F7778777F77
DATA FF7878F77F7777777778888777777777777777777777777F7778777787788778F
DATA 77F7777788887777777777777777777777777777F7778777FFFFF7778F77F7778
DATA 877777777777777777777777777777777F777877F78888F778F77F77787777777
DATA 77777777777777777777777777F777877F87777F878F77F777877777777777777
DATA 7777777777777777777F777877F87777F878F77F777FFFFFFFFFFFFFFFFFFFFFF
DATA FFFFFFFFFFFFF7778777FFFFF7878F77F77777777777777777777777777777777
DATA 7777777778777788888778F77F777777777777777777777777777777777777777
DATA 77877FFFFFFF778F77F77777777777777777777777777777777777777777877F8
DATA 8F888878F77F7778888888888888888888888888888888888F777877F87F87777
DATA 8F77F7778777777777777777777777777777777777F777877F877877778F77F77
DATA 78777777777777777777777777777777777F7778777877777778F77F777FF7777
DATA 7777777777777777777777777777F777877F777777778F77F77777FFFF7777777
DATA 777777777777777777777F777877F877777778F77F777777777FFFF7777777777
DATA 77777777777777F777877FFFFFFF778F77F7777777777777FFFF7777777777777
DATA 7777777F777877F888888878F77F77777777777777777FFFF7777777777777777
DATA F777877F877777778F77F777888777777777777777FFF7777777777777F777877
DATA 7877777778F77F777877888877777777777777FFFF777777777F777877FFFFFF7
DATA 778F77F7778777777888877777777777777FFFF77777F777877788888F778F77F
DATA 77787777777777888877777777777777FFFF7F77787777777F7878F77F7778777
DATA 77777777777888777777777777777FF777877777777F778F77F77787777777777
DATA 777777788887777777777777777877FFFFFF7878F77F777877777777777777777
DATA 777788887777777777778777888888778F77F7778777777777777777777777777
DATA 78888777777778777FFFFFF778F77F7778777777777777777777777FFFF777777
DATA 777777877F78F888878F77F777877777777777777777FFFF77777777777777778
DATA 77F87F877778F77F777877777777777777FFF7777777777777778F7778777FFFF
DATA FF778F77F77787777777777FFFF7777777777777788887F7778777788888878F7
DATA 7F7778777777FFFF77777777777777888877777F777877FFFFFFF778F77F77787
DATA 7FFFF777777777777778888777777777F777877F88F888878F77F777FFF777777
DATA 7777777778887777777777777F777877F87F877778F77F7777777777777777788
DATA 887777777777777777F7778777FF7FFF778F77F77777777777778888777777777
DATA 77777777777F7778777788788878F77F777777777888877777777777777777777
DATA 7777F777877FFFFFFF778F77F7777788887777777777777777777777777777F77
DATA 7877F88F88F878F77F7778877777777777777777777777777777777F777877F87
DATA F87F878F77F7778777777777777777777777777777777777F777877F87787F878
DATA F77F7778777777777777777777777777777777777F7778777877777878F77F777
DATA FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7778777777777778F77F7777777777
DATA 77777777777777777777777777777778777777777778F77F77777777777777777
DATA 7777777777777777777777778777777777778F77F777777777777777777777777
DATA 777777777777777778777777777778F77F7778888888888888888888888888888
DATA 888888F7778777777777778F77F7778777777777777777777777777777777777F
DATA 7778777777777778F77F7778777777777777777777777777777777777F7778777
DATA 777777778F77F7778777777777777777777777777777777777F77787777777777
DATA 78F77F7778777777777777777777777777777777777F7778777777777778F77F7
DATA 77FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7778777777777778F77F77777777
DATA 7777777777777777777777777777777778777777777778F77F777777777777777
DATA 777777777777777777777777778777777777778F77F7777777777777777777777
DATA 77777777777777777778777777777778F77F77788888888888888888888888888
DATA 8888888887778777777777778F77F777877777777777777777777777777777777
DATA 7F7778777777777778F77F7778777777777777777777777777777777777F77787
DATA 77777777778F77F7778777777777777777777777777777777777F777877777777
DATA 7778F777F777877777777777777777777777777777777F7778777777777778F77
DATA 7F77787777777777777777777777777777777F77787777777777778F777F77778
DATA 777777777777777777777777777777F77787777777777778F7777F77787777777
DATA 7777777777777777777777F777787777777777778F7777F777787777777777777
DATA 777777777777777F777877777777777778F77777F777877777777777777777777
DATA 7777777F7777877777777777778F77777F7777877777777777777777777777777
DATA F7778777777777777778F777777F77778777777777777777777777777F7777877
DATA 7777777777778F7777777F777787777777777777777777777F777787777777777
DATA 777778F77777777F777788777777777777777777FF7777877777777777777778F
DATA 777777777F777778877777777777777FF777778777777777777777778F7777777
DATA 777F777777FF7777777777FF77777787777777777777777778F77777777777F77
DATA 77777FFFFFFFFFF7777777877777777777777777778F777777777777FF7777777
DATA 777777777777788777777777777777777778F77777777777777FF777777777777
DATA 77778877777777777777777777778F7777777777777777FFF7777777777888777
DATA 7777777777777777777778F777777777777777777788888888887777777777777
DATA 777777777777778F7777777777777777777777777777777777777777777777777
DATA 77777778F77777777777777777777777777777777777777777777777777777777
DATA 8F888888888888888888888888888888888888888888888888888888888000000
DATA 0000000000000000000000000000000000000000000000000000

TunnelCoord:
DATA 0,0 ,0,0 ,0,0 ,0,0 ,0,0, 0,0 ,-10,0 ,-20,0 ,-40,0 ,-80,0, -160,20
DATA -200,40 ,-200,80 ,-200,100 ,-150,120, -100,140 ,-50,160 ,0,170
DATA 50,180 ,100,200, 90,150 ,80,100 ,70,50 ,60,0 ,50,0, 40,0 ,30,0
DATA 20,0 ,10,0 ,0,0, 0,0 ,0,0 ,0,0 ,50,50 ,100,100, 150,100 ,150,100
DATA 150,50 ,150,0 ,150,-50, 150,-100 ,140,-150 ,120,-200 ,100,-175
DATA 80,-150, 60,-125 ,40,-100 ,20,-75 ,0,-50 ,0,-25

REM $STATIC
SUB CopyPal (FromPal() AS PalType, IntoPal() AS PalType)
IF UBOUND(FromPal) <> UBOUND(IntoPal) THEN EXIT SUB

FOR a = 0 TO UBOUND(FromPal)
  IntoPal(a) = FromPal(a)
NEXT a
END SUB

SUB DrawLogo (sig, col)
COLOR col
'---<The>---
LOCATE 3, 7: PRINT "The"
'---<D>---
LINE (30, 30)-(60, 50)
LINE -(70, 70)
LINE -(75, 100)
LINE -(70, 130)
LINE -(60, 150)
LINE -(30, 170)
LINE -(30, 30)
LINE (40, 50)-(60, 70)
LINE -(65, 100)
LINE -(60, 130)
LINE -(40, 150)
LINE -(40, 50)
PAINT (35, 35), col, col
'---<E>---
LINE (80, 35)-(140, 30)
LINE -(135, 60)
LINE -(105, 50)
LINE -(100, 80)
LINE -(140, 75)
LINE -(140, 100)
LINE -(105, 95)
LINE -(110, 140)
LINE -(145, 133)
LINE -(140, 165)
LINE -(95, 160)
LINE -(80, 35)
PAINT (90, 85), col, col
'---<M>---
LINE (170, 30)-(200, 60)
LINE -(230, 35)
LINE -(225, 165)
LINE -(208, 160)
LINE -(220, 55)
LINE -(200, 75)
LINE -(180, 50)
LINE -(185, 165)
LINE -(165, 160)
LINE -(170, 30)
PAINT (175, 40), col, col
'---<O>---
CIRCLE (270, 100), 65, col, , , 1.9
CIRCLE (270, 100), 50, col, , , 1.999
PAINT (270, 40), col, col
'---<by Hauke>---
IF sig THEN LOCATE 23, 27: PRINT "by Hauke";
END SUB

SUB DrawVIVID.BMP (Xpos, Ypos)
Rpos& = 66: RESTORE PicVIVID.BMPdata
READ Xmax, Ymax
FOR x = 0 TO Xmax
 FOR y = 0 TO Ymax
  IF Rpos& > 65 THEN READ InBuff$: Rpos& = 1
  I$ = MID$(InBuff$, Rpos&, 1)
  col = VAL("&H" + I$)
  Rpos& = Rpos& + 1: PSET (x + Xpos, y + Ypos), col
 NEXT
NEXT
END SUB

SUB DumpPal (WhatPal() AS PalType)
FOR a = 0 TO UBOUND(WhatPal)
  SetPal a, WhatPal(a).r, WhatPal(a).G, WhatPal(a).b
NEXT a
END SUB

SUB EmptyBuff
DO: LOOP UNTIL INKEY$ = ""
END SUB

SUB FadeIn (WhatPal() AS PalType)
DIM WorkPal(UBOUND(WhatPal)) AS PalType
EmptyBuff
DO
  Count = 0
  FOR a = 0 TO UBOUND(WhatPal)
    IF WorkPal(a).r < WhatPal(a).r THEN WorkPal(a).r = WorkPal(a).r + 1: Count = Count + 1
    IF WorkPal(a).G < WhatPal(a).G THEN WorkPal(a).G = WorkPal(a).G + 1: Count = Count + 1
    IF WorkPal(a).b < WhatPal(a).b THEN WorkPal(a).b = WorkPal(a).b + 1: Count = Count + 1
  NEXT a
  DumpPal WorkPal()
LOOP UNTIL Count = 0
EmptyBuff
END SUB

SUB FadeInto (FromPal() AS PalType, IntoPal() AS PalType)
IF UBOUND(FromPal) <> UBOUND(IntoPal) THEN EXIT SUB
DIM WorkPal(UBOUND(FromPal)) AS PalType, Direc(UBOUND(FromPal)) AS PalType
EmptyBuff
FOR a = 0 TO UBOUND(FromPal)
  Direc(a).r = SGN(FromPal(a).r - IntoPal(a).r)
  Direc(a).G = SGN(FromPal(a).G - IntoPal(a).G)
  Direc(a).b = SGN(FromPal(a).b - IntoPal(a).b)
  WorkPal(a) = FromPal(a)
NEXT a

DO
  Count = 0
  FOR a = 0 TO UBOUND(FromPal)
    IF WorkPal(a).r <> IntoPal(a).r THEN WorkPal(a).r = WorkPal(a).r - Direc(a).r: Count = Count + 1
    IF WorkPal(a).G <> IntoPal(a).G THEN WorkPal(a).G = WorkPal(a).G - Direc(a).G: Count = Count + 1
    IF WorkPal(a).b <> IntoPal(a).b THEN WorkPal(a).b = WorkPal(a).b - Direc(a).b: Count = Count + 1
  NEXT a
  DumpPal WorkPal()
LOOP UNTIL Count = 0
EmptyBuff
END SUB

SUB FadeOut (WhatPal() AS PalType)
DIM WorkPal(UBOUND(WhatPal)) AS PalType
EmptyBuff
FOR a = 2 TO UBOUND(WhatPal)
  WorkPal(a) = WhatPal(a)
NEXT a

DO
  Count = 0
  FOR a = 2 TO UBOUND(WhatPal)
    IF WorkPal(a).r THEN WorkPal(a).r = WorkPal(a).r - 1: Count = Count + 1
    IF WorkPal(a).G THEN WorkPal(a).G = WorkPal(a).G - 1: Count = Count + 1
    IF WorkPal(a).b THEN WorkPal(a).b = WorkPal(a).b - 1: Count = Count + 1
  NEXT a
  DumpPal WorkPal()
LOOP UNTIL Count = 0
EmptyBuff
END SUB

SUB FillPal (WhatPal() AS PalType)
FOR a = 0 TO UBOUND(WhatPal)
  GetPal a, WhatPal(a).r, WhatPal(a).G, WhatPal(a).b
NEXT a
END SUB

SUB GetPal (col, r, G, b)
OUT &H3C7, col
r = INP(&H3C9)
G = INP(&H3C9)
b = INP(&H3C9)
END SUB

SUB InvertPal (WhatPal() AS PalType)
FOR a = 0 TO UBOUND(WhatPal)
  WhatPal(a).r = 63 - WhatPal(a).r
  WhatPal(a).G = 63 - WhatPal(a).G
  WhatPal(a).b = 63 - WhatPal(a).b
NEXT a
END SUB

SUB MakePal (WhatPal() AS PalType)
  x = 0: y = UBOUND(WhatPal)
  DIM cStack(256) AS STRING * 2
  RndCol WhatPal(0)
  WhatPal(y) = WhatPal(0)
 
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
    r = (WhatPal(x).r + WhatPal(y).r) \ 2 + (INT(RND * 3) - 1) * q
    IF r < 0 THEN r = 0
    IF r > 63 THEN r = 63
    WhatPal(z).r = r
    '*** green
    G = (WhatPal(x).G + WhatPal(y).G) \ 2 + (INT(RND * 3) - 1) * q
    IF G < 0 THEN G = 0
    IF G > 63 THEN G = 63
    WhatPal(z).G = G
    '*** blue
    b = (WhatPal(x).b + WhatPal(y).b) \ 2 + (INT(RND * 3) - 1) * q
    IF b < 0 THEN b = 0
    IF b > 63 THEN b = 63
    WhatPal(z).b = b
    '***
    cStack(TopStack) = CHR$(x) + CHR$(z)
    TopStack = TopStack + 1
    cStack(TopStack) = CHR$(z) + CHR$(y)
    TopStack = TopStack + 1
  LOOP
END SUB

SUB RndCol (Clr AS PalType)
r = RND * 64
G = RND * 64
b = RND * 64
Clr.r = r: Clr.G = G: Clr.b = b
END SUB

SUB RotatePal (WhatPal() AS PalType)
FOR a = 254 TO 2 STEP -1
  SWAP WhatPal(a), WhatPal(a + 1)
NEXT a
END SUB

SUB SetPal (col, r, G, b)
OUT &H3C8, col
OUT &H3C9, r
OUT &H3C9, G
OUT &H3C9, b
END SUB

SUB SFBlackHole (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  SELECT CASE Star(a).v
    CASE 0
      IF Star(a).x > Star(a).xc THEN Star(a).x = Star(a).x - Star(a).s
      IF Star(a).x < Star(a).xc THEN Star(a).x = Star(a).x + Star(a).s
      IF Star(a).y > Star(a).yc THEN Star(a).y = Star(a).y - Star(a).s
      IF Star(a).y < Star(a).yc THEN Star(a).y = Star(a).y + Star(a).s
      s1 = Star(a).x > Star(a).xc - 2
      s2 = Star(a).x < Star(a).xc + 2
      s3 = Star(a).y > Star(a).yc - 2
      s4 = Star(a).y < Star(a).yc + 2
      IF s1 AND s2 AND s3 AND s4 THEN Star(a).v = -1
      'IF (s1 AND s2) OR (s3 AND s4) THEN Star(a).s = Star(a).s + 1
    CASE -1
      Star(a).x = RND * (Star(a).x2 - Star(a).x1) + Star(a).x1
      Star(a).y = RND * (Star(a).y2 - Star(a).y1) + Star(a).y1
      Star(a).c = RND * 20 + 1
      Star(a).s = Star(a).c \ 8 + 1
      Star(a).c = Star(a).c + 200
      Star(a).b = RND * 4 - 2
      Star(a).v = -3
    CASE ELSE
      Star(a).v = 0
  END SELECT
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFBoom (Star() AS StarType)
MaxS = UBOUND(Star)
IF x2 - x1 < y2 - y1 THEN m = x2 - x1 ELSE m = y2 - y1
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  SELECT CASE Star(a).v
   CASE 0
    IF Star(a).x < Star(a).sx THEN Star(a).x = Star(a).x - Star(a).s
    IF Star(a).x > Star(a).sx THEN Star(a).x = Star(a).x + Star(a).s
    IF Star(a).y < Star(a).sy THEN Star(a).y = Star(a).y - Star(a).b
    IF Star(a).y > Star(a).sy THEN Star(a).y = Star(a).y + Star(a).b
    IF Star(a).x <= Star(a).x1 + Star(a).d THEN Star(a).v = -1
    IF Star(a).y <= Star(a).y1 + Star(a).d THEN Star(a).v = -1
    IF Star(a).x >= Star(a).x2 - Star(a).d THEN Star(a).v = -1
    IF Star(a).y >= Star(a).y2 - Star(a).d THEN Star(a).v = -1
  CASE -1
    Star(a).sy = RND * (Star(a).x2 - Star(a).x1)
    Star(a).s = (Star(a).c - 200) \ 8 + 1
    Star(a).d = RND * (m \ 3)
    Star(a).v = -2
   CASE -2
    IF Star(a).s \ 2 = 0 THEN s = 1 ELSE s = Star(a).s \ 2
    Star(a).x = Star(a).x - s
    Star(a).y = Star(a).y + Star(a).b
    IF Star(a).x < Star(a).x1 OR Star(a).y > Star(a).y2 OR Star(a).y < Star(a).y1 THEN
      Star(a).x = RND * ((Star(a).x2 - Star(a).x1) \ 16) + Star(a).x2 - ((Star(a).x2 - Star(a).x1) \ 16)
      Star(a).y = RND * (Star(a).y2 - Star(a).y1) + Star(a).y1
      Star(a).c = RND * 20 + 1
      Star(a).s = Star(a).c \ 8 + 1
      Star(a).c = Star(a).c + 200
      Star(a).b = RND * 4 - 2
      Star(a).v = -3
    END IF
   CASE -3
    Star(a).x = Star(a).x - Star(a).s
    IF Star(a).x < Star(a).x1 THEN
      Star(a).x = RND * ((Star(a).x2 - Star(a).x1) \ 16) + Star(a).x2 - ((Star(a).x2 - Star(a).x1) \ 16)
      Star(a).y = RND * (Star(a).y2 - Star(a).y1) + Star(a).y1
      Star(a).c = RND * 20 + 1
      Star(a).s = Star(a).c \ 8 + 1
      Star(a).c = Star(a).c + 200
      Star(a).b = RND * 4 - 2
    END IF
  END SELECT
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFBounce (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  Star(a).x = Star(a).x - Star(a).s
  IF Star(a).x < Star(a).x1 THEN
    Star(a).x = RND * ((Star(a).x2 - Star(a).x1) \ 16) + Star(a).x2 - ((Star(a).x2 - Star(a).x1) \ 16)
    Star(a).y = RND * (Star(a).y2 - Star(a).y1) + Star(a).y1
    Star(a).c = RND * 20 + 1
    Star(a).s = Star(a).c \ 8 + 1
    Star(a).c = Star(a).c + 200
    Star(a).b = RND * 4 - 2
    Star(a).v = -3
  END IF
  Star(a).y = Star(a).y - Star(a).b
  IF Star(a).y < Star(a).y1 OR Star(a).y > Star(a).y2 THEN Star(a).b = -Star(a).b
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFClear (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
NEXT a
END SUB

SUB SFDraw (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFExpl (Star() AS StarType)
MaxS = UBOUND(Star)
IF x2 - x1 < y2 - y1 THEN m = x2 - x1 ELSE m = y2 - y1
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  SELECT CASE Star(a).v
   CASE 0
    IF Star(a).x < Star(a).sx THEN Star(a).x = Star(a).x - Star(a).s
    IF Star(a).x > Star(a).sx THEN Star(a).x = Star(a).x + Star(a).s
    IF Star(a).y < Star(a).sy THEN Star(a).y = Star(a).y - Star(a).s
    IF Star(a).y > Star(a).sy THEN Star(a).y = Star(a).y + Star(a).s
    IF Star(a).x <= Star(a).x1 + Star(a).d THEN Star(a).v = -1
    IF Star(a).y <= Star(a).y1 + Star(a).d THEN Star(a).v = -1
    IF Star(a).x >= Star(a).x2 - Star(a).d THEN Star(a).v = -1
    IF Star(a).y >= Star(a).y2 - Star(a).d THEN Star(a).v = -1
  CASE -1
    Star(a).sy = RND * (Star(a).x2 - Star(a).x1)
    Star(a).s = (Star(a).c - 200) \ 8 + 1
    Star(a).d = RND * (m \ 3)
    Star(a).v = -2
   CASE -2
    IF Star(a).s \ 2 = 0 THEN s = 1 ELSE s = Star(a).s \ 2
    Star(a).x = Star(a).x - s
    Star(a).y = Star(a).y + Star(a).b
    IF Star(a).x < Star(a).x1 OR Star(a).y > Star(a).y2 OR Star(a).y < Star(a).y1 THEN
      Star(a).v = -3
    END IF
   CASE -3
    Star(a).v = 0
    Star(a).d = RND * (m \ 3)
    Star(a).x = Star(a).xv + RND * 3 - 1
    Star(a).y = Star(a).yv + RND * 3 - 1
    Star(a).c = RND * 20 + 1
    Star(a).s = Star(a).c \ 8 + 1
    Star(a).c = Star(a).c + 200
    Star(a).b = RND * 4 - 2
  END SELECT
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFInit (Star() AS StarType, x1, y1, x2, y2)
MaxS = UBOUND(Star)
IF x2 - x1 < y2 - y1 THEN m = x2 - x1 ELSE m = y2 - y1
FOR a = 1 TO MaxS
  Star(a).c = RND * 20 + 1
  Star(a).s = Star(a).c \ 8 + 1
  Star(a).c = Star(a).c + 200
  Star(a).b = RND * 4 - 2
  Star(a).x1 = x1
  Star(a).y1 = y1
  Star(a).x2 = x2
  Star(a).y2 = y2
  Star(a).xc = (Star(a).x2 - Star(a).x1) \ 2 + Star(a).x1
  Star(a).yc = (Star(a).y2 - Star(a).y1) \ 2 + Star(a).y1
  Star(a).x = RND * (x2 - x1) + x1
  Star(a).y = RND * (y2 - y1) + y1
  Star(a).v = -3
  IF RND > .5 THEN Star(a).sx = RND * ((Star(a).x2 - Star(a).x1) \ 16) ELSE Star(a).sx = (Star(a).x2 - Star(a).x1) - RND * ((Star(a).x2 - Star(a).x1) \ 16)
  Star(a).sy = RND * (Star(a).x2 - Star(a).x1)
  Star(a).d = RND * (m \ 3)
NEXT a
END SUB

SUB SFInitBoom (Star() AS StarType, x, y)
MaxS = UBOUND(Star)
IF x2 - x1 < y2 - y1 THEN m = x2 - x1 ELSE m = y2 - y1
FOR a = 1 TO MaxS
  IF RND > .5 THEN Star(a).sx = RND * ((Star(a).x2 - Star(a).x1) \ 16) ELSE Star(a).sx = (Star(a).x2 - Star(a).x1) - RND * ((Star(a).x2 - Star(a).x1) \ 16)
  Star(a).sy = RND * (Star(a).x2 - Star(a).x1)
  Star(a).d = RND * (m \ 3)
  Star(a).v = 0
  Star(a).x = x + RND * 3 - 1
  Star(a).y = y + RND * 3 - 1
  Star(a).xv = x
  Star(a).yv = y
NEXT a
END SUB

SUB SFPull (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  IF Star(a).v = 0 THEN
    IF Star(a).x < Star(a).xd THEN Star(a).x = Star(a).x + Star(a).s
    IF Star(a).x > Star(a).xd THEN Star(a).x = Star(a).x - Star(a).s
    IF Star(a).y < Star(a).yd THEN Star(a).y = Star(a).y + Star(a).s
    IF Star(a).y > Star(a).yd THEN Star(a).y = Star(a).y - Star(a).s
    s1 = Star(a).x > Star(a).xd - 2
    s2 = Star(a).x < Star(a).xd + 2
    s3 = Star(a).y > Star(a).yd - 2
    s4 = Star(a).y < Star(a).yd + 2
    IF s1 AND s2 AND s3 AND s4 THEN
      Star(a).x = Star(a).xd
      Star(a).y = Star(a).yd
      Star(a).v = -3
      Star(a).c = 220
    END IF
  END IF
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFStd (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  Star(a).x = Star(a).x - Star(a).s
  IF Star(a).x < Star(a).x1 THEN
    Star(a).x = RND * ((Star(a).x2 - Star(a).x1) \ 16) + Star(a).x2 - ((Star(a).x2 - Star(a).x1) \ 16)
    Star(a).y = RND * (Star(a).y2 - Star(a).y1) + Star(a).y1
    Star(a).c = RND * 20 + 1
    Star(a).s = Star(a).c \ 8 + 1
    Star(a).c = Star(a).c + 200
    Star(a).b = RND * 4 - 2
    Star(a).v = -3
  END IF
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFSuck (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  IF Star(a).x < Star(a).xc THEN Star(a).x = Star(a).x + Star(a).s
  IF Star(a).x > Star(a).xc THEN Star(a).x = Star(a).x - Star(a).s
  IF Star(a).y < Star(a).yc THEN Star(a).y = Star(a).y + Star(a).s
  IF Star(a).y > Star(a).yc THEN Star(a).y = Star(a).y - Star(a).s
  Star(a).v = 0
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFTwinkle (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  IF Star(a).s \ 2 = 0 THEN s = 1 ELSE s = Star(a).s \ 2
  Star(a).y = Star(a).y + s
  Star(a).c = Star(a).c + 1
  IF Star(a).c >= 220 THEN Star(a).c = 201
  IF Star(a).y > Star(a).y2 THEN
    Star(a).x = RND * (Star(a).x2 - Star(a).x1) + Star(a).x1
    Star(a).y = RND * ((Star(a).y2 - Star(a).y1) \ 16) + Star(a).y1
    Star(a).c = RND * 20 + 1
    Star(a).s = Star(a).c \ 8 + 1
    Star(a).c = Star(a).c + 200
    Star(a).b = RND * 4 - 2
    Star(a).v = -3
  END IF
  PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a
END SUB

SUB SFTwinkleDown (Star() AS StarType)
MaxS = UBOUND(Star)
FOR a = 1 TO MaxS
  PSET (Star(a).x, Star(a).y), 0
  IF Star(a).v = -3 THEN
    s = ABS(Star(a).b) + 1
    Star(a).y = Star(a).y + s
    Star(a).c = Star(a).c + 1
    IF Star(a).c >= 220 THEN Star(a).c = 201
  END IF
  IF Star(a).y > Star(a).y2 THEN
    Star(a).x = RND * (Star(a).x2 - Star(a).x1) + Star(a).x1
    Star(a).y = RND * ((Star(a).y2 - Star(a).y1) \ 16) + Star(a).y1
    Star(a).c = RND * 20 + 1
    Star(a).s = Star(a).c \ 8 + 1
    Star(a).c = Star(a).c + 200
    Star(a).b = RND * 4 - 2
    Star(a).v = 0
  END IF
  IF Star(a).v THEN PSET (Star(a).x, Star(a).y), Star(a).c
NEXT a

END SUB

SUB SwapPal (Pal1() AS PalType, Pal2() AS PalType)
IF UBOUND(Pal1) <> UBOUND(Pal2) THEN EXIT SUB

FOR a = 0 TO UBOUND(Pal1)
  SWAP Pal1(a), Pal2(a)
NEXT a
END SUB

