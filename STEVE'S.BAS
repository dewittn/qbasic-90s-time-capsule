
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
DECLARE SUB game ()
DECLARE SUB encoder ()
DECLARE SUB main ()
DECLARE SUB main2 ()
DECLARE SUB decoder ()
DECLARE SUB picture ()
DECLARE SUB music ()
DECLARE SUB timex ()
DECLARE SUB grade ()
DECLARE SUB fibanoch ()
DECLARE SUB math ()
DECLARE SUB screens ()
DECLARE SUB bloop ()
DECLARE SUB saver ()


CALL main2

SUB bloop
    CLOSE
    CLS
    PRINT "-1)edit"
    PRINT "-2)view text"
    INPUT "enter selection"; s$
    OPEN "LIST" FOR BINARY AS #1
    IF s$ = "1" THEN CLOSE : GOTO bloop
    IF LOF(1) = 0 THEN CLOSE : GOTO forx
    IF s$ = "2" THEN GOTO guy
    CALL bloop
guy:
    DO
     LOOP WHILE UCASE$(R$) = "Y"
    CLOSE #1
    'Echo the file back.
    OPEN "LIST" FOR INPUT AS #1
    CLS
    PRINT "Entries in file:": PRINT
    DO WHILE NOT EOF(1)
        LINE INPUT #1, REC$  'Read entries from the file.
        PRINT REC$           'Print the entries on the screen.
    LOOP
    CLOSE #1
    SLEEP 0
    CALL main
forx:
    OPEN "list" FOR OUTPUT AS #1
    INPUT ; a$
    WRITE #1, a$
    CLOSE
    CALL main
bloop:
    OPEN "list" FOR INPUT AS #1
    CLS
    PRINT "Entries in file:": PRINT
    DO WHILE NOT EOF(1)
        LINE INPUT #1, REC$  'Read entries from the file.
        PRINT REC$           'Print the entries on the screen.
    LOOP
    CLOSE
    OPEN "list" FOR OUTPUT AS #1
    INPUT ; d$
    WRITE #1, d$
    CLOSE #1
    SLEEP 0
    CALL main
END SUB

SUB decoder
19  CLS
    COLOR 14, 9: PRINT TAB(25); "T H E  D E C O D E R"
    COLOR 0, 9: PRINT "________________________________________________________________________________"
    COLOR 14, 9: PRINT TAB(21); "this program can decode these codes:": COLOR 15, 9
    PRINT ""
    PRINT "-1)z code 16"
    PRINT "-2)morse"
    PRINT "press Ctrl+X to exit decoder"
    PRINT ""
    COLOR 7, 9: INPUT "--which selection"; ts$: COLOR 15, 9
    IF ts$ = "1" THEN GOTO 21
    IF ts$ = "2" THEN GOTO 18
    IF ts$ = CHR$(24) THEN CALL main
    GOTO 19

21 CLS
DO
COLOR 7, 9: INPUT "enter higher number"; a%
    INPUT "enter lower number"; b%: COLOR 15, 9
    c = a% - b%
    IF c = 1 THEN PRINT "a"
    IF c = 2 THEN PRINT "b"
    IF c = 3 THEN PRINT "c"
    IF c = 4 THEN PRINT "d"
    IF c = 5 THEN PRINT "e"
    IF c = 6 THEN PRINT "f"
    IF c = 7 THEN PRINT "g"
    IF c = 8 THEN PRINT "h"
    IF c = 9 THEN PRINT "i"
    IF c = 10 THEN PRINT "j"
    IF c = 11 THEN PRINT "k"
    IF c = 12 THEN PRINT "l"
    IF c = 13 THEN PRINT "m"
    IF c = 14 THEN PRINT "n"
    IF c = 15 THEN PRINT "o"
    IF c = 16 THEN PRINT "p"
    IF c = 17 THEN PRINT "q"
    IF c = 18 THEN PRINT "r"
    IF c = 19 THEN PRINT "s"
    IF c = 20 THEN PRINT "t"
    IF c = 21 THEN PRINT "u"
    IF c = 22 THEN PRINT "v"
    IF c = 23 THEN PRINT "w"
    IF c = 24 THEN PRINT "x"
    IF c = 25 THEN PRINT "y"
    IF c = 26 THEN PRINT "z"
    IF c = 0 THEN GOTO 19
    LOOP
18 CLS
DO
COLOR 7, 9: INPUT "enter code"; ax$
        COLOR 15, 9
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
    IF ax$ = "" THEN CLS : GOTO 18
    IF ax$ = "end" THEN GOTO 19
    LOOP
END SUB

SUB encoder
2   CLS
    SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(25); "T H E  E N C O D E R": COLOR 0, 9
    PRINT "________________________________________________________________________________"
    COLOR 15, 9
    PRINT "-1)z code 16"
    PRINT "-2)letter"
    PRINT "-3)morse"
    PRINT "-4)number"
    PRINT "-5)binary"
    PRINT "-6)mixed math"
    PRINT "-7)any"
    PRINT "press Ctrl+X to exit encoder"
    PRINT ""
    COLOR 7, 9: INPUT "--which selection"; cd$: COLOR 15, 9
    IF cd$ = "1" THEN GOTO 1
    IF cd$ = "2" THEN GOTO 100
    IF cd$ = "3" THEN GOTO 10
    IF cd$ = "4" THEN GOTO 300
    IF cd$ = "5" THEN GOTO 400
    IF cd$ = "6" THEN GOTO 76
    IF cd$ = "7" THEN GOTO 500
    IF cd$ = CHR$(24) THEN CALL main
    IF cd$ = CHR$(19) THEN CALL screens
    GOTO 2
