DECLARE SUB TLOAD (File$, StartPos&)
DECLARE SUB TSAVE (File$, StartPos&, EndPos&)
DECLARE FUNCTION FileExist% (T$)
DECLARE FUNCTION GETINPUT$ (CHARS%)
DECLARE FUNCTION GETDEC$ (CHARS%)
DECLARE FUNCTION ProgramName$ ()
DECLARE SUB Box (topRow%, topCol%, lowRow%, lowCol%, Frg%, Bkg%)
DECLARE FUNCTION GETHEX$ (CHARS%)
DECLARE SUB FPRINT (NAT$, FL%)
CONST yes = 1, No = 0
'$INCLUDE: 'qb.bi'
SCREEN 0
DEFINT A-Z
StartLoc& = 0
StartSeg& = &H40
BorderColour% = 9
MemColour% = 7
InfoColour% = 15
Mode$ = "H"
LiveBytes% = yes
Lines% = 25
DIM Mods%(0 TO ((Lines% / 25) * 1439))
WIDTH , Lines%
Max& = 65535 - ((Lines% / 25) * 1439)
Main:
Invalid% = No
CurEdit% = 0
COLOR MemColour%, 0
DIM Regs AS RegType
LOCATE , , 0
CLS
COLOR BorderColour%, 0
LOCATE Lines% - CINT((Lines% / 25) * 6.5), 1: PRINT STRING$(80, 196)
COLOR 0, MemColour%
FOR I% = (Lines% - 2) TO Lines%
LOCATE I%, 1
FPRINT STRING$(80, " "), No
NEXT I%
LOCATE Lines% - 2, 1
FPRINT "   F1=Edit  F2=Goto Addr  F3=Config  F4=Load file into memory  F5=Memory Dump", No
LOCATE Lines% - 1, 1
FPRINT "       F6=Compare  F7=About MemoryView  F8=Mode  F9=Mem Search  ESC=Exit", No
LOCATE Lines%, 1
FPRINT "   Use Pgup, Pgdn, Home, End, and arrow keys to move inside selected segment", No
Update% = yes
DO
K$ = INKEY$
IF LEN(K$) THEN GOSUB Move
IF Update% = yes THEN
Regs.ax = &HB00
Regs.bx = BorderColour%
CALL INTERRUPT(&H10, Regs, Regs)
COLOR MemColour%, 0
COLOR InfoColour%, 0
IF LiveBytes% = yes THEN Update% = No
LOCATE Lines% - 5, 1: FPRINT "Segment: " + HEX$(StartSeg&) + "h     ", No
LOCATE Lines% - 4, 1: FPRINT "Offset: " + HEX$(StartLoc&) + "h to ", No
FPRINT HEX$(StartLoc& + ((Lines% / 25) * 1439)) + "h          ", No
LOCATE Lines% - 3, 1
PRINT "Mode: ";
IF Mode$ = "H" THEN PRINT "Hex" ELSE PRINT "Dec"
END IF
SL% = -2
IF LiveBytes% = yes OR (LiveBytes% = No AND Update% = yes) THEN
Update% = No
FOR I& = StartLoc& TO StartLoc& + INT(Lines% / 25) * 1439
SL% = SL% + 2
DEF SEG = StartSeg&
Char% = PEEK(I&)
DEF SEG = &HB800
POKE SL%, Char%
NEXT I&
END IF
LOOP
Move:
SELECT CASE K$
CASE CHR$(0) + "M", "6": StartLoc& = StartLoc& + 1
IF StartLoc& > Max& THEN StartLoc& = Max&
CASE CHR$(0) + "K", "4": StartLoc& = StartLoc& - 1
IF StartLoc& < 0 THEN StartLoc& = 0
CASE CHR$(0) + "H", "8": StartLoc& = StartLoc& - 80
IF StartLoc& < 0 THEN StartLoc& = StartLoc& + 80
CASE CHR$(0) + "P", "2": StartLoc& = StartLoc& + 80
IF StartLoc& > Max& THEN StartLoc& = StartLoc& - 80
CASE CHR$(0) + "Q", "3": StartLoc& = StartLoc& + 1440
IF StartLoc& > Max& THEN StartLoc& = StartLoc& - 1440
CASE CHR$(0) + "I", "9": StartLoc& = StartLoc& - 1440
IF StartLoc& < 0 THEN StartLoc& = StartLoc& + 1440
CASE CHR$(0) + "G", "7": StartLoc& = 0
CASE CHR$(0) + "O", "1": StartLoc& = Max&
CASE CHR$(0) + "A"
IT% = InfoColour%: BT% = BorderColour%
Box 5, 26, 12, 52, InfoColour%, BorderColour%
COLOR InfoColour%, BorderColour%
LOCATE 6, 28
SOUND 50, 1
FPRINT "  MemView Version 0.3", No
LOCATE 8, 28
FPRINT "By D. Tyler Barnes,1996", No
LOCATE 10, 28
FPRINT "       FREEWARE!", No
LOCATE 11, 28
FPRINT " Tested on a 486dx2 80", No
InfoColour% = IT%: BorderColour% = BT%
DO: Junk$ = INKEY$: LOOP UNTIL LEN(Junk$)
DEF SEG = &HB800
FOR C% = 691 TO 2027 STEP 2
POKE C%, MemColour%
NEXT C%
CASE "", "", CHR$(0) + "", "Q", "q", "X", "x"
COLOR 7, 0
Regs.ax = &HB00
Regs.bx = 0
CALL INTERRUPT(&H10, Regs, Regs)
CLS
END
CASE CHR$(0) + "<"
LOCATE Lines% - 5, 40, 1
COLOR InfoColour%, 0: FPRINT "Segment:Offset = ", No
LastKey$ = ""
Seg$ = GETHEX$(4)
IF Seg$ = "" THEN GOTO NoMatter
LOCATE Lines% - 5, 62
FPRINT ": ", No
Off$ = GETHEX$(4)
IF Off$ = "" THEN Off$ = "0000"
StartLoc& = VAL("&H" + Off$)
IF StartLoc& < 0 THEN StartLoc& = StartLoc& + 65536
IF StartLoc& > Max& THEN StartLoc& = Max&
StartSeg& = VAL("&H" + Seg$)
IF StartSeg& < 0 THEN StartSeg& = StartSeg& + 65536
NoMatter:
LOCATE Lines% - 5, 40, 0
2 FPRINT SPACE$(29), No
CASE CHR$(0) + ";": GOSUB ByteEditor: GOTO Main
CASE CHR$(0) + "?"
TryAgain:
FOR R% = (Lines% - 5) TO (Lines% - 3)
LOCATE R%, 30, 0
FPRINT SPACE$(40), No
NEXT R%
LOCATE Lines% - 5, 30, 1
FPRINT "Save memory dump as:", No
F$ = GETINPUT$(12)
IF F$ = "" THEN GOTO Finished
FE% = FileExist(F$)
IF FE% = yes THEN
FOR R% = Lines% - 5 TO Lines% - 3
LOCATE R%, 30, 0
FPRINT SPACE$(40), No
NEXT R%
BEEP
LOCATE Lines% - 5, 30: PRINT "File Exists!"
LOCATE Lines% - 4, 30: PRINT "Hit any key..."
DO: A$ = INKEY$: LOOP UNTIL LEN(A$)
GOTO TryAgain
END IF
ON ERROR GOTO InvalidFilename
OPEN F$ FOR BINARY AS 1
ON ERROR GOTO EH
CLOSE 1
IF Invalid% = yes THEN Invalid% = No: GOTO TryAgain
LOCATE Lines% - 4, 30: FPRINT "Offset ____h to ____h", No
LastKey$ = ""
LOCATE Lines% - 4, 37: FO$ = GETHEX$(4)
LOCATE Lines% - 4, 46: SO$ = GETHEX$(4)
DEF SEG = StartSeg&
LOCATE Lines% - 3, 29
TSAVE F$, VAL("&H" + FO$), VAL("&H" + SO$)
Finished:
COLOR MemColour%, 0
FOR R% = Lines% - 5 TO Lines% - 3
LOCATE R%, 30, 0
FPRINT SPACE$(40), No
NEXT R%
CASE CHR$(0) + ">"
LOCATE Lines% - 5, 30, 1
FPRINT "Load File:", No
F$ = GETINPUT$(12)
LOCATE , , 0
IF FileExist(F$) = No THEN
BEEP
LOCATE Lines% - 5, 30
FPRINT "File Not Found!", No
LOCATE Lines% - 4, 30
FPRINT "Hit Any Key...", No
DO: A$ = INKEY$: LOOP UNTIL LEN(A$)
GOTO FinishedLoad
END IF
LOCATE Lines% - 4, 30
FPRINT "Offset:____h", No
LOCATE Lines% - 4, 37, 1
LastKey$ = ""
O$ = GETHEX$(4)
DEF SEG = StartSeg&
LOCATE Lines% - 3, 30, 0
TLOAD F$, VAL("&H" + O$)
FinishedLoad:
FOR L% = Lines% - 5 TO Lines% - 3
LOCATE L%, 30, 0
FPRINT SPACE$(20), No
NEXT L%
CASE "[", "<", ",": StartSeg& = StartSeg& - 1
IF StartSeg& < 0 THEN StartSeg& = 0
CASE "]", ".", ">": StartSeg& = StartSeg& + 1
IF StartSeg& > 65535 THEN StartSeg& = 65535
END SELECT
EndSelect:
LOCATE , , 0
Update% = yes
RETURN
ByteEditor:
COLOR 0, MemColour%
FOR I% = Lines% - 2 TO Lines%
LOCATE I%, 1
FPRINT SPACE$(80), No
NEXT I%
LOCATE Lines% - 2, 1
FPRINT "F1 = Enter Hex Value   F2 = Enter Decimal Value   F3 = Quit   F4 = Save and Quit", No
LOCATE Lines% - 1, 1
LOCATE Lines%, 1
FPRINT "        Use Pgup, Pgdn, Home, End, and arrow keys to move within window", No
COLOR InfoColour%, 0
U2% = yes: Typed% = No: SaveIt% = No
LOCATE , , 1
CurCol% = CurEdit%
FOR I% = 0 TO ((Lines% / 25) * 1439)
DEF SEG = StartSeg&
Mods%(I%) = PEEK(StartLoc& + I%)
DEF SEG = &HB800
POKE I% * 2, Mods%(I%)
NEXT I%
DO
K$ = INKEY$
NewVal:
IF LEN(K$) THEN U2% = yes
SELECT CASE K$
CASE CHR$(0) + "M", "6": CurCol% = CurCol% + 2
IF CurCol% > 2879 THEN CurCol% = CurCol% - 2
CASE CHR$(0) + "K", "4": CurCol% = CurCol% - 2
IF CurCol% < 0 THEN CurCol% = CurCol% + 2
CASE CHR$(0) + "H", "8": CurCol% = CurCol% - 160
IF CurCol% < 0 THEN CurCol% = CurCol% + 160
CASE CHR$(0) + "P", "2": CurCol% = CurCol% + 160
IF CurCol% > 2879 THEN CurCol% = CurCol% - 160
CASE CHR$(0) + "G": CurCol% = 0
CASE CHR$(0) + "O": CurCol% = (Lines% / 25) * 2878
CASE CHR$(0) + "I": CurCol% = CurCol% - ((Y% - 1) * 160)
CASE CHR$(0) + "Q": CurCol% = CurCol% + ((17 * 160) - ((Y% - 1) * 160))
CASE CHR$(0) + ";"
LOCATE Lines% - 5, 20, 1
FPRINT "Hex:", No
LastKey$ = ""
H$ = GETHEX$(2)
K$ = CHR$(VAL("&H" + H$))
LOCATE Lines% - 5, 20, 0: PRINT "       ";
GOTO NewVal
CASE CHR$(0) + "<"
ReEnter:
LOCATE Lines% - 5, 20, 0
PRINT SPACE$(30);
LOCATE Lines% - 5, 20, 1
FPRINT "Dec:", No
LastKey$ = ""
H$ = GETDEC$(3)
IF VAL(H$) > 255 THEN GOTO ReEnter
K$ = CHR$(VAL(H$))
LOCATE Lines% - 5, 20, 0: PRINT "       ";
GOTO NewVal
CASE ""
CASE CHR$(0) + "=": SaveIt% = No: EXIT DO
CASE CHR$(0) + ">": SaveIt% = yes: EXIT DO
CASE ELSE
Typed% = yes
Mods%(INT(CurCol% / 2)) = ASC(K$)
CurCol% = CurCol% + 2
IF CurCol% > ((Lines% / 25) * 2878) THEN CurCol% = ((Lines% / 25) * 2878)
END SELECT
IF U2% = yes THEN
Y% = INT(CurCol% / 160) + 1
X% = (INT(CurCol% / 2) + 1) - (80 * (INT(CurCol% / 160)))
MemPos& = INT(CurCol% / 2) + StartLoc&
DEF SEG = StartSeg&
CurByte% = Mods%(INT(CurCol% / 2))
FOR C% = Lines% - 5 TO Lines% - 3
LOCATE C%, 1: PRINT SPACE$(80);
NEXT C%
LOCATE Lines% - 5, 1: PRINT "Segment: "; HEX$(StartSeg&) + "h"
LOCATE Lines% - 4, 1: PRINT "Offset: "; HEX$(MemPos&) + "h"
LOCATE Lines% - 3, 1: PRINT "Char:"; HEX$(CurByte%) + "h (" + LTRIM$(STR$(CurByte%)) + "d)"
DEF SEG = &HB800
LOCATE Y%, X%, 1: POKE CurCol%, CurByte%
IF Typed% = yes THEN POKE CurCol% - 2, Mods%(INT((CurCol% - 2) / 2)): Typed% = No
U2% = No
END IF
LOOP
IF SaveIt% = yes THEN
DEF SEG = StartSeg&
FOR I% = 0 TO (Lines% / 25) * 1439
POKE StartLoc& + I%, Mods%(I%)
NEXT I%
END IF
LOCATE , , 0
RETURN
EH:
CLS
COLOR 7, 0
PRINT "FATAL ERROR; PROGRAM HALTED."
PRINT "Error#"; ERR
END
InvalidFilename:
Invalid% = yes
RESUME NEXT

