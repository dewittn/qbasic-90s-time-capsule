'----- Begin EMM Handler -----
'Program to store data in Expanded memory with QuickBasic.
'Rewritten from EMM Demo by Hauke Daempfling
'Hauke Daempfling - hcd@berlin.snafu.de
'I took this program I found that showed you how to use the EMM
'  and rewrote it so that it now has subs and funcs that you can
'  call to store/get strings from the EMM.
'It looks pretty messy but it works fine :)
'*-*-*-*-*
'MsgLen referrs to how long a message (string) stored in the EMS should be.
CONST MsgLen = 16           'Message length
'NumMsgs is how many messages you can store.
CONST NumMsgs = 5000        'Messages to allocate
'To see how many bytes you're allocating, just do MsgLen * NumMsgs.
'(like: 16 * 5000 = 80000 = 80KB)
'The ratio of NumMsgs/MsgLen should be changed according whatever type
'of program you're writing. For example, if you're writing a text editor,
'you should do MsgLen = Max number of chars in a line and NumMsgs = max.
'number of lines in memory.
'*-*-*-*-*
DECLARE SUB StoreMsg (what$, I%)
DECLARE SUB GetPages ()
DECLARE SUB ReleaseEMM ()
DECLARE FUNCTION GetMsg$ (I%)
DECLARE SUB CallEmm (EmmFuncNbr%)
DECLARE FUNCTION EmmDriverExists2% ()
DECLARE FUNCTION EmmDriverExists1% ()
DECLARE SUB EmmPrintStatus (Status%)
DECLARE FUNCTION FmtPointer$ (P AS ANY)
DECLARE FUNCTION Hi% (Operand%)
DECLARE FUNCTION Lo% (Operand%)
'If you use the PDS product, change the next line to include
'the QBX.BI include file instead of the QB.BI file
'$INCLUDE: 'QB.BI'
DEFINT A-Z
CONST EmsInt = &H67         'EMS interrupt number
CONST IoCtlFunc = &H44      'IOCtl DOS Function number
CONST PageLen = 16384       'Length of memory page
CONST MsgsPerPage = PageLen \ MsgLen
'EMM functions:
CONST GetStatus = &H40
CONST GetPageFrameAddr = &H41
CONST GetUnallocPages = &H42
CONST GetEmmVersion = &H46
CONST AllocatePages = &H43
CONST MapHandlePage = &H44
CONST DeallocatePages = &H45
TYPE address
    Segment AS LONG
    Offset AS LONG
END TYPE
DIM SHARED P0 AS address             'Pointer to physical page 1
DIM SHARED P1 AS address             'Pointer to physical page 2
DIM SHARED P2 AS address             'Pointer to physical page 3
DIM SHARED P3 AS address             'Pointer to physical page 4
DIM SHARED MsgBuf AS address         'Pointer into mapped memory
DIM SHARED Buff AS STRING * MsgLen   'Buffer for message to store in EM
DIM SHARED EmmRegs AS RegType        'Registers for interrupt calls
DIM SHARED Page AS LONG              'Page frame address
DIM SHARED Index AS LONG             'Index into page frame
DIM SHARED StrNum AS STRING * 6      'Holds record # for EMM msg
DIM SHARED EmmHandle AS INTEGER      'Handle for the EMM

'Test for the existence of the EMM driver
IF EmmDriverExists1% = 0 THEN
  PRINT "Error - Couldn't find EMM driver"
  SYSTEM
END IF
IF EmmDriverExists2% = 0 THEN
  PRINT "Error - Couldn't find EMM driver"
  SYSTEM
END IF
CALL CallEmm(GetStatus)
CALL CallEmm(GetEmmVersion)
AL% = Lo%(EmmRegs.ax)
MajorVersion = AL% \ 16
MinorVersion = AL% AND &HF
IF AL% < &H32 THEN
    PRINT "Error - EMM version is earlier than 3.2"
    SYSTEM
END IF
CALL CallEmm(GetPageFrameAddr)
P0.Segment = EmmRegs.bx   'Window 0 -> P0 = BX:0000
P1.Segment = EmmRegs.bx   'Window 1 -> P1 = BX:4000
P2.Segment = EmmRegs.bx   'Window 2 -> P2 = BX:8000
P3.Segment = EmmRegs.bx   'Window 3 -> P3 = BX:C000
P0.Offset = &H0
P1.Offset = &H4000
P2.Offset = &H8000
P3.Offset = &HC000
'--- End EMM Handler

