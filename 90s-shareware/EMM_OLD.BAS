'Program to store data in Expanded memory with QuickBasic.

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
CONST MsgLen = 16           'Message length
CONST MsgsPerPage = PageLen \ MsgLen
CONST NumMsgs = 5000

'*** Emm functions ***

CONST GetStatus = &H40
CONST GetPageFrameAddr = &H41
CONST GetUnallocPages = &H42
CONST GetEmmVersion = &H46
CONST AllocatePages = &H43
CONST MapHandlePage = &H44
CONST DeallocatePages = &H45

CLS

TYPE address
    Segment AS LONG
    Offset AS LONG
END TYPE

DIM P0 AS address             'Pointer to physical page 1
DIM P1 AS address             'Pointer to physical page 2
DIM P2 AS address             'Pointer to physical page 3
DIM P3 AS address             'Pointer to physical page 4
DIM MsgBuf AS address         'Pointer into mapped memory
DIM Buff AS STRING * 16       'Buffer for message to store in EM
DIM I AS INTEGER              'Dummy variable
DIM SHARED EmmRegs AS RegType 'Registers for interrupt calls
DIM Page AS LONG              'Page frame address
DIM Index AS LONG             'Index into page frame
DIM StrNum AS STRING * 6      'Holds record # for EMM msg

'Test for the existence of the EMM driver
'You can choose from 1 of 2 methods

'IF EmmDriverExists1% THEN         'Method 1
IF EmmDriverExists2% THEN          'Method 2
    PRINT "EMM driver exists"
ELSE
    PRINT "No EMM driver detected."
END IF

'Print the current status of the EMM driver

PRINT "Checking EMM status"
CALL CallEmm(GetStatus)
PRINT "EMM status ok"

'Print the version number of the EMM driver

CALL CallEmm(GetEmmVersion)

PRINT "EMS driver version = ";

AL% = Lo%(EmmRegs.ax)
MajorVersion = AL% \ 16
MinorVersion = AL% AND &HF
PRINT USING "!."; RIGHT$(STR$(MajorVersion), 1);
PRINT USING "!"; RIGHT$(STR$(MinorVersion), 1)

IF AL% < &H32 THEN
    PRINT "Error - EMM version is earlier than 3.2"
    SYSTEM
END IF

'***** Print the page frame & physical window addresses *****

CALL CallEmm(GetPageFrameAddr)

P0.Segment = EmmRegs.bx   'Window 0 -> P0 = BX:0000
P1.Segment = EmmRegs.bx   'Window 1 -> P1 = BX:4000
P2.Segment = EmmRegs.bx   'Window 2 -> P2 = BX:8000
P3.Segment = EmmRegs.bx   'Window 3 -> P3 = BX:C000
P0.Offset = &H0
P1.Offset = &H4000
P2.Offset = &H8000
P3.Offset = &HC000

PRINT "Page frame segment address = "; HEX$(EmmRegs.bx)
PRINT "Physical page 0 address = "; FmtPointer$(P0)
PRINT "Physical page 1 address = "; FmtPointer$(P1)
PRINT "Physical page 2 address = "; FmtPointer$(P2)
PRINT "Physical page 3 address = "; FmtPointer$(P3)

'***** Print # of unallocated pages and total # of pages *****

CALL CallEmm(GetUnallocPages)
PRINT "Total EMS pages = "; EmmRegs.dx
PRINT "Unused EMS pages = "; EmmRegs.bx

'***** Allocate some pages of expanded memory *****

EmmRegs.bx = (NumMsgs + MsgsPerPage) \ MsgsPerPage
CALL CallEmm(AllocatePages)
PRINT "Allocated "; EmmRegs.bx; " pages to handle #"; EmmRegs.dx
EmmHandle = EmmRegs.dx

'***** Load EMS RAM with data *****

MsgBuf = P0
PRINT "Storing messages into extended memory page frame"
LastPageNbr = -1
FOR I = 0 TO NumMsgs - 1
    LOCATE 14, 50: PRINT USING "#,###"; I
    StrNum = STR$(I)
    Buff = " EMS msg #" + StrNum
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
        EXIT FOR
    END IF
NEXT I

PRINT

'Allow user to access any message in the buffer

I = &HFF

WHILE I <> -1
    INPUT "Enter message # to retrieve, or -1 to quit: "; I
    IF (I >= 0) AND (I < NumMsgs) THEN

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

            PRINT "Retrieved message -> "; Buff;
            PRINT " from page #"; Page; " Index"; Index
        ELSE
            CALL EmmPrintStatus(AH)
            I = -1
        END IF
    END IF

WEND

'***** Free the EMS RAM back to the EMM driver *****

EmmRegs.dx = EmmHandle
CALL CallEmm(DeallocatePages)
PRINT "Released all memory for handle "; EmmRegs.dx
END

'Error handling routine

oops:
    SELECT CASE ERR
        CASE 53   'File/device not found.
            PRINT "No EMM driver found"
            SYSTEM
        CASE ELSE
            PRINT "Unknown error #"; ERR
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
EmsDriver.Segment = PEEK(VectorAddr + 3) * 256& + _
                    PEEK(VectorAddr + 2)

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

DIM EmmHandle AS INTEGER      'Handle for EMM allocated pages

ON ERROR GOTO oops
    EmmDriverExists2% = -1      'Set default return value to TRUE
    OPEN "I", 1, "EMMXXXX0"

    EmmRegs.ax = IoCtlFunc * 256&           'Call IOCtl Function
    EmmRegs.bx = FILEATTR(1, 2)             'Set DOS file handle#
    CALL INTERRUPT(&H21, EmmRegs, EmmRegs)  'Call DOS
    CLOSE 1
    IF (EmmRegs.flags AND 1) = 0 THEN       'Call successfull
     IF (EmmRegs.dx AND &H80) = &H80 THEN  'Handle is for a dev
        PRINT "Handle refers to a device"
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

FUNCTION Hi% (Operand%)
    Hi% = Operand% \ 256
END FUNCTION

FUNCTION Lo% (Operand%)
    Lo% = Operand% MOD 256
END FUNCTION
