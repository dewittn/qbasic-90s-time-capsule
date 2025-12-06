DECLARE SUB SAVER2 ()
DECLARE SUB game ()
DECLARE SUB HELP ()
DECLARE SUB Sparkle ()
DECLARE SUB TIME ()
DECLARE SUB DECODE ()
DECLARE SUB AUTO ()
DECLARE SUB Set ()
DECLARE SUB DAWINGS ()
DECLARE SUB GAMES ()
DECLARE SUB CAL ()
DECLARE SUB WRITER ()
DECLARE SUB music ()
DECLARE SUB saver ()
DECLARE SUB timex ()
DECLARE SUB main ()
DECLARE SUB ENCODE ()
DIM SHARED USERNAME$
CLS
CALL Sparkle
CLS
DEF SEG = 0
Status% = PEEK(&H417)
POKE &H417, (Status% XOR &H40)
COLOR 15
INPUT "ENTER NAME"; B$
USERNAME$ = B$
PRINT "ENTER CODE"
COLOR 0, 0: INPUT C$
IF C$ = "BLOOP" THEN CALL main
SCREEN 7
FOR a = 1 TO 1000
B = INT(RND(1) * 15) + 1
C = INT(RND(1) * 15) + 1
COLOR B, C
NEXT a
END

SUB AUTO
OPEN "SAVERS" FOR INPUT AS #1
INPUT #1, Rec1$
CLOSE
SELECT CASE Rec1$
        CASE "1"
        GOTO 15
        CASE "2"
        GOTO 11
        CASE "3"
        GOTO 19
        CASE "4"
        GOTO 21
        CASE "5"
        GOTO 22
        CASE "6"
        GOTO 23
        CASE "7"
        GOTO 48
        CASE "8"
        GOTO 74
        CASE "9"
        GOTO 75
        CASE "A"
        GOTO explosions
        CASE "B"
        GOTO squres
        CASE "C"
        GOTO raining
        CASE "D"
        GOTO shapes
        CASE "E"
        GOTO fly
        CASE "F"
        GOTO disolve
        CASE ELSE
        BEEP
        END SELECT
        PRINT "SOMETHING RONG": EXIT SUB
15 DO
a = INT(RND(1) * 127) + 1
PRINT CHR$(a);
LOOP WHILE INKEY$ = ""
EXIT SUB
11
DO
SCREEN 12
a = INT(RND(1) * 640) + 1
B = INT(RND(1) * 640) + 1
C = INT(RND(1) * 640) + 1
D = INT(RND(1) * 640) + 1
e = INT(RND(1) * 15) + 1
f = INT(RND(1) * 50) + 1
G = INT(RND(1) * 640) + 1
H = INT(RND(1) * 640) + 1
j = INT(RND(1) * 640) + 1
s = INT(RND(1) * 640) + 1
k = INT(RND(1) * 640) + 1
L = INT(RND(1) * 640) + 1
m = INT(RND(1) * 640) + 1
n = INT(RND(1) * 640) + 1
O = INT(RND(1) * 640) + 1
p = INT(RND(1) * 640) + 1
q = INT(RND(1) * 640) + 1
R = INT(RND(1) * 640) + 1
COLOR e
LINE (a, B)-(C, D), , BF
LINE (G, H)-(s, j)
LINE (G, H)-(s, j), , B
LINE (O, p)-(q, R)
LINE (k, L)-(m, n), , B
CIRCLE (a, B), f
Triangle$ = "F60 L120 E60"
DRAW "C2 X" + VARPTR$(Triangle$)
LOOP WHILE INKEY$ = ""
19 CLS
SCREEN 12
DO
C = INT(RND(1) * 15) + 1
COLOR C
a = INT(RND(1) * 1040) + 1
B = INT(RND(1) * 1040) + 1
LINE (320, 240)-(a, B)
IF INKEY$ = CHR$(27) THEN EXIT SUB
LOOP WHILE INKEY$ = ""
EXIT SUB
21 CLS
SCREEN 12
a = 0: B = 0: C = 0
DO
D = INT(RND(1) * 15) + 1
COLOR D
CIRCLE (a, B), C
a = a + 1
B = B + 1
C = C + 1
LOOP WHILE INKEY$ = ""
EXIT SUB
22 CLS
SCREEN 12
C = 0
DO
D = INT(RND(1) * 15) + 1
COLOR D
CIRCLE (320, 240), C
C = C + 1
IF INKEY$ = CHR$(27) THEN EXIT SUB
LOOP
23 SCREEN 12
C = 1
CLS
25 DO
a = INT(RND(1) * 15) + 1
COLOR a
D = D + 1
IF D > 500 THEN 24
B = INT(RND(1) * 1000) + 1
LINE (320, 240)-(B, D)
LOOP WHILE INKEY$ = ""
EXIT SUB
24 DO
a = INT(RND(1) * 15) + 1
COLOR a
D = D - 1
IF D < 0 THEN 25
B = INT(RND(1) * 1000) + 1
LINE (320, 240)-(B, D)
LOOP WHILE INKEY$ = ""
EXIT SUB
48
COLOR 0, 0
CLS
181
DO
a = INT(RND(1) * 127) + 1
IF a = 12 THEN 181
IF a = 11 THEN 181
B = INT(RND * 30)
COLOR B
PRINT CHR$(a);
LOOP WHILE INKEY$ = ""
EXIT SUB
74
DO: CLS
C = 0
SCREEN 1
FOR Z = .1 TO 1.1 STEP .0002
IF INKEY$ = CHR$(27) THEN EXIT SUB
C = C + 1
CIRCLE (Z * 200, SIN(Z * 24) * (Z * 50) + 100), Z * 40, C
C = -C * (C < 15): NEXT Z
FOR Z = 1 TO 1000
C = C + 1
IF C > 6 THEN 74
PALETTE C, 0
PALETTE C, C
NEXT Z
LOOP WHILE INKEY$ = ""
EXIT SUB
75 CLS
SCREEN 12
DO
a = INT(RND(1) * 15) + 1
G = INT(RND(1) * 640) + 1
H = INT(RND(1) * 640) + 1
j = INT(RND(1) * 640) + 1
s = INT(RND(1) * 640) + 1
COLOR a
LINE (G, H)-(j, s)
LOOP WHILE INKEY$ = ""
EXIT SUB
disolve:
SCREEN 12
     DIM Box%(1 TO 200)
deds:
    Z = RND * 14 + 1
    x1% = 0: x2% = 1: y1% = 0: y2% = 1
    LINE (x1%, y1%)-(x2%, y2%), Z, BF
    GET (x1%, y1%)-(x2%, y2%), Box%
    xa = 1
    DO
    xa = xa + 1
        PUT (x1%, y1%), Box%, OR
        x1% = RND * 620
        y1% = RND * 460
        PUT (x1%, y1%), Box%
        IF xa = 7000 THEN CLS : GOTO deds
LOOP WHILE INKEY$ = ""
EXIT SUB
squres:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 640
D = RND * 480
e = RND * 15 + 1
LINE (a, B)-(C, D), e, BF
LOOP WHILE INKEY$ = ""
EXIT SUB
raining:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 15 + 1
D = RND * 30
FOR X = 1 TO D
CIRCLE (a, B), (X), C
NEXT X
LOOP WHILE INKEY$ = ""
EXIT SUB
shapes:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 640
D = RND * 480
e = RND * 15 + 1
f = RND * 100
G = RND * 15 + 1
H = RND * 640
i = RND * 480
LINE (a, B)-(C, D), e, BF
CIRCLE (H, i), f, G
LOOP WHILE INKEY$ = ""
EXIT SUB
explosions:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 15 + 1
D = RND * 300
FOR X = 1 TO D
CIRCLE (a, B), (X), C
NEXT X
LOOP WHILE INKEY$ = ""
EXIT SUB
fly:
COLOR 0, 0
CLOSE
RANDOMIZE TIMER
CLS
OPEN "fly.slp" FOR INPUT AS #1
INPUT #1, bht$
G = LEN(bht$)
DO
CLS
FOR aple = 1 TO 80 - ged
ged = RND * 14 + 1
LOCATE 10, aple, 0
FOR slp = 1 TO 100: NEXT slp
COLOR ged
PRINT " "; bht$
NEXT aple
LOOP WHILE INKEY$ = ""
EXIT SUB
140 CALL AUTO
EXIT SUB
141
END SUB

