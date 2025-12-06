DEFINT A-Z
DECLARE SUB SendFile (FileName$, Msgs$)
DECLARE SUB BannerScroll (ts$, x%, y%, boxsize%, ticks%)
DECLARE SUB FCP ()
DECLARE SUB TCP ()
DECLARE SUB BarText ()
DECLARE SUB UpdateBar (ByteRetry%, BlockRetry%)
DECLARE SUB RecieveFile (FileName$, FileSize&, Msgs$)
DECLARE FUNCTION mClick% (x1%, y1%, x2%, y2%)
DECLARE SUB PAT (x%, y%, text$)
DECLARE SUB CurOn ()
DECLARE SUB CurOff ()
DECLARE FUNCTION trim$ (what$)
DECLARE SUB Filter (InString$, Events)
DECLARE SUB PutBlock (Block$)
DECLARE SUB PutByte (what$)
DECLARE SUB PutCommand (Block$)
DECLARE SUB PutResend ()
DECLARE FUNCTION CarrierOn% ()
DECLARE FUNCTION GetCode$ ()
DECLARE FUNCTION GetByte$ ()
DECLARE FUNCTION ByteToNum& (Bytes$)
DECLARE FUNCTION NumToByte$ (Num&)
DECLARE FUNCTION PlusMin% (Val1%, Val2%, PM%)
DECLARE SUB BaudLatch (Speed%)
DECLARE SUB mShow ()
DECLARE SUB mInit ()
DECLARE SUB mInfo (x, y, btn)
DECLARE SUB mHide ()
DECLARE SUB TextButton (Position%, XButton%, YButton%, Button$, ButtonForeColour%, ButtonBackColour%, ButtonHiLightChar%, ShadowColour%, ShadowBackGround%, Shadow%)
DECLARE SUB Pause (Seconds!)
DECLARE FUNCTION DIR$ (FileSpec$)
DECLARE FUNCTION InpBox$ (Def$, x%, y%, Overlay$)
DECLARE SUB Box (x1%, y1%, x2%, y2%, Version%, Clr1%, Clr2%)
DECLARE SUB GetText (x1%, y1%, x2%, y2%, Store$)
DECLARE SUB PutText (x1%, y1%, Store$)
DECLARE SUB Highlight (x%, y%, Hlen%, FG%, BG%)

CONST DOS = &H21
CONST SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00

'$INCLUDE: 'QB.BI'
DIM mInregs AS RegType, mOutregs AS RegType
''$INCLUDE: 'KEYCODES.BI'

CONST xID$ = ""           'ID, starts each block
CONST xCMD$ = ""          'Block contains a command
CONST xDATA$ = ""         'Block contains data
CONST xRESEND$ = ""       'Re-send last block
CONST xCHECKSUM$ = ""     'Checksum for block follows
CONST xSTARTBLOCK$ = ""   'Start of block
CONST xENDBLOCK$ = ""     'End of block
CONST xCONFIRM$ = "-*-"  'Confirm string
CONST xBLOCKSIZE$ = ""    'Block size follows
CONST xUP$ = ""           'Upload file
CONST xDOWN$ = ""         'Download file
CONST xPOPUP$ = ""        'Popup message

CONST True = -1, False = 0
CONST Left = -1, Right = 0
CONST Up = -1, Down = 0
CONST Upload = 1, Download = 2, Popup = 3

DIM ComPort      'Port number
DIM FileNum      'Open file number
DIM ComActive    'Is port on?
DIM ComAddr      'Address of Port
DIM Baud&        'Baud rate
DIM Bits         'Data bits (6,7,8)
DIM Parity$      'Parity
DIM StopBits!    'Stopbits (1, 1.5, 2)
DIM Timeout      'Timeout
DIM BuffSize     'Buffer size
DIM Retry        'Times to retry
DIM LastBlock$   'Last block sent
DIM BlockLen     'Data block size (for transfer)

COLOR 7, 1                      ' Set screen color.
CLS

Quit$ = CHR$(0) + CHR$(16)
UpKey$ = CHR$(0) + CHR$(72)
DownKey$ = CHR$(0) + CHR$(80)
LeftKey$ = CHR$(0) + CHR$(75)
RightKey$ = CHR$(0) + CHR$(77)
PageUp$ = CHR$(0) + CHR$(73)
PageDown$ = CHR$(0) + CHR$(81)

PRINT "*** Simple Terminal ***"

Reenter1:
ComPort = 2  'INPUT "Com port (1,2)? ", ComPort
SELECT CASE ComPort
  CASE 1
    ComAddr = &H3F8
  CASE 2
    ComAddr = &H2F8
  CASE ELSE
    GOTO Reenter1
END SELECT

FileNum = FREEFILE
		     
Reenter2:
PRINT "Select a baud rate:"
PRINT "1) 115000"
PRINT "2) 56000"
PRINT "3) 38400"
PRINT "4) 19200"
PRINT "5) 9600"
PRINT "6) 2400"
PRINT "7) 300"
BaudNum = 3  'INPUT "? ", BaudNum
SELECT CASE BaudNum
  CASE 7
    Baud& = 300
  CASE 6
    Baud& = 2400
  CASE 5
    Baud& = 9600
  CASE 4
    Baud& = 19200
  CASE 3
    Baud& = 38400
    Latch = -1
  CASE 2
    Baud& = 56000
    Latch = -1
  CASE 1
    Baud& = 115000
    Latch = -1
  CASE ELSE
    GOTO Reenter2
