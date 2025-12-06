'              **   Writen by Nicolas Culberson of Apoky!   **
'The whole HaK-MaN hasn't come out yet.. but I'm hopeing to get it out soon.
'The controls are easy.. right arrow, left, up arrow and space to shoot..
'if you would like to email me, reach me at:    culberson@mis.nb.ca
DECLARE SUB info ()
DECLARE SUB lev1 ()
DECLARE SUB die2 ()
DECLARE SUB menu ()
DECLARE SUB block ()
DECLARE SUB evilsanta ()
DECLARE SUB badman2 ()
DECLARE SUB badman ()
DECLARE SUB lev7 ()
DECLARE SUB blast ()
DECLARE SUB hitwallblast ()
DECLARE SUB takeoff ()
DECLARE SUB picture ()
DECLARE SUB secret ()
DECLARE SUB lev6 ()
DECLARE SUB lev5 ()
DECLARE SUB fallforward ()
DECLARE SUB lev4 ()
DECLARE SUB jumpfar ()
DECLARE SUB lev3 ()
DECLARE SUB fallpit ()
DECLARE SUB fallback ()
DECLARE SUB lev2 ()
DECLARE SUB hitwall ()
DECLARE SUB jumpright ()
DECLARE SUB hitself ()
DECLARE SUB die ()
DECLARE SUB forward ()
DECLARE SUB jump ()
DECLARE SUB backward ()
DECLARE SUB shoot ()
RANDOMIZE TIMER
DIM SHARED heal
DIM SHARED blood
DIM SHARED a
DIM SHARED b
DIM SHARED duh
DIM SHARED gun
DIM SHARED death
DIM SHARED lev
DIM SHARED brad
DIM SHARED bob
blood = 1
heal = 5
CLS
SCREEN 12
'CALL evilsanta      'unrem to go strait to the evil santa.
CALL menu
CALL lev2
CALL lev3
CALL lev4
CALL lev5
CALL lev6
CALL evilsanta
CALL lev7





SUB backward
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
a = a - 5
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB badman
COLOR 10
PSET (a + 15, b + 6)
DRAW "r5u10l5d10"
PAINT (a + 16, b + 5), 2, 10
DO
IF da = 1000 THEN
COLOR 12
PAINT (a, b), 12, 15
IF blood = 1 THEN PSET (a, b - 10): DRAW "r3u2l1d3"
IF blood = 1 THEN PSET (a - 3, b - 10): DRAW "u3l2"
FOR cool = 1 TO 1000: NEXT cool
COLOR 0
PAINT (a, b), 0, 15
IF blood = 1 THEN PSET (a, b - 10): DRAW "r3u2l1d3"
IF blood = 1 THEN PSET (a - 3, b - 10): DRAW "u3l2"
IF heal = 5 THEN CIRCLE (15, 115), 10, 0
IF heal = 4 THEN CIRCLE (15, 115), 8, 0
IF heal = 3 THEN CIRCLE (15, 115), 6, 0
IF heal = 2 THEN CIRCLE (15, 115), 4, 0
IF heal = 1 THEN CIRCLE (15, 115), 2, 0
IF heal = 0 THEN CALL die
heal = heal - 1
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
da = 0
END IF
da = da + 1
a$ = INKEY$
IF a$ = CHR$(27) THEN CALL menu
IF a$ = " " THEN
IF blood = 0 THEN LINE (a + 10, b - 5)-(a + 20, b + 6), 0, BF


jj = INT(RND * 2)

IF blood = 1 AND jj = 0 THEN
LINE (a + 10, b - 5)-(a + 20, b + 6), 12, BF
COLOR 12
PSET (a + 10, b - 10): DRAW "r3u2l1d2"
PSET (a + 18, b - 10): DRAW "r4d2l1u5"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 5)-(a + 20, b), 0, BF
COLOR 0
PSET (a + 10, b - 10): DRAW "r3u2l1d2"
PSET (a + 18, b - 10): DRAW "r4d2l1u5"
COLOR 12
PSET (a + 10, b + 7)
DRAW "d5r1u5r3d6r1u6r2d4u4r2d7r1u7"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 5)-(a + 20, b + 6), 0, BF
PSET (a + 10, b + 7)
DRAW "d7r1u7r3d9r1u9r2d5u5r2d10r1u10"
END IF



IF blood = 1 AND jj = 1 THEN
LINE (a + 10, b - 5)-(a + 20, b + 6), 12, BF
COLOR 12
PSET (a + 10, b - 10): DRAW "r3u4l1u2"
PSET (a + 18, b - 10): DRAW "r4d2l3u4"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 5)-(a + 20, b), 0, BF
COLOR 0
PSET (a + 10, b - 10): DRAW "r3u4l1u2"
PSET (a + 18, b - 10): DRAW "r4d2l3u4"
COLOR 12
PSET (a + 10, b + 7)
DRAW "d2r1u2r2d7r1u7r3d6r1u6r2d3r1u3"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 5)-(a + 20, b + 6), 0, BF
PSET (a + 10, b + 7)
DRAW "d4r1u4r2d8r1u8r3d9r1u9r2d6r1u6"
END IF



