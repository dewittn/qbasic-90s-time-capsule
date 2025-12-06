REM   Alpha version of VR Maze Wars (working title) by David Carlton
REM   Hard Core Software  Copyright 1995

REM   This is the alpha version of my game! Basically it's a super slow
REM   qbasic version of my program only allowing you to wander around a
REM   small room. This actually looks barely anything like the actual game
REM   will. This has clear walls and no hit detection for the objects in
REM   the center of the room. Also, because this has no object sorting,
REM   close walls will dissapear. Of course the worst thing about the alpha
REM   is how terribly slow it runs in non-compiled qbasic. Most of the time
REM   you will have to wait about 5 seconds for each frame to be drawn.

REM   Below is a list of features that will be in the finished version or
REM   later upgrades:

REM   -Written in C++:over ten times faster
REM   -Runs in Windows
REM   -SVGA or VGA graphics
REM   -Digital sound effects and midi music
REM   -Full 6DOF enviroment (jumping,strafing,look up-down  the works!)
REM   -Texture mapped surfaces
REM   -Gourad/ray traced shading and light effects
REM   -Multiple cameras
REM   -Weapons like homing missle launchers and artillery cannons
REM   -Helpful powerups like 180 degree vision and jet packs
REM   -Lots of enemies
REM   -Liquid surfaces (dive underwater)
REM   -Modem play
REM   -Large and a-maze-ing levels
REM   -More cool stuff like level editors and cheats

REM   This alpha version is a long ways away from the finished version
REM   described above, but I'm working on it. Not all of these features may
REM   get included in the first version, but I'll try to squeeze in all that
REM   I can. I plan to release it as shareware, and include more levels,
REM   weapons, enemies, and sound effects if it is registered.

REM   I tried to spend as little time as possible working on this alpha
REM   because of the problems and limitations of qbasic. Thus, you can't do
REM   too much in this program. Use the arrow keys to move around, and q to
REM   quit. I also added b for bird's eye view and n for normal view. I might
REM   use something like that as a map in later versions. Ready? Press F5
REM   to start. If you have any suggestions write me on the internet at
REM   "pvhsa07@ll.kcts.org".


REM   P.S.  If you want to see this program run in high resolution, change
REM   the lines that say  SCREEN 8, , drawnpage, shownpage  to  SCREEN 12 and
REM   maxy and screeny to 479 in the line just below the first SCREEN
REM   statement. This will disable multiple pages but allow 640x480 graphics.



ON ERROR GOTO 1
1 RESUME NEXT

REM initialization

DIM template(3, 6, 4, 3), objectloc(37, 3), objectrot(37, 3), objecttype(37)
DIM playerloc(3), playerrot(3), playervel(3), surfacenumber(3), vertexnumber(3, 6)

shownpage = 1: drawnpage = 0
COLOR 7
SCREEN 8, , drawnpage, shownpage
perspective = 600
walkspeed = 5
maxx = 639: minx = 1: maxy = 199: miny = 1
screenx = 639: screeny = 199

REM reading data routine

REM This should read out of a data file in later versions

FOR i = 1 TO 3
READ playerloc(i)
NEXT i
FOR j = 1 TO 3
READ playerrot(j)
NEXT j
FOR k = 1 TO 3
READ playervel(k)
NEXT k

READ templatenumber
FOR i = 1 TO templatenumber
READ surfacenumber(i)
FOR j = 1 TO surfacenumber(i)
READ vertexnumber(i, j)
FOR k = 1 TO vertexnumber(i, j)
FOR l = 1 TO 3
READ template(i, j, k, l)
NEXT l
NEXT k
NEXT j
NEXT i

READ objectnumber
FOR i = 1 TO objectnumber
READ objecttype(i)
FOR j = 1 TO 3
READ objectloc(i, j)
NEXT j
FOR k = 1 TO 3
READ objectrot(i, k)
NEXT k
NEXT i

REM  keyboard scan routine

REM This is the central routine in this version of the game, but it shouldn't
REM be in later versions.

GOSUB 100

DO

