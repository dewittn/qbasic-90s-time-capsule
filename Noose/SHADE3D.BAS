'Shaded 3-D animation with shadows [solid5.bas] for QB4.5/PDS
'By Rich Geldreich 1992
'Notes...
'   This version uses some floating  point math in the initialization
'code for shading, but after initialization floating point math is not
'used at all.
'   The  shading  imploys Lambert's Law to determine the intensity of
'each visible polygon.  Three simple  lookup tables are calculated at
'initialization time  which  are  used  to  eliminate  multiples  and
'divides in the main animation code.
'   The hidden face  detection  algorithm  was  made  by Dave Cooper.
'It's fast, and does not require any multiples and divides under most
'cases.  The "standard" way of detecting hidden faces, by finding the
'dot product of the normal of each polygon and  the  viewing  vector,
'was not just good (or fast) enough for me!
'   The PolyFill routine is the major  bottleneck  of  this  program.
'QB's  LINE  command isn't as fast as I would like it to be...  On my
'286-10, the speed isn't that bad (after all, this is all-QB!).  On a
'386 or 486, this thing should fly...  [hopefully]
'   The  shadows  are  calculated by projecting a line with the light
'source's vector through each of the points on the solid.  Where this
'line hits the ground  plane(which  has  a  constant Y coordinate) is
'where the new shadow point is plotted.
'   This program is 100% public domain- but  of  course  please  give
'some credit if you use anything from this program.  Thanks!
DEFINT A-Z
DECLARE SUB CullPolygons ()
DECLARE SUB DrawLine (xs%, ys%, xe%, ye%, EdgeList() AS ANY)
DECLARE SUB DrawObject ()
DECLARE SUB DrawShadows ()
DECLARE SUB EdgeFill (EdgeList() AS ANY, YLow%, YHigh%, C%)
DECLARE SUB FindNormals ()
DECLARE SUB PolyFill (x1%, y1%, x2%, y2%, x3%, y3%, C%)
DECLARE SUB RotatePoints ()
DECLARE SUB ShadePolygons ()
 
CONST True = -1, False = 0
 
TYPE EdgeType              'for fast polygon rasterization
    Low         AS INTEGER
    High        AS INTEGER
END TYPE
TYPE PointType
    XObject     AS INTEGER 'original cooridinate
    YObject     AS INTEGER
    ZObject     AS INTEGER 'rotated coodinated
    XWorld      AS INTEGER
    YWorld      AS INTEGER
    ZWorld      AS INTEGER
    XView       AS INTEGER 'rotated & translated coordinate
    YView       AS INTEGER
    XShadow     AS INTEGER 'coordinates projected onto the ground plane
    YShadow     AS INTEGER
END TYPE
TYPE PolyType
    P1          AS INTEGER '3 points which make up the polygon(they point
    P2          AS INTEGER ' to the point list array)
    P3          AS INTEGER
    Culled      AS INTEGER 'True if plane not visible
    ZCenter     AS INTEGER 'Z center of polygon
    ZOrder      AS INTEGER 'Used in the shell sort of the ZCenters
    Intensity   AS INTEGER 'Intensity of polygon
    WorldXN     AS INTEGER 'Contains the coordinates of the point
    WorldYN     AS INTEGER ' which is both perpendicular and a constant
    WorldZN     AS INTEGER ' distance from the polygon
    NormalX     AS INTEGER 'Normal of polygon -128 to 128
    NormalY     AS INTEGER ' (used for fast Lambert shading)
    NormalZ     AS INTEGER
END TYPE
TYPE LineType
    P1          AS INTEGER 'Used for shadow projection
    P2          AS INTEGER
END TYPE
 
DIM SHARED EdgeList(199) AS EdgeType
DIM SHARED SineTable(359 + 90) AS LONG 'cos(x)=sin(x+90)
DIM SHARED R1, R2, R3, ox, oy, oz
DIM SHARED MaxPoints, MaxPolys, MaxLines
 
