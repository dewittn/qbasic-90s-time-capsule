DEFINT A-Z
DECLARE SUB msg (msgs%)
DECLARE SUB CullPolygons ()
DECLARE SUB DrawLine (xs%, ys%, xe%, ye%, EdgeList() AS ANY)
DECLARE SUB DrawObject ()
DECLARE SUB EdgeFill (EdgeList() AS ANY, YLow%, YHigh%, C%)
DECLARE SUB PolyFill (x1%, y1%, x2%, y2%, x3%, y3%, C%)
DECLARE SUB RotatePoints ()
CONST True = -1, False = 0
TYPE EdgeType              'for fast polygon rasterization
    Low         AS INTEGER
    High        AS INTEGER
END TYPE
TYPE PointType
    XObject     AS INTEGER 'original cooridinate
    YObject     AS INTEGER
    ZObject     AS INTEGER
    XWorld      AS INTEGER 'rotated coodinated
    YWorld      AS INTEGER
    ZWorld      AS INTEGER
    XView       AS INTEGER 'rotated & translated coordinate
    YView       AS INTEGER
END TYPE
TYPE PolyType
    P1          AS INTEGER '3 points which make up the polygon(they point
    P2          AS INTEGER ' to the point list array)
    P3          AS INTEGER
    Culled      AS INTEGER 'True if plane not visible
    ZCenter     AS INTEGER 'Z center of polygon
    ZOrder      AS INTEGER 'Used in the shell sort of the ZCenters
    Pcolor      AS INTEGER 'used for color sequences
END TYPE
DIM SHARED EdgeList(190) AS EdgeType
DIM SHARED SineTable(359 + 90) AS LONG 'cos(x)=sin(x+90)
DIM SHARED R1, R2, R3, ox, oy, oz
DIM SHARED MaxPoints, MaxPolys
DIM SHARED s, XLow(1), XHigh(1), YLow(1), YHigh(1)
DIM SHARED lx, ly, lz

MaxPoints = 3
DATA 250,0,250, -250,0,250, -250,0,-250, 250,0,-250

MaxPolys = 1
DATA 3,2,0,2, 2,1,0,2

DIM SHARED Polys(MaxPolys) AS PolyType
DIM SHARED Points(MaxPoints) AS PointType
FOR a = 0 TO MaxPoints
    READ Points(a).XObject, Points(a).YObject, Points(a).ZObject
    X = X + Points(a).XObject: Y = Y + Points(a).YObject: Z = Z + Points(a).ZObject
NEXT
'Center the object
X = X \ (MaxPoints + 1): Y = Y \ (MaxPoints + 1): Z = Z \ (MaxPoints + 1)
FOR a = 0 TO MaxPoints
    Points(a).XObject = Points(a).XObject - X
    Points(a).YObject = Points(a).YObject - Y
    Points(a).ZObject = Points(a).ZObject - Z
NEXT
FOR a = 0 TO MaxPolys
    READ Polys(a).P1, Polys(a).P2, Polys(a).P3
    READ Polys(a).Pcolor
NEXT
 
a = 1
FOR a! = 0 TO (359 + 90) / 57.29 STEP 1 / 57.29
    SineTable(a) = SIN(a!) * 1024: a = a + 1
NEXT
R1 = 0: R2 = 0: R3 = 340
ox = 0: oy = 0: oz = 800
D1 = 0: D2 = 0: D3 = 0
s = 0: t = 1
DIM SHARED Mesg$
Mesg$ = "Game Running"
SCREEN 7, , 0, 1: CLS
PCOPY 0, 1

