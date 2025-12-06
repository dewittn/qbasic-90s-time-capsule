
DEFINT A-Z
'$STATIC
DECLARE SUB ScreenSaver ()
DECLARE SUB PackTxt (text$)
DECLARE SUB MoveIcon (x, y)
DECLARE FUNCTION OpenWindow (WhatWin AS ANY)
DECLARE SUB syspause ()
DECLARE SUB redraw ()
DECLARE SUB rredraw ()
DECLARE SUB Quit ()
DECLARE SUB ColorChange ()
DECLARE SUB WinPrint (WhatWin, text$)
DECLARE SUB SizeWin (x, y)
DECLARE SUB MoveWin (x, y)
DECLARE SUB DrawMenu (WhatMen)
DECLARE SUB TimeShow ()
DECLARE SUB CloseWindow (WhatWin)
DECLARE SUB ActivateWin (WhatWin)
DECLARE SUB DoEvents ()
DECLARE SUB SizebackWindow (WhatWin)
DECLARE SUB MinWindow (WhatWin)
DECLARE SUB CheckVals (WhatWin AS ANY)
DECLARE SUB MaxWindow (WhatWin AS ANY)
DECLARE SUB DrawWindow (WhatWin AS ANY)
DECLARE SUB StatLine (what$)
DECLARE FUNCTION EditBox$ (Def$, x%, y%)
DECLARE FUNCTION DirBox$ (ArgD$, ArgF$)
'$INCLUDE: 'mouse.bi'
TYPE WinType
  Xpos AS INTEGER
  Ypos AS INTEGER
  Xsize AS INTEGER
  Ysize AS INTEGER
  Title AS STRING * 70
  Fixed AS INTEGER
  Stat AS INTEGER
  IconX AS INTEGER
  IconY AS INTEGER
  Active AS INTEGER
  CurX AS INTEGER
  CurY AS INTEGER
END TYPE
DIM SHARED Wins
DIM SHARED BS, VS
DIM SHARED SSTime AS SINGLE
DIM SHARED SSaver AS SINGLE
SSTime = 60!
SSaver = TIMER + SSTime

'BS is the "Backup Screen", it is displayed while there's work
'going on in the "Viewing Screen", or VS

BS = 1: VS = 0

'ON ERROR GOTO ErrHandle
DIM SHARED path$
path$ = "C:\QUICK\Noose\"
Wins = 10
OPEN path$ + "WinDOS.SAV" FOR RANDOM AS #2
'GET #2, 1, Wins
DIM SHARED Win(Wins) AS WinType
FOR a = 1 TO Wins
  GET #2, a + 1, Win(a)
NEXT a
CLOSE #2

CONST Dead = 0
CONST Sized = 1
CONST Max = 2
CONST Min = 3
CONST Sizing1 = 4
CONST Sizing2 = 5
DIM SHARED SizeHow
SizeHow = Sizing1
DIM SHARED NewWin AS WinType
DIM SHARED WinOn
DIM SHARED DrawShadow
DIM SHARED DummyWin AS WinType
DIM SHARED TC(9, 11)
DIM SHARED TCName$(9)
DIM SHARED CurTCol
DIM SHARED StatLOn
DIM SHARED MenuOn
MenuOn = TRUE
StatLOn = TRUE
OPEN path$ + "WinDOS.PAL" FOR INPUT AS #1
FOR a = 0 TO 9
  FOR b = 0 TO 11
    INPUT #1, TC(a, b)
    IF TC(a, b) = 999 THEN TC(a, b) = 0: GOTO fileend
  NEXT b
  LINE INPUT #1, TCName$(a)
NEXT a
fileend:
INPUT #1, CurTCol
INPUT #1, MenuOn
INPUT #1, StatLOn
INPUT #1, DrawShadow
CLOSE #1
'0  = Backgr FG
'1  = Backgr BG
'2  = Menu FG
'3  = Menu BG
'4  = Highl FG
'5  = Highl BG
'6  = Win FG
'7  = Win BG
'8  = Std FG
'9  = Std BG
'10 = StatLine FG
'11 = StatLine BG

'----- Mouse Stuff -----
DIM SHARED inreg AS RegType   ' Input Registers; used in CALL INTERRUPT
DIM SHARED outreg AS RegType  ' Output Registers; used in CALL INTERRUPT
DIM SHARED inregx AS RegTypeX  ' Extended Input Registers w/ segment
DIM SHARED outregx AS RegTypeX ' Extended Output Registers w/ segment
'Internal variables used by various mouse functions
DIM SHARED mINIT AS INTEGER, mGRAPHICS AS INTEGER
DIM SHARED mXlast AS INTEGER, mYlast AS INTEGER
mINIT = 0
mGRAPHICS = 0
mXlast = 0
mYlast = 0
DIM SHARED event AS MouseEvent
DIM SHARED oldevent AS MouseEvent
IF MouseInit(0) = 0 THEN
  BEEP
  StatLine "Mouse not found!"
END IF
SCREEN 0, , VS, VS
CLS
redraw
'----- ***** Main ***** -----
NewWin.Xpos = 1
NewWin.Ypos = 1
NewWin.Xsize = 50
NewWin.Ysize = 18
NewWin.Title = "This is a test window."
NewWin.Fixed = FALSE
NewWin.Stat = Sized
NewWin.IconX = 1
NewWin.IconY = 1
'NW = OpenWindow(NewWin)

DO
  DoEvents
LOOP

Quit
'----- ***** End ***** -----
ErrHandle:
BEEP
LOCATE 25, 1
COLOR 4, 4
PRINT "*** PROGRAM ERROR ***";
RESUME NEXT

SUB ActivateWin (WhatWin)
FOR a = 1 TO Wins
  Win(a).Active = FALSE
NEXT a
Win(WhatWin).Active = TRUE
WinOn = WhatWin
redraw
END SUB

SUB CheckVals (WhatWin AS WinType)
g1 = 81
g2 = 25
g3 = 1
g4 = 24
IF DrawShadow = TRUE THEN g1 = 79: g2 = g2 - 1
IF StatLOn = TRUE THEN g2 = g2 - 1: g4 = 23
IF MenuOn = TRUE THEN g3 = 2

  IF WhatWin.Xpos > g1 THEN WhatWin.Xpos = g1
  IF WhatWin.Ypos > 20 THEN WhatWin.Ypos = 20
  IF WhatWin.Xpos < 1 THEN WhatWin.Xpos = 1
  IF WhatWin.Ypos < g3 THEN WhatWin.Ypos = g3
  IF WhatWin.Xsize > g1 - 1 THEN WhatWin.Xsize = g1 - 1
  IF WhatWin.Ysize > g2 - 1 THEN WhatWin.Ysize = g2 - 1
  IF WhatWin.Xsize < 11 THEN WhatWin.Xsize = 11
  IF WhatWin.Ysize < 3 THEN WhatWin.Ysize = 3
  IF WhatWin.Ypos + WhatWin.Ysize > g2 THEN WhatWin.Ypos = g2 - WhatWin.Ysize
  IF WhatWin.Xpos + WhatWin.Xsize > g1 THEN WhatWin.Xpos = g1 - WhatWin.Xsize

  IF WhatWin.IconX > 69 THEN WhatWin.IconX = 69
  IF WhatWin.IconY > g4 THEN WhatWin.IconY = g4
  IF WhatWin.IconX < 1 THEN WhatWin.IconX = 1
  IF WhatWin.IconY < g3 THEN WhatWin.IconY = g3
END SUB

SUB CloseWindow (WhatWin)
Win(WhatWin).Stat = Dead
Win(WhatWin).Title = ""
ActivateWin 1
redraw
END SUB

SUB ColorChange
MouseHide
COLOR 0, 7
FOR a = 2 TO 24
  LOCATE a, 1
  PRINT STRING$(80, " ");
NEXT a
LOCATE 2, 1
COLOR 0, 7
PRINT "É"; STRING$(30, "Í"); "¹";
COLOR 15, 9
PRINT " Change Colors ";
COLOR 0, 7
PRINT "Ì"; STRING$(31, "Í"); "»";
d = 23
IF StatLOn = FALSE THEN d = 24
FOR a = 3 TO d
  LOCATE a, 1
  PRINT "º"; STRING$(78, " "); "º";
NEXT a
LOCATE d + 1, 1
PRINT "È"; STRING$(78, "Í"); "¼";

LOCATE 4, 5
PRINT "Color Set";
LOCATE 5, 3
COLOR 15, 7
PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";
COLOR 0, 7
PRINT "¿";
FOR a = 6 TO 15
  LOCATE a, 3
  COLOR 15, 7
  PRINT "³";
  COLOR 0, 7
  PRINT a - 6; "             ³";
NEXT a
LOCATE 16, 3
COLOR 15, 7
PRINT "À";
COLOR 0, 7
PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
FOR a = 0 TO 9
  LOCATE a + 6, 7
  IF TCName$(a) = "" THEN PRINT "------------";  ELSE PRINT LEFT$(TCName$(a), 12);
NEXT a
x$ = LEFT$(TCName$(CurTCol), 12)
LOCATE CurTCol + 6, 4
COLOR 15, 0
PRINT CurTCol; x$; SPACE$(13 - LEN(x$));

LOCATE 4, 27
COLOR 0, 7
PRINT "Element";
LOCATE 5, 23
COLOR 15, 7
PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";
COLOR 0, 7
PRINT "¿";
FOR a = 6 TO 17
  LOCATE a, 23
  COLOR 15, 7
  PRINT "³";
  COLOR 0, 7
  PRINT a - 6; "                   ";
  IF a - 6 > 9 THEN PRINT "³";  ELSE PRINT " ³";
NEXT a
LOCATE 18, 23
COLOR 15, 7
PRINT "À";
COLOR 0, 7
PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
LOCATE 6, 28
PRINT "Background - FG"
LOCATE 7, 28
PRINT "Background - BG"
LOCATE 8, 28
PRINT "Menu       - FG"
LOCATE 9, 28
PRINT "Menu       - BG"
LOCATE 10, 28
PRINT "Highlight  - FG"
LOCATE 11, 28
PRINT "Highlight  - BG"
LOCATE 12, 28
PRINT "Window     - FG"
LOCATE 13, 28
PRINT "Window     - BG"
LOCATE 14, 28
PRINT "Standard   - FG"
LOCATE 15, 28
PRINT "Standard   - BG"
LOCATE 16, 28
PRINT "Msg. Line  - FG"
LOCATE 17, 28
PRINT "Msg. Line  - BG"

LOCATE 4, 58
COLOR 0, 7
PRINT "Color";
LOCATE 5, 51
COLOR 15, 7
PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";
COLOR 0, 7
PRINT "¿";
FOR a = 6 TO 21
  LOCATE a, 51
  COLOR 15, 7
  PRINT "³";
  COLOR 0, 7
  PRINT a - 6; "                  ";
  IF a - 6 > 9 THEN PRINT "³";  ELSE PRINT " ³";
