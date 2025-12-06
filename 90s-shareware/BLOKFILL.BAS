'Hmmm... I went back and examined my source.  I tried it with a few more
'shapes and managed to crash it.  It is also a little slow.  So I went back
'and rewrote it with an entirely new algorithm that I developed.  I was
'kind of surprised to find as to how fast it filled in areas.  Depending
'on how complex the shape is, it can be a bit of a memory hog.  It uses both
'a stack and recursion to prevent stack and memory errors (which would have
'happened in a worse case scenario).  It may seem to pause on large fill
'areas but don't worry... just give it a sec.  Well here it is:
'
' BLOKFILL.BAS
' Developed and written by David J. Arigan
' Copyright (C)1996 - not to be used in any commercial product without
' written consent from the author.
DEFINT A-Z

SCREEN 9

'LINE (100, 100)-(200, 150), 4
'LINE (100, 100)-(300, 100), 4
'LINE (300, 100)-(300, 150), 4
'LINE (300, 150)-(200, 150), 4
'fill 112, 102, 7, 4

FOR i = 0 TO 310 STEP 6
  CIRCLE (320, 175), i, 4, 0, 6         ' very complex shape
NEXT
fill 639, 0, 7, 4

SUB fill (xp, yp, fc, bc)
  DIM xs(1500), ys(1500)
  xs(0) = xp: ys(0) = yp: stk = 1
  WHILE stk > 0
    stk = stk - 1
    x1 = xs(stk): fx1 = 0: y1 = ys(stk): fy1 = 0
    x2 = xs(stk): fx2 = 0: y2 = ys(stk): fy2 = 0
    WHILE (fx1 + fy1 + fx2 + fy2) <> 4
      IF fx1 = 0 THEN
        IF x1 = 0 THEN
          fx1 = 1
        ELSE
          x1 = x1 - 1
          FOR i = y1 TO y2
            nc = POINT(x1, i)
            IF nc = fc OR nc = bc THEN fx1 = 1: x1 = x1 + 1: EXIT FOR
          NEXT
        END IF
      END IF
      IF fx2 = 0 THEN
        IF x2 = 639 THEN
          fx2 = 1
        ELSE
          x2 = x2 + 1
          FOR i = y1 TO y2
            nc = POINT(x2, i)
            IF nc = fc OR nc = bc THEN fx2 = 1: x2 = x2 - 1: EXIT FOR
          NEXT
        END IF
      END IF
      IF fy1 = 0 THEN
        IF y1 = 0 THEN
          fy1 = 1
        ELSE
          y1 = y1 - 1
          FOR i = x1 TO x2
            nc = POINT(i, y1)
            IF nc = fc OR nc = bc THEN fy1 = 1: y1 = y1 + 1: EXIT FOR
          NEXT
        END IF
      END IF
      IF fy2 = 0 THEN
        IF y2 = 349 THEN
          fy2 = 1
        ELSE
          y2 = y2 + 1
          FOR i = x1 TO x2
            nc = POINT(i, y2)
            IF nc = fc OR nc = bc THEN fy2 = 1: y2 = y2 - 1: EXIT FOR
          NEXT
        END IF
      END IF
    WEND
    LINE (x1, y1)-(x2, y2), fc, BF
    m1 = -1: m2 = -1
    FOR i = x1 TO x2
      WHILE stk >= 1499
        fill xs(stk - 1), ys(stk - 1), fc, bc: stk = stk - 1
      WEND
      IF y1 > 0 THEN
        nc = POINT(i, y1 - 1)
        IF nc <> bc AND nc <> fc THEN
          IF m1 = -1 THEN m1 = i
          nc = POINT(i + 1, y1 - 1)
          IF i = x2 OR nc = bc OR nc = fc THEN
            xs(stk) = (i - m1) \ 2 + m1: ys(stk) = y1 - 1: stk = stk + 1
            m1 = -1
          END IF
        END IF
      END IF
      IF y2 < 349 THEN
        nc = POINT(i, y2 + 1)
        IF nc <> bc AND nc <> fc THEN
          IF m2 = -1 THEN m2 = i
          nc = POINT(i + 1, y2 + 1)
          IF i = x2 OR nc = bc OR nc = fc THEN
            xs(stk) = (i - m2) \ 2 + m2: ys(stk) = y2 + 1: stk = stk + 1
            m2 = -1
          END IF
        END IF
      END IF
    NEXT i
    m1 = -1: m2 = -1
    FOR i = y1 TO y2
      WHILE stk >= 1499
        fill xs(stk - 1), ys(stk - 1), fc, bc: stk = stk - 1
      WEND
      IF x1 > 0 THEN
        nc = POINT(x1 - 1, i)
        IF nc <> bc AND nc <> fc THEN
          IF m1 = -1 THEN m1 = i
          nc = POINT(x1 - 1, i + 1)
          IF i = y2 OR nc = bc OR nc = fc THEN
            xs(stk) = x1 - 1: ys(stk) = (i - m1) \ 2 + m1: stk = stk + 1
            m1 = -1
          END IF
        END IF
      END IF
      IF x2 < 639 THEN
        nc = POINT(x2 + 1, i)
        IF nc <> bc AND nc <> fc THEN
          IF m2 = -1 THEN m2 = i
          nc = POINT(x2 + 1, i + 1)
          IF i = y2 OR nc = bc OR nc = fc THEN
            xs(stk) = x2 + 1: ys(stk) = (i - m2) \ 2 + m2: stk = stk + 1
            m2 = -1
          END IF
        END IF
      END IF
    NEXT i
  WEND
END SUB