in$ = INKEY$
IF RIGHT$(in$, 1) = CHR$(72) THEN vectorvel = walkspeed: GOSUB 50
IF RIGHT$(in$, 1) = CHR$(80) THEN vectorvel = walkspeed * (-1): GOSUB 50
IF RIGHT$(in$, 1) = CHR$(77) THEN playerrot(1) = playerrot(1) - .26799
IF RIGHT$(in$, 1) = CHR$(75) THEN playerrot(1) = playerrot(1) + .26799
IF playerrot(1) > 6.28 THEN playerrot(1) = playerrot(1) - 6.28
IF playerrot(1) < 0 THEN playerrot(1) = playerrot(1) + 6.28
IF in$ = "q" THEN gameover = 1: END
IF in$ = "b" THEN playerloc(2) = 100: playerrot(3) = 1.54
IF in$ = "n" THEN playerloc(2) = 0: playerrot(3) = 3.14
IF RIGHT$(in$, 1) <> CHR$(72) AND RIGHT$(in$, 1) <> CHR$(80) THEN GOSUB 55

REM   IF in$ <> "" OR playervel(1) <> 0 OR playervel(3) <> 0 THEN CLS 1: GOSUB 100

IF in$ <> "" THEN CLS 1: GOSUB 100

in$ = ""

LOOP WHILE gameover = 0

END

REM  vector movement converted to cartesian

50

REM x velocity
playervel(1) = playervel(1) + SIN(playerrot(1)) * vectorvel
REM z velocity
playervel(3) = playervel(3) - COS(playerrot(1)) * vectorvel

playervel(1) = INT(playervel(1)): playervel(3) = INT(playervel(3))

IF playervel(1) > 4 THEN playervel(1) = 4
IF playervel(1) < -4 THEN playervel(1) = -4
IF playervel(3) > 4 THEN playervel(1) = 4
IF playervel(3) < -4 THEN playervel(3) = -4

playerloc(1) = playerloc(1) + playervel(1)
playerloc(3) = playerloc(3) + playervel(3)

REM customized hit detection -- cheap

IF playerloc(1) < 0 THEN playerloc(1) = 0
IF (playerloc(3) <= 30 OR playerloc(3) >= 40) AND playerloc(1) > 60 THEN playerloc(1) = 60
IF playerloc(1) > 80 THEN playerloc(1) = 80

IF playerloc(3) < 0 THEN playerloc(3) = 0
IF playerloc(3) > 70 THEN playerloc(3) = 70
IF playerloc(1) >= 60 AND playerloc(3) < 30 THEN playerloc(3) = 30
IF playerloc(1) >= 60 AND playerloc(3) > 40 THEN playerloc(3) = 40

RETURN

REM  friction

55 REM  I disabled gliding because it isn't very effective when the program
REM     runs this slow.

IF playervel(1) > 0 THEN playervel(1) = playervel(1) - 4
IF playervel(1) < 0 THEN playervel(1) = playervel(1) + 4
IF playervel(3) > 0 THEN playervel(3) = playervel(3) - 4
IF playervel(3) < 0 THEN playervel(3) = playervel(3) + 4

RETURN

REM  main graphics routine (large)

100


FOR i = 1 TO objectnumber
FOR j = 1 TO surfacenumber(objecttype(i))

GOSUB 2000

x = template(objecttype(i), j, 1, 1): y = template(objecttype(i), j, 1, 2): z = template(objecttype(i), j, 1, 3)
GOSUB 3000
x1 = x: y1 = y: z1 = z

x = template(objecttype(i), j, 2, 1): y = template(objecttype(i), j, 2, 2): z = template(objecttype(i), j, 2, 3)
GOSUB 3000
x2 = x: y2 = y: z2 = z

x = template(objecttype(i), j, 3, 1): y = template(objecttype(i), j, 3, 2): z = template(objecttype(i), j, 3, 3)
GOSUB 3000
x3 = x: y3 = y: z3 = z

GOSUB 7000
IF sp < 0 THEN GOTO 105

x = template(objecttype(i), j, 1, 1): y = template(objecttype(i), j, 1, 2): z = template(objecttype(i), j, 1, 3)
GOSUB 3000
GOSUB 4000
sxa = sx: sya = sy

x = template(objecttype(i), j, 2, 1): y = template(objecttype(i), j, 2, 2): z = template(objecttype(i), j, 2, 3)
GOSUB 3000
GOSUB 4000
sxb = sx: syb = sy

GOSUB 5000
IF drawit = 1 THEN LINE (sxa, sya)-(sxb, syb)

x = template(objecttype(i), j, 2, 1): y = template(objecttype(i), j, 2, 2): z = template(objecttype(i), j, 2, 3)
GOSUB 3000
GOSUB 4000
sxa = sx: sya = sy

