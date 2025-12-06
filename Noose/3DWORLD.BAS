DEFINT A-Z
DECLARE SUB CullPolygons ()
DECLARE SUB DrawLine (xs%, ys%, xe%, ye%, EdgeList() AS ANY)
DECLARE SUB DrawObject ()
DECLARE SUB DrawShadows ()
DECLARE SUB EdgeFill (EdgeList() AS ANY, YLow%, YHigh%, c%)
DECLARE SUB FindNormals ()
DECLARE SUB PolyFill (x1%, y1%, x2%, y2%, x3%, y3%, c%)
DECLARE SUB RotatePoints ()
DECLARE SUB ShadePolygons ()
 
CONST True = -1, False = 0
 
TYPE EdgeType              'for fast polygon rasterization
    Low         AS INTEGER
    High        AS INTEGER
END TYPE
TYPE PointType
    XObject     AS LONG 'original cooridinate
    YObject     AS LONG
    ZObject     AS LONG 'rotated coodinated
    XWorld      AS LONG
    YWorld      AS LONG
    ZWorld      AS LONG
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
    Pcolor      AS INTEGER
END TYPE
 
DIM SHARED EdgeList(199) AS EdgeType
DIM SHARED SineTable(359 + 90) AS LONG
DIM SHARED RY, oy, oz
DIM SHARED MaxPoints, MaxPolys
 
DIM SHARED Polys(100) AS PolyType
DIM SHARED Points(100) AS PointType

DIM SHARED s, XLow(1), XHigh(1), YLow(1), YHigh(1)

CLS
MaxPoints = 7 'Cube.
DATA -100,100,100
DATA 100,100,100
DATA 100,100,-100
DATA -100,100,-100
DATA -100,-100,100
DATA 100,-100,100
DATA 100,-100,-100
DATA -100,-100,-100
MaxPolys = 11
DATA 5,4,0, 5,0,1
DATA 6,2,3, 3,7,6
DATA 6,5,1, 6,1,2
DATA 7,0,4, 7,3,0
DATA 6,7,4, 6,4,5
DATA 0,3,2, 1,0,2

FOR a = 0 TO MaxPoints
    READ Points(a).XObject, Points(a).YObject, Points(a).ZObject
NEXT
FOR a = 0 TO MaxPolys
    READ Polys(a).P1, Polys(a).P2, Polys(a).P3
    Polys(a).Pcolor = 15
NEXT
 
'Precalculate the sine table
a = 0
FOR a! = 0 TO (359 + 90) / 57.29 STEP 1 / 57.29
    SineTable(a) = SIN(a!) * 1024: a = a + 1
NEXT
 
RY = 0: oz = 1000

s = 1: t = 0
 
SCREEN 7, , 0, 0
LINE (0, 100)-(319, 199), 7, BF
LINE (0, 0)-(319, 99), 8, BF
SCREEN 7, , 1, 0
LINE (0, 100)-(319, 199), 7, BF
LINE (0, 0)-(319, 99), 8, BF
 
YHigh(0) = -32768: ShadowYHigh(0) = -32768
YHigh(1) = -32768: ShadowYHigh(1) = -32768
DO
    'Flip active and work pages so user doesn't see our messy drawing
    SCREEN 7, , s, t: SWAP s, t

    'Wait for vertical retrace to reduce flicker
    WAIT &H3DA, 8
 
    'Erase the old image from the screen
    IF YHigh(s) <> -32768 THEN
        IF YHigh(s) < 100 THEN
            LINE (XLow(s), YLow(s))-(XHigh(s), YHigh(s)), 7, BF
        ELSEIF YLow(s) < 100 THEN
            LINE (XLow(s), YLow(s))-(XHigh(s), 99), 8, BF
            LINE (XLow(s), 100)-(XHigh(s), YHigh(s)), 7, BF
        ELSE
            LINE (XLow(s), YLow(s))-(XHigh(s), YHigh(s)), 8, BF
        END IF
    END IF
    
    RotatePoints
    IF Wire = False THEN CullPolygons
 
    XLow(s) = 32767: XHigh(s) = -32768
    YLow(s) = 32767: YHigh(s) = -32768
    DrawObject
    LOCATE 25, 1: PRINT "Angle: "; RY; "Distance: "; oz; "Speed:"; -dz;
   

    RY = (RY + D) MOD 360: IF RY < 0 THEN RY = RY + 360
    oz = oz + dz: oy = oy + dy
    IF oz < -8000 THEN
        oz = -8000: dz = 0
    ELSEIF oz > 8000 THEN
        oz = 8000: dz = 0
    END IF
   
    a$ = INKEY$
    SELECT CASE a$
    CASE "4"
        D = D - 1
    CASE "6"
        D = D + 1
    CASE "8"
        dz = dz - 5
    CASE "2"
        dz = dz + 5
    CASE "5"
        D = 0: dz = 0: dy = 0
    CASE "0"
       oy = 0: dy = 0: oz = 1000: dz = 0
       D = 0: RY = 0
    CASE "w"
      IF Wire = False THEN Wire = True ELSE Wire = False
      IF Wire = True THEN
         FOR a = 0 TO MaxPolys
            Polys(a).Culled = False
         NEXT a
      END IF
    CASE CHR$(27)
        END
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
    FOR a = 0 TO MaxPolys
        P1 = Polys(a).P1
        P2 = Polys(a).P2
        P3 = Polys(a).P3
 
        IF Points(P1).ZWorld < 1 OR Points(P2).ZWorld < 1 OR Points(P3).ZWorld < 1 THEN
          Polys(a).Culled = True
          GOTO skipcull
        END IF

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
skipcull:
    NEXT