1   CLS
    SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(28); "Z  C O D E  1 6": COLOR 0, 9
    PRINT "________________________________________________________________________________": COLOR 15, 9
20  INPUT " enter letter to be encoded"; c$
    IF c$ = "end" THEN GOTO 2
    IF c$ = "exit" THEN GOTO 2
    IF c$ = CHR$(24) THEN GOTO 2
    IF c$ = "" THEN CLS : GOTO 20
    IF c$ = CHR$(19) THEN CALL screens
    RANDOMIZE TIMER
    op = INT(999 * RND(1) + 1)
    PRINT op
    IF c$ = "a" THEN PRINT op + 1
    IF c$ = "b" THEN PRINT op + 2
    IF c$ = "c" THEN PRINT op + 3
    IF c$ = "d" THEN PRINT op + 4
    IF c$ = "e" THEN PRINT op + 5
    IF c$ = "f" THEN PRINT op + 6
    IF c$ = "g" THEN PRINT op + 7
    IF c$ = "h" THEN PRINT op + 8
    IF c$ = "i" THEN PRINT op + 9
    IF c$ = "j" THEN PRINT op + 10
    IF c$ = "k" THEN PRINT op + 11
    IF c$ = "l" THEN PRINT op + 12
    IF c$ = "m" THEN PRINT op + 13
    IF c$ = "n" THEN PRINT op + 14
    IF c$ = "o" THEN PRINT op + 15
    IF c$ = "p" THEN PRINT op + 16
    IF c$ = "q" THEN PRINT op + 17
    IF c$ = "r" THEN PRINT op + 18
    IF c$ = "s" THEN PRINT op + 19
    IF c$ = "t" THEN PRINT op + 20
    IF c$ = "u" THEN PRINT op + 21
    IF c$ = "v" THEN PRINT op + 22
    IF c$ = "w" THEN PRINT op + 23
    IF c$ = "x" THEN PRINT op + 24
    IF c$ = "y" THEN PRINT op + 25
    IF c$ = "z" THEN PRINT op + 26
    GOTO 20
100 CLS
    SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(28); "L E T T E R  C O D E": COLOR 0, 9
    PRINT "________________________________________________________________________________": COLOR 15, 9
120 INPUT " enter letter to be encoded"; hi$
    IF hi$ = "" THEN CLS
    IF hi$ = CHR$(24) THEN GOTO 2
    IF hi$ = CHR$(19) THEN CALL screens
50  RANDOMIZE TIMER
    mn = INT(26 * RND(1) + 1)
    IF mn = 1 THEN GOTO 50
    IF mn = 2 THEN mn$ = "b"
    IF mn = 3 THEN mn$ = "c"
    IF mn = 4 THEN mn$ = "d"
    IF mn = 5 THEN GOTO 50
    IF mn = 6 THEN mn$ = "f"
    IF mn = 7 THEN mn$ = "g"
    IF mn = 8 THEN mn$ = "h"
    IF mn = 9 THEN GOTO 50
    IF mn = 10 THEN mn$ = "j"
    IF mn = 11 THEN mn$ = "k"
    IF mn = 12 THEN mn$ = "l"
    IF mn = 13 THEN mn$ = "m"
    IF mn = 14 THEN mn$ = "n"
    IF mn = 15 THEN GOTO 50
    IF mn = 16 THEN mn$ = "p"
    IF mn = 17 THEN mn$ = "q"
    IF mn = 18 THEN mn$ = "r"
    IF mn = 19 THEN mn$ = "s"
    IF mn = 20 THEN mn$ = "t"
    IF mn = 21 THEN GOTO 50
    IF mn = 22 THEN mn$ = "v"
    IF mn = 23 THEN mn$ = "w"
    IF mn = 24 THEN mn$ = "x"
    IF mn = 25 THEN mn$ = "y"
    IF mn = 26 THEN mn$ = "z"
    RANDOMIZE TIMER
    mc = INT(5 * RND(1) + 1)
    IF mc = 1 THEN mc$ = "a"
    IF mc = 2 THEN mc$ = "e"
    IF mc = 3 THEN mc$ = "i"
    IF mc = 4 THEN mc$ = "o"
    IF mc = 5 THEN mc$ = "u"
    IF hi$ = "a" THEN PRINT mc$; mn$
    IF hi$ = "b" THEN PRINT mn$; mc$; mc$; mc$
    IF hi$ = "c" THEN PRINT mn$; mc$; mn$; mc$
    IF hi$ = "d" THEN PRINT mn$; mc$; mc$
    IF hi$ = "e" THEN PRINT mc$
    IF hi$ = "f" THEN PRINT mc$; mc$; mn$; mc$
    IF hi$ = "g" THEN PRINT mn$; mn$; mc$
    IF hi$ = "h" THEN PRINT mc$; mc$; mc$; mc$
    IF hi$ = "i" THEN PRINT mc$; mc$
    IF hi$ = "j" THEN PRINT mc$; mn$; mn$; mn$
    IF hi$ = "k" THEN PRINT mn$; mc$; mn$
    IF hi$ = "l" THEN PRINT mc$; mn$; mc$; mc$
    IF hi$ = "m" THEN PRINT mn$; mn$
    IF hi$ = "n" THEN PRINT mn$; mc$
    IF hi$ = "o" THEN PRINT mn$; mn$; mn$
    IF hi$ = "p" THEN PRINT mc$; mn$; mn$; mc$
    IF hi$ = "q" THEN PRINT mn$; mn$; mc$; mn$
    IF hi$ = "r" THEN PRINT mc$; mn$; mc$
    IF hi$ = "s" THEN PRINT mc$; mc$; mc$
    IF hi$ = "t" THEN PRINT mn$
    IF hi$ = "u" THEN PRINT mc$; mc$; mn$
    IF hi$ = "v" THEN PRINT mc$; mc$; mn$
    IF hi$ = "w" THEN PRINT mc$; mn$; mn$
    IF hi$ = "x" THEN PRINT mn$; mc$; mc$; mn$
    IF hi$ = "y" THEN PRINT mn$; mc$; mn$; mn$
    IF hi$ = "z" THEN PRINT mn$; mn$; mc$; mc$
    GOTO 120