SUB Box (topRow%, topCol%, lowRow%, lowCol%, Frg%, Bkg%)
COLOR Bkg%, Bkg%
IF Bkg% >= 8 THEN Bkg% = Bkg% - 8
FOR I% = topRow% TO lowRow%
LOCATE I% + 1, topCol% + 2
PRINT STRING$(lowCol% - topCol% + 1, 176)
NEXT I%
COLOR Bkg%, Frg%
FOR I% = topRow% TO lowRow%
LOCATE I%, topCol%
PRINT STRING$(lowCol% - topCol% + 1, 219)
NEXT I%
COLOR Frg%, Bkg%
LOCATE topRow%, topCol%
PRINT "Ú" + STRING$(lowCol% - topCol% - 1, 196) + "¿"
FOR I% = (topRow% + 1) TO (lowRow% - 1)
LOCATE I%, topCol%
PRINT "³"
LOCATE I%, lowCol%
PRINT "³"
NEXT
LOCATE lowRow%, topCol%
PRINT "À" + STRING$(lowCol% - topCol% - 1, 196) + "Ù"
COLOR 7, 0
END SUB

DEFSNG A-Z
FUNCTION FileExist% (T$)
DEFINT A-Z
DIM F AS STRING * 64
DIM Inx AS RegTypeX
DIM Outx AS RegTypeX
Inx.ax = &H2F00
CALL INTERRUPTX(&H21, Inx, Outx)
DTASeg = Outx.es
DTAAddr = Outx.bx
F$ = LTRIM$(RTRIM$(UCASE$(T$))) + CHR$(0)
Inx.ds = VARSEG(F$)
Inx.dx = VARPTR(F$)
Inx.ax = &H4E00
Inx.cx = -1
CALL INTERRUPTX(&H21, Inx, Outx)
IF Outx.flags AND 1 THEN
FileExist% = 0
ELSE
FileExist% = 1
END IF
END FUNCTION

