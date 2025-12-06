'3D Starfield
'By Andrew Jones final edit on 1/25/96
'If you liked my STARZ, you'll love this.
'Finally, a FIRST PERSON starfield!  Unfortunately, this is only an
'illusion of 3D stars, the stars have no "Z" direction, but you'll be
'fooled for a long enough time.
'Since I don't like just leaving with an END, the stars will twinkle down
'to the bottom of the screen before quitting for a nice goodbye effect.
'Press ESC to quit.
RANDOMIZE TIMER
DEFINT A-Z
SCREEN 13
CONST NumStars = 1000   'Modify this to your CPU speed!  150 is real nice.
DIM fc(NumStars)       'Twinkle color
DIM sx(NumStars)
DIM sy(NumStars)
DIM sc(NumStars)
DIM sdx(NumStars)
DIM sdy(NumStars)
FOR t = 0 TO NumStars
fc(t) = INT(RND * 15) + 1
sx(t) = 140 + INT(RND * 40) + 1
sy(t) = 80 + INT(RND * 40) + 1
sc(t) = INT(RND * 15) + 1
sdx(t) = INT(RND * 10)
sdy(t) = INT(RND * 10)
IF sdx(t) = 0 AND sdy(t) = 0 THEN sdy(t) = 1    'In case the mover variables
                                                'are both motionless.
NEXT
DO
        FOR t = 0 TO NumStars
                PSET (sx(t), sy(t)), 0
                   IF sx(t) = 0 AND sy(t) = 0 THEN
                                sx(t) = 140 + INT(RND * 40) + 1
                                sy(t) = 80 + INT(RND * 40) + 1
                                sc(t) = INT(RND * 15) + 1
                                sdx(t) = INT(RND * 10)
                                sdy(t) = INT(RND * 10)
                                IF sdx(t) = 0 AND sdy(t) = 0 THEN sdy(t) = 1
                                END IF
'These two lines move the stars.
IF sx(t) <= 160 THEN sx(t) = sx(t) - sdx(t) ELSE sx(t) = sx(t) + sdx(t)
IF sy(t) <= 100 THEN sy(t) = sy(t) - sdy(t) ELSE sy(t) = sy(t) + sdy(t)
PSET (sx(t), sy(t)), sc(t) + 15 'Grey shade.
'If a star leaves its boundaries, it's time to see some new ones!
IF sx(t) > 319 THEN sx(t) = 0: sy(t) = 0
IF sx(t) < 0 THEN sx(t) = 0: sy(t) = 0
IF sy(t) > 199 THEN sy(t) = 0: sx(t) = 0
IF sy(t) < 0 THEN sy(t) = 0: sx(t) = 0
NEXT
IF INKEY$ = CHR$(27) THEN EXIT DO
LOOP
DO
Done = 0
FOR t = 0 TO NumStars
PSET (sx(t), sy(t)), 0
IF sdy(t) = 0 THEN sdy(t) = 1
IF sy(t) < 200 THEN sy(t) = sy(t) + sdy(t) ELSE Done = Done + 1
PSET (sx(t), sy(t)), 15 + fc(t)'Twinkle.
fc(t) = fc(t) + 1
IF fc(t) = 16 THEN fc(t) = 0
NEXT
LOOP WHILE Done < NumStars