DIM SHARED lines(100) AS LineType
DIM SHARED Polys(100) AS PolyType
DIM SHARED Points(100) AS PointType
DIM SHARED lx(256), ly(256), lz(256)   'lookup tables for Lambert shading

DIM SHARED s, XLow(1), XHigh(1), YLow(1), YHigh(1)
DIM SHARED ShadowXLow(1), ShadowXHigh(1), ShadowYLow(1), ShadowYHigh(1)
DIM SHARED lx, ly, lz

CLS
PRINT "QuickBASIC/PDS 3-D Solid Animation": PRINT "By Rich Geldreich 1992"
PRINT : PRINT "Keys: [Turn NUMLOCK on]"
PRINT "Left.....................Angle 1 -"

PRINT "Right....................Angle 1 +"
PRINT "Up.......................Angle 2 -"
PRINT "Down.....................Angle 2 +"
PRINT "-........................Angle 3 -"
PRINT "+........................Angle 3 +"
PRINT "5........................Rotation Stop"
PRINT "0........................Rotation Reset"
PRINT "Up Arrow.................Forward"
PRINT "Down Arrow...............Backward"
PRINT "Left Arrow...............Left"
PRINT "Right Arrow..............Right"
PRINT : PRINT "Initializing..."
 
MaxPoints = 4  'Pyramid.
'Points follow...
DATA -100,0,100, -100,0,-100, 100,0,-100, 100,0,100, 0,-290,0
MaxPolys = 5
'Polygons follow (they must be specified in counterclockwise
'order for correct hidden face removal and shading)
DATA 4,0,3, 4,3,2, 4,1,0, 4,2,1, 3,0,1, 3,1,2
MaxLines = 7
'Lines follow for shadow computation...
DATA 4,0, 4,1, 4,2, 4,3, 0,1, 1,2, 2,3, 3,0
 
'MaxPoints = 7 'Cube.
'DATA -100,100,100
'DATA 100,100,100
'DATA 100,100,-100
'DATA -100,100,-100
'DATA -100,-100,100
'DATA 100,-100,100
'DATA 100,-100,-100
'DATA -100,-100,-100
'MaxPolys = 11
'DATA 5,4,0, 5,0,1
'DATA 6,2,3, 3,7,6
'DATA 6,5,1, 6,1,2
'DATA 7,0,4, 7,3,0
'DATA 6,7,4, 6,4,5
'DATA 0,3,2, 1,0,2
'MaxLines = 11
'DATA 0,1, 1,2, 2,3, 3,0
'DATA 4,5, 5,6, 6,7, 7,4
'DATA 4,0, 5,1, 6,2, 7,3
 
'MaxPoints = 15 'Wierd pencil-like shape...
'DATA 0,0,0, 250,0,0, 400,40,0, 400,60,0, 250,100,0, 0,100,0,-20,90,0, -20,10,0
'DATA 0,0,-50, 250,0,-50, 400,40,-50, 400,60,-50, 250,100,-50, 0,100,-50, -20,90,-50, -20,10,-50
'MaxPolys = 27
'DATA 1,0,7, 1,7,2, 2,7,6, 2,6,3, 3,6,4, 4,6,5
'DATA 9,15,8, 9,10,15, 10,14,15, 10,11,14, 11,13,14, 11,12,13
'DATA 8,7,0, 8,15,7, 8,0,1, 9,8,1, 9,1,2, 10,9,2, 10,2,3, 11,10,3
'DATA 12,11,4, 11,3,4, 4,5,13, 4,13,12
'DATA 5,6,14, 5,14,13, 14,6,7, 14,7,15
'MaxLines = 23
'DATA 0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,7, 7,0
'DATA 8,9, 9,10, 10,11, 11,12, 12,13, 13,14, 14,15, 15,0
'DATA 0,8, 1,9, 2,10, 3,11, 4,12, 5,13, 6,14, 7,15

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
NEXT
FOR a = 0 TO MaxLines
    READ lines(a).P1, lines(a).P2
NEXT
 