SUB FPRINT (NAT$, FL%)
YT = (80 - POS(0)) + 1
BS = INSTR(LEFT$(NAT$, YT), "")
IF BS < 1 THEN
PRINT LEFT$(NAT$, YT);
ELSE
BST$ = LEFT$(NAT$, YT): GOSUB PrintWithBackspaces
END IF
IF LEN(NAT$) - YT > 0 THEN
BS = INSTR(RIGHT$(NAT$, LEN(NAT$) - YT), "")
ELSE
BS = 0
END IF
IF BS < 1 THEN
IF LEN(NAT$) - YT > 0 THEN PRINT RIGHT$(NAT$, LEN(NAT$) - YT);
ELSE
BST$ = RIGHT$(NAT$, LEN(NAT$) - YT): GOSUB PrintWithBackspaces
END IF
IF FL = yes THEN PRINT
EXIT SUB
PrintWithBackspaces:
DO UNTIL INSTR(BST$, "") < 1
TBP = INSTR(BST$, "")
PRINT LEFT$(BST$, TBP - 1);
IF POS(0) > 1 THEN
LOCATE CSRLIN, POS(0) - 1: PRINT " "; : LOCATE CSRLIN, POS(0) - 1
END IF
BST$ = RIGHT$(BST$, LEN(BST$) - TBP)
LOOP
PRINT BST$;
RETURN
END SUB

