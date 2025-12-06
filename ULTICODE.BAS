DECLARE SUB makearray (X$)
DIM SHARED array$(1000)
DIM SHARED zcode(1000)
DIM mn$(4)
DIM mc$(4)
FOR fmt = 1 TO 1000
array$(fmt) = "û"
NEXT fmt
CLS
COLOR 5: PRINT "                      Steve's Ultimate Encoding Utility"
COLOR 2
PRINT STRING$(80, "_")
COLOR 7
PRINT
PRINT "Text must be less than 1000 characters."
INPUT "Input Text to be Encoded: ", a$
    IF LEN(a$) > 1000 THEN
    a$ = LEFT$(a$, 1000)
    END IF
INPUT "Do you want the final product sent dirrectly to the printer? (Y,N)", que$
que$ = UCASE$(que$)
IF LEFT$(que$, 1) = "Y" THEN printon = 1 ELSE printon = 0
    CALL makearray(a$)
    COLOR 18: PRINT "             Processing..."
    COLOR 7
    FOR a = 1 TO 127
    c$ = array$(a)
    IF c$ = "û" THEN GOTO endx
    IF c$ = " " THEN array$(a) = "-"
    IF c$ = "a" THEN array$(a) = "1"
    IF c$ = "b" THEN array$(a) = "2"
    IF c$ = "c" THEN array$(a) = "3"
    IF c$ = "d" THEN array$(a) = "4"
    IF c$ = "e" THEN array$(a) = "5"
    IF c$ = "f" THEN array$(a) = "6"
    IF c$ = "g" THEN array$(a) = "7"
    IF c$ = "h" THEN array$(a) = "8"
    IF c$ = "i" THEN array$(a) = "9"
    IF c$ = "j" THEN array$(a) = "10"
    IF c$ = "k" THEN array$(a) = "11"
    IF c$ = "l" THEN array$(a) = "12"
    IF c$ = "m" THEN array$(a) = "13"
    IF c$ = "n" THEN array$(a) = "14"
    IF c$ = "o" THEN array$(a) = "15"
    IF c$ = "p" THEN array$(a) = "16"
    IF c$ = "q" THEN array$(a) = "17"
    IF c$ = "r" THEN array$(a) = "18"
    IF c$ = "s" THEN array$(a) = "19"
    IF c$ = "t" THEN array$(a) = "20"
    IF c$ = "u" THEN array$(a) = "21"
    IF c$ = "v" THEN array$(a) = "22"
    IF c$ = "w" THEN array$(a) = "23"
    IF c$ = "x" THEN array$(a) = "24"
    IF c$ = "y" THEN array$(a) = "25"
    IF c$ = "z" THEN array$(a) = "26"
    NEXT a