x = template(objecttype(i), j, 3, 1): y = template(objecttype(i), j, 3, 2): z = template(objecttype(i), j, 3, 3)
GOSUB 3000
GOSUB 4000
sxb = sx: syb = sy

GOSUB 5000
IF drawit = 1 THEN LINE (sxa, sya)-(sxb, syb)

FOR k = 3 TO vertexnumber(objecttype(i), j)
IF k = vertexnumber(objecttype(i), j) THEN

   x = template(objecttype(i), j, 1, 1): y = template(objecttype(i), j, 1, 2): z = template(objecttype(i), j, 1, 3)
   GOSUB 3000
   GOSUB 4000
   sxa = sx: sya = sy
  
   x = template(objecttype(i), j, k, 1): y = template(objecttype(i), j, k, 2): z = template(objecttype(i), j, k, 3)
   GOSUB 3000
   GOSUB 4000
   sxb = sx: syb = sy
  
   GOSUB 5000
   IF drawit = 1 THEN
     LINE (sxa, sya)-(sxb, syb)
   END IF

ELSE
  
   x = template(objecttype(i), j, k + 1, 1): y = template(objecttype(i), j, k + 1, 2): z = template(objecttype(i), j, k + 1, 3)
   GOSUB 3000
   GOSUB 4000
   sxa = sx: sya = sy
  
   x = template(objecttype(i), j, k, 1): y = template(objecttype(i), j, k, 2): z = template(objecttype(i), j, k, 3)
   GOSUB 3000
   GOSUB 4000
   sxb = sx: syb = sy
  
   GOSUB 5000
   IF drawit = 1 THEN
     LINE (sxa, sya)-(sxb, syb)
   END IF
END IF
NEXT k
105 NEXT j
NEXT i

REM switch pages

drawnpage = 1 - drawnpage
shownpage = 1 - shownpage
SCREEN 8, , drawnpage, shownpage

RETURN

2000

REM sin and cos factors

REM player
sr1 = SIN(playerrot(1)): sr2 = SIN(playerrot(2)): sr3 = SIN(playerrot(3))
cr1 = COS(playerrot(1)): cr2 = COS(playerrot(2)): cr3 = COS(playerrot(3))

REM object -- adding "o" at the end is cheap

sro1 = SIN(objectrot(i, 1)): sro2 = SIN(objectrot(i, 2)): sro3 = SIN(objectrot(i, 3))
cro1 = COS(objectrot(i, 1)): cro2 = COS(objectrot(i, 2)): cro3 = COS(objectrot(i, 3))

RETURN

3000 REM 3-d formulas

REM object

x = (-1) * x: xa = cro1 * x - sro1 * z
za = sro1 * x + cro1 * z: x = cro2 * xa + sro2 * y
ya = cro2 * y - sro2 * xa: z = cro3 * za - sro3 * ya
y = sro3 * za + cro3 * ya

x = x + objectloc(i, 1): y = y + objectloc(i, 2): z = z + objectloc(i, 3)

REM player

x = x - playerloc(1): y = y - playerloc(2): z = z - playerloc(3)

x = (-1) * x: xa = cr1 * x - sr1 * z
za = sr1 * x + cr1 * z: x = cr2 * xa + sr2 * y
ya = cr2 * y - sr2 * xa: z = cr3 * za - sr3 * ya
y = sr3 * za + cr3 * ya

sx = perspective * x / z: sy = perspective * y / z