YHigh(0) = -32768: YHigh(1) = -32768
msgt! = TIMER + .3
DO
    IF s = 1 THEN
      IF msgt! <= TIMER THEN
        smesg = smesg + 1
        msgt! = TIMER + .3
      END IF
    END IF
    msg smesg
    SCREEN 7, , s, t: SWAP s, t: WAIT &H3DA, 8
    IF YHigh(s) <> -32768 THEN
      LINE (XLow(s), YLow(s))-(XHigh(s), YHigh(s)), 0, BF
    END IF
    RotatePoints
    CullPolygons
    XLow(s) = 32767: XHigh(s) = -32768
    YLow(s) = 32767: YHigh(s) = -32768
    DrawObject
    R1 = (R1 + D1) MOD 360: IF R1 < 0 THEN R1 = R1 + 360
    R2 = (R2 + D2) MOD 360: IF R2 < 0 THEN R2 = R2 + 360
    R3 = (R3 + D3) MOD 360: IF R3 < 0 THEN R3 = R3 + 360
    oz = oz + dz: ox = ox + dx
    IF oz < 400 THEN
        oz = 400: dz = 0
    ELSEIF oz > 1500 THEN
        oz = 1500: dz = 0
    END IF
    IF ox < -4000 THEN
        ox = -4000: dx = 0
    ELSEIF ox > 4000 THEN
        ox = 4000: dx = 0
    END IF
    IF R3 >= 355 THEN R3 = 355: D3 = 0
    IF R3 <= 300 THEN R3 = 300: D3 = 0
    a$ = UCASE$(INKEY$)
    SELECT CASE a$
    CASE "4"
        D1 = D1 - 1
    CASE "6"
        D1 = D1 + 1
    CASE "5"
        D1 = 0: D2 = 0: D3 = 0
        dz = 0
    CASE "0"
        R1 = 0: R2 = 0: R3 = 340
        D1 = 0: D2 = 0: D3 = 0
        ox = 0: oy = 0: oz = 800
        dz = 0
    CASE "2"
        D3 = D3 + 1
    CASE "8"
        D3 = D3 - 1
    CASE CHR$(27)
        EXIT DO
    CASE "9"
        dz = dz - 5
    CASE "3"
        dz = dz + 5
    CASE "C"
        SCREEN 7, , 0, 1: CLS : LINE (0, 0)-(319, 199), 0, BF: msg -1
        SCREEN 7, , 1, 0: CLS : LINE (0, 0)-(319, 199), 0, BF: msg -1
        R1 = 0: R2 = 0: R3 = 355
        D1 = 0: D2 = 0: D3 = 0
        ox = 0: oy = -30: oz = 800
        dz = 0
    END SELECT
LOOP

'"Culls" the polygons which aren't visible to the viewer. Also shades
'each polygon using Lambert's law.
SUB CullPolygons
    'This algorithm for removing hidden faces was developed by Dave Cooper.
    'There is another method, by finding the dot product of the
    'plane's normal and the viewing vector, but this algorithm is
    'much faster because of its simplicity(and lack of floating point
    'calculations).
    FOR a = 2 TO MaxPolys
        P1 = Polys(a).P1
        P2 = Polys(a).P2
        P3 = Polys(a).P3
 
        IF Points(P1).YView <= Points(P2).YView THEN
            IF Points(P3).YView < Points(P1).YView THEN
                PTop = P3
                PNext = P1
                PLast = P2
            ELSE
                PTop = P1
                PNext = P2
                PLast = P3
            END IF
        ELSE
            IF Points(P3).YView < Points(P2).YView THEN
                PTop = P3
                PNext = P1
                PLast = P2
            ELSE
                PTop = P2
                PNext = P3
                PLast = P1
            END IF
        END IF
 
        XLow = Points(PTop).XView
        YLow = Points(PTop).YView
 
        XNext = Points(PNext).XView
        XLast = Points(PLast).XView
 
        IF XNext <= XLow AND XLast >= XLow THEN
            Polys(a).Culled = True
        ELSEIF XNext >= XLow AND XLast <= XLow THEN
            Polys(a).Culled = False
        ELSE
            YNext = Points(PNext).YView
            YLast = Points(PLast).YView
            IF ((YNext - YLow) * 256&) \ (XNext - XLow) < ((YLast - YLow) * 256&) \ (XLast - XLow) THEN
                Polys(a).Culled = False
            ELSE
                Polys(a).Culled = True
            END IF
        END IF
 
    NEXT
END SUB

