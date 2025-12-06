DEFINT A-Z
DECLARE FUNCTION GetByte$ (Bytes%)
DECLARE FUNCTION GetCode$ (retry%)
DECLARE SUB PutByte (byte$)
DECLARE SUB PutCode (block$)
CONST xID$ = ""           'ID, starts each block
CONST xDATA$ = ""         'Data follows
CONST xRESEND$ = ""       'Re-send last block code
CONST xCHECKSUM$ = ""     'Checksum for block follows
CONST xSTARTBLOCK$ = ""   'Start of block
CONST xENDBLOCK$ = ""     'End of block
CONST xCONFIRM$ = "--"  'Confirm end-of-block
CONST xBLOCKSIZE$ = ""    'Block size follows
CONST True = -1, False = 0
DIM SHARED FileNum
'
'   *** Data Transfer Routines ***
'        by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This program helps you transfer data without errors. It uses a CRC and
'will automatically retry send/recieve as many times as specified.
'
'
'
'Okay, here's how it works when you want to recieve something:
' Your friend calls PutCode with whatever data he wants.
' You call GetCode. GetCode waits for the data and recieves it.
' Meanwhile, your friend's PutCode is calling GetCode to get a
'confirm that the data is okay.
' Your GetCode, after getting your friend's data, sends a confirm
'string using PutCode. That PutCode does not call GetCode for a
'confirm string because then the confirm string would be confirmed
'endlessly.
' You now have your friend's data (without errors of any kind).
' Your PutCode has sent the confirm string and your friend's GetCode
'(called by your friend's PutCode to get the confirm string) recieves
'it. The GetCode recieving the confirm string does not send a confirm beacuse then it would be
'confirming a confirm string. Now your friend's PutCode's GetCode returns
'the confirm string
'
'

FUNCTION GetByte$ (Bytes)
SHARED FileNum

eT! = TIMER + 1
GetByte$ = ""
DO
  IF NOT EOF(FileNum) THEN GetByte$ = INPUT$(Bytes, FileNum): EXIT DO
  IF INKEY$ = CHR$(27) THEN GetByte$ = xCONFIRM$ + "CANCEL": EXIT DO
LOOP UNTIL TIMER >= eT!
END FUNCTION

FUNCTION GetCode$ (retry)
GetCode$ = ""
SHARED LastBlock$

DIM CRC AS LONG, BSize AS LONG
RetryGetTheCode:
Bad = 0

'*** GET ID
DO
  tmp$ = GetByte$(1)
  IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  IF LEN(tmp$) AND tmp$ = xID$ THEN
    EXIT DO
  ELSE
    Bad = Bad + 1
  END IF
  IF Bad = retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
LOOP

'*** GET DATA/RESEND
RetryGet1:
tmp$ = GetByte$(1)
IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
IF LEN(tmp$) AND (tmp$ = xDATA$ OR tmp$ = xRESEND$) THEN
  'nothing, just continue
ELSE
  Bad = Bad + 1
  IF Bad = retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  GOTO RetryGet1
END IF

IF tmp$ = xRESEND$ THEN
  IF LstRe = True THEN
    PutByte xID$ + xRESEND$
    LastRe = True
  ELSE
    PutByte LastBlock$
    NoGood = NoGood + 1
    IF NoGood = retry THEN
      GetCode$ = xID$ + "BREAK"
      EXIT FUNCTION
    END IF
  END IF
  GOTO RetryGetTheCode
END IF
LstRe = (LastRe = True)
LastRe = False

'*** GET CHECKSUM
temp$ = ""
DO
  tmp$ = GetByte$(1)
  IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  IF LEN(tmp$) THEN
    temp$ = temp$ + tmp$
  ELSE
    Bad = Bad + 1
    END IF
  IF Bad = retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  IF LEN(temp$) = 5 OR tmp$ = xSTARTBLOCK$ OR tmp$ = xBLOCKSIZE$ THEN
    EXIT DO
  END IF
LOOP

IF LEN(temp$) <> 5 THEN
  NoGood = NoGood + 1
  IF NoGood = retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutByte xID$ + xRESEND$
  LstRe = True
  GOTO RetryGetTheCode
END IF
temp$ = RIGHT$(temp$, LEN(temp$) - 1)
Bytes$ = temp$
Byte1& = (ASC(MID$(Bytes$, 1, 1)) AND &HFF&) * &H1
Byte2& = (ASC(MID$(Bytes$, 2, 1)) AND &HFF&) * &H100
Byte3& = (ASC(MID$(Bytes$, 3, 1)) AND &HFF&) * &H10000
Byte4& = (ASC(MID$(Bytes$, 4, 1)) AND &HFF&) * &H1000000
ByteToNum& = Byte1& + Byte2& + Byte3& + Byte4&
CRC = ByteToNum&

