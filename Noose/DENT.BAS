'DENT.BAS
'Helps programers maintain neat/pretty code.
'Released to Public domain by Paul Hurst in 1995
'
'Please use this to it's fullest extent!
'
'PLEASE don't take this code, put your name on it, compile
'it and sell it or anything. That type of thing really
'ticks me off.

DEFINT A-Z
DECLARE FUNCTION Changesub$ (St$, Way%)
DECLARE FUNCTION Getparams% ()
DECLARE FUNCTION Mcase$ (St$)
DECLARE FUNCTION Trim$ (St$)
DECLARE FUNCTION Getfilename$ (Default$, Ext$, X%, Y%)
DECLARE FUNCTION Addext$ (File$, Ext$)
DECLARE FUNCTION Getword$ (St$, WordNum%)
DECLARE FUNCTION Secondword$ (W$)
DECLARE FUNCTION Firstword$ (W$)
DECLARE SUB Processfile ()
DECLARE SUB Center (ROW%, St$)
CONST TRUE = 1, FALSE = NOT TRUE
DIM SHARED FunctionChange, SubChange, SpaceIndent
DIM SHARED Inputfile$, OutPutFile$
FunctionChange = 3
SubChange = 3
SpaceIndent = 3
DO
   Result = GetParams
   IF Result <> 0 THEN
      OPEN Inputfile$ FOR INPUT AS #1
      OPEN OutPutFile$ FOR OUTPUT AS #2
      ProcessFile
      CLOSE #1
      CLOSE #2
   END IF
LOOP UNTIL Result = 0

END

FUNCTION Addext$ (File$, Ext$)
   IF File$ = "" OR Ext$ = "" THEN EXIT FUNCTION
   Work$ = ""
   Period = INSTR(File$, ".")
   IF Period = 0 THEN
      Work$ = File$ + "." + Ext$
   ELSE
      Work$ = LEFT$(File$, Period - 1) + "." + Ext$
   END IF
   AddExt$ = Work$
END FUNCTION

SUB Center (ROW, St$)
   Col = (80 - LEN(St$)) / 2
   LOCATE ROW, Col: PRINT St$
END SUB

FUNCTION Changesub$ (St$, Way)
   Dec = INSTR(St$, "DECLARE")
   Line$ = St$
   IF Dec = 0 THEN
      TheName$ = GetWord$(Line$, 2)
   ELSE
      TheName$ = GetWord$(Line$, 3) ' sub/function name
   END IF
   Place = INSTR(Line$, TheName$)  ' where is it
   SELECT CASE Way
      CASE 1: TheName$ = UCASE$(TheName$)
      CASE 2: TheName$ = LCASE$(TheName$)
      CASE 3: TheName$ = MCASE$(TheName$)
   END SELECT
   MID$(Line$, Place, LEN(TheName$)) = TheName$
   ChangeSub$ = Line$
END FUNCTION

FUNCTION Firstword$ (W$)
   IF LEN(W$) = 0 THEN EXIT FUNCTION
   S = INSTR(W$, " ")
   IF S = 0 AND W$ <> "" THEN
      FirstWord$ = W$
   ELSE
      FirstWord$ = LEFT$(W$, S - 1)
   END IF
END FUNCTION