endx:
RANDOMIZE TIMER
    FOR a = 1 TO 1000
    c$ = array$(a)
    op = INT(999 * RND(1) + 1)
    IF c$ = "û" THEN GOTO end1
    IF c$ = " " THEN array$(a) = "0"
    IF c$ = "1" THEN zcode(a) = op: array$(a) = STR$(op + 1)
    IF c$ = "2" THEN zcode(a) = op: array$(a) = STR$(op + 2)
    IF c$ = "3" THEN zcode(a) = op: array$(a) = STR$(op + 3)
    IF c$ = "4" THEN zcode(a) = op: array$(a) = STR$(op + 4)
    IF c$ = "5" THEN zcode(a) = op: array$(a) = STR$(op + 5)
    IF c$ = "6" THEN zcode(a) = op: array$(a) = STR$(op + 6)
    IF c$ = "7" THEN zcode(a) = op: array$(a) = STR$(op + 7)
    IF c$ = "8" THEN zcode(a) = op: array$(a) = STR$(op + 8)
    IF c$ = "9" THEN zcode(a) = op: array$(a) = STR$(op + 9)
    IF c$ = "10" THEN zcode(a) = op: array$(a) = STR$(op + 10)
    IF c$ = "11" THEN zcode(a) = op: array$(a) = STR$(op + 11)
    IF c$ = "12" THEN zcode(a) = op: array$(a) = STR$(op + 12)
    IF c$ = "13" THEN zcode(a) = op: array$(a) = STR$(op + 13)
    IF c$ = "14" THEN zcode(a) = op: array$(a) = STR$(op + 14)
    IF c$ = "15" THEN zcode(a) = op: array$(a) = STR$(op + 15)
    IF c$ = "16" THEN zcode(a) = op: array$(a) = STR$(op + 16)
    IF c$ = "17" THEN zcode(a) = op: array$(a) = STR$(op + 17)
    IF c$ = "18" THEN zcode(a) = op: array$(a) = STR$(op + 18)
    IF c$ = "19" THEN zcode(a) = op: array$(a) = STR$(op + 19)
    IF c$ = "20" THEN zcode(a) = op: array$(a) = STR$(op + 20)
    IF c$ = "21" THEN zcode(a) = op: array$(a) = STR$(op + 21)
    IF c$ = "22" THEN zcode(a) = op: array$(a) = STR$(op + 22)
    IF c$ = "23" THEN zcode(a) = op: array$(a) = STR$(op + 23)
    IF c$ = "24" THEN zcode(a) = op: array$(a) = STR$(op + 24)
    IF c$ = "25" THEN zcode(a) = op: array$(a) = STR$(op + 25)
    IF c$ = "26" THEN zcode(a) = op: array$(a) = STR$(op + 26)
    NEXT a
end1:
  FOR i = 1 TO 1000
  FOR a = 1 TO 4
  d$ = MID$(array$(i), a, 1)
  IF array$(i) = "û" THEN GOTO end2
  IF d$ = "0" THEN MID$(array$(i), a, 1) = "~"
  IF d$ = "1" THEN MID$(array$(i), a, 1) = "a"
  IF d$ = "2" THEN MID$(array$(i), a, 1) = "b"
  IF d$ = "3" THEN MID$(array$(i), a, 1) = "c"
  IF d$ = "4" THEN MID$(array$(i), a, 1) = "d"
  IF d$ = "5" THEN MID$(array$(i), a, 1) = "e"
  IF d$ = "6" THEN MID$(array$(i), a, 1) = "f"
  IF d$ = "7" THEN MID$(array$(i), a, 1) = "g"
  IF d$ = "8" THEN MID$(array$(i), a, 1) = "h"
  IF d$ = "9" THEN MID$(array$(i), a, 1) = "i"
  NEXT
  NEXT
end2:
CLS
IF printon = 1 THEN
COLOR 18
PRINT "                         Printing..."
COLOR 4
LPRINT "Key Codes:"
COLOR 7
FOR a = 1 TO 1000
IF zcode(a) <> 0 THEN
LPRINT zcode(a);
END IF
NEXT a
LPRINT
COLOR 3
LPRINT STRING$(80, "_")
COLOR 7
ELSE
COLOR 4
PRINT "Key Codes:"
COLOR 7
FOR a = 1 TO 1000
IF zcode(a) <> 0 THEN
PRINT zcode(a);
END IF
NEXT a
PRINT
COLOR 3
PRINT STRING$(80, "_")
COLOR 7
END IF

  RANDOMIZE TIMER
    FOR a = 1 TO 1000
    FOR X = 1 TO 4
    hi$ = MID$(array$(a), X, 1)
    FOR die = 1 TO 4