k = 1
END IF
LOOP UNTIL k = 1
death = death + 1
END SUB




SUB badman2
COLOR 15
PSET (a + 15, b + 6)
DRAW "r7u15l7d15"
PAINT (a + 16, b + 5), 15, 15
DO
IF da = 800 THEN
COLOR 12
PAINT (a, b), 12, 15
IF blood = 1 THEN PSET (a, b - 10): DRAW "r3u2l1d3"
IF blood = 1 THEN PSET (a - 3, b - 10): DRAW "u3l2"
IF lev < 6 THEN FOR cool = 1 TO 1000: NEXT cool
IF lev = 6 THEN FOR cool = 1 TO 500: NEXT cool
COLOR 0
PAINT (a, b), 0, 15
IF blood = 1 THEN PSET (a, b - 10): DRAW "r3u2l1d3"
IF blood = 1 THEN PSET (a - 3, b - 10): DRAW "u3l2"
IF heal = 5 THEN CIRCLE (15, 115), 10, 0
IF heal = 4 THEN CIRCLE (15, 115), 8, 0
IF heal = 3 THEN CIRCLE (15, 115), 6, 0
IF heal = 2 THEN CIRCLE (15, 115), 4, 0
IF heal = 1 THEN CIRCLE (15, 115), 2, 0
IF heal = 0 THEN CALL die
heal = heal - 1
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
da = 0
END IF
da = da + 1
a$ = INKEY$
IF a$ = CHR$(27) THEN CALL menu
IF a$ = " " THEN
IF blood = 0 THEN LINE (a + 10, b - 10)-(a + 23, b + 6), 0, BF
jjj = INT(RND * 2)

IF blood = 1 AND jjj = 0 THEN
LINE (a + 10, b - 10)-(a + 23, b + 6), 12, BF
COLOR 12
PSET (a + 10, b - 10): DRAW "r3u2l1d2"
PSET (a + 18, b - 10): DRAW "r4d2l1u5"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 10)-(a + 23, b), 0, BF
COLOR 0
PSET (a + 10, b - 10): DRAW "r3u2l1d2"
PSET (a + 18, b - 10): DRAW "r4d2l1u5"
COLOR 12
PSET (a + 10, b + 7)
DRAW "d6r1u6d1r1u1r3d6r1u6r2d8r1u8r3d10r1u10r1d5r1u5"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 5)-(a + 23, b + 6), 0, BF
PSET (a + 10, b + 7)
DRAW "d12r1u12d1r1u1r3d8r1u8r2d13r1u13r3d15r1u15r1d8r1u8"
END IF
IF blood = 1 AND jjj = 1 THEN
LINE (a + 10, b - 10)-(a + 23, b + 6), 12, BF
COLOR 12
PSET (a + 12, b - 10): DRAW "l3u2r1d2"
PSET (a + 18, b - 10): DRAW "r4d4l2u3"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 10)-(a + 23, b), 0, BF
COLOR 0
PSET (a + 12, b - 10): DRAW "l3u2r1d2"
PSET (a + 18, b - 10): DRAW "r4d4l2u3"
COLOR 12
PSET (a + 10, b + 7)
DRAW "d4r1u4d6r1u6r3d3r1u3r2d4r1u4r3d15r1u15r1d8r1u8"
FOR cool = 1 TO 1000: NEXT cool
LINE (a + 10, b - 5)-(a + 23, b + 6), 0, BF
PSET (a + 10, b + 7)
DRAW "d6r1u6d8r1u8r3d5r1u5r2d8r1u8r3d16r1u16r1d11r1u11"
END IF

k = 1
END IF
LOOP UNTIL k = 1
death = death + 1
IF blood = 0 AND lev = 2 OR blood = 0 AND lev = 6 THEN FOR cool = 1 TO 1000: NEXT cool
END SUB

SUB block
hmm = b - 50

