DEFINT A-Z
'$DYNAMIC
DECLARE SUB SetDTA (DTA AS ANY)
DECLARE FUNCTION RStr$ (X%, LX%)
DECLARE FUNCTION FmtTime$ (t%)
DECLARE FUNCTION FmtDate$ (FDate%)
DECLARE SUB SetUpScreen ()
DECLARE FUNCTION InBox% (x1%, y1%, x2%, y2%, X%, y%)
DECLARE SUB Debounce ()
DECLARE SUB GetText (x1%, y1%, x2%, y2%, Store$)
DECLARE SUB PutText (x1%, y1%, Store$)
DECLARE FUNCTION AltKey% ()
DECLARE SUB TextButton (Position%, XButton%, YButton%, Button$, ButtonForeColour%, ButtonBackColour%, ButtonHiLightChar%, ShadowColour%, ShadowBackGround%, Shadow%)
DECLARE SUB Pause (Seconds!)
DECLARE FUNCTION FindNext% (DEntry AS ANY)
DECLARE SUB TransferDTA2DIR (DEntry AS ANY)
DECLARE FUNCTION floppyDriveReady% (drive$)
DECLARE FUNCTION Exist% (Name$, SearchAttrb%)
DECLARE FUNCTION FindFirst% (Attr%, FileName$, DEntry AS ANY)
DECLARE FUNCTION ByteStr$ (v AS LONG)
DECLARE SUB Box (x1%, y1%, x2%, y2%, Version%, Clr1%, Clr2%)
DECLARE SUB EDecode (text$)
DECLARE SUB EEncode (text$)
DECLARE SUB ExpPassw (Pw$)
DECLARE SUB Meter (Xp%, Yp%, CurVal&, MaxVal&)
DECLARE SUB ReGenTable (Table$, Pw$)
DECLARE FUNCTION mNOT% (v%, m%)
DECLARE FUNCTION sCRC% (what$)
DECLARE FUNCTION Decrypt1% (InFile$, Pw$, OutFile$)
DECLARE FUNCTION Encrypt1% (InFile$, Pw$, OutFile$)
DECLARE FUNCTION SimplEncr$ (In$, Pw$)
DECLARE FUNCTION rmarin% (ij AS INTEGER, kl AS INTEGER)
DECLARE FUNCTION ranmar% (rvec() AS DOUBLE, ln AS INTEGER)
DECLARE SUB Highlight (X%, y%, Hlen%, FG%, BG%)
DECLARE FUNCTION InpBox$ (Def$, X%, y%, Overlay$)
DECLARE FUNCTION WildCardCount% (WCstr$)
DECLARE FUNCTION WildCardString$ (WCstr$, Istr$, Wone%)
DECLARE FUNCTION WildCardMatch% (WCstr$, Istr$)
DECLARE SUB mShow ()
DECLARE SUB mInit ()
DECLARE SUB mInfo (X, y, Btn)
DECLARE SUB mHide ()
'$INCLUDE: 'QB.BI'
'$INCLUDE: 'KeyCodes.BI'
DIM mInregs AS RegType, mOutregs AS RegType
TYPE DataTransferArea
  Reserved1   AS STRING * 21
  Attribute   AS STRING * 1
  FileTime    AS INTEGER
  Filedate    AS INTEGER
  FileSize    AS LONG
  FileName    AS STRING * 13
END TYPE
TYPE DirectoryRecord
  FileName    AS STRING * 13
  FileSize    AS LONG
  Filedate    AS INTEGER
  FileTime    AS INTEGER
  FileAttb    AS INTEGER
END TYPE
TYPE DosPListT
  ax AS INTEGER
  bx AS INTEGER
  cx AS INTEGER
  dx AS INTEGER
  si AS INTEGER
  di AS INTEGER
  ds AS INTEGER
  es AS INTEGER
  Rsrvd AS INTEGER
  CompID AS INTEGER
  ProcID AS INTEGER
END TYPE
DIM SHARED InRegsX AS RegTypeX
DIM SHARED OutRegsX AS RegTypeX
DIM SHARED DTA AS DataTransferArea
DIM SHARED DEntry  AS DirectoryRecord
DIM DirEntry AS DirectoryRecord
CONST TRUE = -1
CONST FALSE = 0
CONST Right = -1    ' Whatever number you want, but RIGHT <> LEFT
CONST Left = 0
CONST Up = -1       ' Whatever number you want, but UP <> DOWN
CONST Down = 0
DIM u(97) AS DOUBLE

SetUpScreen

DO
  mInfo X, y, b
  a$ = INKEY$
  IF b THEN
    IF InBox(5, 5, 18, 6, X, y) THEN
      mHide
      TextButton Down, 5, 5, "   ~Encode  ", 15, 1, 2, 8, 12, Right
      Debounce
      TextButton Up, 5, 5, "   ~Encode  ", 15, 1, 2, 8, 12, Right
      mShow
    ELSEIF InBox(5, 7, 18, 8, X, y) THEN
      mHide
      TextButton Down, 5, 7, "   ~Decode  ", 15, 1, 2, 8, 12, Right
      Debounce
      TextButton Up, 5, 7, "   ~Decode  ", 15, 1, 2, 8, 12, Right
      mShow
    ELSEIF InBox(5, 9, 18, 10, X, y) THEN
      mHide
      TextButton Down, 5, 9, "   ~View    ", 15, 1, 2, 8, 12, Right
      Debounce
      TextButton Up, 5, 9, "   ~View    ", 15, 1, 2, 8, 12, Right
      mShow
    ELSEIF InBox(5, 11, 18, 12, X, y) THEN
      mHide
      TextButton Down, 5, 11, "   E~xit    ", 15, 1, 2, 8, 12, Right
      Debounce
      TextButton Up, 5, 11, "   E~xit    ", 15, 1, 2, 8, 12, Right
      mShow
      EXIT DO
    ELSE
      Debounce
    END IF
  END IF
  IF LEN(a$) THEN
    IF a$ = altE$ THEN
      DO: LOOP UNTIL INKEY$ = ""
   
    ELSEIF a$ = altD$ THEN
      DO: LOOP UNTIL INKEY$ = ""
   
    ELSEIF a$ = altV$ THEN
      DO: LOOP UNTIL INKEY$ = ""
   
    ELSEIF a$ = altX$ OR a$ = CHR$(27) THEN
      DO: LOOP UNTIL INKEY$ = ""
      EXIT DO
    END IF
  END IF
LOOP





mInit
mHide
COLOR 7, 0
CLS
SYSTEM
'-----------------------------------------------------------
DataBox:
DATA Ú, Ä, ¿, ³, À, Ù
DATA É, Í, », º, È, ¼
DATA Õ, Í, ¸, ³, Ô, ¾
DATA Û, Û, Û, Û, Û, Û
DATA ², ², ², ², ², ²
DATA ±, ±, ±, ±, ±, ±
DATA °, °, °, °, °, °
DATA +, -, +, |, +, +
'===========================================================

