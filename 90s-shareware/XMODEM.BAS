DECLARE FUNCTION IsCarrier% ()

'  +-------------------------------------------------------------------+
'  |                                                                   |
'  |   XMODEM.BAS                                Author: Bryan Leggo   |
'  |                                                                   |
'  |   Original XModem, XModem-CRC, and XModem-1K Transfer Protocols   |
'  |                                                                   |
'  |   Uses standard QuickLibrary for "FileExists" function. Use /L    |
'  |   for QB.QLB in environment or the .LIB while compiling.          |
'  |                                                                   |
'  +-------------------------------------------------------------------+

DECLARE FUNCTION CalcCheckSum% (Blk$)
DECLARE FUNCTION CalcCRC& (X$, CRCHigh%, CRCLow%)
DECLARE FUNCTION FileExists% (T$, Attrib%)
DECLARE FUNCTION NoCarrier% ()
DECLARE FUNCTION TimedGet$ (Limit&, Cancelled%)
DECLARE FUNCTION Warn$ (Message$)
DECLARE SUB ClrLn (Ln%, Spaces%)
DECLARE SUB OpenCom (ComChan%, Param$)
DECLARE SUB PurgeBuffer ()
DECLARE SUB ReceiveXModem (BlkSize%, F$)
DECLARE SUB SendXModem (BlkSize%, F$)
DECLARE SUB SimpleTerminal ()
DECLARE SUB Txt (Side$, T$)
DECLARE SUB Transfer (WhichWay$)
DECLARE SUB VidBar (BarOn%, Col%, Length%)

TYPE RegTypeX                                   'Register Type for
   ax    AS INTEGER                             ' Interrupt Calls
   bx    AS INTEGER
   cx    AS INTEGER                             'AX = AH AL
   dx    AS INTEGER                             'BX = BH BL, etc.
   bp    AS INTEGER
   si    AS INTEGER
   di    AS INTEGER
   Flags AS INTEGER
   ds    AS INTEGER
   es    AS INTEGER
END TYPE

CONST TRUE = -1, FALSE = 0                      'Boolean Constants

DEFINT A-Z

DIM SHARED CR$, LF$, BS$, Escape$               'Global String Constants
DIM SHARED Lft$, Rght$, Up$, Down$
DIM SHARED PgUp$, PgDown$
DIM SHARED XOn$, XOff$
DIM SHARED Ack$, Nak$, Soh$, Stx$, Eot$, Can$   'Protocol Pseudo-Constants
DIM SHARED ComBase, Baud&
DIM SHARED Txt1st, TxtMax                       'Used by Txt Sub
DIM SHARED Kolor, BGKolor                       'Screen Colors
DIM SHARED ErrCode, ErrCt                       'Error Number & Count

'===========================================================================
'                  I N I T I A L I Z E     V A R I A B L E S
'===========================================================================

CR$ = CHR$(13): LF$ = CHR$(10): BS$ = CHR$(8): Escape$ = CHR$(27)
Up$ = CHR$(0) + CHR$(72): Down$ = CHR$(0) + CHR$(80)
Lft$ = CHR$(0) + CHR$(75): Rght$ = CHR$(0) + CHR$(77)
PgUp$ = CHR$(0) + CHR$(73): PgDown$ = CHR$(0) + CHR$(81)
XOn$ = CHR$(17): XOff$ = CHR$(19): Ack$ = CHR$(6): Nak$ = CHR$(21)
Soh$ = CHR$(1): Stx$ = CHR$(2): Eot$ = CHR$(4): Can$ = CHR$(24)

Baud& = 2400                                       'Set the BaudRate
Param$ = STR$(Baud&) + ",N,8,1,RS,OP,CD0,DS0"      ' and Com Parameters


'===========================================================================
'                         M A I N     P R O G R A M
'===========================================================================

OpenCom 1, Param$                               'Open Port 1 with Parameters$
SimpleTerminal                                  'Terminal Mode
END


'***************************************************************************
'                        E R R O R     H A N D L E R
'***************************************************************************

Handler:
ErrCode = ERR                               'Copy Err # to Global Var
ErrCt = ErrCt + 1                           'Try Statement Causing the Error
IF ErrCt MOD 3 = 0 THEN                     ' Twice Before Giving Up and
   RESUME NEXT: ErrCt = 0                   ' Going to the Next Statement
ELSE
   RESUME
END IF

FUNCTION CalcCheckSum (Blk$)                'Returns CheckSum on Blk$

C& = 0                                      'Use Long Int to Avoid Overflow
FOR Q = 1 TO LEN(Blk$)
   C& = C& + ASC(MID$(Blk$, Q, 1))          'Add to Add Bits of Each Byte