50 mn = INT(26 * RND(1) + 1)
    IF mn = 1 THEN GOTO 50
    IF mn = 2 THEN mn$(die) = "b"
    IF mn = 3 THEN mn$(die) = "c"
    IF mn = 4 THEN mn$(die) = "d"
    IF mn = 5 THEN GOTO 50
    IF mn = 6 THEN mn$(die) = "f"
    IF mn = 7 THEN mn$(die) = "g"
    IF mn = 8 THEN mn$(die) = "h"
    IF mn = 9 THEN GOTO 50
    IF mn = 10 THEN mn$(die) = "j"
    IF mn = 11 THEN mn$(die) = "k"
    IF mn = 12 THEN mn$(die) = "l"
    IF mn = 13 THEN mn$(die) = "m"
    IF mn = 14 THEN mn$(die) = "n"
    IF mn = 15 THEN GOTO 50
    IF mn = 16 THEN mn$(die) = "p"
    IF mn = 17 THEN mn$(die) = "q"
    IF mn = 18 THEN mn$(die) = "r"
    IF mn = 19 THEN mn$(die) = "s"
    IF mn = 20 THEN mn$(die) = "t"
    IF mn = 21 THEN GOTO 50
    IF mn = 22 THEN mn$(die) = "v"
    IF mn = 23 THEN mn$(die) = "w"
    IF mn = 24 THEN mn$(die) = "x"
    IF mn = 25 THEN mn$(die) = "y"
    IF mn = 26 THEN mn$(die) = "z"
    RANDOMIZE TIMER
    mc = INT(5 * RND(1) + 1)
    IF mc = 1 THEN mc$(die) = "a"
    IF mc = 2 THEN mc$(die) = "e"
    IF mc = 3 THEN mc$(die) = "i"
    IF mc = 4 THEN mc$(die) = "o"
    IF mc = 5 THEN mc$(die) = "u"
    NEXT die