REM $STATIC
FUNCTION AltKey
  DIM InRegs AS RegTypeX
  DIM OutRegs AS RegTypeX
  InRegs.ax = &H200
  CALL INTERRUPTX(&H16, InRegs, OutRegs)
  AL = OutRegs.ax MOD 256
  AltKey = (AL AND 8) = 8
END FUNCTION

SUB Box (x1, y1, x2, y2, Version, Clr1, Clr2)
' ********************
' * Draw a framework *
' ********************
' X1, Y1 - coordinates of upper left corner of framework
' X2, Y2 - coordinates of right lower corner of framework
' Version - form of framework
' Clr1, Clr2 -framework's fore- and background colors

REDIM b$(8, 6)
RESTORE DataBox
FOR I = 1 TO 8
	FOR J = 1 TO 6
		READ b$(I, J)
	NEXT J
NEXT I
COLOR Clr1, Clr2
LOCATE y1, x1
PRINT b$(Version, 1);
PRINT STRING$(x2 - x1 - 1, b$(Version, 2));
PRINT b$(Version, 3);
FOR y = y1 + 1 TO y2 - 1
	LOCATE y, x1
	PRINT b$(Version, 4);
	PRINT SPACE$(x2 - x1 - 1);
	PRINT b$(Version, 4);
NEXT y
LOCATE y2, x1
PRINT b$(Version, 5);
PRINT STRING$(x2 - x1 - 1, b$(Version, 2));
PRINT b$(Version, 6);
END SUB

FUNCTION ByteStr$ (v AS LONG)
SELECT CASE v
  CASE IS >= 1000000000
    s$ = LTRIM$(RTRIM$(STR$(v / 1000000000)))
    IF LEN(s$) > 4 THEN s$ = LEFT$(s$, 4)
    IF RIGHT$(s$, 1) = "." THEN s$ = LEFT$(s$, 4)
    s$ = s$ + " GB"
  CASE IS >= 1000000 AND v < 1000000000
    s$ = LTRIM$(RTRIM$(STR$(v / 1000000)))
    IF LEN(s$) > 4 THEN s$ = LEFT$(s$, 4)
    IF RIGHT$(s$, 1) = "." THEN s$ = LEFT$(s$, 4)
    s$ = s$ + " MB"
  CASE IS < 1000000 AND v >= 1000
    s$ = LTRIM$(RTRIM$(STR$(v / 1000)))
    IF LEN(s$) > 4 THEN s$ = LEFT$(s$, 4)
    IF INSTR(s$, ".") < LEN(s$) - 1 THEN s$ = LEFT$(s$, LEN(s$) - 1)
    IF RIGHT$(s$, 1) = "." THEN s$ = LEFT$(s$, 4)
    s$ = s$ + " KB"
  CASE IS < 1000
    s$ = LTRIM$(RTRIM$(STR$(v))) + " bytes"
  CASE ELSE
    s$ = LTRIM$(RTRIM$(STR$(v))) + " x"
END SELECT
ByteStr$ = s$
END FUNCTION

SUB Debounce
DO
 mInfo f, f, tb
LOOP UNTIL tb = 0
END SUB

FUNCTION Decrypt1 (InFile$, Pw$, OutFile$)
Xp = POS(0): Yp = CSRLIN
DIM xRnd(1023) AS DOUBLE
Meter Xp, Yp, 0, 1
X$ = "This should encrypt the password."
ExpPassw Pw$
ExpPassw X$
Pw$ = SimplEncr$(Pw$, X$)
InFile$ = LTRIM$(RTRIM$(InFile$))
OutFile$ = LTRIM$(RTRIM$(OutFile$))
DataStr$ = ""

dRetr1:
xi1 = sCRC(Pw$)
xi2 = sCRC(DataStr$)
r = rmarin(xi1, xi2)
r = ranmar(xRnd(), 1024)
FOR a = 0 TO 1023
  NewChr$ = CHR$((xRnd(a) * 2048) AND &HFF)
  IF INSTR(DataStr$, NewChr$) = 0 THEN DataStr$ = DataStr$ + NewChr$
NEXT a
IF LEN(DataStr$) < 256 THEN GOTO dRetr1
DataStr$ = LEFT$(DataStr$, 256)
ReGenTable DataStr$, Pw$


f1 = FREEFILE
OPEN InFile$ FOR BINARY AS #f1
IF LOF(f1) = 0 THEN CLOSE #f1: EXIT FUNCTION
f2 = FREEFILE
OPEN OutFile$ FOR BINARY AS #f2
IF LOF(f2) THEN CLOSE #f1, #f2: EXIT FUNCTION
WorkStr$ = STRING$(256, 0)
DIM Fpos AS LONG, xtms AS LONG, Bytes AS LONG
xtms = LOF(f1) \ 256 + 1
l = 256
X$ = STRING$(16, 0)
GET #f1, , X$
'PRINT "-"; x$; "-"
IF LEFT$(X$, 5) <> "ENCID" THEN CLOSE #f1, #f2: EXIT FUNCTION
r$ = MID$(X$, 6, 10)
l$ = SimplEncr$(r$, "PASSENCSTR")
IF LEFT$(Pw$, 10) <> l$ THEN CLOSE #f1, #f2: EXIT FUNCTION
IF RIGHT$(X$, 1) <> CHR$(27) THEN CLOSE #f1, #f2: EXIT FUNCTION
X$ = ""

FOR Fpos = 1 TO xtms
  l = 256
  IF Bytes + 256 > LOF(f1) THEN l = LOF(f1) - Bytes - 16
  WorkStr$ = STRING$(l, 0)
  GET #f1, , WorkStr$

  WorkStr$ = WorkStr$ + CHR$(123)
  FOR a = l TO 1 STEP -1
    cb = ASC(MID$(WorkStr$, a, 1))
    nb = ASC(MID$(WorkStr$, a + 1, 1))
    X = mNOT(cb, nb)
    MID$(WorkStr$, a, 1) = CHR$(X)
  NEXT a
  WorkStr$ = LEFT$(WorkStr$, LEN(WorkStr$) - 1)
 
  FOR a = 1 TO l
    I = ASC(MID$(WorkStr$, a, 1))
    X = mNOT(I, a - 1)
    MID$(WorkStr$, a, 1) = CHR$(X)
  NEXT a
 
  IF l = 256 THEN
    FOR a = 256 TO 1 STEP -1
      p = ASC(MID$(DataStr$, a, 1)) + 1
      X$ = MID$(WorkStr$, p, 1)
      MID$(WorkStr$, p, 1) = MID$(WorkStr$, a, 1)
      MID$(WorkStr$, a, 1) = X$
    NEXT a
  END IF
 
  FOR a = 1 TO l
      I = ASC(MID$(WorkStr$, a, 1))
      p = ASC(MID$(DataStr$, a, 1))
      X = mNOT(I, p)
      MID$(WorkStr$, a, 1) = CHR$(X)
  NEXT a

  PUT #f2, , WorkStr$

  Bytes = Bytes + 256

  Meter Xp, Yp, Bytes, LOF(f1)

  'PRINT sCRC(DataStr$);
  ReGenTable DataStr$, Pw$
NEXT Fpos