FUNCTION GETDEC$ (CHARS)
SHARED LastKey$
LOCATE , , 1
DO
IF LEN(LastKey$) THEN
A$ = LastKey$
LastKey$ = ""
ELSE
A$ = UCASE$(INKEY$)
END IF
SELECT CASE A$
CASE ""
IF Counter > 0 THEN
Counter = Counter - 1
PRINT " ";
Total$ = LEFT$(Total$, LEN(Total$) - 1)
END IF
CASE ""
CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
IF Counter < CHARS THEN
Counter = Counter + 1
PRINT A$;
Total$ = Total$ + A$
ELSE
LastKey$ = A$
EXIT DO
END IF
END SELECT
LOOP UNTIL A$ = CHR$(13)
DO UNTIL LEN(Total$) = CHARS
Total$ = "0" + Total$
LOOP
PRINT
GETDEC$ = Total$
END FUNCTION

FUNCTION GETHEX$ (CHARS)
SHARED LastKey$
LOCATE , , 1
DO
IF LEN(LastKey$) THEN
A$ = LastKey$
LastKey$ = ""
ELSE
A$ = UCASE$(INKEY$)
END IF
SELECT CASE A$
CASE ""
IF Counter > 0 THEN
Counter = Counter - 1
PRINT " ";
Total$ = LEFT$(Total$, LEN(Total$) - 1)
END IF
CASE ""
CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
IF Counter < CHARS THEN
Counter = Counter + 1
PRINT A$;
Total$ = Total$ + A$
ELSE
LastKey$ = A$
EXIT DO
END IF
END SELECT
LOOP UNTIL A$ = CHR$(13)
IF LEN(Total$) THEN
DO UNTIL LEN(Total$) = CHARS
Total$ = "0" + Total$
LOOP
END IF
PRINT
GETHEX$ = Total$
END FUNCTION