10  CLS
    SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(28); "M O R S E  C O D E": COLOR 0, 9
    PRINT "________________________________________________________________________________": COLOR 15, 9
60  INPUT " enter letter to be encoded"; ac$
    IF ac$ = "" THEN CLS
    IF ac$ = "end" THEN GOTO 2
    IF ac$ = "exit" THEN GOTO 2
    IF ac$ = CHR$(24) THEN GOTO 2
    IF ac$ = CHR$(19) THEN CALL screens
    a$ = "._"
    b$ = "_..."
    c$ = "_._."
    d$ = "_.."
    e$ = "."
    f$ = ".._."
    g$ = "__."
    h$ = "...."
    i$ = ".."
    j$ = ".___"
    k$ = "_._"
    l$ = "._.."
    m$ = "__"
    n$ = "_."
    o$ = "___"
    p$ = ".__."
    q$ = "__._"
    R$ = "._."
    s$ = "..."
    t$ = "_"
    u$ = ".._"
    v$ = "..._"
    w$ = ".__"
    x$ = "_.._"
    y$ = "_.__"
    z$ = "__.."
    IF ac$ = "a" THEN PRINT a$
    IF ac$ = "b" THEN PRINT b$
    IF ac$ = "c" THEN PRINT c$
    IF ac$ = "d" THEN PRINT d$
    IF ac$ = "e" THEN PRINT e$
    IF ac$ = "f" THEN PRINT f$
    IF ac$ = "g" THEN PRINT g$
    IF ac$ = "h" THEN PRINT h$
    IF ac$ = "i" THEN PRINT i$
    IF ac$ = "j" THEN PRINT j$
    IF ac$ = "k" THEN PRINT k$
    IF ac$ = "l" THEN PRINT l$
    IF ac$ = "m" THEN PRINT m$
    IF ac$ = "n" THEN PRINT n$
    IF ac$ = "o" THEN PRINT o$
    IF ac$ = "p" THEN PRINT p$
    IF ac$ = "q" THEN PRINT q$
    IF ac$ = "r" THEN PRINT R$
    IF ac$ = "s" THEN PRINT s$
    IF ac$ = "t" THEN PRINT t$
    IF ac$ = "u" THEN PRINT u$
    IF ac$ = "v" THEN PRINT v$
    IF ac$ = "w" THEN PRINT w$
    IF ac$ = "x" THEN PRINT x$
    IF ac$ = "y" THEN PRINT y$
    IF ac$ = "z" THEN PRINT z$
    GOTO 60
300 CLS
    SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(28); "N U M B E R  C O D E": COLOR 0, 9
    PRINT "________________________________________________________________________________": COLOR 15, 9