SUB CAL
Z = 30
128 DO: X = 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(30); "C A L C U L A T O R"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "1)ADD"
PRINT "2)SUBTRACT"
PRINT "3)MULTIPLY"
PRINT "4)DIVIDE"
PRINT "5)FIBANCHY SEQUENCE"
PRINT "6)TRIANGULER NUMBERS"
PRINT "7)FACTORIALS"
PRINT "8)POWERS"
PRINT "9)AVERAGER"
PRINT "PICK ONE"
DO
B$ = INKEY$
SLEEP 1
X = X + 1
IF X > Z THEN GOSUB 130
LOOP WHILE B$ = ""
SELECT CASE B$
CASE "1"
GOTO 31
CASE "2"
GOTO 33
CASE "3"
GOTO 35
CASE "4"
GOTO 38
CASE "5"
GOTO 40
CASE "6"
GOTO 42
CASE "7"
GOTO 45
CASE "8"
GOTO 46
CASE "9"
GOTO 50
CASE CHR$(24)
GOTO 134
CASE ELSE
BEEP
END SELECT
LOOP
31 CLS
X = 0
PRINT "1)ADD NUMBERS"
PRINT "PRESS 1 TO BEGIN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 31
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 32
CASE ELSE
BEEP
END SELECT
GOTO 31
32 CLS
INPUT "HOW MANY NUMBER TO BE ADDED"; a
IF a < 2 THEN 32
a = a - 1
INPUT C
FOR B = 1 TO a
INPUT D
e = D + C
PRINT C; "+"; D; "="; e
C = e
NEXT B
PRINT "HIT ANY KEY TO CONTINUE"
DO
B$ = INKEY$
LOOP WHILE B$ = ""
GOTO 31
33
CLS
PRINT "1)SUBTRACT NUMBERS"
PRINT "PRESS 1 TO BEGIN"
X = 0
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 33
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 34
CASE ELSE
BEEP
END SELECT
GOTO 46
34 CLS
INPUT "HOW MANY NUMBERS TO BE SUBTRACTED"; a
IF a < 2 THEN 34
a = a - 1
INPUT C
FOR B = 1 TO a
INPUT D
e = C - D
PRINT C; "-"; D; "="; e
C = e
NEXT B
PRINT "HIT ANY KEY TO CONTINUE"
DO
LOOP WHILE INKEY$ = ""
GOTO 33
35 CLS
PRINT "1)MULTIPLY NUMBERS"
PRINT "PRESS 1 TO BEGIN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 36
CASE ELSE
BEEP
END SELECT
GOTO 35
36 CLS
INPUT "HOW MANY NUMBERS TO BE MULTIPLYED"; a
IF a < 2 THEN 34
a = a - 1
INPUT C
FOR B = 1 TO a
INPUT D
e = C * D
PRINT C; "*"; D; "="; e
C = e
NEXT B
PRINT "HIT ANY KEY TO CONTINUE"
DO
LOOP WHILE INKEY$ = ""
GOTO 35
38 CLS
PRINT "1)DIVIDE NUMBERS"
PRINT "PRESS 1 TO BEGIN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 39
CASE ELSE
BEEP
END SELECT
GOTO 38
39 CLS
INPUT "HOW MANY NUMBERS TO BE DIVIDED"; a
IF a < 2 THEN 34
a = a - 1
INPUT C
FOR B = 1 TO a
INPUT D
e = C / D
PRINT C; "/"; D; "="; e
C = e
NEXT B
PRINT "HIT ANY KEY TO CONTINUE"
DO
LOOP WHILE INKEY$ = ""
GOTO 38
40
CLS
PRINT "1)FIBACHY SEQUENCE"
PRINT "PRESS 1 TO BEGINN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 40
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 143
CASE ELSE
BEEP
END SELECT
GOTO 40
143 CLS
PRINT "PRESS ESC TO STOP"
SLEEP 2
a = 1
B = 1
PRINT a
SLEEP 1
PRINT B
DO
q = q + 1
IF q > 183 THEN a = 1: B = 1: q = 0: PRINT 1: PRINT 1
C = a + B
a = B
B = C
IF INKEY$ = CHR$(27) THEN 41
PRINT C
SLEEP 1
LOOP
41 PRINT "HIT ANY KEY"
DO
LOOP WHILE INKEY$ = ""
GOTO 40
42 CLS
PRINT "TRIANGULAR NUMBERS"
PRINT "1)PRINT ALL NUMBERS"
PRINT "2)PICK NUMBER"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 42
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 43
CASE "2"
GOTO 44
CASE ELSE
BEEP
END SELECT
GOTO 33
GOTO 42
43 CLS
a = 0: B = 0: C = 0
PRINT "PRESS ESC TO STOP"
a = 1
DO
B = a + C
a = a + 1
C = B
IF INKEY$ = CHR$(27) THEN 41
SLEEP 1
PRINT B
LOOP
44 CLS
PRINT "TYPE 0 TO END"
DO
INPUT a
IF a = 0 THEN 42
C = a
FOR q = 1 TO a
a = a - 1
B = a + C
C = B
IF INKEY$ = CHR$(27) THEN 42
NEXT q
PRINT B
LOOP
45 CLS
PRINT "1)FACTORS"
PRINT "PRESS 1 TO BEGIN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 45
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 145
CASE ELSE
BEEP
END SELECT
GOTO 45
145
CLS
PRINT "TYPE 0 TO END"
DO
INPUT a
IF a = 0 THEN 45
IF a = -1 THEN END
C = 1
FOR q = 1 TO a
B = C * a
a = a - 1
C = B
NEXT q
PRINT B
LOOP
46 CLS
PRINT "1)POWERS"
PRINT "PRESS 1 TO BEGIN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 46
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 146
CASE ELSE
BEEP
END SELECT
GOTO 46
146 CLS
DO
INPUT "ENTER NUMBER"; a
IF a = 0 THEN 46
IF a = -1 THEN END
47 INPUT "ENTER POWER"; B
IF B < 2 THEN 47
e = a
FOR q = 2 TO B
C = a * e
e = C
NEXT q
PRINT C
LOOP
50
CLS
PRINT "1)AVERAGER + GRADER"
PRINT "PRESS 1 BEGIN"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOSUB 130: GOTO 50
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
CASE CHR$(24)
GOTO 128
CASE CHR$(26)
END
CASE "1"
GOTO 51
CASE ELSE
BEEP
END SELECT
GOTO 50
51 CLS
INPUT "HOW MANY NUMBERS TO BE AVERAGED"; a
IF a < 2 THEN 51
INPUT e
X = a - 1
FOR q = 1 TO X
INPUT B
f = B + e
e = f
NEXT q
s = f / a
PRINT s; "%"
PRINT "GRADE IS"
IF s > 59 THEN q$ = "F"
IF s > 70 THEN q$ = "D"
IF s > 72 THEN q$ = "C-"
IF s > 76 THEN q$ = "C"
IF s > 79 THEN q$ = "C+"
IF s > 82 THEN q$ = "B-"
IF s > 86 THEN q$ = "B"
IF s > 89 THEN q$ = "B+"
IF s > 94 THEN q$ = "A-"
IF s > 100 THEN q$ = "A"
IF s > 100 THEN q$ = "A+"
PRINT q$
PRINT "HIT ANY KEY"
DO
LOOP WHILE INKEY$ = ""
GOTO 50
130 CALL AUTO
X = 0
SCREEN 0
COLOR 15, 1
RETURN
134
END SUB

SUB DAWINGS
Z = 30
125 X = 0
SCREEN 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(25); "D R A W I N G S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "1)IMPOSSIBLE TRIANGLE"
PRINT "2)CUBE"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X = Z THEN 127
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
        CASE "1"
        GOTO 72
        CASE "2"
        GOTO 73
        CASE CHR$(24)
        GOTO 133
        CASE CHR$(26)
        END
        CASE ELSE
        BEEP
        END SELECT
        GOTO 125
72 SCREEN 12
DRAW "U10 R10 D10 L10 U10 E90 F100 L190 U10 R165 F10 H87 E8 H5 G8 F5 E8 G85 E5 R135 F5 H67 E5 G67"
PRINT "HIT ANY KEY"
DO
LOOP WHILE INKEY$ = ""
GOTO 125
73 SCREEN 12
DRAW "U100 R100 D100 L100 U100 E40 R100 G40 D100 E40 U100"
PRINT "HIT ANY KEY"
DO
LOOP WHILE INKEY$ = ""
GOTO 125
127 CALL AUTO
GOTO 125
133
END SUB

SUB DECODE
Z = 30
160 X = 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(30); "D E C O D E R"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "1)RANDOM NUBER CODE"
PRINT "2)MESSAGE CODE"
PRINT "3)MATH CODE"
PRINT "4)MORES"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X = Z THEN 161
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
        CASE "1"
        GOTO 162
        CASE "2"
        GOTO 182
        CASE "3"
        GOTO 169
        CASE "4"
        GOTO 197
        CASE CHR$(24)
        GOTO 166
        CASE CHR$(26)
        END
        CASE ELSE
        BEEP
        END SELECT
        GOTO 160
162 CLS
PRINT "TO END PRESS ENTER"
PRINT "TO CLEAR  SCREEN PRESS 1"
168 DO
INPUT "ENTER BIGGER NUMBER"; C
IF C = 1 THEN 162
IF C = 0 THEN 160
INPUT "ENTER SMALLER NUMBER"; B
a = C - B
IF a < 0 THEN 168
IF a > 26 THEN 168
IF a = 1 THEN a$ = "A"
IF a = 2 THEN a$ = "B"
IF a = 3 THEN a$ = "C"
IF a = 4 THEN a$ = "D"
IF a = 5 THEN a$ = "E"
IF a = 6 THEN a$ = "F"
IF a = 7 THEN a$ = "G"
IF a = 8 THEN a$ = "H"
IF a = 9 THEN a$ = "I"
IF a = 10 THEN a$ = "J"
IF a = 11 THEN a$ = "K"
IF a = 12 THEN a$ = "L"
IF a = 13 THEN a$ = "M"
IF a = 14 THEN a$ = "N"
IF a = 15 THEN a$ = "O"
IF a = 16 THEN a$ = "P"
IF a = 17 THEN a$ = "Q"
IF a = 18 THEN a$ = "R"
IF a = 19 THEN a$ = "S"
IF a = 20 THEN a$ = "T"
IF a = 21 THEN a$ = "U"
IF a = 22 THEN a$ = "V"
IF a = 23 THEN a$ = "W"
IF a = 24 THEN a$ = "X"
IF a = 25 THEN a$ = "Y"
IF a = 26 THEN a$ = "Z"
PRINT a$
LOOP
169 CLS
170 DO
INPUT "ENTER FIRST NUMBER"; B
IF B = 0 THEN 160
INPUT "ENTER SECOND NUMBER"; D
PRINT "1 = *: 2 = /: 3 = +: 4 = -"
171 INPUT "ENTER OPERATION NUMBER"; e
IF e > 4 THEN 171
INPUT "ENTER ASNWER"; C
IF e = 1 THEN G = B * D
IF e = 2 THEN G = B / D
IF e = 3 THEN G = B + D
IF e = 4 THEN G = B - D
a = C - G
IF C = 1 THEN 169
IF C = 0 THEN 160
IF a < 0 THEN 170
IF a > 26 THEN 170
IF a = 1 THEN a$ = "A"
IF a = 2 THEN a$ = "B"
IF a = 3 THEN a$ = "C"
IF a = 4 THEN a$ = "D"
IF a = 5 THEN a$ = "E"
IF a = 6 THEN a$ = "F"
IF a = 7 THEN a$ = "G"
IF a = 8 THEN a$ = "H"
IF a = 9 THEN a$ = "I"
IF a = 10 THEN a$ = "J"
IF a = 11 THEN a$ = "K"
IF a = 12 THEN a$ = "L"
IF a = 13 THEN a$ = "M"
IF a = 14 THEN a$ = "N"
IF a = 15 THEN a$ = "O"
IF a = 16 THEN a$ = "P"
IF a = 17 THEN a$ = "Q"
IF a = 18 THEN a$ = "R"
IF a = 19 THEN a$ = "S"
IF a = 20 THEN a$ = "T"
IF a = 21 THEN a$ = "U"
IF a = 22 THEN a$ = "V"
IF a = 23 THEN a$ = "W"
IF a = 24 THEN a$ = "X"
IF a = 25 THEN a$ = "Y"
IF a = 26 THEN a$ = "Z"
PRINT a$
LOOP
182
CLS
DO
INPUT "ENTER MESSAGE"; a$
IF a$ = CHR$(26) THEN END
IF a$ = CHR$(24) THEN 160
IF a$ = "" THEN 182
L = LEN(a$)
FOR n = 1 TO L
a = ASC(MID$(a$, n, 1)) + 16
PRINT CHR$(a);
NEXT n
PRINT
LOOP
197 CLS
DO
COLOR 7, 9: INPUT "ENTER CODE"; ax$: COLOR 15, 9
    IF ax$ = "" THEN 197
    IF ax$ = CHR$(26) THEN END
    IF ax$ = CHR$(24) THEN 160
    IF ax$ = "._" THEN PRINT "a"
    IF ax$ = "_..." THEN PRINT "b"
    IF ax$ = "_._." THEN PRINT "c"
    IF ax$ = "_.." THEN PRINT "d"
    IF ax$ = "." THEN PRINT "e"
    IF ax$ = ".._." THEN PRINT "f"
    IF ax$ = "__." THEN PRINT "g"
    IF ax$ = "...." THEN PRINT "h"
    IF ax$ = ".." THEN PRINT "i"
    IF ax$ = ".___" THEN PRINT "j"
    IF ax$ = "_._" THEN PRINT "k"
    IF ax$ = "._.." THEN PRINT "l"
    IF ax$ = "__" THEN PRINT "m"
    IF ax$ = "_." THEN PRINT "n"
    IF ax$ = "___" THEN PRINT "o"
    IF ax$ = ".__." THEN PRINT "p"
    IF ax$ = "__._" THEN PRINT "q"
    IF ax$ = "._." THEN PRINT "r"
    IF ax$ = "..." THEN PRINT "s"
    IF ax$ = "_" THEN PRINT "t"
    IF ax$ = ".._" THEN PRINT "u"
    IF ax$ = "..._" THEN PRINT "v"
    IF ax$ = ".__" THEN PRINT "w"
    IF ax$ = "_.._" THEN PRINT "x"
    IF ax$ = "_.__" THEN PRINT "y"
    IF ax$ = "__.." THEN PRINT "z"
    LOOP