'Enters a line into the edge list. For each scan line, the line's
'X coordinate is found. Notice the lack of floating point math in this
'subroutine.
SUB DrawLine (xs, ys, xe, ye, EdgeList() AS EdgeType)
 
    IF ys > ye THEN SWAP xs, xe: SWAP ys, ye
 
    IF ye < 0 OR ys > 190 THEN EXIT SUB

    IF ys < 0 THEN
        xs = xs + ((xe - xs) * -ys) \ (ye - ys)
        ys = 0

    END IF
 
    xd = xe - xs
    yd = ye - ys
 
    IF yd <> 0 THEN xi = xd \ yd: xrs = ABS(xd MOD yd)
 
    xr = -yd \ 2
 
    IF ye > 190 THEN ye = 190
 
    xdirect = SGN(xd) + xi
 
    FOR Y = ys TO ye
        IF xs < EdgeList(Y).Low THEN EdgeList(Y).Low = xs
        IF xs > EdgeList(Y).High THEN EdgeList(Y).High = xs
 
        xr = xr + xrs
        IF xr > 0 THEN
            xr = xr - yd
            xs = xs + xdirect
        ELSE
            xs = xs + xi
        END IF
    NEXT
 
END SUB

SUB DrawObject
 
    'Find the center of each visible polygon, and prepare the order list.
    NumPolys = 0
    FOR a = 2 TO MaxPolys
        IF Polys(a).Culled = False THEN 'is this polygon visible?
            Polys(NumPolys).ZOrder = a
            NumPolys = NumPolys + 1
            Polys(a).ZCenter = Points(Polys(a).P1).ZWorld + Points(Polys(a).P2).ZWorld + Points(Polys(a).P3).ZWorld
        END IF
    NEXT
    'Sort the visible polygons by their Z center using a shell sort.
    NumPolys = NumPolys - 1
    Mid = (NumPolys + 1) \ 2
    DO
        FOR a = 0 TO NumPolys - Mid
            CompareLow = a
            CompareHigh = a + Mid
            DO WHILE Polys(Polys(CompareLow).ZOrder).ZCenter < Polys(Polys(CompareHigh).ZOrder).ZCenter
                SWAP Polys(CompareLow).ZOrder, Polys(CompareHigh).ZOrder
                CompareHigh = CompareLow
                CompareLow = CompareLow - Mid
                IF CompareLow < 0 THEN EXIT DO
            LOOP
        NEXT
        Mid = Mid \ 2
    LOOP WHILE Mid > 0
    'Plot the visible polygons.
      FOR Z = 0 TO 1
          P1 = Polys(Z).P1: P2 = Polys(Z).P2: P3 = Polys(Z).P3
          PolyFill (Points(P1).XView), (Points(P1).YView), (Points(P2).XView), (Points(P2).YView), (Points(P3).XView), (Points(P3).YView), (Polys(Z).Pcolor)
      NEXT
    FOR Z = 0 TO NumPolys
       a = Polys(Z).ZOrder 'which polygon do we plot?
       P1 = Polys(a).P1: P2 = Polys(a).P2: P3 = Polys(a).P3
       PolyFill (Points(P1).XView), (Points(P1).YView), (Points(P2).XView), (Points(P2).YView), (Points(P3).XView), (Points(P3).YView), (Polys(a).Pcolor)
    NEXT
    'FOR Z = 0 TO MaxPoints
    '  PSET (Points(Z).XView, Points(Z).YView), 15
    'NEXT Z
END SUB

SUB EdgeFill (EdgeList() AS EdgeType, YLow, YHigh, C)
    FOR a = YLow TO YHigh
        LINE (EdgeList(a).Low, a)-(EdgeList(a).High, a), C
    NEXT
END SUB

SUB msg (msgs)
SHARED Mesg$
IF msgs <= 0 THEN msgs = 1

tryagain:
IF LEN(Mesg$) < 40 THEN
  Mesg$ = Mesg$ + " *** " + Mesg$
  GOTO tryagain