200 INPUT " enter letter to be encoded"; c$
    IF c$ = "" THEN CLS
    IF c$ = "end" THEN GOTO 2
    IF c$ = "exit" THEN GOTO 2
    IF c$ = CHR$(24) THEN GOTO 2
    IF c$ = CHR$(19) THEN CALL screens
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
    g = 7
    h = 8
    i = 9
    j = 10
    k = 11
    l = 12
    m = 13
    n = 14
    o = 15
    p = 16
    q = 17
    R = 18
    s = 19
    t = 20
    u = 21
    v = 22
    w = 23
    x = 24
    y = 25
    z = 26
    IF c$ = "a" THEN PRINT a
    IF c$ = "b" THEN PRINT b
    IF c$ = "c" THEN PRINT c
    IF c$ = "d" THEN PRINT d
    IF c$ = "e" THEN PRINT e
    IF c$ = "f" THEN PRINT f
    IF c$ = "g" THEN PRINT g
    IF c$ = "h" THEN PRINT h
    IF c$ = "i" THEN PRINT i
    IF c$ = "j" THEN PRINT j
    IF c$ = "k" THEN PRINT k
    IF c$ = "l" THEN PRINT l
    IF c$ = "m" THEN PRINT m
    IF c$ = "n" THEN PRINT n
    IF c$ = "o" THEN PRINT o
    IF c$ = "p" THEN PRINT p
    IF c$ = "q" THEN PRINT q
    IF c$ = "r" THEN PRINT R
    IF c$ = "s" THEN PRINT s
    IF c$ = "t" THEN PRINT t
    IF c$ = "u" THEN PRINT u
    IF c$ = "v" THEN PRINT v
    IF c$ = "w" THEN PRINT w
    IF c$ = "x" THEN PRINT x
    IF c$ = "y" THEN PRINT y
    IF c$ = "z" THEN PRINT z
    GOTO 200
400 CLS
  SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(28); "B I N A R Y  C O D E": COLOR 0, 9
  PRINT "________________________________________________________________________________": COLOR 15, 9
4 INPUT " enter letter to be encoded"; xz$
IF xz$ = "" THEN CLS
IF xz$ = CHR$(24) THEN GOTO 2
IF xz$ = CHR$(19) THEN CALL screens
IF xz$ = "a" THEN PRINT "1"
IF xz$ = "b" THEN PRINT "10"
IF xz$ = "c" THEN PRINT "11"
IF xz$ = "d" THEN PRINT "100"
IF xz$ = "e" THEN PRINT "101"
IF xz$ = "f" THEN PRINT "110"
IF xz$ = "g" THEN PRINT "111"
IF xz$ = "h" THEN PRINT "1000"
IF xz$ = "i" THEN PRINT "1001"
IF xz$ = "j" THEN PRINT "1010"
IF xz$ = "k" THEN PRINT "1011"
IF xz$ = "l" THEN PRINT "1100"
IF xz$ = "m" THEN PRINT "1101"
IF xz$ = "n" THEN PRINT "1110"
IF xz$ = "o" THEN PRINT "1111"
IF xz$ = "p" THEN PRINT "10000"
IF xz$ = "q" THEN PRINT "10001"
IF xz$ = "r" THEN PRINT "10010"
IF xz$ = "s" THEN PRINT "10011"
IF xz$ = "t" THEN PRINT "10100"
IF xz$ = "u" THEN PRINT "10101"
IF xz$ = "v" THEN PRINT "10110"
IF xz$ = "w" THEN PRINT "10111"
IF xz$ = "x" THEN PRINT "11000"
IF xz$ = "y" THEN PRINT "11001"
IF xz$ = "z" THEN PRINT "11010"
GOTO 4

76  CLS
    SCREEN 0: CLS : COLOR 14, 9: PRINT TAB(28); "M I X E D  U P  M A T H": COLOR 0, 9
    PRINT "________________________________________________________________________________": COLOR 15, 9
tophat:
    RANDOMIZE TIMER
    a = INT(RND * 99) + 1
    b = INT(RND * 99) + 1
    c = INT(RND * 4) + 1
    IF c = 1 THEN b$ = "+": d = a + b
    IF c = 2 THEN b$ = "*": d = a * b
    IF c = 3 THEN b$ = "-": d = a - b
    IF c = 4 THEN b$ = "/": d = a / b
    INPUT "enter letter to be encoded"; a$
    IF a$ = "" THEN CLS : GOTO tophat
    IF a$ = CHR$(24) THEN GOTO 2
    IF a$ = CHR$(19) THEN CALL screens
    IF a$ = "a" THEN PRINT a; b$; b; d + 1
    IF a$ = "b" THEN PRINT a; b$; b; d + 2
    IF a$ = "c" THEN PRINT a; b$; b; d + 3
    IF a$ = "d" THEN PRINT a; b$; b; d + 4
    IF a$ = "e" THEN PRINT a; b$; b; d + 5
    IF a$ = "f" THEN PRINT a; b$; b; d + 6
    IF a$ = "g" THEN PRINT a; b$; b; d + 7
    IF a$ = "h" THEN PRINT a; b$; b; d + 8
    IF a$ = "i" THEN PRINT a; b$; b; d + 9
    IF a$ = "j" THEN PRINT a; b$; b; d + 10
    IF a$ = "k" THEN PRINT a; b$; b; d + 11
    IF a$ = "l" THEN PRINT a; b$; b; d + 12
    IF a$ = "m" THEN PRINT a; b$; b; d + 13
    IF a$ = "n" THEN PRINT a; b$; b; d + 14
    IF a$ = "o" THEN PRINT a; b$; b; d + 15
    IF a$ = "p" THEN PRINT a; b$; b; d + 16
    IF a$ = "q" THEN PRINT a; b$; b; d + 17
    IF a$ = "r" THEN PRINT a; b$; b; d + 18
    IF a$ = "s" THEN PRINT a; b$; b; d + 19
    IF a$ = "t" THEN PRINT a; b$; b; d + 20
    IF a$ = "u" THEN PRINT a; b$; b; d + 21
    IF a$ = "v" THEN PRINT a; b$; b; d + 22
    IF a$ = "w" THEN PRINT a; b$; b; d + 23
    IF a$ = "x" THEN PRINT a; b$; b; d + 24
    IF a$ = "y" THEN PRINT a; b$; b; d + 25
    IF a$ = "z" THEN PRINT a; b$; b; d + 26