161 CALL AUTO
GOTO 160
166
END SUB

SUB ENCODE
Z = 30
124 X = 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(30); "E N C O D E R"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "1)RANDOM NUBER CODE"
PRINT "2)MESSAGE CODE"
PRINT "3)MATH CODE"
PRINT "4)PYRAMID CODE"
PRINT "5)MORES CODE"
PRINT "6)LETTER CODE"
PRINT "7)BINARY"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X = Z THEN 135
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
        CASE "1"
        GOTO 5
        CASE "2"
        GOTO 7
        CASE "3"
        GOTO 49
        CASE "4"
        GOTO 184
        CASE "6"
        GOTO 192
        CASE "5"
        GOTO 191
        CASE "7"
        GOTO 196
        CASE CHR$(24)
        GOTO 136
        CASE CHR$(26)
        END
        CASE ELSE
        BEEP
        END SELECT
        GOTO 124
5 CLS
PRINT INT(RND(1) * 999) + 1
DO
INPUT "ENTER LETER"; a$
IF a$ = "" THEN 5
IF a$ = CHR$(26) THEN END
IF a$ = CHR$(24) THEN 124
B = INT(RND(1) * 999) + 1
IF a$ = "A" THEN a = 1
IF a$ = "B" THEN a = 2
IF a$ = "C" THEN a = 3
IF a$ = "D" THEN a = 4
IF a$ = "E" THEN a = 5
IF a$ = "F" THEN a = 6
IF a$ = "G" THEN a = 7
IF a$ = "H" THEN a = 8
IF a$ = "I" THEN a = 9
IF a$ = "J" THEN a = 10
IF a$ = "K" THEN a = 11
IF a$ = "L" THEN a = 12
IF a$ = "M" THEN a = 13
IF a$ = "N" THEN a = 14
IF a$ = "O" THEN a = 15
IF a$ = "P" THEN a = 16
IF a$ = "Q" THEN a = 17
IF a$ = "R" THEN a = 3
IF a$ = "S" THEN a = 19
IF a$ = "T" THEN a = 20
IF a$ = "U" THEN a = 21
IF a$ = "V" THEN a = 22
IF a$ = "W" THEN a = 23
IF a$ = "X" THEN a = 24
IF a$ = "Y" THEN a = 25
IF a$ = "Z" THEN a = 26
PRINT B
PRINT B + a
LOOP
7 CLS
DO
INPUT "ENTER MASSAGE"; a$
IF a$ = CHR$(26) THEN END
IF a$ = CHR$(24) THEN 124
IF a$ = "" THEN 7
L = LEN(a$)
FOR n = 1 TO L
a = ASC(MID$(a$, n, 1)) - 16
PRINT CHR$(a);
NEXT n
PRINT
LOOP
49 CLS
DO
INPUT "ENTER LETTER"; a$
IF a$ = CHR$(24) THEN 124
IF a$ = CHR$(26) THEN END
IF a$ = "" THEN 49
IF a$ = "A" THEN a = 1
IF a$ = "B" THEN a = 2
IF a$ = "C" THEN a = 4
IF a$ = "D" THEN a = 4
IF a$ = "E" THEN a = 5
IF a$ = "F" THEN a = 6
IF a$ = "G" THEN a = 7
IF a$ = "H" THEN a = 8
IF a$ = "I" THEN a = 9
IF a$ = "J" THEN a = 10
IF a$ = "K" THEN a = 11
IF a$ = "L" THEN a = 12
IF a$ = "M" THEN a = 13
IF a$ = "N" THEN a = 14
IF a$ = "O" THEN a = 15
IF a$ = "P" THEN a = 16
IF a$ = "Q" THEN a = 17
IF a$ = "R" THEN a = 18
IF a$ = "S" THEN a = 19
IF a$ = "T" THEN a = 20
IF a$ = "U" THEN a = 21
IF a$ = "V" THEN a = 22
IF a$ = "W" THEN a = 23
IF a$ = "X" THEN a = 24
IF a$ = "Y" THEN a = 25
IF a$ = "Z" THEN a = 26
B = INT(4 * RND(1) + 1)
C = INT(RND(1) * 99) + 1
D = INT(RND(1) * 99) + 1
IF B = 1 THEN e = C + D: PRINT C; "+"; D; "="; e + a
IF B = 2 THEN e = C - D: PRINT C; "-"; D; "="; e + a
IF B = 3 THEN e = C * D: PRINT C; "*"; D; "="; e + a
IF B = 4 THEN e = C / D: PRINT C; "/"; D; "="; e + a
LOOP
184 CLS
DO
INPUT "ENTER LETTER"; a$
IF a$ = CHR$(24) THEN 124
IF a$ = CHR$(26) THEN END
IF a$ = "" THEN 184
L = LEN(a$)
D = INT(RND * 18)
FOR V = 1 TO L
B$ = MID$(a$, V, 1)
IF B$ = "A" THEN a = 6: B = 7: C = 18
IF B$ = "B" THEN a = 5: B = 7: C = 18
IF B$ = "C" THEN a = 4: B = 7: C = 18
IF B$ = "D" THEN a = 3: B = 7: C = 18
IF B$ = "E" THEN a = 2: B = 7: C = 18
IF B$ = "F" THEN a = 1: B = 7: C = 18
IF B$ = "G" THEN a = 1: B = 8: C = 17
IF B$ = "H" THEN a = 2: B = 8: C = 17
IF B$ = "I" THEN a = 3: B = 8: C = 17
IF B$ = "J" THEN a = 4: B = 8: C = 17
IF B$ = "K" THEN a = 5: B = 8: C = 17
IF B$ = "L" THEN a = 6: B = 8: C = 17
IF B$ = "M" THEN a = 5: B = 9: C = 16
IF B$ = "N" THEN a = 4: B = 9: C = 16
IF B$ = "O" THEN a = 3: B = 9: C = 16
IF B$ = "P" THEN a = 2: B = 9: C = 16
IF B$ = "Q" THEN a = 2: B = 10: C = 15
IF B$ = "R" THEN a = 3: B = 10: C = 15
IF B$ = "S" THEN a = 4: B = 10: C = 15
IF B$ = "T" THEN a = 5: B = 10: C = 15
IF B$ = "U" THEN a = 5: B = 11: C = 14
IF B$ = "V" THEN a = 4: B = 11: C = 14
IF B$ = "W" THEN a = 3: B = 11: C = 14
IF B$ = "X" THEN a = 2: B = 11: C = 14
IF B$ = "Y" THEN a = 3: B = 12: C = 13
IF B$ = "Z" THEN a = 4: B = 12: C = 13
a = a + D
B = B + D
IF B > 26 THEN B = B - 26
C = C + D
IF C > 26 THEN C = C - 26
IF a = 1 THEN C$ = "A"
IF a = 2 THEN C$ = "B"
IF a = 3 THEN C$ = "C"
IF a = 4 THEN C$ = "D"
IF a = 5 THEN C$ = "E"
IF a = 6 THEN C$ = "F"
IF a = 7 THEN C$ = "G"
IF a = 8 THEN C$ = "H"
IF a = 9 THEN C$ = "I"
IF a = 10 THEN C$ = "J"
IF a = 11 THEN C$ = "K"
IF a = 12 THEN C$ = "L"
IF a = 13 THEN C$ = "M"
IF a = 14 THEN C$ = "N"
IF a = 15 THEN C$ = "O"
IF a = 16 THEN C$ = "P"
IF a = 17 THEN C$ = "Q"
IF a = 18 THEN C$ = "R"
IF a = 19 THEN C$ = "S"
IF a = 20 THEN C$ = "T"
IF a = 21 THEN C$ = "U"
IF a = 22 THEN C$ = "V"
IF a = 23 THEN C$ = "W"
IF a = 24 THEN C$ = "X"
IF a = 25 THEN C$ = "Y"
IF a = 26 THEN C$ = "Z"
IF B = 1 THEN D$ = "A"
IF B = 2 THEN D$ = "B"
IF B = 3 THEN D$ = "C"
IF B = 4 THEN D$ = "D"
IF B = 5 THEN D$ = "E"
IF B = 6 THEN D$ = "F"
IF B = 7 THEN D$ = "G"
IF B = 8 THEN D$ = "H"
IF B = 9 THEN D$ = "I"
IF B = 10 THEN D$ = "J"
IF B = 11 THEN D$ = "K"
IF B = 12 THEN D$ = "L"
IF B = 13 THEN D$ = "M"
IF B = 14 THEN D$ = "N"
IF B = 15 THEN D$ = "O"
IF B = 16 THEN D$ = "P"
IF B = 17 THEN D$ = "Q"
IF B = 18 THEN D$ = "R"
IF B = 19 THEN D$ = "S"
IF B = 20 THEN D$ = "T"
IF B = 21 THEN D$ = "U"
IF B = 22 THEN D$ = "V"
IF B = 23 THEN D$ = "W"
IF B = 24 THEN D$ = "X"
IF B = 25 THEN D$ = "Y"
IF B = 26 THEN D$ = "Z"
IF C = 1 THEN e$ = "A"
IF C = 2 THEN e$ = "B"
IF C = 3 THEN e$ = "C"
IF C = 4 THEN e$ = "D"
IF C = 5 THEN e$ = "E"
IF C = 6 THEN e$ = "F"
IF C = 7 THEN e$ = "G"
IF C = 8 THEN e$ = "H"
IF C = 9 THEN e$ = "I"
IF C = 10 THEN e$ = "J"
IF C = 11 THEN e$ = "K"
IF C = 12 THEN e$ = "L"
IF C = 13 THEN e$ = "M"
IF C = 14 THEN e$ = "N"
IF C = 15 THEN e$ = "O"
IF C = 16 THEN e$ = "P"
IF C = 17 THEN e$ = "Q"
IF C = 18 THEN e$ = "R"
IF C = 19 THEN e$ = "S"
IF C = 20 THEN e$ = "T"
IF C = 21 THEN e$ = "U"
IF C = 22 THEN e$ = "V"
IF C = 23 THEN e$ = "W"
IF C = 24 THEN e$ = "X"
IF C = 25 THEN e$ = "Y"
IF C = 26 THEN e$ = "Z"
e = INT(RND * 4)
IF e = 1 THEN PRINT C$; D$;
IF e = 2 THEN PRINT D$; C$;
IF e = 3 THEN PRINT C$; e$;
IF e = 4 THEN PRINT e$, C$
NEXT V
PRINT D
LOOP
192 CLS
DO
INPUT "ENTER LETTERS"; H$
    IF H$ = "" THEN 192
    IF H$ = CHR$(24) THEN 124
    IF H$ = CHR$(26) THEN END