END SELECT

Bits = 8  'INPUT "Data bits (6,7,8)? ", Bits

Parity$ = "N"  'INPUT "Parity (N=none,E=even,O=odd,S=space,M=mark)? ", Parity$

StopBits! = 1  'INPUT "Stopbits (1,1.5,2)? ", StopBits!

Timeout = 500  'INPUT "Timeout (milliseconds)? ", Timeout

BuffSize = 2048  'INPUT "Send/recieve buffer size (bytes)? ", BuffSize
BlockLen = BuffSize - 24

TranPath$ = "C:\TEMP\"  'INPUT "Transfer path (path name)? ", TranPath$
IF NOT LEFT$(TranPath$, 1) = "\" THEN TranPath$ = TranPath$ + "\"

Retry = 5

Ostr$ = "COM" + trim$(STR$(ComPort)) + ":"
IF Latch THEN x& = 19200 ELSE x& = Baud&
Ostr$ = Ostr$ + trim$(STR$(x&)) + "," + UCASE$(Parity$)
Ostr$ = Ostr$ + "," + trim$(STR$(Bits)) + "," + trim$(STR$(StopBits!))
Ostr$ = Ostr$ + ",BIN,OP10000,RB" + trim$(STR$(BuffSize))
Ostr$ = Ostr$ + ",TB" + trim$(STR$(BuffSize))

CLS
FCP
BarText
COLOR 0, 7: LOCATE 1, 1: PRINT SPACE$(80); : LOCATE 1, 1
      '<- begin                                                                  end ->'
PRINT "   File   Edit   Options   File Transfer   Help";

COLOR 7, 1: LOCATE , , 1: mInit
TCP
Ylin = 1

' Open communications
CurOff
mHide
GetText 20, 7, 60, 10, Gtxt$
Box 20, 7, 60, 10, 2, 15, 4
PAT 23, 8, "Please make sure your modem is on."
PAT 23, 9, "  Press any key to continue..."
DO: LOOP UNTIL INKEY$ <> ""
PutText 20, 7, Gtxt$

GetText 20, 7, 50, 9, Gtxt$
Box 20, 7, 50, 9, 2, 15, 4
PAT 23, 8, "Opening communications..."
OPEN Ostr$ FOR RANDOM AS #1 LEN = 1024
IF Latch THEN BaudLatch BaudNum
ComActive = -1
PutText 20, 7, Gtxt$
Gtxt$ = ""
CurOn
mShow
LOCATE 2, 1