FUNCTION Getfilename$ (Default$, Ext$, X, Y)
   Begin$ = Default$
   Work$ = Default$
   MaxLen = 12
   LOCATE , , 1, 6, 7
   LOCATE Y, X: PRINT STRING$(MaxLen, 250)
   LOCATE Y, X: PRINT Work$
   
   DO
      LOCATE Y, X + LEN(Work$)
      DO: K$ = UCASE$(INKEY$): LOOP UNTIL K$ <> ""
      SELECT CASE ASC(K$)
         CASE 46
            IF INSTR(Work$, ".") = 0 THEN
               Work$ = Work$ + K$
               LOCATE Y, X: PRINT Work$
            ELSE
               SOUND 100, 1
            END IF
         CASE 25
            Work$ = ""
            LOCATE Y, X: PRINT STRING$(MaxLen, 250)
            LOCATE Y, X
         CASE 27
            LOCATE Y, X: PRINT SPACE$(MaxLen)
            Work$ = Default$
            LOCATE Y, X: PRINT Work$
         CASE 13
            'ignore
         CASE 8
            IF LEN(Work$) > 0 THEN
               Work$ = LEFT$(Work$, LEN(Work$) - 1)
               LOCATE Y, X + LEN(Work$): PRINT CHR$(250)
               LOCATE Y, X + LEN(Work$)
            ELSE
               SOUND 100, 1
            END IF
         CASE 0 TO 32, 47, 58, 59, 60 TO 63, 92
            SOUND 100, 1 'ignore, can't be in a file name
         CASE ELSE
            IF LEN(Work$) < MaxLen THEN
               S = INSTR(Work$, ".")
               IF S <> 0 THEN
                  Ok = 0
                  FOR I = 1 TO 3
                     IF MID$(Work$, S + I, 1) = "" THEN Ok = 1
                  NEXT I
                  IF Ok = 0 THEN
                     K$ = "": SOUND 100, 1
                  END IF
               END IF
               Work$ = Work$ + K$
               LOCATE Y, X: PRINT Work$
            ELSE
               SOUND 100, 1
            END IF
      END SELECT
      
   LOOP UNTIL K$ = CHR$(13) OR K$ = CHR$(27)
   
   IF Work$ <> "" THEN
      IF INSTR(Work$, ".") = 0 THEN Work$ = Work$ + "." + Ext$
      Work$ = TRIM$(Work$)  'must in case
   END IF
   GetFileName$ = UCASE$(Work$)
   
END FUNCTION