NEXT a
LOCATE 22, 51
COLOR 15, 7
PRINT "À";
COLOR 0, 7
PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
LOCATE 6, 56
PRINT "Black"
LOCATE 7, 56
PRINT "Blue"
LOCATE 8, 56
PRINT "Green"
LOCATE 9, 56
PRINT "Cyan"
LOCATE 10, 56
PRINT "Red"
LOCATE 11, 56
PRINT "Magenta"
LOCATE 12, 56
PRINT "Brown"
LOCATE 13, 56
PRINT "White"
LOCATE 14, 56
PRINT "Grey"
LOCATE 15, 56
PRINT "Lt. Blue"
LOCATE 16, 56
PRINT "Lt. Green"
LOCATE 17, 56
PRINT "Lt. Cyan"
LOCATE 18, 56
PRINT "Lt. Red"
LOCATE 19, 56
PRINT "Lt. Magenta"
LOCATE 20, 56
PRINT "Yellow"
LOCATE 21, 56
PRINT "Br. White"
LOCATE 23, 50
PRINT "Lt. Colors are dark in BG.";
FOR a = 0 TO 15
  LOCATE a + 6, 68
  COLOR 0, 7
  PRINT "-";
  COLOR a, a
  PRINT "ÛÛÛÛ";  '"ßßßß";
  COLOR 0, 7
  PRINT "-";
NEXT a



CSel = TC(CurTCol, 0)
DO
  MouseHide
  StatLine ""
  LOCATE 17, 4
  COLOR 15, 7
  PRINT "ÚÄÄÄÄÄÄÄ";
  COLOR 0, 7
  PRINT "¿";
  LOCATE 18, 4
  COLOR 15, 7
  PRINT "³";
  COLOR 0, 7
  PRINT "  New  ";
  PRINT "³";
  LOCATE 19, 4
  COLOR 15, 7
  PRINT "À";
  COLOR 0, 7
  PRINT "ÄÄÄÄÄÄÄÙ";
 
  LOCATE 20, 4
  COLOR 15, 7
  PRINT "ÚÄÄÄÄÄÄ";
  COLOR 0, 7
  PRINT "¿";
  LOCATE 21, 4
  COLOR 15, 7
  PRINT "³";
  COLOR 0, 7
  PRINT "  OK  ";
  PRINT "³";
  LOCATE 22, 4
  COLOR 15, 7
  PRINT "À";
  COLOR 0, 7
  PRINT "ÄÄÄÄÄÄÙ";
 
  COLOR 0, 7
  FOR a = 0 TO 9
    LOCATE a + 6, 4
    IF TCName$(a) = "" THEN PRINT a; "------------ ";  ELSE PRINT a; LEFT$(TCName$(a), 12); SPACE$(13 - LEN(TCName$(a)))
  NEXT a
  x$ = LEFT$(TCName$(CurTCol), 12)
  LOCATE CurTCol + 6, 4
  COLOR 15, 9
  PRINT CurTCol; x$; SPACE$(13 - LEN(x$));

  FOR b = 6 TO 17
    IF b - 6 = AtSel THEN COLOR 15, 9 ELSE COLOR 0, 7
    FOR a = 24 TO 43
      LOCATE b, a
      PRINT CHR$(SCREEN(b, a));
    NEXT a
    LOCATE b, 46
    PRINT CHR$(SCREEN(b, 46));
  NEXT b
 
  FOR a = 0 TO 11
    LOCATE a + 6, 44
    COLOR TC(CurTCol, a), TC(CurTCol, a)
    PRINT "ÛÛ";
  NEXT a
 
  FOR b = 6 TO 21
    IF b - 6 = CSel THEN COLOR 15, 9 ELSE COLOR 0, 7
    FOR a = 52 TO 68
      LOCATE b, a
      PRINT CHR$(SCREEN(b, a));
    NEXT a
    LOCATE b, 73
    PRINT CHR$(SCREEN(b, 73));
  NEXT b



  DO
    MouseShow
    MouseGetInfo event
    x = event.x
    y = event.y
    Cmd$ = INKEY$
    TimeShow
    btn = event.buttons
    IF btn THEN
     IF y > 5 AND x > 3 AND y < 16 AND x < 20 THEN
       IF TCName$(y - 6) <> "" THEN CurTCol = y - 6
       AtSel = 0
       CSel = TC(CurTCol, AtSel)
       EXIT DO
     END IF
     IF y > 5 AND x > 23 AND y < 18 AND x < 47 THEN
      AtSel = y - 6
      CSel = TC(CurTCol, AtSel)
      EXIT DO
     END IF
     IF y > 5 AND x > 51 AND x < 74 AND y < 22 THEN
      CSel = y - 6
      TC(CurTCol, AtSel) = CSel
      EXIT DO
     END IF
    IF y > 16 AND x > 3 AND x < 13 AND y < 20 THEN
      MouseHide
      LOCATE 17, 4
      COLOR 0, 7
      PRINT "ÉÍÍÍÍÍÍÍ";
      COLOR 15, 7
      PRINT "»";
      LOCATE 18, 4
      COLOR 0, 7
      PRINT "º";
      COLOR 7, 0
      PRINT "  New  ";
      COLOR 15, 7
      PRINT "º";
      LOCATE 19, 4
      COLOR 0, 7
      PRINT "È";
      COLOR 15, 7
      PRINT "ÍÍÍÍÍÍÍ¼";
      MouseShow
      DO
	MouseGetInfo event
	IF event.buttons = 0 THEN EXIT DO
      LOOP
      FOR a = 0 TO 9
	IF TCName$(a) = "" THEN NewSet = a: EXIT FOR
      NEXT a
      IF NewSet = 0 THEN
	StatLine "No space for new set."
	EXIT DO
      END IF
      StatLine "Please enter the name for the new set."
      LOCATE 19, 15
      COLOR 15, 8
      PRINT "                 ";
      x$ = EditBox$("                      ", 15, 19)
      LOCATE 19, 15
      COLOR 0, 7
      PRINT "                        ";
      TCName$(NewSet) = x$
      CurTCol = NewSet
      EXIT DO
    END IF
   
    IF y > 19 AND x > 3 AND x < 12 AND y < 23 THEN
      MouseHide
      LOCATE 20, 4
      COLOR 0, 7
      PRINT "ÉÍÍÍÍÍÍ";
      COLOR 15, 7
      PRINT "»";
      LOCATE 21, 4
      COLOR 0, 7
      PRINT "º";
      COLOR 7, 0
      PRINT "  OK  ";
      COLOR 15, 7
      PRINT "º";
      LOCATE 22, 4
      COLOR 0, 7
      PRINT "È";
      COLOR 15, 7
      PRINT "ÍÍÍÍÍÍ¼";
     MouseShow
      DO
	MouseGetInfo event
	IF event.buttons = 0 THEN EXIT DO
      LOOP
      GOTO endcol
      END IF
   END IF
  LOOP


LOOP


endcol:
MouseShow
END SUB

FUNCTION DirBox$ (ArgD$, ArgF$)
OldS = 0                                        'OldS = your prog.'s page
AcS = 1                                         'AcS  = DirBox's page
PCOPY OldS, AcS: SCREEN 0, , AcS, AcS           'switch to page AcS
LOCATE , , 0                                    'hide the cursor
x = 10: y = 3                                   'X/Y coordinates of the box
CurFile = 0: CurDir = 0: CurDrive = 0
IF NOT RIGHT$(ArgD$, 1) = "\" THEN ArgD$ = ArgD$ + "\"
DIM Dir$(0)                                     'initalize the Dir$ and File$
DIM File$(0)                                    ' arrays

GOSUB DrawBackGr                                'draw the box
LOCATE y, x + 19: COLOR 20, 9: PRINT "    Wait...   "; 'wait message
GOSUB GetDirs                                   'get the files and dirs.
GOSUB GetFiles
GOSUB DrawFileBox                               'draw the File+Dir boxes
GOSUB DrawDirBox
CurFile = 0: CurDir = -1: CurDrive = -1
GOSUB DrawDirBox
GOSUB DrawFileBox
GOSUB DCL                                       'DCL=DriveCurrentLocation
						'  (don't ask)