Meter Xp, Yp, 1, 1

CLOSE f1, f2
END FUNCTION

SUB EDecode (text$)
Out$ = "": text$ = UCASE$(text$)
FOR I = 1 TO LEN(text$) STEP 4
  in1 = ASC(MID$(text$, I, 1)) - 32
  in2 = ASC(MID$(text$, I + 1, 1)) - 32
  in3 = ASC(MID$(text$, I + 2, 1)) - 32
  in4 = ASC(MID$(text$, I + 3, 1)) - 32
  out1 = in1 + ((in4 AND 3) * 64)
  out2 = in2 + ((in4 AND 12) * 16)
  out3 = in3 + ((in4 AND 48) * 4)
  Out$ = Out$ + CHR$(out1) + CHR$(out2) + CHR$(out3)
NEXT I
text$ = RTRIM$(Out$)
END SUB

SUB EEncode (text$)
Out$ = ""
IF LEN(text$) MOD 3 <> 0 THEN text$ = text$ + SPACE$(3 - (LEN(text$) MOD 3))
FOR I = 1 TO LEN(text$) STEP 3
  in1 = ASC(MID$(text$, I, 1))
  in2 = ASC(MID$(text$, I + 1, 1))
  in3 = ASC(MID$(text$, I + 2, 1))
  out1 = (in1 AND 63)
  out2 = (in2 AND 63)
  out3 = (in3 AND 63)
  out4 = ((in1 \ 64) AND 3) + ((in2 \ 16) AND 12) + ((in3 \ 4) AND 48)
  Out$ = Out$ + CHR$(out1 + 32) + CHR$(out2 + 32) + CHR$(out3 + 32) + CHR$(out4 + 32)
NEXT I
text$ = Out$
END SUB

FUNCTION Encrypt1 (InFile$, Pw$, OutFile$)
Xp = POS(0): Yp = CSRLIN
DIM xRnd(1023) AS DOUBLE
Meter Xp, Yp, 0, 1
X$ = "This should encrypt the password."
ExpPassw Pw$
ExpPassw X$
Pw$ = SimplEncr$(Pw$, X$)
InFile$ = LTRIM$(RTRIM$(InFile$))
OutFile$ = LTRIM$(RTRIM$(OutFile$))
DataStr$ = ""

eRetr1:
xi1 = sCRC(Pw$)
xi2 = sCRC(DataStr$)
r = rmarin(xi1, xi2)
r = ranmar(xRnd(), 1024)
FOR a = 0 TO 1023
  NewChr$ = CHR$((xRnd(a) * 2048) AND &HFF)
  IF INSTR(DataStr$, NewChr$) = 0 THEN DataStr$ = DataStr$ + NewChr$
NEXT a
IF LEN(DataStr$) < 256 THEN GOTO eRetr1
DataStr$ = LEFT$(DataStr$, 256)
ReGenTable DataStr$, Pw$

'tests$ = DataStr$

f1 = FREEFILE
OPEN InFile$ FOR BINARY AS #f1
IF LOF(f1) = 0 THEN EXIT FUNCTION
f2 = FREEFILE
OPEN OutFile$ FOR BINARY AS #f2
IF LOF(f2) THEN EXIT FUNCTION
WorkStr$ = STRING$(256, 0)
DIM Fpos AS LONG, tms AS LONG, Bytes AS LONG
tms = LOF(f1) \ 256 + 1
l = 256
'PRINT sCRC(LEFT$(Pw$, 10))
r$ = SimplEncr$(LEFT$(Pw$, 10), "PASSENCSTR")
X$ = "ENCID" + r$ + CHR$(27)

PUT #f2, , X$

FOR Fpos = 1 TO tms
  IF Bytes + 256 > LOF(f1) THEN l = LOF(f1) - Bytes
  WorkStr$ = STRING$(l, 0)
  GET #f1, , WorkStr$
 
  FOR a = 1 TO l
      I = ASC(MID$(WorkStr$, a, 1))
      p = ASC(MID$(DataStr$, a, 1))
      X = mNOT(I, p)
      MID$(WorkStr$, a, 1) = CHR$(X)
  NEXT a
 
  IF l = 256 THEN
    FOR a = 1 TO 256
      p = ASC(MID$(DataStr$, a, 1)) + 1
      X$ = MID$(WorkStr$, p, 1)
      MID$(WorkStr$, p, 1) = MID$(WorkStr$, a, 1)
      MID$(WorkStr$, a, 1) = X$
    NEXT a
  END IF

  FOR a = 1 TO l
    I = ASC(MID$(WorkStr$, a, 1))
    X = mNOT(I, a - 1)
    MID$(WorkStr$, a, 1) = CHR$(X)
  NEXT a
 
  WorkStr$ = WorkStr$ + CHR$(123)
  FOR a = 1 TO l
    cb = ASC(MID$(WorkStr$, a, 1))
    nb = ASC(MID$(WorkStr$, a + 1, 1))
    X = mNOT(cb, nb)
    MID$(WorkStr$, a, 1) = CHR$(X)
  NEXT a
  WorkStr$ = LEFT$(WorkStr$, LEN(WorkStr$) - 1)

  PUT #f2, , WorkStr$
 
  Bytes = Bytes + 256
 
  Meter Xp, Yp, Bytes, LOF(f1)
 
  'PRINT sCRC(DataStr$);
  ReGenTable DataStr$, Pw$
NEXT Fpos

Meter Xp, Yp, 1, 1

CLOSE f1, f2
END FUNCTION