ELSE
    Dmsg$ = Mesg$ + " *** " + Mesg$
    IF msgs >= LEN(Mesg$) + 6 THEN msgs = 1
    Dmsg$ = MID$(Dmsg$, msgs, 40)
    Dmsg$ = LEFT$(Dmsg$, 40)
    LOCATE 25, 1
    COLOR 9
    PRINT Dmsg$;
END IF
END SUB

'Draws a polygon to the screen. Simply finds the start and stop X
'coordinates for each scan line within the polygon and uses the
'LINE command for filling.
SUB PolyFill (x1, y1, x2, y2, x3, y3, C) 'for QB 4.5 guys
 
    'find lowest and high X & Y coordinates
    IF y1 < y2 THEN YLow = y1 ELSE YLow = y2
    IF y3 < YLow THEN YLow = y3
    IF y1 > y2 THEN YHigh = y1 ELSE YHigh = y2
    IF y3 > YHigh THEN YHigh = y3
 
    IF x1 < x2 THEN XLow = x1 ELSE XLow = x2
    IF x3 < XLow THEN XLow = x3
    IF x1 > x2 THEN XHigh = x1 ELSE XHigh = x2
    IF x3 > XHigh THEN XHigh = x3
 
    IF YLow < 0 THEN YLow = 0
    IF YHigh > 190 THEN YHigh = 190
 
    IF XLow < XLow(s) THEN XLow(s) = XLow
    IF XHigh > XHigh(s) THEN XHigh(s) = XHigh
 
    IF YLow < YLow(s) THEN YLow(s) = YLow
    IF YHigh > YHigh(s) THEN YHigh(s) = YHigh
 

    'check for polygons which cannot be visible
    IF YHigh < 0 OR YLow > 190 OR XLow > 319 OR XHigh < 0 THEN EXIT SUB
 
    'initialize the edge list
    FOR a = YLow TO YHigh
        EdgeList(a).Low = 32767
        EdgeList(a).High = -32768
    NEXT
 
    'Remember the lowest & highest X and Y coordinates drawn to the
    'screen for later erasing
 
    'Find the start and stop X coodinates for each scan line
   
    IF C = 0 THEN
      LINE (x1, y1)-(x2, y2), 15
      LINE (x2, y2)-(x3, y3), 15
      LINE (x3, y3)-(x1, y1), 15
    ELSE
      DrawLine (x1), (y1), (x2), (y2), EdgeList()
      DrawLine (x2), (y2), (x3), (y3), EdgeList()
      DrawLine (x3), (y3), (x1), (y1), EdgeList()
      EdgeFill EdgeList(), YLow, YHigh, C
      'LINE (x1, y1)-(x2, y2), 7
      'LINE (x2, y2)-(x3, y3), 7
      'LINE (x3, y3)-(x1, y1), 7
    END IF
END SUB

'Rotates the points of the object and the object's normals.
'Avoids floating point math for speed.
SUB RotatePoints
 
    'lookup the sine and cosine of each angle...
    s1& = SineTable(R1): c1& = SineTable(R1 + 90)
    s2& = SineTable(R2): c2& = SineTable(R2 + 90)
    s3& = SineTable(R3): c3& = SineTable(R3 + 90)
 
    'rotate the points of the object
    FOR a = 0 TO MaxPoints
        xo = Points(a).XObject
        yo = Points(a).YObject
        zo = Points(a).ZObject
       
        x1 = (xo * c1& - zo * s1&) \ 1024 'yaw
        z1 = (xo * s1& + zo * c1&) \ 1024

        z3 = (z1 * c3& - yo * s3&) \ 1024 + oz 'pitch
        y2 = (z1 * s3& + yo * c3&) \ 1024

        x2 = (x1 * c2& + y2 * s2&) \ 1024 + ox 'roll
        y3 = (y2 * c2& - x1 * s2&) \ 1024 + oy
       
        Points(a).XView = 160 + (x2 * 400&) \ z3
        Points(a).YView = 100 + (y3 * 300&) \ z3
 
        Points(a).XWorld = x2
        Points(a).YWorld = y3
        Points(a).ZWorld = z3
    NEXT
    EXIT SUB
 
END SUB