DO                              ' Main communications loop.

   keyinput$ = INKEY$           ' Check the keyboard.

   IF keyinput$ = Quit$ THEN    ' Exit the loop if the user
      EXIT DO                   ' pressed ALT+q.
   ELSEIF keyinput$ = PageUp$ THEN
      
   ELSEIF keyinput$ = PageDown$ THEN
      
   ELSEIF keyinput$ <> "" THEN  ' Otherwise, if the user has
      'PRINT KeyInput$;
      PRINT #1, keyinput$;      ' pressed a key, send the
   END IF                       ' character typed to the modem.

   ' Check the modem. If characters are waiting (EOF(1) is
   ' true), get them and print them to the screen
   IF NOT EOF(1) THEN
      ModemInput$ = INPUT$(LOC(1), #1)
      Filter ModemInput$, AnyEvents
      SELECT CASE AnyEvents
	CASE Upload
	  BEEP
	  CurOff
	  FCP
	  GetText 20, 5, 63, 10, Gtxt$
	  Box 20, 5, 63, 10, 2, 15, 4
	  PAT 27, 6, "Partner wants to upload a file"
	  PAT 32, 7, "Getting file info..."
	  COLOR 14, 4
	  PAT 34, 8, "Please wait..."
	  COLOR 9, 4
	  PAT 30, 9, "Press ESC to Cancel"
	  UpFile$ = GetCode$
	  COLOR 14, 4
	  IF UpFile$ = xID$ + "BREAK" THEN
	    PAT 26, 8, "  TRANSFER STOPPED (ON ERROR)  "
	    COLOR 9, 4
	    PAT 30, 9, "     <  OK  >      "
	    DO: LOOP UNTIL mClick(35, 9, 42, 9) OR INKEY$ = CHR$(13)
	    PutText 20, 5, Gtxt$
	    Gtxt$ = ""
	    BarText
	    TCP
	    CurOn
	    GOTO AllRight
	  END IF
	  FileNm$ = LEFT$(UpFile$, LEN(UpFile$) - 4)
	  FileSz& = ByteToNum&(RIGHT$(UpFile$, 4))
	  COLOR 15, 4
	  PAT 32, 7, "Recieving file..."
	  PAT 34, 8, "              "
	  RecieveFile FileNm$, FileSz&, Mtxt$
	  FCP
	  PutText 20, 5, Gtxt$
	  Gtxt$ = ""
	  BarText
	  TCP
	  CurOn
	CASE Download
	  BEEP
	  CurOff
	  FCP
	  GetText 20, 5, 63, 10, Gtxt$
	  Box 20, 5, 63, 10, 2, 15, 4
	  PAT 27, 6, "Partner wants to download a file"
	  PAT 32, 7, "Getting file info..."
	  COLOR 14, 4
	  PAT 34, 8, "Please wait..."
	  COLOR 9, 4
	  PAT 30, 9, "Press ESC to Cancel"
	  DownFile$ = GetCode$
	  COLOR 14, 4
	  IF DownFile$ = xID$ + "BREAK" THEN
	    PAT 26, 8, "  TRANSFER STOPPED (ON ERROR)  "
	    COLOR 9, 4
	    PAT 30, 9, "     <  OK  >      "
	    DO: LOOP UNTIL mClick(35, 9, 42, 9) OR INKEY$ = CHR$(13)
	    PutText 20, 5, Gtxt$
	    Gtxt$ = ""
	    BarText
	    TCP
	    CurOn
	    GOTO AllRight
	  END IF
	  FileNm$ = LEFT$(DownFile$, LEN(DownFile$) - 4)
	  COLOR 15, 4
	  PAT 32, 7, "Sending file..."
	  PAT 34, 8, "              "
	  SendFile FileNm$, Mtxt$
	  FCP
	  PutText 20, 5, Gtxt$
	  Gtxt$ = ""
	  BarText
	  TCP
	  CurOn
	CASE Popup
	  BEEP
	  CurOff
	  FCP
	  GetText 20, 5, 63, 10, Gtxt$
	  Box 20, 5, 63, 10, 2, 15, 4
	  PAT 25, 6, "Partner is sending a popup message"
	  PAT 32, 7, "Getting popup message..."
	  COLOR 14, 4
	  PAT 34, 8, "Please wait..."
	  COLOR 9, 4
	  PAT 30, 9, "Press ESC to Cancel"
	  PopupMsg$ = GetCode$
	  COLOR 14, 4
	  IF PopupMsg$ = xID$ + "BREAK" THEN
	    PAT 26, 8, "  TRANSFER STOPPED (ON ERROR)  "
	    COLOR 9, 4
	    PAT 30, 9, "     <  OK  >      "
	    DO: LOOP UNTIL mClick(35, 9, 42, 9) OR INKEY$ = CHR$(13)
	    PutText 20, 5, Gtxt$
	    Gtxt$ = ""
	    BarText
	    TCP
	    CurOn
	    GOTO AllRight
	  END IF
	  COLOR 15, 4
	  PAT 23, 6, "       Popup Message Recieved       "
	  PAT 32, 7, "   Popup message:       "
	  COLOR 9, 4
	  PAT 30, 9, "     <  OK  >      "
	  COLOR 14, 4
	  DO
	     BannerScroll PopupMsg$, 23, 8, 37, 256
	  LOOP UNTIL mClick(35, 9, 42, 9) OR INKEY$ = CHR$(13)
	  PutText 20, 5, Gtxt$
	  Gtxt$ = ""
	  BarText
	  TCP
	  CurOn
      END SELECT
AllRight:
      PRINT ModemInput$;        ' backspaces, then print.
   END IF
LOOP

ComActive = 0
CLOSE                           ' End communications.
COLOR 7, 0
VIEW PRINT 1 TO 25
CLS
mInit
mHide
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

SUB BannerScroll (ts$, x, y, boxsize, ticks)
STATIC msgtimer AS SINGLE, msgstep
IF LEN(ts$) > 13 THEN
  IF msgtimer < TIMER THEN
    msgtimer = TIMER + .2
    msgstep = msgstep + 1
    Dmsg$ = ts$ + " *** " + ts$
    Dmsg$ = MID$(Dmsg$, msgstep, 37)
    IF msgstep = LEN(ts$) + 6 THEN msgstep = 1
    Dmsg$ = LEFT$(Dmsg$, 37)
    LOCATE 8, 23
    PRINT Dmsg$
  END IF
ELSE
  LOCATE 8, 23
  PRINT Mesg$ + SPACE$(37 - LEN(Mesg$))
END IF
END SUB

DEFSNG A-Z
SUB BarText
COLOR 0, 3: LOCATE 25, 1: PRINT SPACE$(80); : LOCATE 25, 1
      '<- begin                                                                  end ->'
PRINT "  <ALT+Q> - Quit   ³   <PGUP> - Upload file   ³   <PGDN> - Download (get) file  ";
END SUB

SUB BaudLatch (Speed%)
'Speed: 3 = 38.4, 2 = 56000, 1 = 115K

	OldLSR% = INP(ComAddr% + 3)
	OUT (ComAddr% + 3), (OldLSR% OR &H80)   ' Enable the Divisor Latch
	OUT (ComAddr% + 0), (Speed% MOD &HFF)   ' Lo Byte of Baud Rate
	OUT (ComAddr% + 1), (Speed% \ &H100)    ' Hi Byte of Baud Rate
	OUT (ComAddr% + 3), OldLSR%             ' Disable Divisor Latch
END SUB

DEFINT A-Z
SUB Box (x1, y1, x2, y2, Version, Clr1, Clr2)
' ********************
' * Draw a framework *
' ********************
' X1, Y1 - coordinates of upper left corner of framework
' X2, Y2 - coordinates of right lower corner of framework
' Version - form of framework
' Clr1, Clr2 -framework's fore- and background colors

REDIM B$(8, 6)
RESTORE DataBox
FOR I = 1 TO 8
	FOR J = 1 TO 6
		READ B$(I, J)
	NEXT J
NEXT I
COLOR Clr1, Clr2
LOCATE y1, x1
PRINT B$(Version, 1);
PRINT STRING$(x2 - x1 - 1, B$(Version, 2));
PRINT B$(Version, 3);
FOR y = y1 + 1 TO y2 - 1
	LOCATE y, x1
	PRINT B$(Version, 4);
	PRINT SPACE$(x2 - x1 - 1);
	PRINT B$(Version, 4);
NEXT y
LOCATE y2, x1
PRINT B$(Version, 5);
PRINT STRING$(x2 - x1 - 1, B$(Version, 2));
PRINT B$(Version, 6);
END SUB

FUNCTION ByteToNum& (Bytes$)
IF LEN(Bytes$) <> 4 THEN EXIT FUNCTION

Byte1& = (ASC(MID$(Bytes$, 1, 1)) AND &HFF&) * &H1
Byte2& = (ASC(MID$(Bytes$, 2, 1)) AND &HFF&) * &H100
Byte3& = (ASC(MID$(Bytes$, 3, 1)) AND &HFF&) * &H10000
Byte4& = (ASC(MID$(Bytes$, 4, 1)) AND &HFF&) * &H1000000
ByteToNum& = Byte1& + Byte2& + Byte3& + Byte4&
END FUNCTION

FUNCTION CarrierOn
SHARED CommAddr

DEF SEG = &H40
IF (INP(ComAddr + 6) AND 128) = 0 THEN CarrierOn = False ELSE CarrierOn = True
DEF SEG
END FUNCTION

SUB CurOff
SHARED Ylin
Ylin = CSRLIN
LOCATE , , 0
END SUB

SUB CurOn
SHARED Ylin
COLOR 7, 1
LOCATE Ylin + 1, 1, 1
END SUB

FUNCTION DIR$ (FileSpec$) STATIC

   DIM DTA AS STRING * 44, Regs AS RegTypeX
   Null$ = CHR$(0)

'-----  Set up our own DTA so we don't destroy COMMAND$
   Regs.ax = SetDTA                    'Set DTA function
   Regs.dx = VARPTR(DTA)               'DS:DX points to our DTA
   Regs.ds = -1                        'Use current value for DS
   INTERRUPTX DOS, Regs, Regs          'Do the interrupt

'-----  Check to see if this is First or Next
   IF LEN(FileSpec$) THEN              'FileSpec$ isn't null, so
							    'FindFirst
	 FileSpecZ$ = FileSpec$ + Null$   'Make FileSpec$ into an ASCIIZ
							    'string
	 Regs.ax = FindFirst              'Perform a FindFirst
	 Regs.cx = 0                      'Only look for normal files
	 Regs.dx = SADD(FileSpecZ$)       'DS:DX points to ASCIIZ file
	 Regs.ds = -1                     'Use current DS
   ELSE                                'We have a null FileSpec$,
	 Regs.ax = FindNext               'so FindNext
   END IF

   INTERRUPTX DOS, Regs, Regs          'Do the interrupt

'-----  Return file name or null
   IF Regs.flags AND 1 THEN            'No files found
	 DIR$ = ""                        'Return null string
   ELSE
	 Null = INSTR(31, DTA, Null$)     'Get the filename found
	 DIR$ = MID$(DTA, 31, Null - 30)  'It's an ASCIIZ string starting
   END IF                              'at offset 30 of the DTA

END FUNCTION

DEFSNG A-Z
SUB FCP
VIEW PRINT 1 TO 25
END SUB

DEFINT A-Z
SUB Filter (InString$, Events) STATIC
SHARED UpKey$

   ' Look for backspace characters and recode them to
   ' CHR$(29) (the LEFT cursor key):
   DO
      BackSpace = INSTR(InString$, CHR$(8))
      IF BackSpace THEN
	 MID$(InString$, BackSpace) = CHR$(29)
      END IF
   LOOP WHILE BackSpace

   ' Look for line-feed characters and remove any found:
   DO
      LineFeed = INSTR(InString$, CHR$(10))
      IF LineFeed THEN
	 InString$ = LEFT$(InString$, LineFeed - 1) + MID$(InString$, LineFeed + 1)
      END IF
   LOOP WHILE LineFeed
      
   Events = 0
   xStr$ = xStr$ + InString$
   IF INSTR(xStr$, xSTARTBLOCK$) THEN
      IF INSTR(xStr$, xSTARTBLOCK$ + xCONFIRM$ + xDOWN$ + xENDBLOCK$) THEN
	Events = Download
	MID$(xStr$, INSTR(xStr$, xSTARTBLOCK), 8) = "        "
      ELSEIF INSTR(xStr$, xSTARTBLOCK$ + xCONFIRM$ + xUP$ + xENDBLOCK$) THEN
	Events = Upload
	MID$(xStr$, INSTR(xStr$, xSTARTBLOCK), 8) = "        "
      ELSEIF INSTR(xStr$, xSTARTBLOCK$ + xCONFIRM$ + xPOPUP$ + xENDBLOCK$) THEN
	Events = Popup
	MID$(xStr$, INSTR(xStr$, xSTARTBLOCK), 8) = "        "
      END IF
   ELSE
     xStr$ = ""
   END IF
  
   'IF INSTR(InString$, "X") THEN Events = Popup
  
END SUB

FUNCTION GetByte$
SHARED Timeout, FileNum

eT! = TIMER + (Timeout / 1000)

GetByte$ = ""
DO
  IF NOT EOF(FileNum) THEN GetByte$ = INPUT$(1, FileNum): EXIT DO
  IF INKEY$ = CHR$(27) THEN GetByte$ = xCONFIRM$ + "CANCEL": EXIT DO
LOOP UNTIL TIMER >= eT!

END FUNCTION

'****** Block structure:
'
'Commands:
' 1     1       1          4         1          8        1
'(ID) (CMD) (CHECKSUM) Checksum (STARTBLOCK) Command (ENDBLOCK)
'
'Data blocks:
' 1     1         1         4         1          4          1
'(ID) (DATA) (CHECKSUM) Checksum (BLOCKSIZE) Block size (STARTBLOCK)
'   (Size)        1         5
' Data Block (ENDBLOCK) (CONFIRM)
'
'Resend last block:
' 1      1
'(ID) (RESEND)
'
FUNCTION GetCode$
SHARED Retry, LastBlock$

'GetCode$ = "Hello, this is a little popup message! How are you today?"
'EXIT FUNCTION

UpdateBar 0, 0

DIM CRC AS LONG, BSize AS LONG
RetryGetTheCode:
Bad = 0

'*** GET ID
DO
  tmp$ = GetByte$
  IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  IF LEN(tmp$) AND tmp$ = xID$ THEN
    EXIT DO
  ELSE
    Bad = Bad + 1
    UpdateBar Bad, NoGood
  END IF
  IF Bad = Retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
LOOP

'*** GET CMD/DATA/RESEND
RetryGet1:
tmp$ = GetByte$
IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
IF LEN(tmp$) AND (tmp$ = xCMD$ OR tmp$ = xDATA$ OR tmp$ = xRESEND$) THEN
  'nothing, just continue
ELSE
  Bad = Bad + 1
  UpdateBar Bad, NoGood
  IF Bad = Retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  GOTO RetryGet1
END IF

SELECT CASE tmp$
  CASE xCMD$
    BSize = 8
  CASE xRESEND$
    PutByte LastBlock$
    NoGood = NoGood + 1
    UpdateBar Bad, NoGood
    IF NoGood = Retry THEN
      GetCode$ = xID$ + "BREAK"
      EXIT FUNCTION
    END IF
    GOTO RetryGetTheCode
END SELECT

'*** GET CHECKSUM
temp$ = ""
DO
  tmp$ = GetByte$
  IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  IF LEN(tmp$) THEN
    temp$ = temp$ + tmp$
  ELSE
    Bad = Bad + 1
    UpdateBar Bad, NoGood
  END IF
  IF Bad = Retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  IF LEN(temp$) = 5 OR tmp$ = xSTARTBLOCK$ OR tmp$ = xBLOCKSIZE$ THEN
    EXIT DO
  END IF
LOOP

IF LEN(temp$) <> 5 THEN
  NoGood = NoGood + 1
  UpdateBar Bad, NoGood
  IF NoGood = Retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutResend
  GOTO RetryGetTheCode
END IF
temp$ = RIGHT$(temp$, LEN(temp$) - 1)
CRC = ByteToNum&(temp$)

'*** GET BLOCKSIZE
IF tmp$ = xBLOCKSIZE$ THEN
  temp$ = ""
  DO
    tmp$ = GetByte$
    IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
    IF LEN(tmp$) THEN
      temp$ = temp$ + tmp$
    ELSE
      Bad = Bad + 1
      UpdateBar Bad, NoGood
    END IF
    IF Bad = Retry THEN
      GetCode$ = xID$ + "BREAK": EXIT FUNCTION
    END IF
    IF LEN(temp$) = 5 OR tmp$ = xSTARTBLOCK$ THEN
      EXIT DO
    END IF
  LOOP

  IF LEN(temp$) <> 5 THEN
    NoGood = NoGood + 1
    UpdateBar Bad, NoGood
    IF NoGood = Retry THEN
      GetCode$ = xID$ + "BREAK"
      EXIT FUNCTION
    END IF
    PutResend
    GOTO RetryGetTheCode
  END IF
  temp$ = RIGHT$(temp$, LEN(temp$) - 1)
  BSize = ByteToNum&(temp$)
END IF

'*** GET BLOCK
IF tmp$ <> xSTARTBLOCK$ THEN
  NoGood = NoGood + 1
  IF NoGood = Retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutResend
  GOTO RetryGetTheCode
END IF
GetBlock$ = ""
ContGetBlock:
DO
  tmp$ = GetByte$
  IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  IF LEN(tmp$) THEN
    GetBlock$ = GetBlock$ + tmp$
  ELSE
    Bad = Bad + 1
    UpdateBar Bad, NoGood
  END IF
  IF Bad = Retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  IF tmp$ = xENDBLOCK$ THEN
    EXIT DO
  END IF
LOOP

DO
  tmp$ = GetByte$ + GetByte$ + GetByte$ + GetByte$ + GetByte$
  IF INSTR(tmp$, xCONFIRM$ + "CANCEL") THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  IF LEN(tmp$) = 5 AND tmp$ = xCONFIRM$ THEN
    EXIT DO
  ELSEIF LEN(tmp$) = 5 THEN
    GetBlock$ = GetBlock$ + tmp$
    GOTO ContGetBlock:
  ELSE
    Bad = Bad + 1
    UpdateBar Bad, NoGood
  END IF
  IF Bad = Retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
LOOP

'*** CHECK IF BLOCK IS VALID
IF LEN(GetBlock$) = BSize + 1 THEN
  NoGood = NoGood + 1
  UpdateBar Bad, NoGood
  IF NoGood = Retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutResend
  GOTO RetryGetTheCode
END IF
GetBlock$ = LEFT$(GetBlock$, BSize)
FOR a = 1 TO LEN(GetBlock$) - 1 STEP 2
  CalCRC& = CalCRC& XOR (ASC(MID$(GetBlock$, a, 1)) + ASC(MID$(GetBlock$, a + 1, 1)) * &H100)
NEXT a
IF CalCRC& <> CRC THEN
  NoGood = NoGood + 1
  IF NoGood = Retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutResend
  GOTO RetryGetTheCode
END IF
END FUNCTION

'size = ((x2 - x1 + 1) * (y2 - y1 + 1)) * 2 + 2
SUB GetText (x1, y1, x2, y2, Store$)
IF x1 > x2 THEN SWAP x1, x2
IF y1 > y2 THEN SWAP y1, y2
Store$ = CHR$(x2 - x1) + CHR$(y2 - y1)
FOR x = x1 TO x2
  FOR y = y1 TO y2
    Store$ = Store$ + CHR$(SCREEN(y, x, 0)) + CHR$(SCREEN(y, x, -1))
  NEXT y
NEXT x
END SUB

SUB Highlight (x, y, Hlen, FG, BG)
IF x > 80 OR x < 1 OR y > 25 OR y < 1 OR x + Hlen > 80 THEN EXIT SUB
COLOR FG, BG
FOR a = x TO x + Hlen - 1
  NoKey$ = INKEY$
  LOCATE y, a
  PRINT CHR$(SCREEN(y, a));
NEXT a
END SUB

FUNCTION InpBox$ (Def$, x, y, Overlay$)
IF y > 25 OR x > 80 OR y < 1 OR x < 1 THEN EXIT FUNCTION
Dlen = LEN(Def$)
IF x + Dlen > 80 THEN EXIT FUNCTION
Def$ = LTRIM$(RTRIM$(Def$))
IF LEN(Overlay$) > 1 THEN Overlay$ = LEFT$(Overlay$, 1)
LOCATE y, x
IF Overlay$ <> "" THEN
  PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$));