GOTO tophat


500 RANDOMIZE TIMER
    ef = INT(6 * RND(1) + 1)
    IF ef = 1 THEN GOTO 1
    IF ef = 2 THEN GOTO 100
    IF ef = 3 THEN GOTO 10
    IF ef = 4 THEN GOTO 300
    IF ef = 5 THEN GOTO 400
    IF ef = 6 THEN GOTO 76

END SUB

SUB game
CLS
SLEEP 1
musicb$ = "l16o3cfffeeeddefeccdddddddaaaao4cfffeeeddefeccdddddddaaaao3cfffeeeddefeccdddddddeeeeeeeedddddddddddddddd"
PLAY musicb$
COLOR 7, 8: CLS
33 CLS : INPUT "you are in a large room. there are passages to the south, east and west"; c$
IF c$ = "south" THEN GOTO 35
IF c$ = "west" THEN GOTO 32
IF c$ = "east" THEN GOTO 34
GOTO 33
END
41 CLS : PRINT "you come into a small room. you notice a stairway going down."
INPUT "there is a door to the east."; d$
IF d$ = "stairway" THEN GOTO 42
IF d$ = "east" THEN GOTO 35
GOTO 41
END
35 CLS : PRINT "you walk into a spider web. It's ovious this way hasn't been used much."
INPUT "there are doors to the north and to the west."; e$
IF e$ = "north" THEN GOTO 33
IF e$ = "west" THEN GOTO 41
GOTO 35
END
32 CLS : INPUT "you enter a room. there are doors to the north, west and east."; f$
IF f$ = "north" THEN GOTO 31
IF f$ = "west" THEN GOTO 30
IF f$ = "east" THEN GOTO 33
GOTO 32
END
31 CLS : INPUT "you open the door and some bats fly out. there is a door to the south."; g$
IF g$ = "south" THEN GOTO 32
GOTO 31
END
30 CLS : INPUT "you walk into the red room. there are doors to the south and to the east."; h$
IF h$ = "south" THEN GOTO 36
IF h$ = "east" THEN GOTO 32
GOTO 30
END
36 CLS : PRINT "you walk into the room but as you enter the door slams and locks"
PRINT "next the walls start coming together and squish you. you are dead press any key": SLEEP 0: CALL main
END
37 CLS : PRINT "you walk in. you see a stairway going down."
INPUT "there is also a door leading to the west."; i$
IF i$ = "stairway" THEN GOTO 44
IF i$ = "west" THEN GOTO 38
GOTO 37
END
34 CLS : INPUT "you walk into a white room. there is a door to the west"; j$
IF j$ = "west" THEN GOTO 33
GOTO 34
END
38 CLS : PRINT "as you walk in you see a snake behind you! you actidentaly run into a wall."
PRINT "it makes a clunk sound. it's hollow you notice. you look for a secret door"
INPUT "and find one to the west, you open it. you could go in. there is a door to the east"; k$
IF k$ = "go in" THEN PRINT "you go in": SLEEP 4: CLS : PRINT "you pass through cobwebs": SLEEP 4: CLS : PRINT "you go around a bend now heading north": SLEEP 4: CLS : PRINT "you come to a door and you open it": GOTO 39
IF k$ = "east" THEN GOTO 37
GOTO 38
END
42 CLS : INPUT "you are on the lower level. there is a door to the south. you see stairs."; l$
IF l$ = "stairway" THEN GOTO 41
IF l$ = "south" THEN GOTO 43
GOTO 42
END
43 CLS : INPUT "you walk in. there are doors to the north and to the west"; m$
IF m$ = "north" THEN GOTO 42
IF m$ = "west" THEN GOTO 44
GOTO 43
END
44 CLS : INPUT "you are on the lower level. there is a door to the east. you see stairs"; n$
IF n$ = "stairway" THEN GOTO 37
IF n$ = "east" THEN GOTO 43
GOTO 44
END
40 CLS : PRINT "as soon as you open the door you are out of the game T H E  E N D !  press any key": SLEEP 0: CALL main
GOTO 40
END
39 CLS : INPUT "you walk in from the south there is a door to the east"; k$
IF k$ = "go in" THEN PRINT "you go in": SLEEP 4: CLS : PRINT "you go around a bend now heading east": SLEEP 4: CLS : PRINT "you pass through cobwebs": SLEEP 4: CLS : PRINT "you come to a door and you open it": GOTO 38
IF k$ = "east" THEN GOTO 40
GOTO 39
END

END SUB

