DECLARE SUB KeyInt (AL%)
'
' KEYSTUFF.BAS  by Matt Hart
' Uses Interrupt 16H for various keyboard operations.
'
' The scroll lock, num lock, caps lock, and insert
' key flags remain ON until pressed again, thus the need for
' the ?Flag variables in this demo program.
'
' Also see Keystuf.asm for assembly language equivilants.
'
    DEFINT A-Z
    TYPE RegTypeX
        AX    AS INTEGER
        bx    AS INTEGER
        cx    AS INTEGER
        dx    AS INTEGER
        bp    AS INTEGER
        si    AS INTEGER
        di    AS INTEGER
        flags AS INTEGER
        ds    AS INTEGER
        es    AS INTEGER
    END TYPE
    DECLARE FUNCTION RShift ()
    DECLARE FUNCTION LShift ()
    DECLARE FUNCTION CtrlKey ()
    DECLARE FUNCTION AltKey ()
    DECLARE FUNCTION ScrollLock ()
    DECLARE FUNCTION NumLock ()
    DECLARE FUNCTION CapsLock ()
    DECLARE FUNCTION InsertKey ()
    SFlag = 0: NFlag = 0: CFlag = 0: IFlag = 0
    DO
        IF RShift THEN PRINT "Right Shift Key"
        IF LShift THEN PRINT "Left Shift Key"
        IF CtrlKey THEN PRINT "Control Key"
        IF AltKey THEN PRINT "Alt Key"
        IF ScrollLock AND NOT SFlag THEN
            PRINT "Scroll Lock Enabled"
            SFlag = NOT SFlag
        ELSEIF NOT ScrollLock AND SFlag THEN
            PRINT "Scroll Lock Disabled"
            SFlag = NOT SFlag
        END IF
        IF NumLock AND NOT NFlag THEN
            PRINT "Num Lock Enabled"
            NFlag = NOT NFlag
        ELSEIF NOT NumLock AND NFlag THEN
            PRINT "Num Lock Disabled"
            NFlag = NOT NFlag
        END IF
        IF CapsLock AND NOT CFlag THEN
            PRINT "Caps Lock Enabled"
            CFlag = NOT CFlag
        ELSEIF NOT CapsLock AND CFlag THEN
            PRINT "Caps Lock Disabled"
            CFlag = NOT CFlag
        END IF
        IF (InsertKey AND NOT IFlag) OR (NOT InsertKey AND IFlag) THEN
            PRINT "Insert Key Toggled"
            IFlag = NOT IFlag
        END IF
    LOOP UNTIL INKEY$ = CHR$(27)
    END

FUNCTION AltKey
  DIM InRegs AS RegTypeX
  DIM OutRegs AS RegTypeX
  InRegs.AX = &H200
  CALL InterruptX(&H16, InRegs, OutRegs)
  AL = OutRegs.AX MOD 256
  AltKey = (AL AND 8) = 8
END FUNCTION

'
FUNCTION CapsLock
    CALL KeyInt(AL): CapsLock = (AL AND 64) = 64
END FUNCTION

'
FUNCTION CtrlKey
    CALL KeyInt(AL): CtrlKey = (AL AND 4) = 4
END FUNCTION

'
FUNCTION InsertKey
    CALL KeyInt(AL): InsertKey = (AL AND 128) = 128
END FUNCTION

'
SUB KeyInt (AL)
    DIM InRegs AS RegTypeX
    DIM OutRegs AS RegTypeX
    InRegs.AX = &H200
    CALL InterruptX(&H16, InRegs, OutRegs)
    AL = OutRegs.AX MOD 256
END SUB

'
FUNCTION LShift
    CALL KeyInt(AL): LShift = (AL AND 2) = 2
END FUNCTION

'
FUNCTION NumLock
    CALL KeyInt(AL): NumLock = (AL AND 32) = 32
END FUNCTION

'
FUNCTION RShift
    CALL KeyInt(AL): RShift = (AL AND 1) = 1
END FUNCTION

'
FUNCTION ScrollLock
    CALL KeyInt(AL): ScrollLock = (AL AND 16) = 16
END FUNCTION