ELSE
  PRINT Def$ + SPACE$(Dlen - LEN(Def$));
END IF
L = 0              'location of cursor in the Box
LOCATE y + L, x, 1

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
   CASE CHR$(0) + CHR$(83)
     IF L < LEN(Def$) THEN
       IF L = 0 THEN
	 Def$ = RIGHT$(Def$, LEN(Def$) - 1) + " "
       ELSE
	 Def$ = LEFT$(Def$, L) + MID$(Def$, L + 2)
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
    InpBox$ = ""
    EXIT DO
   CASE CHR$(13)
    InpBox$ = RTRIM$(Def$)
    EXIT DO
   CASE ELSE
     Def$ = Def$ + SPACE$(Dlen - LEN(Def$))
     IF LEN(a$) = 1 AND L < Dlen THEN MID$(Def$, L + 1, 1) = a$: L = L + 1
     Def$ = LTRIM$(RTRIM$(Def$))
  END SELECT
  LOCATE y, x, 0
  IF Overlay$ <> "" THEN
    PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$));
  ELSE
    PRINT Def$ + SPACE$(Dlen - LEN(Def$));
  END IF
  LOCATE y, x + L, 1
LOOP
LOCATE y, x, 0
IF Overlay$ <> "" THEN
  PRINT STRING$(LEN(Def$), Overlay$) + SPACE$(Dlen - LEN(Def$))