SUB grade
COLOR 15, 9: CLS
COLOR 14, 9: PRINT TAB(25); "G R A D E  F I N D E R": COLOR 0, 9
PRINT "________________________________________________________________________________": COLOR 15, 9
99 COLOR 15, 9: INPUT "--enter maxium grade number (press e to end)"; a
IF a = e THEN CALL main
INPUT "--enter grade from paper"; b
c = b / a
c = c * 100
PRINT TAB(3); c
COLOR 7, 9
IF c = 100 THEN COLOR 14, 9: PRINT TAB(3); "A+"
IF c < 100 AND c > 92 THEN PRINT TAB(3); "A"
IF c < 93 AND c > 89 THEN PRINT TAB(3); "A-"
IF c < 90 AND c > 86 THEN PRINT TAB(3); "B+"
IF c < 87 AND c > 82 THEN PRINT TAB(3); "B"
IF c < 83 AND c > 79 THEN PRINT TAB(3); "B-"
IF c < 80 AND c > 76 THEN PRINT TAB(3); "C+"
IF c < 77 AND c > 72 THEN PRINT TAB(3); "C"
IF c < 73 AND c > 69 THEN PRINT TAB(3); "C-"
IF c < 70 AND c > 66 THEN PRINT TAB(3); "D+"
IF c < 67 AND c > 62 THEN PRINT TAB(3); "D"
IF c < 63 AND c > 59 THEN PRINT TAB(3); "D-"
IF c < 60 THEN COLOR 4, 9: PRINT TAB(3); "F"
GOTO 99
END SUB

SUB main
SCREEN 0
COLOR 15, 9
CLS
COLOR 14, 9: PRINT TAB(25); "S T E V E' S  D E S K T O P"
COLOR 0, 9: PRINT "________________________________________________________________________________"
COLOR 15, 9
PRINT "-1)Steve's game"
PRINT "-2)picture"
PRINT "-3)encoder"
PRINT "-4)decoder"
PRINT "-5)music"
PRINT "-6)grader"
PRINT "-7)math"
PRINT "-8)timer"
PRINT "-9)write"
PRINT "-10)screen saver"
PRINT "press Ctrl+X to exit"
COLOR 7, 9: INPUT "--enter your selection"; b$: COLOR 15, 9
IF b$ = "1" THEN CALL game
IF b$ = "2" THEN CALL picture
IF b$ = "3" THEN CALL encoder
IF b$ = "4" THEN CALL decoder
IF b$ = "5" THEN CALL music
IF b$ = "6" THEN CALL grade
IF b$ = "7" THEN CALL math
IF b$ = "8" THEN CALL timex
IF b$ = "9" THEN CALL bloop
IF b$ = "10" THEN CALL saver
IF b$ = CHR$(24) THEN PRINT "good bye Steve!": END
IF b$ = CHR$(19) THEN CALL screens
CALL main
END SUB

SUB main2
CLS
PRINT "enter your name"
COLOR 0: INPUT "", a$
IF a$ <> "steveX" THEN SCREEN 1: GOTO endx
COLOR 15, 9: CALL main
endx:
 FOR i = 1 TO 40
 IF i = 40 THEN COLOR 4: PRINT a$; " get off my computer program!!!!": PRINT "": PRINT "": PRINT "": PRINT TAB(20); "now!!!": END
 FOR m = 1 TO 15
 COLOR m
 IF m = 15 THEN GOTO hine
 NEXT m
hine:
 NEXT i
 

END SUB

SUB math
CLS
  COLOR 14, 9: PRINT TAB(25); "M A T H E M A T I C S": COLOR 0, 9
  PRINT "________________________________________________________________________________"
  COLOR 15, 9
  PRINT "-1)fibanoch"
  PRINT "-2)metric convert"
  PRINT "press Ctrl+X to exit math"
  PRINT ""
  COLOR 7, 9: INPUT "--which selection"; a$: COLOR 15, 9
  IF a$ = "1" THEN GOTO 28
  IF a$ = "2" THEN GOTO top
  IF a$ = CHR$(24) THEN CALL main
  CALL math
28  CLS
  b = 1
  a = 1
  PRINT a: SLEEP 1
  PRINT b: SLEEP 1
27 c = a + b
  a = b
  b = c
  PRINT c
  IF c > 7.856933E+37 THEN PRINT "press any key to continue": SLEEP 0: CALL math
  SLEEP 1: GOTO 27
  END

top:
CLS
COLOR 14, 9: PRINT TAB(25); "C O N V E R T ": COLOR 0, 9
PRINT "________________________________________________________________________________": COLOR 15, 9
PRINT "-1)meter to yard"
PRINT "-2)yard to meter"
PRINT "-3)inch to centemeter"
PRINT "-4)centimeter to inch"
PRINT "press Ctrl+X to exit convert"
COLOR 7, 9: INPUT "--which selection"; a$
COLOR 15, 9
CLS
IF a$ = "1" THEN COLOR 14, 9: PRINT TAB(25); "C O N V E R T ": COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9: GOTO meter
IF a$ = "2" THEN COLOR 14, 9: PRINT TAB(25); "C O N V E R T ": COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9: GOTO yard
IF a$ = "3" THEN COLOR 14, 9: PRINT TAB(25); "C O N V E R T ": COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9: GOTO inch
IF a$ = "4" THEN COLOR 14, 9: PRINT TAB(25); "C O N V E R T ": COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9: GOTO cm
IF a$ = CHR$(24) THEN CALL math
GOTO top
meter:
INPUT "how many meters"; b
IF b = e THEN GOTO top
b = b * 1.0989015#
PRINT b; "yds."
GOTO meter
yard:
INPUT "how many yards"; c
IF c = e THEN GOTO top
c = c * .91
PRINT c; "meters"
GOTO yard
inch:
INPUT "how many inchs"; d
IF d = e THEN GOTO top
d = d * 2.54
PRINT d; "cm"
GOTO inch
cm:
INPUT "how many centimeters"; f
IF f = e THEN GOTO top
f = f * .39
PRINT f; "inchs"
GOTO cm


