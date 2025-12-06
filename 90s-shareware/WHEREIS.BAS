DEFINT A-Z

' Declare symbolic constants used in program:
CONST EOFTYPE = 0, FILETYPE = 1, DIRTYPE = 2, ROOT = "TWH"

DECLARE SUB ScanDir (pathspec$, Level, filespec$, row, pt$)

DECLARE FUNCTION MakeFileName$ (Num)
DECLARE FUNCTION GetEntry$ (FileNum, EntryType)

CLS
INPUT "File to look for"; filespec$
PRINT
PRINT "Enter the directory where the search should start"
PRINT "(optional drive + directories). Press <ENTER> to begin"
PRINT "the search in the root directory of the current drive."
PRINT
INPUT "Starting directory"; pathspec$
1 INPUT "Print results(Y\N)"; pt$
SELECT CASE pt$
        CASE "y"
                pt$ = "1"
        CASE "Y"
                pt$ = "1"
        CASE "n"
                GOTO 1
        CASE "N"
                GOTO 1
        CASE ELSE
                GOTO 1
END SELECT
CLS
RightCh$ = RIGHT$(pathspec$, 1)

IF pathspec$ = "" OR RightCh$ = ":" OR RightCh$ <> "\" THEN
   pathspec$ = pathspec$ + ">"
END IF

filespec$ = UCASE$(filespec$)
pathspec$ = UCASE$(pathspec$)
Level = 1
row = 3

' Make the top level call (level 1) to begin the search:
ScanDir pathspec$, Level, filespec$, row, pt$

KILL ROOT + ".*"        ' Delete all temporary files created
                        ' by the program.

LOCATE row + 1, 1: PRINT "Search complete."
END

'
' ======================= GETENTRY ==========================
'    This procedure processes entry lines in a DIR listing
'    saved to a file.
' ===========================================================
'
FUNCTION GetEntry$ (FileNum, EntryType) STATIC

   ' Loop until a valid entry or end-of-file (EOF) is read:
   DO UNTIL EOF(FileNum)
      LINE INPUT #FileNum, EntryLine$
      IF EntryLine$ <> "" THEN

         ' Get first character from the line for test:
         TestCh$ = LEFT$(EntryLine$, 1)
         IF TestCh$ <> " " AND TestCh$ <> "." THEN EXIT DO
      END IF
   LOOP

   ' Entry or EOF found, decide which:
   IF EOF(FileNum) THEN
      EntryType = EOFTYPE
      GetEntry$ = ""

   ELSE           ' Not EOF, either a file or a directory.

      ' Build and return the entry name:
      EntryName$ = RTRIM$(LEFT$(EntryLine$, 8))

      ' Test for extension and add to name if there is one:
      EntryExt$ = RTRIM$(MID$(EntryLine$, 10, 3))
      IF EntryExt$ <> "" THEN
         GetEntry$ = EntryName$ + "." + EntryExt$
      ELSE
         GetEntry$ = EntryName$
      END IF

      ' Determine the entry type, and return that
      ' value to the point where GetEntry$ was called:
      IF MID$(EntryLine$, 15, 3) = "DIR" THEN
         EntryType = DIRTYPE            ' Directory
      ELSE
         EntryType = FILETYPE           ' File
      END IF

   END IF

END FUNCTION

'
' ===================== MAKEFILENAME$ =======================
'    This procedure makes a file name from a root string
'    ("TWH" - defined as a symbolic constant at the module
'    level) and a number passed to it as an argument (Num).
' ===========================================================
'
FUNCTION MakeFileName$ (Num) STATIC

   MakeFileName$ = ROOT + "." + LTRIM$(STR$(Num))

END FUNCTION

'
' ======================= SCANDIR ===========================
'   This procedure recursively scans a directory for the
'   file name entered by the user.
'
'   NOTE: The SUB header doesn't use the STATIC keyword
'         since this procedure needs a new set of variables
'         each time it is invoked.
' ===========================================================
'
SUB ScanDir (pathspec$, Level, filespec$, row, pt$)

   LOCATE 1, 1: PRINT "Now searching"; SPACE$(50);
   LOCATE 1, 15: PRINT pathspec$;

   ' Make a file specification for the temporary file:
   TempSpec$ = MakeFileName$(Level)

   ' Get a directory listing of the current directory, and
   ' save it in the temporary file:
   SHELL "DIR " + pathspec$ + " > " + TempSpec$

   ' Get the next available file number:
   FileNum = FREEFILE

   ' Open the DIR listing file and scan it:
   OPEN TempSpec$ FOR INPUT AS #FileNum

   ' Process the file, one line at a time:
   DO

      ' Get an entry from the DIR listing:
      direntry$ = GetEntry$(FileNum, EntryType)

      ' If entry is a file:
      IF EntryType = FILETYPE THEN

         ' If the FileSpec$ string matches, print entry and
         ' exit this loop:
         IF pt$ = "1" THEN
         IF direntry$ = filespec$ THEN
            IF RIGHT$(pathspec$, 1) = "\" THEN
            LPRINT pathspec$; direntry$; " ";
            ELSE
            LPRINT pathspec$ + "\" + direntry$; " ";
            END IF
         END IF
         IF LEFT$(filespec$, 1) = "*" THEN
         IF RIGHT$(filespec$, 3) = RIGHT$(direntry$, 3) THEN
            IF RIGHT$(pathspec$, 1) = "\" THEN
            LPRINT pathspec$; direntry$; " ";
            ELSE
            LPRINT pathspec$ + "\" + direntry$; " ";
            END IF
            END IF
         END IF
         END IF
        
         IF direntry$ = filespec$ THEN
            IF RIGHT$(pathspec$, 1) = "\" THEN
            LOCATE row, 1: PRINT pathspec$; direntry$;
            ELSE
            LOCATE row, 1: PRINT pathspec$ + "\" + direntry$;
            END IF
            row = row + 1
            EntryType = EOFTYPE
         END IF
         IF LEFT$(filespec$, 1) = "*" THEN
         IF RIGHT$(filespec$, 3) = RIGHT$(direntry$, 3) THEN
            IF RIGHT$(pathspec$, 1) = "\" THEN
            LOCATE row, 1: PRINT pathspec$; direntry$;
            ELSE
            LOCATE row, 1: PRINT pathspec$ + "\" + direntry$;
            END IF
            row = row + 1
            IF row > 25 THEN
            CLS
            row = 1
            END IF
            'EntryType = EOFTYPE
         END IF
         END IF
      ' If the entry is a directory, then make a recursive
      ' call to ScanDir with the new directory:
      ELSEIF EntryType = DIRTYPE THEN
         IF pathspec$ = "C:\" THEN
         NewPath$ = pathspec$ + direntry$
         ELSE
         NewPath$ = pathspec$ + "\" + direntry$
         END IF
         ScanDir NewPath$, Level + 1, filespec$, row, pt$
         LOCATE 1, 1: PRINT "Now searching"; SPACE$(50);
         LOCATE 1, 15: PRINT pathspec$;
         count = count + 1
      END IF

   LOOP UNTIL EntryType = EOFTYPE

   ' Scan on this DIR listing file is finished, so close it:
   CLOSE FileNum
   count = -3
END SUB

