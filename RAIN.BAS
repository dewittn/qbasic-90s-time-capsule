SCREEN 1
RANDOMIZE TIMER
DO
LINE (ox, oy)-(oy, ox), 0
x = INT(RND * 320)
y = INT(RND * 200)
LINE (x, y)-(y, x)
ox = x
oy = y
LOOP UNTIL INKEY$ = CHR$(27)