NEXT Q
C& = (C& AND 255)                           'AND Out Hi Byte Bits
CalcCheckSum = C&
END FUNCTION

FUNCTION CalcCRC& (B$, CRCHigh%, CRCLow%)      'Calculates CRC for Each Block

DIM Power(0 TO 7)                              'For the 8 Powers of 2
DIM CRC AS LONG

FOR I = 0 TO 7                                 'Calculate Once Per Block to
   Power(I) = 2 ^ I                            ' Increase Speed Within FOR J
NEXT I                                         ' Loop
CRC = 0                                        'Reset for Each Text Block
FOR I = 1 TO LEN(B$)                           'Calculate for Length of Block
   ByteVal = ASC(MID$(B$, I, 1))
   FOR J = 7 TO 0 STEP -1
      TestBit = ((CRC AND 32768) = 32768) XOR ((ByteVal AND Power(J)) = Power(JCRC = ((CRC AND 32767&) * 2&)))
      IF TestBit THEN CRC = CRC XOR &H1021&     ' <-- This for 16 Bit CRC
      '*** IF TestBit THEN CRC = CRC XOR &H8005&     ' <-- This for 32 Bit CRC
   NEXT J
NEXT I
CRCHigh% = (CRC \ 256)                          'Break Word Down into Bytes
CRCLow% = (CRC MOD 256)                         ' for Comparison Later
ComputeCRC& = CRC                               'Return the Word Value
END FUNCTION

REM $DYNAMIC
SUB ClrLn (Ln, Spaces)                       'Clears Line from Left Side
LOCATE Ln, 1, 0: PRINT SPACE$(Spaces);       ' for Number of Designated
LOCATE Ln, 1                                 ' Spaces. Returns Cursor to
END SUB                                      ' to First Column Afterwards

FUNCTION FileExists (T$, Attrib)     'True if File T$ Exists else False

DIM F AS STRING * 64
DIM Inx AS RegTypeX
DIM Outx AS RegTypeX

Inx.ax = &H2F00                      'Function 2FH Gets the DTA Address in
CALL INTERRUPTX(&H21, Inx, Outx)     ' ES:BX
DTASeg = Outx.es
DTAAddr = Outx.bx
F$ = LTRIM$(RTRIM$(UCASE$(T$))) + CHR$(0)

Inx.ds = VARSEG(F$)                  'Pass the File Specs by Giving Address
Inx.dx = VARPTR(F$)                  ' of String that Contains Specification
Inx.ax = &H4E00                      'Function 4EH for Find 1st Matching Entry
Inx.cx = Attrib                      'CX = Directory Attribute (0=Files Only)
CALL INTERRUPTX(&H21, Inx, Outx)     'Use Interrupt 21H
IF Outx.Flags AND 1 THEN
   FileExists = FALSE
ELSE
   FileExists = TRUE
END IF

END FUNCTION

FUNCTION IsCarrier

DEF SEG = &H40
IF (INP(ComBase + 6) AND 128) = 0 THEN IsCarrier = TRUE ELSE IsCarrier = FALSE
DEF SEG

END FUNCTION

REM $STATIC
SUB OpenCom (ComChan, Param$)

CLOSE 1
SELECT CASE ComChan                   'Will Require Swapping at &H400, &H402
CASE 1                                ' Order to Support Com 3 and 4
   ComBase = &H3F8
   OPEN "R", 1, "COM1:" + Param$
CASE 2
   ComBase = &H2F8
   OPEN "R", 1, "COM2:" + Param$
END SELECT

END SUB

SUB PurgeBuffer                                    'Clear Comm Line of Chars

Mark& = TIMER                                      'Mark Starting Time
DO
   IF NOT EOF(1) THEN                              'Get More Chars While Some
      JunkIt$ = INPUT$(1, 1): Mark& = TIMER        ' In the Buffer and it's
   END IF                                          ' Less Than 1/2 Second
LOOP UNTIL EOF(1) AND (ABS(TIMER - Mark&) > .5)    ' Since Last Char Gotten
END SUB

SUB ReceiveXModem (BlkSize, F$)                 '(Block Size and Filename)
DIM B$(1 TO 4)                                  'Temp Storage of Block Bytes

CLOSE 9: OPEN "O", #9, F$                       'Save File to Channel #9
PRINT #1, XOff$; XOn$;
Cancels$ = STRING$(3, Can$)
Underway = FALSE                                'True After 1st Pkt Confirmed
Blocks = 1                                      'Block/Pkt Counter (1-Max)
BlkNum = 1                                      'Packet Block Number (1-255)
Bad = 0                                         'Bad Packets/Error Count
BCt = 0                                         'RAM Block Ptr for B$()
PurgeBuffer                                     'Get Rid of Extra Chars
CrcMode = TRUE: PktSize = BlkSize + 5           'Try CRC Mode First
PRINT #1, "C";                                  'Send "C" to Signal It


