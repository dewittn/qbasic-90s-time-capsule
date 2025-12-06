DEFINT A-Z
DECLARE SUB vline (xs%, ys%, xe%, ye%, c%)
DECLARE SUB memsw (n)
DECLARE SUB vpset (x!, y!, c!)
DECLARE FUNCTION vscreen (mode)
DIM SHARED maxx, maxy, bpp, cp, vms
maxx = 800: maxy = 600
bpp = 8: vms = 0
lenn = 0
WHILE D <> 999
   lenn = lenn + 1
   READ D
WEND
lenn = lenn - 1
RESTORE
DIM SHARED a(lenn - 1)
DEF SEG = VARSEG(a(0))
FOR i = 0 TO lenn - 1
    READ D
    POKE VARPTR(a(0)) + i, D
NEXT i
IF vscreen(&H103) = 1 THEN
   PRINT "Vesa mode not supported: Make sure vesa bios is loaded.": END
END IF
cp = 0

vline 10, 10, 100, 100, 4
vline 100, 100, 319, 199, 1


memsw 0
DEF SEG
SLEEP
SCREEN 2: SCREEN 0
vms = 0
SYSTEM

DATA &h55,&h8B,&hEC,&h8B,&h5E,&hC,&h8B,&h7,&h8B,&h5E,&h8
DATA &h8B,&hF,&h8B,&h5E,&h6,&h8B,&h17,&h50,&h8B,&h5E,&hA
DATA &h8B,&h7,&h89,&hC3,&h58,&hCD,&h10,&h53,&h8B,&h5E,&hC
DATA &h89,&h7,&h5B,&h89,&hD8,&h8B,&h5E,&hA,&h89,&h7,&h8B
DATA &h5E,&h8,&h89,&hF,&h8B,&h5E,&h6,&h89,&h17,&h5D,&hCA
DATA &h8,&h0
DATA 999

SUB memsw (n)
AX = &H4F05: BX = &H0: CX = &H0: DX = n
DEF SEG = VARSEG(a(0))
CALL ABSOLUTE(AX, BX, CX, DX, VARPTR(a(0)))
cp = n: vms = 0
END SUB

SUB vline (xs, ys, xe, ye, c)
    ctemp! = c

    IF ys > ye THEN SWAP ys, ye
    IF xs > xe THEN SWAP xs, xe

    IF ye < 0 OR ys > maxy THEN EXIT SUB

    IF ys < 0 THEN
        xs = xs + ((xe - xs) * -ys) \ (ye - ys)
        ys = 0
    END IF

    xd = xe - xs
    yd = ye - ys

    IF yd <> 0 THEN xi = xd \ yd: xrs = ABS(xd MOD yd)

    xr = -yd \ 2

    IF ye > maxy THEN ye = maxy

    xdirect = SGN(xd) + xi

    FOR y = ys TO ye
        xtemp! = xs
        ytemp! = y
        vpset xtemp!, ytemp!, ctemp!
                     
        xr = xr + xrs
        IF xr > 0 THEN
            xr = xr - yd
            xs = xs + xdirect
        ELSE
            xs = xs + xi
        END IF
    NEXT

END SUB

SUB vpset (x!, y!, c!)
   IF vms = 0 THEN DEF SEG = &HA000: vms = 1
   pg = INT((y! * maxx + x!) / 65536)
   IF pg <> cp THEN memsw pg
   m! = (y! * maxx + x!) MOD 65536
   POKE m!, c!
END SUB

FUNCTION vscreen (mode)
AX = &H4F02: BX = mode: CX = 0: DX = 0
DEF SEG = VARSEG(a(0))
CALL ABSOLUTE(AX, BX, CX, DX, VARPTR(a(0)))
vscreen = (AX AND &H100) / &H100
vms = 0
END FUNCTION