DO
COLOR 12
PSET (a - 5, hmm)
DRAW "r10u10l10d10"
PAINT (a + 1, hmm - 1), 3, 12
FOR cool = 1 TO 500: NEXT cool
PAINT (a + 1, hmm - 1), 0, 12
PSET (a - 5, hmm), 0
DRAW "r10u10l10d10"
hmm = hmm + 10
IF hmm = b THEN CALL die
a$ = INKEY$
IF a = 130 AND a$ = " " THEN
PAINT (151, 81), 12, 14
FOR cool = 1 TO 1000: NEXT cool
PAINT (151, 81), 13, 14
IF brad = 4 THEN
IF blood = 1 THEN
COLOR 12
LINE (a + 10, b - 80)-(a + 50, b + 5), 12, BF
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 70), 0, BF
PSET (a + 10, b + 6)
DRAW "d10r1u10r1d2r1u2r3d15r1u15r2d9r1u9r1d8r1u8r5d14r1u14r1d15r1u15r6d16r1u16r5d5r1u5r2d18r1u18r1d12r1u12r1d4r1u4"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 60), 0, BF
PSET (a + 10, b + 6)
DRAW "d14r1u14r1d3r1u3r3d17r1u17r2d13r1u13r1d11r1u11r5d16r1u16r1d19r1u19r6d21r1u21r5d8r1u8r2d18r1u18r1d16r1u16r1d8r1u8"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 50), 0, BF
PSET (a + 10, b + 6)
DRAW "d17r1u17r1d9r1u9r3d23r1u23r2d19r1u19r1d14r1u14r5d20r1u20r1d26r1u26r6d25r1u25r5d13r1u13r2d27r1u27r1d19r1u19r1d12r1u12"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 40), 0, BF
PSET (a + 10, b + 6)
DRAW "d23r1u23r1d13r1u13r3d28r1u28r2d29r1u29r1d19r1u19r5d26r1u26r1d28r1u28r6d30r1u30r5d19r1u19r2d33r1u33r1d24r1u24r1d17r1u17"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 30), 0, BF
PSET (a + 10, b + 6)
DRAW "d29r1u29r1d17r1u17r3d35r1u35r2d37r1u37r1d25r1u25r5d29r1u29r1d36r1u36r6d36r1u36r5d24r1u24r2d39r1u39r1d27r1u27r1d21r1u21"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 20), 0, BF
PSET (a + 10, b + 6)
DRAW "d34r1u34r1d26r1u26r3d39r1u39r2d42r1u42r1d28r1u28r5d35r1u35r1d40r1u40r6d39r1u39r5d29r1u29r2d47r1u47r1d33r1u33r1d25r1u25"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b - 10), 0, BF
PSET (a + 10, b + 6)
DRAW "d39r1u39r1d35r1u35r3d47r1u47r2d46r1u46r1d35r1u35r5d38r1u38r1d44r1u44r6d45r1u45r5d36r1u36r2d47r1u47r1d38r1u38r1d29r1u29"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b), 0, BF
PSET (a + 10, b + 6)
DRAW "d47r1u47r1d36r1u36r3d50r1u50r2d51r1u51r1d38r1u38r5d43r1u43r1d47r1u47r6d48r1u48r5d44r1u44r2d49r1u49r1d45r1u45r1d35r1u35"
FOR cool = 1 TO 500: NEXT cool
LINE (a + 10, b - 80)-(a + 50, b + 5), 0, BF
PSET (a + 10, b + 6)
DRAW "d53r1u52r1d39r1u39r3d55r1u55r2d57r1u57r1d43r1u43r5d48r1u48r1d53r1u53r6d55r1u55r5d49r1u49r2d54r1u54r1d48r1u48r1d39r1u39"
FOR cool = 1 TO 500: NEXT cool
END IF
CALL lev7
END IF
brad = brad + 1
END IF
IF a = 125 AND a$ = CHR$(0) + "M" THEN a$ = "Yo"
IF a = 130 AND a$ = CHR$(0) + "M" THEN a$ = "Yo"
LOOP UNTIL a$ = CHR$(0) + "M" OR a$ = CHR$(0) + "K"
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = CHR$(0) + "K" THEN CALL backward: a = a + 10
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "M" THEN CALL forward: a = a - 10
DO
COLOR 12
PSET (a - 5, hmm)
DRAW "r10u10l10d10"
PAINT (a + 1, hmm - 1), 3, 12
FOR cool = 1 TO 500: NEXT cool
PAINT (a + 1, hmm - 1), 0, 12
PSET (a - 5, hmm), 0
DRAW "r10u10l10d10"
hmm = hmm + 10
LOOP UNTIL hmm = b
COLOR 12
PSET (a - 5, b + 7)
DRAW "d10r2u7r2d12r2u12r2d6r2u6r2d8r2u11l14"
PAINT (a - 3, b + 8), 3, 12
PAINT (a, b + 8), 3, 12
IF a$ = CHR$(0) + "K" THEN a = a - 10
IF a$ = CHR$(0) + "M" THEN a = a + 10
a$ = "Yo"
death = death + 1
END SUB