REM cheap-o 3-d line clipping (That's why things look strange sometimes)

drawit = 1
IF z <= 10 THEN drawit = 0


RETURN

4000

REM 2-d cartesian to 2-d physical

sx = sx + 399: sy = sy + 299: rx = screenx / 799: ry = screeny / 599
sx = sx * rx: sy = sy * ry

RETURN


5000

REM 2-d line clipping


IF sxa > sxb THEN tempswap = sxa: sxa = sxb: sxb = tempswap: tempswap = sya: sya = syb: syb = tempswap
IF sxa < minx AND sxb < minx THEN drawit = 0: RETURN
IF sxa > maxx AND sxb > maxx THEN drawit = 0: RETURN
IF sya < miny AND syb < miny THEN drawit = 0: RETURN
IF sya > maxy AND syb > maxy THEN drawit = 0: RETURN
IF sxa < minx THEN c = (syb - sya) / (sxb - sxa) * (sxb - minx) ELSE GOTO 5010
                    sxa = minx: sya = syb - c
                    IF sya < miny AND syb < miny THEN drawit = 0: RETURN
                    IF sya > maxy AND syb > maxy THEN drawit = 0: RETURN

5010  IF sxb > maxx THEN c = (syb - sya) / (sxb - sxa) * (maxx - sxa) ELSE GOTO 5020
                    sxb = maxx: syb = sya + c
                    IF sya < miny AND syb < miny THEN drawit = 0: RETURN
                    IF sya > maxy AND syb > maxy THEN drawit = 0: RETURN

5020 IF sya > syb THEN tempswap = sxa: sxa = sxb: sxb = tempswap: tempswap = sya: sya = syb: syb = tempswap
IF sya < miny THEN c = (sxb - sxa) / (syb - sya) * (syb - miny): sxa = sxb - c: sya = miny
IF syb > maxy THEN c = (sxb - sxa) / (syb - sya) * (maxy - sya): sxb = sxa + c: syb = maxy

RETURN

7000

REM plane-equation method of hidden surface removal

sp1 = x1 * (y2 * z3 - y3 * z2): sp1 = (-1) * sp1: sp2 = x2 * (y3 * z1 - y1 * z3)
sp3 = x3 * (y1 * z2 - y2 * z1): sp = sp1 - sp2 - sp3

RETURN


REM player data

DATA 5,0,0,  2.796129,0,3.14,  0,0,0

REM templates

DATA 3

REM template:cube

DATA 6, 4, 5,5,5, 5,5,-5, -5,5,-5, -5,5,5,  4, 5,-5,5, 5,5,5, -5,5,5, -5,-5,5
DATA 4, 5,-5,-5, 5,5,-5, 5,5,5, 5,-5,5,  4, -5,-5,-5, -5,5,-5, 5,5,-5, 5,-5,-5
DATA    4, -5,-5,5, -5,5,5, -5,5,-5, -5,-5,-5
DATA    4, -5,-5,5, -5,-5,-5, 5,-5,-5, 5,-5,5

REM template:pyramid

DATA 5, 3, 5,-5,5, 0,10,0, -5,-5,5,  3, 5,-5,-5, 0,10,0, 5,-5,5
DATA    3, -5,-5,5, 0,10,0, -5,-5,-5,  3, -5,-5,-5, 0,10,0, 5,-5,-5
DATA    4, -5,-5,5, -5,-5,-5, 5,-5,-5, 5,-5,5

REM template:wall

DATA 2, 4, 5,-5,0, 5,5,0, -5,5,0, -5,-5,0,  4, -5,-5,0, -5,5,0, 5,5,0, 5,-5,0


REM objects

DATA 36

REM walls

DATA 3, 5,0,0, 0,0,0,  3, 15,0,0, 0,0,0,  3, 25,0,0, 0,0,0
DATA 3, 35,0,0, 0,0,0,  3, 45,0,0, 0,0,0,  3, 55,0,0, 0,0,0,  3, 5,0,70, 0,0,0
DATA 3, 15,0,70, 0,0,0,  3, 25,0,70, 0,0,0,  3, 35,0,70, 0,0,0

DATA 3, 45,0,70, 0,0,0,  3, 55,0,70, 0,0,0,  3, 0,0,5, 1.57,0,0
DATA 3, 0,0,15, 1.57,0,0,  3, 0,0,25, 1.57,0,0,  3, 0,0,35, 1.57,0,0
DATA 3, 0,0,45, 1.57,0,0,  3, 0,0,55, 1.57,0,0,  3, 0,0,65, 1.57,0,0
DATA 3, 60,0,5, 1.57,0,0

DATA 3, 60,0,15, 1.57,0,0,  3, 60,0,25, 1.57,0,0,  3, 60,0,45, 1.57,0,0
DATA 3, 60,0,55, 1.57,0,0,  3, 60,0,65, 1.57,0,0,  3, 65,0,30, 0,0,0
DATA 3, 75,0,30, 0,0,0,  3, 65,0,40, 0,0,0,  3, 75,0,40, 0,0,0
DATA 3, 80,0,35, 1.57,0,0

REM other objects

DATA 1, 15,0,15, 0,0,0,  1, 45,0,15, 0,0,0
DATA 2, 25,0,35, 0,0,0,    1, 15,0,55, 0,0,0
DATA 1, 45,0,55, 0,0,0,  1, 25,15,35, 0,0,0