COLOR 0, 7: LOCATE y, x + 18: PRINT "¹"; : COLOR 15, 9
PRINT " Select Files "; : COLOR 0, 7: PRINT "Ì"; 'redraw the title
DO
 Cmd$ = UCASE$(INKEY$)                           'get the keys pressed
 IF Cmd$ = CHR$(0) + "P" THEN                    'up arrow
   IF CurFile > -1 THEN
     IF CurFile < Allfiles THEN CurFile = CurFile + 1
     CurDir = -1: CurDrive = -1
     GOSUB DrawFileBox
   END IF
   IF CurDir > -1 THEN
     IF CurDir < Alldirs THEN CurDir = CurDir + 1
     CurFile = -1: CurDrive = -1
     GOSUB DrawDirBox
   END IF
 ELSEIF Cmd$ = CHR$(0) + "H" THEN               'down arrow
   IF CurFile > -1 THEN
     IF CurFile > 0 THEN CurFile = CurFile - 1
     CurDir = -1: CurDrive = -1
     GOSUB DrawFileBox
   END IF
   IF CurDir > -1 THEN
     IF CurDir > 0 THEN CurDir = CurDir - 1
     CurFile = -1: CurDrive = -1
     GOSUB DrawDirBox
   END IF
 ELSEIF Cmd$ = CHR$(13) THEN                    'enter
   IF CurFile > -1 THEN
     BtnSel = 1
     GOSUB DrawBtns
     LOCATE y + 2, x + 40
     COLOR 7, 7
     PRINT " ";
     COLOR 15, 2
     PRINT "   OK   ";
     LOCATE y + 3, x + 41
     COLOR 7, 7
     PRINT "        "
     GOSUB pause
     DirBox$ = ArgD$ + File$(CurFile)
     ERASE Dir$, File$
     SCREEN 0, , OldS, OldS
     EXIT FUNCTION
   END IF
   IF CurDir > -1 THEN                          'change directories
     LOCATE y, x + 19: COLOR 20, 9: PRINT "   Wait...   ";
     IF Dir$(CurDir) = ".." THEN
       ArgD$ = LEFT$(ArgD$, LEN(ArgD$) - 1)
       FOR a = LEN(ArgD$) TO 1 STEP -1
	 IF RIGHT$(ArgD$, 1) <> "\" THEN        'this is all I could come
	   ArgD$ = LEFT$(ArgD$, LEN(ArgD$) - 1) ' up with for going down
	 ELSE                                   ' one directory... delete
	   EXIT FOR                             ' all characters until the
	 END IF                                 ' next "\"
       NEXT a
     ELSE
       ArgD$ = ArgD$ + Dir$(CurDir) + "\"
     END IF
     GOSUB GetDirs                              'get files+dirs from new
     GOSUB GetFiles                             ' directory
     CurFile = 0: CurDir = 0: CurDrive = 0
     DinView = 0
     FinView = 0
     GOSUB DrawBackGr                           'redraw everything
     GOSUB DrawFileBox
     GOSUB DrawDirBox
     CurFile = -1: CurDir = 0: CurDrive = -1
     GOSUB DrawFileBox
     GOSUB DrawDirBox
     COLOR 0, 7: LOCATE y, x + 18: PRINT "¹"; : COLOR 15, 9
     PRINT " Select Files "; : COLOR 0, 7: PRINT "Ì";
     GOSUB DCL
   END IF
   IF CurDrive > -1 THEN                        'this is probably
     LOCATE y + 11, x + 3                       ' where you'll find
     COLOR 15, 9                                ' some bugs
     PRINT SPACE$(32)
     LOCATE y + 11, x + 3
     PRINT ""; : INPUT "", x$                   'input a new drive/directory
     LOCATE y, x + 19: COLOR 20, 9: PRINT "   Wait...   ";
     CDr$ = LEFT$(x$, INSTR(x$, "\"))
     IF LEN(x$) > 3 THEN CDi$ = RIGHT$(x$, INSTR(x$, "\"))
     IF INSTR(CDr$, ":\") = 0 THEN GOTO nodo    'if no drive is given
     ArgD$ = CDr$ + CDi$
     IF NOT RIGHT$(ArgD$, 1) = "\" THEN ArgD$ = ArgD$ + "\"
     GOSUB GetDirs
     GOSUB GetFiles
     CurFile = 0: CurDir = 0: CurDrive = 0
     DinView = 0
     FinView = 0
     GOSUB DrawBackGr
     GOSUB DrawFileBox
     GOSUB DrawDirBox
     CurFile = -1: CurDir = -1: CurDrive = 0
     GOSUB DrawFileBox
     GOSUB DrawDirBox
nodo:
     COLOR 0, 7: LOCATE y, x + 18: PRINT "¹"; : COLOR 15, 9
     PRINT " Select Files "; : COLOR 0, 7: PRINT "Ì";
     GOSUB DCL
   END IF
 ELSEIF Cmd$ = CHR$(0) + "M" THEN               'right key: switch boxes
   IF CurFile > -1 THEN
       CurFile = -1: CurDir = DinView: CurDrive = -1
   ELSEIF CurDir > -1 THEN
       CurFile = -1: CurDir = -1: CurDrive = 0
   ELSEIF CurDrive > -1 THEN
       CurFile = FinView: CurDir = -1: CurDrive = -1
   END IF
   GOSUB DrawFileBox
   GOSUB DrawDirBox
   GOSUB DCL
 ELSEIF Cmd$ = CHR$(0) + "K" THEN               'left key: switch boxes
   IF CurFile > -1 THEN
       CurFile = -1: CurDir = -1: CurDrive = 0
   ELSEIF CurDir > -1 THEN
       CurFile = FinView: CurDir = -1: CurDrive = -1
   ELSEIF CurDrive > -1 THEN
       CurFile = -1: CurDir = DinView: CurDrive = -1
   END IF
   GOSUB DrawFileBox
   GOSUB DrawDirBox
   GOSUB DCL
 ELSEIF Cmd$ = CHR$(27) THEN                    'ESC pressed (abort)
   BtnSel = 2
   GOSUB DrawBtns
   LOCATE y + 4, x + 40
   COLOR 7, 7
   PRINT " ";
   COLOR 15, 2
   PRINT " Cancel ";
   LOCATE y + 5, x + 41
   COLOR 7, 7
   PRINT "        "
   GOSUB pause
   DirBox$ = ""
   ERASE Dir$, File$
   SCREEN 0, , OldS, OldS
   EXIT FUNCTION
 ELSEIF Cmd$ = CHR$(9) THEN                     'TAB (switch to OK & Cancel)
  BtnSel = 1
  GOSUB DrawBtns
   DO
    xCmd$ = UCASE$(INKEY$)
    IF xCmd$ = CHR$(0) + "H" THEN BtnSel = 1: GOSUB DrawBtns
    IF xCmd$ = CHR$(0) + "P" THEN BtnSel = 2: GOSUB DrawBtns
    IF xCmd$ = CHR$(9) THEN EXIT DO
    IF xCmd$ = CHR$(27) THEN
      BtnSel = 2
      GOSUB DrawBtns
      LOCATE y + 4, x + 40
      COLOR 7, 7
      PRINT " ";
      COLOR 15, 2
      PRINT " Cancel ";
      LOCATE y + 5, x + 41
      COLOR 7, 7
      PRINT "        "
      GOSUB pause
      DirBox$ = ""
      ERASE Dir$, File$
      SCREEN 0, , OldS, OldS
      EXIT FUNCTION
    END IF
    IF xCmd$ = CHR$(13) THEN
      IF BtnSel = 1 THEN
	LOCATE y + 2, x + 40
	COLOR 7, 7
	PRINT " ";
	COLOR 15, 2
	PRINT "   OK   ";
	LOCATE y + 3, x + 41
	COLOR 7, 7
	PRINT "        "
	GOSUB pause
	DirBox$ = ArgD$ + File$(CurFile)
	ERASE Dir$, File$
	SCREEN 0, , OldS, OldS
	EXIT FUNCTION
      END IF
      IF BtnSel = 2 THEN
	LOCATE y + 4, x + 40
	COLOR 7, 7
	PRINT " ";
	COLOR 15, 2
	PRINT " Cancel ";
	LOCATE y + 5, x + 41
	COLOR 7, 7
	PRINT "        "
	GOSUB pause
	DirBox$ = ""
	ERASE Dir$, File$
	SCREEN 0, , OldS, OldS
	EXIT FUNCTION
      END IF
    END IF
   LOOP
   BtnSel = 0
   GOSUB DrawBtns
 ELSE                                           'first letter of file/dir.
   IF CurFile > -1 THEN                         ' name
     f = 0
     FOR a = CurFile + 1 TO Allfiles
       IF UCASE$(LEFT$(File$(a), 1)) = Cmd$ THEN
	 CurFile = a
	 GOSUB DrawFileBox
	 f = 1
	 EXIT FOR
       END IF
     NEXT a
     IF f = 0 THEN
       FOR a = 0 TO Allfiles
	 IF UCASE$(LEFT$(File$(a), 1)) = Cmd$ THEN
	   CurFile = a
	   GOSUB DrawFileBox
	   f = 1
	   EXIT FOR
	 END IF
       NEXT a
     END IF
    END IF
   IF CurDir > -1 THEN
     f = 0
     FOR a = CurDir + 1 TO Alldirs
       IF UCASE$(LEFT$(Dir$(a), 1)) = Cmd$ THEN
	 CurDir = a
	 GOSUB DrawDirBox
	 f = 1
	 EXIT FOR
       END IF
     NEXT a
     IF f = 0 THEN
       FOR a = 0 TO Alldirs
	 IF UCASE$(LEFT$(Dir$(a), 1)) = Cmd$ THEN
	   CurDir = a
	   GOSUB DrawDirBox
	   f = 1
	   EXIT FOR
	 END IF
       NEXT a
     END IF
    END IF
 END IF

LOOP
ERASE Dir$, File$
SCREEN 0, , OldS, OldS
EXIT FUNCTION
	   '-------------------
DrawBackGr:                                     'draw the actual box
  COLOR 0, 7: LOCATE y, x: PRINT "É"; STRING$(52, "Í"); "»";
  FOR a = y + 1 TO y + 11
    LOCATE a, x
    PRINT "º"; STRING$(52, " "); "º";
  NEXT a
  LOCATE y + 12, x
  PRINT "È"; STRING$(52, "Í"); "¼";
  LOCATE y, x + 18: PRINT "¹"; : COLOR 15, 9
  PRINT " Select Files "; : COLOR 0, 7: PRINT "Ì";

  LOCATE y + 1, x + 6: COLOR 0, 7: PRINT " Files "; 'file box
  COLOR 15, 7: LOCATE y + 2, x + 2: PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";
  COLOR 0, 7: PRINT "¿";
  FOR a = y + 3 TO y + 9
    LOCATE a, x + 2
    COLOR 15, 7: PRINT "³              "; : COLOR 0, 7: PRINT "³";
  NEXT a
  LOCATE y + 10, x + 2
  COLOR 15, 7: PRINT "À"; : COLOR 0, 7: PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
 
  LOCATE y + 1, x + 21: COLOR 0, 7: PRINT " Directories "; 'directories box
  COLOR 15, 7: LOCATE y + 2, x + 20: PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";
  COLOR 0, 7: PRINT "¿";
  FOR a = y + 3 TO y + 9
    LOCATE a, x + 20
    COLOR 15, 7: PRINT "³              "; : COLOR 0, 7: PRINT "³";
  NEXT a
  LOCATE y + 10, x + 20
  COLOR 15, 7: PRINT "À"; : COLOR 0, 7: PRINT "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
  GOSUB DrawBtns
  LOCATE y + 7, x + 42: COLOR 15, 7: PRINT "DirBox"
  COLOR 8, 7
  LOCATE y + 9, x + 41: PRINT "By Hauke"
  LOCATE y + 10, x + 40: PRINT "Daempfling"
RETURN

DrawBtns:
  LOCATE y + 2, x + 40
  IF BtnSel = 1 THEN COLOR 15, 2 ELSE COLOR 0, 2 'OK/Cancel buttons
  PRINT "   OK   ";
  COLOR 0, 7
  PRINT "Ü";
  LOCATE y + 3, x + 41
  PRINT "ßßßßßßßß";

  LOCATE y + 4, x + 40
  IF BtnSel = 2 THEN COLOR 15, 2 ELSE COLOR 0, 2
  PRINT " Cancel ";
  COLOR 0, 7
  PRINT "Ü";
  LOCATE y + 5, x + 41
  PRINT "ßßßßßßßß";
RETURN
	 '--------------------------
GetFiles:                                       'get the files
  LOCATE y + 13, 1: PRINT "";                   'in case of error messages
  DosCmd$ = "DIR " + ArgD$ + ArgF$ + " /B /A-D /ON > C:\DIR.TMP" 'DIR command
  SHELL DosCmd$                                 'shell to DOS
  OPEN "C:\DIR.TMP" FOR INPUT AS #1
  InFile$ = INPUT$(LOF(1), #1)                  'read the file
  CLOSE #1
  KILL "C:\DIR.TMP"
  Allfiles = -1                                 'number of files in list
  NewLine$ = CHR$(13)                           'the new line character
  FOR a = 1 TO LEN(InFile$)                     'read the number of lines
    IF MID$(InFile$, a, 1) = NewLine$ THEN Allfiles = Allfiles + 1
  NEXT a
  IF Allfiles = -1 THEN RETURN                  'if the file is empty

  REDIM File$(Allfiles)                         'dimesion the file array
  Sloc = 1                                      'location pointer in InFile$
  File$(0) = LEFT$(InFile$, INSTR(InFile$, NewLine$) - 1) 'get first filename
  FOR a = 1 TO Allfiles                         'split the filenames
    Sloc = INSTR(Sloc + 2, InFile$, NewLine$)   'move the pointer
    IF Sloc = 0 OR INSTR(MID$(InFile$, Sloc + 2), NewLine$) = 0 THEN EXIT FOR
    File$(a) = LEFT$(MID$(InFile$, Sloc + 2), INSTR(MID$(InFile$, Sloc + 2), NewLine$) - 1)
  NEXT a
  FOR a = 0 TO Allfiles                         'check for empty strings
    IF File$(a) = "" THEN
      FOR b = a TO Allfiles - 1
       File$(b) = File$(b + 1)
      NEXT b
      Allfiles = Allfiles - 1
    END IF
  NEXT a
  InFile$ = ""
RETURN
	     '---------------------------
DrawFileBox:                                    'draw the file box
  IF CurFile = -1 THEN COLOR 0, 7 ELSE COLOR 15, 9
  LOCATE y + 1, x + 6: PRINT " Files ";
  IF CurFile = -1 OR Allfiles = -1 THEN RETURN  'if the file box isn't active
  LOCATE y + 3, x + 17: COLOR 7, 9: PRINT "";  ' don't redraw it
  LOCATE y + 9, x + 17: COLOR 7, 9: PRINT "";
  COLOR 1, 7
  FOR a = y + 4 TO y + 8
    LOCATE a, x + 17: PRINT "°";
  NEXT a
  IF Allfiles > 6 THEN
    CurSel = ((CurFile / Allfiles) * 100) \ 25  'location of scroll bar
    IF CurFile > FinView + 6 THEN FinView = CurFile - 6 'FinView is the first
    IF CurFile < FinView THEN FinView = CurFile         ' file in the box
    d = 0                                               ' (not CurFile)
    FOR a = FinView TO FinView + 6
      LOCATE y + 3 + d, x + 3
      IF a = CurFile THEN COLOR 15, 9 ELSE COLOR 0, 7   'if the file is sel.
      IF LEN(File$(a)) > 12 THEN                        'if the filename is
	PRINT " "; LEFT$(File$(a), 9); "..."            ' too long to be dis-
      ELSE                                              ' played fully
	PRINT " "; File$(a); SPACE$(12 - LEN(File$(a))); ' (Windoze 95)
      END IF
      d = d + 1
    NEXT a
  ELSE
    CurSel = 0                                          'scroll bar
    FOR a = 0 TO Allfiles                               'same as above
      LOCATE y + 3 + a, x + 3
      IF a = CurFile THEN COLOR 15, 9 ELSE COLOR 0, 7
      IF LEN(File$(a)) > 12 THEN
	PRINT " "; LEFT$(File$(a), 9); "..."
      ELSE
	PRINT " "; File$(a); SPACE$(12 - LEN(File$(a)));
      END IF
    NEXT a
    COLOR 0, 7
    FOR a = Allfiles + 1 TO 6 - Allfiles                'print spaces where
      LOCATE y + 3 + a, x + 3                           ' there aren't any
      PRINT "            ";                             ' filenames
    NEXT a
  END IF
  LOCATE y + 4 + CurSel, x + 17: COLOR 7, 1: PRINT "°"; ' scroll bar
RETURN
	  '---------------------
GetDirs:                                                'practically the same
  LOCATE y + 13, 1: PRINT "";                           ' as GetFiles
  DosCmd$ = "DIR " + ArgD$ + "*.* /B /AD /ON > C:\DIR.TMP"
  SHELL DosCmd$
  OPEN "C:\DIR.TMP" FOR INPUT AS #1
  InFile$ = INPUT$(LOF(1), #1)
  CLOSE #1
  KILL "C:\DIR.TMP"
  NewLine$ = CHR$(13)
  Alldirs = -1
  FOR a = 1 TO LEN(InFile$)
    IF MID$(InFile$, a, 1) = NewLine$ THEN Alldirs = Alldirs + 1
  NEXT a
  IF Alldirs = -1 AND LEN(ArgD$) = 3 THEN RETURN
 
  REDIM Dir$(Alldirs + 1)
  IF Alldirs = -1 THEN GOTO SkipFill:
  Sloc = 1
  Dir$(0) = LEFT$(InFile$, INSTR(InFile$, NewLine$) - 1)
  FOR a = 1 TO Alldirs
    Sloc = INSTR(Sloc + 2, InFile$, NewLine$)
    IF Sloc = 0 OR INSTR(MID$(InFile$, Sloc + 2), NewLine$) = 0 THEN EXIT FOR
    Dir$(a) = LEFT$(MID$(InFile$, Sloc + 2), INSTR(MID$(InFile$, Sloc + 2), NewLine$) - 1)
  NEXT a
  FOR a = 0 TO Alldirs
    IF Dir$(a) = "" THEN
      FOR b = a TO Alldirs - 1
       Dir$(b) = Dir$(b + 1)
      NEXT b
      Alldirs = Alldirs - 1
    END IF
  NEXT a
SkipFill:
  IF LEN(ArgD$) > 3 THEN                                'add the .. directory
    Alldirs = Alldirs + 1                               ' if needed
    IF Alldirs > 0 THEN
      FOR a = Alldirs - 1 TO 0 STEP -1
	Dir$(a + 1) = Dir$(a)
      NEXT a
      Dir$(0) = ".."
    ELSE
      Dir$(0) = ".."
    END IF
  END IF
  InFile$ = ""
RETURN
	     '---------------------------
DrawDirBox:                                             'again, the same as
  IF CurDir = -1 THEN COLOR 0, 7 ELSE COLOR 15, 9       ' DrawFileBox
  LOCATE y + 1, x + 21: PRINT " Directories ";
  IF CurDir = -1 OR Alldirs = -1 THEN RETURN
  LOCATE y + 3, x + 35: COLOR 7, 9: PRINT "";
  LOCATE y + 9, x + 35: COLOR 7, 9: PRINT "";
  COLOR 1, 7
  FOR a = y + 4 TO y + 8
    LOCATE a, x + 35: PRINT "°";
  NEXT a
  IF Alldirs > 6 THEN
    CurSel = ((CurDir / Alldirs) * 100) \ 25
    IF CurDir > DinView + 6 THEN DinView = CurDir - 6
    IF CurDir < DinView THEN DinView = CurDir
    d = 0
    FOR a = DinView TO DinView + 6
      LOCATE y + 3 + d, x + 21
      IF a = CurDir THEN COLOR 15, 9 ELSE COLOR 0, 7
      IF LEN(Dir$(a)) > 12 THEN
	PRINT " "; LEFT$(Dir$(a), 9); "..."
      ELSE
	PRINT " "; Dir$(a); SPACE$(12 - LEN(Dir$(a)));
      END IF
      d = d + 1
    NEXT a
    IF CurDir + 6 > Alldirs THEN
      COLOR 0, 7
      FOR a = d TO 6
       LOCATE y + 3 + a, x + 21
       PRINT "              ";
      NEXT a
    END IF
  ELSE
    CurSel = 0
    FOR a = 0 TO Alldirs
      LOCATE y + 3 + a, x + 21
      IF a = CurDir THEN COLOR 15, 9 ELSE COLOR 0, 7
      IF LEN(Dir$(a)) > 12 THEN
	PRINT " "; LEFT$(Dir$(a), 9); "..."
      ELSE
	PRINT " "; Dir$(a); SPACE$(12 - LEN(Dir$(a)));
      END IF
    NEXT a
    COLOR 0, 7
    FOR a = Alldirs + 1 TO 6 - Alldirs
      LOCATE y + 3 + a, x + 21
      PRINT "            ";
    NEXT a
  END IF
  LOCATE y + 4 + CurSel, x + 35: COLOR 7, 1: PRINT "°";
RETURN
	  '---------------------
DCL:                                                    'draw the current
LOCATE y + 11, x + 3                                    ' drive/dir.
IF CurDrive = -1 THEN COLOR 0, 7 ELSE COLOR 15, 9
IF LEN(ArgD$) > 32 THEN
  PRINT LEFT$(ArgD$, 32)
ELSE
  PRINT ArgD$; SPACE$(32 - LEN(ArgD$))
END IF
RETURN
	  '---------------------------
pause:                                                  'simple pause routine
 tim! = TIMER + .1
 DO: LOOP UNTIL TIMER >= tim!
RETURN
END FUNCTION

SUB DoEvents

xCmd$ = INKEY$
Cmd$ = UCASE$(xCmd$)
MouseGetInfo event
btn = event.buttons
x = event.x
y = event.y

TimeShow
IF Cmd$ = "Q" THEN
  Quit
END IF

IF btn = 0 AND Cmd$ = "" AND oldevent.x = x AND oldevent.y = y THEN
  'nothing
ELSE
  SSaver = TIMER + SSTime
END IF
oldevent = event

IF TIMER > SSaver THEN
  ScreenSaver
  SSaver = TIMER + SSTime
END IF

IF btn = 0 THEN EXIT SUB
IF Win(WinOn).Stat = Sized THEN
  IF x > Win(WinOn).Xpos AND y > Win(WinOn).Ypos AND x < Win(WinOn).Xpos + Win(WinOn).Xsize - 1 AND y < Win(WinOn).Ypos + Win(WinOn).Ysize THEN
   
    AcYes = TRUE
  ELSEIF y = Win(WinOn).Ypos AND x = Win(WinOn).Xpos + 2 THEN
    CloseWindow WinOn
    AcYes = TRUE
  ELSEIF y = Win(WinOn).Ypos AND x = Win(WinOn).Xpos + Win(WinOn).Xsize - 5 AND Win(WinOn).Fixed = FALSE THEN
    MinWindow WinOn
    AcYes = TRUE
  ELSEIF y = Win(WinOn).Ypos AND x = Win(WinOn).Xpos + Win(WinOn).Xsize - 3 AND Win(WinOn).Fixed = FALSE THEN
    MaxWindow WinOn
    AcYes = TRUE
  ELSEIF y = Win(WinOn).Ypos + Win(WinOn).Ysize AND x = Win(WinOn).Xpos + Win(WinOn).Xsize - 1 AND Win(WinOn).Fixed = FALSE THEN
    SizeWin x, y
    AcYes = TRUE
  ELSEIF y = Win(WinOn).Ypos AND x > Win(WinOn).Xpos + 3 AND x < Win(WinOn).Xpos + Win(WinOn).Xsize - 6 THEN
    MoveWin x, y
    AcYes = TRUE
  END IF
ELSEIF Win(WinOn).Stat = Max THEN
  IF y > 2 AND y < 25 THEN
    AcYes = TRUE

  ELSEIF y = 2 AND x = 3 THEN
    CloseWindow WinOn
    AcYes = TRUE
  ELSEIF y = 2 AND x = 76 THEN
    MinWindow WinOn
    AcYes = TRUE
  ELSEIF y = 2 AND x = 78 THEN
    SizebackWindow WinOn
    AcYes = TRUE
  END IF
ELSEIF Win(WinOn).Stat = Min THEN
  IF x >= Win(WinOn).IconX AND y >= Win(WinOn).IconY AND x <= Win(WinOn).IconX + 11 AND y <= Win(WinOn).IconY + 1 THEN
    AcYes = TRUE
    IF btn = 1 THEN
      SizebackWindow WinOn
    ELSE
      MoveIcon x, y
    END IF
  END IF
END IF
IF AcYes = TRUE THEN
DO
  MouseGetInfo event
  IF event.buttons = 0 THEN EXIT DO
LOOP
END IF
IF AcYes = FALSE THEN
  FOR a = 1 TO Wins
    IF a <> WinOn THEN
      IF Win(a).Stat = Sized THEN
	IF x >= Win(a).Xpos AND y >= Win(a).Ypos AND x <= Win(a).Xpos + Win(a).Xsize - 1 AND y <= Win(a).Ypos + Win(a).Ysize THEN
	  ActivateWin a
	  GOTO jumpout
	END IF
      ELSEIF Win(a).Stat = Min THEN
	IF x >= Win(a).IconX AND y >= Win(a).IconY AND x <= Win(a).IconX + 11 AND y <= Win(a).IconY + 1 THEN
	  ActivateWin a
	  GOTO jumpout
	END IF
      ELSEIF Win(a).Stat = Max THEN
	IF y > 1 AND y < 25 THEN
	  ActivateWin a
	  GOTO jumpout
	END IF
      END IF
    END IF
  NEXT a
END IF
jumpout:
IF y = 1 AND MenuOn = TRUE THEN
  IF x > 3 AND x < 8 THEN
    DrawMenu 1
    MouseGetInfo event
    DO
      IF MouseMove(event) = TRUE THEN EXIT DO
    LOOP
    DO
      MouseGetInfo event
      IF MouseButton(event, TRUE) = TRUE THEN EXIT DO
      IF INKEY$ <> "" THEN EXIT DO
      TimeShow
    LOOP
    nx = event.x
    ny = event.y
    IF nx > 2 AND nx < 18 THEN
      IF ny = 6 THEN
	LOCATE 6, 3
	COLOR 7, 0
	PRINT "  Quit WinDOS  ";
	syspause
	Quit
      END IF
      IF ny = 3 OR ny = 4 THEN BEEP
    END IF
    redraw
  ELSEIF x > 12 AND x < 20 THEN
    DrawMenu 2
    MouseGetInfo event
    DO
      IF MouseMove(event) = TRUE THEN EXIT DO
    LOOP
    DO
      MouseGetInfo event
      IF MouseButton(event, TRUE) = TRUE THEN EXIT DO
      IF INKEY$ <> "" THEN EXIT DO
      TimeShow
    LOOP
    nx = event.x
    ny = event.y
    IF nx > 11 AND nx < 28 THEN
      IF ny = 3 THEN
	LOCATE 3, 12
	COLOR 7, 0
	IF DrawShadow = TRUE THEN PRINT ">";  ELSE PRINT " ";
	PRINT " Draw Shadows    ";
	syspause
	IF DrawShadow = TRUE THEN DrawShadow = FALSE ELSE DrawShadow = TRUE
	FOR a = 1 TO Wins
	  CheckVals Win(a)
	NEXT a
      END IF
      IF ny = 4 THEN
	LOCATE 4, 12
	COLOR 7, 0
	PRINT "  Set Colors      ";
	syspause
	ColorChange
      END IF
      IF ny = 5 THEN
	LOCATE 5, 12
	COLOR 7, 0
	PRINT "  Arrange Windows ";
	syspause
	ox = -11
	IF StatLOn = TRUE THEN oy = 22 ELSE oy = 23
	FOR a = 1 TO Wins
	  IF NOT Win(a).Stat = Dead THEN
	    ox = ox + 13
	    IF ox > 67 THEN
	      ox = 2
	      oy = oy - 3
	    END IF
	    Win(a).IconX = ox
	    Win(a).IconY = oy
	  END IF
	NEXT a
	FOR a = 1 TO Wins
	  IF Win(a).Stat = Dead THEN
	    ox = ox + 13
	    IF ox > 67 THEN
	      ox = 2
	      oy = oy - 3
	    END IF
	    Win(a).IconX = ox
	    Win(a).IconY = oy
	  END IF
	NEXT a
	ox = 1: oy = 2
	FOR a = 1 TO Wins
	  IF NOT Win(a).Stat = Dead THEN
	    Win(a).Xpos = ox
	    Win(a).Ypos = oy
	    Win(a).Xsize = 50
	    Win(a).Ysize = 10
	    ox = ox + 1: oy = oy + 1
	  END IF
	NEXT a
	FOR a = 1 TO Wins
	  IF Win(a).Stat = Dead THEN
	    Win(a).Xpos = ox
	    Win(a).Ypos = oy
	    Win(a).Xsize = 50
	    Win(a).Ysize = 10
	    ox = ox + 1: oy = oy + 1
	  END IF
	NEXT a
      END IF
      IF ny = 6 THEN
	COLOR 7, 0
	LOCATE 6, 12
	PRINT "  Msg. Line ";
	IF StatLOn = TRUE THEN PRINT "off";  ELSE PRINT "on ";
	PRINT "   ";
	syspause
	IF StatLOn = TRUE THEN StatLOn = FALSE ELSE StatLOn = TRUE
      END IF
    END IF
  redraw
 ELSEIF x > 24 AND x < 32 THEN
    DrawMenu 3
    MouseGetInfo event
    DO
      IF MouseMove(event) = TRUE THEN EXIT DO
    LOOP
    DO
      MouseGetInfo event
      IF MouseButton(event, TRUE) = TRUE THEN EXIT DO
      IF INKEY$ <> "" THEN EXIT DO
      TimeShow
    LOOP
    nx = event.x
    ny = event.y
    DIM e(Wins + 2)
    r = 2
    FOR a = 1 TO Wins
      IF NOT Win(a).Stat = Dead THEN r = r + 1: e(r) = a
    NEXT a
    IF nx > 23 AND nx < 39 AND ny < r + 1 AND ny > 2 THEN
     LOCATE ny, 24
     COLOR 7, 0
     x$ = LEFT$(Win(e(ny)).Title, INSTR(Win(e(ny)).Title, "     "))
     IF e(ny) = WinOn THEN PRINT "> ";  ELSE PRINT "  ";
     IF LEN(x$) < 13 THEN
       PRINT x$; SPACE$(13 - LEN(x$));
     ELSE
       PRINT LEFT$(x$, 13);
     END IF
     syspause
     ActivateWin e(ny)
    END IF
    ERASE e
    redraw
  END IF
END IF
IF y = 1 AND x > 70 AND x < 81 THEN
  LOCATE 1, 71
  COLOR 7, 0
  PRINT " "; TIME$; " "
  syspause
  IF MenuOn = FALSE THEN
    MenuOn = TRUE
    FOR a = 1 TO Wins: CheckVals Win(a): NEXT a
  ELSE
    MenuOn = FALSE
  END IF
  redraw
  DO
    MouseGetInfo event
    IF event.buttons = 0 THEN EXIT DO
  LOOP
END IF
END SUB

SUB DrawMenu (WhatMen)
IF WhatMen = 1 THEN
  LOCATE 1, 3
  COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  PRINT " File ";
  COLOR TC(CurTCol, 2), TC(CurTCol, 3)
  LOCATE 2, 2
  PRINT "ÚÄÙ  ÀÄÄÄÄÄÄÄÄÄÄ¿";
  LOCATE 3, 2
  PRINT "³               ³";
  LOCATE 4, 2
  PRINT "³               ³";
  LOCATE 5, 2
  PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´";
  LOCATE 6, 2
  PRINT "³  Quit WinDOS  ³";
  LOCATE 7, 2
  PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
ELSEIF WhatMen = 2 THEN
  LOCATE 1, 12
  COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  PRINT " Options ";
  COLOR TC(CurTCol, 2), TC(CurTCol, 3)
  LOCATE 2, 11
  PRINT "ÚÄÙ     ÀÄÄÄÄÄÄÄÄÄÄ¿";
  LOCATE 3, 11
  PRINT "³";
  IF DrawShadow = TRUE THEN PRINT ">";  ELSE PRINT " ";
  PRINT " Draw Shadows    ³";
  LOCATE 4, 11
  PRINT "³  Set Colors      ³";
  LOCATE 5, 11
  PRINT "³  Arrange Windows ³";
  LOCATE 6, 11
  PRINT "³  Msg. Line ";
  IF StatLOn = TRUE THEN PRINT "off";  ELSE PRINT "on ";
  PRINT "   ³";
  LOCATE 7, 11
  PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
ELSEIF WhatMen = 3 THEN
  LOCATE 1, 24
  COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  PRINT " Windows ";
  COLOR TC(CurTCol, 2), TC(CurTCol, 3)
  LOCATE 2, 23
  PRINT "ÚÄÙ     ÀÄÄÄÄÄÄÄ¿";
  r = 2
  FOR a = 1 TO Wins
    IF NOT Win(a).Stat = Dead THEN
     x$ = LEFT$(Win(a).Title, INSTR(Win(a).Title, "     "))
     r = r + 1
     LOCATE r, 23
     PRINT "³";
     IF a = WinOn THEN PRINT "> ";  ELSE PRINT "  ";
     IF LEN(x$) < 13 THEN
       PRINT x$; SPACE$(13 - LEN(x$));
     ELSE
       PRINT LEFT$(x$, 13);
     END IF
     PRINT "³";
    END IF
  NEXT a
  LOCATE r + 1, 23
  PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ";
END IF
END SUB

SUB DrawWindow (WhatWin AS WinType)
MouseHide
x$ = LEFT$(WhatWin.Title, INSTR(WhatWin.Title, "     ") - 1)
Xp = WhatWin.Xpos
Xs = WhatWin.Xsize
Yp = WhatWin.Ypos
Ys = WhatWin.Ysize
IF WhatWin.Stat = 1 THEN
  'draw top left+top right corners
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  LOCATE Yp, Xp
  'PRINT "Ú"; STRING$(Xs - 2, "Ä"); "¿";
  PRINT "Ú";
  LOCATE Yp, Xp + Xs - 1
  PRINT "¿";
  'draw window area
  FOR a = Yp + 1 TO Yp + Ys - 2
    LOCATE a, Xp
    COLOR TC(CurTCol, 8), TC(CurTCol, 9)
    PRINT "³";
    COLOR TC(CurTCol, 6), TC(CurTCol, 7)
    PRINT STRING$(Xs - 2, " ");
    COLOR TC(CurTCol, 8), TC(CurTCol, 9)
    PRINT "³";
    COLOR 7, 0
    'draw shadows if needed
    IF DrawShadow = TRUE THEN PRINT CHR$(SCREEN(a, Xp + Xs));
    IF DrawShadow = TRUE THEN PRINT CHR$(SCREEN(a, Xp + Xs + 1));
  NEXT a
    'this row is drawn individually because of the sizig corner
    LOCATE Yp + Ys - 1, Xp
    COLOR TC(CurTCol, 8), TC(CurTCol, 9)
    PRINT "³";
    COLOR TC(CurTCol, 6), TC(CurTCol, 7)
    PRINT STRING$(Xs - 2, " ");
    COLOR TC(CurTCol, 8), TC(CurTCol, 9)
    IF WhatWin.Fixed = FALSE THEN PRINT "Á";  ELSE PRINT "³";
    COLOR 7, 0
    IF DrawShadow = TRUE THEN PRINT CHR$(SCREEN(a, Xp + Xs));
    IF DrawShadow = TRUE THEN PRINT CHR$(SCREEN(a, Xp + Xs + 1));
  'draw the bottom row
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  LOCATE Yp + Ys, Xp
  PRINT "À"; STRING$(Xs - 3, "Ä");
  IF WhatWin.Fixed = FALSE THEN PRINT "´ ";  ELSE PRINT "ÄÙ";
  COLOR 7, 0
  'draw all other shadows
  IF DrawShadow = TRUE THEN PRINT CHR$(SCREEN(Yp + Ys, Xp + Xs));
  IF DrawShadow = TRUE THEN PRINT CHR$(SCREEN(Yp + Ys, Xp + Xs + 1));
  IF DrawShadow = TRUE THEN
    FOR a = Xp + 2 TO Xp + Xs + 1
      LOCATE Yp + Ys + 1, a
      PRINT CHR$(SCREEN(Yp + Ys + 1, a));
    NEXT a
  END IF
  'draw close button
  LOCATE Yp, Xp + 1
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  PRINT "´þ³";
  'draw title bar
  IF WhatWin.Active = TRUE THEN
    COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  ELSE
    COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  END IF
  'draw title
  LOCATE Yp, Xp + 4
  IF LEN(x$) < Xs - 10 THEN
    PRINT x$ + SPACE$(Xs - 10 - LEN(x$));
  ELSE
    PRINT LEFT$(x$, Xs - 10);
  END IF
  'draw max/min btns if it isn't fixed
  LOCATE Yp, Xp + Xs - 6
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  IF WhatWin.Fixed = FALSE THEN
     PRINT "³³Ã";
  ELSE
     PRINT "ÃÄÄÄÄ";
  END IF

ELSEIF WhatWin.Stat = 2 THEN
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  LOCATE 2, 1
  PRINT STRING$(80, "Ä");
  COLOR TC(CurTCol, 6), TC(CurTCol, 7)
  FOR a = 3 TO 24
    PRINT SPACE$(80);
  NEXT a
  LOCATE 2, 2
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  PRINT "´þ³";
  COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  PRINT SPACE$(70);
  COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  PRINT "³³Ã";
  LOCATE 2, 40 - INT(LEN(x$) / 2)
  COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  PRINT x$;
  IF StatLOn = FALSE THEN
    LOCATE 25, 1
    COLOR TC(CurTCol, 6), TC(CurTCol, 7)
    PRINT SPACE$(80);
  END IF
ELSEIF WhatWin.Stat = 4 THEN
  'draw non-see-through borders of window
  COLOR 15, 0
  LOCATE Yp, Xp
  PRINT "Ú"; STRING$(Xs - 2, "Ä"); "¿";
  FOR a = Yp + 1 TO Yp + Ys - 1
    LOCATE a, Xp
    PRINT "³";
    LOCATE a, Xp + Xs - 1
    PRINT "³";
  NEXT a
  LOCATE Yp + Ys, Xp
  PRINT "À"; STRING$(Xs - 2, "Ä"); "Ù";

ELSEIF WhatWin.Stat = 5 THEN
  'draw see-through borders of window (not used often)
  COLOR 15, 0
  LOCATE Yp, Xp
  FOR a = Xp TO Xp + Xs - 1
    PRINT CHR$(SCREEN(Yp, a));
  NEXT a
  FOR a = Yp + 1 TO Yp + Ys - 1
    LOCATE a, Xp
    PRINT CHR$(SCREEN(a, Xp));
    LOCATE a, Xp + Xs - 1
    PRINT CHR$(SCREEN(a, Xp + Xs - 1));
  NEXT a
  LOCATE Yp + Ys, Xp
  FOR a = Xp TO Xp + Xs - 1
    PRINT CHR$(SCREEN(Yp + Ys, a));
  NEXT a
ELSEIF WhatWin.Stat = 3 THEN
  LOCATE WhatWin.IconY, WhatWin.IconX
  IF WhatWin.Active = FALSE THEN
    COLOR TC(CurTCol, 8), TC(CurTCol, 9)
  ELSE
    COLOR TC(CurTCol, 4), TC(CurTCol, 5)
  END IF
  PRINT "Ú";
  PRINT LEFT$(WhatWin.Title, 10);
  PRINT "¿";
  LOCATE WhatWin.IconY + 1, WhatWin.IconX
  PRINT "ÀÄÄÄÄÄÄÄÄÄÄÙ";
END IF
MouseShow
END SUB

FUNCTION EditBox$ (Def$, x, y)
LOCATE y, x
PRINT Def$;
L = 0              'location of cursor in the Box
LOCATE y + L, x, 1
Dlen = LEN(Def$)
' H
'K M
' P
DO

  DO: a$ = INKEY$: LOOP WHILE LEN(a$) = 0
  SELECT CASE (a$)
   CASE CHR$(8)
     IF L > 0 THEN
       IF L = LEN(Def$) THEN
	 Def$ = LEFT$(Def$, LEN(Def$) - 1)
	 L = L - 1
       ELSE
	 Def$ = LEFT$(Def$, L - 1) + MID$(Def$, L + 1)
	 L = L - 1
       END IF
     END IF
   CASE CHR$(16)
     IF L < LEN(Def$) THEN
       IF L = 0 THEN
	 Def$ = RIGHT$(Def$, LEN(Def$) - 1) + " "
	 L = L - 1
       ELSE
	 Def$ = LEFT$(Def$, L - 1) + MID$(Def$, L + 1)
	 L = L - 1
       END IF
     END IF
   CASE CHR$(0) + "M"
     IF L < Dlen THEN L = L + 1
   CASE CHR$(0) + "K"
     IF L > 0 THEN L = L - 1
   CASE CHR$(0) + CHR$(79)
     L = LEN(RTRIM$(Def$))
   CASE CHR$(0) + CHR$(71)
     L = 0
   CASE CHR$(27)
    EditBox$ = ""
    EXIT DO
   CASE CHR$(13)
    EditBox$ = RTRIM$(Def$)
    EXIT DO
   CASE ELSE
     Def$ = Def$ + SPACE$(Dlen - LEN(Def$))
     IF LEN(a$) = 1 AND L < Dlen THEN MID$(Def$, L + 1, 1) = a$: L = L + 1
  END SELECT
  LOCATE y, x, 0
  PRINT Def$ + SPACE$(Dlen - LEN(Def$));
  LOCATE y, x + L, 1
LOOP
LOCATE y, x, 0
PRINT Def$;
END FUNCTION

SUB MaxWindow (WhatWin)
Win(WhatWin).Stat = Max
DrawWindow Win(WhatWin)
END SUB

SUB MinWindow (WhatWin)
Win(WhatWin).Stat = Min
redraw
END SUB

DEFSNG A-L, N-Z
	FUNCTION MouseButton (event AS MouseEvent, debounce AS INTEGER)
	' ---------------------------=< MouseButton >=-------------------------
	' Detects whether or not a mouse button has been pressed.  Works the
	' same way as MouseMove (returns TRUE and updates passed MouseEvent
	' structure if button pressed, else returns FALSE).  The second
	' parameter of the function determines whether or not the buttons will
	' be "debounced" after reading a press.  Debouncing means that the
	' function will wait until the button is no longer pressed anymore
	' before it returns to the caller.  This is a good thing to use,
	' because a single click of a mouse button can often produce several
	' button-press events, due to the sensitivity of the mouse buttons.
	' Using the debounce option (passing TRUE, or any non-zero value, as
	' the second parameter) eliminates these extra button-press events and
	' prevents possible problems with thinking the user has clicked more
	' than he has.  However, I left the option of not debouncing because
	' it is possible you may want to keep track of held-down buttons (for
	' dragging the mouse through pull-down menus, or other such things
	' where the user must hold down the button); in this case, simply pass
	' FALSE (0) as the second parameter.

		IF mINIT = 0 THEN           ' Not initialized/available
			MouseButton = 0
			EXIT FUNCTION
		END IF

		inreg.ax = 3
		CALL INTERRUPT(&H33, inreg, outreg)     ' Get pos/button info
		IF outreg.bx > 0 THEN           ' a button(s) is pressed
			event.buttons = outreg.bx
			IF mGRAPHICS = 0 THEN       ' text mode
				outreg.cx = INT(outreg.cx / 8) + 1
				outreg.dx = INT(outreg.dx / 8) + 1
			ELSEIF mGRAPHICS = 1 THEN   ' graphics mode 1
				outreg.cx = INT(outreg.cx / 2)
			END IF
			event.x = outreg.cx
			event.y = outreg.dx
			mXlast = outreg.cx
			mYlast = outreg.dx
			IF debounce <> 0 THEN       ' User wants to debounce buttons
				WHILE outreg.bx > 0     ' While a button(s) is pressed...
					CALL INTERRUPT(&H33, inreg, outreg) ' get pos/button info
				WEND
			END IF
			MouseButton = NOT 0
		ELSE
			MouseButton = 0
		END IF
	END FUNCTION

	SUB MouseGetInfo (event AS MouseEvent)
	' --------------------------=< MouseGetInfo >=--------------------------
	' This subroutine gets the position of mouse pointer (actual screen
	' position, dependent upon screen mode), and the button info, whether
	' or not there is a new event (position has changed or button pressed).
	' The info is returned through the event parameter passed to it.
	' Note: Calling this subroutine updates the last known values for the
	' position of the mouse pointer, so that even if the position IS new
	' (it has moved), then calling MouseMove after calling this will NOT
	' reveal the change in position, as you've chosen to ignore the move
	' by calling this subroutine.
	' Note: No debouncing at all is done in this subroutine.  It simply
	' gives you the current status of the buttons, without caring whether
	' any of them are pressed or not.

		IF mINIT = 0 THEN           ' Not initialized/available
			EXIT SUB
		END IF
	   
		inreg.ax = 3
		CALL INTERRUPT(&H33, inreg, outreg)     ' Get position/button info
		IF mGRAPHICS = 0 THEN       ' Text mode
			outreg.cx = INT(outreg.cx / 8) + 1
			outreg.dx = INT(outreg.dx / 8) + 1
		ELSEIF mGRAPHICS = 1 THEN   ' Graphics mode 1
			outreg.cx = INT(outreg.cx / 2)
		END IF
		event.x = outreg.cx
		event.y = outreg.dx
		event.buttons = outreg.bx
		mXlast = outreg.cx
		mYlast = outreg.dx
	END SUB

	SUB MouseHide
	' ----------------------------=< MouseHide >=--------------------------
	' Hides the mouse pointer (shuts it off).  I advise hiding before every
	' CLS, then turning it back on with MouseShow after screen is fully
	' drawn (especially if changing screen color).  Otherwise, the pointer
	' may interfere with stuff being drawn on the screen.

		IF mINIT = 0 THEN           ' Not initialized/available
			EXIT SUB
		END IF

		inreg.ax = 2
		CALL INTERRUPT(&H33, inreg, outreg)     ' Hide the pointer
	END SUB

	FUNCTION MouseInit (mode AS INTEGER)
	' ---------------------------=< MouseInit >=---------------------------
	' Function which initializes the mouse for use.  The argument passed
	' should be 0 for normal text-mode (80 columns X 25 rows) screen, or
	' 1 for graphics-mode resolution 1 (320 X 200), or 2 for graphics-mode
	' resolution 2 (640 X 200; same as mouse's own virtual screen).  The
	' return value is 0 if no mouse is available for use, otherwise it is
	' the number of buttons available on the mouse.

		mGRAPHICS = mode
		inreg.ax = 0
		CALL INTERRUPT(&H33, inreg, outreg)     ' Reset mouse
		mINIT = outreg.ax
		IF mINIT <> 0 THEN           ' If a mouse is available...
			IF outreg.bx <> 0 THEN
				mINIT = outreg.bx   ' set # of buttons
			END IF
			inreg.ax = 7
			inreg.cx = 0            ' min column
			inreg.dx = 639          ' max column
			CALL INTERRUPT(&H33, inreg, outreg) ' Set min/max column
			inreg.ax = 8
			inreg.cx = 0            ' min row
			inreg.dx = 199          ' max row
			CALL INTERRUPT(&H33, inreg, outreg) ' Set min/max row
			inreg.ax = 1
			CALL INTERRUPT(&H33, inreg, outreg) ' Turn on pointer
			inreg.ax = 3
			CALL INTERRUPT(&H33, inreg, outreg) ' Get init pos & button info
			IF mGRAPHICS = 0 THEN       ' Text mode; convert virtual pos
				mXlast = INT(outreg.cx / 8) + 1
				mYlast = INT(outreg.dx / 8) + 1
			ELSEIF mGRAPHICS = 1 THEN   ' Graphics mode 1; convert virtual X
				mXlast = INT(outreg.cx / 2)
				mYlast = outreg.dx
			ELSE                        ' Grpahics mode 2; no conversion
				mXlast = outreg.cx
				mYlast = outreg.dx
			END IF
		END IF
		MouseInit = mINIT
	END FUNCTION

	FUNCTION MouseMove (event AS MouseEvent)
	' ---------------------------=< MouseMove >=---------------------------
	' Detects whether or not the mouse has moved from its last position
	' (actual screen position, which is dependent upon screen mode).  If a
	' movement has occured, -1 (TRUE) is returned and the passed MouseEvent
	' structure is filled in with the appropriate info.  If no movement has
	' occured, then 0 (FALSE) is returned, and nothing is filled in on the
	' passed MouseEvent structure.  (Note: Even though the button info is
	' returned along with the position info if a movement has occurred, no
	' debouncing of buttons is done.)

		IF mINIT = 0 THEN           ' Not initialized/available
			MouseMove = 0
			EXIT FUNCTION
		END IF

		inreg.ax = 3
		CALL INTERRUPT(&H33, inreg, outreg)     ' Get position/button info
		IF mGRAPHICS = 0 THEN       ' Text mode
			outreg.cx = INT(outreg.cx / 8) + 1
			outreg.dx = INT(outreg.dx / 8) + 1
		ELSEIF mGRAPHICS = 1 THEN   ' Graphics mode 1
			outreg.cx = INT(outreg.cx / 2)
		END IF
		IF mXlast <> outreg.cx OR mYlast <> outreg.dx THEN  ' mouse has moved
			event.x = outreg.cx
			event.y = outreg.dx
			event.buttons = outreg.bx
			mXlast = outreg.cx
			mYlast = outreg.dx
			MouseMove = NOT 0
		ELSE
			MouseMove = 0
		END IF
	END FUNCTION

	FUNCTION MouseNewEvent (event AS MouseEvent)
	' --------------------------=< MouseNewEvent >=-------------------------
	' This is sort of a combination of MouseMove and MouseButton.  It will
	' return TRUE if either the mouse pointer has moved from its last
	' position, or if a button has been pressed.  (Note: Debouncing is not
	' optional in this function; it always debounces.  If you need no
	' debouncing, then you'll have to use MouseButton and MouseMove
	' individually.)  a call to this function is essentially equivalent to
	' "MouseButton(event, TRUE) OR MouseMove(event)".

		IF mINIT = 0 THEN           ' Not initialized/available
			MouseNewEvent = 0
			EXIT FUNCTION
		END IF

		inreg.ax = 3
		CALL INTERRUPT(&H33, inreg, outreg)     ' Get position/button info
		IF mGRAPHICS = 0 THEN       ' Text mode
			outreg.cx = INT(outreg.cx / 8) + 1
			outreg.dx = INT(outreg.dx / 8) + 1
		ELSEIF mGRAPHICS = 1 THEN   ' Graphics mode 1
			outreg.cx = INT(outreg.cx / 2)
		END IF
		IF mXlast <> outreg.cx OR mYlast <> outreg.dx OR outreg.bx > 0 THEN
			event.x = outreg.cx
			event.y = outreg.dx
			event.buttons = outreg.bx
			mXlast = outreg.cx
			mYlast = outreg.dx
			WHILE outreg.bx > 0 ' debounce; While a button(s) is pressed...
				CALL INTERRUPT(&H33, inreg, outreg) ' get pos/button info
			WEND
			MouseNewEvent = NOT 0
		ELSE
			MouseNewEvent = 0
		END IF
	END FUNCTION

	SUB MouseSetPos (x AS INTEGER, y AS INTEGER)
	' ---------------------------=< MouseSetPos >=-------------------------
	' Sets the position of the mouse pointer.  The x argument is the column
	' to move to, and the y argument is the row to move to.  (Range of
	' legal values determined by screen mode, as set by MouseInit.  For
	' text-mode 0: x is 1 - 80, y is 1 - 25.  For graphics-mode 1: x is
	' 0 - 319, y is 0 - 199.  For graphics-mode 2: x is 0 - 639, y is
	' 0 - 199.)

		IF mINIT = 0 THEN           ' Not initialized/available
			EXIT SUB
		END IF

		IF mGRAPHICS = 0 THEN       ' Text mode
			IF x >= 1 AND x <= 25 AND y >= 1 AND y <= 80 THEN   ' Legal pos
				inreg.ax = 4
				inreg.cx = (x - 1) * 8
				inreg.dx = (y - 1) * 8
				CALL INTERRUPT(&H33, inreg, outreg)     ' Set position
				mXlast = x
				mYlast = y
			END IF
		ELSEIF mGRAPHICS = 1 THEN   ' Graphics mode 1
			IF x >= 0 AND x <= 319 AND y >= 0 AND y <= 199 THEN ' Legal pos
				inreg.ax = 4
				inreg.cx = x * 2
				inreg.dx = y
				CALL INTERRUPT(&H33, inreg, outreg)     ' Set position
				mXlast = x
				mYlast = y
			END IF
		ELSE                        ' Graphics mode 2
			IF x >= 0 AND x <= 639 AND y >= 0 AND y <= 199 THEN ' Legal pos
				inreg.ax = 4
				inreg.cx = x
				inreg.dx = y
				CALL INTERRUPT(&H33, inreg, outreg)     ' Set position
				mXlast = x
				mYlast = y
			END IF
		END IF
	END SUB

	SUB MouseShow
	' ----------------------------=< MouseShow >=--------------------------
	' Shows the mouse pointer (turns it on).  See comments for MouseHide.
	' Pointer is automatically turned on initially by MouseInit.

		IF mINIT = 0 THEN           ' Not initialized/available
			EXIT SUB
		END IF

		inreg.ax = 1
		CALL INTERRUPT(&H33, inreg, outreg)     ' Show pointer
	END SUB

	SUB MouseTextPtr (scl AS INTEGER, sch AS STRING, cl AS INTEGER, ch AS STRING)
	' --------------------------=< MouseTextPtr >=----------------------------
	' This subroutine sets the color and shape of the text-mode mouse
	' pointer.  It normally defaults to simply a white block-cursor, but
	' you can change that with this subroutine.  The new pointer
	' attributes (cl, color of the pointer, and ch, character to use for the
	' pointer) will be XORed with the result of ANDing the screen attributes
	' (scl, screen color, and sch, screen character) with whatever is on the
	' screen where the pointer is to be, which will produce the color/shape
	' you see on the screen at that spot.  If you don't want the screen mask
	' to have any effect, just pass in an integer with all 1 bits (-1, TRUE,
	' or NOT 0 in Basic's two's complement method of storing integers).  The
	' colors and characters you pass in will be converted into bit masks.
	' Note: If you pass more than a single-character string as the char,
	' only the first character will be used.

		IF mINIT = 0 OR mGRAPHICS <> 0 THEN ' Not init., or not in text mode
			EXIT SUB
		END IF

		inreg.ax = &HA
		inreg.bx = 0
		inreg.cx = scl AND 127      ' ensure only 7-bit number
		inreg.dx = cl AND 127       ' ensure only 7-bit number
		inreg.cx = inreg.cx * 256   ' shift left by 8
		inreg.dx = inreg.dx * 256   ' shift left by 8
		inreg.cx = inreg.cx + ASC(LEFT$(sch, 1))    ' add char to bit mask
		inreg.dx = inreg.dx + ASC(LEFT$(ch, 1))     ' add char to bit mask
		CALL INTERRUPT(&H33, inreg, outreg)     ' define text cursor
	END SUB

DEFINT A-L, N-Z
SUB MoveIcon (x, y)
  gx = x - Win(WinOn).IconX
  gy = y - Win(WinOn).IconY
  ox = x
  oy = y
  DO
    MouseGetInfo event
    nx = event.x
    ny = event.y
    IF ox <> nx OR oy <> ny THEN
      Win(WinOn).IconX = nx - gx
      Win(WinOn).IconY = ny - gy
      CheckVals Win(WinOn)
      redraw
    END IF
    IF event.buttons = 0 THEN EXIT DO
    ox = nx
    oy = ny
  LOOP
END SUB

SUB MoveWin (x, y)
  Win(0) = Win(WinOn)
  Win(0).Stat = SizeHow
  redraw
  gx = x - Win(WinOn).Xpos
  ox = x
  oy = y
  DO
    MouseGetInfo event
    nx = event.x
    ny = event.y
    IF ox <> nx OR oy <> ny THEN
      Win(0).Xpos = nx - gx
      Win(0).Ypos = ny
      CheckVals Win(0)
      redraw
    END IF
    IF event.buttons = 0 THEN EXIT DO
    ox = nx
    oy = ny
  LOOP
  Win(0).Stat = Sized
  Win(WinOn) = Win(0)
  Win(0).Stat = Dead
  redraw
END SUB

FUNCTION OpenWindow (WhatWin AS WinType)

CheckVals WhatWin

New = 1
FOR a = 1 TO Wins
  IF Win(a).Stat = Dead THEN New = a: EXIT FOR
NEXT a

Win(New) = WhatWin
Win(New).CurX = 1
Win(New).CurY = 1
IF Win(New).Fixed = TRUE THEN Win(New).Stat = Sized
ActivateWin New

OpenWindow = New
END FUNCTION

SUB PackTxt (text$)
   d1$ = "  e  as  tinthouerhet anreesr d onn or o i y wo tontyo. neisarte"
   d2$ = "ed,  ctiy  bat snd fal pensestvengitu talehaurllcousa  mf dfoof "
   d3$ = "siril  hmeg om Icehironsasiossbedepe rli Tetel nicho lilprcactut"
   d4$ = "Thpaeceachh wige ebuaisursulmawaotowtsmploI solyee Cunm rtieno S"
   d5$ = "diwhs.rafincademe.irplk  ury Pwoacos gams,duayavucColamowe Aoopu"
   Dict$ = d1$ + d2$ + d3$ + d4$ + d5$
  
   IF NOT LEFT$(text$, 1) = CHR$(255) THEN
     IF LEN(text$) < 4 THEN EXIT SUB

     FOR a = 1 TO LEN(text$)
       v = ASC(MID$(text$, a, 1))
       IF v < 32 OR v > 127 THEN
	 IF v = 9 THEN
	   MID$(text$, a, 1) = " "
	 ELSEIF v = 10 THEN
	   MID$(text$, a, 1) = "~"
	 ELSEIF v = 13 THEN
	   MID$(text$, a, 1) = "~"
	 ELSE
	   EXIT SUB
	 END IF
       END IF
     NEXT a
    
     DO
      
       cnt = cnt + 1
       char$ = MID$(text$, cnt, 2)
      
       IF cnt = LEN(text$) THEN
	 text$ = CHR$(255) + temp$ + CHR$(ASC(MID$(text$, cnt, 1)) - 32)
	 EXIT SUB
       END IF
      
       xx = 1 'read pointer in Dict$
ReDo:
       x = INSTR(xx, Dict$, char$)
       IF x THEN
	 IF (x \ 2) = (x / 2) THEN
	   xx = x + 1
	   GOTO ReDo
	 END IF
	 temp$ = temp$ + CHR$((x \ 2) + 96)
	 cnt = cnt + 1
       ELSE
	 temp$ = temp$ + CHR$(ASC(MID$(text$, cnt, 1)) - 32)
       END IF
     LOOP WHILE cnt < LEN(text$)
     text$ = CHR$(255) + temp$
     EXIT SUB
   ELSE
     comp$ = RIGHT$(text$, LEN(text$) - 1)
     text$ = ""
     FOR x = 1 TO LEN(comp$)
       char = ASC(MID$(comp$, x, 1))
       IF char > 95 THEN
	 text$ = text$ + MID$(Dict$, (char - 96) * 2 + 1, 2)
       ELSE
	 text$ = text$ + CHR$(ASC(MID$(comp$, x, 1)) + 32)
       END IF
     NEXT x
   END IF
END SUB

DEFSNG A-Z
SUB pause (tim)
a& = TIMER + tim
DO: LOOP UNTIL TIMER > a&
END SUB

DEFINT A-Z
SUB Quit
OPEN path$ + "WinDOS.PAL" FOR OUTPUT AS #1
FOR a = 0 TO 9
  FOR b = 0 TO 11
    PRINT #1, TC(a, b)
  NEXT b
  PRINT #1, TCName$(a)
  IF TCName$(a + 1) = "" THEN PRINT #1, 999: EXIT FOR
NEXT a
PRINT #1, CurTCol
PRINT #1, MenuOn
PRINT #1, StatLOn
PRINT #1, DrawShadow
CLOSE #1

OPEN path$ + "WinDOS.SAV" FOR RANDOM AS #2
PUT #2, 1, Wins
FOR a = 1 TO Wins
  PUT #2, a + 1, Win(a)
NEXT a
CLOSE #2


MouseHide
SCREEN 0, , 0, 0
COLOR 7, 0
CLS
PRINT "Goodbye.";
END
END SUB

SUB redraw
MouseHide

'copy current VS into BS so it can be displayed
PCOPY VS, BS

'display BS and work on VS
SCREEN 0, , VS, BS
WAIT &H3DA, 8 '<-- wait for vertical retrace (reduces flicker)
rredraw

'switch back to VS
SCREEN 0, , VS, VS

MouseShow
END SUB

SUB rredraw
STATIC redtimes
redtimes = redtimes + 1
STATIC BackChar
BackChar = 176

MouseHide

LOCATE 1, 1, 0
IF MenuOn = TRUE THEN
  COLOR TC(CurTCol, 2), TC(CurTCol, 3)
  PRINT "   File     Options     Windows                                                 ";
ELSE
  COLOR TC(CurTCol, 0), TC(CurTCol, 1)
  PRINT STRING$(80, CHR$(BackChar));
END IF
TimeShow
COLOR TC(CurTCol, 0), TC(CurTCol, 1)
FOR a = 2 TO 24
  LOCATE a, 1
  PRINT STRING$(80, CHR$(BackChar));
NEXT a
IF StatLOn = FALSE THEN
  LOCATE 25, 1
  PRINT STRING$(80, CHR$(BackChar));
ELSE
  StatLine ""
END IF
FOR a = 1 TO Wins
  IF Win(a).Stat = Min AND a <> WinOn THEN DrawWindow Win(a)
NEXT a
FOR a = 1 TO Wins
  IF Win(a).Stat = Sized AND a <> WinOn THEN DrawWindow Win(a)
NEXT a
FOR a = 1 TO Wins
  IF Win(a).Stat = Max AND a <> WinOn THEN DrawWindow Win(a)
NEXT a

IF NOT Win(WinOn).Stat = Dead THEN DrawWindow Win(WinOn)
IF NOT Win(0).Stat = Dead THEN DrawWindow Win(0)

MouseShow
END SUB

SUB ScreenSaver
MouseGetInfo event
PCOPY VS, BS
SCREEN 0, , BS, BS
DO
x = INT(RND(1) * 80) + 1
y = INT(RND(1) * 25) + 1
col1 = INT(RND(1) * 15)
col2 = INT(RND(1) * 15)
LOCATE y, x
COLOR col1, col2
PRINT "Ü";
IF INKEY$ <> "" OR MouseNewEvent(event) = TRUE THEN EXIT DO
LOOP
redraw
END SUB

SUB SizebackWindow (WhatWin)
Win(WhatWin).Stat = Sized
CheckVals Win(WhatWin)
redraw
END SUB

SUB SizeWin (x, y)
  Win(0) = Win(WinOn)
  Win(0).Stat = SizeHow
  redraw
  ox = x
  oy = y
  DO
    MouseGetInfo event
    nx = event.x
    ny = event.y
    IF ox <> nx OR oy <> ny THEN
      Win(0).Xsize = Win(0).Xsize + nx - ox
      Win(0).Ysize = Win(0).Ysize + ny - oy
      CheckVals Win(0)
      redraw
    END IF
    IF event.buttons = 0 THEN EXIT DO
    ox = nx
    oy = ny
  LOOP
  Win(0).Stat = Sized
  Win(WinOn) = Win(0)
  Win(0).Stat = Dead
  redraw
END SUB

SUB StatLine (what$)
IF StatLOn = FALSE THEN EXIT SUB
LOCATE 25, 1
COLOR TC(CurTCol, 10), TC(CurTCol, 11)
PRINT SPACE$(80);
LOCATE 25, 40 - INT(LEN(what$) / 2)
PRINT what$;
END SUB

SUB syspause
a# = TIMER + .15
DO: LOOP UNTIL TIMER > a#
END SUB

SUB TimeShow
LOCATE 1, 71
COLOR TC(CurTCol, 2), TC(CurTCol, 3)
PRINT " "; TIME$; " ";
END SUB

SUB WinPrint (WhatWin, text$)
IF Win(WhatWin).Stat = Dead THEN EXIT SUB
IF WhatWin <> WinOn THEN EXIT SUB
IF Win(WhatWin).Stat = Sized THEN
  IF Win(WhatWin).CurY > 23 THEN Win(WhatWin).CurY = 0
  IF Win(WhatWin).CurY > Win(WhatWin).Ysize - 2 THEN EXIT SUB
  IF LEN(text$) > Win(WhatWin).Xsize - 2 THEN text$ = LEFT$(text$, Win(WhatWin).Xsize - 2)
  LOCATE Win(WhatWin).Ypos + Win(WhatWin).CurY + 1, Win(WhatWin).Xpos + Win(WhatWin).CurX + 1
  COLOR TC(CurTCol, 6), TC(CurTCol, 7)
  PRINT text$;
  Win(WhatWin).CurY = Win(WhatWin).CurY + 1
END IF
END SUB