n = LEN(H$)
FOR V = 1 TO n
HI$ = MID$(H$, V, 1)
194  RANDOMIZE TIMER
    mn = INT(26 * RND(1) + 1)
    IF mn = 1 THEN GOTO 194
    IF mn = 2 THEN mn$ = "B"
    IF mn = 3 THEN mn$ = "C"
    IF mn = 4 THEN mn$ = "D"
    IF mn = 5 THEN GOTO 194
    IF mn = 6 THEN mn$ = "F"
    IF mn = 7 THEN mn$ = "G"
    IF mn = 8 THEN mn$ = "H"
    IF mn = 9 THEN GOTO 194
    IF mn = 10 THEN mn$ = "J"
    IF mn = 11 THEN mn$ = "K"
    IF mn = 12 THEN mn$ = "L"
    IF mn = 13 THEN mn$ = "M"
    IF mn = 14 THEN mn$ = "N"
    IF mn = 15 THEN GOTO 194
    IF mn = 16 THEN mn$ = "P"
    IF mn = 17 THEN mn$ = "Q"
    IF mn = 18 THEN mn$ = "R"
    IF mn = 19 THEN mn$ = "S"
    IF mn = 20 THEN mn$ = "T"
    IF mn = 21 THEN GOTO 194
    IF mn = 22 THEN mn$ = "V"
    IF mn = 23 THEN mn$ = "W"
    IF mn = 24 THEN mn$ = "X"
    IF mn = 25 THEN mn$ = "Y"
    IF mn = 26 THEN mn$ = "Z"
    RANDOMIZE TIMER
    mc = INT(5 * RND(1) + 1)
    IF mc = 1 THEN mc$ = "A"
    IF mc = 2 THEN mc$ = "E"
    IF mc = 3 THEN mc$ = "I"
    IF mc = 4 THEN mc$ = "O"
    IF mc = 5 THEN mc$ = "U"
    IF HI$ = "A" THEN PRINT mc$; mn$;
    IF HI$ = "B" THEN PRINT mn$; mc$; mc$; mc$;
    IF HI$ = "C" THEN PRINT mn$; mc$; mn$; mc$;
    IF HI$ = "D" THEN PRINT mn$; mc$; mc$;
    IF HI$ = "E" THEN PRINT mc$;
    IF HI$ = "F" THEN PRINT mc$; mc$; mn$; mc$;
    IF HI$ = "G" THEN PRINT mn$; mn$; mc$;
    IF HI$ = "H" THEN PRINT mc$; mc$; mc$; mc$;
    IF HI$ = "I" THEN PRINT mc$; mc$;
    IF HI$ = "J" THEN PRINT mc$; mn$; mn$; mn$;
    IF HI$ = "K" THEN PRINT mn$; mc$; mn$;
    IF HI$ = "L" THEN PRINT mc$; mn$; mc$; mc$;
    IF HI$ = "M" THEN PRINT mn$; mn$;
    IF HI$ = "N" THEN PRINT mn$; mc$;
    IF HI$ = "O" THEN PRINT mn$; mn$; mn$;
    IF HI$ = "P" THEN PRINT mc$; mn$; mn$; mc$;
    IF HI$ = "Q" THEN PRINT mn$; mn$; mc$; mn$;
    IF HI$ = "R" THEN PRINT mc$; mn$; mc$;
    IF HI$ = "S" THEN PRINT mc$; mc$; mc$;
    IF HI$ = "T" THEN PRINT mn$;
    IF HI$ = "U" THEN PRINT mc$; mc$; mn$;
    IF HI$ = "V" THEN PRINT mc$; mc$; mn$;
    IF HI$ = "W" THEN PRINT mc$; mn$; mn$;
    IF HI$ = "X" THEN PRINT mn$; mc$; mc$; mn$;
    IF HI$ = "Y" THEN PRINT mn$; mc$; mn$; mn$;
    IF HI$ = "Z" THEN PRINT mn$; mn$; mc$; mc$;
    NEXT V
    PRINT
    LOOP
191 CLS
DO
INPUT "ENTER LETTERS"; ACS$
    IF ACS$ = "" THEN 191
    IF ACS$ = CHR$(24) THEN GOTO 124
    IF ACS$ = CHR$(26) THEN END
    n = LEN(ACS$)
    FOR V = 1 TO n
    AC$ = MID$(ACS$, V, 1)
    a$ = "._"
    B$ = "_..."
    C$ = "_._."
    D$ = "_.."
    e$ = "."
    f$ = ".._."
    G$ = "__."
    H$ = "...."
    i$ = ".."
    j$ = ".___"
    k$ = "_._"
    L$ = "._.."
    m$ = "__"
    n$ = "_."
    O$ = "___"
    p$ = ".__."
    q$ = "__._"
    R$ = "._."
    s$ = "..."
    t$ = "_"
    u$ = ".._"
    V$ = "..._"
    w$ = ".__"
    X$ = "_.._"
    y$ = "_.__"
    Z$ = "__.."
    IF AC$ = "A" THEN PRINT a$;
    IF AC$ = "B" THEN PRINT B$;
    IF AC$ = "C" THEN PRINT C$;
    IF AC$ = "D" THEN PRINT D$;
    IF AC$ = "E" THEN PRINT e$;
    IF AC$ = "F" THEN PRINT f$;
    IF AC$ = "G" THEN PRINT G$;
    IF AC$ = "H" THEN PRINT H$;
    IF AC$ = "I" THEN PRINT i$;
    IF AC$ = "J" THEN PRINT j$;
    IF AC$ = "K" THEN PRINT k$;
    IF AC$ = "L" THEN PRINT L$;
    IF AC$ = "M" THEN PRINT m$;
    IF AC$ = "N" THEN PRINT n$;
    IF AC$ = "O" THEN PRINT O$;
    IF AC$ = "P" THEN PRINT p$;
    IF AC$ = "Q" THEN PRINT q$;
    IF AC$ = "R" THEN PRINT R$;
    IF AC$ = "S" THEN PRINT s$;
    IF AC$ = "T" THEN PRINT t$;
    IF AC$ = "U" THEN PRINT u$;
    IF AC$ = "V" THEN PRINT V$;
    IF AC$ = "W" THEN PRINT w$;
    IF AC$ = "X" THEN PRINT X$;
    IF AC$ = "Y" THEN PRINT y$;
    IF AC$ = "Z" THEN PRINT Z$;
    NEXT V
    PRINT
    LOOP
196 CLS
DO
INPUT "ENTER LETERS"; XZE$
IF XZE$ = "" THEN 196
IF XZE$ = CHR$(24) THEN 124
IF XZE$ = CHR$(26) THEN END
n = LEN(XZE$)
FOR V = 1 TO n
XZ$ = MID$(XZE$, V, 1)
IF XZ$ = "A" THEN PRINT "1";
IF XZ$ = "B" THEN PRINT "10";
IF XZ$ = "C" THEN PRINT "11";
IF XZ$ = "D" THEN PRINT "100";
IF XZ$ = "E" THEN PRINT "101";
IF XZ$ = "F" THEN PRINT "110";
IF XZ$ = "G" THEN PRINT "111";
IF XZ$ = "H" THEN PRINT "1000";
IF XZ$ = "I" THEN PRINT "1001";
IF XZ$ = "J" THEN PRINT "1010";
IF XZ$ = "K" THEN PRINT "1011";
IF XZ$ = "L" THEN PRINT "1100";
IF XZ$ = "M" THEN PRINT "1101";
IF XZ$ = "N" THEN PRINT "1110";
IF XZ$ = "O" THEN PRINT "1111";
IF XZ$ = "P" THEN PRINT "10000";
IF XZ$ = "Q" THEN PRINT "10001";
IF XZ$ = "R" THEN PRINT "10010";
IF XZ$ = "S" THEN PRINT "10011";
IF XZ$ = "T" THEN PRINT "10100";
IF XZ$ = "U" THEN PRINT "10101";
IF XZ$ = "V" THEN PRINT "10110";
IF XZ$ = "W" THEN PRINT "10111";
IF XZ$ = "X" THEN PRINT "11000";
IF XZ$ = "Y" THEN PRINT "11001";
IF XZ$ = "Z" THEN PRINT "11010";
NEXT V
PRINT
LOOP
135 CALL AUTO
GOTO 124
136
END SUB

