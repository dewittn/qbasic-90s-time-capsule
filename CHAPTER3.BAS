INPUT "Eneter X1: ", x1temp
INPUT "Enter Y1: ", y1temp
INPUT "Enter Answ1: ", answ1temp
INPUT "Eneter X2: ", x2temp
INPUT "Enter Y2: ", y2temp
INPUT "Enter Answ2: ", answ2temp
PRINT
IF x1temp < 0 THEN x1 = -(x1temp) ELSE x1 = x1temp
IF x2temp < 0 THEN x2 = -(x2temp) ELSE x2 = x2temp

y1 = y1temp
y2 = y2temp

FOR a = 1 TO x2
 FOR b = 1 TO x1
  IF x1 * a = x2 * b THEN EXIT FOR
 NEXT
  IF x1 * a = x2 * b THEN EXIT FOR
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
y1 = y1 * a
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
y2 = y2 * b
answ2 = answ2temp * b


IF x1 > 0 AND x2 > 0 THEN
 y3 = y1 - y2
 answ3 = answ1 - answ2


ELSE
 y3 = y1 + y2
 answ3 = answ1 + answ2
IF y2temp > 0 THEN
 PRINT "-"; x2temp * b; "x +"; y2temp * b; "y = "; answ2temp * b
ELSE
 PRINT "-"; x2temp * b; "x "; y2temp * b; "y = "; answ2temp * b
END IF

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

IF y1temp * a > 0 THEN
 PRINT x1temp * a; "x +"; y1temp * a; "y = "; answ1temp * a
ELSE
 PRINT x1temp * a; "x "; y1temp * a; "y = "; answ1temp * a
END IF



PRINT
PRINT y3; "y = "; answ3
PRINT "y = "; answ3; " / "; y3
PRINT "y = "; answ3 / y3

PRINT "x = "; (answ1temp - ((answ3 / y3) * y1temp)) / x1temp