GetPacket:                                      'Get Packet of Bytes
'IF NoCarrier THEN ErrType = 13: GOTO ShowErr    'Are We Still Online?
Pkt$ = ""
FOR Tries = 1 TO 10                             'Allow 10 Tries
   W$ = TimedGet$(8, Cancelled)                 'Get Response/1st Char of Pkt
   IF Cancelled THEN ErrType = 11: GOTO ShowErr 'Quit If User Cancelled
   SELECT CASE W$                               '1st Byte Is:
   CASE Soh$: BlkSize = 128: EXIT FOR           'Soh = 128 Byte Block Coming
   CASE Stx$: BlkSize = 1024: EXIT FOR          'Stx = 1K Block Coming
   CASE Eot$: GOTO ReceptionDone                'End of Xmission. Close Out.
   CASE Can$: EXIT FOR                          'Cancelled by Sender
   CASE ""                                      'No Char In Means Timed Out
      Bad = Bad + 1: LOCATE 7, 40
      PRINT "Tries:"; Tries; TAB(80);
   CASE ELSE                                    'Else Didn't Get An Expected
      PurgeBuffer                               ' Response So Purge Characters
   END SELECT
   IF NOT Underway THEN                         'Handshaking Not Complete Yet
      IF Tries < 4 THEN                         ' So Send Out Init Char Again
         CrcMode = TRUE: PRINT #1, "C";         ' Send a "C" to Start CRC or
      ELSE                                      ' a <Nak> for Standard Mode
         CrcMode = FALSE: PRINT #1, Nak$;
      END IF
   END IF
   IF Bad >= 10 THEN                            'Have Reached the Max of 10
      ErrType = 14: PurgeBuffer: GOTO ShowErr   ' Errors from TimeOuts or
   END IF                                       ' Bad Packets so Abort
NEXT Tries
IF CrcMode THEN                                 'Blk Size Determined by <Soh>
   PktSize = BlkSize + 5                        ' or <Stx>, PacketSize by
ELSE                                            ' BlockSize and Type of Check
   PktSize = BlkSize + 4                        ' Used (1 Extra Byte for CRC)
END IF
Pkt$ = W$                                       'We've Got the First Byte
WHILE LEN(Pkt$) <= PktSize - 1                  'Now Get Rest of Packet
   W$ = TimedGet$(4, Cancelled)
   IF Cancelled THEN ErrType = 11: GOTO ShowErr
   IF LEN(W$) THEN                              'If There is a Byte then Add
      Pkt$ = Pkt$ + W$                          ' it to the Packet
      IF LEFT$(Pkt$, 3) = Cancels$ THEN         'Packet Starting with Three
         PRINT #1, Cancels$; Ack$;              ' <Can>s Is a Cancellation So
         ErrType = 12: GOTO ShowErr             ' <Ack>nowledge And Abort
      END IF
   ELSE                                         'Else Null Means We Timed Out
      Bad = Bad + 1
      LOCATE 7, 40: PRINT TAB(80);
      LOCATE 7, 40: PRINT "Character Timeout. Errors:"; Bad;
      GOTO CheckPacket
   END IF
WEND

CheckPacket:                                              'Check Packet Errors
IF LEN(Pkt$) = PktSize THEN                               'If Packet Right Size
  IF BlkNum = ASC(MID$(Pkt$, 2, 1)) + 1 AND (BlkNum XOR 255) = ASC(MID$(Pkt$, ErrType = 7)) THEN GOTO ShowErr                          'Repeated Block #
    ELSEIF BlkNum <> ASC(MID$(Pkt$, 2, 1)) THEN            'Block Counts Don't
      ErrType = 5: GOTO ShowErr                           ' Match. Try New Pkt
    ELSEIF (BlkNum XOR 255) <> ASC(MID$(Pkt$, 3, 1)) THEN  'Block Ct Complement
      ErrType = 6: GOTO ShowErr                           ' Mismatch. Try New
  END IF                                                 ' Packet
  Blk$ = MID$(Pkt$, 4, BlkSize)                          'Else Copy the Block
  IF CrcMode THEN                                        'Do CheckSum or CRC
    J& = CalcCRC&(Blk$, Hi, Low)
    IF Hi <> ASC(MID$(Pkt$, PktSize - 1, 1)) THEN ErrType = 4: GOTO ShowErr
    IF Low <> ASC(MID$(Pkt$, PktSize, 1)) THEN ErrType = 4: GOTO ShowErr
  ELSE
    ChkSum = CalcCheckSum(Blk$)
    IF ChkSum <> ASC(MID$(Pkt$, PktSize, 1)) THEN ErrType = 3: GOTO ShowErr
  END IF
  GOSUB ShowProgress                             'Displays Xfer Status
  BlkNum = 255 AND (BlkNum + 1)                  'Success Thru All CheckPts
  Blocks = Blocks + 1: Bad = 0                   ' so Increment Block Cts
  Underway = TRUE                                ' Mark Handshake Completed
  IF BlkSize = 1024 THEN                         'For Xmodem-1k Write to Disk
    PRINT #9, Blk$;                             ' Immediately
  ELSE
    BCt = BCt + 1: B$(BCt) = Blk$               'Else Save 4 Blocks In RAM
    IF BCt = 4 THEN                             ' Write them to Disk Every
      PRINT #9, B$(1); B$(2); B$(3); B$(4);    ' 4th, i.e. After 512 Bytes
      BCt = 0                                  ' Reset RAM Block Index
    END IF
  END IF                                         'Acknowledge Good Block Read
  PRINT #1, Ack$;                                ' And Go to Get Next Packet
  GOTO GetPacket
