CLS
INPUT "Enter number to be converted:", o
INPUT "Enrer base to convert number to:", p
CLS
z = 6
DIM q(z)
FOR l = p TO 1 STEP -1
a = o
b = l
q(1) = 1
q(2) = b
w = b
FOR s = 3 TO z
        e = w * b
        w = e
        q(s) = w
NEXT s
FOR s = z TO 2 STEP -1
1       IF a > q(s) OR a = q(s) THEN
                DO
                a = a - q(s)
                v = v + 1
                LOOP UNTIL a < q(s)
        END IF
        PRINT v;
        v = 0
NEXT s
PRINT
PRINT l
DO
LOOP UNTIL INKEY$ <> ""
PRINT
NEXT l

