DEFINT A-Z
DECLARE SUB DrawWin (wWin AS ANY)
DECLARE SUB GetText (x1%, y1%, x2%, y2%, Store$)
DECLARE SUB PutText (x1%, y1%, Store$)
DECLARE SUB mShow ()
DECLARE SUB mInit ()
DECLARE SUB mInfo (x, y, Btn)
DECLARE SUB mHide ()
'$INCLUDE: 'QB.BI'
DIM mInregs AS RegType, mOutregs AS RegType
TYPE WinType
 Title AS STRING * 80
 x1 AS INTEGER
 y1 AS INTEGER
 x2 AS INTEGER
 y2 AS INTEGER
 h AS INTEGER
 w AS INTEGER
 Zorder AS INTEGER
 ID AS INTEGER
END TYPE
DIM SHARED Win(1 TO 6) AS WinType
'****************************************************************************'
'************* COLOR VGA WITH 8 PAGES IN SCREEN MODE 0 REQUIRED *************'
'****************************************************************************'
'Maximum of 6 windows
'SCREEN 0, , WorkPage, DisplayPage
SCREEN 0, , 0, 0
CLS
Win(1).Title = "Test Window"
Win(1).x1 = 3
Win(1).y1 = 4
Win(1).x2 = 76
Win(1).y2 = 24
Win(1).w = Win(1).x2 - Win(1).x1
Win(1).h = Win(1).y2 - Win(1).y1
Win(1).Zorder = 1
Win(1).ID = 1
DrawWin Win(1)

SUB DrawWin (wWin AS WinType)
'ÚÄ´ Title        ³þÃ¿
'³                   ³
'³                   ³
'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
'minimum width: 9
'minimum height: 3
'³ÀÃ´ÚÙ¿Äþ°²±ÁÂ
x1 = wWin.x1
y1 = wWin.y1
x2 = wWin.x2
y2 = wWin.y2
h = wWin.h
w = wWin.w
t$ = RTRIM$(wWin.Title)

COLOR 15, 1
LOCATE y1, x1
PRINT "ÚÄ´";
IF wWin.Zorder THEN COLOR 15, 15 ELSE COLOR 15, 1
PRINT SPACE$(w - 6);
COLOR 15, 1
PRINT "³þÃ¿";
FOR a = 1 TO h - 1
  LOCATE y1 + a, x1
  COLOR 15, 9
  PRINT "³";
  COLOR 0, 2
  PRINT SPACE$(w - 1);
  COLOR 15, 9
  PRINT "³";
NEXT a
LOCATE y2, x1
COLOR 15, 9
PRINT "À"; STRING$(w - 2, "Ä"); "´ ";
IF LEN(t$) > w - 9 THEN t$ = LEFT$(t$, w - 9)
IF wWin.Zorder THEN COLOR 15, 15 ELSE COLOR 15, 1
LOCATE y1, x1 + 4: PRINT t$
COLOR 15, 1
LOCATE y2 - 1, x2: PRINT "Á"
SCREEN 0, , wWin.ID, 0
GetText 1, 1, w - 1, h - 1, st$
SCREEN 0, , 0, 0
PutText x1 + 1, y1 + 1, st$
st$ = ""
END SUB

SUB GetText (x1, y1, x2, y2, Store$)
'size = ((x2 - x1 + 1) * (y2 - y1 + 1)) * 2 + 2
IF x1 > x2 THEN SWAP x1, x2
IF y1 > y2 THEN SWAP y1, y2
Store$ = CHR$(x2 - x1) + CHR$(y2 - y1)
FOR x = x1 TO x2
  FOR y = y1 TO y2
    Store$ = Store$ + CHR$(SCREEN(y, x, 0)) + CHR$(SCREEN(y, x, -1))
  NEXT y
NEXT x
END SUB

SUB mHide
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 2
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  
END SUB

SUB mInfo (x, y, Btn)
'-----[Debouncing Routine]-----
'mInfo Xpos, Ypos, Btns
'IF Btns THEN
'  ... code ...                  'a button has been pressed
'  DO                            'wait for the user to release the button
'    mInfo dummy, dummy, tmpBtn                                 '(debouncing)
'    IF tmpBtn = 0 THEN EXIT DO  'the user has released the button
'  LOOP
'  ... code ...                  'the button was released
'ENDIF

'-----[Drag Routine]-----
'mInfo oldX, oldY, Btns
'DO
'  mInfo newX, newY, Btns                 'get new mouse position
'  IF oldX <> newX OR oldY <> newY THEN
'    ... code ...                         'the pointer has moved
'  END IF
'  IF Btns = 0 THEN EXIT DO               'the user has released the button
'  oldX = newX: oldY = newY               'store old mouse position
'LOOP
'... code ...
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 3
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  x = mOutregs.cx
  y = mOutregs.dx
  Btn = mOutregs.bx

END SUB

SUB mInit
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  mInregs.ax = 0
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  IsMouseOK = mOutregs.ax
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 7
  mInregs.cx = 0            ' min column
  mInregs.dx = 639          ' max column
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  mInregs.ax = 8
  mInregs.cx = 0            ' min row
  mInregs.dx = 199          ' max row
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  mInregs.ax = 1
  CALL INTERRUPT(&H33, mInregs, mOutregs)

END SUB

SUB mShow
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB

  mInregs.ax = 1
  CALL INTERRUPT(&H33, mInregs, mOutregs)

END SUB

SUB OpenWin (WinID, wWin AS WinType)
Win(WinID) = wWin
END SUB

SUB PutText (x1, y1, Store$)
x2 = x1 + ASC(MID$(Store$, 1, 1))
y2 = y1 + ASC(MID$(Store$, 2, 1))
Store$ = RIGHT$(Store$, LEN(Store$) - 2)
Pnt = 1
FOR x = x1 TO x2
  FOR y = y1 TO y2
    Char$ = MID$(Store$, Pnt, 1)
    Col = ASC(MID$(Store$, Pnt + 1, 1))
    FGC = Col AND 15
    BGC = Col \ 16
    Pnt = Pnt + 2
    LOCATE y, x: COLOR FGC, BGC: PRINT Char$;
  NEXT y
NEXT x
END SUB

