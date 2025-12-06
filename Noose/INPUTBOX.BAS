DEFINT A-Z
DECLARE FUNCTION InpBox$ (Def$, X%, Y%, Overlay$)
'
'  *** Input Box ***
' by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This program is a very nice substitute for INPUT. It supports the
'arrow keys, delete, backspace, home, and end keys. It also has
'a password function, just put the character you want to substitute
'for any typed characters into Overlay$.
'

CLS
PRINT "Please enter your name."
a$ = InpBox$("Your Name         ", 1, 2, "")
IF a$ = "" THEN PRINT "Aborted!" ELSE PRINT "Welcome, "; a$
PRINT

PRINT "Please enter your password."
a$ = InpBox$("                  ", 1, 6, "*")
IF a$ = "" THEN PRINT "Aborted!" ELSE PRINT "Password OK. ("; a$; ")"

FUNCTION InpBox$ (Def$, X, Y, Overlay$)
IF Y > 25 OR X > 80 OR Y < 1 OR X < 1 THEN EXIT FUNCTION
Dlen = LEN(Def$)
IF X + Dlen > 80 THEN EXIT FUNCTION
Def$ = LTRIM$(RTRIM$(Def$))
IF LEN(Overlay$) > 1 THEN Overlay$ = LEFT$(Overlay$, 1)
LOCATE Y, X
IF Overlay$ <> "" THEN
  PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$));
ELSE
  PRINT Def$ + SPACE$(Dlen - LEN(Def$));
END IF
L = 0              'location of cursor in the Box
LOCATE Y + L, X, 1

DO

  DO: a$ = INKEY$: LOOP WHILE LEN(a$) = 0
  SELECT CASE (a$)
   CASE CHR$(8)
     IF L > 0 THEN
       IF L = LEN(Def$) THEN
         Def$ = LEFT$(Def$, LEN(Def$) - 1)
         L = L - 1
       ELSE
         Def$ = LEFT$(Def$, L - 1) + MID$(Def$, L + 1)
         L = L - 1
       END IF
     END IF
   CASE CHR$(0) + CHR$(83)
     IF L < LEN(Def$) THEN
       IF L = 0 THEN
         Def$ = RIGHT$(Def$, LEN(Def$) - 1) + " "
       ELSE
         Def$ = LEFT$(Def$, L) + MID$(Def$, L + 2)
       END IF
     END IF
   CASE CHR$(0) + "M"
     IF L < Dlen THEN L = L + 1
   CASE CHR$(0) + "K"
     IF L > 0 THEN L = L - 1
   CASE CHR$(0) + CHR$(79)
     L = LEN(RTRIM$(Def$))
   CASE CHR$(0) + CHR$(71)
     L = 0
   CASE CHR$(27)
    InpBox$ = ""
    EXIT DO
   CASE CHR$(13)
    InpBox$ = RTRIM$(Def$)
    EXIT DO
   CASE ELSE
     Def$ = Def$ + SPACE$(Dlen - LEN(Def$))
     IF LEN(a$) = 1 AND L < Dlen THEN MID$(Def$, L + 1, 1) = a$: L = L + 1
     Def$ = LTRIM$(RTRIM$(Def$))
  END SELECT
  LOCATE Y, X, 0
  IF Overlay$ <> "" THEN
    PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$));
  ELSE
    PRINT Def$ + SPACE$(Dlen - LEN(Def$));
  END IF
  LOCATE Y, X + L, 1
LOOP
LOCATE Y, X, 0
IF Overlay$ <> "" THEN
  PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$))
ELSE
  PRINT Def$ + SPACE$(Dlen - LEN(Def$))
END IF
END FUNCTION

