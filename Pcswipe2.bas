CLEAR : CLS : DEFINT A-X: DEFSTR Y-Z: DIM x(16)
DIM ttl AS INTEGER
DEF SEG = 64: ON ERROR GOTO errortrap
TYPE info
names AS STRING * 35
id AS INTEGER
phone AS LONG
bday AS STRING * 10
END TYPE
DIM inf AS info

OPEN "R", 1, "c:\Bitport.dat": FIELD 1, 4 AS a$
IF LOF(1) = 0 THEN
a1 = PEEK(8) + 256 * PEEK(9) + 1
ELSE
GET 1, 1: a1 = VAL(a$) + 1
END IF
CLOSE 1

start1:
GOSUB screenlayout
WHILE (INP(a1) AND 64) = 0
a$ = INKEY$: IF a$ = "~" THEN LOCATE 10, 35: PRINT SPACE$(20): LOCATE 10, 35: INPUT "Enter ID #: ", ttl: GOTO bypass
IF a$ <> "" THEN GOTO readytoend
WEND
x = 0: j = 0: start! = TIMER
readholes:
WHILE (INP(a1) AND 64) = 0: x = x + 1: WEND
j = j + 1: x(j) = x
IF x = 0 OR (TIMER - start!) > 2 THEN ERROR 6
IF j < 16 THEN GOTO readholes
done1:
VIEW PRINT 3 TO 24: CLS : VIEW PRINT: BEEP
stat = 0: ttl = 0
FOR i = 2 TO 16
SELECT CASE stat
CASE IS = 0
IF x(i) > 1.5 * x(i - 1) THEN
ttl = ttl + 2 ^ (i - 2): stat = 1
ELSE stat = 0
END IF
CASE IS = 1
IF x(i) < .667 * x(i - 1) THEN
stat = 0
ELSE
ttl = ttl + 2 ^ (i - 2): stat = 1
END IF
CASE ELSE
ERROR 6
END SELECT
NEXT
LOCATE 14, 3
LOCATE 10, 35: PRINT "ID sensed:"; ttl
bypass:
OPEN "c:\names.dat" FOR RANDOM AS #2 LEN = LEN(inf)
xhigh = LOF(2) / LEN(inf)
found = 0
RecCnt = 0
DO
RecCnt = RecCnt + 1
GET #2, RecCnt, inf
IF ttl = inf.id THEN
found = 1
PRINT
PRINT "Name: "; inf.names
PRINT "ID: "; inf.id
PRINT "Phone Number: "; inf.phone
PRINT "Birthday: "; inf.bday
END IF
LOOP WHILE (RecCnt < xhigh AND found = 0)
IF found = 0 THEN GOSUB screenlayout: LOCATE 10, 35: PRINT "ID not in database.": BEEP
CLOSE #2
GOSUB screenlayout
GOTO start1
readytoend:
IF a$ = CHR$(27) THEN CLS : LOCATE 18, 1, 1: END
BEEP: GOTO readholes

screenlayout:
LOCATE 1, 34, 0: PRINT "Pc Swipe Card";
LOCATE 2, 1: PRINT STRING$(79, 220)
LOCATE 18, 35: COLOR 23, 0: PRINT "waiting........"; :
COLOR 7, 0
LOCATE 21, 33: PRINT "(Press Esc to end)"
RETURN

errortrap: IF ERR = 6 THEN
SOUND 500, 1
CLS : LOCATE 1, 34: PRINT "Pc Swipe Card";
LOCATE 2, 1: PRINT STRING$(79, 220): COLOR 0, 7
LOCATE 9, 25: PRINT SPACE$(34)
LOCATE 10, 25: PRINT "Error in reading swipe card."
LOCATE 11, 25: PRINT "wait for the beep and try again."
LOCATE 12, 25: PRINT SPACE$(34): COLOR 7, 0
start! = TIMER
WHILE (TIMER - start!) < 1: WEND: CLS
END IF
BEEP
RESUME start1