FUNCTION Exist% (Name$, SearchAttrb%)
 ' Format:
 ' EXIST Name$, SearchAttrb%
 ' Name$ can be any valid DOS filename, directory name, or
 ' volume label.
 '     wildcards (* and ?) are accepted.
 ' Attrb% can be the following:
 '     0 == Test for any file
 '    39 == Test for any file
 '    16 == Test for Directory names ONLY
 '     8 == Test for Volume labels ONLY
 '     4 == Test for System files ONLY
 '     2 == Test for Hidden files ONLY
 '     1 == Test for Read-Only files ONLY
 '    63 == Test for anything file/label/directory
 '
 '  Combinations can be made (ie. search for Read-only
 '  Directories) by following this binary number bit chart:
 '     Bit 7  Shareable (Novell Netware, otherwise ignore)
 '     Bit 6  unused
 '     Bit 5  archive
 '     bit 4  Directory
 '     Bit 3  Volume Label
 '     Bit 2  system
 '     Bit 1  Hidden
 '     Bit 0  Read only
 '  for example a Read-only Directory would be bits 0 and 4,
 '  in binary numbers that's: 10001 or 17 decimal.

 ' If the tested for item exists Exist% will be set to -1, true
 '    and SearchAttrb% can be ignored

 ' If the tested for item does not exist, or there is an error,
 ' Exist% will be set to 0, false, and SearchAttrb% will be set
 ' to one of the following:
 '    -1 == Floppy drive not ready or invalid drive letter.
 '     0 == item does not exist.

 DIM inreg AS RegTypeX, outreg AS RegTypeX

 seed$ = LTRIM$(RTRIM$(UCASE$(Name$)))

 IF SearchAttrb% AND 8 THEN  ' Volume label check
   ' Volume Label searches need to have a "." for the
   ' ninth character if the label is >8 characters.
   ' The following assures a correct search

   IF NOT (INSTR(seed$, ".")) THEN

	' step backwards through the string

	FOR I = LEN(seed$) TO 1 STEP -1

	  ' look for end of string, or drive/directory marker

	  IF MID$(seed$, I, 1) = ":" OR MID$(seed$, I, 1) = "\" OR I = 1 THEN

	    ' I points to start of name, without drive/directory
	    ' marker, see if "." is required

	    IF LEN(MID$(seed$, I + 1, LEN(seed$) - I)) > 8 THEN

		 ' if no drive/directory, then we're checking the
		 ' default drive, in this case I must equal 0 to
		 ' place the "." correctly.

		 IF I = 1 THEN I = 0

		 ' place the "."

		 seed$ = LEFT$(seed$, I) + MID$(seed$, I + 1, 8) + "." + MID$(seed$, I + 9, LEN(seed$) - I)
	    END IF
	    I = 1  ' exit the next loop
	  END IF
	NEXT I
   END IF
 END IF

 IF SearchAttrb% = 0 THEN SearchAttrb% = 39  ' default search

 ' if there's a drive in the search string
 IF INSTR(seed$, ":") THEN
   drive$ = LEFT$(seed$, 1)   ' gets the drive
 ELSE
   drive$ = "@"               ' for default drive
 END IF

 ' if it's a floppy drive we need to make sure a disk
 ' is in the drive.
 IF NOT floppyDriveReady(drive$) THEN
   SearchAttrb% = -1   ' Floppy not ready.
   Exist% = 0
   EXIT FUNCTION
 END IF

 inreg.dx = VARPTR(DTA)      'set a new DOS DTA
 inreg.ds = VARSEG(DTA)
 inreg.ax = &H1A00
 CALL INTERRUPTX(&H21, inreg, outreg)

 seed$ = seed$ + CHR$(0)     'DOS needs ASCIIZ string
 inreg.ax = &H4E00           'find file name service
 inreg.cx = SearchAttrb%
 inreg.dx = SADD(seed$)      'show where the spec is
 inreg.ds = VARSEG(seed$)    'use this with QB - SSEG for PDS(?)
 CALL INTERRUPTX(&H21, inreg, outreg)

 IF (outreg.flags AND 1) THEN
   SearchAttrb% = 0          ' Item does not exist
   Exist% = 0
 ELSE
   Exist% = -1               ' item exists
 END IF

END FUNCTION

SUB ExpPassw (Pw$)
DIM RandTable(255) AS DOUBLE
l = 256 - LEN(Pw$)
r = rmarin(sCRC(Pw$), 12343)
r = ranmar(RandTable(), 256)
FOR a = 1 TO l
  X = ((RandTable(a) * 2048) AND 255)
  Pw$ = Pw$ + CHR$(X)
NEXT a
ERASE RandTable
END SUB

SUB FileList (CurSelFile$, FileNum)
'26,3-74,19
STATIC TopFile, MaxFiles, tfNum
DIM DirEntry AS DirectoryRecord
DIM ListName AS STRING * 12
REDIM FileName$(200)

CALL SetDTA(DTA)

FindStatus = FindFirst(0, FileSpec$, DirEntry)
FileName$(1) = LTRIM$(RTRIM$(DirEntry.FileName))
FindStatus = FindNext(DirEntry)
I = 1

DO WHILE FindStatus = 0
  I = I + 1
  FileName$(I) = LTRIM$(RTRIM$(DirEntry.FileName))
  FindStatus = FindNext(DirEntry)
  CALL SetDTA(DTA)
  IF I >= 200 THEN EXIT DO
LOOP

END SUB

FUNCTION FindFirst (Attr, FileName$, DEntry AS DirectoryRecord)
  InRegsX.ax = &H4E00
  InRegsX.cx = Attr

  Spec$ = FileName$ + CHR$(0)
  InRegsX.ds = VARSEG(Spec$) ' Load DS:DX with
  InRegsX.dx = SADD(Spec$)   ' address of Spec$
  CALL INTERRUPTX(&H21, InRegsX, OutRegsX)

  FindFirst = OutRegsX.ax

  IF (OutRegsX.flags AND 1) = 0 THEN
    CALL TransferDTA2DIR(DEntry)
    FindFirst = 0 'Clear error condition setting
  END IF
END FUNCTION

FUNCTION FindNext (DEntry AS DirectoryRecord)
  DTA.FileName = SPACE$(13)
  InRegsX.ax = &H4F00
  CALL INTERRUPTX(&H21, InRegsX, OutRegsX)
  FindNext = OutRegsX.ax
  IF (OutRegsX.flags AND 1) = 0 THEN
    CALL TransferDTA2DIR(DEntry)
    FindNext = 0
  END IF
END FUNCTION

FUNCTION floppyDriveReady% (drive$)
 DIM inreg AS RegTypeX, outreg AS RegTypeX

 ' This function may also be used independently from
 ' the Exist% function. It returns -1, true if the
 ' drive is ready, or 0, false, if the drive is not
 ' ready, or the drive letter is an invalid drive.

 drive% = (ASC(drive$) OR 32) - 97

 'reset floppy drive
 inreg.ax = 0
 inreg.dx = drive%
 CALL INTERRUPTX(&H13, inreg, outreg)

 inreg.ax = &H401     'verify disk sector
 inreg.cx = &H101
 inreg.dx = drive%
 CALL INTERRUPTX(&H13, inreg, inreg)
 'call the interrupt twice since if a disk has just been
 'inserted, the first time gives a wrong answer
 inreg.ax = &H401
 inreg.cx = &H101
 inreg.dx = drive%
 CALL INTERRUPTX(&H13, inreg, outreg)

 'if it was a hard disk we just checked forget the whole thing
 IF outreg.ax AND 256 THEN
   inreg.ax = &H1C00      ' check drive type
   inreg.dx = drive% + 1  ' diff. drive number system must add 1
   CALL INTERRUPTX(&H21, inreg, outreg)
   ' check if drive was a valid drive letter.
   IF (outreg.ax AND &HFF) = &HFF THEN HardCheck = 0 ELSE HardCheck = -1
 END IF

 floppyDriveReady% = ((outreg.flags AND 1) = 0) OR HardCheck
END FUNCTION

FUNCTION FmtDate$ (FDate)
	   Day = FDate AND &H1F
	   Month = (FDate AND &H1E0) \ 32
	   Year = (FDate AND &HFE00) \ 512 + 1980
	   FmtDate$ = RStr$(Month, 2) + "-" + RStr$(Day, 2) + "-" + RStr$(Year, 4)
END FUNCTION