SUB game
CLS
SLEEP 1
MUSICb$ = "l16o3cfffeeeddefeccdddddddaaaao4cfffeeeddefeccdddddddaaaao3cfffeeeddefeccdddddddeeeeeeeedddddddddddddddd"
PLAY MUSICb$
COLOR 7, 8: CLS
HI:
CLS : INPUT "you are in a large room. there are passages to the south, east and west"; C$
IF C$ = "SOUTH" THEN GOTO BI
IF C$ = "WEST" THEN GOTO dI
IF C$ = "EAST" THEN GOTO gI
GOTO HI
CI:
CLS : PRINT "you come into a small room. you notice a stairway going down."
INPUT "there is a door to the east."; D$
IF D$ = "STAIRWAY" THEN GOTO JI
IF D$ = "EAST" THEN GOTO BI
GOTO CI
EXIT SUB
BI:
CLS : PRINT "you walk into a spider web. It's ovious this way hasn't been used much."
INPUT "there are doors to the north and to the west."; e$
IF e$ = "NORTH" THEN GOTO HI
IF e$ = "WEST" THEN GOTO CI
GOTO BI
dI:
CLS : INPUT "you enter a room. there are doors to the north, west and east."; f$
IF f$ = "NORTH" THEN GOTO KI
IF f$ = "WEST" THEN GOTO xI
IF f$ = "EAST" THEN GOTO HI
GOTO dI
KI:
CLS : INPUT "you open the door and some bats fly out. there is a door to the SOUTH."; G$
IF G$ = "SOUTH" THEN GOTO dI
GOTO KI
xI:
CLS : INPUT "you walk into the red room. there are doors to the SOUTH and to the east."; H$
IF H$ = "SOUTH" THEN GOTO YI
IF H$ = "EAST" THEN GOTO dI
GOTO xI
YI: CLS : PRINT "you walk into the room but as you enter the door slams and locks"
PRINT "next the walls start coming together and squish you. you are dead press any key": DO: LOOP WHILE INKEY$ = "": EXIT SUB
PI:
CLS : PRINT "you walk in. you see a stairway going down."
INPUT "there is also a door leading to the west."; i$
IF i$ = "STAIRWAY" THEN GOTO RI
IF i$ = "WEST" THEN GOTO LI
GOTO PI
gI:
CLS : INPUT "you walk into a white room. there is a door to the west"; j$
IF j$ = "WEST" THEN GOTO HI
GOTO gI
LI:
CLS : PRINT "as you walk in you see a snake behind you! you actidentaly run into a wall."
PRINT "it makes a clunk sound. it's hollow you notice. you look for a secret door"
INPUT "and find one to the west, you open it. you could go in. there is a door to the east"; k$
IF k$ = "GO IN" THEN PRINT "you go in": SLEEP 4: CLS : PRINT "you pass through cobwebs": SLEEP 4: CLS : PRINT "you go around a bend now heading north": SLEEP 4: CLS : PRINT "you come to a door and you open it": GOTO WI
IF k$ = "EAST" THEN GOTO PI
GOTO LI
JI:
CLS : INPUT "you are on the lower level. there is a door to the SOUTH. you see stairs."; L$
IF L$ = "STAIRWAY" THEN GOTO CI
IF L$ = "SOUTH" THEN GOTO QI
GOTO JI
QI:
CLS : INPUT "you walk in. there are doors to the north and to the west"; m$
IF m$ = "NORTH" THEN GOTO JI
IF m$ = "WEST" THEN GOTO RI
GOTO QI
RI:
CLS : INPUT "you are on the lower level. there is a door to the east. you see stairs"; n$
IF n$ = "STAIRWAY" THEN GOTO PI
IF n$ = "EAST" THEN GOTO QI
GOTO RI
TI: CLS : PRINT "as soon as you open the door you are out of the game T H E  E N D !  press any key": SLEEP 0: EXIT SUB
GOTO TI
WI:
CLS : INPUT "you walk in from the south there is a door to the east"; k$
IF k$ = "go in" THEN PRINT "you go in": SLEEP 4: CLS : PRINT "you go around a bend now heading east": SLEEP 4: CLS : PRINT "you pass through cobwebs": SLEEP 4: CLS : PRINT "you come to a door and you open it": GOTO LI
IF k$ = "EAST" THEN GOTO TI
GOTO WI
END SUB

SUB GAMES
Z = 30
123 CLS
C = C + 1
X = 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "1)GUESS YOUR NUMBER"
PRINT "2)SPORTS QUESTIONS"
PRINT "3)TALK TO ALIENS"
PRINT "4)STEVE'S GAME"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN 179
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
        CASE "1"
        GOTO 52
        CASE "2"
        GOTO 76
        CASE "3"
        GOTO 118
        CASE "4"
        CALL game
        CASE CHR$(24)
        GOTO 172
        CASE CHR$(26)
        END
        CASE ELSE
        BEEP
        END SELECT
GOTO 123
52 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "PICK A NUMBER 1-63"
PRINT "THEN PRESS RETURN"
DO
LOOP WHILE INKEY$ = ""
a = 0: B = 0: C = 0: D = 0: e = 0: f = 0: G = 0
173 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "01 03 05 07 09 11 13 15"
PRINT
PRINT "17 19 21 23 25 27 29 31"
PRINT
PRINT "33 35 37 39 41 43 45 47"
PRINT
PRINT "49 51 53 55 57 59 61 63"
INPUT "IS YOUR NUMBER HERE N/Y"; a$
IF a$ = "Y" THEN a = 1: GOTO 174
IF a$ = "N" THEN 174
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
GOTO 173
174 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "02 03 06 07 10 11 14 15"
PRINT
PRINT "18 19 22 23 26 27 30 31"
PRINT
PRINT "34 35 38 39 42 43 46 47"
PRINT
PRINT "50 51 54 55 58 59 62 63"
INPUT "IS YOUR NUMBER HERE N/Y"; a$
IF a$ = "Y" THEN B = 2: GOTO 175
IF a$ = "N" THEN 175
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
GOTO 174
175 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "04 05 06 07 12 13 14 15"
PRINT
PRINT "20 21 22 23 28 29 30 31"
PRINT
PRINT "36 37 38 39 44 45 46 47"
PRINT
PRINT "52 53 54 55 60 61 62 63"
INPUT "IS YOUR NUMBER HERE N/Y"; a$
IF a$ = "Y" THEN C = 4: GOTO 176
IF a$ = "N" THEN 176
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
GOTO 175
176 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "08 09 10 11 12 13 14 15"
PRINT
PRINT "24 25 26 27 28 29 30 31"
PRINT
PRINT "40 41 42 43 44 45 46 47"
PRINT
PRINT "56 57 58 59 60 61 62 63"
INPUT "IS YOUR NUMBER HERE N/Y"; a$
IF a$ = "Y" THEN D = 8: GOTO 177
IF a$ = "N" THEN 177
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
GOTO 176
177 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "16 17 18 19 20 21 22 23"
PRINT
PRINT "24 25 26 27 28 29 30 31"
PRINT
PRINT "48 49 50 51 52 53 54 55"
PRINT
PRINT "56 57 58 59 60 61 62 63"
INPUT "IS YOUR NUMBER HERE N/Y"; a$
IF a$ = "Y" THEN e = 16: GOTO 178
IF a$ = "N" THEN 178
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
GOTO 177
178 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "32 33 34 35 36 37 38 39"
PRINT
PRINT "40 41 42 43 44 45 46 47"
PRINT
PRINT "48 49 50 51 52 53 54 55"
PRINT
PRINT "56 57 58 59 60 61 62 63"
INPUT "IS YOUR NUMBER HERE N/Y"; a$
IF a$ = "Y" THEN f = 32: GOTO 183
IF a$ = "N" THEN 183
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
GOTO 178
183 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT "YOUR NUMBER IS"
G = a + B + C + D + e + f
IF G = 0 THEN PRINT "YOU DID SOME THING ROUNG": SLEEP 5: GOTO 52
SLEEP 5
PRINT G
53 INPUT "AM I RIGHT N/Y"; a$
IF a$ = CHR$(24) THEN 123
IF a$ = CHR$(26) THEN END
IF a$ = "Y" THEN PRINT " GOOD": SLEEP 5: GOTO 52
IF a$ = "N" THEN PRINT "THAT CANT BE?!!": SLEEP 1: GOTO 52
GOTO 53
76 CLS
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(35); "G A M E S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
 INPUT "HOW MANY QUESTIONS DO YOU WANT TO BE ASKED(1-36)"; a
 IF a < 0 THEN 76
 DIM n$(36), m$(36), f$(2)
 CLS
 FOR X = 1 TO 36
 n$(X) = ""
 NEXT X
 FOR B = 1 TO a
 FOR q = 1 TO 50: NEXT q