SUB die
IF blood = 0 THEN LINE (a - 10, b - 10)-(a + 10, b + 5), 0, BF
IF blood = 1 THEN
LINE (a - 10, b - 10)-(a + 10, b + 5), 12, BF
FOR cool = 1 TO 500: NEXT cool
LINE (a - 10, b - 10)-(a + 10, b - 5), 0, BF
PSET (a - 10, b + 6), 12
DRAW "d10r1u10r2d12r1u12r3d9r1u9r5d13r1u13r2d8r1u8r3d12r1u12"
FOR cool = 1 TO 500: NEXT cool
LINE (a - 10, b - 10)-(a + 10, b), 0, BF
PSET (a - 10, b + 6), 12
DRAW "d13r1u13r2d17r1u17r3d11r1u11r5d15r1u15r2d10r1u10r3d13r1u13"
FOR cool = 1 TO 500: NEXT cool
LINE (a - 10, b - 10)-(a + 10, b + 4), 0, BF
PSET (a - 10, b + 6), 12
DRAW "d16r1u16r1d3u3l1r2d19r1u19r3d13r1u13r5d17r1u17r2d13r1u13r3d16r1u16"
FOR cool = 1 TO 1000: NEXT cool
END IF
COLOR 12
PALETTE 15, 0
FOR x = 1 TO 63 STEP 1
PALETTE 15, x '* 256
PALETTE 0, 63 - x
LOCATE 15, 35: PRINT "Game Over"
NEXT x
PALETTE
CALL menu
END SUB





SUB die2
COLOR 12
PALETTE 15, 0
FOR x = 1 TO 63 STEP 1
PALETTE 15, x '* 256
PALETTE 0, 63 - x
LOCATE 15, 35: PRINT "Game Over"
NEXT x
PALETTE
CALL menu
END
END SUB

SUB evilsanta
endsanta = 1
CLS
COLOR 2
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (1, 90)
DRAW "r199"
PAINT (1, 91), 4, 2
COLOR 14
PSET (150, 30)
DRAW "r30d58l40u10r10r30l30u5h5u5e5 u2r30l30u8  r10e5g5l10l5u5r5u12"
PAINT (151, 31), 8, 14
PSET (160, 60)
DRAW "r10d10l10u10d15r3u2d2r3u2d2r3u2d2u4"
PSET (155, 35)
DRAW "r5d5l5u5"
PAINT (156, 36), 12, 14
PAINT (151, 81), 13, 14
COLOR 15
PSET (150, 29)
DRAW "r30u5l30d5"
PAINT (153, 25), 15, 15
COLOR 12
PSET (155, 23)
DRAW "e10f10l20"
PAINT (157, 22), 12, 12
COLOR 15
PSET (163, 13)
DRAW "r5u5l5d5"
PAINT (164, 12), 15, 15
a = 10
b = 84
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a$ = CHR$(27) THEN CALL menu
IF a = 130 AND a$ = " " THEN a$ = "Yo"
IF a = 130 AND a$ = CHR$(0) + "M" THEN a$ = "Yo"
IF a = 60 THEN
COLOR 2
PSET (a - 6, b + 5)
DRAW "u100"
END IF
IF a = 60 AND a$ = CHR$(0) + "K" THEN a$ = "Yo"
IF a = 10 AND a$ = CHR$(0) + "K" THEN a$ = "Yo"
IF a$ = " " THEN CALL shoot
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a > 70 AND a < 135 THEN CALL block
IF x = 199 THEN x = 1
NEXT x
END
END SUB

SUB fallback
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
a = a - 10
b = b + 10
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB fallforward
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
a = a + 10
b = b + 10
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB fallpit
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 7, b + 10), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 500: NEXT cool
CIRCLE (a + 7, b + 10), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 7, b + 20), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 500: NEXT cool
CIRCLE (a + 7, b + 20), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 7, b + 30), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 500: NEXT cool
CIRCLE (a + 7, b + 30), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 7, b + 40), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 500: NEXT cool
CIRCLE (a + 7, b + 40), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 7, b + 50), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 500: NEXT cool
IF duh = 1 THEN CALL lev6
'IF duh = 2 THEN CALL secret
IF duh = 3 THEN CIRCLE (a + 7, b + 50), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f: GOTO 1"
CALL die2
1
END SUB







SUB forward
COLOR 0
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
a = a + 5
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB hitself
PAINT (a, b), 12, 15
COLOR 12
IF blood = 1 THEN PSET (a - 5, b - 12): DRAW "u4l3d1r3d1l3"
FOR cool = 1 TO 1000: NEXT cool
PAINT (a, b), 0, 15
COLOR 0
IF blood = 1 THEN PSET (a - 5, b - 12): DRAW "u4l3d1r3d1l3"
IF blood = 1 THEN COLOR 12: PSET (a - 10, b + 7): DRAW "d3r1u3r2d2r1u2"
IF heal = 5 THEN CIRCLE (15, 115), 10, 0
IF heal = 4 THEN CIRCLE (15, 115), 8, 0
IF heal = 3 THEN CIRCLE (15, 115), 6, 0
IF heal = 2 THEN CIRCLE (15, 115), 4, 0
IF heal = 1 THEN CIRCLE (15, 115), 2, 0
IF heal = 0 THEN CALL die
heal = heal - 1
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
END SUB

SUB hitwall
COLOR 10
PSET (a + 10, b - 3)
DRAW "h1f1d5g1l1e1u5h1"
FOR cool = 1 TO 1000: NEXT cool
COLOR 0
PSET (a + 10, b - 3)
DRAW "h1f1d5g1l1e1u5h1"
END SUB