'The SUBs and how to use them:
'GetPages - Gets the pages in the EMM. Can only be called once, but
'           has no routine to check it (so watch out). Needs no arguments.
'ReleaseEMM - Releases EMM pages. MUST be used to release pages when
'             ending program, or those pages cannot be used until a reboot.
'             Needs no arguments.
'StoreMsg - Stores a string into EMM. Arguments: what$=string to store
'           I=message num. to store it in
'GetMsg$ (Function) - returns the message string from a message. Arguments:
'        I=message num. to get string from

'Example:
CLS
GetPages                 'allocate pages
StoreMsg "testing...", 1 'store string "testing..." in EMM with msg num 1
StoreMsg "This program rules", 2 'this string is clipped because MsgLen=16
PRINT GetMsg$(2)         'get the string from msg number 2 in the EMM
PRINT GetMsg$(1)         'get the string from msg number 1 in the EMM
ReleaseEMM               'release the pages that were allocated

'Error handling routine
SYSTEM
oops:
SELECT CASE ERR
 CASE 53   'File/device not found.
   PRINT "No EMM driver found"
   SYSTEM
 CASE ELSE
   PRINT "Unknown error #"; ERR
   ReleaseEMM
   SYSTEM
END SELECT

SUB CallEmm (EmmFuncNbr)

    EmmRegs.ax = EmmFuncNbr * 256
    CALL INTERRUPT(EmsInt, EmmRegs, EmmRegs)
    AH = Hi%(EmmRegs.ax)
    IF AH <> 0 THEN
	CALL EmmPrintStatus(AH)
	SYSTEM
    END IF

END SUB

FUNCTION EmmDriverExists1%

DIM EmsDriver AS address
DIM EmsIdString AS STRING * 8

EmmDriverExists1% = 0                   'False
DEF SEG = 0
VectorAddr = &H67 * 4
EmsDriver.Segment = PEEK(VectorAddr + 3) * 256& + PEEK(VectorAddr + 2)

IF EmsDriver.Segment <> 0 THEN
    DEF SEG = EmsDriver.Segment
    EmsDriver.Offset = 10
    FOR I = 0 TO 7
     MID$(EmsIdString, I + 1, 1) = CHR$(PEEK(EmsDriver.Offset + I))
    NEXT I
    IF EmsIdString = "EMMXXXX0" THEN
     EmmDriverExists1% = -1
    END IF
END IF
DEF SEG

END FUNCTION

FUNCTION EmmDriverExists2%


    EmmDriverExists2% = -1      'Set default return value to TRUE
    OPEN "I", 1, "EMMXXXX0"

    EmmRegs.ax = IoCtlFunc * 256&           'Call IOCtl Function
    EmmRegs.bx = FILEATTR(1, 2)             'Set DOS file handle#
    CALL INTERRUPT(&H21, EmmRegs, EmmRegs)  'Call DOS
    CLOSE 1
    IF (EmmRegs.flags AND 1) = 0 THEN       'Call successfull
     IF (EmmRegs.dx AND &H80) = &H80 THEN   'Handle is for a dev
	'PRINT "Handle refers to a device"
     ELSE
	PRINT "Handle refers to a file"
	PRINT "Unable to contact EMM driver if present"
	SYSTEM
     END IF
    ELSE 'Call unsuccessfull
     SELECT CASE EmmRegs.ax
	CASE 1: PRINT "Invalid IOCtl subfunction"
	CASE 5: PRINT "Access to IOCTL denied"
	CASE 6: PRINT "Invalid handle"
	CASE ELSE
	    PRINT "Unknown error # "; EmmRegs.ax
     END SELECT
     PRINT "Unable to contact EMM driver"
     SYSTEM
    END IF
    EXIT FUNCTION

END FUNCTION

