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
'$DYNAMIC
DEFINT A-Z
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
END TYPE
SCREEN 13
RANDOMIZE TIMER
OUT &H3C8, 200
FOR t = 1 TO 20
  OUT &H3C9, t * 3 + 3
  OUT &H3C9, t * 3 + 3
  OUT &H3C9, t * 3 + 3
  'OUT &H3C9, INT(RND * 64)
  'OUT &H3C9, INT(RND * 64)
  'OUT &H3C9, INT(RND * 64)
NEXT

DIM Stars(300) AS StarType

SFInit Stars(), 0, 16, 320, 200

LOCATE 1, 1: PRINT "Standard"
DO
  SFStd Stars()
LOOP UNTIL INKEY$ <> ""

LOCATE 1, 1: PRINT "Suck    "
DO
  SFSuck Stars()
LOOP UNTIL INKEY$ <> ""

LOCATE 1, 1: PRINT "Boom"
DO
  SFBoom Stars()
LOOP UNTIL INKEY$ <> ""

LOCATE 1, 1: PRINT "Bounce    "
DO
  SFBounce Stars()
LOOP UNTIL INKEY$ <> ""

LOCATE 1, 1: PRINT "Twinkle"
DO
  SFTwinkle Stars()
LOOP UNTIL INKEY$ <> ""

LOCATE 1, 1: PRINT "Black Hole"
DO
  SFBlackHole Stars()
LOOP UNTIL INKEY$ <> ""

SFClear Stars()

LOCATE 1, 1: PRINT "Multiple starfields"
DIM Stars1(100) AS StarType
DIM Stars2(100) AS StarType
DIM Stars3(100) AS StarType
SFInit Stars1(), 0, 16, 320, 61
SFInit Stars2(), 0, 61, 320, 122
SFInit Stars3(), 0, 122, 320, 200

DO
  SFStd Stars1()
  SFTwinkle Stars2()
  SFBounce Stars3()
LOOP UNTIL INKEY$ <> ""
SFClear Stars1()
SFClear Stars2()
SFClear Stars3()
SFInitBoom Stars1(), Stars1(1).xc, Stars1(1).yc
SFInitBoom Stars2(), Stars2(1).xc, Stars2(1).yc
SFInitBoom Stars3(), Stars3(1).xc, Stars3(1).yc
DO
  SFBoom Stars1()
  SFBoom Stars2()
  SFBoom Stars3()
LOOP UNTIL INKEY$ <> ""
DO
  SFStd Stars1()
  SFTwinkle Stars2()
  SFBounce Stars3()
LOOP UNTIL INKEY$ <> ""
SFClear Stars1()
SFClear Stars2()
SFClear Stars3()
SFInit Stars1(), 0, 16, 320, 200
    SFInitBoom Stars1(), RND * 320, RND * 200
SFInit Stars2(), 0, 16, 320, 200
SFInitBoom Stars2(), RND * 320, RND * 200
SFInit Stars3(), 0, 16, 320, 200
SFInitBoom Stars3(), RND * 320, RND * 200
SFcount = 1
DO
  IF SFcount = 25 THEN
    SFClear Stars1()
    SFInitBoom Stars1(), RND * 304 + 16, RND * 200
  END IF
  IF SFcount = 50 THEN
    SFClear Stars2()
    SFInitBoom Stars2(), RND * 304 + 16, RND * 200
  END IF
  IF SFcount = 75 THEN
    SFClear Stars3()
    SFInitBoom Stars3(), RND * 304 + 16, RND * 200
    SFcount = 1
  END IF
  SFcount = SFcount + 1
  SFExpl Stars1()
  SFExpl Stars2()
  SFExpl Stars3()
LOOP UNTIL INKEY$ <> ""

REM $STATIC
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
  Star(a).v = 0
  Star(a).d = RND * (m \ 3)
  Star(a).x = x + RND * 3 - 1
  Star(a).y = y + RND * 3 - 1
  Star(a).xv = x
  Star(a).yv = y
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