131
 C = INT(RND(1) * 36) + 1
 IF n$(C) = "X" THEN 131
 IF C = 1 THEN GOSUB 77
 IF C = 2 THEN GOSUB 78
 IF C = 3 THEN GOSUB 79
 IF C = 4 THEN GOSUB 80
 IF C = 5 THEN GOSUB 81
 IF C = 6 THEN GOSUB 82
 IF C = 7 THEN GOSUB 83
 IF C = 8 THEN GOSUB 84
 IF C = 9 THEN GOSUB 85
 IF C = 10 THEN GOSUB 86
 IF C = 11 THEN GOSUB 87
 IF C = 12 THEN GOSUB 88
 IF C = 13 THEN GOSUB 89
 IF C = 14 THEN GOSUB 90
 IF C = 15 THEN GOSUB 91
 IF C = 16 THEN GOSUB 92
 IF C = 17 THEN GOSUB 93
 IF C = 18 THEN GOSUB 94
 IF C = 19 THEN GOSUB 95
 IF C = 20 THEN GOSUB 96
 IF C = 21 THEN GOSUB 97
 IF C = 22 THEN GOSUB 98
 IF C = 23 THEN GOSUB 99
 IF C = 24 THEN GOSUB 100
 IF C = 25 THEN GOSUB 101
 IF C = 26 THEN GOSUB 102
 IF C = 27 THEN GOSUB 103
 IF C = 28 THEN GOSUB 104
 IF C = 29 THEN GOSUB 105
 IF C = 30 THEN GOSUB 106
 IF C = 31 THEN GOSUB 107
 IF C = 32 THEN GOSUB 108
 IF C = 33 THEN GOSUB 109
 IF C = 34 THEN GOSUB 110
 IF C = 35 THEN GOSUB 111
 NEXT B
PRINT "YOUR SCORE WAS "; C; " OUT OF "; a
GOTO 123
77   CLS
Z$ = "DECTHALON"
PRINT "1)ATHLETES EARN POINTS DURING SEVERAL EVENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN RETURN
PRINT "2)THE POLE VAULT AND SHOT PUT ARE PART OF THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETES IN THIS SPORT MUST RUN, JUMP, THROW, AND VAULT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)IN THIS TRACK-AND-FIELD SPORT, ATHLETES MUST COMPLETE IN 10 EVENSTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$; ""
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
78   CLS
Z$ = "ICE HOCKEY"
PRINT "1)TWO TEAMS OF SIX PLAYERS PER TEAM COMPETE AGAIST EACH OTHER TO SCORE THE MOST POINTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS SPORT HAS CHECKING BUT IT IS NOT CHECKERS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)PLAYERS WHO BREAK THE RULES OF THIS GAME SPEND TIME IN THE PENALTY BOX."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)WANYNE GRETZKY HAS HIT THE PUCK PAST GOALIES MORE THAN 700 TIMES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$; ""
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
79   CLS
Z$ = "SWIMMING"
PRINT "1)EVENTS VARY IN DISTANCE, SUCH AS 100 METERS, 200 METER, AND 400 METER."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS SUMMER OLYMPIC SPORT HAS INDIVIDAUL AND RELAY EVENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHELETS STRENGHT AND BREATH CONTROL TO COMPETE."
INPUT "G TO GUESS RE ETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN RETURN
PRINT "BACK STORK, BREASTSTRK, BUTTERFLY, AND FREESTYLE ARE FOUR STYLES IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$; ""
n$(C) = "X": RETURN
80   CLS
Z$ = "TENNIS"
PRINT "1)YEARS AGO, OMLY WHITE PLAYING CLOTHERS WERE ALLOWED."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)A SCORE OF ZERO IF CALLED LOVE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THIS GAME CAN BE PLAYED ON GRASS OR CLAY CORTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)IN COMPETITION, PLAYERS MUST WIN GAME, SET, AND MACH."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$; ""
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
81   CLS
Z$ = "GOLF"
PRINT "1)CONTESTANTS PLAY ON A GRASS CORSE OR FIELD."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)PLAYERS MUST JUGDE DISTANCE AND AIM CAREFULLY"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)BIRDIES, BOGEYS, AND PAR ARE POSSIBLE SCORES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)CLUBS WITH WOODEN OR METAL HEADS ARE USED TO HIT A BALL."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
82   CLS
Z$ = "RACEQUETBALL"
PRINT "1)IN THIS GAME, SINGLES OR TEAMS MUST SCORE 21 POINTS TO WIN."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)LOSING A SERVE IS CALLED SIDE OUT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)POEPLE PLAY THIS SPORT WITHIN A WALLED COURT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THIS GAME IS SIMILAR TO HAND-BALL, BUT IS PLAYED WITH A SMALL RACQUET."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
83   CLS
Z$ = "FEIL HOCKEY"
PRINT "1)THIS GAME STARTS WITH A BULLY IN THE CENTER OF THE FEILD."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)IN THIS SPORT, THERE ARE 11 PLAYERS ON A TEAM."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)PLAYERS MAY NOT  SHEILED THE BALL OR PROTECT THE BALL DURING PLAY.'"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)PLAYERS COMPETE WITH HOOKED STIKS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
84   CLS
Z$ = "SOFTBALL"
PRINT "1)IN THIS GAME PLAYERS ATTEMPT TO SCORE RUNS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)TEAMS PLAY SEVEN ININGS IN THIS GAME."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THIS GAME CAN BE PLAYED TWO WAYS: SLOW PITCH AND FAST PITCH."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)IN THIS SPORT,THE BALL IS PUT INTO PLAY WITH AN UNDER HAND THROW."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
85   CLS
Z$ = "JUDO"
PRINT "1)TWO ATHLETES WHEAR WHITE UNIFORMS DURING A MACH."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)CONTESTANTS BOW BEFORE SARTING A MACH."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETES USE ONLY THEIR BODIES TO THROW OPPONENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)EXPERT COMPETITORS WAER BLAK BELTS IN THIS SPORT, WICH WAS CREATED IN JAPAN IN 1882."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
86   CLS
Z$ = "WRESTLING"
PRINT "1)THIS SPORT DIVIDES COMPETITORS INTO WEIGHT CATEGORIES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)IN THIS SPORT, A PIN IS A SCORE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)IN THIS ANCIENT SPORT, TWO ATHLETES GRIP EACH OTHER."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)GRCO-ROMAN IS THE STYLE USED IN THE OLYMPIC GAMES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
87   CLS
Z$ = "GYMNASICSTICS"
PRINT "1)THIS IS ONE OF THE MOST POPULAR OLYMPIC SPECTATOR SPORTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)ATHLETES COMPETE ON TEAMS AND AS SINGLES CONTESTANTS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)IN THIS SPORT, FLEXIBILITY AND STRENGTH ARE NESSARY."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)TWO EVENTS IN THIS SPORT ARE VAULT AND PARALLEL BARS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
88   CLS
Z$ = "ROWING"
PRINT "1)TEAMS IN THIS SPORT CONSTIST OF TWO,FOUR,OR EIGHT MEMBERS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)A COXSWAIN CAN GUIDE THE TEAM AND STEER THE BOAT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)RACING MEETS IN THIS SPORT ARE CALLED REGATTAS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THIS SPORT USES LONG, NARROW BOATS CALLED SHELLS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
89   CLS
Z$ = "VOLLEYBALL"
PRINT "1)IN AMATEUTR PLAY, SIX PLAYERS ARE ON A TEAM."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)IN SOME PROFESSIONAL EVENTS, TWO-PLAYER TEAMS COMPETE ON SANDY BEACHES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)A SPIKE IS A SPECIAL HAND MOTION"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THIS SPORT FEATURES A NET AT LEAST SEVEN FEET HIGHT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
90   CLS
Z$ = "CAR RACING"
PRINT "1)SPEED AND SAFTY ARE MOST IMPORTANT IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)STOCK, DRAG, FORMULA, AND GRAND PRIX ARE ALL DIFFERENT EVENTS IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)A.J. FOYT IS A FAMOUS COMPETITOR."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THE INDIANAPOLIS 500 IS A WORLD-FAMOUS ANNUAL CONTEST IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
91   CLS
Z$ = "BOBSLEDING"
PRINT "1)THIS SPORT IS OPEN TO TWO-PERSON AND FOUR PERSON-TEAMS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS IS A WINTER OLYMPIC DOWNHILL EVENT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)EACH TEAM IN THIS SPORT HAS A BRAKEMAN."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)TEAMS RACE DOWN A TRACK CALLED A CHUTE"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
92   CLS
Z$ = "BOXING"
PRINT "1)ONLY TWO CONTESTANTS COMPETE DURING THESE EVENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THE COMPETITION IS DIVIDED INTO ROUNDS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETES WEAR GLOVES AROUND THIER HANDS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)AN ATHLETTE IN THIS SPORT MAY WIN BY A KNOK OUT PUNCH"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
93   CLS
Z$ = "SKIING"
PRINT "1)ATHLETES RACE AGAINST TIME IN THESE SNOWY EVENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS WINTER SPORT BEGAN IN NORTHERN EUROPE AND ASIA"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)DONWHILL, SLAMOM, AND CROSSCUNTRY ARE OLYMPIC EVENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)COMPETITORS WEAR EQUIPMENT ON THIER FEET."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
94   CLS
Z$ = "BASEBALL"
PRINT "1)ORIGINALY CALLED THE 'ENGLISH ROUNDERS,' THIS SPORT DEVLOPED ITS CURRENT FORM IM THE US."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)TWENTY-SIX MAJOR-LEAGUE TEAMS PLAY THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)TWO PLAYERS EARN THE CY YOUNG AWARD EVERY SEASON."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)PLAYERS HOPE TO HIT HOMERUNS IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
95   CLS
Z$ = "BOWLING"
PRINT "1)PLAYERS MAY PLAY THIS GAME ONE-ON-ONE OR IN TEAMS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THE PLAYING AREA IS CALLED A LANE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)A PERFACT SCORE IS 300."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THE TARGETS IN THIS GAME ARE CALLED PINS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
96   CLS
Z$ = "FIGURE SKATING"
PRINT "1)CONTESTANTS MUST PERFORM REQUIRED MOTIONS IN EACH ROUND."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS SPORT FEATURES PAIRS AND SINGLES EVENS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETES REFER TO THIER EQUIMPMENT AS BALDS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)ATHLETES PERFORM THIS SPORT ON ICE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
97   CLS
Z$ = "HURDLES"
PRINT "1)THIS SPORT IS A TRADITIONAL OLYMPIC EVENT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)IN THIS SPORT, ATHLETES COMPETE IN HEATS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)CONTESTANTS MUST RUN AND JUMP DURRING THIS TRACK EVENT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)JUMPING OVER A BARRIER GIVES THIS SPORT ITS NAME."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
98   CLS
Z$ = "TRIATHLON"
PRINT "1)THIS COMPETITION STARDED IN HAWAII IN 1978"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)ENDUR IS INPORTANT IN THIS SPORT"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THIS SPORT TEST ALL MAJOR MUSCLE OF THE BODY"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)ATHLETES SWIM, CYCLE, AND RUN IN THIS EXCITING SPORT"
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
99   CLS
Z$ = "EQUESTRIAN COMPETITION"
PRINT "1)CONTESTANTS MUST TRAIN AND COMPETE IN DRESSAGE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)CONTESTANTS MUST JUMP CLEANLY, TURN, WELL, AND GO FAST"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ONE OF THE MOST DIFFICULT EVENTS IS TIMED CROSS COMPETE"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)CONTESTANTS RIDE HORES TO COMPETE"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
100
Z$ = "SURFING"
PRINT "1)THIS WATER SPORT REQUIRES BALANCE AND GOOD TIMING"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)CONTESTANTS EARN POINTS FOR FORM AND THE LENGHT OF THEIR RIDES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETES TRY TO RIDE THE CURL DURRING THIS COMPETION"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)CONTESTANTS STAND ON FIBERGLASS BOARDS IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
101   CLS
Z$ = "BASKETBALL"
PRINT "1)THIS GAME WAS INVENTED IN THE US IN 1891."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)IN THIS SPORRT THERE ARE FIVE PLAYERS ON EACH TEAM"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THE PLAYER POSITION ARE GUARD,FORWARD, AND CENTER."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)PLAYER DRIBBLE, PASS, AND SHOOT DURING THIS GAME"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
102   CLS
Z$ = "FENCING"
PRINT "1)IN THIS SPORT, A TOUCH IS HOW A PLAYER SCORES"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THE THREE WEAPONS IN THIS SPORT ARE FOIL, "; CHR$(138); "P"; CHR$(138); "E AND SABER"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)PLAYERS BEGING COMPETING WITH THE COMAND 'ON GARD!'"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)SWORDS ARE USED IN THIS SPORT"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
103   CLS
Z$ = "SKI JUKMPING"
PRINT "1)THIS IS A WINTER SPORT AND A POPULAR OLYMPIC SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)ATHLETES PERFORM SEVERAL TIMES TO GET A TOTAL SCORE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THE CONTESTANTS ARE JUGED ON DISTANCE, BALANCE,  AND FORM"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)IN THIS SPORT THE ATHLETE IS AIRBORN FORM 3 TO 10 SECONDS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
104   CLS
Z$ = "WEITGHT LIFTING"
PRINT "1)THIS OLYMPIC SPORT PISTS ATHLETES AGAINST AECH OTHER IN A CONTEST OF STRENGHT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS EVENT HAS TWO JUBGES AND ONE REFEREE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THREE EVENTS ARE PRESS, THE SNACH, AND THE CLEAR-AND-JERK"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THE ATHLETE WHO CAN LIFT THE HEAVEST AMOUNT WINS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
105   CLS
Z$ = "LACROSSE"
PRINT "1)THE PLAYING FEILED FOR THIS SPORT IS 60 TO 70 YARDS WIDE AND 110 YARDS LONG."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THIS SPORT WAS INVENTED CENTUREIS AGO BY CANADIAN INDIANS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)PLAYERS TRY TO THROW A RUBBER BALL INTO A NET USING STIKS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)TEN PLAYERS ON A TEAM EACH CARRY STICK WITH A POKET-LIKE HEAD CALLED THE CROSSE"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
106
CLS
Z$ = "CYCLING"
PRINT "1)IN THIS SPORT, ATHLETES MAY USE SLIPSTREAMING."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)A FAMOUS RACE IS THE TOIUR BE FRANCE, A 21-DAY AVENT SPANNING 2,500 MILES(4,00KM)THROUGHT SIX EUROPEAN CONTRIES."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)THIS SPORT HAS CROSS-CONTRY AND SPRINT EVENTS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)ATHLETES RIDE TWO-WEELED VEHICLES IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
107   CLS
Z$ = "SOCCER"
PRINT "1)THIS IS PROBABLY THE MOST POPULAR TEAM SPORT IN THE WORLD."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)THE WORLD CUP IS THE PRIZE AWARDED TO THE BEST TEAM IN TIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)PEL"; CHR$(138); " OF BRAZIL WAS A WORLDFAMOUS PLAYER IN THIS GAME"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)IN THIS SPORT, ONLY THE GOALKEEPER MAY USE HANDS."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
108   CLS
Z$ = "DIVING"
PRINT "1)FORM AND DIFFICULTLTY ARE JUDGED DURING EACH ATHLETES TURN."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)'TUK', 'LAYOUT', AND 'PIKE' ARE POSITIONS IN THIS SPORT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETE OFTEN DO SOMERSAULTS DURING THIS EVENT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)ATHLETE PLUNGE INTO WATER DURING THIER TURNS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
109   CLS
Z$ = "FOOTBALL"
PRINT "1)AT A GIVEN MOMENT OF PLAY, ONE TEAM PLAYS OFFENCE AND THE OTHER PLAYS DEFENSE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)IN THIS SPORT, EACH TEAM HAS 11 PLAYERS ON THE FIELD."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)TEAMS CAN SCORE ONE, TWO, THREE, OR SIX POINTS AT A TIME."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)LINEBACKER IS THE NAME OF PLAYER POSITION"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
110   CLS
Z$ = "BADMINTON"
PRINT "1)THIS GAME WAS FIRST PLAYED IN INDIA, WHERE IT WAS KNOW AS POONA"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)ENGLISH MEN AND ENJOYED THIS SPORT IN THE 1800s."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)HITTING A SHUTTLECOCK IS THE OBJECT OF HTIS GAME."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THIS IS A RACQUET GAME WITH A NET, BUT IT'S NOT TENNIS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
111   CLS
Z$ = "SPEED SKATING"
PRINT "1)THIS WINTER SPORT HAS TIME TRAILS CALLED HEATS"
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "2)TWO COMPETITORS AT A TIME PARTICIPATE."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "3)ATHLETES RACE AS FAR AS 10,000 METER."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "4)THE ATHLETES WEAR SPECIAL FOOTWEAR DURING THIS EVENT."
INPUT "G TO GUESS RETURN TO CONTINUE"; a$
IF a$ = "G" THEN GOSUB 113
IF a$ = "G" THEN n$(C) = "X": RETURN
PRINT "THE ANSWER IS "; Z$
DO: LOOP WHILE INKEY$ = ""
n$(C) = "X": RETURN
113 INPUT "WHAT IS YOUR GUESS"; B$
IF B$ = Z$ THEN C = C + 1
IF B$ <> Z$ THEN PRINT "TOO BAD": DO: LOOP WHILE INKEY$ = ""
IF B$ = Z$ THEN PRINT "GOOD": DO: LOOP WHILE INKEY$ = ""
RETURN
118
SCREEN 0: CLS
RANDOMIZE TIMER
PRINT "PREPARE TO RECEIVE ALIEN TRANSMISSION"
FOR s = 200 TO 1200 STEP 10
SOUND s, 2
FOR i = 1 TO 50: NEXT i
NEXT s
114 CLS
B = INT(RND(1) * 80) + 1
GOSUB 116
LOCATE 12, 1
PRINT "WHAT IS YOUR REPLY"
INPUT R$
IF R$ = "BYE" THEN 115
GOTO 114
115 B = 5
GOSUB 116
LOCATE 17, 1: SLEEP 1: SCREEN 0: COLOR 1: GOTO 123
116 FOR a = 1000 TO 1000 + B
SOUND INT(RND * a) + 60, 2
R = INT(RND * 255 + 1)
LOCATE , , 0
PRINT CHR$(R);
FOR i = 1 TO 50: NEXT i
NEXT a
RETURN
179 CALL AUTO
GOTO 123
172
END SUB

