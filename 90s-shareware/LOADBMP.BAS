DEFINT A-Z

SUB LoadBmp (file$, xpos, ypos)
IF LTRIM$(RTRIM$(file$)) = "" THEN EXIT SUB
FFile = FREEFILE
OPEN file$ FOR BINARY AS #FFile
IF LOF(FFile) = 0 THEN
 PRINT "Error: "; file$; " not found!"
 CLOSE
 KILL file$
 EXIT SUB
END IF
table$ = INPUT$(54, #FFile)  'Get the file header (54 bytes)
DIM table&(30)           'Create numerical array for header
DEF SEG = VARSEG(table&(1))
pointer% = VARPTR(table&(1))

'Poke the data from string "table$" into numerical array "table&"
FOR x% = 0 TO 51
 POKE pointer% + x%, ASC(MID$(table$, x% + 3, 1))
NEXT
DEF SEG

'Check for valid file type
IF MID$(table$, 1, 2) <> "BM" OR table&(4) <> 40 THEN
   PRINT "Error while loading "; file$: EXIT SUB
END IF
IF table&(8) <> 0 THEN
   PRINT "Error while loading "; file$: EXIT SUB
END IF
Hcol = 2 ^ ASC(MID$(table$, 29, 1))
IF Hcol <> 256 AND Hcol <> 16 THEN
   PRINT "Only 256 or 16 colors supported!": EXIT SUB
END IF

thecolors$ = INPUT$(table&(3) - 54, #FFile) 'Read in pallette info
DIM byte AS STRING * 1
FOR K = 0 TO Hcol - 1
   GET FFile, 55 + 4 * K, byte
   B = ASC(byte) \ 4
   GET FFile, 56 + 4 * K, byte
   G = ASC(byte) \ 4
   GET FFile, 57 + 4 * K, byte
   R = ASC(byte) \ 4
   OUT &H3C8, K
   OUT &H3C9, R
   OUT &H3C9, G
   OUT &H3C9, B
NEXT K

'Read in Bitmap data and set pixels accordingly
Y% = table&(6) 'Put number of vertical pixels into y%

IF Hcol = 16 THEN
 xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
 IF (table&(5) \ 2) < LEN(xdata$) THEN
   linelength% = table&(5) \ 2
 ELSE
   linelength% = LEN(xdata$)
 END IF
ELSE
 xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1), #1)
 IF (table&(5)) < LEN(xdata$) THEN
   linelength% = table&(5)
 ELSE
   linelength% = LEN(xdata$)
 END IF
END IF
DO
    IF Hcol = 16 THEN
      xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
      IF (table&(5) \ 2) < LEN(xdata$) THEN
        linelength% = table&(5) \ 2
      ELSE
        linelength% = LEN(xdata$)
      END IF
    ELSE
      xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1), #1)
      IF (table&(5)) < LEN(xdata$) THEN
        linelength% = table&(5)
      ELSE
        linelength% = LEN(xdata$)
      END IF
    END IF
  
    FOR x% = 1 TO linelength%
      pixel% = ASC(MID$(xdata$, x%, 1))
      IF Hcol = 16 THEN
        PSET (x% * 2 + 1 + xpos, Y% + ypos), pixel% AND 15
        PSET (x% * 2 + xpos, Y% + ypos), pixel% \ 16
      ELSE
        PSET (x% + xpos, Y% + ypos), pixel%
      END IF
     NEXT
    Y% = Y% - 1
LOOP UNTIL EOF(FFile)
CLOSE #FFile
ERASE table&
END SUB