'*** GET BLOCKSIZE
IF tmp$ = xBLOCKSIZE$ THEN
  temp$ = ""
  DO
    tmp$ = GetByte$(1)
    IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
    IF LEN(tmp$) THEN
      temp$ = temp$ + tmp$
    ELSE
      Bad = Bad + 1
      END IF
    IF Bad = retry THEN
      GetCode$ = xID$ + "BREAK": EXIT FUNCTION
    END IF
    IF LEN(temp$) = 5 OR tmp$ = xSTARTBLOCK$ THEN
      EXIT DO
    END IF
  LOOP

  IF LEN(temp$) <> 5 THEN
    NoGood = NoGood + 1
    IF NoGood = retry THEN
      GetCode$ = xID$ + "BREAK"
      EXIT FUNCTION
    END IF
    PutByte xID$ + xRESEND$
    LstRe = True
    GOTO RetryGetTheCode
  END IF
  temp$ = RIGHT$(temp$, LEN(temp$) - 1)
  Bytes$ = temp$
  Byte1& = (ASC(MID$(Bytes$, 1, 1)) AND &HFF&) * &H1
  Byte2& = (ASC(MID$(Bytes$, 2, 1)) AND &HFF&) * &H100
  Byte3& = (ASC(MID$(Bytes$, 3, 1)) AND &HFF&) * &H10000
  Byte4& = (ASC(MID$(Bytes$, 4, 1)) AND &HFF&) * &H1000000
  ByteToNum& = Byte1& + Byte2& + Byte3& + Byte4&
  BSize = ByteToNum&
END IF

'*** GET BLOCK
IF tmp$ <> xSTARTBLOCK$ THEN
  NoGood = NoGood + 1
  IF NoGood = retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutByte xID$ + xRESEND$
  LstRe = True
  GOTO RetryGetTheCode
END IF
GetBlock$ = ""
ContGetBlock:
DO
  tmp$ = GetByte$(1)
  IF tmp$ = xCONFIRM$ + "CANCEL" THEN GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  IF LEN(tmp$) THEN
    GetBlock$ = GetBlock$ + tmp$
  ELSE
    Bad = Bad + 1
  END IF
  IF Bad = retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
  IF tmp$ = xENDBLOCK$ THEN
    EXIT DO
  END IF
LOOP

DO
  tmp$ = GetByte$(5)
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
  END IF
  IF Bad = retry THEN
    GetCode$ = xID$ + "BREAK": EXIT FUNCTION
  END IF
LOOP

'*** CHECK IF BLOCK IS VALID
IF LEN(GetBlock$) = BSize + 1 THEN
  NoGood = NoGood + 1
  IF NoGood = retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutByte xID$ + xRESEND$
  LstRe = True
  GOTO RetryGetTheCode
END IF
GetBlock$ = LEFT$(GetBlock$, BSize)
FOR a = 1 TO LEN(GetBlock$) - 1 STEP 2
  CalCRC& = CalCRC& XOR (ASC(MID$(GetBlock$, a, 1)) + ASC(MID$(GetBlock$, a + 1, 1)) * &H100)
NEXT a
IF CalCRC& <> CRC THEN
  NoGood = NoGood + 1
  IF NoGood = retry THEN
    GetCode$ = xID$ + "BREAK"
    EXIT FUNCTION
  END IF
  PutByte xID$ + xRESEND$
  LstRe = True
  GOTO RetryGetTheCode
END IF
GetCode$ = GetBlock$
IF RIGHT$(block$, 2) = "." + CHR$(123) AND INSTR(UCASE$(block$), "CONFIRM") THEN EXIT FUNCTION
PutCode "This is a confirm that I got the code." + CHR$(123)
END FUNCTION

SUB PutByte (byte$)
SHARED FileNum
PRINT #FileNum, byte$
END SUB

SUB PutCode (block$)
SHARED LastBlock$, FileNum

FOR a = 1 TO LEN(block$) - 1 STEP 2
  CRC& = CRC& XOR (ASC(MID$(block$, a, 1)) + ASC(MID$(block$, a + 1, 1)) * &H100)
NEXT a
OutBlock$ = xID$ + xDATA$ + xCHECKSUM$
Num& = CRC&: GOSUB NumTtoByte
OutBlock$ = OutBlock$ + NumToByte$ + xBLOCKSIZE$
Num& = LEN(block$): GOSUB NumTtoByte
OutBlock$ = OutBlock$ + NumToByte$ + xSTARTBLOCK$
OutBlock$ = OutBlock$ + block$ + xENDBLOCK$ + xCONFIRM$
PRINT #FileNum, OutBlock$
LastBlock$ = OutBlock$
OutBlock$ = ""

block$ = ""
IF RIGHT$(block$, 2) = "." + CHR$(123) AND INSTR(UCASE$(block$), "CONFIRM") THEN EXIT SUB
X$ = GetCode$(0)
IF X$ = xID$ + "BREAK" THEN block$ = X$: EXIT SUB
IF RIGHT$(block$, 2) <> "." + CHR$(123) OR INSTR(UCASE$(block$), "CONFIRM") THEN block$ = X$: EXIT SUB
block$ = ""

EXIT SUB
NumTtoByte:
Byte1 = (Num& \ &H1) AND &HFF&
Byte2 = (Num& \ &H100) AND &HFF&
Byte3 = (Num& \ &H10000) AND &HFF&
Byte4 = (Num& \ &H1000000) AND &HFF&
NumToByte$ = CHR$(Byte1) + CHR$(Byte2) + CHR$(Byte3) + CHR$(Byte4)
RETURN
END SUB