SUB info
CLS
SCREEN 0
COLOR 15
PRINT
COLOR 30
PRINT "                           ***CHRISTMAS HaK-MaN***"
COLOR 15
PRINT
PRINT "The Controls..."
PRINT
PRINT "Up arrow /\ is Jump"
PRINT "Left arrow < is walk backwards"
PRINT "Right arrow > is walk forwards"
PRINT "Space bar --- is shoot"
PRINT
PRINT "If you want to jump up and go right you must be at a wall... "
PRINT
PRINT "Menu..."
PRINT
PRINT "The menu is very easy, just press the button in [] you wish to use. "
PRINT "Blood.."
PRINT "If you do not want blood press B at the main menu and that will turn"
PRINT "it off. If you want it back on just press B again. "
PRINT "      Every time you go back to the menu the blood will turn on."
PRINT "Press a key..."
SLEEP
PRINT
PRINT "In the game..."
PRINT
PRINT "If you want the time in the middle of the game you can just press T"
PRINT "If you want to quit in the middle of a game press ESC"
PRINT
PRINT "The last boss..."
PRINT
PRINT "The last boss is very hard but you must get past him. Why?, I donno."
PRINT "You must shoot the evilsantas feet to kill him.  What will happen is"
PRINT "there will be blocks falling after two moves past the wall that pops"
PRINT "up.  You must move in and hit him then get out of the way as fast as"
PRINT "posible. "
PRINT
PRINT "If you can't beat the evilsanta or can't get past the levels here is"
PRINT "what it says: "
PRINT
PRINT "You have won CHRISTMAS VERSION"
PRINT "of HaK-MaN.If you enjoyed this"
PRINT "please DL the whole HaK-MaN.  If you"
PRINT "didn't enjoy this, DL the whole HaK-MaN"
PRINT "Press a key..."
SLEEP
PRINT "because it is alot better. The full"
PRINT "version includes:"
PRINT
PRINT "1) More levels (but harder)"
PRINT "2) More badguys(but harder)"
PRINT "3) PC sounds"
PRINT "4) Lots of cool pictures"
PRINT "5) More Guns!!!!!!!"
PRINT "6) 4 x the screen size (400x200)"
COLOR 31: PRINT "AND MUCH MORE! "
COLOR 15
PRINT
PRINT "Press Enter..."
DO
IF INKEY$ = CHR$(13) THEN SCREEN 12: CALL menu
LOOP


END
CALL menu
END SUB

SUB jump
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a, b - 10), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 1000: NEXT cool
CIRCLE (a, b - 10), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB jumpfar
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 7, b - 10), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 1000: NEXT cool
CIRCLE (a + 7, b - 10), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
a = a + 15
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB jumpright
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 5, b - 15), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 1000: NEXT cool
CIRCLE (a + 5, b - 15), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
a = a + 10
b = b - 10
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
END SUB

SUB lev1
heal = 5
lev = lev + 1
COLOR 2
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (1, 90)
DRAW "r50u10r30d20r20u20r60u10r38"
PAINT (3, 93), 9, 2
PAINT (133, 93), 9, 2
COLOR 14
PSET (62, 50)
DRAW "r5u5l5d5"
PAINT (63, 49), 6, 14
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
a = 10
b = 83
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a = 195 THEN CALL lev2
IF a$ = "T" OR a$ = "t" THEN COLOR 1: LOCATE 16, 1: PRINT TIME$: LOCATE 16, 1: SLEEP: PRINT "                   "
IF a = 190 AND a$ = " " THEN CALL hitwall: a$ = "Yo"
IF a = 15 AND death = 0 OR a = 55 AND death = 1 OR a = 95 AND death = 2 OR a = 135 AND death = 3 OR a = 175 AND death = 4 THEN CALL badman
IF a = 195 THEN x = 200
IF a = 80 AND a$ = CHR$(0) + "M" AND bridge = 0 THEN
CIRCLE (a, b), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 10, b + 10), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR cool = 1 TO 500: NEXT cool
CIRCLE (a + 10, b + 10), 5, 0: DRAW "c0u4u1r5u1l10d1r5u1l4u1e4f4l7e3f3l5e2f1l1"
CIRCLE (a + 10, b + 20), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
CALL die2
END IF
IF a = 10 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 45 AND a$ = CHR$(0) + "M" OR a = 155 AND a$ = CHR$(0) + "M" THEN a$ = "b"
IF a = 45 AND a$ = CHR$(0) + "H" OR a = 155 AND a$ = CHR$(0) + "H" THEN CALL jumpright: a$ = "b"
IF a = 45 AND a$ = " " OR a = 155 AND a$ = " " THEN CALL hitself: a$ = "b"
IF a = 40 AND a$ = " " OR a = 150 AND a$ = " " THEN CALL hitwall: a$ = "b"
IF a = 55 AND a$ = CHR$(0) + "K" OR a = 165 AND a$ = CHR$(0) + "K" THEN CALL fallback: a$ = "b"
IF a$ = CHR$(27) THEN CALL menu
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = " " THEN CALL shoot
IF a = 65 AND a$ = CHR$(0) + "H" AND bridge = 0 THEN
COLOR 15
PSET (a + 16, b + 7)
DRAW "r20"
bridge = 1
PAINT (63, 49), 12, 14
a$ = "b"
END IF
IF a = 65 AND a$ = CHR$(0) + "H" AND bridge = 1 THEN
COLOR 0
PSET (a + 17, b + 7)
DRAW "r18 "
bridge = 0
PAINT (63, 49), 6, 14
END IF
IF x = 199 THEN x = 1
NEXT x
END SUB