END SUB

SUB music
8 SCREEN 0: COLOR 15, 1: CLS
PRINT "-1)1812 overture"
PRINT "-2)A Whole New World"
PRINT "-3)stars and stripes forever"
PRINT "-4)pretty day"
PRINT "press Ctrl+X to exit music"
PRINT ""
COLOR 7, 9: INPUT "which music selection"; wed$: COLOR 15, 9
IF wed$ = "1" THEN GOTO 9
IF wed$ = "2" THEN GOTO 11
IF wed$ = "3" THEN GOTO 12
IF wed$ = "4" THEN GOTO musicx
IF wed$ = CHR$(24) THEN CALL main
GOTO 8
11 SCREEN 12
CARPET:
   CARPET$ = "BU200C1E25R50G25L50BR50BU10C7BL10E5F5BH5U10G3BE3F3E3D10G5BE5F5BH5BU10F3BH3U1R2U4L4D4R2BD1BG3BH3U1R2U4L4D4R2BD11BG5BD5"
    DRAW "C8BL300BD200U200R50D200BU150R43D150U286R47D286U189R39D189BR50U100R60D100C15BU200C8BR10BD10BD200U150R45D150" + CARPET$
    MUSICa$ =  _
"MLO4L4DL8CL4E-L8DO3B-L1FO4L4DL8CL4E-L8DO3L4B-O4L2DL2CP64L4CO3L8BO4L4DL8CP8O3L8AO4L4CO3B-AB-GL8AO4L4C.O3L8B-L1FO4L4DL8CL4E-L8DO3B-L1FO4L4DL8CL4E-L8DO3L4B-O4L2DL2CP64L4CO3L8BO4L4DL8CP8O3L8AO4L4CO3B-AB-GL8AO4L4C.O3L8B-O4L4D.P8L8DL4E-L8GL2FP2P8"
    PLAY MUSICa$
    GOTO 8

12 MUSICa$ = "MNL2CCO3L4B-AL2AMSL4G#AMNMSL1AL2MNL4G#AL2AL4G#AO4L2CO3L4AO4CO3L1B-L2G.L4GL2GL4F#GMSL1B-L2B-MNL4AGL2AO4L4CCL2D.L4DO3L1G"
PLAY MUSICa$
GOTO 8

9 MUSICa$ = "O3L10EDCDEDCDL5EL5CCO0CCO3L10CDEDCDL5EL5CCO0CCO3L10DEFEDEFEDEL5FO0CCO3L10CDEDCDL5ECC"
PLAY MUSICa$
GOTO 8
musicx:
PLAY "l6gedcdegedcdegegaeal2g"
GOTO 8
END SUB

SUB picture
5 CLS : SCREEN 0: COLOR 15, 1: CLS
PRINT "-1)hole"
PRINT "-2)circles"
PRINT "press Ctrl+X to exit picture"
COLOR 7, 9: INPUT "--which selection"; q$: COLOR 15, 9
IF q$ = "1" THEN GOTO 6
IF q$ = "2" THEN GOTO 7
IF q$ = CHR$(24) THEN CALL main
GOTO 5
6    CLS
    PRINT "press any key to start": SLEEP 0
    CLS
    SCREEN 12
   FOR i% = 1 TO 11 STEP 2
    FOR x = 1 TO 200
    IF x = 200 THEN PRINT "press any key to continue": SLEEP 0: GOTO 5
    a = INT(15 * RND(1) + 1)
    COLOR a
   
        WINDOW (-x / i%, -100 / i%)-(x / i%, 100 / i%)
        CIRCLE (0, 0), 10
        NEXT x
    NEXT i%
GOTO 5
7
     CLS
13    INPUT "What color do you want?(press Ctrl+X to end)"; a$
     SCREEN 12
     CLS
14   FOR x = 1 TO 400
     IF x = 399 THEN GOTO 13
     IF a$ = CHR$(24) THEN GOTO 5
     IF a$ = "blue" THEN a = 1
     IF a$ = "green" THEN a = 2
     IF a$ = "cyan" THEN a = 3
     IF a$ = "red" THEN a = 4
     IF a$ = "purple" THEN a = 5
     IF a$ = "brown" THEN a = 6
     IF a$ = "white" THEN a = 15
     IF a$ = "grey" THEN a = 8
     IF a$ = "l blue" THEN a = 9
     IF a$ = "l green" THEN a = 10
     IF a$ = "l cyan" THEN a = 11
     IF a$ = "pink" THEN a = 12
     IF a$ = "magenta" THEN a = 13
     IF a$ = "yellow" THEN a = 14
     IF a$ = "all" THEN b = INT(15 * RND(1) + 1): COLOR b: GOTO 15
     COLOR a
