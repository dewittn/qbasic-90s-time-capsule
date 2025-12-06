DECLARE SUB LCA1decomp (InFile$, OutFile$, BuffLen%, Msg$)
DECLARE SUB LCA1comp (InFile$, OutFile$, BuffLen%, Msg$)

CLS
File$ = "C:\TEST.TXT"
OPEN File$ FOR BINARY AS #1
PRINT "----- Compression -----"
PRINT "*** Info ***"
PRINT "File: "; File$; " ("; LTRIM$(RTRIM$(STR$(LOF(1)))); " bytes)"
CLOSE #1
OPEN "C:\TEST.CMP" FOR BINARY AS #1
CLOSE #1: KILL "C:\TEST.CMP"
PRINT "*** Compressing ***"
LCA1comp File$, "C:\TEST.CMP", 1000, Msgs$
PRINT "Done"
PRINT "*** Messages ***"
IF LEFT$(Msgs$, 7) = "ERROR: " THEN
  PRINT "Error during compressing: "; RIGHT$(Msgs$, LEN(Msgs$) - 7)
  SYSTEM
END IF

PRINT Msgs$
OPEN "C:\TEST.CMP" FOR BINARY AS #1
PRINT "*** Info ***"
PRINT "New file length: "; LTRIM$(RTRIM$(STR$(LOF(1)))); " bytes"
CLOSE #1

Msgs$ = ""
CLOSE
OPEN "C:\TEST.OUT" FOR BINARY AS #1
CLOSE #1: KILL "C:\TEST.OUT"
OPEN "C:\TEST.CMP" FOR BINARY AS #1
'SLEEP
PRINT "----- Decompression -----"
PRINT "*** Info ***"
PRINT "(Compressed) File length: "; LTRIM$(RTRIM$(STR$(LOF(1)))); " bytes"
CLOSE #1
PRINT "*** Decompressing ***"
LCA1decomp "C:\TEST.CMP", "C:\TEST.OUT", 1000, Msgs$
PRINT "Done"
PRINT "*** Messages ***"
IF LEFT$(Msgs$, 7) = "ERROR: " THEN
  PRINT "Error during decompressing: "; RIGHT$(Msgs$, LEN(Msgs$) - 7)
  SYSTEM
END IF

PRINT Msgs$
OPEN "C:\TEST.OUT" FOR BINARY AS #1
PRINT "*** Info ***"
PRINT "New file length: "; LTRIM$(RTRIM$(STR$(LOF(1)))); " bytes"
CLOSE #1
KILL "C:\TEST.CMP"
'KILL "C:\TEST.OUT"
PRINT "----- End -----"

DEFINT A-Z
'LCA Compressor V1.0
'by Hauke Daempfling
'April/May 1996
SUB LCA1comp (InFile$, OutFile$, BuffLen, Msg$)
'*** Prepare vars. & error checking
InFile$ = LTRIM$(RTRIM$(InFile$))
OutFile$ = LTRIM$(RTRIM$(OutFile$))
IF InFile$ = "" THEN Msg$ = "ERROR: No input file": EXIT SUB
IF OutFile$ = "" THEN Msg$ = "ERROR: No output file": EXIT SUB
IF BuffLen < 256 OR BuffLen > 10000 THEN Msg$ = "ERROR: Invalid buffer size (Values: 256-10000)": EXIT SUB
IF BuffLen * 2 > FRE("Free Memory") - 4096 THEN Msg$ = "ERROR: Buffer too big (Out of memory)": EXIT SUB
DIM BitMask(8): FOR a = 0 TO 8: BitMask(a) = 2 ^ a: NEXT a
DIM SwitchList(255), CodeList(255, 8), MaxCodes
InBuffer$ = STRING$(BuffLen, 0)
OutBuffer$ = ""

'*** Check Input file
F1 = FREEFILE
OPEN InFile$ FOR BINARY AS #F1
IF LOF(F1) = 0 THEN
  Msg$ = "ERROR: " + InFile$ + " not found"
  CLOSE #F1
  KILL InFile$
  EXIT SUB
END IF

'*** Check Output file
F2 = FREEFILE
OPEN OutFile$ FOR BINARY AS #F2
IF LOF(F2) THEN
  Msg$ = "ERROR: " + OutFile$ + " already exists"
  CLOSE #F2
  EXIT SUB
END IF
DIM Fpos AS LONG, FileLen AS LONG
FileLen = LOF(F1)