FUNCTION FmtTime$ (t%)
	   Seconds = (t% AND &H1F) * 2
	   Minutes = (t% AND &H7E0) \ 32

	   Hours = (t% < 0) * (-16) + ((t% AND &H7FFF) \ 2048)
	   Abbr$ = " am"
	   IF Hours = 12 THEN Abbr$ = " pm"
	   IF Hours = 0 THEN Hours = 12

	   IF Hours > 12 THEN
			 Hours = Hours MOD 12
			 Abbr$ = " pm"
	   END IF
	   FmtTime$ = RStr$(Hours, 2) + ":" + RStr$(Minutes, 2) + ":" + RStr$(Seconds, 2)
END FUNCTION

SUB GetText (x1, y1, x2, y2, Store$)
'size = ((x2 - x1 + 1) * (y2 - y1 + 1)) * 2 + 2
IF x1 > x2 THEN SWAP x1, x2
IF y1 > y2 THEN SWAP y1, y2
Store$ = CHR$(x2 - x1) + CHR$(y2 - y1)
FOR X = x1 TO x2
  FOR y = y1 TO y2
    Store$ = Store$ + CHR$(SCREEN(y, X, 0)) + CHR$(SCREEN(y, X, -1))
  NEXT y
NEXT X
END SUB

SUB Highlight (X, y, Hlen, FG, BG)
IF X > 80 OR X < 1 OR y > 25 OR y < 1 OR X + Hlen > 80 THEN EXIT SUB
COLOR FG, BG
FOR a = X TO X + Hlen - 1
  NoKey$ = INKEY$
  LOCATE y, a
  PRINT CHR$(SCREEN(y, a));
NEXT a
END SUB

FUNCTION InBox (x1, y1, x2, y2, X, y)
InBox = (X >= x1) AND (y >= y1) AND (X <= x2) AND (y <= y2)
END FUNCTION

FUNCTION InpBox$ (Def$, X, y, Overlay$)
IF y > 25 OR X > 80 OR y < 1 OR X < 1 THEN EXIT FUNCTION
Dlen = LEN(Def$)
IF X + Dlen > 80 THEN EXIT FUNCTION
Def$ = LTRIM$(RTRIM$(Def$))
IF LEN(Overlay$) > 1 THEN Overlay$ = LEFT$(Overlay$, 1)
LOCATE y, X
IF Overlay$ <> "" THEN
  PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$));
ELSE
  PRINT Def$ + SPACE$(Dlen - LEN(Def$));
END IF
l = 0              'location of cursor in the Box
LOCATE y + l, X, 1

DO

  DO: a$ = INKEY$: LOOP WHILE LEN(a$) = 0
  SELECT CASE (a$)
   CASE CHR$(8)
     IF l > 0 THEN
       IF l = LEN(Def$) THEN
	 Def$ = LEFT$(Def$, LEN(Def$) - 1)
	 l = l - 1
       ELSE
	 Def$ = LEFT$(Def$, l - 1) + MID$(Def$, l + 1)
	 l = l - 1
       END IF
     END IF
   CASE CHR$(0) + CHR$(83)
     IF l < LEN(Def$) THEN
       IF l = 0 THEN
	 Def$ = RIGHT$(Def$, LEN(Def$) - 1) + " "
       ELSE
	 Def$ = LEFT$(Def$, l) + MID$(Def$, l + 2)
       END IF
     END IF
   CASE CHR$(0) + "M"
     IF l < Dlen THEN l = l + 1
   CASE CHR$(0) + "K"
     IF l > 0 THEN l = l - 1
   CASE CHR$(0) + CHR$(79)
     l = LEN(RTRIM$(Def$))
   CASE CHR$(0) + CHR$(71)
     l = 0
   CASE CHR$(27)
    InpBox$ = ""
    EXIT DO
   CASE CHR$(13)
    InpBox$ = RTRIM$(Def$)
    EXIT DO
   CASE ELSE
     Def$ = Def$ + SPACE$(Dlen - LEN(Def$))
     IF LEN(a$) = 1 AND l < Dlen THEN MID$(Def$, l + 1, 1) = a$: l = l + 1
     Def$ = LTRIM$(RTRIM$(Def$))
  END SELECT
  LOCATE y, X, 0
  IF Overlay$ <> "" THEN
    PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$));
  ELSE
    PRINT Def$ + SPACE$(Dlen - LEN(Def$));
  END IF
  LOCATE y, X + l, 1
LOOP
LOCATE y, X, 0
IF Overlay$ <> "" THEN
  PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$))
ELSE
  PRINT Def$ + SPACE$(Dlen - LEN(Def$))
END IF
END FUNCTION

SUB Meter (Xp, Yp, CurVal AS LONG, MaxVal AS LONG)
IF Xp > 55 OR Xp < 1 OR Yp > 25 OR Yp < 1 THEN EXIT SUB
PerVal = (CurVal / MaxVal) * 100
IF PerVal > 100 THEN EXIT SUB
LOCATE Yp, Xp
PRINT STRING$(PerVal \ 5, "Û"); STRING$(20 - PerVal \ 5, "°"); " ";
IF PerVal = 100 THEN PRINT "Done" ELSE PRINT LTRIM$(RTRIM$(STR$(PerVal))) + "%"
END SUB

SUB mHide
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 2
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  
END SUB

SUB mInfo (X, y, Btn)
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType

  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 3
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  X = mOutregs.cx \ 8 + 1
  y = mOutregs.dx \ 8 + 1
  Btn = mOutregs.bx

END SUB

SUB mInit
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  mInregs.ax = 0
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  IsMouseOK = mOutregs.ax
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 7
  mInregs.cx = 0            ' min column
  mInregs.dx = 639          ' max column
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  mInregs.ax = 8
  mInregs.cx = 0            ' min row
  mInregs.dx = 199          ' max row
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  mInregs.ax = 1
  CALL INTERRUPT(&H33, mInregs, mOutregs)

END SUB

FUNCTION mNOT (v, m)
mNOT = (((NOT (v AND m)) AND m) + (v AND (NOT m))) AND 255
END FUNCTION

SUB mShow
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB

  mInregs.ax = 1
  CALL INTERRUPT(&H33, mInregs, mOutregs)

END SUB

SUB Pause (Seconds!)

t! = TIMER                        ' Pause routine
WHILE NOT TIMER - t! > Seconds!   ' Delay for how many Seconds!
WEND                              ' WHILE...WEND or DO...LOOP  Whatever

END SUB

SUB PutText (x1, y1, Store$)
x2 = x1 + ASC(MID$(Store$, 1, 1))
y2 = y1 + ASC(MID$(Store$, 2, 1))
Store$ = RIGHT$(Store$, LEN(Store$) - 2)
Pnt = 1
FOR X = x1 TO x2
  FOR y = y1 TO y2
    Char$ = MID$(Store$, Pnt, 1)
    FGC = ASC(MID$(Store$, Pnt + 1, 1)) AND 15
    BGC = ASC(MID$(Store$, Pnt + 1, 1)) \ 16
    Pnt = Pnt + 2
    LOCATE y, X: COLOR FGC, BGC: PRINT Char$;
  NEXT y
NEXT X
END SUB