15 CIRCLE (x, x), x
     NEXT x


END SUB

SUB saver
CLOSE
    CLS
COLOR 14, 9: PRINT TAB(25); "S C R E E N  S A V E R"
COLOR 0, 9: PRINT "________________________________________________________________________________"
COLOR 15, 9
    PRINT "-1)explosions"
    PRINT "-2)squares"
    PRINT "-3)raining paint"
    PRINT "-4)shapes"
    PRINT "-5)word fly"
    PRINT "-6)disolve"
    PRINT "-7)edit word fly"
    PRINT "press Ctrl+X when done"
    INPUT "which selection for saver"; scr$
    IF scr$ = "7" THEN GOSUB editw
    IF scr$ > "7" THEN CALL saver
    IF scr$ = CHR$(24) THEN CALL main
    OPEN "savers" FOR OUTPUT AS #1
    WRITE #1, scr$
    CLOSE #1
    CALL saver
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
END SUB

SUB screens
CLOSE
OPEN "savers" FOR INPUT AS #1
IF EOF(1) THEN PRINT "error": SLEEP 2: CALL main
INPUT #1, cad$
IF cad$ = "1" THEN GOTO explosions
IF cad$ = "2" THEN GOTO squres
IF cad$ = "3" THEN GOTO raining
IF cad$ = "4" THEN GOTO shapes
IF cad$ = "5" THEN GOTO fly
IF cad$ = "6" THEN GOTO disolve

disolve:
SCREEN 12
     DIM Box%(1 TO 200)
deds:
    z = RND * 14 + 1
    x1% = 0: x2% = 1: y1% = 0: y2% = 1
    LINE (x1%, y1%)-(x2%, y2%), z, BF
    GET (x1%, y1%)-(x2%, y2%), Box%
    xa = 1
    DO
    xa = xa + 1
        PUT (x1%, y1%), Box%, OR
        x1% = RND * 620
        y1% = RND * 460
        PUT (x1%, y1%), Box%
        IF xa = 7000 THEN CLS : GOTO deds
        LOOP UNTIL INKEY$ = CHR$(27)
    EXIT SUB
squres:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
b = RND * 480
c = RND * 640
d = RND * 480
e = RND * 15 + 1
LINE (a, b)-(c, d), e, BF
LOOP UNTIL INKEY$ = CHR$(27)
CALL main
raining:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
b = RND * 480
c = RND * 15 + 1
d = RND * 30
FOR x = 1 TO d
CIRCLE (a, b), (x), c
NEXT x
LOOP UNTIL INKEY$ = CHR$(27)
EXIT SUB
shapes:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
b = RND * 480
c = RND * 640
d = RND * 480
e = RND * 15 + 1
f = RND * 100
g = RND * 15 + 1
h = RND * 640
i = RND * 480
LINE (a, b)-(c, d), e, BF
CIRCLE (h, i), f, g
LOOP UNTIL INKEY$ = CHR$(27)
CALL main
explosions:
DO
SCREEN 12
RANDOMIZE TIMER
a = RND * 640
b = RND * 480
c = RND * 15 + 1
d = RND * 300
FOR x = 1 TO d
CIRCLE (a, b), (x), c
NEXT x
LOOP UNTIL INKEY$ = CHR$(27)
EXIT SUB
fly:
COLOR 0, 0
CLOSE
RANDOMIZE TIMER
CLS
OPEN "fly.slp" FOR INPUT AS #1
INPUT #1, bht$
g = LEN(bht$)
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


END SUB

SUB timex
start:
CLS
COLOR 14, 9: CLS
PRINT TAB(25); "T I M E R": COLOR 0, 9
PRINT "________________________________________________________________________________": COLOR 15, 9
PRINT "-1)count up"
PRINT "-2)count down"
PRINT "press Ctrl+X to exit timer"
COLOR 7, 9: INPUT "which selection"; z$
COLOR 15, 9
IF z$ = "1" THEN GOTO up
IF z$ = "2" THEN GOTO down
IF z$ = CHR$(24) THEN CALL main
GOTO start
down:
CLS
COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9
INPUT "-how many seconds to count from"; b
FOR a = -b TO 0 STEP 1
PRINT a
SLEEP 1
IF a = -1 THEN GOTO beeper
NEXT a
END
up:
CLS
COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9
INPUT "Start"; y$
IF y$ <> "y" THEN GOTO up
d = 1
WHILE INKEY$ = ""
CLS
PRINT "to stop press space"
COLOR 0, 9: PRINT "________________________________________________________________________________": COLOR 15, 9
PRINT d
d = d + 1
SLEEP 1
WEND
GOTO start

beeper:
COLOR 7, 9: PRINT "press Esc to stop..."
DO
BEEP: SLEEP 1
LOOP UNTIL INKEY$ = CHR$(27)
GOTO start
END SUB