'*** If file size < 100 then no use compressing
IF FileLen < 100 THEN
  Msg$ = "ERROR: No use compressing (File too small)"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF

'*** Get distrib.
'PRINT "Scanning file and generating codes..."
Rpos = BuffLen + 1
FOR Fpos = 1 TO FileLen
  IF Rpos > BuffLen THEN
    GET #F1, , InBuffer$
    Rpos = 1
  END IF
  CurByte = ASC(MID$(InBuffer$, Rpos, 1))
  Rpos = Rpos + 1
  SwitchList(CurByte) = 1
NEXT Fpos
SEEK #F1, 1

'*** Generate Codes
MaxCodes = -1
FOR a = 0 TO 255
  IF SwitchList(a) THEN
    MaxCodes = MaxCodes + 1
    'PRINT "Code for"; a; "(code"; MaxCodes; ") :";
    CodeList(a, 0) = MaxCodes
    FOR b = 1 TO 8
      CodeList(a, b) = (MaxCodes AND BitMask(b - 1)) \ BitMask(b - 1)
      'PRINT CodeList(a, b);
    NEXT b
    'PRINT
  END IF
NEXT a
'SLEEP
IF MaxCodes = -1 THEN
  Msg$ = "ERROR: Internal error - check input file"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF
'PRINT "Codes: "; MaxCodes + 1

'*** Find max. code size
FOR a = 0 TO 7
  IF MaxCodes > BitMask(a) - 1 THEN
    NeedBits = a + 1
  ELSE
    EXIT FOR
  END IF
NEXT a
'PRINT "Bits needed:"; NeedBits
IF NeedBits = 0 THEN
  Msg$ = "ERROR: Internal error - check input file"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF
'PRINT "Guessed Ratio:"; 100 - ((NeedBits / 8) * 100); "%"
IF NeedBits = 8 THEN
  Msg$ = "ERROR: No use compressing (File would expand)"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF

'*** Debugging
'PRINT "New codes:"
'd = -1
'FOR a = 0 TO 255
'  IF SwitchList(a) THEN
'   d = d + 1
'    PRINT "Code for"; a; "(code"; d; ") :";
'    FOR b = 1 TO CodeLen(a)
'      PRINT CodeList(a, b);
'    NEXT b
'    PRINT
'  END IF
'NEXT a
'FOR a = 0 TO 255: PRINT SwitchList(a); : NEXT a: PRINT
'FOR a = 0 TO 255
'  IF SwitchList(a) THEN PRINT CodeList(a, 0); "="; a; "|";
'NEXT a
'PRINT

'*** Write Header
'PRINT "Compressing and writing file..."
'* LCA ID string
OutBuffer$ = OutBuffer$ + "LCAF"
'* LCA Version
OutBuffer$ = OutBuffer$ + CHR$(&H10)
'* Old file size
Byte1 = (FileLen \ &H1) AND &HFF
Byte2 = (FileLen \ &H100) AND &HFF
Byte3 = (FileLen \ &H10000) AND &HFF
Byte4 = (FileLen \ &H1000000) AND &HFF
OutBuffer$ = OutBuffer$ + CHR$(Byte1) + CHR$(Byte2) + CHR$(Byte3) + CHR$(Byte4)
'* Reserved for new file size
OutBuffer$ = OutBuffer$ + "    "
'* Options reserved for future versions
OutBuffer$ = OutBuffer$ + CHR$(255)
'* Compression codes
SWout = 0: CurByte = 0
FOR a = 1 TO 32
  FOR b = 0 TO 7
    'PRINT SwitchList(SWout);
    IF SwitchList(SWout) THEN
      CurByte = CurByte + BitMask(b)
    END IF
    SWout = SWout + 1
  NEXT b
  OutBuffer$ = OutBuffer$ + CHR$(CurByte)
  CurByte = 0
NEXT a
'PRINT
'SLEEP
'* Start of file code
OutBuffer$ = OutBuffer$ + "SOCF"