END SUB

'Enters a line into the edge list. For each scan line, the line's
'X coordinate is found. Notice the lack of floating point math in this
'subroutine.
SUB DrawLine (xs, ys, xe, ye, EdgeList() AS EdgeType)
 
    IF ys > ye THEN SWAP xs, xe: SWAP ys, ye
 
    IF ye < 0 OR ys > 199 THEN EXIT SUB
    IF xs < 0 THEN xs = 0: IF xe > 319 THEN xe = 319
    IF ys < 0 THEN ys = 0: IF ye > 199 THEN ye = 199

    IF ys < 0 THEN
        xs = xs + ((xe - xs) * -ys) \ (ye - ys)
        ys = 0
    END IF
 
    xd = xe - xs
    yd = ye - ys
 
    IF yd <> 0 THEN xi = xd \ yd: xrs = ABS(xd MOD yd)
 
    xr = -yd \ 2
 
    IF ye > 199 THEN ye = 199


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
    FOR a = 0 TO MaxPolys
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
    FOR Z = 0 TO NumPolys
        a = Polys(Z).ZOrder 'which polygon do we plot?
        P1 = Polys(a).P1: P2 = Polys(a).P2: P3 = Polys(a).P3
        PolyFill (Points(P1).XView), (Points(P1).YView), (Points(P2).XView), (Points(P2).YView), (Points(P3).XView), (Points(P3).YView), (Polys(a).Pcolor)
    NEXT
END SUB

SUB EdgeFill (EdgeList() AS EdgeType, YLow, YHigh, c)
    FOR a = YLow TO YHigh
        LINE (EdgeList(a).Low, a)-(EdgeList(a).High, a), c
    NEXT
END SUB

'Draws a polygon to the screen. Simply finds the start and stop X
'coordinates for each scan line within the polygon and uses the
'LINE command for filling.
SUB PolyFill (x1, y1, x2, y2, x3, y3, c) 'for QB 4.5 guys
    SHARED Wire

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
    IF YHigh > 199 THEN YHigh = 199
 
    IF XLow < XLow(s) THEN XLow(s) = XLow
    IF XHigh > XHigh(s) THEN XHigh(s) = XHigh
 
    IF YLow < YLow(s) THEN YLow(s) = YLow
    IF YHigh > YHigh(s) THEN YHigh(s) = YHigh
 

    'check for polygons which cannot be visible
    IF YHigh < 0 OR YLow > 199 OR XLow > 319 OR XHigh < 0 THEN EXIT SUB
 
    'initialize the edge list
    FOR a = YLow TO YHigh
        EdgeList(a).Low = 32767
        EdgeList(a).High = -32768
    NEXT
 
    'Remember the lowest & highest X and Y coordinates drawn to the
    'screen for later erasing
 
    'Find the start and stop X coodinates for each scan line
    IF Wire = False THEN
      DrawLine (x1), (y1), (x2), (y2), EdgeList()
      DrawLine (x2), (y2), (x3), (y3), EdgeList()
      DrawLine (x3), (y3), (x1), (y1), EdgeList()
      EdgeFill EdgeList(), YLow, YHigh, c
    ELSE
      LINE (x1, y1)-(x2, y2), c
      LINE -(x3, y3), c
      LINE -(x1, y1), c
    END IF

END SUB

'Rotates the points of the object and the object's normals.
'Avoids floating point math for speed.
SUB RotatePoints
   
    'lookup the sine and cosine of each angle...
    s& = SineTable(RY): c& = SineTable(RY + 90)
 
    'rotate the points of the object
    FOR a = 0 TO MaxPoints
        xo& = Points(a).XObject
        yo& = Points(a).YObject
        zo& = Points(a).ZObject
   
        yo& = yo& + oy: zo& = zo& + oz
        xn& = (zo& * s& + xo& * c&) \ 1024
        yn& = yo&
        zn& = (zo& * c& - xo& * s&) \ 1024
         
        IF zn& <> 0 THEN
          xv& = 160 + (xn& * 400&) \ zn&
          yv& = 100 + (yn& * 300&) \ zn&
          IF xv& > -1000 AND yv& > -1000 AND xv& < 1000 AND yv& < 1000 THEN
            Points(a).XView = INT(xv&)
            Points(a).YView = INT(yv&)
          END IF
        END IF
       
        Points(a).XWorld = xn&
        Points(a).YWorld = yn&
        Points(a).ZWorld = zn&
    NEXT
END SUB