ELSE
  PRINT Def$ + SPACE$(Dlen - LEN(Def$))
END IF
END FUNCTION

FUNCTION mClick (x1, y1, x2, y2)
mInfo x, y, btn
mClick = False
IF btn AND (x >= x1) AND (y >= y1) AND (x <= x2) AND (y <= y2) THEN mClick = True
END FUNCTION

SUB mHide
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 2
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  
END SUB

SUB mInfo (x, y, btn)
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB
 
  mInregs.ax = 3
  CALL INTERRUPT(&H33, mInregs, mOutregs)
  x = mOutregs.cx \ 8 + 1
  y = mOutregs.dx \ 8 + 1
  btn = mOutregs.bx

'-----[Debouncing Routine]-----
'mInfo Xpos, Ypos, Btns
'IF Btns THEN
'  ... code ...                  'a button has been pressed
'  DO                            'wait for the user to release the button
'    mInfo dummy, dummy, tmpBtn                                 '(debouncing)
'    IF tmpBtn = 0 THEN EXIT DO  'the user has released the button
'  LOOP
'  ... code ...                  'the button was released
'ENDIF

'-----[Drag Routine]-----
'mInfo oldX, oldY, Btns
'DO
'  mInfo newX, newY, Btns                 'get new mouse position
'  IF oldX <> newX OR oldY <> newY THEN
'    ... code ...                         'the pointer has moved
'  END IF
'  IF Btns = 0 THEN EXIT DO               'the user has released the button
'  oldX = newX: oldY = newY               'store old mouse position
'LOOP
'... code ...

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