IF LEN(Pkt$) < PktSize THEN ErrType = 1: GOTO ShowErr                      'Err and Get New Packet
IF LEN(Pkt$) > PktSize THEN
  ErrType = 2: GOTO ShowErr                      ' And Get New Packet
ELSE                                              'Else an Unexpected Error
  ErrType = 8: GOTO ShowErr                      ' So Warn and Try for New
END IF                                            ' Packet
                                                  ' Last 2 Should NOT Occur

ReceptionDone:
IF BCt <> 0 THEN                                  'If Some Bytes Still In
   FOR I = 1 TO BCt: PRINT #9, B$(I); : NEXT I    ' Memory Then Write Them
END IF                                            ' to Disk
CLOSE 9: PRINT #1, Ack$;                          'Xmit Complete so Close
EXIT SUB                                          ' File and Send Final Ack


'---------------------------------------------------------------------------

ShowErr:
Response$ = Nak$                                  'Send Nak After Most Errors
SELECT CASE ErrType
CASE 1: ErM$ = "Short Block in #" + STR$(Blocks)
CASE 2: ErM$ = "Long Block in #" + STR$(Blocks)
CASE 3: ErM$ = "Checksum Error in #" + STR$(Blocks)
CASE 4: ErM$ = "CRC Error in #" + STR$(Blocks)
CASE 5: ErM$ = "Block # Error in #" + STR$(Blocks)
CASE 6: ErM$ = "Complement Error in #" + STR$(Blocks)
CASE 7: ErM$ = "Block # Repeated in #" + STR$(Blocks - 1): Response$ = Ack$
CASE 8: ErM$ = "Unexpected Error!"
CASE 9:
CASE 10: ErM$ = "Transfer Cancelled"
CASE 11: ErM$ = "Transfer Aborted by User"
CASE 12: ErM$ = "Transfer Aborted by Sender"
CASE 13: ErM$ = "No Carrier"
CASE 14: ErM$ = "Maximum Errors. Transfer Aborted."
END SELECT
LOCATE 7, 40: PRINT TAB(80);                      'Show the ErrorMsg
LOCATE 7, 40: PRINT ErM$;
IF ErrType < 10 THEN                              'ErrType < 10 is Recoverable
   Bad = Bad + 1                                  ' Count One More Error
   PRINT #1, Response$;                           ' Respond Nak (or Ack) and
   Pkt$ = "": GOTO GetPacket                      ' Go to Get Packet Again
ELSE
   J$ = Warn$(ErM$)                               'Notify User of Cancel
   SLEEP 2: PurgeBuffer                           'Get Rid of Remaining Pkt
   PRINT #1, STRING$(5, 24); STRING$(5, 8);       'Send 5 <Can>s & 5 <BS>s
   CLOSE 9: KILL F$                               'ErrType >= 10 is Fatal so
   EXIT SUB                                       ' Kill Off File and Quit
END IF

'---------------------------------------------------------------------------

ShowProgress:                                     'Show Byte Counts & Bar
KBytes = INT(Blocks * (BlkSize / 1024))
LOCATE 5, 40: PRINT "Received #"; Blocks; TAB(60); KBytes; "K Bytes";
IF BarLength = 0 THEN
   LOCATE 9: VidBar FALSE, 1, 80
   FOR K = 1 TO 9
      LOCATE 10, K * 8 - 1
      PRINT LTRIM$(STR$(100 * (KBytes \ 100) + (K * 10))); "K ";
   NEXT K
