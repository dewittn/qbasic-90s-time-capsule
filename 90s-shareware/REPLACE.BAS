DECLARE SUB Replace (text$, char1$, char2$)

CLS
DO

PRINT
test$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
PRINT test$
INPUT "Replace:", a$
IF UCASE$(a$) = "END" THEN END
INPUT "With:   ", b$
Replace test$, a$, b$
PRINT test$

LOOP

SUB Replace (text$, char1$, char2$)
IF INSTR(text$, char1$) = 0 THEN EXIT SUB
FOR a = 1 TO LEN(text$) - LEN(char1$)
  IF MID$(text$, a, LEN(char1$)) = char1$ THEN
    text$ = LEFT$(text$, a - 1) + char2$ + RIGHT$(text$, LEN(text$) - (a + LEN(char1$)) + 1)
  END IF
NEXT a
END SUB

