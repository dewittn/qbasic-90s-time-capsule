'Very Short Mouse Routines
'    Hauke Daempfling
'   hcd@berlin.snafu.de
'Feb. 17, 1996, sometime around 1 AM
'
'Short instructions:
'  mInit - Initialize and show the mouse pointer. For resolutions other than
'          SCREEN 0, change the X/Y boundraries in the mInit SUB (note that
'          even though the max. X and max. Y values in mInit seem a bit
'          strange, they are correct).
'  mInfo - Store the mouse info into the X, Y, and Btn arguments. Btn can be
'          0 - none, 1 - left, 2 - right, 3 - both.
'  mHide - Hide the mouse pointer. Mouse pointer should be hidden during
'          drawing operations.
'  mShow - Show the mouse pointer after using mHide.
'
'NOTE: For some screen modes the returned mouse X/Y may not be correct, they
'      first have to be translated in some way I don't know.

DEFINT A-Z
DECLARE SUB mShow ()
DECLARE SUB mInit ()
DECLARE SUB mInfo (X, Y, Btn)
DECLARE SUB mHide ()
'$INCLUDE: 'QB.BI'
DIM mInregs AS RegType, mOutregs AS RegType

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

SUB mHide
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 2
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  
END SUB

SUB mInfo (X, Y, Btn)
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 3
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  X = mOutregs.cx
  Y = mOutregs.dx
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