END IF
BarLength = INT(80 * ((KBytes MOD 100) / 100))
LOCATE 9: VidBar TRUE, 1, BarLength
RETURN



' Block refers to Block of Text from File (128 bytes, 1024 for Xmodem-1K)
' Packet Refers to Block + Extra "Control" Characters, i.e. :

'       XModem: SOH + BlockCt + Complement BlockCt + Block + CheckSum
'    XModemCRC: SOH + BlockCt + Complement BlockCt + Block + CRC (Hi & Low)
'    XModem-1K: STX + BlockCt + Complement BlockCt + Block + CheckSum
' XModemCRC-1K: STX + BlockCt + Complement BlockCt + Block + CRC (Hi & Low)

END SUB

SUB SendXModem (BlkSize, F$)                              '(Bytes, FileName$)

CLOSE 9: OPEN F$ FOR RANDOM AS 9 LEN = 128
FIELD #9, 128 AS BlkOf128$
FiLen& = LOF(9): TtlBlocks = FiLen& \ BlkSize             'Get File Length
IF FiLen& MOD BlkSize > 0 THEN TtlBlocks = TtlBlocks + 1  ' in Bytes & Blocks
LOCATE 3, 40: PRINT "Blocks:"; TtlBlocks; TAB(60);
Seconds = ((TtlBlocks * 6) + FiLen&) \ (Baud& \ 16)
Est$ = STR$(Seconds \ 3600) + STR$(Seconds \ 60) + STR$(Seconds MOD 60)
FOR I = 2 TO LEN(Est$)
   IF MID$(Est$, I, 1) = " " THEN MID$(Est$, I, 1) = ":"
NEXT I
PRINT "Est. Time:"; Est$;

ErM$ = "Transfer Aborted"                        'Generic Msg In Case of Error
Blocks = 0: BlkNum = 0                           'Blocks (1-?), BlkNum (1-255)
EoFile = FALSE: W$ = ""                          'Initialize Block, Byte,
Ct& = 0                                          'To Count Bytes Used & Sent
Bad = 0                                          'Error Counter
PurgeBuffer                                      'Clear the Com Line

DO                                               'Shake Hands with Receiver
   W$ = TimedGet$(20, Cancelled)                 'Get Initial Character

   IF Cancelled THEN GOTO AbortSend              'If User Pressed <Esc>
   SELECT CASE W$
   CASE Can$: GOTO AbortSend                     'Receiver is Cancelling
   CASE Nak$: CrcMode = FALSE: EXIT DO           'Nak for Standard XModem
   CASE "C": CrcMode = TRUE: EXIT DO             'C Indicates XModem-CRC
   END SELECT                                    'Begin After <Nak> or C
LOOP

MakePacket:
IF NoCarrier THEN                                    'Still Online?
   ErM$ = "No Carrier!": GOTO AbortSend
END IF
W$ = "": Blocks = Blocks + 1: Bad = 0                'Advance Block Counter
IF (BlkSize = 1024) AND ((Ct& + 896) > FiLen&) THEN  'If Doing 1k and at End
   BlkSize = 128                                     ' of File Then Shorten
END IF                                               ' to Avoid Extra Nulls
IF BlkSize = 128 THEN MaxBCt = 1 ELSE MaxBCt = 8     '8 Groups of 128 = 1024
BCt = 0: Blk$ = ""                                   'Build the Block$
DO
   Ct& = Ct& + 128: GET #9                           'Advance File Ptr, Get Fro
   BCt = BCt + 1: Blk$ = Blk$ + BlkOf128$
   IF Ct& >= FiLen& THEN                             'If It's Last Block We're
      EoFile = TRUE                                  ' About Done Xmitting
      Pad = Ct& - FiLen&                             ' Pad the End with Nulls
      MID$(Blk$, BlkSize - Pad, Pad) = STRING$(Pad, CHR$(0))
      EXIT DO
   END IF
LOOP UNTIL BCt = MaxBCt                              'Done After 1 (8 for 1k)
BlkNum = (255 AND Blocks)                            ' So Assemble the Packet
Pkt$ = Soh$ + CHR$(BlkNum) + CHR$(BlkNum XOR 255) + Blk$
IF BlkSize = 1024 THEN MID$(Pkt$, 1, 1) = Stx$       '1st Byte is Stx for 1K
IF CrcMode THEN                                      'End of Packet Varies
   J& = CalcCRC&(Blk$, Hi%, Low%)                    ' with Check Method Used
   Pkt$ = Pkt$ + CHR$(Hi%) + CHR$(Low%)              ' 2 Bytes for CRC
ELSE
   ChkSum = CalcCheckSum(Blk$)                       ' 1 Byte for CheckSum
   Pkt$ = Pkt$ + CHR$(ChkSum)