FUNCTION Getparams
   CONST ENTER = 13, ESCAPE = 27
   CONST DOWNARROW = 80, UPARROW = 72, LEFTARROW = 75, RIGHTARROW = 77
   CONST COL1 = 27, COL2 = 49, ROW = 11
   CLS
   Inputfile$ = "": OutPutFile$ = ""
   f = 1:
   COLOR 15, 2
   Center 1, " Dent v1.00 X Public Domain 1995 Paul Hurst "
   COLOR 7, 0
   Center 3, "UP .............. Move to next field"
   Center 4, "DOWN ........ Move to previous field"
   Center 5, "LEFT ......... Rotate field value up"
   Center 6, "RIGHT ...... Rotate field value down"
   Center 7, "ENTER .. Start with current settings"
   Center 8, "ESCAPE ................... Quit Dent"
   Center 22, "Auto-indents source code for neater code. Dent also cases subs / functions"
   Center 23, "Dent was written in QB4.5 and should work with most Basic Code"
   GOSUB DrawSelected
   DO
      
      K$ = INKEY$
      IF K$ = CHR$(0) + CHR$(DOWNARROW) THEN
         f = f + 1: IF f = 6 THEN f = 1
         GOSUB DrawSelected
      END IF
      
      IF K$ = CHR$(0) + CHR$(UPARROW) THEN
         f = f - 1: IF f = 0 THEN f = 5
         GOSUB DrawSelected
      END IF
      
      IF K$ = CHR$(0) + CHR$(RIGHTARROW) THEN
         SELECT CASE f
            CASE 1
               Inputfile$ = GetFileName$(Inputfile$, "BAS", COL1 + 13, ROW)
               OutPutFile$ = AddExt(Inputfile$, "BAK")
               GOSUB DrawSelected
            CASE 2
               OutPutFile$ = GetFileName$(OutPutFile$, "BAK", COL1 + 13, ROW + 1)
               GOSUB DrawSelected
            CASE 3
               SpaceIndent = SpaceIndent + 1
               IF SpaceIndent > 10 THEN SpaceIndent = 0
            CASE 4
               SubChange = SubChange + 1
               IF SubChange = 4 THEN SubChange = 1
            CASE 5
               FunctionChange = FunctionChange + 1
               IF FunctionChange = 4 THEN FunctionChange = 1
         END SELECT
         GOSUB DrawSelected
      END IF
      
      IF K$ = CHR$(0) + CHR$(LEFTARROW) THEN
         SELECT CASE f
            CASE 1
               Inputfile$ = GetFileName$(Inputfile$, "BAS", COL1 + 13, ROW)
               OutPutFile$ = AddExt(Inputfile$, "BAK")
               GOSUB DrawSelected
            CASE 2
               OutPutFile$ = GetFileName$(OutPutFile$, "BAK", COL1 + 13, ROW + 1)
               GOSUB DrawSelected
            CASE 3
               SpaceIndent = SpaceIndent - 1
               IF SpaceIndent = -1 THEN SpaceIndent = 10
            CASE 4
               SubChange = SubChange - 1
               IF SubChange = 0 THEN SubChange = 3
            CASE 5
               FunctionChange = FunctionChange - 1
               IF FunctionChange = 0 THEN FunctionChange = 3
         END SELECT
         GOSUB DrawSelected
      END IF
      
      IF K$ = CHR$(13) THEN
         IF Inputfile$ = "" OR OutPutFile$ = "" THEN K$ = ""
         SOUND 100, 1
      END IF
      
      
   LOOP UNTIL K$ = CHR$(13) OR K$ = CHR$(27)
   
   IF K$ = CHR$(13) THEN GetParams = 1 ELSE GetParams = 0
   EXIT FUNCTION
   
   DrawSelected:
   LOCATE , , 0
   SELECT CASE SubChange
      CASE 1: SubChange$ = "upper"
      CASE 2: SubChange$ = "lower"
      CASE 3: SubChange$ = "mixed"
   END SELECT
   SELECT CASE FunctionChange
      CASE 1: FunctionChange$ = "upper"
      CASE 2: FunctionChange$ = "lower"
      CASE 3: FunctionChange$ = "mixed"
   END SELECT
   
   LOCATE ROW + 0, COL1:       PRINT "Input file   "; Inputfile$; SPACE$(13)
   LOCATE ROW + 1, COL1:       PRINT "output file  "; OutPutFile$; SPACE$(13)
   LOCATE ROW + 2, COL1: PRINT USING "Space indent [##]"; SpaceIndent
   LOCATE ROW + 3, COL1
   PRINT USING "Subs         [ & ]"; SubChange$
   LOCATE ROW + 4, COL1: PRINT USING "Functions    [ & ]"; FunctionChange$
   LOCATE ROW + (f - 1), COL2, 1, 1, 7
   RETURN
   
END FUNCTION

FUNCTION Getword$ (St$, WordNum)
   
   Work$ = LTRIM$(St$)
   FOR I = 2 TO WordNum   '2 so we skip first word incase WordNum=1
      S = INSTR(Work$, " ")
      IF S = 0 THEN Work$ = ""
      Work$ = RIGHT$(Work$, LEN(Work$) - S)
   NEXT I
   
   S = INSTR(Work$, " ")
   TheWord$ = ""
   IF S = 0 THEN TheWord$ = Work$ ELSE TheWord$ = LEFT$(Work$, S - 1)
   
   GetWord$ = TheWord$
   
END FUNCTION

FUNCTION Mcase$ (St$)
   'Mixed case   ie PAUL = Paul
   Work$ = St$
   Work$ = LCASE$(Work$)
   MCASE$ = UCASE$(MID$(Work$, 1, 1)) + RIGHT$(Work$, LEN(Work$) - 1)
END FUNCTION

