DECLARE SUB LoadBmp (file$, xpos%, ypos%, mx%, my%)
DEFINT A-Z

SCREEN 0: CLS
PRINT "***** BMP2BAS - The Bitmap-to-Basic Converter ***** "
PRINT "By Hauke Daempfling - VIVID software"
PRINT "June 9, 1996"
PRINT
PRINT "This program  creates text  BAS files  from Windows"
PRINT "bitmaps. Bitmaps must be 16 color and RGB (not RLE)"
PRINT "encoded. Useful for adding  small bitmaps into your"
PRINT "programs, eliminating the  problem of lots of small"
PRINT "data files. Maximum bitmap size is 640x480."
PRINT
INPUT "Bitmap filename? ", INf$
INf$ = UCASE$(INf$)
IF INf$ = "" THEN PRINT "No filename!": SYSTEM
INPUT "Output filename? ", OUTf$
OUTf$ = UCASE$(OUTf$)
IF OUTf$ = "" THEN PRINT "No filename!": SYSTEM
OPEN OUTf$ FOR BINARY AS #1
l& = LOF(1)
CLOSE #1
IF l& THEN
  PRINT OUTf$; " already exists! Overwrite?";
  DO: a$ = INKEY$: LOOP UNTIL a$ <> ""
  IF LEFT$(LTRIM$(UCASE$(a$)), 1) <> "Y" THEN :  SYSTEM
END IF

SCREEN 12

LoadBmp INf$, -2, -2, mx, my
mx = mx - 1
my = my - 2
OPEN OUTf$ FOR OUTPUT AS #1
x$ = CHR$(34): y$ = CHR$(13) + CHR$(10)

o$ = ""
o$ = o$ + "defint a-z" + y$
o$ = o$ + "declare sub Draw" + INf$ + "(Xpos%,Ypos%)" + y$ + y$
o$ = o$ + "screen 12 'Any 16-color or more mode will do" + y$
o$ = o$ + "Draw" + INf$ + " 0,0" + y$ + y$
o$ = o$ + "'Call this procedure to draw " + INf$ + " at Xpos,Ypos" + y$
o$ = o$ + "sub Draw" + INf$ + "(Xpos,Ypos)" + y$
o$ = o$ + "Rpos&=66:restore Pic" + INf$ + "data" + y$
o$ = o$ + "read Xmax,Ymax" + y$
o$ = o$ + "for x=0 to Xmax" + y$
o$ = o$ + " for y=0 to Ymax" + y$
o$ = o$ + "  if Rpos&>65 then read InBuff$:Rpos&=1" + y$
o$ = o$ + "  i$=mid$(InBuff$,Rpos&,1)" + y$
o$ = o$ + "  col=val(" + x$ + "&H" + x$ + "+i$)" + y$
o$ = o$ + "  Rpos&=Rpos&+1:pset (x+Xpos,y+Ypos),col" + y$
o$ = o$ + " next" + y$
o$ = o$ + "next" + y$
o$ = o$ + "end sub" + y$ + y$
o$ = o$ + "Pic" + INf$ + "data:" + y$
o$ = o$ + "'*** Pic data from picture file " + INf$ + y$
o$ = o$ + "DATA" + STR$(mx) + "," + STR$(my)
PRINT #1, o$

o$ = "DATA "
FOR x = 0 TO mx
 FOR y = 0 TO my
  r = POINT(x, y)
  s$ = HEX$(r)
  o$ = o$ + s$
  IF LEN(o$) = 70 THEN PRINT #1, o$: o$ = "DATA "
 NEXT y
NEXT x
IF LEN(o$) > 5 THEN PRINT #1, o$
o$ = "'* End pic data for " + INf$
PRINT #1, o$
CLOSE #1

SCREEN 2: SCREEN 0
PRINT "Done converting. Goodbye!"
SYSTEM

SUB LoadBmp (file$, xpos, ypos, mx, my)
IF LTRIM$(RTRIM$(file$)) = "" THEN SCREEN 0: SYSTEM
FFile = FREEFILE
OPEN file$ FOR BINARY AS #FFile
IF LOF(FFile) = 0 THEN
 PRINT "Error: "; file$; " not found!"
 CLOSE
 KILL file$
 SCREEN 0
 SYSTEM
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
   PRINT "Error while loading "; file$: SCREEN 0: SYSTEM
END IF
IF table&(8) <> 0 THEN
   PRINT "Error while loading "; file$: SCREEN 0: SYSTEM
END IF
IF ASC(MID$(table$, 29, 1)) <> 4 THEN
   PRINT "Error while loading "; file$: SCREEN 0: SYSTEM
END IF

thecolors$ = INPUT$(table&(3) - 54, #FFile) 'Read in pallette info

'Read in Bitmap data and set pixels accordingly
y% = table&(6) 'Put number of vertical pixels into y%
my = y
xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
    IF (table&(5) \ 2) < LEN(xdata$) THEN
       linelength% = table&(5) \ 2
    ELSE
       linelength% = LEN(xdata$)
    END IF
mx = linelength% * 2
DO
  xdata$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
    IF (table&(5) \ 2) < LEN(xdata$) THEN
       linelength% = table&(5) \ 2
    ELSE
       linelength% = LEN(xdata$)
    END IF
    IF linelength% > mx THEN mx = linelength% * 2
    FOR x% = 1 TO linelength%
      pixel% = ASC(MID$(xdata$, x%, 1))
      PSET (x% * 2 + 1 + xpos, y% + ypos), pixel% AND 15
      PSET (x% * 2 + xpos, y% + ypos), pixel% \ 16
     NEXT
    y% = y% - 1
LOOP UNTIL EOF(FFile)
CLOSE #FFile
ERASE table&
END SUB

