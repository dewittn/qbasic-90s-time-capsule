DEFINT A-Z
DECLARE FUNCTION OnScreen% (Xp%, Yp%)
DECLARE SUB FillArea (X%, Y%, NewClr%, CornerJump%)
DECLARE SUB Push (X%, Y%)
DECLARE FUNCTION Pop% ()
TYPE CoordType
  X AS INTEGER
  Y AS INTEGER
END TYPE
CONST True = -1, False = 0
DIM SHARED TopStack, DeepStack
DeepStack = 25000
DIM SHARED FillStack(DeepStack) AS CoordType, Ver(1 TO 8) AS CoordType
Ver(1).X = 0:  Ver(1).Y = -1
Ver(2).X = -1: Ver(2).Y = 0
Ver(3).X = 1:  Ver(3).Y = 0
Ver(4).X = 0:  Ver(4).Y = 1
Ver(5).X = -1: Ver(5).Y = -1
Ver(6).X = 1:  Ver(6).Y = -1
Ver(7).X = -1:  Ver(7).Y = 1
Ver(8).X = 1:  Ver(8).Y = 1

SCREEN 12
RANDOMIZE TIMER
LINE (0, 0)-(639, 479), 2, BF
X = RND * 640: Y = RND * 480
PSET (X, Y), 0
FOR a = 1 TO 100
  X = RND * 640: Y = RND * 480
  LINE -(X, Y), 0
  X = RND * 640: Y = RND * 480
  LINE -(X, Y), 2
NEXT a
LINE (50, 50)-(590, 430), 0, B
FillArea 50, 50, 12, -1
FillArea 315, 235, 15, 0

'Fill the area with NewClr, start at coord. X,Y
SUB FillArea (X, Y, NewClr, CornerJump)
  OldClr = POINT(X, Y)
  IF CornerJump = -1 THEN UpTo = 8 ELSE UpTo = 4
 
  DIM Cord AS CoordType, tmp AS CoordType, PerVal AS LONG, oPerVal AS LONG
  'Put our current coord on the stack
  Push X, Y
  'Fill our point
  PSET (X, Y), NewClr
  'Stack display, delete if you want
  LINE (0, 0)-(102, 22), 2, B
  LINE (0, 0)-(101, 21), 0, BF
  WHILE TopStack > 0
    'Delete the following if you want
    PerVal = (TopStack * 100&) \ DeepStack
    IF PerVal <> oPerVal THEN
      LINE (0, 0)-(PerVal, 20), 15, BF
      LINE (PerVal, 0)-(100, 20), 0, BF
      oPerVal = PerVal
    END IF
    'Get the coord we want to search (exapnd) from
    Cord = FillStack(Pop)
    CurX = Cord.X: CurY = Cord.Y
    'Paint dot
    PSET (CurX, CurY), NewClr
    'Serach
    FOR a = 1 TO UpTo
      'Search directions
      '5 1 6
      '2 * 3
      '7 4 8
      nX = Ver(a).X + CurX: nY = Ver(a).Y + CurY
      Pcol = POINT(nX, nY)
      'Check: is the point OK to put on stack?
      IF Pcol = OldClr AND OnScreen(nX, nY) AND TopStack < DeepStack THEN
        Push nX, nY
      ELSEIF TopStack >= DeepStack THEN
        'We've hit the limit of the stack, so now we have to find and remove
        'all the points that we cannot expand any further from. This always
        'gets the stack down to about 25%-50%, except when you are filling
        'lines, because then almost every point is counted as being OK.
        LINE (0, 0)-(100, 20), 0, BF                'Delete if you want
        LOCATE 1, 1: PRINT "  Wait.....";
        NSP = 0 'NSP=New Stack Pointer, OSP=Old Stack Pointer
        FOR OSP = 1 TO TopStack
          tmp = FillStack(OSP)
          CX = tmp.X: CY = tmp.Y
          FOR c = 1 TO UpTo
             nX = Ver(c).X + CX: nY = Ver(c).Y + CY
             Pcol = POINT(nX, nY)
             IF Pcol = OldClr AND OnScreen(nX, nY) THEN
               FillStack(NSP) = tmp
               NSP = NSP + 1
               EXIT FOR
             END IF
          NEXT c
        NEXT OSP
        TopStack = NSP
        LINE (0, 0)-(100, 20), 0, BF   'Delete if you want
      END IF
    NEXT a
  WEND
END SUB

FUNCTION OnScreen (Xp, Yp)
'Checks if a dot is on the screen
IF Xp >= 0 AND Xp < 640 AND Yp >= 0 AND Yp < 480 THEN OnScreen = -1
END FUNCTION

'Remove a coord. off the stack
FUNCTION Pop
IF TopStack = 0 THEN EXIT FUNCTION
TopStack = TopStack - 1
Pop = TopStack
END FUNCTION

'Put a coord. on the stack
SUB Push (X, Y)
IF TopStack = DeepStack + 1 THEN EXIT SUB
FillStack(TopStack).X = X
FillStack(TopStack).Y = Y
TopStack = TopStack + 1
END SUB

