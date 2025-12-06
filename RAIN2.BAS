SCREEN 12
RANDOMIZE TIMER
DO
IF skip <> 1 THEN
IF skipb = 0 THEN
LINE (ox, oy)-(-oy, -ox), 0
ELSE
LINE (ox, oy)-(oy, ox), 0
END IF
END IF
x = INT(RND * 640)
y = INT(RND * 280)
IF skipb <> 1 THEN
LINE (x, y)-(-y, -x)
ELSE
LINE (x, y)-(y, x)
END IF
ox = x
oy = y
'SLEEP 1
IF INKEY$ = CHR$(0) + ";" THEN
IF skip = 1 THEN
skip = 0
ELSE
skip = 1
END IF
END IF
IF INKEY$ = CHR$(0) + "<" THEN
IF skipb = 1 THEN
skipb = 0
ELSE
skipb = 1
END IF
END IF
LOOP UNTIL INKEY$ = CHR$(27)