IF printon = 1 THEN
    IF hi$ = "û" THEN GOTO msg
    IF hi$ = " " THEN LPRINT "-";
    IF hi$ = "a" THEN LPRINT mc$(1); mn$(1); "-";
    IF hi$ = "b" THEN LPRINT mn$(1); mc$(1); mc$(2); mc$(3); "-";
    IF hi$ = "c" THEN LPRINT mn$(1); mc$(1); mn$(2); mc$(2); "-";
    IF hi$ = "d" THEN LPRINT mn$(1); mc$(1); mc$(2); "-";
    IF hi$ = "e" THEN LPRINT mc$(1); "-";
    IF hi$ = "f" THEN LPRINT mc$(1); mc$(2); mn$(1); mc$(3); "-";
    IF hi$ = "g" THEN LPRINT mn$(1); mn$(2); mc$(1); "-";
    IF hi$ = "h" THEN LPRINT mc$(1); mc$(2); mc$(3); mc$(4); "-";
    IF hi$ = "i" THEN LPRINT mc$(1); mc$(2); "-";
    IF hi$ = "j" THEN LPRINT mc$(1); mn$(1); mn$(2); mn$(3); "-";
    IF hi$ = "k" THEN LPRINT mn$(1); mc$(1); mn$(2); "-";
    IF hi$ = "l" THEN LPRINT mc$(1); mn$(1); mc$(2); mc$(3); "-";
    IF hi$ = "m" THEN LPRINT mn$(1); mn$(2); "-";
    IF hi$ = "n" THEN LPRINT mn$(1); mc$(1); "-";
    IF hi$ = "o" THEN LPRINT mn$(1); mn$(2); mn$(3); "-";
    IF hi$ = "p" THEN LPRINT mc$(1); mn$(1); mn$(2); mc$(2); "-";
    IF hi$ = "q" THEN LPRINT mn$(1); mn$(2); mc$(1); mn$(3); "-";
    IF hi$ = "r" THEN LPRINT mc$(1); mn$(1); mc$(2); "-";
    IF hi$ = "s" THEN LPRINT mc$(1); mc$(2); mc$(3); "-";
    IF hi$ = "t" THEN LPRINT mn$(1); "-";
    IF hi$ = "u" THEN LPRINT mc$(1); mc$(2); mn$(1); "-";
    IF hi$ = "v" THEN LPRINT mc$(1); mc$(2); mc$(3); mn$(1); "-";
    IF hi$ = "w" THEN LPRINT mc$(1); mn$(1); mn$(2); "-";
    IF hi$ = "x" THEN LPRINT mn$(1); mc$(1); mc$(2); mn$(2); "-";
    IF hi$ = "y" THEN LPRINT mn$(1); mc$(1); mn$(2); mn$(3); "-";
    IF hi$ = "z" THEN LPRINT mn$(1); mn$(2); mc$(1); mc$(2); "-";
    IF hi$ = "~" THEN LPRINT mn$(1); mn$(2); mn$(3); mn$(4); "-";
   
    ELSE
    IF hi$ = "û" THEN GOTO msg
    IF hi$ = " " THEN PRINT "-";
    IF hi$ = "a" THEN PRINT mc$(1); mn$(1); "-";
    IF hi$ = "b" THEN PRINT mn$(1); mc$(1); mc$(2); mc$(3); "-";
    IF hi$ = "c" THEN PRINT mn$(1); mc$(1); mn$(2); mc$(2); "-";
    IF hi$ = "d" THEN PRINT mn$(1); mc$(1); mc$(2); "-";
    IF hi$ = "e" THEN PRINT mc$(1); "-";
    IF hi$ = "f" THEN PRINT mc$(1); mc$(2); mn$(1); mc$(3); "-";
    IF hi$ = "g" THEN PRINT mn$(1); mn$(2); mc$(1); "-";
    IF hi$ = "h" THEN PRINT mc$(1); mc$(2); mc$(3); mc$(4); "-";
    IF hi$ = "i" THEN PRINT mc$(1); mc$(2); "-";
    IF hi$ = "j" THEN PRINT mc$(1); mn$(1); mn$(2); mn$(3); "-";
    IF hi$ = "k" THEN PRINT mn$(1); mc$(1); mn$(2); "-";
    IF hi$ = "l" THEN PRINT mc$(1); mn$(1); mc$(2); mc$(3); "-";
    IF hi$ = "m" THEN PRINT mn$(1); mn$(2); "-";
    IF hi$ = "n" THEN PRINT mn$(1); mc$(1); "-";
    IF hi$ = "o" THEN PRINT mn$(1); mn$(2); mn$(3); "-";
    IF hi$ = "p" THEN PRINT mc$(1); mn$(1); mn$(2); mc$(2); "-";
    IF hi$ = "q" THEN PRINT mn$(1); mn$(2); mc$(1); mn$(3); "-";
    IF hi$ = "r" THEN PRINT mc$(1); mn$(1); mc$(2); "-";
    IF hi$ = "s" THEN PRINT mc$(1); mc$(2); mc$(3); "-";
    IF hi$ = "t" THEN PRINT mn$(1); "-";
    IF hi$ = "u" THEN PRINT mc$(1); mc$(2); mn$(1); "-";
    IF hi$ = "v" THEN PRINT mc$(1); mc$(2); mc$(3); mn$(1); "-";
    IF hi$ = "w" THEN PRINT mc$(1); mn$(1); mn$(2); "-";
    IF hi$ = "x" THEN PRINT mn$(1); mc$(1); mc$(2); mn$(2); "-";
    IF hi$ = "y" THEN PRINT mn$(1); mc$(1); mn$(2); mn$(3); "-";
    IF hi$ = "z" THEN PRINT mn$(1); mn$(2); mc$(1); mc$(2); "-";
    IF hi$ = "~" THEN PRINT mn$(1); mn$(2); mn$(3); mn$(4); "-";
    END IF
    NEXT
    NEXT
msg:
    IF printon = 1 THEN
    LPRINT
    LPRINT
    LPRINT
    LPRINT
    LPRINT
    LPRINT "Message: "; a$
    CLS
COLOR 7
PRINT "                         Printing Complete."
   
    ELSE
    PRINT
    PRINT
    PRINT
    PRINT
    PRINT
    PRINT "Message: "; a$
    END IF
SLEEP 0

SUB makearray (X$)
FOR i = 1 TO LEN(X$)
array$(i) = MID$(X$, i, 1)
NEXT
'FOR i = LEN(X$) + 1 TO 1000
'array$(i) = CHR$(0)
'NEXT
END SUB