SUB lev2
lev = lev + 1
CLS
COLOR 2
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (1, 70)
DRAW "r50u10r50u10r30d50r12u50r28d50r12u50r16"
PAINT (3, 93), 9, 2
PAINT (153, 93), 9, 2
PAINT (196, 93), 9, 2
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
a = 10
b = 63
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a = 195 THEN CALL lev3
IF a$ = "T" OR a$ = "t" THEN COLOR 1: LOCATE 16, 1: PRINT TIME$: LOCATE 16, 1: SLEEP: PRINT "                   "
IF a = 190 AND a$ = " " THEN CALL hitwall: a$ = "Yo"
IF a = 15 AND death = 5 OR a = 55 AND death = 6 OR a = 105 AND death = 7 OR a = 145 AND death = 8 THEN CALL badman
IF a = 195 THEN x = 200
IF a = 145 AND a$ = CHR$(0) + "K" OR a = 185 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 130 AND a$ = CHR$(0) + "H" OR a = 170 AND a$ = CHR$(0) + "H" THEN CALL jumpfar: a$ = "b"
IF a = 130 AND a$ = CHR$(0) + "M" OR a = 170 AND a$ = CHR$(0) + "M" THEN CALL fallpit: a$ = "b"
IF a = 10 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 45 AND a$ = CHR$(0) + "M" OR a = 95 AND a$ = CHR$(0) + "M" THEN a$ = "b"
IF a = 45 AND a$ = CHR$(0) + "H" OR a = 95 AND a$ = CHR$(0) + "H" THEN CALL jumpright: a$ = "b"
IF a = 45 AND a$ = " " OR a = 95 AND a$ = " " THEN CALL hitself: a$ = "b"
IF a = 40 AND a$ = " " OR a = 90 AND a$ = " " THEN CALL hitwall: a$ = "b"
IF a = 55 AND a$ = CHR$(0) + "K" OR a = 105 AND a$ = CHR$(0) + "K" THEN CALL fallback: a$ = "b"
IF a$ = CHR$(27) THEN CALL menu
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = " " THEN CALL shoot
IF x = 199 THEN x = 1
NEXT x
END SUB

SUB lev3
lev = lev + 1
CLS
COLOR 2
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (1, 50)
DRAW "r30d50r12u50r28u10r50d10r50u20r29d20l29r5u15l5"
PAINT (3, 93), 9, 2
PAINT (93, 93), 9, 2
PAINT (198, 45), 1, 2
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
a = 10
b = 43
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a = 170 THEN CALL lev4
IF a$ = "T" OR a$ = "t" THEN COLOR 1: LOCATE 16, 1: PRINT TIME$: LOCATE 16, 1: SLEEP: PRINT "                   "
IF a = 190 AND a$ = " " THEN CALL hitwall: a$ = "Yo"
IF a = 45 AND death = 9 THEN CALL badman2
IF a = 95 AND death = 10 THEN CALL badman
IF a = 135 AND death = 11 THEN CALL badman2
IF a = 170 THEN x = 200
IF a = 130 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 120 AND a$ = CHR$(0) + "M" THEN CALL fallforward: a$ = "b"
IF a = 30 AND a$ = CHR$(0) + "H" THEN CALL jumpfar: a$ = "b"
IF a = 30 AND a$ = CHR$(0) + "M" THEN CALL fallpit: a$ = "b"
IF a = 10 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 45 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 65 AND a$ = CHR$(0) + "M" THEN a$ = "b"
IF a = 65 AND a$ = CHR$(0) + "H" THEN CALL jumpright: a$ = "b"
IF a = 65 AND a$ = " " OR a = 165 AND a$ = " " THEN CALL hitself: a$ = "b"
IF a = 60 AND a$ = " " OR a = 160 AND a$ = " " THEN CALL hitwall: a$ = "b"
IF a = 75 AND a$ = CHR$(0) + "K" THEN CALL fallback: a$ = "b"
IF a$ = CHR$(27) THEN CALL menu
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = " " THEN CALL shoot
IF x = 199 THEN x = 1
NEXT x
END SUB






