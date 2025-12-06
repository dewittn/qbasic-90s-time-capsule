'---------------------------------------------------
'  MSWIND.BAS - Microsoft Windows Utils for QB 4.5
'---------------------------------------------------
'       (c) Carl Gorringe 1/15/96
'
' This program contains some routines to
'  report if Windows is running, and to
'   read and write to its Clipboard.
'
' Remember to have Windows loaded or else
' the Clipboard routines WILL NOT WORK!!
'
'    Released to the Public Domain.
'  You may use this any way you see fit,
'  just remember to give credit where
'  credit is due. This program is provided
'  "AS IS", therefore I am not responsible
'  for any consequences of using it.
'
' I can be contacted be sending a message to:
' CARL GORRINGE at FIDOnet's QUICK_BAS echo or
' Internet e-mail: <carl.gorringe@rhosoft.com>

'-------------------
' $INCLUDE: 'QB.BI'      <-- Remember to load QB with the /L switch!
'-------------------

CONST FALSE = 0
CONST TRUE = NOT FALSE

DECLARE FUNCTION Info.DOSver% ()
DECLARE FUNCTION Info.WinMode% ()
DECLARE FUNCTION Clipboard.Detect% ()
DECLARE FUNCTION Clipboard.Size& (Format%, ErrCode%)
DECLARE SUB Clipboard.Empty (ErrCode%)
DECLARE SUB Clipboard.Get (Format%, DataSeg%, DataOff%, ErrCode%)
DECLARE SUB Clipboard.Put (Format%, DataSeg%, DataOff%, DataSize&, ErrCode%)
DECLARE FUNCTION Clipboard.GetText$ (ErrCode%)
DECLARE SUB Clipboard.PutText (Text$, ErrCode%)

'---------------------------------------------------
CLS
PRINT "MSWIND.BAS - Programmed by Carl Gorringe <carl.gorringe@rhosoft.com>"
PRINT
PRINT "DOS Version:", (Info.DOSver% / 100)
PRINT "Windows Mode:", Info.WinMode%

ClipExist% = Clipboard.Detect%
IF ClipExist% THEN
	PRINT "Clipboard:", " Available"
ELSE
	PRINT "Clipboard:", " N/A"
END IF

IF ClipExist% THEN

	'--- Store Text on Clipboard ---
		PRINT
		INPUT "Enter some text to store on the Clipboard: ", ClipText$
	  
		CALL Clipboard.PutText(ClipText$, ErrCode%)
		PRINT
		PRINT "   ClipText:", ClipText$
		PRINT "    ErrCode:", ErrCode%
		IF ErrCode% <> 0 THEN END
	  
		ClipText$ = ""             '<-- Clear Variable
		
		PRINT
		PRINT "Now press [CTRL]+[ESC] to switch to Windows and check the Clipboard."
		PRINT "Press Any Key to Retrieve the Clipboard contents..."
		I$ = INPUT$(1)

	'--- Retrieve Text from Clipboard ---

		Format% = 7
		Size& = Clipboard.Size&(Format%, ErrCode%)
	  
		PRINT
		PRINT "     Format:", Format%
		PRINT "       Size:", Size&; "bytes"
		PRINT "    ErrCode:", ErrCode%
		IF ErrCode% <> 0 THEN END

		ClipText$ = Clipboard.GetText$(ErrCode%)
		PRINT "   ClipText:", ClipText$
		PRINT "    ErrCode:", ErrCode%

END IF

FUNCTION Clipboard.Detect%

'  (c) Carl Gorringe 1/15/96
'------------------------------------------
'  Returns TRUE (-1) if Windows Clipboard
'  is Detected, else returns FALSE (0).
'------------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType

ClipMode% = FALSE
WinMode% = Info.WinMode%

IF WinMode% > 1 THEN
  InReg.ax = &H1700
  CALL INTERRUPT(&H2F, InReg, OutReg)
  IF OutReg.ax = &H1700 THEN
	 ClipMode% = FALSE
  ELSE
	 ClipMode% = TRUE
  END IF
END IF

Clipboard.Detect% = ClipMode%

END FUNCTION

SUB Clipboard.Empty (ErrCode%)

'  (c) Carl Gorringe 1/15/96
'---------------------------------------------
'  Empties the Clipboard
'  ErrCode% is the Error Code returned: 0=OK
'---------------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType
DIM InRegX AS RegTypeX, OutRegX AS RegTypeX

'--- Open Clipboard ---
	InReg.ax = &H1701
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 1                  '<-- Clipboard is already open (error)
		EXIT SUB
	END IF