DEFSNG A-Z
FUNCTION ranmar% (rvec() AS DOUBLE, ln AS INTEGER)
SHARED u() AS DOUBLE, c AS DOUBLE, cd AS DOUBLE, cm AS DOUBLE
SHARED i97 AS INTEGER, j97 AS INTEGER, test AS INTEGER
  DIM uni AS DOUBLE
  DIM ivec AS INTEGER

  IF NOT test THEN
    PRINT "RANMAR: Call the initialization routine (RMARIN) ";
    PRINT "before calling RANMAR."
    ranmar = 1
    EXIT FUNCTION
  END IF
  FOR ivec = 0 TO ln - 1
    uni = u(i97) - u(j97)
    IF uni < 0# THEN uni = uni + 1#
    u(i97) = uni
    i97 = i97 - 1
    IF i97 < 0 THEN i97 = 96
    j97 = j97 - 1
    IF j97 < 0 THEN j97 = 96
    c = c - cd
    IF c < 0# THEN c = c + cm
    uni = uni - c
    IF uni < 0# THEN uni = uni + 1#
    rvec(ivec) = uni
    ranmar = 0
  NEXT ivec
END FUNCTION

DEFINT A-Z
SUB ReGenTable (Table$, Pw$)
DIM SwapTable(256) AS DOUBLE
IF LEN(Pw$) < 256 THEN Pw$ = Pw$ + SPACE$(256 - LEN(Pw$))
r = ranmar(SwapTable(), 257)
FOR a = 1 TO 256
  p = ((SwapTable(a) * 2048) AND 255) + 1
  X$ = MID$(Table$, p, 1)
  MID$(Table$, p, 1) = MID$(Table$, a, 1)
  MID$(Table$, a, 1) = CHR$(mNOT(ASC(X$), ASC(MID$(Pw$, a, 1))))
NEXT a
ERASE SwapTable
END SUB