SUB main
SCREEN 0
DO
X = 0
DO
X = 0
DO
X = X + 1
IF X > 30 THEN 129
B$ = INKEY$
SCREEN 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(25); "N E L S O N ' S   D E S K T O P"
COLOR 15, 1
PRINT "USER:  "; USERNAME$
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
PRINT TIME$, DATE$
PRINT "1)ENCODE"
PRINT "2)DECODE"
PRINT "3)SCREEN SAVERS"
PRINT "4)MUSIC"
PRINT "5)WRITER"
PRINT "6)CALCULATOR"
PRINT "7)GAMES"
PRINT "8)TIMER"
PRINT "9)DRAWINGS"
PRINT "F1)SET SCREEN SAVER"
PRINT "F2)SET CLOCK + DATE"
PRINT "PICK ONE"
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
        CASE CHR$(0) + "<"
        SHELL "SET2"
        CASE CHR$(0) + ";"
        CALL SAVER2
        CASE "2"
        CALL DECODE
        CASE "3"
        CALL saver
        CASE "4"
        SHELL "MUSIC"
        CASE "5"
        SHELL "WRITE"
        CASE "6"
        CALL CAL
        CASE "7"
        CALL GAMES
        CASE "8"
        SHELL "TIMER"
        CASE "9"
        CALL DAWINGS
        CASE CHR$(24)
        PRINT "GOOD BYE "; USERNAME$: END
        CASE CHR$(26)
        END
        CASE "1"
        CALL ENCODE
        CASE ELSE
        BEEP
        END SELECT
        SCREEN 0
        LOOP
129 CALL AUTO
LOOP
END SUB

SUB saver
Z = 30
142 CLS
SCREEN 0
COLOR 15, 1
CLS
COLOR 14, 1: PRINT TAB(25); "S C R E E N  S A V E R S"
PRINT
COLOR 0, 1: PRINT "--------------------------------------------------------------------------------": COLOR 15, 1
X = 0
Z = 30
PRINT "1)ASC"
PRINT "2)SQUARES AND CIRCLES"
PRINT "3)LINES"
PRINT "4)CIRCLES"
PRINT "5)CIRCLES MIDDLE"
PRINT "6)LINES.2"
PRINT "7)ASC.2"
PRINT "8)CIRCLES.2"
PRINT "9)LINES.3"
PRINT "A)EXPLOSINS"
PRINT "B)SQUARES"
PRINT "C)RAINING PAINT"
PRINT "D)SHAPES"
PRINT "E)WORD FLY"
PRINT "F)DISOLVE"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOTO 209
SLEEP 1
LOOP WHILE B$ = ""
SELECT CASE B$
        CASE CHR$(24)
        GOTO 210
        CASE CHR$(26)
        END
        CASE "1"
        GOTO 193
        CASE "2"
        GOTO 198
        CASE "3"
        GOTO 199
        CASE "4"
        GOTO 200
        CASE "5"
        GOTO 201
        CASE "6"
        GOTO 202
        CASE "7"
        GOTO 203
        CASE "8"
        GOTO 204
        CASE "9"
        GOTO 205
        CASE "A"
        GOTO explosions1
        CASE "B"
        GOTO squres1
        CASE "C"
        GOTO raining1
        CASE "D"
        GOTO shapes1
        CASE "E"
        GOTO fly1
        CASE "F"
        GOTO disolve1
        CASE ELSE
        BEEP
        END SELECT
        GOTO 142