'--- Empty Clipboard ---
	InReg.ax = &H1702
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 3                  '<-- Failure (error)
	END IF

'--- Close Clipboard ---
	InReg.ax = &H1708
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 2                  '<-- Clipboard wont close (error)
		EXIT SUB
	END IF


END SUB

SUB Clipboard.Get (Format%, DataSeg%, DataOff%, ErrCode%)

'  (c) Carl Gorringe 1/15/96  << v1.0 >>
'---------------------------------------------
'  Gets Data from the Clipboard and stores
'  it at address DataSeg% : DataOff%
'  ErrCode% is the Error Code returned: 0=OK
'  Format% is the clipboard format number:
'         1 = Text (Windows Text)  <-- Contains garbage chars at end of text
'         2 = Bitmap Picture
'         3 = Metafile Picture
'         7 = OEM Text (DOS Text)  <-- Contains nulls at end of text
'---------------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType
DIM InRegX AS RegTypeX, OutRegX AS RegTypeX

'--- Open Clipboard ---
	InReg.ax = &H1701
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 1                  '<-- Clipboard is already open (error)
		EXIT SUB
	END IF

'--- Get Clipboard Data ---
	InRegX.ax = &H1705
	InRegX.dx = Format%
	InRegX.es = DataSeg%
	InRegX.bx = DataOff%
	CALL INTERRUPTX(&H2F, InRegX, OutRegX)
	IF OutRegX.ax = 0 THEN
		ErrCode% = 3                  '<-- (error)
	END IF

'--- Close Clipboard ---
	InReg.ax = &H1708
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 2                  '<-- Clipboard wont close (error)
		EXIT SUB
	END IF

END SUB

FUNCTION Clipboard.GetText$ (ErrCode%)

'  (c) Carl Gorringe 1/15/96  << v1.0 >>
'-----------------------------------------------------
'  Gets and Returns Text Data from the Clipboard.
'  Clipboard Format used is "OEM Text" (Format% = 7)
'  ErrCode% is the Error Code returned: 0=OK
'-----------------------------------------------------
'<< Done - Tested OK >>

ErrCode% = 0
Format% = 1       '<-- 7=OEM Text, 1=Windows Text

'--- Get Size of Clipboard ---
	Size& = Clipboard.Size&(Format%, ErrCode%)
	IF ErrCode% > 0 THEN EXIT FUNCTION
  
	IF Size& = 0 THEN
		ErrCode% = 4         '<-- Clipboard Empty!
		EXIT FUNCTION
	END IF

	IF Size& > 32000 THEN
		ErrCode% = 5         '<-- Clipboard Too Large for String Variable!
		EXIT FUNCTION
	END IF

'--- Get Text from Clipboard and Store It ---
	Temp$ = SPACE$(Size&)
	CALL Clipboard.Get(Format%, VARSEG(Temp$), SADD(Temp$), ErrCode%)
  
	IF ErrCode% = 0 THEN
		'--- Trim Ending Garbage ---
			Temp$ = LEFT$(Temp$, INSTR(Temp$, CHR$(0)) - 1)

		'--- Trim Ending CR/LF if Exists ---
			IF RIGHT$(Temp$, 2) = CHR$(13) + CHR$(10) THEN
				Temp$ = LEFT$(Temp$, LEN(Temp$) - 2)
			END IF

		Clipboard.GetText$ = Temp$
	END IF

END FUNCTION

SUB Clipboard.Put (Format%, DataSeg%, DataOff%, DataSize&, ErrCode%)

'  (c) Carl Gorringe 1/15/96  << v1.0 >>
'---------------------------------------------
'  Stores Data on to the Clipboard starting
'  from address DataSeg% : DataOff%
'    and storing DataSize& bytes.
'  ErrCode% is the Error Code returned: 0=OK
'  Format% is the clipboard format number:
'         1 = Text (Windows Text)
'         2 = Bitmap Picture
'         3 = Metafile Picture
'         7 = OEM Text (DOS Text)
'---------------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType
DIM InRegX AS RegTypeX, OutRegX AS RegTypeX

'--- Open Clipboard ---
	InReg.ax = &H1701
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 1                  '<-- Clipboard is already open (error)
		EXIT SUB
	END IF