FUNCTION GETINPUT$ (CHARS)
LOCATE , , 1
DO
A$ = UCASE$(INKEY$)
SELECT CASE A$
CASE ""
IF Counter > 0 THEN
Counter = Counter - 1
PRINT " ";
Total$ = LEFT$(Total$, LEN(Total$) - 1)
END IF
CASE "", ";", "*", "?", "/", "\", ":", ""
CASE CHR$(13): EXIT DO
CASE ELSE
IF Counter < CHARS THEN
Counter = Counter + 1
PRINT A$;
Total$ = Total$ + A$
END IF
END SELECT
LOOP UNTIL A$ = CHR$(13)
PRINT
GETINPUT$ = Total$
END FUNCTION

FUNCTION ProgramName$ STATIC
DIM Regs AS RegType
Regs.ax = &H5100
INTERRUPT &H21, Regs, Regs
DEF SEG = Regs.bx
EnvSeg% = PEEK(&H2C) + PEEK(&H2D) * 256
DEF SEG = EnvSeg%
DO
Byte% = PEEK(Offset%)
IF Byte% = 0 THEN
Count% = Count% + 1
IF Count% AND EXEFlag% THEN
EXIT DO
ELSEIF Count% = 2 THEN
EXEFlag% = -1
Offset% = Offset% + 2
END IF
ELSE
Count% = 0
IF EXEFlag% THEN
Temp$ = Temp$ + CHR$(Byte%)
END IF
END IF
Offset% = Offset% + 1
LOOP
DEF SEG
ProgramName$ = Temp$
Temp$ = ""
END FUNCTION

SUB TLOAD (File$, StartPos&)
L = CSRLIN: C = POS(0)
IF StartPos& < 0 THEN StartPos& = StartPos& + 65536
IF EndPos& < 0 THEN EndPos& = EndPos& + 65536
Z% = FREEFILE
OPEN File$ FOR BINARY AS Z%
FLength& = LOF(Z%)
DO UNTIL EOF(Z%)
Data$ = INPUT$(1, Z%)
IF LEN(Data$) THEN POKE StartPos&, ASC(Data$)
LOCATE L, C, 0
PRINT INT((LOC(Z%) / FLength&) * 100); "%";
StartPos& = StartPos& + 1
LOOP
CLOSE Z%
END SUB

SUB TSAVE (File$, StartPos&, EndPos&)
L = CSRLIN: C = POS(0)
IF StartPos& < 0 THEN StartPos& = StartPos& + 65536
IF EndPos& < 0 THEN EndPos& = EndPos& + 65536
Z% = FREEFILE
OPEN File$ FOR OUTPUT AS Z%
FOR C& = StartPos& TO EndPos& STEP 1
PRINT #Z%, CHR$(PEEK(C&));
LOCATE L, C, 0
PRINT INT((C& / EndPos&) * 100); "%";
NEXT C&
CLOSE Z%
END SUB

