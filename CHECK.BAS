DIM check$(1000)
DIM checktemp$(1000)
CLS
OPEN "c:\access1.dat" FOR INPUT AS #1
 DO UNTIL EOF(1)
 numb = numb + 1
 INPUT #1, check$(numb)
 INPUT #1, checktemp$(numb)
LOOP
FOR a = 1 TO numb
 FOR b = 1 TO numb
 IF check$(a) = checktemp$(b) THEN Bad = Bad + 1
NEXT
NEXT
IF Bad > 0 THEN PRINT "U have "; Bad; " Duplicates"
PRINT "THere are "; numb; " Enteries"
SLEEP
CLOSE