'Precalculate the normal point of each polygon for fast Lambert shading

FindNormals
 
'Precalculate the sine table
a = 0

FOR a! = 0 TO (359 + 90) / 57.29 STEP 1 / 57.29
    SineTable(a) = SIN(a!) * 1024: a = a + 1
NEXT
 
'Some light source configurations won't work that great!
l1 = 70: l2 = 40           'light source's spherical coordinates
a1! = l1 / 57.29: a2! = l2 / 57.29

s1! = SIN(a1!): c1! = COS(a1!)
s2! = SIN(a2!): c2! = COS(a2!)
lx = 128 * s1! * c2!        'convert spherical coordinates to a vector
ly = 128 * s1! * s2!        'scale up by 128 for integer math
lz = 128 * c1!
 
FOR a = -128 TO 128         'precalculate the three light source tables
    lx(a + 128) = lx * a    'for fast Lambert shading
    ly(a + 128) = ly * a
    lz(a + 128) = lz * a
NEXT
 
PRINT "Strike a key...": DO: LOOP WHILE INKEY$ = ""
 
R1 = 0: R2 = 0: R3 = 0      'three angles of rotation
ox = 0: oy = -50: oz = 1100 'object's origin (this program cannot currently
                            'handle the object when it goes behind theviewer!)
s = 1: t = 0
 
SCREEN 7, , 0, 0
OUT &H3C8, 0                'set 16 shades
FOR a = 0 TO 15
    OUT &H3C9, (a * 34) \ 10
    OUT &H3C9, (a * 212) \ 100
    OUT &H3C9, (a * 4) \ 10
    IF a = 7 THEN OUT &H3C7, 16: OUT &H3C8, 16
NEXT
LINE (0, 100)-(319, 199), 9, BF
LINE (0, 0)-(319, 99), 3, BF
SCREEN 7, , 1, 0
LINE (0, 100)-(319, 199), 9, BF
LINE (0, 0)-(319, 99), 3, BF
 
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
            LINE (XLow(s), YLow(s))-(XHigh(s), YHigh(s)), 3, BF
        ELSEIF YLow(s) < 100 THEN
            LINE (XLow(s), YLow(s))-(XHigh(s), 99), 3, BF
            LINE (XLow(s), 100)-(XHigh(s), YHigh(s)), 9, BF
        ELSE
            LINE (XLow(s), YLow(s))-(XHigh(s), YHigh(s)), 9, BF
        END IF
    END IF
    IF ShadowYHigh(s) <> -32768 THEN
        LINE (ShadowXLow(s), ShadowYLow(s))-(ShadowXHigh(s), ShadowYHigh(s)), 9, BF
    END IF
    RotatePoints
    CullPolygons
    ShadePolygons
 
    XLow(s) = 32767: XHigh(s) = -32768
    YLow(s) = 32767: YHigh(s) = -32768
    DrawShadows
    DrawObject
 
    R1 = (R1 + D1) MOD 360: IF R1 < 0 THEN R1 = R1 + 360
    R2 = (R2 + D2) MOD 360: IF R2 < 0 THEN R2 = R2 + 360
    R3 = (R3 + D3) MOD 360: IF R3 < 0 THEN R3 = R3 + 360
    oz = oz + dz: ox = ox + dx
    IF oz < 600 THEN
        oz = 600: dz = 0
    ELSEIF oz > 8000 THEN
        oz = 8000: dz = 0
    END IF
    IF ox < -4000 THEN
        ox = -4000: dx = 0
    ELSEIF ox > 4000 THEN
        ox = 4000: dx = 0
    END IF
    a$ = INKEY$
    SELECT CASE a$
    CASE "4"
        D1 = D1 - 2
    CASE "6"
        D1 = D1 + 2
    CASE "8"
        D2 = D2 - 2
    CASE "2"
        D2 = D2 + 2
    CASE "5"

        D1 = 0: D2 = 0: D3 = 0
    CASE "0"
        R1 = 0: R2 = 0: R3 = 0
        D1 = 0: D2 = 0: D3 = 0
    CASE "+"
        D3 = D3 + 2
    CASE "-"
        D3 = D3 - 2
    CASE CHR$(27)
        END
    CASE CHR$(0) + CHR$(72)
        dz = dz - 20
    CASE CHR$(0) + CHR$(80)
        dz = dz + 20
    CASE CHR$(0) + CHR$(77)
        dx = dx - 20
    CASE CHR$(0) + CHR$(75)
        dx = dx + 20
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
 
    IF ye < 0 OR ys > 199 THEN EXIT SUB

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
        PolyFill (Points(P1).XView), (Points(P1).YView), (Points(P2).XView), (Points(P2).YView), (Points(P3).XView), (Points(P3).YView), (Polys(a).Intensity)
    NEXT
END SUB

SUB DrawShadows
    YLow = 32767: YHigh = -32768
    XLow = 32767: XHigh = -32768
    FOR a = 0 TO MaxPoints
        'Project the 3-D point onto the ground plane...
        temp& = (Points(a).YWorld - 200)
        X = Points(a).XWorld - (temp& * lx) \ ly
        Y = 200 'ground plane has a constant Y coordinate
        Z = Points(a).ZWorld - (temp& * lz) \ ly
        'Put the point into perspective
        xTemp = 160 + (X * 400&) \ Z
        yTemp = 100 + (Y * 300&) \ Z
 
        Points(a).XShadow = xTemp
        Points(a).YShadow = yTemp
 
        'Find the lowest & highest X Y coordinates
        IF yTemp < YLow THEN YLow = yTemp

        IF yTemp > YHigh THEN YHigh = yTemp
        IF xTemp < XLow THEN XLow = xTemp
        IF xTemp > XHigh THEN XHigh = xTemp
    NEXT
 
    'Store lowest & highest coordinates for later erasing...
    ShadowXLow(s) = XLow: ShadowYLow(s) = YLow

    ShadowXHigh(s) = XHigh: ShadowYHigh(s) = YHigh
    IF XHigh < 0 OR XLow > 319 OR YLow > 199 OR YHigh < 0 THEN EXIT SUB
    IF YHigh > 199 THEN YHigh = 199
    IF YLow < 0 THEN YLow = 0
 
    'Initialize the edge list
    FOR a = YLow TO YHigh
        EdgeList(a).Low = 32767
        EdgeList(a).High = -32768
    NEXT
 
    'Enter the lines into the edge list
    FOR a = 0 TO MaxLines
        P1 = lines(a).P1
        P2 = lines(a).P2
        DrawLine (Points(P1).XShadow), (Points(P1).YShadow), (Points(P2).XShadow), (Points(P2).YShadow), EdgeList()
        'LINE ((Points(P1).XShadow),(Points(P1).YShadow))-((Points(P2).XShadow), (Points(P2).YShadow)), 0
    NEXT
 
    'Fill the polygon
    EdgeFill EdgeList(), YLow, YHigh, 3
 
END SUB

SUB EdgeFill (EdgeList() AS EdgeType, YLow, YHigh, C)
    FOR a = YLow TO YHigh
        LINE (EdgeList(a).Low, a)-(EdgeList(a).High, a), C
    NEXT
END SUB

'This routine initializes the data required by the fast Lambert shading
'algorithm. It calculates the point which is both perpendicular
'and a constant distance from each polygon and stores it. This point
'is then rotated with the rest of the points. When it comes time for
'shading, the normal to the polygon is looked up in a simple lookup
'table for maximum speed.
SUB FindNormals
    FOR a = 0 TO MaxPolys
        P1 = Polys(a).P1: P2 = Polys(a).P2: P3 = Polys(a).P3
 
        'find the vectors of 2 lines inside the polygon
        ax! = Points(P2).XObject - Points(P1).XObject
        ay! = Points(P2).YObject - Points(P1).YObject
        az! = Points(P2).ZObject - Points(P1).ZObject
 
        bx! = Points(P3).XObject - Points(P2).XObject
        by! = Points(P3).YObject - Points(P2).YObject
        bz! = Points(P3).ZObject - Points(P2).ZObject
 
        'find the cross product of the 2 vectors
        nx! = ay! * bz! - az! * by!
        ny! = az! * bx! - ax! * bz!
        nz! = ax! * by! - ay! * bx!
 
        'normalize the vector so it ranges from -1 to 1
        M! = SQR(nx! * nx! + ny! * ny! + nz! * nz!)
        IF M! <> 0 THEN nx! = nx! / M!: ny! = ny! / M!: nz! = nz! / M!
        'store the vector for later rotation(notice that it is scaled
        'up by 128 so it can be stored as an integer variable)
        Polys(a).WorldXN = nx! * 128 + Points(P1).XObject
        Polys(a).WorldYN = ny! * 128 + Points(P1).YObject
        Polys(a).WorldZN = nz! * 128 + Points(P1).ZObject
    NEXT
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
    DrawLine (x1), (y1), (x2), (y2), EdgeList()
    DrawLine (x2), (y2), (x3), (y3), EdgeList()
    DrawLine (x3), (y3), (x1), (y1), EdgeList()
    EdgeFill EdgeList(), YLow, YHigh, C
 
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
        GOSUB Rotate3D
 
        Points(a).XView = 160 + (x2 * 400&) \ z3
        Points(a).YView = 100 + (y3 * 300&) \ z3
        'IF y3 > 300 THEN STOP
 
        Points(a).XWorld = x2
        Points(a).YWorld = y3
        Points(a).ZWorld = z3
    NEXT
    'rotate the normals of each polygon...
    FOR a = 0 TO MaxPolys
        xo = Polys(a).WorldXN
        yo = Polys(a).WorldYN
        zo = Polys(a).WorldZN
        GOSUB Rotate3D
        P1 = Polys(a).P1
        'unorigin the point
        x2 = x2 - Points(P1).XWorld
        y3 = y3 - Points(P1).YWorld
        z3 = z3 - Points(P1).ZWorld
        'check the bounds just in case of a round off error
        IF x2 < -128 THEN x2 = -128 ELSE IF x2 > 128 THEN x2 = 128
        IF y3 < -128 THEN y3 = -128 ELSE IF y3 > 128 THEN y3 = 128
        IF z3 < -128 THEN z3 = -128 ELSE IF z3 > 128 THEN z3 = 128
        'store the normal back; it's now ready for the shading
        'calculations (which are simplistic now)
        Polys(a).NormalX = x2 + 128
        Polys(a).NormalY = y3 + 128
        Polys(a).NormalZ = z3 + 128
    NEXT
    EXIT SUB
 
Rotate3D:
    x1 = (xo * c1& - zo * s1&) \ 1024 'yaw
    z1 = (xo * s1& + zo * c1&) \ 1024
 
    z3 = (z1 * c3& - yo * s3&) \ 1024 + oz 'pitch
    y2 = (z1 * s3& + yo * c3&) \ 1024
 
    x2 = (x1 * c2& + y2 * s2&) \ 1024 + ox 'roll
    y3 = (y2 * c2& - x1 * s2&) \ 1024 + oy
 
RETURN
END SUB

'Shades the polygons using Lambert shading. Notice the total lack of
'floating point math- only 1 divide is required for each polygon shaded.
'(This divide can be eliminated, but the shading won't be as accurate.)
SUB ShadePolygons
    FOR a = 0 TO MaxPolys
        IF Polys(a).Culled = False THEN

         'lookup the polygon's normal for shading
         '(128*128)\15 = 1092
         Intensity = (lx(Polys(a).NormalX) + ly(Polys(a).NormalY) + lz(Polys(a).NormalZ)) \ 1092
         IF Intensity < 0 THEN Intensity = 0
         Intensity = Intensity + 5
         IF Intensity > 15 THEN Intensity = 15

         Polys(a).Intensity = Intensity
        END IF
    NEXT
END SUB