END IF

SendPacket:
PRINT #1, Pkt$;                                      'Send the Packet and
LOCATE 5, 40: PRINT "Sending #"; Blocks;             ' Show Progress on Screen
P = INT((Blocks / TtlBlocks) * 100)                  'Calculate Percentage
IF P <= 100 THEN                                     'Percentage Can Be > 100
   LOCATE 5, 60: PRINT P; "% Complete": LOCATE 9     ' On Last Blocks of 1k
   VidBar TRUE, 1, INT((Blocks / TtlBlocks) * 80)    ' Mode Since Last 1024 is
END IF                                               ' Sent in 128 Byte Blocks

DO                                                   'Packet Has Been Sent so
   W$ = TimedGet$(10, Cancelled)                     'Get Response/Confirm
   IF Cancelled THEN GOTO AbortSend                  'Quit If User <Esc>aped
   SELECT CASE W$                                    'Interpret Response
   CASE Ack$                                         'Block Acknowledged So
      Bad = 0                                        ' Send Next Packet If
      IF EoFile THEN EXIT DO ELSE GOTO MakePacket    ' More Data
   CASE ELSE                                         'Else
      Bad = Bad + 1                                  ' Count 1 More Error
      IF Bad > 9 THEN GOTO AbortSend                 ' Abort If Over Limit
      IF W$ = Can$ THEN                              'If a <Can> Then Look
         FOR I = 1 TO 2                              ' For at Least 2 More to
            W$ = W$ + TimedGet$(2, Cancelled)        ' Be Sure (Or User Esc)
            IF Cancelled THEN GOTO AbortSend
            IF W$ = STRING$(3, Can$) THEN GOTO AbortSend
         NEXT I
         GOTO SendPacket
      ELSE
         PurgeBuffer                                 'Any Other Char Is an
         GOTO SendPacket                             ' Error So ReSend Packet
      END IF                                         ' & Look for <Ack> Again
   END SELECT
LOOP

ConcludeSend:
ErM$ = "End of Transmission": GOSUB ShowStatus       'Proper End of Transmit
CLOSE 9: PRINT #1, Eot$;                             'Close File, Send the EOT
I$ = TimedGet$(10, Cancelled)                        'Get Final Char
IF I$ = Ack$ THEN                                    'Should Be an <Ack> but
   ErM$ = "Acknowledged": GOSUB ShowStatus
ELSEIF Cancelled THEN                                'Allow User to Cancel
   EXIT SUB
ELSE                                                 'If Not an <Ack> Resend
   GOTO ConcludeSend                                 ' <Eot> and Try Again
END IF
EXIT SUB

'---------------------------------------------------------------------------

AbortSend:
J$ = Warn$(ErM$)                                 'Show Error Status
CLOSE 9                                          'Close File
PRINT #1, STRING$(5, Can$); STRING$(5, BS$);     'Send Cancel to Receiver
EXIT SUB

'---------------------------------------------------------------------------

ShowStatus:
LOCATE 7, 40: PRINT ErM$; TAB(80);               'Show the Status or ErrorMsg
RETURN

END SUB

SUB SimpleTerminal
ON ERROR GOTO Handler
FF$ = CHR$(12): Hm$ = CHR$(11)

CLS : GOSUB InfoBar
PRINT #1, "AT S0=1"                       'Send Modem Initialization String
DO
   Out$ = INKEY$                          'Look for Key Press
   'IF LEN(Out$) THEN                      'If There IS One then Select
      SELECT CASE Out$
      CASE PgUp$, PgDown$                 ' to Upload or Download
         Transfer Out$: GOSUB InfoBar
      CASE Escape$                        ' Escape to End Program
         EXIT DO
      CASE CHR$(0) + CHR$(59)
         PRINT #1, "atdt 626-9456"
      CASE ELSE
         PRINT #1, Out$;                  ' Else Send the Character Verbatim
      END SELECT
   'END IF
   IF LOC(1) THEN                         'Is there Incoming Data from Com?
      DO                                  ' If So then Get Chars Until No
         ComChr$ = INPUT$(1, 1)           ' More or End of a Line <LF>
         SELECT CASE ComChr$
         CASE BS$: ComChr$ = CHR$(29)     'Replace BackSpaces with CHR$(29)
         CASE FF$, Hm$: ComChr$ = ""      'Filter these Out
         CASE LF$: ComChr$ = "": EXIT DO  'Ignore Linefeeds But Exit Do Loop
         END SELECT
         PRINT ComChr$;                   'Print the Char Received On Screen
      LOOP UNTIL LOC(1) = 0               'No More Com Waiting
   END IF
LOOP
EXIT SUB

'---------------------------------------------------------------------------

