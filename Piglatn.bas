'                       Pig Latin encoder
DIM b$(1000)
CLS
PRINT "                 Igpay Atinlay Encoderay"
INPUT a$
a$ = UCASE$(a$) + " "


FOR g = 1 TO 1000
b$(g) = "è"
NEXT g
d = 1
FOR c = 1 TO LEN(a$)
IF RIGHT$(LEFT$(a$, c), 1) = CHR$(32) THEN
e = e + 1
b$(e) = LTRIM$(MID$(a$, d, c - d))
d = c
END IF
NEXT c
FOR f = 1 TO 1000
IF b$(f) = "è" THEN GOTO endx

FOR b = 1 TO LEN(b$(f))

SELECT CASE RIGHT$(LEFT$(b$(f), b), 1)
CASE "A"
b$(f) = MID$(b$(f), b, LEN(b$(f))) + MID$(b$(f), 1, b - 1) + "AY"
EXIT FOR
CASE "E"
b$(f) = MID$(b$(f), b, LEN(b$(f))) + MID$(b$(f), 1, b - 1) + "AY"
EXIT FOR
CASE "I"
b$(f) = MID$(b$(f), b, LEN(b$(f))) + MID$(b$(f), 1, b - 1) + "AY"
EXIT FOR
CASE "O"
b$(f) = MID$(b$(f), b, LEN(b$(f))) + MID$(b$(f), 1, b - 1) + "AY"
EXIT FOR
CASE "U"
b$(f) = MID$(b$(f), b, LEN(b$(f))) + MID$(b$(f), 1, b - 1) + "AY"
EXIT FOR
END SELECT
NEXT
NEXT
endx:
FOR a = 1 TO 1000
IF b$(a) = "è" THEN END
PRINT b$(a); " ";
NEXT

