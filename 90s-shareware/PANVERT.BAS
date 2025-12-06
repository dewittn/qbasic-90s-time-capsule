DEFINT A-Z
SCREEN 9: CLS
COLOR 4, 0
FOR X = 1 TO 24
LOCATE X, 1: PRINT STRING$(79, "X");
NEXT
CIRCLE (300, 200), 150, 14
PAINT (301, 201), 12, 14
SLEEP (4)
FOR I% = 0 TO 26480 STEP 80
REM M% stands for MSB and L%=LSB
M% = FIX(I% / 256): L% = I% - (M% * 256)
OUT &H3D4, 12: OUT &H3D5, M%: OUT &H3D4, 13: OUT &H3D5, L%
WAIT &H3DA, 8 'Wait for vertical retrace
FOR D = 0 TO 100: NEXT: 'Adjust for different scroll speed
NEXT
FOR I% = 26480 TO 0 STEP -80
M% = FIX(I% / 256): L% = I% - (M% * 256)
OUT &H3D4, 12: OUT &H3D5, M%: OUT &H3D4, 13: OUT &H3D5, L%
WAIT &H3DA, 8: 'waits for vertical retrace
FOR DELAY = 0 TO 100: NEXT: 'Adjust for different scroll speed
NEXT
SLEEP (1)
RUN