SUB mShow
SHARED IsMouseOK, mInregs AS RegType, mOutregs AS RegType
 
  IF IsMouseOK = 0 THEN EXIT SUB

  mInregs.ax = 1
  CALL INTERRUPT(&H33, mInregs, mOutregs)

END SUB

FUNCTION NumToByte$ (Num&)
Byte1 = (Num& \ &H1) AND &HFF&
Byte2 = (Num& \ &H100) AND &HFF&
Byte3 = (Num& \ &H10000) AND &HFF&
Byte4 = (Num& \ &H1000000) AND &HFF&
NumToByte$ = CHR$(Byte1) + CHR$(Byte2) + CHR$(Byte3) + CHR$(Byte4)
END FUNCTION

SUB PAT (x, y, text$)
LOCATE y, x: PRINT text$
END SUB

SUB Pause (Seconds!)

T! = TIMER                        ' Pause routine
WHILE NOT TIMER - T! > Seconds!   ' Delay for how many Seconds!
WEND                              ' WHILE...WEND or DO...LOOP  Whatever

END SUB

FUNCTION PlusMin (Val1, Val2, PM)
PlusMin = ((Val1 >= (Val2 - PM)) AND (Val1 <= (Val2 + PM)))
END FUNCTION

'****** Block structure:
'
'Data blocks:
' 1     1         1         4         1          4          1
'(ID) (DATA) (CHECKSUM) Checksum (BLOCKSIZE) Block size (STARTBLOCK)
'   (Size)        1       1      1
' Data Block (ENDBLOCK) (ID) (ENDBLOCK)
'
SUB PutBlock (Block$)
SHARED LastBlock$, FileNum