SUB Processfile
   
   OldLine = -1
   IF OutPutFile$ <> "CON" THEN
      OldLine = CSRLIN
      COLOR 7: PRINT "Working ";
      COLOR 31: PRINT ". . ."
   END IF
   COLOR 7
   Spaces$ = ""
   InCase = FALSE
   CaseIndent = 0
   TotalLines = 0
   WHILE NOT EOF(1)
      LINE INPUT #1, Line$
      
      TotalLines = TotalLines + 1
      Line$ = LTRIM$(Line$)
      Token$ = FirstWord$(Line$)
      
      SELECT CASE Token$
         CASE "DECLARE"
            SecondToken$ = GetWord$(Line$, 2)
            
            IF SecondToken$ = "FUNCTION" THEN
               Line$ = ChangeSub$(Line$, FunctionChange)
               PRINT #2, Spaces$ + Line$
            END IF
            IF SecondToken$ = "SUB" THEN
               Line$ = ChangeSub$(Line$, SubChange)
               PRINT #2, Spaces$ + Line$
            END IF
            
         CASE "ELSE"
            Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            
         CASE "ELSEIF"
            Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
         CASE "IF"
            PRINT #2, Spaces$ + Line$
            TempNum = INSTR(Line$, "'")
            Temp$ = Line$
            IF TempNum <> 0 THEN Temp$ = LEFT$(Line$, TempNum - 1)
            Temp$ = RTRIM$(Temp$)
            IF RIGHT$(Temp$, 4) = "THEN" THEN Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            
         CASE "SUB"
            Spaces$ = ""
            Line$ = ChangeSub$(Line$, SubChange)
            PRINT #2, Spaces$ + Line$
            Spaces$ = STRING$(SpaceIndent, " ")
            
         CASE "FUNCTION"
            Spaces$ = ""
            Line$ = ChangeSub$(Line$, FunctionChange)
            PRINT #2, Spaces$ + Line$
            Spaces$ = STRING$(SpaceIndent, " ")
            
         CASE "CASE"
            IF CaseIndent = 0 THEN
               PRINT #2, Spaces$ + Line$
               Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
               CaseIndent = CaseIndent + 1
            ELSE
               Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
               PRINT #2, Spaces$ + Line$
               Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            END IF
            
            
         CASE "SELECT"
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            IF CaseIndent <> 0 THEN
               CaseIndent = CaseIndent + 1
               Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            END IF
            
         CASE "TYPE"
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            
         CASE "DO"
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            
         CASE "LOOP"
            Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
            PRINT #2, Spaces$ + Line$
            
         CASE "WHILE"
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            
         CASE "WEND"
            Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
            PRINT #2, Spaces$ + Line$
            
         CASE "FOR"
            PRINT #2, Spaces$ + Line$
            Spaces$ = Spaces$ + STRING$(SpaceIndent, " ")
            
         CASE "NEXT"
            Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
            PRINT #2, Spaces$ + Line$
            
         CASE "END"
            SecondToken$ = GetWord$(Line$, 2)
            IF SecondToken$ = "" THEN
               PRINT #2, Spaces$ + Line$
            END IF
            
            IF SecondToken$ = "TYPE" THEN                      'END TYPE
               Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
               PRINT #2, Spaces$ + Line$
            END IF
            
            IF SecondToken$ = "IF" THEN                      'END IF
               Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent)
               PRINT #2, Spaces$ + Line$
            END IF
            
            IF SecondToken$ = "SELECT" THEN
               Spaces$ = LEFT$(Spaces$, LEN(Spaces$) - SpaceIndent * 2)
               PRINT #2, Spaces$ + Line$
               CaseIndent = CaseIndent - 1
            END IF
            
            IF SecondToken$ = "SUB" OR SecondToken$ = "FUNCTION" THEN
               Spaces$ = ""
               PRINT #2, Spaces$ + Line$
            END IF
            
            
         CASE ELSE
            PRINT #2, Spaces$ + Line$
            
      END SELECT
      
      
      
   WEND
   
   IF OldLine <> -1 THEN
      COLOR 7: LOCATE OldLine: PRINT "Done!            "
   END IF
   
END SUB

FUNCTION Trim$ (St$)
   TRIM$ = LTRIM$(RTRIM$(St$))
END FUNCTION

