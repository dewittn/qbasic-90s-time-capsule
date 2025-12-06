DECLARE SUB Boom (Xfrom%, Yfrom%, sAng%, eAng%, Dots%, Dist%, Cycles%, Spd%)
DEFINT A-Z
TYPE BoomType
  Xpos AS INTEGER   'X position
  Ypos AS INTEGER   'Y position
  Xinc AS INTEGER   'X increment
  Yinc AS INTEGER   'Y increment
  Live AS INTEGER   'Lifetime left
  Clr  AS INTEGER   'Color of point
  Spd  AS INTEGER   'Speed of point
  Cycl AS INTEGER   'Cycles left
END TYPE

RANDOMIZE TIMER
SCREEN 7
SLEEP

'      Yfrom           Dots    Cycles
'    Xfrom | sAng eAng  |  Dist |  Speed
Boom 160, 100, 0, 360, 100, 20, 2, 2

SLEEP

SUB Boom (Xfrom, Yfrom, sAng, eAng, Dots, Dist, Cycles, Spd)
'Initialize points
DIM Points(Dots) AS BoomType
FOR a = 0 TO Dots
  Points(WP).Cycl = Cycles
  WP = a: GOSUB InitPoint
  col = INP(64) MOD 2
  SELECT CASE col
    CASE 1
      Points(a).Clr = 4
    CASE 0
      Points(a).Clr = 14
  END SELECT
NEXT a

DO
  Alive = 0
  FOR a = 1 TO Dots
    IF Points(a).Live = 0 THEN
      Points(a).Cycl = Points(a).Cycl - 1
      PSET (Points(a).Xpos, Points(a).Ypos), 0
      WP = a: GOSUB InitPoint
    ELSE
      IF Points(a).Cycl > 0 THEN
        PSET (Points(a).Xpos, Points(a).Ypos), 0
        OffCourse = (INP(64) MOD 4 - 2): IF OffCourse = 0 THEN OffCourse = 1
        Points(a).Xpos = Points(a).Xpos + (Points(a).Xinc \ OffCourse)
        Points(a).Ypos = Points(a).Ypos + (Points(a).Yinc \ OffCourse)
        Points(a).Live = Points(a).Live - 1
        PSET (Points(a).Xpos, Points(a).Ypos), Points(a).Clr
        Alive = Alive + 1
      END IF
    END IF
  NEXT a
LOOP UNTIL Alive = 0
ERASE Points
EXIT SUB
InitPoint:
  Points(WP).Xpos = Xfrom
  Points(WP).Ypos = Yfrom
 
  Angle = INT(RND(1) * (eAng - sAng)) + sAng
  Points(WP).Xinc = (COS(Angle) * Dist) \ Spd
  Points(WP).Yinc = (SIN(Angle) * Dist) \ Spd
 
  Distance = ((Points(WP).Xinc + Points(WP).Yinc) / 2) + Dist
  Points(WP).Live = INT(RND(1) * Distance)
RETURN
END SUB

