DEFINT A-Z
DECLARE SUB GetText (x1%, y1%, x2%, y2%, Store$)
DECLARE SUB PutText (x1%, y1%, Store$)

'size = ((x2 - x1 + 1) * (y2 - y1 + 1)) * 2 + 2

CLS
RANDOMIZE TIMER
FOR x = 2 TO 79 STEP 3
  FOR y = 2 TO 24 STEP 3
    COLOR INT(RND * 16), INT(RND * 16)
    LOCATE y - 1, x - 1: PRINT "\|/";
    LOCATE y, x - 1: PRINT "-*-";
    LOCATE y + 1, x - 1: PRINT "/|\";
  NEXT y
NEXT x

COLOR 15, 4: LOCATE 1, 1: PRINT "Press any key..."
SLEEP
LOCATE 1, 1: PRINT "Getting text...."
sT! = TIMER
GetText 20, 5, 59, 15, StoreTxt$
eT! = TIMER
LOCATE 2, 1: PRINT "GetText:"; eT! - sT!
LOCATE 1, 1: PRINT "Press any key..."
COLOR 15, 1
LOCATE 5, 20: PRINT "+"; STRING$(38, "-"); "+"
FOR y = 6 TO 14: LOCATE y, 20: PRINT "|"; SPACE$(38); "|": NEXT y
LOCATE 15, 20: PRINT "+"; STRING$(38, "-"); "+"
LOCATE 6, 35: PRINT "Welcome!"
LOCATE 8, 25: PRINT "Bla bla bla (c)1996 bla bla"
LOCATE 9, 25: PRINT "  All Rights Reserved."
LOCATE 11, 25: PRINT "Press any key to enter program..."
SLEEP
COLOR 15, 4: LOCATE 1, 1: PRINT "Putting text...."
sT! = TIMER
PutText 20, 5, StoreTxt$
eT! = TIMER
COLOR 15, 4: LOCATE 2, 1: PRINT "PutText:"; eT! - sT!
LOCATE 1, 1: PRINT "End of demo.    "

SUB GetText (x1, y1, x2, y2, Store$)
IF x1 > x2 THEN SWAP x1, x2
IF y1 > y2 THEN SWAP y1, y2
Store$ = CHR$(x2 - x1) + CHR$(y2 - y1)
FOR x = x1 TO x2
  FOR y = y1 TO y2
    Store$ = Store$ + CHR$(SCREEN(y, x, 0)) + CHR$(SCREEN(y, x, -1))
  NEXT y
NEXT x
END SUB

SUB PutText (x1, y1, Store$)
x2 = x1 + ASC(MID$(Store$, 1, 1))
y2 = y1 + ASC(MID$(Store$, 2, 1))
Store$ = RIGHT$(Store$, LEN(Store$) - 2)
Pnt = 1
FOR x = x1 TO x2
  FOR y = y1 TO y2
    Char$ = MID$(Store$, Pnt, 1)
    FGC = ASC(MID$(Store$, Pnt + 1, 1)) AND 15
    BGC = ASC(MID$(Store$, Pnt + 1, 1)) \ 16
    Pnt = Pnt + 2
    LOCATE y, x: COLOR FGC, BGC: PRINT Char$;
  NEXT y
NEXT x
END SUB

