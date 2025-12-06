CLEAR : CLS : DEFINT A-X: DEF SEG = 64
a1 = PEEK(8) + 256 * PEEK(9) + 1
LOCATE 1, 34, 0: PRINT "PcSWIPE Test"
LOCATE 2, 1: PRINT STRING$(79, 220)
LOCATE 4, 31: PRINT "(Press ESC To End)"
previous = (INP(a1) AND 64) / 64
LOCATE 10, 39
IF previous = 1 THEN PRINT "HI" ELSE PRINT "LO"
loop01:
a = (INP(a1) AND 64) / 64
a$ = INKEY$: IF a$ <> "" THEN GOTO endit
LOCATE 10, 39
IF a = 1 AND previous = 0 THEN
SOUND 600, 1
PRINT "HI"
previous = 1
ELSEIF a = 0 AND previous = 1 THEN
SOUND 100, 1
PRINT "LO"
previous = 0
END IF
GOTO loop01
endit:
END


