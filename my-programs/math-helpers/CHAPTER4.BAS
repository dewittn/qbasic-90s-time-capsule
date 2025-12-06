CLS
INPUT "Eneter X1: ", x1temp
INPUT "Enter Y1: ", y1temp
INPUT "Enter Answ1: ", answ1temp
INPUT "Eneter X2: ", x2temp
INPUT "Enter Y2: ", y2temp
INPUT "Enter Answ2: ", answ2temp
PRINT
IF x1temp < 0 THEN X1 = -(x1temp) ELSE X1 = x1temp
IF x2temp < 0 THEN X2 = -(x2temp) ELSE X2 = x2temp

Y1 = y1temp
Y2 = y2temp

FOR a = 1 TO X2
 FOR b = 1 TO X1
  IF X1 * a = X2 * b THEN EXIT FOR
 NEXT
  IF X1 * a = X2 * b THEN EXIT FOR
NEXT

IF y1temp > 0 THEN
 PRINT a; "("; x1temp; "x +"; y1temp; "y = "; answ1temp; ")"
ELSE
 PRINT a; "("; x1temp; "x "; y1temp; "y = "; answ1temp; ")"
END IF

IF y2temp > 0 THEN
 PRINT b; "("; x2temp; "x +"; y2temp; "y = "; answ2temp; ")"
ELSE
 PRINT b; "("; x2temp; "x "; y2temp; "y = "; answ2temp; ")"
END IF
PRINT

Y1 = Y1 * a
answ1 = answ1temp * a

IF y1temp > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF

IF y2temp > 0 THEN
 PRINT x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b
ELSE
 PRINT x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b
END IF
PRINT
Y2 = Y2 * b
answ2 = answ2temp * b

X1 = x1temp
X2 = x2temp

IF (X1 > 0 AND X2 > 0) OR (X1 < 0 AND X2 < 0) THEN
 y3 = Y1 - Y2
 answ3 = answ1 - answ2

IF y1temp * a > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF

IF y2temp > 0 THEN
 PRINT "-"; x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b
ELSE
 PRINT "-"; x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b
END IF

ELSE
 y3 = Y1 + Y2
 answ3 = answ1 + answ2

IF y1temp * a > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF

IF y2temp > 0 THEN
 PRINT "+"; x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b; " ="
ELSE
 PRINT "+"; x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b; " ="
END IF

END IF




PRINT
PRINT y3; "y = "; answ3
PRINT "y = "; answ3; " / "; y3
PRINT "y = "; answ3 / y3
PRINT
PRINT (answ1temp - ((answ3 / y3) * y1temp)); " / "; x1temp
PRINT "x = "; (answ1temp - ((answ3 / y3) * y1temp)) / x1temp

INPUT "Solve for x using LC?(y/n): ", hi$
IF UCASE$(hi$) <> "Y" THEN END

IF y1temp < 0 THEN Y1 = -(y1temp) ELSE Y1 = y1temp
IF y2temp < 0 THEN Y2 = -(y2temp) ELSE Y2 = y2temp

X1 = x1temp
X2 = x2temp

FOR a = 1 TO Y2
 FOR b = 1 TO Y1
  IF Y1 * a = Y2 * b THEN EXIT FOR
 NEXT
  IF Y1 * a = Y2 * b THEN EXIT FOR
NEXT

IF y1temp > 0 THEN
 PRINT a; "("; x1temp; "x +"; y1temp; "y = "; answ1temp; ")"
ELSE
 PRINT a; "("; x1temp; "x "; y1temp; "y = "; answ1temp; ")"
END IF

IF y2temp > 0 THEN
 PRINT b; "("; x2temp; "x +"; y2temp; "y = "; answ2temp; ")"
ELSE
 PRINT b; "("; x2temp; "x "; y2temp; "y = "; answ2temp; ")"
END IF
PRINT

X1 = X1 * a
answ1 = answ1temp * a

IF y1temp > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF

IF y2temp > 0 THEN
 PRINT x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b
ELSE
 PRINT x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b
END IF
PRINT
X2 = X2 * b
answ2 = answ2temp * b

Y1 = y1temp
Y2 = y2temp

IF Y1 > 0 AND Y2 > 0 OR Y1 < 0 AND Y2 < 0 THEN
 x3 = X1 - X2
 answ3 = answ1 - answ2

IF y1temp * a > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF

IF y2temp > 0 THEN
 PRINT "-"; x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b
ELSE
 PRINT "-"; x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b
END IF

ELSE
 x3 = X1 + X2
 answ3 = answ1 + answ2

IF y1temp * a > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF

IF y2temp > 0 THEN
 PRINT "+"; x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b; " ="
ELSE
 PRINT "+"; x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b; " ="
END IF

END IF




PRINT
PRINT x3; "x = "; answ3
PRINT "x = "; answ3; " / "; x3
PRINT "x = "; answ3 / x3