DEFSNG A-Z
FUNCTION rmarin% (ij AS INTEGER, kl AS INTEGER)
SHARED u() AS DOUBLE, c AS DOUBLE, cd AS DOUBLE, cm AS DOUBLE
SHARED i97 AS INTEGER, j97 AS INTEGER, test AS INTEGER
  DIM s AS DOUBLE, t AS DOUBLE
  DIM I AS INTEGER, J AS INTEGER, k AS INTEGER, l AS INTEGER, m AS INTEGER
  DIM ii AS INTEGER, jj AS INTEGER

  ' Change FALSE to TRUE in the next statement to test the
  ' random routine.

  test = TRUE
  IF (ij < 0 OR ij > 31328) OR (kl < 0 OR kl > 30081) THEN
    PRINT "RMARIN: The first random number seed must have a ";
    PRINT "value between 0 and 31328"
    PRINT "        The second random number seed must have a ";
    PRINT "value between 0 and 30081"
    rmarin = 1
    EXIT FUNCTION
  END IF
  I = INT(ij / 177# MOD 177#) + 2
  J = INT(ij MOD 177#) + 2
  k = INT(kl / 169# MOD 178#) + 1
  l = INT(kl MOD 169#)
  FOR ii = 0 TO 96
    s = 0#
    t = .5
    FOR jj = 0 TO 23
      m = INT(k * (I * J MOD 179#) MOD 179#)
      I = J
      J = k
      k = m
      l = INT((l * 53# + 1#) MOD 169#)
      IF (l * m MOD 64#) >= 32 THEN
	s = s + t
      END IF
      t = t * .5
    NEXT jj
    u(ii) = s
  NEXT
  c = 362436# / 16777216#
  cd = 7654321# / 16777216#
  cm = 16777213# / 16777216#
  i97 = 96
  j97 = 32
  test = TRUE
  rmarin = 0
END FUNCTION

DEFINT A-Z
FUNCTION RStr$ (X%, LX%)
	   X$ = STR$(X%)
	   RStr$ = RIGHT$("00000" + RIGHT$(X$, LEN(X$) - 1), LX%)
END FUNCTION

FUNCTION sCRC (what$)
X = 123
FOR a = 1 TO LEN(what$)
  X = X XOR ASC(MID$(what$, a, 1))
NEXT a
'PRINT x
sCRC = X AND &HFF
END FUNCTION

SUB SetDTA (DTA AS DataTransferArea)
  InRegsX.ax = &H1A00
  InRegsX.ds = VARSEG(DTA)
  InRegsX.dx = VARPTR(DTA)
  CALL INTERRUPTX(&H21, InRegsX, OutRegsX)
END SUB

SUB SetUpScreen
SCREEN 0, , 0, 0
mInit
mHide
COLOR 7, 9: CLS
FOR y = 2 TO 24
  LOCATE y, 1: PRINT STRING$(80, "°");
NEXT y
COLOR 7, 1
LOCATE 1, 1: PRINT SPACE$(80);
LOCATE 1, 1: PRINT "         File Encoding - by Hauke Daempfling - (c)1996 VIVID software"
COLOR 7, 12
LOCATE 25, 1: PRINT SPACE$(80);
Box 3, 3, 20, 13, 2, 7, 12
LOCATE 3, 6: PRINT "[ Commands ]"
COLOR 15
LOCATE 3, 8: PRINT "Commands"
TextButton Up, 5, 5, "   ~Encode  ", 15, 1, 2, 8, 12, Right
TextButton Up, 5, 7, "   ~Decode  ", 15, 1, 2, 8, 12, Right
TextButton Up, 5, 9, "   ~View    ", 15, 1, 2, 8, 12, Right
TextButton Up, 5, 11, "   E~xit    ", 15, 1, 2, 8, 12, Right
Box 25, 3, 75, 20, 2, 7, 12
LOCATE 3, 45: PRINT "[ Files ]"
COLOR 15: LOCATE 3, 47: PRINT "Files"
LOCATE
mShow
END SUB

FUNCTION SimplEncr$ (In$, Pw$)
Out$ = ""
FOR a = LEN(In$) TO 1 STEP -1
  I = ASC(RIGHT$(In$, a))
  p = ASC(RIGHT$(Pw$, a))
  X = mNOT(I, p)
  Out$ = Out$ + CHR$(X)
NEXT a
SimplEncr$ = Out$
END FUNCTION

SUB TextButton (Position, XButton, YButton, Button$, ButtonForeColour, ButtonBackColour, ButtonHiLightChar, ShadowColour, ShadowBackGround, Shadow)

XCor = XButton

IF (Shadow = Left) AND (Position = Up) THEN      ' Place shadows on the
  LOCATE YButton, XButton - 1                    ' left side of button
  COLOR ShadowColour, ShadowBackGround
  PRINT "Ü";
  LOCATE YButton + 1, XButton - 1: PRINT "ßß";
END IF

IF Position = Down THEN        ' This routine removes the shadows
  LOCATE YButton, XButton
  COLOR , ShadowBackGround
  PRINT " ";
  IF Shadow = Right THEN XCor = XCor + 1 ELSE XCor = XCor - 1
  LOCATE YButton + 1, XCor: PRINT " ";
END IF

LOCATE YButton, XCor
COLOR ButtonForeColour, ButtonBackColour
PRINT " ";              ' Spaces are automatically inserted, remove if desired

Length = LEN(Button$)   ' Number of characters in BUTTON$
FOR I = 1 TO Length     ' Parse them all
  IF MID$(Button$, I, 1) = "~" THEN
    COLOR ButtonHiLightChar
  ELSE
    XCor = XCor + 1
    LOCATE YButton, XCor
    PRINT MID$(Button$, I, 1);
    COLOR ShadowColour, ShadowBackGround
    IF Position = Up THEN
      LOCATE YButton + 1, XCor: PRINT "ß";
    ELSE
      LOCATE YButton + 1, XCor: PRINT " ";
    END IF
    COLOR ButtonForeColour, ButtonBackColour
  END IF
NEXT I

IF Position = Down THEN        ' This routine also removes the shadows
  LOCATE YButton + 1, XCor + 1
  COLOR ShadowColour, ShadowBackGround
  PRINT " ";
  IF Shadow = Left THEN
    LOCATE YButton, XCor + 2: PRINT " ";
  END IF
END IF

COLOR ButtonForeColour, ButtonBackColour
LOCATE YButton, XCor + 1
PRINT " ";              ' Spaces are automatically inserted, remove if desired

IF (Shadow = Right) AND (Position = Up) THEN
  COLOR ShadowColour, ShadowBackGround
  PRINT "Ü";
  LOCATE YButton + 1, XCor + 1: PRINT "ßß";
END IF

END SUB

SUB TransferDTA2DIR (DEntry AS DirectoryRecord)
 DEntry.FileName = DTA.FileName
 DEntry.FileSize = DTA.FileSize
 DEntry.Filedate = DTA.Filedate
 DEntry.FileTime = DTA.FileTime
 DEntry.FileAttb = ASC(DTA.Attribute)
END SUB

'by David Arigan, tweaked by Hauke Daempfling
SUB UUDecode (InFile$, OutFile$)
  InFile$ = LTRIM$(RTRIM$(InFile$))
  OutFile$ = LTRIM$(RTRIM$(OutFile$))
  dnam$ = InFile$
  FOR a = LEN(InFile$) TO 1 STEP -1
    IF RIGHT$(dnam$, 1) = "\" THEN EXIT FOR ELSE dnam$ = LEFT$(dnam$, LEN(dnam$) - 1)
  NEXT a
  FRF1 = FREEFILE
  OPEN InFile$ FOR BINARY AS #FRF1
  FRF2 = FREEFILE
  IF LOF(1) = 0 THEN
    PRINT "File '"; InFile$; "' does not exist."
    CLOSE #FRF1: KILL InFile$: EXIT SUB
  END IF
  CLOSE #FRF1
  OPEN InFile$ FOR INPUT AS #FRF1
  WHILE EOF(1) = 0
    LINE INPUT #FRF1, l$: lc = lc + 1
    IF LCASE$(LEFT$(l$, 5)) = "begin" THEN
      N = INSTR(l$, " ")
      IF N <> 0 AND INSTR(N + 1, l$, " ") <> 0 THEN
	IF OutFile$ = "" THEN
	   onam$ = dnam$ + RTRIM$(MID$(l$, INSTR(N + 1, l$, " ") + 1))
	ELSE
	   onam$ = OutFile$
	END IF
	OPEN onam$ FOR BINARY AS #FRF2
	DO
	  LINE INPUT #FRF1, l$: lc = lc + 1
	  IF LCASE$(LEFT$(l$, 3)) = "end" THEN success = -1: EXIT DO
	  IF LEN(l$) THEN
	    ls = (ASC(l$) - 32) MOD 64: o$ = ""
	    IF ls < 0 OR ls > 45 OR ls > ((LEN(l$) - 1) * 3 \ 4) THEN
	      PRINT "*** Error in line #"; lc; " (Bad length)": EXIT DO
	    END IF
	    FOR I = 1 TO ls
	      p = ((I - 1) \ 3) * 4
	      SELECT CASE (I - 1) MOD 3
		CASE 0
		  c% = (ASC(MID$(l$, p + 2)) - 32) * 4
		  c% = c% + (ASC(MID$(l$, p + 3)) - 32) \ 16
		CASE 1
		  c% = ((ASC(MID$(l$, p + 3)) - 32) * 16) AND &HF0
		  c% = c% + (ASC(MID$(l$, p + 4)) - 32) \ 4
		CASE 2
		  c% = ((ASC(MID$(l$, p + 4)) - 32) * 64) AND &HC0
		  c% = c% + (ASC(MID$(l$, p + 5)) - 32)
	      END SELECT
	      o$ = o$ + CHR$(c)
	    NEXT I
	    PUT #FRF2, , o$
	  END IF
	LOOP UNTIL EOF(1)
	CLOSE #FRF2
	IF success = 0 THEN
	  PRINT "*** UUDecoding '"; onam$; " was not succesful."
	ELSE
	  PRINT "Finished UUDecoding '"; onam$; "'"
	  success = 0
	END IF
      END IF
    END IF
  WEND
  CLOSE #FRF2

END SUB

'by David Arigan, tweaked by Hauke Daempfling
SUB UUEncode (InFile$, OutFile$)
  InFile$ = LTRIM$(RTRIM$(InFile$))
  OutFile$ = LTRIM$(RTRIM$(OutFile$))
  pnam$ = InFile$
RetryAddUUE1:
  IF INSTR(pnam$, "\") THEN
    pnam$ = MID$(pnam$, INSTR(pnam$, "\") + 1): GOTO RetryAddUUE1
  END IF
  FRF1 = FREEFILE
  OPEN InFile$ FOR BINARY AS #FRF1
  FRF2 = FREEFILE
  IF LOF(FRF1) = 0 THEN
    PRINT "File '"; InFile$; "' does not exist."
    CLOSE #FRF1: KILL InFile$: EXIT SUB
  END IF
  OPEN OutFile$ FOR OUTPUT AS #FRF2
  PRINT #FRF2, "begin 644 " + pnam$
  bl& = 45: fl& = LOF(FRF1): bf$ = SPACE$(bl&)
  WHILE fl&
    IF fl& < bl& THEN bl& = fl&: bf$ = SPACE$(bl&)
    GET #FRF1, , bf$: fl& = fl& - bl&
    IF bl& MOD 3 <> 0 THEN bf$ = bf$ + STRING$(3 - bl& MOD 3, 0)
    FOR I = 1 TO bl& STEP 3
      c1 = ASC(MID$(bf$, I, 1))
      c2 = ASC(MID$(bf$, I + 1, 1))
      c3 = ASC(MID$(bf$, I + 2, 1))
      l$ = l$ + CHR$(c1 \ 4 + 32)
      l$ = l$ + CHR$((c1 * 16 + c2 \ 16 AND &H3F) + 32)
      l$ = l$ + CHR$((c2 * 4 + c3 \ 64 AND &H3F) + 32)
      l$ = l$ + CHR$((c3 AND &H3F) + 32)
    NEXT
    PRINT #FRF2, CHR$(32 + bl&); l$: l$ = ""
  WEND
  PRINT #FRF2, : PRINT #FRF2, "end"
  CLOSE #FRF1, #FRF2
END SUB

SUB vScrollDown (x1, y1, x2, y2, howmany)
DIM InRegs AS RegType, OutRegs AS RegType
InRegs.ax = &H700 + howmany
InRegs.bx = &H0
InRegs.cx = (y1 - 1) * &H100 + (x1 - 1)
InRegs.dx = (y2 - 1) * &H100 + (x2 - 1)
CALL INTERRUPT(&H10, InRegs, OutRegs)
END SUB

SUB vScrollUp (x1, y1, x2, y2, howmany)
DIM InRegs AS RegType, OutRegs AS RegType
InRegs.ax = &H600 + howmany
InRegs.bx = &H0
InRegs.cx = (y1 - 1) * &H100 + (x1 - 1)
InRegs.dx = (y2 - 1) * &H100 + (x2 - 1)
CALL INTERRUPT(&H10, InRegs, OutRegs)
END SUB

FUNCTION WildCardCount (WCstr$)
IF WCstr$ = "" THEN WildCardCount = -1: EXIT FUNCTION
FOR a = 1 TO LEN(WCstr$)    'simpily count the wildcards
  IF MID$(WCstr$, a, 1) = "*" OR MID$(WCstr$, a, 1) = "?" THEN WCC = WCC + 1
NEXT a
WildCardCount = WCC
END FUNCTION

FUNCTION WildCardMatch (WCstr$, Istr$)
WCM = -1: Wpos = 0: Rpos = 0   'init variables
IF WCstr$ = "" OR Istr$ = "" THEN WildCardMatch = 0: EXIT FUNCTION
  '^^^ can't process null strings
IF LEFT$(WCstr$, 1) = "*" THEN WCstr$ = " " + WCstr$: Istr$ = " " + Istr$
DO                '^^^ can't process * at beginning of string
  Rpos = Rpos + 1    'position in Istr$
  Wpos = Wpos + 1    'position in WCstr$
  'for debugging, look at it if you don't understand WildCardMatch
  'SLEEP 1: CLS
  'PRINT WCstr$: PRINT SPACE$(Wpos - 1); "^"
  'PRINT Istr$: PRINT SPACE$(Rpos - 1); "^"
  IF MID$(WCstr$, Wpos, 1) = "*" THEN  'if there's a * wildcard
    'the idea of this is to skip over whatever characters are in
    ' Istr$ supplementing the * wildcard by setting Rpos according
    ' to the position of NextChrs$ in Istr$ so we can continue scanning
    'NextChrs$ are the characters between the current wildcard and the
    ' next one, that is why two wildcards next to one another are not
    ' allowed (NextChrs$ would be "", or " ", etc.).
    NextPos = INSTR(Wpos + 1, WCstr$, "*") - 1    'find the next *
    IF NextPos <= 0 THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
      '^^^ if there's no * left, there might be a ?
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)
      '^^^ if there's still no ?/* found, then that was the last wildcard
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos) 'get string between
    IF NextChrs$ = "" THEN                             ' the two *'s
      IF Wpos = LEN(WCstr$) THEN     'if we're at the end of the string
	EXIT DO                      ' and it's matched so far, then it's
      ELSE                           ' a match
	WCM = 0: EXIT DO             'if not, no match
      END IF
    END IF
    IF INSTR(NextChrs$, "?") THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)          'this is in case
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos)  ' it's a sequence
    IF NextChrs$ = "" THEN WCM = 0: EXIT DO             ' of * ? *
    Cnt = 0                                         'find our positon
    FOR a = Rpos TO LEN(Istr$) - LEN(NextChrs$) + 1 ' in Istr$
      IF MID$(Istr$, a, LEN(NextChrs$)) = NextChrs$ THEN Cnt = a: EXIT FOR
    NEXT a
    IF Cnt = 0 THEN WCM = 0: EXIT DO    'if we didn't find it then no match
    Rpos = Cnt - 1                      'set the scan positon in Istr$
  ELSE
    IF MID$(WCstr$, Wpos, 1) = MID$(Istr$, Rpos, 1) THEN
      'Match
    ELSEIF MID$(WCstr$, Wpos, 1) = "?" THEN
      'Match
    ELSE
      'No match
      WCM = 0: EXIT DO
    END IF
  END IF
LOOP UNTIL Rpos > LEN(Istr$)
WildCardMatch = WCM
END FUNCTION

FUNCTION WildCardString$ (WCstr$, Istr$, Wone)
IF Wone <= 0 THEN WildCardString$ = "": EXIT FUNCTION
  '^^^ can't process negative wildcards
FOR a = 1 TO LEN(WCstr$)  'find the position of the wildcard we want
  IF MID$(WCstr$, a, 1) = "*" OR MID$(WCstr$, a, 1) = "?" THEN WCC = WCC + 1
  IF WCC = Wone THEN
    WCC = a: EXIT FOR
  END IF
NEXT a
IF WCC = 0 THEN WildCardString$ = "": EXIT FUNCTION
'this routine is practically like WildCardMatch
IF LEFT$(WCstr$, 1) = "*" THEN WCstr$ = " " + WCstr$: Istr$ = " " + Istr$
DO
  Rpos = Rpos + 1
  Wpos = Wpos + 1
  'debugging
  'SLEEP 1: CLS
  'PRINT WCstr$: PRINT SPACE$(Wpos - 1); "^"
  'PRINT Istr$: PRINT SPACE$(Rpos - 1); "^"
  IF MID$(WCstr$, Wpos, 1) = "*" THEN
    NextPos = INSTR(Wpos + 1, WCstr$, "*") - 1
    IF NextPos <= 0 THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos)
    IF NextChrs$ = "" THEN
      IF Wpos = LEN(WCstr$) THEN
	WCS$ = MID$(Istr$, Rpos): EXIT DO  'get wildcard string
      ELSE
	WCS$ = "": EXIT DO
      END IF
    END IF
    IF INSTR(NextChrs$, "?") THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos) 'get wilcard string
    IF NextChrs$ = "" THEN WCS$ = "": EXIT DO
    Cnt = 0
    FOR a = Rpos TO LEN(Istr$) - LEN(NextChrs$) + 1
      IF MID$(Istr$, a, LEN(NextChrs$)) = NextChrs$ THEN Cnt = a: EXIT FOR
    NEXT a
    IF Cnt = 0 THEN WCS$ = "": EXIT DO
    IF Wpos = WCC THEN WCS$ = MID$(Istr$, Rpos, Cnt - Rpos): EXIT DO
    Rpos = Cnt - 1          '^^^ get wildcard string
  ELSE
    IF MID$(WCstr$, Wpos, 1) = MID$(Istr$, Rpos, 1) THEN
      'Match
    ELSEIF MID$(WCstr$, Wpos, 1) = "?" THEN
      'Match
      IF Wpos = WCC THEN WCS$ = MID$(Istr$, Rpos, 1): EXIT DO
    ELSE                        '^^^ get wilcard character
      WCS$ = "": EXIT DO
    END IF
  END IF
LOOP UNTIL Rpos > LEN(Istr$)
WildCardString$ = WCS$
END FUNCTION

