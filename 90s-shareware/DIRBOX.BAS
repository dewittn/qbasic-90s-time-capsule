DECLARE FUNCTION DirBox$ (ArgD$, ArgF$)
'          DirBox 1.0b
'       By Hauke Daempfling
'Jan 1996

' This program displays a file box in which the
' user can select a file (duh). It's just the 'beta
' version' right now. In other words, it works but still
' I don't have all the bugs out.

' It works pretty simple: it SHELLs the DOS dir command
' so it puts the plain list of files or directories into
' a file. Then the file is taken and split up into an array
' wherever there is CHR$(13). Then the user can select a file
' from the array (list).
' NOTE: The program assumes that you are using screen page 0
' and it uses page 1. If you are using or not using these pages
' you can change the values in the first line of DirBox.

'I would appreciate it that if you fix any bugs in the program
'that you could EMail the changes to hcd@berlin.snafu.de. Thanks :)

'here a litttle demo:
SCREEN 0
CLS
FOR x = 1 TO 80       'random background
  FOR y = 1 TO 25
   LOCATE y, x
   PRINT CHR$(INT(RND * 26) + 65);
  NEXT y
NEXT x
a$ = DirBox$("C:\", "*.*") 'start DirBox
LOCATE 1, 1
COLOR 4, 7
IF a$ = "" THEN PRINT "You aborted." ELSE PRINT "You selected: "; a$
a$ = DirBox$("C:\", "*.EXE")
COLOR 4, 7
IF a$ = "" THEN PRINT "You aborted." ELSE PRINT "You selected: "; a$:
COLOR 4, 7
PRINT "-*-*- END OF DEMO -*-*-"

DEFINT A-Z
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
     GOSUB Pause
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
   GOSUB Pause
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
      GOSUB Pause
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
        GOSUB Pause
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
        GOSUB Pause
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
Pause:                                                  'simple pause routine
 tim! = TIMER + .1
 DO: LOOP UNTIL TIMER >= tim!
RETURN
END FUNCTION

