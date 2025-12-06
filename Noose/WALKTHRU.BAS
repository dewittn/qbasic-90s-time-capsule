DECLARE SUB DrawMap ()
DECLARE SUB InitMap ()
DECLARE SUB DrawScreen ()
DEFINT A-Z
TYPE RoomType
  N AS INTEGER
  S AS INTEGER
  E AS INTEGER
  W AS INTEGER
END TYPE
TYPE CoordType
  x AS INTEGER
  y AS INTEGER
END TYPE
DIM SHARED Ld(4) AS CoordType
Ld(0).x = 0:  Ld(0).y = 0
Ld(1).x = 0: Ld(1).y = -1
Ld(2).x = 0: Ld(2).y = 1
Ld(3).x = 1: Ld(3).y = 0
Ld(4).x = -1: Ld(4).y = 0
DIM SHARED R(8, 8) AS RoomType
SCREEN 0
FOR a = 1 TO 17
 READ tmp$
 PRINT tmp$
NEXT a
FOR x = 1 TO 8
  FOR y = 1 TO 8
    Xp = x * 4 - 1
    Yp = y * 2
    R(x, y).N = SCREEN(Yp - 1, Xp) <> ASC("-")
    R(x, y).S = SCREEN(Yp + 1, Xp) <> ASC("-")
    R(x, y).E = SCREEN(Yp, Xp + 2) <> ASC("|")
    R(x, y).W = SCREEN(Yp, Xp - 2) <> ASC("|")
    'IF R(x, y).N THEN LOCATE yp - 1, xp: PRINT "-"
    'IF R(x, y).S THEN LOCATE yp + 1, xp: PRINT "-"
    'IF R(x, y).E THEN LOCATE yp, xp + 2: PRINT "|"
    'IF R(x, y).W THEN LOCATE yp, xp - 2: PRINT "|"
  NEXT y
NEXT x
DIM SHARED Xpos, Ypos, Ldir
Xpos = 1: Ypos = 1

SCREEN 13

LINE (70, 10)-(250, 180), 15, B
InitMap
DrawScreen
DrawMap
DO
  DO
    a$ = INKEY$
  LOOP UNTIL a$ <> ""
  sw = 0
  SELECT CASE a$
   CASE "8": Ldir = 1: sw = -1
   CASE "2": Ldir = 2: sw = -1
   CASE "6": Ldir = 3: sw = -1
   CASE "4": Ldir = 4: sw = -1
   CASE CHR$(27): EXIT DO
  END SELECT
  IF sw THEN
    Xpos = Xpos + Ld(Ldir).x
    Ypos = Ypos + Ld(Ldir).y
    IF Xpos > 8 THEN Xpos = 8: sw = 0
    IF Xpos < 1 THEN Xpos = 1: sw = 0
    IF Ypos > 8 THEN Ypos = 8: sw = 0
    IF Ypos < 1 THEN Ypos = 1: sw = 0
    IF sw THEN
      DrawScreen
      DrawMap
    END IF
  END IF
LOOP







MapData:
DATA +---+---+---+---+---+---+---+---+
DATA |           |                   |
DATA +---+   +   +   +---+---+   +   +
DATA |   |   |       |           |   |
DATA +   +   +   +   +   +---+---+   +
DATA |           |                   |
DATA +---+   +---+   +---+   +---+   +
DATA |       |   |       |   |   |   |
DATA +---+---+   +---+   +   +   +---+
DATA |       |           |   |       |
DATA +   +   +   +---+---+   +   +---+
DATA |   |       |               |   |
DATA +   +---+---+   +   +   +---+   +
DATA |               |   |   |       |
DATA +   +   +---+---+   +---+   +   +
DATA |   |           |           |   |
DATA +---+---+---+---+---+---+---+---+

SUB DrawMap
FOR x = 1 TO 8
  FOR y = 1 TO 8
    IF x = Xpos AND y = Ypos THEN c = 4 ELSE c = 0
    PSET (x * 4, y * 4), c
  NEXT y
NEXT x
END SUB

'Box Area: (70,10)-(250,180)
SUB DrawScreen
Xp = Xpos
Yp = Ypos
LOCATE 25, 1: PRINT Xp; Yp;
D = Ldir
LINE (71, 11)-(249, 179), 0, BF
S = 180
p = 1
'We do not see the walls of the area we are currently standing in.
'Are we facing a wall?
SELECT CASE D
  CASE 1
    IF R(Xp, Yp).N = 0 THEN BEEP: EXIT SUB
  CASE 2
    IF R(Xp, Yp).S = 0 THEN BEEP: EXIT SUB
  CASE 3
    IF R(Xp, Yp).E = 0 THEN BEEP: EXIT SUB
  CASE 4
    IF R(Xp, Yp).W = 0 THEN BEEP: EXIT SUB
END SELECT
DO
  'Find the next area we're looking at.
  nX = Xp + Ld(D).x * p
  nY = Yp + Ld(D).y * p
  'Are we looking off the field?
  IF nX < 1 OR nX > 8 OR nY < 1 OR nY > 8 THEN
    EXIT DO
  END IF
  'Draw the walls the next area.
  wide = 180 - p * 20
  x1 = 70 + p * 20
  x2 = 90 + wide
  'Does this area have a wall on the far end?
  SELECT CASE D
    CASE 1
      IF R(nX, nY).N = 0 THEN
        LINE (x1, y1)-(x2, y2), 0, B
        EXIT DO
      END IF
    CASE 2
      IF R(nX, nY).S = 0 THEN
        LINE (x1, y1)-(x2, y2), 0, B
        EXIT DO
      END IF
    CASE 3
      IF R(nX, nY).E = 0 THEN
        LINE (x1, y1)-(x2, y2), 0, B
        EXIT DO
      END IF
    CASE 4
      IF R(nX, nY).W = 0 THEN
        LINE (x1, y1)-(x2, y2), 0, B
        EXIT DO
      END IF
  END SELECT
 
 
  p = p + 1
LOOP UNTIL p = 8
END SUB

SUB InitMap
LINE (2, 2)-(34, 34), 0, BF
LINE (2, 2)-(34, 34), 15, B
FOR x = 1 TO 8
  FOR y = 1 TO 8
    LINE (x * 4 + 2, 2)-(x * 4 + 2, 32 + 2), 15
    LINE (2, y * 4 + 2)-(32 + 2, y * 4 + 2), 15
    Xp = x * 4
    Yp = y * 4
    IF R(x, y).N THEN PSET (Xp, Yp - 2), 0
    IF R(x, y).S THEN PSET (Xp, Yp + 2), 0
    IF R(x, y).E THEN PSET (Xp + 2, Yp), 0
    IF R(x, y).W THEN PSET (Xp - 2, Yp), 0
  NEXT y
NEXT x
END SUB

SUB QFill (x, y)

END SUB