SUB EmmPrintStatus (Status%)
    SELECT CASE Status%
	CASE &H0: S$ = "Status ok"
	CASE &H80: S$ = "Driver malfunction"
	CASE &H81: S$ = "Hardware malfunction"
	CASE &H83: S$ = "Bad Handle"
	CASE &H84: S$ = "Undefined function"
	CASE &H85: S$ = "No free handles"
	CASE &H86: S$ = "Page map context error"
	CASE &H87: S$ = "Insufficient memory pages"
	CASE &H88: S$ = "Not enough free pages"
	CASE &H89: S$ = "Can't allocate zero pages"
	CASE &H8A: S$ = "Logical page out of range"
	CASE &H8B: S$ = "Physical page out of range"
	CASE &H8C: S$ = "Page map hardware RAM full"
	CASE &H8D: S$ = "Page map already has a handle"
	CASE &H8E: S$ = "Page map not mapped to handle"
	CASE &H8F: S$ = "Undefined subfunction number"
	CASE ELSE
	    S$ = "Unknown status number $" + HEX$(Status%)
    END SELECT
    PRINT "EMM: " + S$
END SUB

FUNCTION FmtPointer$ (P AS address)
    F$ = "$" + RIGHT$(HEX$(P.Segment), 4)
    F$ = F$ + ":$" + RIGHT$(HEX$(P.Offset), 4)
    FmtPointer$ = F$
END FUNCTION

FUNCTION GetMsg$ (I)
IF I < 1 OR I > NumMsgs THEN EXIT FUNCTION

MsgBuf = P3
Page = I \ MsgsPerPage
Index = I MOD MsgsPerPage
'***** Map indicated page into physical page 3 *****
AH = MapHandlePage                 'Map EMM page
AL = 3                             ' using physical page 3
EmmRegs.ax = AH * 256 + AL
EmmRegs.bx = Page                  'Logical page number
EmmRegs.dx = EmmHandle             'EMM RAM handle

CALL INTERRUPT(EmsInt, EmmRegs, EmmRegs)
AH = Hi%(EmmRegs.ax)
IF AH = 0 THEN
  MsgBuf.Offset = MsgBuf.Offset + Index * LEN(Buff)

  'Move the bytes from memory to a local variable

  DEF SEG = MsgBuf.Segment
  FOR J = 0 TO MsgLen - 1
    MID$(Buff, J + 1, 1) = CHR$(PEEK(MsgBuf.Offset + J))
  NEXT J
  DEF SEG

  ELSE
   CALL EmmPrintStatus(AH)
   I = -1
  END IF
GetMsg$ = Buff
END FUNCTION

SUB GetPages
CALL CallEmm(GetUnallocPages)

EmmRegs.bx = (NumMsgs + MsgsPerPage) \ MsgsPerPage
CALL CallEmm(AllocatePages)
EmmHandle = EmmRegs.dx
END SUB

FUNCTION Hi% (Operand%)
    Hi% = Operand% \ 256
END FUNCTION

FUNCTION Lo% (Operand%)
    Lo% = Operand% MOD 256
END FUNCTION

SUB ReleaseEMM
EmmRegs.dx = EmmHandle
CALL CallEmm(DeallocatePages)
END SUB

SUB StoreMsg (what$, I)
IF I < 0 OR I > NumMsgs THEN EXIT SUB

Buff = what$
MsgBuf = P0
LastPageNbr = -1
Page = I \ MsgsPerPage
Index = I MOD MsgsPerPage
MsgBuf.Offset = Index * LEN(Buff)
'***** Map indicated logical page into physical page 0 ****
IF Page <> LastPageNbr THEN
  AH = MapHandlePage
  AL = 0
  EmmRegs.ax = AH * 256 + AL  'Map EMS page & Physical page 0
  EmmRegs.bx = Page
  EmmRegs.dx = EmmHandle                      'EMM RAM handle
  CALL INTERRUPT(EmsInt, EmmRegs, EmmRegs)
  LastPageNbr = Page
END IF
AH = Hi%(EmmRegs.ax)
IF AH = 0 THEN
  ' Set message into memory
  DEF SEG = MsgBuf.Segment
  FOR J = 0 TO MsgLen - 1
    POKE MsgBuf.Offset + J, ASC(MID$(Buff, J + 1, 1))
  NEXT J
  DEF SEG
ELSE
  CALL EmmPrintStatus(AH)
END IF

END SUB