'*** Compression
'PRINT "Wait.";
Rpos = BuffLen + 1
CurBit = 0: CurByte = 0: OutByte = 0
FOR Fpos = 1 TO FileLen
  IF Rpos > BuffLen THEN
    'PRINT ".";
    GET #F1, , InBuffer$
    Rpos = 1
  END IF
  CurByte = ASC(MID$(InBuffer$, Rpos, 1))
  Rpos = Rpos + 1
  FOR a = 1 TO NeedBits
    'OutByte = (OutByte * 2) OR CodeList(CurByte, a)
    CurBit = CurBit + 1
    IF CodeList(CurByte, a) THEN OutByte = OutByte + BitMask(CurBit - 1)
    IF CurBit = 8 THEN
      OutBuffer$ = OutBuffer$ + CHR$(OutByte)
      OutByte = 0: CurBit = 0
      IF LEN(OutBuffer$) = BuffLen THEN
        'PRINT ".";
        PUT #F2, , OutBuffer$
        OutBuffer$ = ""
      END IF
    END IF
  NEXT a
NEXT Fpos

'*** Dump rest of buffer
'PRINT "."
'IF LEN(OutBuffer$) THEN PRINT LEN(OutBuffer$)
PUT #F2, , OutBuffer$

'*** Add compressed file len to header of output file
DIM NewFileLen AS LONG
NewFileLen = LOF(F2)
Byte1 = (NewFileLen \ &H1) AND &HFF
Byte2 = (NewFileLen \ &H100) AND &HFF
Byte3 = (NewFileLen \ &H10000) AND &HFF
Byte4 = (NewFileLen \ &H1000000) AND &HFF
tmp$ = CHR$(Byte1) + CHR$(Byte2) + CHR$(Byte3) + CHR$(Byte4)
PUT #F2, 10, tmp$

Ratio = 100 - ((LOF(F2) / LOF(F1)) * 100)
Msg$ = "Compression completed. Ratio: " + LTRIM$(RTRIM$(STR$(Ratio))) + "%"
CLOSE #F1, #F2
END SUB

'LCA Decompressor V1.0
'by Hauke Daempfling
'April/May 1996
SUB LCA1decomp (InFile$, OutFile$, BuffLen, Msg$)
'*** Prepare vars. & error checking
InFile$ = LTRIM$(RTRIM$(InFile$))
OutFile$ = LTRIM$(RTRIM$(OutFile$))
IF InFile$ = "" THEN Msg$ = "ERROR: No input file": EXIT SUB
IF OutFile$ = "" THEN Msg$ = "ERROR: No output file": EXIT SUB
IF BuffLen < 256 OR BuffLen > 10000 THEN Msg$ = "ERROR: Invalid buffer size (Values: 256-10000)": EXIT SUB
IF BuffLen * 2 > FRE("Free Memory") - 2048 THEN Msg$ = "ERROR: Buffer too big (Out of memory)": EXIT SUB
DIM BitMask(8): FOR a = 0 TO 8: BitMask(a) = 2 ^ a: NEXT a
DIM SwitchList(255), MaxCodes, CodeList(255)
InBuffer$ = STRING$(BuffLen, 0)
OutBuffer$ = ""

'*** Check Input file
F1 = FREEFILE
OPEN InFile$ FOR BINARY AS #F1
IF LOF(F1) = 0 THEN
  Msg$ = "ERROR: " + InFile$ + " not found"
  CLOSE #F1
  KILL InFile$
  EXIT SUB
END IF

'*** Check Output file
F2 = FREEFILE
OPEN OutFile$ FOR BINARY AS #F2
IF LOF(F2) THEN
  Msg$ = "ERROR: " + OutFile$ + " already exists"
  CLOSE #F2, #F1
  EXIT SUB
END IF
DIM Fpos AS LONG, FileLen AS LONG
FileLen = LOF(F1)

'*** Get Header
tmpBuff$ = STRING$(50, 0)
GET #F1, , tmpBuff$
'* LCA ID
IF LEFT$(tmpBuff$, 4) <> "LCAF" THEN
 Msg$ = "ERROR: Invalid LCA identifier": CLOSE #F2, #F1
 KILL OutFile$: EXIT SUB
END IF
'* Version
Vers = ASC(MID$(tmpBuff$, 5, 1))
HiVer = (Vers AND &HF0) \ &H10
LoVer = Vers AND &HF
IF HiVer <> 1 OR LoVer <> 0 THEN
  Msg$ = "ERROR: Compressed file has different version"
  CLOSE #F1, #F2: KILL OutFile$: EXIT SUB