InfoBar:
CLS
LOCATE 24, 1: COLOR 0, 7
PRINT " <PgUp> to Upload,        <PgDown> to Download,         <Escape> to End Program ": COLOR 7, 0: LOCATE 24, 1
RETURN

END SUB

FUNCTION TimedGet$ (Limit&, Cancelled)            'Timed Routine to Get One
                                                  'Character from Comm Port
Mark& = TIMER                                     'Mark Starting Time
DO
   IF NOT EOF(1) THEN                             'If Chars Waiting Then
      TimedGet$ = INPUT$(1, 1): EXIT FUNCTION     ' Return 1 Character
   END IF
   IF INKEY$ = Escape$ THEN                       'User Can Press <Esc> to
      Cancelled = TRUE: EXIT FUNCTION             ' Quit
   END IF
LOOP WHILE ABS(TIMER - Mark&) < Limit&            'Wait Up Until Past Limit
TimedGet$ = ""                                    'Return "" If Timing Out

END FUNCTION

REM $DYNAMIC
SUB Transfer (WhichWay$)                  'WhichWay = PgUp (U/L), PgDn (D/L)
ON ERROR GOTO Handler

NumProtos = 4                             'Number of Protocols Here
SendDir$ = ""                             'Define Directories Where Files Will
RecvDir$ = ""                             ' Be DownLoaded To or Uploaded From
SendExternal$ = ""                        'DOS Command Line Used to Execute
RecvExternal$ = ""                        ' External Protocol (~ for Filename)
Kolor = 0: BGKolor = 7                    'Transfer Area in Reverse Video for
COLOR Kolor, BGKolor                      ' Contrast
VIEW PRINT 1 TO 11: CLS 2: VIEW PRINT     'Clear Top 11 Lines
LOCATE 11, 1: PRINT STRING$(80, "#");

IF WhichWay$ = PgUp$ THEN                 'Determine if Sending or Receiving
   Way$ = "Sending": Sending = TRUE       ' From Key Pressed
ELSE
   Way$ = "Receiving": Sending = FALSE
END IF
DO
   ClrLn 9, 80: PRINT "File You Are "; Way$; ": ";
   F$ = "": LINE INPUT F$
   IF F$ = "" THEN GOTO ExitTransfer
   F$ = UCASE$(F$)
   IF Sending THEN
      IF LEN(SendDir$) THEN
         IF INSTR(F$, ":") = 0 THEN F$ = SendDir$ + "\" + F$
      END IF
      IF FileExists(F$, 0) THEN Ok = TRUE ELSE J$ = Warn$("File Not Found")
   ELSE
      IF LEN(ReceiveDir$) THEN
         IF INSTR(F$, ":") = 0 THEN F$ = ReceiveDir$ + "\" + F$
      END IF
      IF FileExists(F$, 0) THEN
         ClrLn 9, 80
         PRINT F$; " Already Exists! Overwrite it? (Y/N)? ";
         DO: B$ = UCASE$(INKEY$)
         LOOP UNTIL LEN(B$) AND INSTR("YN", B$)
         IF B$ = "Y" THEN Ok = TRUE
      ELSE
         ErrCode = 0: F = FREEFILE
         OPEN "O", F, F$
         IF ErrCode THEN J$ = Warn$("Bad Path/Filename?") ELSE Ok = TRUE
         CLOSE F
      END IF
   END IF
LOOP UNTIL Ok

Txt1st = 1: TxtMax = 30                            'And Draw a Box Around
LOCATE 1, 1
PRINT TAB(40); "Choose a Protocol"; TAB(80);
Txt "T", ""
Txt "C", "       XModem       "
Txt "C", " XModem-1k (YModem) "
Txt "C", " External Protocol  "
Txt "C", "       Cancel       "
Txt "B", ""
R = 1: C = 0
DO
   LOCATE R + 1, 2, 0
   VidBar TRUE, 2, 30
   DO: C$ = INKEY$: LOOP UNTIL LEN(C$)
   VidBar FALSE, 2, 30
   SELECT CASE C$                                      'Based on Terminator:
   CASE Up$: R = R - 1: IF R < 1 THEN R = NumProtos    ' Go to Line Above
   CASE Down$: R = R + 1: IF R > NumProtos THEN R = 1  ' or Line Below
   CASE CR$: EXIT DO
   CASE Escape$: EXIT DO
   END SELECT