SUB lev4
lev = lev + 1
CLS
death = 0
COLOR 7
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (1, 90)
DRAW "r30u10r50u10r30d10r40d10r48"
PAINT (3, 93), 8, 7
COLOR 14
PSET (10, 1)
DRAW "d20g5r10h5"
IF duh = 2 THEN
duh = 3
a = 10
b = 33
CALL fallpit
duh = 0
END IF
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
a = 10
b = 83
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a$ = "T" OR a$ = "t" THEN COLOR 1: LOCATE 16, 1: PRINT TIME$: LOCATE 16, 1: SLEEP: PRINT "                   "
IF a = 190 AND a$ = " " THEN CALL hitwall: a$ = "Yo"
IF a = 45 AND death = 0 THEN CALL badman2
IF a = 85 AND death = 1 THEN CALL badman2
IF a = 125 AND death = 2 THEN CALL badman2
IF a = 165 AND death = 3 THEN CALL badman
IF a = 195 THEN CALL lev5
IF a = 110 AND a$ = CHR$(0) + "M" OR a = 150 AND a$ = CHR$(0) + "M" THEN CALL fallforward: a$ = "b"
IF a = 10 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 120 AND a$ = CHR$(0) + "K" OR a = 160 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 25 AND a$ = CHR$(0) + "M" OR a = 75 AND a$ = CHR$(0) + "M" THEN a$ = "b"
IF a = 25 AND a$ = CHR$(0) + "H" OR a = 75 AND a$ = CHR$(0) + "H" THEN CALL jumpright: a$ = "b"
IF a = 75 AND a$ = " " OR a = 25 AND a$ = " " THEN CALL hitself: a$ = "b"
IF a = 70 AND a$ = " " OR a = 20 AND a$ = " " THEN CALL hitwall: a$ = "b"
IF a = 85 AND a$ = CHR$(0) + "K" OR a = 35 AND a$ = CHR$(0) + "K" THEN CALL fallback: a$ = "b"
IF a$ = CHR$(27) THEN CALL menu
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = " " THEN CALL shoot
IF x = 199 THEN x = 1
NEXT x
END
END SUB

SUB lev5
lev = 2
death = 0
CLS
COLOR 2
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (1, 50)
DRAW "r40d50r12u50r28d50r12u50r28d50r12u50r28u10r20d60"
COLOR 12
PSET (192, 10)
DRAW "r3d5r3g5h5r3u5"
PAINT (194, 12), 4, 12
PAINT (3, 93), 9, 2
PAINT (63, 93), 9, 2
PAINT (113, 93), 9, 2
PAINT (173, 93), 9, 2
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
a = 10
b = 43
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a$ = "T" OR a$ = "t" THEN COLOR 1: LOCATE 16, 1: PRINT TIME$: LOCATE 16, 1: SLEEP: PRINT "                   "
IF a = 15 AND death = 0 THEN CALL badman2
IF a = 15 AND death = 1 THEN CALL badman2
IF a = 55 AND death = 2 THEN CALL badman2
IF a = 55 AND death = 3 THEN CALL badman2
IF a = 140 AND death = 4 THEN CALL badman
IF a = 190 AND a$ = " " THEN CALL hitwall: a$ = "Yo"
IF a = 120 AND a$ = CHR$(0) + "M" THEN duh = 2
IF a = 180 AND a$ = CHR$(0) + "M" THEN duh = 1
IF a = 40 AND a$ = CHR$(0) + "H" OR a = 80 AND a$ = CHR$(0) + "H" OR a = 120 AND a$ = CHR$(0) + "H" THEN CALL jumpfar: a$ = "b"
IF a = 40 AND a$ = CHR$(0) + "M" OR a = 80 AND a$ = CHR$(0) + "M" OR a = 120 AND a$ = CHR$(0) + "M" OR a = 180 AND a$ = CHR$(0) + "M" THEN CALL fallpit: a$ = "b"
IF a = 10 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 155 AND a$ = CHR$(0) + "M" THEN a$ = "b"
IF a = 55 AND a$ = CHR$(0) + "K" OR a = 95 AND a$ = CHR$(0) + "K" OR a = 135 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 155 AND a$ = CHR$(0) + "H" THEN CALL jumpright: a$ = "b"
IF a = 165 AND a$ = CHR$(0) + "K" THEN CALL fallback: a$ = "b"
IF a = 155 AND a$ = " " THEN CALL hitself: a$ = "b"
IF a = 150 AND a$ = " " THEN CALL hitwall: a$ = "b"
IF a$ = CHR$(27) THEN CALL menu
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = " " THEN CALL shoot
IF x = 199 THEN x = 1
NEXT x
END SUB