193
DO
a = INT(RND(1) * 127) + 1
IF INKEY$ = CHR$(27) THEN 142
PRINT CHR$(a);
LOOP
198
SCREEN 12
a = INT(RND(1) * 640) + 1
B = INT(RND(1) * 640) + 1
C = INT(RND(1) * 640) + 1
D = INT(RND(1) * 640) + 1
e = INT(RND(1) * 15) + 1
f = INT(RND(1) * 50) + 1
G = INT(RND(1) * 640) + 1
H = INT(RND(1) * 640) + 1
j = INT(RND(1) * 640) + 1
s = INT(RND(1) * 640) + 1
k = INT(RND(1) * 640) + 1
L = INT(RND(1) * 640) + 1
m = INT(RND(1) * 640) + 1
n = INT(RND(1) * 640) + 1
O = INT(RND(1) * 640) + 1
p = INT(RND(1) * 640) + 1
q = INT(RND(1) * 640) + 1
R = INT(RND(1) * 640) + 1
COLOR e
LINE (a, B)-(C, D), , BF
LINE (G, H)-(s, j)
LINE (G, H)-(s, j), , B
LINE (O, p)-(q, R)
LINE (k, L)-(m, n), , B
IF INKEY$ = CHR$(27) THEN 142
CIRCLE (a, B), f
Triangle$ = "F60 L120 E60"
DRAW "C2 X" + VARPTR$(Triangle$)
GOTO 193
199 CLS
SCREEN 12
DO
C = INT(RND(1) * 15) + 1
COLOR C
a = INT(RND(1) * 1040) + 1
B = INT(RND(1) * 1040) + 1
LINE (320, 240)-(a, B)
IF INKEY$ = CHR$(27) THEN 142
LOOP
200 CLS
SCREEN 12
a = 0: B = 0: C = 0
DO
D = INT(RND(1) * 15) + 1
COLOR D
CIRCLE (a, B), C
a = a + 1
B = B + 1
C = C + 1
IF INKEY$ = CHR$(27) THEN 142
LOOP
201 CLS
SCREEN 12
C = 0
DO
D = INT(RND(1) * 15) + 1
COLOR D
CIRCLE (320, 240), C
C = C + 1
IF INKEY$ = CHR$(27) THEN 142
LOOP
202 SCREEN 12
C = 1
CLS
206 DO
a = INT(RND(1) * 15) + 1
COLOR a
D = D + 1
IF D > 500 THEN 207
B = INT(RND(1) * 1000) + 1
LINE (320, 240)-(B, D)
IF INKEY$ = CHR$(27) THEN 142
LOOP
207 DO
a = INT(RND(1) * 15) + 1
COLOR a
D = D - 1
IF D < 0 THEN 208
B = INT(RND(1) * 1000) + 1
LINE (320, 240)-(B, D)
IF INKEY$ = CHR$(27) THEN 142
LOOP
203
COLOR 0, 0
CLS
208
DO
a = INT(RND(1) * 127) + 1
IF a = 12 THEN 208
IF a = 11 THEN 208
B = INT(RND * 15)
COLOR B
PRINT CHR$(a);
IF INKEY$ = CHR$(27) THEN 142
LOOP
204 CLS
C = 0
SCREEN 1
FOR Z = .1 TO 1.1 STEP .0002
IF INKEY$ = CHR$(27) THEN 142
C = C + 1
CIRCLE (Z * 200, SIN(Z * 24) * (Z * 50) + 100), Z * 40, C
C = -C * (C < 15): NEXT Z
IF INKEY$ = CHR$(27) THEN 142
FOR Z = 1 TO 1000
IF INKEY$ = CHR$(27) THEN 142
C = C + 1
IF C > 6 THEN 204
PALETTE C, 0
PALETTE C, C
NEXT Z
GOTO 204
205 CLS
SCREEN 12
DO
a = INT(RND(1) * 15) + 1
G = INT(RND(1) * 640) + 1
H = INT(RND(1) * 640) + 1
j = INT(RND(1) * 640) + 1
s = INT(RND(1) * 640) + 1
COLOR a
LINE (G, H)-(j, s)
IF INKEY$ = CHR$(27) THEN 142
LOOP
disolve1:
SCREEN 12
     DIM Box%(1 TO 200)
deds1:
    Z = RND * 14 + 1
    x1% = 0: x2% = 1: y1% = 0: y2% = 1
    LINE (x1%, y1%)-(x2%, y2%), Z, BF
    GET (x1%, y1%)-(x2%, y2%), Box%
    xa = 1
    DO
    xa = xa + 1
        PUT (x1%, y1%), Box%, OR
        x1% = RND * 620
        y1% = RND * 460
        PUT (x1%, y1%), Box%
        IF xa = 7000 THEN CLS : GOTO deds1
        LOOP UNTIL INKEY$ = CHR$(27)
    GOTO 142
squres1:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 640
D = RND * 480
e = RND * 15 + 1
LINE (a, B)-(C, D), e, BF
LOOP UNTIL INKEY$ = CHR$(27)
GOTO 142
raining1:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 15 + 1
D = RND * 30
FOR X = 1 TO D
CIRCLE (a, B), (X), C
NEXT X
LOOP UNTIL INKEY$ = CHR$(27)
GOTO 142
shapes1:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 640
D = RND * 480
e = RND * 15 + 1
f = RND * 100
G = RND * 15 + 1
H = RND * 640
i = RND * 480
LINE (a, B)-(C, D), e, BF
CIRCLE (H, i), f, G
LOOP UNTIL INKEY$ = CHR$(27)
GOTO 142
explosions1:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
B = RND * 480
C = RND * 15 + 1
D = RND * 300
FOR X = 1 TO D
CIRCLE (a, B), (X), C
NEXT X
LOOP UNTIL INKEY$ = CHR$(27)
GOTO 142
fly1:
COLOR 0, 0
CLOSE
RANDOMIZE TIMER
CLS
OPEN "fly.slp" FOR INPUT AS #1
INPUT #1, bht$
G = LEN(bht$)
DO
CLS
FOR aple = 1 TO 80 - ged
ged = RND * 14 + 1
LOCATE 10, aple, 0
FOR slp = 1 TO 100: NEXT slp
COLOR ged
PRINT " "; bht$
NEXT aple
LOOP UNTIL INKEY$ = CHR$(27)
GOTO 142
209 CALL AUTO
GOTO 142
210
END SUB

SUB SAVER2
ST:
X = 0
Z = 30
CLOSE
    CLS
SCREEN 0
COLOR 14, 9: PRINT TAB(25); "S E T  S C R E E N  S A V E R"
COLOR 0, 9: PRINT "________________________________________________________________________________"
COLOR 15, 9
PRINT "1)ASC"
PRINT "2)SQUARES AND CIRCLES"
PRINT "3)LINES"
PRINT "4)CIRCLES"
PRINT "5)CIRCLES MIDDLE"
PRINT "6)LINES.2"
PRINT "7)ASC.2"
PRINT "8)CIRCLES.2"
PRINT "9)LINES.3"
PRINT "A)EXPLOSINS"
PRINT "B)SQUARES"
PRINT "C)RAINING PAINT"
PRINT "D)SHAPES"
PRINT "E)WORD FLY"
PRINT "F)DISOLVE"
PRINT "G)EDIT WORD FLY"
PRINT "PICK ONE"
DO
B$ = INKEY$
X = X + 1
IF X > Z THEN GOTO WT
SLEEP 1
LOOP WHILE B$ = ""
    IF B$ = "G" THEN GOSUB editw
    IF B$ = CHR$(24) THEN EXIT SUB
    OPEN "savers" FOR OUTPUT AS #1
    Rec1$ = B$
    WRITE #1, Rec1$
    CLOSE #1
    PRINT "SCREEN SAVER SET. PRESS ANY KEY"
    DO
    LOOP WHILE INKEY$ = ""
    GOTO ST
editw:
ploop:
    CLS
    OPEN "fly.slp" FOR INPUT AS #1
    PRINT "current statement:  ": PRINT
    DO WHILE NOT EOF(1)
        INPUT #1, Rec1$
        PRINT Rec1$
    LOOP
    CLOSE
    PRINT "-1)edit text"
    PRINT "-2)return"
    INPUT "which selection"; fgh
    IF fgh = 1 THEN GOSUB hjk
    IF fgh = 2 THEN RETURN
    GOTO ploop
hjk:
    OPEN "fly.slp" FOR OUTPUT AS #1
    INPUT "enter text to be used", kjl$
    WRITE #1, kjl$
    CLOSE
    RETURN
WT:
CALL AUTO
GOTO ST
END SUB

SUB Sparkle
COLOR 18
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
COLOR 15
PRINT "        This program has been brought to you by (C)1994 Steve Productions"
COLOR 18
PRINT "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
COLOR 4, 0
 
  COLOR 4, 0
  a$ = "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    "
  WHILE INKEY$ = ""
FOR a = 1 TO 5
      LOCATE 1, 1
      PRINT MID$(a$, a, 80);
      LOCATE 22, 1
      PRINT MID$(a$, 6 - a, 80);

      FOR B = 2 TO 21
        C = (a + B) MOD 5
        IF C = 1 THEN
          LOCATE B, 80
          PRINT "*";
          LOCATE 23 - B, 1
          PRINT "*";
        ELSE
          LOCATE B, 80
          PRINT " ";
          LOCATE 23 - B, 1
          PRINT " ";
        END IF
      NEXT B
    NEXT a
  WEND

END SUB