LOOP
IF C$ = Escape$ THEN GOTO ExitTransfer                 'Cancelled by User
VidBar TRUE, 2, 30
LOCATE 9, 1: PRINT "+--+---+---+---+---+---+---+---+---+---|---+---+---+---+---+---+---+---+---+---+"
LOCATE 1, 3: PRINT " Press <Escape> to Cancel "
LOCATE 1, 40: PRINT Way$; ": "; UCASE$(F$); TAB(80);
IF Sending THEN
   LOCATE 10, 1: PRINT "0%    10%     20%     30%     40%     50%     60%     70%     80%     90%   100%"
   SELECT CASE R
   CASE 1: SendXModem 128, F$
   CASE 2: SendXModem 1024, F$
   CASE 3: Ext$ = SendExternal$: GOSUB InsertFileName: SHELL Ext$
   CASE 4: GOTO ExitTransfer
   END SELECT
ELSE
   SELECT CASE R
   CASE 1: ReceiveXModem 128, F$
   CASE 2: ReceiveXModem 1024, F$
   CASE 3: Ext$ = RecvExternal$: GOSUB InsertFileName: SHELL Ext$
   CASE 4: GOTO ExitTransfer
   END SELECT
END IF
'PLAY "T90 O3 L32 CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBC"     'All Done Warning Sound

ExitTransfer:
COLOR 7, 0                                            'Back to White on Black
VIEW PRINT 1 TO 11: CLS 2: VIEW PRINT                 'Clear Top 11 Lines
VIEW PRINT 1 TO 24: LOCATE 24, 1, 1
EXIT SUB

'----------------------------------------------------------------------------

InsertFileName:                    'Substitute FileName for ~ in Strings Used
P = INSTR(Ext$, "~")               ' to Call External Protocol (Send or Recv)
IF P > 1 THEN
   Ext$ = LEFT$(Ext$, P - 1) + F$ + RIGHT$(Ext$, LEN(Ext$) - P)
END IF
RETURN

END SUB

REM $STATIC
SUB Txt (Side$, Text$)                  'Put 1 Line of Text w/ Box Delimiters

IF LEN(Text$) > TxtMax THEN Text$ = LEFT$(Text$, TxtMax - 2)
SpaceLeft = (TxtMax - LEN(Text$)) \ 2
LOCATE , Txt1st
IF LEN(Text$) MOD 2 = 1 THEN Text$ = Text$ + " "
IF Side$ = LCASE$(Side$) THEN Shadow$ = ""
SELECT CASE UCASE$(Side$)
CASE "T"
   Text$ = "+" + STRING$(TxtMax, "-") + "+"                    'Top Border
   C = (TxtMax \ 2) - (LEN(T$) \ 2)
   MID$(Text$, C) = T$
CASE "B"
   Text$ = "+" + STRING$(TxtMax, "-") + "+"                    'Bottom Border
   C = (TxtMax \ 2) - (LEN(T$) \ 2)
   MID$(Text$, C) = T$
CASE "C"
   Text$ = "|" + STRING$(SpaceLeft, " ") + Text$ + STRING$(SpaceLeft, " ") + "|"
CASE "R"
   Text$ = "|" + STRING$(2 * SpaceLeft, " ") + Text$ + "|"     'Right-Justify
CASE "L"
   Text$ = "|" + Text$ + STRING$(2 * SpaceLeft, " ") + "|"     'Left-Justify
END SELECT

PRINT Text$; Shadow$;                                   'Print Text, DeLimits
IF CSRLIN < 24 THEN PRINT                               'Go to Next Line
IF (Side$ = "B") AND LEN(Shadow$) THEN
   IF CSRLIN = 24 THEN LOCATE 25
   LOCATE , Txt1st
   PRINT " "; STRING$(TxtMax + 1, Shadow$); Shadow$;
   Shadow$ = ""
END IF
END SUB

SUB VidBar (BarOn, Col, Length)

113 LOCATE , Col                        'Position at Paramter Column
IF BarOn THEN                           'IF Hilighting (BarOn = True) then
   COLOR BGKolor, Kolor                 ' Use the BGKolor in the FG
   FOR J = Col TO Col + Length - 1      'Across the Screen for the "Length"
      PRINT CHR$(SCREEN(CSRLIN, J));    ' Re-Print the Char That is Already
   NEXT J                               ' There in It's New Colors
ELSE
   COLOR Kolor, BGKolor                 'ELSE De-HiLiting So Return Colors
   FOR J = Col TO Col + Length - 1      ' to Normal and Re-Print each Char
      PRINT CHR$(SCREEN(CSRLIN, J));    ' in the Row with the Regular Video
   NEXT J
END IF
LOCATE , Col                            'Return to 1st Column
COLOR Kolor, BGKolor                    ' and Normal Colors
END SUB

FUNCTION Warn$ (Warning$)
LOCATE 1, 40: COLOR 20
PRINT " "; Warning$; TAB(80);
COLOR Kolor, BGKolor
'BEEP: BEEP
END FUNCTION