'--- Store Clipboard Data ---
	InRegX.ax = &H1703
	InRegX.dx = Format%
	InRegX.es = DataSeg%
	InRegX.bx = DataOff%
	IF DataSize& < 32768 THEN
		InRegX.si = 0
		InRegX.cx = DataSize&
	ELSE
		InRegX.si = (DataSize& \ 32768) * 2048   '<-- This part NOT Tested!
		InRegX.cx = DataSize& MOD 32768          '<-- but don't worry about it.
	END IF
  
	CALL INTERRUPTX(&H2F, InRegX, OutRegX)
	IF OutRegX.ax = 0 THEN
		ErrCode% = 3                  '<-- (error)
	END IF

'--- Close Clipboard ---
	InReg.ax = &H1708
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 2                  '<-- Clipboard wont close (error)
		EXIT SUB
	END IF

END SUB

SUB Clipboard.PutText (Text$, ErrCode%)

'  (c) Carl Gorringe 1/15/96  << v1.0 >>
'---------------------------------------------
'  Stores Text on to the Clipboard in
'     BOTH Clipboard Text Formats.
'  ErrCode% is the Error Code returned: 0=OK
'---------------------------------------------
'<< Done - Tested OK >>

ErrCode% = 0

'--- Empty Clipboard ---
	CALL Clipboard.Empty(ErrCode%)
	IF ErrCode% <> 0 THEN
		ErrCode% = ErrCode% + 10
		EXIT SUB
	END IF

'--- Store Text on to Clipboard ---
	Temp$ = Text$ + CHR$(0)
	TempLen& = LEN(Temp$)
  
	CALL Clipboard.Put(1, VARSEG(Temp$), SADD(Temp$), TempLen&, ErrCode%)
	CALL Clipboard.Put(7, VARSEG(Temp$), SADD(Temp$), TempLen&, ErrCode%)


END SUB

FUNCTION Clipboard.Size& (Format%, ErrCode%)

'  (c) Carl Gorringe 1/15/96  << v1.0 >>
'---------------------------------------------
'  Returns the current size of the Clipboard
'  in bytes, using the specified Format%
'  ErrCode% is the Error Code returned: 0=OK
'  Format% is the clipboard format number:
'         1 = Text (Windows Text)
'         2 = Bitmap Picture
'         3 = Metafile Picture
'         7 = OEM Text (DOS Text)
'---------------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType
DIM InRegX AS RegTypeX, OutRegX AS RegTypeX

ErrCode% = 0

'--- Open Clipboard ---
	InReg.ax = &H1701
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 1                  '<-- Clipboard is already open
		Clipboard.Size& = 0
		EXIT FUNCTION
	END IF

'--- Get Size of Clipboard in current Format ---
	InReg.ax = &H1704
	InReg.dx = Format%
	CALL INTERRUPT(&H2F, InReg, OutReg)
	ClipSize& = (OutReg.dx * 16) + OutReg.ax

'--- Close Clipboard ---
	InReg.ax = &H1708
	CALL INTERRUPT(&H2F, InReg, OutReg)
	IF OutReg.ax = 0 THEN
		ErrCode% = 2                  '<-- Clipboard wont close
		Clipboard.Size& = 0
		EXIT FUNCTION
	END IF

Clipboard.Size& = ClipSize&

END FUNCTION

FUNCTION Info.DOSver%

'  (c) Carl Gorringe 1/15/96
'--------------------------------------
'  Returns the DOS version times 100.
'  To get decimal representation,
'  devide the number returned by 100.
'--------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType

InReg.ax = &H3306
CALL INTERRUPT(&H21, InReg, OutReg)
DOSver% = ((OutReg.bx AND 255) * 100) + (OutReg.bx \ 256)
IF DOSver% = 0 THEN
  InReg.ax = &H3000
  CALL INTERRUPT(&H21, InReg, OutReg)
  DOSver% = ((OutReg.ax AND 255) * 100) + (OutReg.ax \ 256)
END IF

Info.DOSver% = DOSver%

END FUNCTION

FUNCTION Info.WinMode%

'  (c) Carl Gorringe 1/15/96
'-------------------------------------------------------------
'  Returns the current Windows Mode:
'    0 = Windows not detected
'    1 = Real mode detected (Win 3.0 and earlier only)
'    2 = Standard mode detected. (Win 3.11 and earlier only)
'    3 = 386 enhanced mode detected.
'-------------------------------------------------------------
'<< Done - Tested OK >>

DIM InReg AS RegType, OutReg AS RegType

DOSver% = Info.DOSver%

IF DOSver% >= 300 THEN
  InReg.ax = &H160A
  CALL INTERRUPT(&H2F, InReg, OutReg)
  IF OutReg.ax <> 0 THEN
	 WinMode% = 0
  ELSE
	 WinMode% = OutReg.cx
  END IF
END IF

Info.WinMode% = WinMode%

END FUNCTION