FOR a = 1 TO LEN(Block$) - 1 STEP 2
  CRC& = CRC& XOR (ASC(MID$(Block$, a, 1)) + ASC(MID$(Block$, a + 1, 1)) * &H100)
NEXT a
OutBlock$ = ""
OutBlock$ = OutBlock$ + xID$ + xDATA$ + xCHECKSUM$
OutBlock$ = OutBlock$ + NumToByte$(CRC&) + xBLOCKSIZE$
OutBlock$ = OutBlock$ + NumToByte$(LEN(Block$)) + xSTARTBLOCK$
OutBlock$ = OutBlock$ + Block$ + xENDBLOCK$ + xCONFIRM$
PRINT #FileNum, OutBlock$
LastBlock$ = OutBlock$
OutBlock$ = ""

END SUB

SUB PutByte (what$)
SHARED FileNum
PRINT #FileNum, what$
END SUB

SUB PutCommand (Block$)
SHARED LastBlock$, FileNum

Block$ = LEFT$(Block$, 8)
Block$ = Block$ + SPACE$(8 - LEN(Block$))

FOR a = 1 TO 8 STEP 2
  CRC& = CRC& XOR (ASC(MID$(Block$, a, 1)) + ASC(MID$(Block$, a + 1, 1)) * &H100)
NEXT a
OutBlock$ = ""
OutBlock$ = OutBlock$ + xID$ + xCMD$ + xCHECKSUM$
OutBlock$ = OutBlock$ + NumToByte$(CRC&) + xSTARTBLOCK$
OutBlock$ = OutBlock$ + Block$ + xENDBLOCK$ + xCONFIRM$
PRINT #FileNum, OutBlock$
LastBlock$ = OutBlock$
OutBlock$ = ""

END SUB

SUB PutResend
SHARED FileNum, LastBlock$
PRINT #FileNum, xID$ + xRESEND$
END SUB

SUB PutText (x1, y1, Store$)
x2 = x1 + ASC(MID$(Store$, 1, 1))
y2 = y1 + ASC(MID$(Store$, 2, 1))
Store$ = RIGHT$(Store$, LEN(Store$) - 2)
Pnt = 1
FOR x = x1 TO x2
  FOR y = y1 TO y2
    Char$ = MID$(Store$, Pnt, 1)
    FGC = ASC(MID$(Store$, Pnt + 1, 1)) AND 15
    BGC = ASC(MID$(Store$, Pnt + 1, 1)) \ 16
    Pnt = Pnt + 2
    LOCATE y, x: COLOR FGC, BGC: PRINT Char$;
  NEXT y
NEXT x
END SUB

'Valid commands (with '*' prefix)
'(Always seen form sending computer's side)
'SENDF - send file
'CANCEL - cancel transfer
'GETF - get file
'READY - data-ready
'DONE - transfer done
SUB RecieveFile (FileName$, FileSize&, Msgs$)
SHARED BlockLen
FCP

Retr1r:
x$ = GetCode$                'get other computer's command
SELECT CASE x$
  CASE xID$ + "BREAK"              'GetCode couldn't get the code
    Msgs$ = "ERROR: Timeout on correct data recieve"
    PutCommand "*CANCEL"     'Cancel transfer
    EXIT SUB
  CASE "*CANCEL "            'The computer has cancelled transfer
    Msgs$ = "ERROR: Computer cancelled transfer (maybe on error/timeout)"
    EXIT SUB
  CASE "*SENDF  "
    'OK, we are ready!
  CASE ELSE    'Practically impossible because of checksum, but other comp.
    PutCommand "*CANCEL"  'could be sending a invalid command/data block.
    Msgs$ = "ERROR: Computer is sending invalid block"
    EXIT SUB
END SELECT
PutCommand "*READY"
Retr2r:
x$ = GetCode$                'get it's response
SELECT CASE x$
  CASE xID$ + "BREAK"              'GetCode couldn't get the code
    Msgs$ = "ERROR: Timeout on correct data recieve"
    PutCommand "*CANCEL"     'Cancel transfer
    EXIT SUB
  CASE "*CANCEL "            'The computer has cancelled transfer
    Msgs$ = "ERROR: Computer cancelled transfer (maybe on error/timeout)"
    EXIT SUB
  CASE ELSE
    'the computer accepted our command and is sending the first block