END IF
'PRINT "Version: " + LTRIM$(RTRIM$(STR$(HiVer))) + "." + LTRIM$(RTRIM$(STR$(LoVer)))
'* Uncompressed file length
DIM NewFileLen AS LONG
Byte1& = ASC(MID$(tmpBuff$, 6, 1)) * &H1
Byte2& = ASC(MID$(tmpBuff$, 7, 1)) * &H100
Byte3& = ASC(MID$(tmpBuff$, 8, 1)) * &H10000
Byte4& = ASC(MID$(tmpBuff$, 9, 1)) * &H1000000
NewFileLen = Byte1& + Byte2& + Byte3& + Byte4&
'* Compressed file length
DIM OldFileLen AS LONG
Byte1& = ASC(MID$(tmpBuff$, 10, 1)) * &H1
Byte2& = ASC(MID$(tmpBuff$, 11, 1)) * &H100
Byte3& = ASC(MID$(tmpBuff$, 12, 1)) * &H10000
Byte4& = ASC(MID$(tmpBuff$, 13, 1)) * &H1000000
OldFileLen = Byte1& + Byte2& + Byte3& + Byte4&
IF OldFileLen <> FileLen THEN
  Msg$ = "ERROR: Input file size changed (file manipulated/invalid file)"
  CLOSE #F1, #F2: KILL OutFile$: EXIT SUB
END IF
'* Compression codes
SWin = 0
FOR a = 1 TO 32
  FOR b = 0 TO 7
    SwitchList(SWin) = -((ASC(MID$(tmpBuff$, a + 14, 1)) AND BitMask(b)) > 0)
    'PRINT SwitchList(SWin);
    SWin = SWin + 1
  NEXT b
NEXT a
'PRINT
'* Start Of File
IF RIGHT$(tmpBuff$, 4) <> "SOCF" THEN
  Msg$ = "ERROR: Invalid Header"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF
tmpBuff$ = ""

'*** Generate Codes
MaxCodes = -1
FOR a = 0 TO 255
  IF SwitchList(a) THEN
    MaxCodes = MaxCodes + 1
    CodeList(MaxCodes) = a
    'PRINT "Code for "; a; ":"; MaxCodes
  END IF
NEXT a
'SLEEP
IF MaxCodes = -1 THEN
  Msg$ = "ERROR: Internal error - check input file"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF
'PRINT "Codes: "; MaxCodes + 1

'*** Find max. code size
FOR a = 0 TO 7
  IF MaxCodes > BitMask(a) - 1 THEN
    NeedBits = a + 1
  ELSE
    EXIT FOR
  END IF
NEXT a
'PRINT "Bits needed:"; NeedBits
IF NeedBits = 0 THEN
  Msg$ = "ERROR: Internal error - check input file"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF
'PRINT "Guessed Ratio:"; 100 - ((NeedBits / 8) * 100); "%"
IF NeedBits = 8 THEN
  Msg$ = "ERROR: No use compressing (File would expand)"
  CLOSE #F1, #F2
  KILL OutFile$
  EXIT SUB
END IF
'FOR a = 0 TO 255
'  IF SwitchList(a) THEN PRINT a; "="; CodeList(a); "|";
'NEXT a
'PRINT
'FOR a = 0 TO 255: PRINT SwitchList(a); : NEXT a: PRINT

'*** Decompression
Rpos = BuffLen + 1
CurBit = 7
FOR Fpos = 1 TO NewFileLen
  FOR a = 1 TO NeedBits
    IF CurBit = 7 THEN
      IF Rpos > BuffLen THEN
        'PRINT ".";
        GET #F1, , InBuffer$
        Rpos = 1
      END IF
      CurByte = ASC(MID$(InBuffer$, Rpos, 1))
      Rpos = Rpos + 1
      CurBit = -1
    END IF
    CurBit = CurBit + 1
    ReadBit = (CurByte AND BitMask(CurBit)) \ BitMask(CurBit)
    'OutByte = (OutByte * 2) OR ReadBit
    IF ReadBit THEN OutByte = OutByte + BitMask(a - 1)
  NEXT a
  OutBuffer$ = OutBuffer$ + CHR$(CodeList(OutByte))
  IF LEN(OutBuffer$) = BuffLen THEN
    PUT #F2, , OutBuffer$
    OutBuffer$ = ""
  END IF
  OutByte = 0
NEXT Fpos
'PRINT
PUT #F2, , OutBuffer$
IF LOF(F2) <> NewFileLen THEN
 Msg$ = "ERROR: Incorrect file size"
ELSE
 Msg$ = "File decompressed OK"
END IF
CLOSE #F1, #F2
END SUB