SUB lev6
death = 0
lev = 6
CLS
COLOR 2
PSET (0, 0)
DRAW "r200d100l200u100"
PSET (50, 1)
DRAW "d89r101u90l30d60l50u60"
PAINT (3, 93), 9, 2
PAINT (85, 3), 9, 2
COLOR 13
PSET (131, 89)
DRAW "r19u30l19d30"
PAINT (132, 87), 2, 13
IF heal = 5 THEN CIRCLE (15, 115), 10, 4
IF heal = 4 THEN CIRCLE (15, 115), 8, 4
IF heal = 3 THEN CIRCLE (15, 115), 6, 4
IF heal = 2 THEN CIRCLE (15, 115), 4, 12
IF heal = 1 THEN CIRCLE (15, 115), 2, 12
IF heal = 0 THEN CALL die
a = 60
b = 83
CIRCLE (a, b), 5, 15: DRAW "c0u4c15u1c15r5u1l10d1r5u1l4u1c12e4f4l7e3f3l5e2f1l1"
FOR x = 1 TO 200
a$ = INKEY$
IF a$ = "T" OR a$ = "t" THEN COLOR 1: LOCATE 16, 1: PRINT TIME$: LOCATE 16, 1: SLEEP: PRINT "                   "
IF a = 70 AND death = 0 THEN CALL badman2
IF a = 70 AND death = 1 THEN CALL badman2
IF a = 70 AND death = 2 THEN CALL badman2
IF a = 75 AND death = 3 THEN CALL badman2
IF a = 75 AND death = 4 THEN CALL badman2
IF a = 75 AND death = 5 THEN CALL badman2
IF a = 90 AND death = 6 THEN CALL badman2
IF a = 90 AND death = 7 THEN CALL badman2
IF a = 90 AND death = 8 THEN CALL badman2

IF a = 190 AND a$ = " " THEN CALL hitwall: a$ = "Yo"
IF a = 125 THEN x = 200
IF a = 60 AND a$ = CHR$(0) + "K" THEN a$ = "b"
IF a = 125 AND a$ = " " THEN CALL hitself: a$ = "b"
IF a = 120 AND a$ = " " THEN CALL hitwall: a$ = "b"
IF a$ = CHR$(27) THEN CALL menu
IF a$ = CHR$(0) + "M" THEN CALL forward
IF a$ = CHR$(0) + "H" THEN CALL jump
IF a$ = CHR$(0) + "K" THEN CALL backward
IF a$ = " " THEN CALL shoot
IF x = 199 THEN x = 1
NEXT x
CALL evilsanta
END SUB

SUB lev7
COLOR 4
CLS
SCREEN 0
COLOR 15
LOCATE 1, 1
PRINT "You have won the CHRISTMAS VERSION"
PRINT "of HaK-MaN.If you enjoyed this"
PRINT "please DL the whole HaK-MaN.  If you"
PRINT "didn't enjoy this, DL the whole HaK-MaN"
PRINT "because it is alot better. The full"
PRINT "version includes:"
PRINT
PRINT "1) More levels (but harder)"
PRINT "2) More badguys(but harder)"
PRINT "3) PC sounds"
PRINT "4) Lots of cool pictures"
PRINT "5) More Guns!!!!!!!"
PRINT "6) 4 x the screen size (400x200)"
COLOR 31: PRINT "AND MUCH MORE! "
COLOR 15: PRINT
PRINT "Press Enter..."
DO
IF INKEY$ = CHR$(13) THEN END
LOOP
SCREEN 12
END
END SUB

SUB menu
blood = 1
CLS
COLOR 12
PSET (130, 100)
DRAW "r350d200l350u200"
PAINT (131, 103), 1, 12
COLOR 10
LOCATE 10, 20
PRINT "[P]lay Christmas HaK-MaN"
LOCATE 12, 20
PRINT "[B]lood  Yes  No"
COLOR 13
LOCATE 12, 28: PRINT "*"
LOCATE 14, 20
COLOR 10
PRINT "[I]nfo on Christmas HaK-MaN"
LOCATE 16, 20
PRINT "[E]xit Christmas HaK-MaN"
COLOR 8
PSET (140, 99)
DRAW "u10r350d200l9u190l340"
PAINT (145, 98), 8, 8
FOR x = 1 TO 200
a$ = INKEY$
IF a$ = "P" OR a$ = "p" THEN x = 200
IF a$ = "E" OR a$ = "e" THEN END
IF a$ = "I" OR a$ = "i" THEN CALL info
IF a$ = "B" AND blood = 1 OR a$ = "b" AND blood = 1 THEN
COLOR 0
LOCATE 12, 28: PRINT "*"
COLOR 13
LOCATE 12, 33
PRINT "*"
a$ = "Yo"
blood = 0
END IF
IF blood = 0 AND a$ = "b" OR blood = 0 AND a$ = "B" THEN
COLOR 0
LOCATE 12, 33: PRINT "*"
COLOR 13
LOCATE 12, 28
PRINT "*"
a$ = "Yo"
blood = 1
END IF
IF x = 199 THEN x = 1
NEXT x
CLS
death = 0
CALL lev1
END SUB






SUB shoot
COLOR 10
PSET (a + 10, b - 3)
DRAW "r3d6l3r2u3l2r2u1"
FOR cool = 1 TO 1000
NEXT cool
COLOR 0
PSET (a + 10, b - 3)
DRAW "r3d6l3r2u3l2r2u1"
END SUB