END SELECT
FR = FREEFILE
OPEN FileName$ FOR BINARY AS #FR
IF LOF(FR) THEN
  CLOSE #FR
  PutCommand "*CANCEL"
  Msgs$ = "ERROR: File already exists"
  EXIT SUB
END IF
DO
  PUT #FR, , x$
  PutCommand "*READY"
Retr3r:
  x$ = GetCode$                'get it's response
  SELECT CASE x$
    CASE xID$ + "BREAK"              'GetCode couldn't get the code
      Msgs$ = "ERROR: Timeout on correct data recieve"
      PutCommand "*CANCEL"     'Cancel transfer
      EXIT SUB
    CASE "*CANCEL "            'The computer has cancelled transfer
      Msgs$ = "ERROR: Computer cancelled transfer (maybe on error/timeout)"
      EXIT SUB
    CASE "*DONE   "            'End of file!
      EXIT DO
    CASE ELSE
      'the computer is sending the next block
  END SELECT
LOOP
x$ = ""
Msgs$ = "File recieved OK"
PutCommand "*DONE"

TCP
END SUB

'Valid commands (with '*' prefix)
'(Always seen form sending computer's side)
'SENDF - send file
'CANCEL - cancel transfer
'GETF - get file
'READY - data-ready
'DONE - transfer done
SUB SendFile (FileName$, Msgs$)
SHARED BlockLen, TranPath$
FE = FREEFILE
OPEN TranPath$ + FileName$ FOR BINARY AS #FE
IF LEN(FE) = 0 THEN
  PutCommand "*CANCEL"
  Msgs$ = "ERROR: File not found"
  CLOSE #FE
  KILL TranPath$ + FileName$
  EXIT SUB
END IF

PutCommand "*SENDF"          'tell the computer we want to send a file

Retr1s:
x$ = GetCode$                'get it's response
SELECT CASE x$
  CASE xID$ + "BREAK"              'GetCode couldn't get the code
    Msgs$ = "ERROR: Timeout on correct data recieve"
    PutCommand "*CANCEL"     'Cancel transfer
    EXIT SUB
  CASE "*CANCEL "            'The computer has cancelled transfer
    Msgs$ = "ERROR: Computer cancelled transfer (maybe on error/timeout)"
    EXIT SUB
  CASE "*READY  "
    'OK, start transfer!
  CASE ELSE    'Practically impossible because of checksum, but other comp.
    PutCommand "*CANCEL"  'could be sending a invalid command/data block.
    Msgs$ = "ERROR: Computer is sending invalid block"
    EXIT SUB
END SELECT

OPEN FileName$ FOR BINARY AS #FE
DO
  Blen& = LOF(1) - LOC(1) + 1
  IF Blen& > BlockLen THEN Blen& = BlockLen
  DataBlock$ = STRING$(Blen&, 0)
  GET #FE, , DataBlock$
  PutBlock DataBlock$
Retr2s:
  
  x$ = GetCode$                'get it's response
  SELECT CASE x$
    CASE xID$ + "BREAK"             'GetCode couldn't get the code
      Msgs$ = "ERROR: Timeout on correct data recieve"
      PutCommand "*CANCEL"     'Cancel transfer
      EXIT SUB
    CASE "*CANCEL "            'The computer has cancelled transfer
      Msgs$ = "ERROR: Computer cancelled transfer (maybe on error/timeout)"
      EXIT SUB
    CASE "*READY  "
      'OK, next block!
    CASE ELSE    'Practically impossible because of checksum, but other comp.
      PutCommand "*CANCEL"  'could be sending a invalid command/data block.
      Msgs$ = "ERROR: Computer is sending invalid block"
      EXIT SUB
  END SELECT
LOOP UNTIL EOF(1)
CLOSE #FE

PutCommand "*DONE"           'tell the computer we are done
Retr3s:
x$ = GetCode$                'get it's response
SELECT CASE x$
  CASE xID$ + "BREAK"             'GetCode couldn't get the code
    'we don't care
    PutCommand "*CANCEL"
  CASE "*CANCEL "            'The computer has cancelled transfer
    'we don't care
  CASE "*DONE   "
    'OK, everything done!
  CASE ELSE    'Practically impossible because of checksum, but other comp.
    PutCommand "*CANCEL"  'could be sending a invalid command/data block.
    'we don't care
END SELECT

Msgs$ = "Transfer OK!"
END SUB

DEFSNG A-Z
SUB TCP
VIEW PRINT 2 TO 24
END SUB

DEFINT A-Z
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

FUNCTION trim$ (what$)
trim$ = LTRIM$(RTRIM$(what$))
END FUNCTION

SUB UpdateBar (ByteRetry, BlockRetry)
SHARED FileNum

COLOR 0, 3: LOCATE 25, 1: PRINT SPACE$(80); : LOCATE 25, 1
LOCATE 25, 1
ost$ = " ³  Byte Retry: " + trim$(STR$(ByteRetry))
ost$ = ost$ + "  ³  Block Retry: " + trim$(STR$(BlockRetry))
PRINT ost$;
LOCATE 25, 1
IF EOF(FileNum) THEN COLOR 4, 3 ELSE COLOR 2, 3
PRINT "Û";
END SUB

