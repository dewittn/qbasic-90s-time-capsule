DEFINT A-Z
DECLARE SUB Highlight (x%, y%, Hlen%, FG%, BG%)
DECLARE SUB ComCmd (wp%)
DECLARE SUB WaitKey ()
DECLARE SUB CheckPorts ()
DECLARE SUB inPr (text$)
DECLARE SUB CheckKey (Key$, FuKeysOff)
DECLARE SUB MainLoop ()
DECLARE SUB Quit ()
DECLARE FUNCTION oPort% (p%)
DECLARE FUNCTION GetInput$ ()
DECLARE SUB Lights (Stat)
DECLARE SUB PutByte (Bytes$, ComPort%)
DECLARE SUB outPr (text$)
DECLARE SUB spcPr (text$)
DECLARE FUNCTION TR$ (what%)
DECLARE SUB DoScreen ()
DECLARE FUNCTION GetByte$ (Bytes%, ComPort%)
TYPE PortType
  BaudRate AS INTEGER
  CheckStat AS LONG
  BlockInto AS INTEGER
  BlockOut AS INTEGER
  BlockAll AS INTEGER
  Echo AS INTEGER
  AntiEcho AS INTEGER
  Dead AS INTEGER
  Jam AS INTEGER
  AntiJam AS INTEGER
  AutoCheck AS INTEGER
END TYPE
ON ERROR GOTO ErrHandle
DIM SHARED LastPress$
DIM SHARED cPort
DIM SHARED outX, outY
DIM SHARED inX, inY
DIM SHARED spcX, spcY
DIM SHARED MyID AS STRING * 6
DIM SHARED chkPort
DIM SHARED InpType
DIM SHARED Port(1 TO 2) AS PortType
DIM SHARED po(1 TO 2)
CONST true = -1, false = 0
MyID$ = "NONAME"
FOR a = 1 TO 2
  Port(a).BaudRate = 9600
NEXT a

DoScreen
spcPr "*** Welcome to ComLink by Hauke Daempfling!~"

MainLoop

Quit

ErrHandle:
SELECT CASE ERR
  CASE 69
    'Buffer overflow
    spcPr CHR$(13) + "*** ERROR: Communications Buffer Overflow~"
    spcPr CHR$(13) + "*** Now emptying communications buffer...~"
    BEEP
    DO
      dummy$ = INPUT$(1, cPort)
    LOOP UNTIL EOF(cPort)
  CASE 52
    'Bad file name or number
    BEEP
    spcPr CHR$(13) + "*** ERROR: Invalid com port access~"
  CASE 24
    'Device timeout
    IF NOT chkPort THEN
      spcPr CHR$(13) + "*** ERROR: COM" + TR$(cPort) + " down~"
      spcPr CHR$(13) + "*** Closing COM" + TR$(cPort) + ".~"
      BEEP
    END IF
    CLOSE cPort
    po(cPort) = false
  CASE 25
    'Device fault
    BEEP
    spcPr CHR$(13) + "*** ERROR: COM" + TR$(cPort) + " port fault~"
    spcPr CHR$(13) + "*** Closing COM" + TR$(cPort) + ".~"
    CLOSE cPort
    po(cPort) = false
  CASE 51
    'Internal error
    BEEP
    spcPr CHR$(13) + "*** ERROR: Internal unknown error~"
    Quit
  CASE 57
    'Device I/O error
    BEEP
    spcPr CHR$(13) + "*** ERROR: Device I/O error~"
    spcPr CHR$(13) + "*** Closing COM" + TR$(cPort) + ".~"
    CLOSE cPort
    po(cPort) = false
  CASE 68
    'Device unavailable
    IF NOT chkPort THEN
      BEEP
      spcPr CHR$(13) + "*** ERROR: Device unavailable~"
      spcPr CHR$(13) + "*** Closing COM" + TR$(cPort) + ".~"
    ELSE
      spcPr CHR$(13) + "*** COM" + TR$(cPort) + " does not exist.~"
    END IF
    Port(cPort).Dead = true
    CLOSE cPort
    po(cPort) = false
  CASE ELSE
    'Unknown
    BEEP
    spcPr CHR$(13) + "*** Unknown error #" + TR$(ERR) + ".~"
END SELECT
RESUME NEXT

SUB CheckKey (Key$, FuKeysOff)
IF LEN(Key$) = 0 THEN EXIT SUB
KillKey = true
IF NOT FuKeysOff AND LEN(Key$) = 1 THEN
  SELECT CASE Key$
    CASE CHR$(27)
      DoScreen
    CASE ELSE
      KillKey = false
  END SELECT
  IF KillKey THEN Key$ = ""
  EXIT SUB
END IF
IF LEN(Key$) <> 2 THEN EXIT SUB
Key$ = RIGHT$(Key$, 1)
IF Key$ = CHR$(16) OR Key$ = "C" THEN Quit
IF NOT FuKeysOff THEN
  SELECT CASE Key$
    CASE ";"
      ComCmd 1
    CASE "<"
      ComCmd 2
    CASE "="
      IF inX > 1 THEN inPr CHR$(13) + "~"
      inPr CHR$(13) + "Please enter the new ID: ~"
      DO
        DO
          k$ = INKEY$
          CheckKey k$, true
          CheckPorts
        LOOP UNTIL k$ <> ""
        SELECT CASE k$
          CASE CHR$(13)
            IF LEN(ss$) > 1 THEN
              MyID$ = ss$
              inPr CHR$(13) + "ID changed." + CHR$(13) + "~"
            ELSE
              inPr CHR$(13) + "ID not changed." + CHR$(13) + "~"
            END IF
            EXIT DO
          CASE CHR$(27)
            inPr CHR$(13) + "ID not changed." + CHR$(13) + "~"
            EXIT DO
          CASE CHR$(8)
            IF LEN(ss$) THEN ss$ = LEFT$(ss$, LEN(ss$) - 1): inPr CHR$(29) + " " + CHR$(29) + "~"
          CASE ELSE
            IF LEN(ss$) < 6 AND LEN(k$) = 1 AND ASC(k$) >= 32 THEN inPr k$ + "~": ss$ = ss$ + k$
        END SELECT
      LOOP
  END SELECT
END IF
Key$ = ""
END SUB

SUB CheckPorts
FOR a = 1 TO 2
  IF po(a) AND NOT Port(a).Dead THEN
    'check an open port
    cPort = a
    'check if com has been closed
    IF Port(a).CheckStat < TIMER AND Port(a).AutoCheck THEN
      Port(a).CheckStat = TIMER + 5
      chkPort = true
      PutByte " " + CHR$(8), a
      IF NOT po(a) THEN
        spcPr CHR$(13) + "*** COM" + TR$(a) + " has been closed!~"
      END IF
      chkPort = false
    END IF
    IF Port(a).Jam AND po(a) AND NOT Port(a).BlockAll THEN PutByte CHR$(128 + RND * 127), a
    IF NOT EOF(a) AND po(a) AND NOT Port(a).BlockAll THEN
      'there are bytes waiting
      x$ = GetByte$(LOC(a), a)
      IF po(oPort(a)) THEN
        'send this data out of the other port if its open
         cPort = a
         IF NOT Port(oPort(a)).BlockAll THEN PutByte x$, oPort(a)
        cPort = a
      END IF
      IF Port(a).AntiJam THEN
        FOR d = 1 TO LEN(x$)
          IF ASC(MID$(x$, d)) < 128 THEN
            ss$ = ss$ + MID$(x$, d, 1)
          END IF
        NEXT d
        x$ = ss$
      END IF
      IF Port(a).AntiEcho THEN
        'we gotta get rid of double chars
        spcPr CHR$(13) + "-" + LastPress$ + "-" + x$ + "-"
        IF LastPress$ <> "" THEN
          IF x$ = STRING$(LEN(x$), LastPress$) OR LastPress$ = x$ THEN x$ = ""
        END IF
      END IF
      IF Port(a).Echo THEN
        'if we're Echoing on this port then send chars back
        FOR d = 1 TO LEN(x$)
          PutByte STRING$(Port(a).Echo, MID$(x$, d, 1)), a
        NEXT d
      END IF
      FOR d = 1 TO LEN(x$)
        'filter
        IF ASC(MID$(x$, d)) = 8 THEN MID$(x$, d, 1) = CHR$(29)
        IF ASC(MID$(x$, d)) = 10 THEN MID$(x$, d, 1) = " "
      NEXT d
      'print
      IF NOT Port(a).BlockOut THEN outPr x$ + "~"
    ELSEIF NOT EOF(a) AND po(a) AND Port(a).BlockAll = true THEN
      'we don't give a shit about this input
      x$ = GetByte$(LOC(a), a)
    END IF
  ELSE
    'this port is closed, check if its open
    IF Port(a).CheckStat < TIMER THEN
      Port(a).CheckStat = TIMER + 5
      IF NOT Port(a).Dead AND Port(a).AutoCheck AND NOT po(a) THEN
        o$ = "COM" + TR$(a) + ":" + TR$(Port(a).BaudRate) + ",N,8,1,OP500,RB1024,TB1024,BIN" 'CS500,CD500,DS500
        chkPort = true
        cPort = a
        po(a) = true
        Lights true
        'sT! = TIMER
        OPEN o$ FOR RANDOM AS #a LEN = 1024
        'eT! = TIMER: spcPr CHR$(13) + TR$(eT! - sT!) + "~"
        Lights false
        chkPort = false
        IF po(a) THEN
          spcPr CHR$(13) + "*** COM" + TR$(a) + " has been opened!~"
          PutByte CHR$(13) + "Welcome! You have connected to " + MyID$ + "." + CHR$(13), a
        END IF
      END IF
    END IF
  END IF
NEXT a
END SUB

SUB ComCmd (wp)
cPort = wp
IF Port(wp).Dead THEN spcPr CHR$(13) + "*** COM" + TR$(wp) + " does not exist.~": EXIT SUB
'BaudRate, BlockInto, BlockOut, BlockAll, Echo, AntiEcho, Jam, AntiJam, AutoCheck
DO
  inPr CHR$(13) + " * COM" + TR$(wp) + " *    Press O to open/close.    Other commands:~"
  inPr CHR$(13) + " 1-BaudRate | 2-BlockInto | 3-BlockOut | 4-BlockAll | 5-Echo~"
  inPr CHR$(13) + " 6-AntiEcho | 7-Jam | 8-AntiJam | 9-AutoCheck | ESC-End~"
  DO
    k$ = INKEY$
    CheckKey k$, true
    CheckPorts
  LOOP UNTIL k$ <> ""
  IF k$ = CHR$(27) THEN EXIT DO
  IF UCASE$(k$) = "O" THEN
    IF po(wp) THEN
      chkPort = true
      cPort = wp
      PutByte CHR$(13) + "This is " + MyID$ + ", logging off." + CHR$(13), wp
      PutByte "+++ATH" + CHR$(13), wp
      CLOSE #wp
      po(wp) = false
      spcPr CHR$(13) + "*** COM" + TR$(wp) + " has been closed!~"
      chkPort = false
      EXIT DO
    ELSE
     cPort = wp
     spcPr CHR$(13) + "*** Opening COM" + TR$(wp) + "...~"
     o$ = "COM" + TR$(wp) + ":" + TR$(Port(wp).BaudRate) + ",N,8,1,OP5000,RB1024,TB1024,BIN" 'CS500,CD500,DS500
     chkPort = true
     po(wp) = true
     Lights true
     OPEN o$ FOR RANDOM AS #wp
     Lights false
     chkPort = false
     IF po(wp) THEN
       spcPr CHR$(13) + "*** COM" + TR$(wp) + " has been opened!~"
       PutByte CHR$(13) + "Welcome! You have connected to " + MyID$ + "." + CHR$(13), wp
       EXIT DO
     ELSEIF Port(wp).Dead = false THEN
       spcPr CHR$(13) + "*** COM" + TR$(wp) + " could not be opened.~"
     END IF
    END IF
  END IF
  SELECT CASE VAL(k$)
    CASE 1
      inPr CHR$(13) + "Change baud rate for COM" + TR$(wp) + ":~"
      inPr CHR$(13) + " 1-300 | 2-1200 | 3-2400 | 4-9600 | 5-19200 | ESC-Cancel~"
      inPr CHR$(13) + "Select the new baud rate.~"
      DO
        k2$ = INKEY$
        CheckKey k2$, true
        CheckPorts
      LOOP UNTIL k2$ <> ""
      NewBaud = 0
      SELECT CASE k2$
        CASE "1"
          NewBaud = 300
        CASE "2"
          NewBaud = 1200
        CASE "3"
          NewBaud = 2400
        CASE "4"
          NewBaud = 9600
        CASE "5"
          NewBaud = 19200
      END SELECT
      IF NewBaud THEN
        Port(wp).BaudRate = NewBaud
        inPr CHR$(13) + "Changing baud rate to " + TR$(NewBaud) + " on COM" + TR$(wp) + ".~"
        IF po(wp) THEN
          o$ = "COM" + TR$(wp) + ":" + TR$(Port(wp).BaudRate) + ",N,8,1,OP500,RB1024,TB1024,BIN" 'CS500,CD500,DS500
          PutByte CHR$(13) + "Changing baud rate to " + TR$(NewBaud) + "!", wp
          Lights true
          CLOSE #wp
          OPEN o$ FOR RANDOM AS #wp
          Lights false
        END IF
        inPr CHR$(13) + "Done." + CHR$(13) + "Press any key...~"
        WaitKey
      END IF
    CASE 2
      Port(wp).BlockInto = NOT Port(wp).BlockInto
      inPr CHR$(13) + "Block all text going from keyboard to COM" + TR$(wp) + " ~"
      IF Port(wp).BlockInto THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE 3
      Port(wp).BlockOut = NOT Port(wp).BlockOut
      inPr CHR$(13) + "Block all text going from COM" + TR$(wp) + " to screen ~"
      IF Port(wp).BlockOut THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE 4
      Port(wp).BlockAll = NOT Port(wp).BlockAll
      inPr CHR$(13) + "Total input/output block for COM" + TR$(wp) + " ~"
      IF Port(wp).BlockAll THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE 5
      IF Port(wp).Echo THEN
        Port(wp).Echo = false
        inPr CHR$(13) + "Echo characters for COM" + TR$(wp) + " disabled. ~"
        inPr CHR$(13) + CHR$(13) + "Press any key...~"
        WaitKey
      ELSE
        inPr CHR$(13) + "Echo characters for COM" + TR$(wp) + " enabled. ~"
        inPr CHR$(13) + CHR$(13) + "Return how many characters (1-9)? ~"
        DO
          k2$ = INKEY$
          CheckKey k2$, true
          CheckPorts
        LOOP UNTIL k2$ <> ""
        IF VAL(k2$) THEN
          Port(wp).Echo = VAL(k2$)
        END IF
        inPr CHR$(13) + "Any characters recieved over COM" + TR$(wp) + " will be mirrored " + TR$(Port(wp).Echo) + " times.~"
        inPr CHR$(13) + CHR$(13) + "Press any key...~"
        WaitKey
      END IF
    CASE 6
      Port(wp).AntiEcho = NOT Port(wp).AntiEcho
      inPr CHR$(13) + "Echo filter for COM" + TR$(wp) + " ~"
      IF Port(wp).AntiEcho THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE 7
      Port(wp).Jam = NOT Port(wp).Jam
      inPr CHR$(13) + "Channel jam for COM" + TR$(wp) + " ~"
      IF Port(wp).Jam THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE 8
      Port(wp).AntiJam = NOT Port(wp).AntiJam
      inPr CHR$(13) + "Channel jam filter for COM" + TR$(wp) + " ~"
      IF Port(wp).AntiJam THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE 9
      Port(wp).AutoCheck = NOT Port(wp).AutoCheck
      inPr CHR$(13) + "Auto open/close check on COM" + TR$(wp) + " ~"
      IF Port(wp).AutoCheck THEN inPr "enabled.~" ELSE inPr "disabled.~"
      inPr CHR$(13) + CHR$(13) + "Press any key...~"
      WaitKey
    CASE ELSE
      'dummy, nothing happens
  END SELECT
LOOP
inPr CHR$(13) + CHR$(13) + CHR$(13) + "~"
inY = 17: LOCATE inY, inX, 1
END SUB

SUB DoScreen
RANDOMIZE TIMER
SCREEN 0
VIEW PRINT 1 TO 25
COLOR 15, 1
CLS
LOCATE 16, 1: PRINT STRING$(80, "Ä");
LOCATE 20, 1: PRINT STRING$(80, "Í");
LOCATE 24, 1: PRINT STRING$(80, "Í");
LOCATE 25, 1
'     |            |          |          |          |          |          |            |
PRINT "   F1: COM1  |  F2: COM2  |  F3:ID  |  F9: Quit                                ";

LOCATE 24, 70: PRINT "ÍÑÍÍÍÍÑÍÍÍÍ";
LOCATE 25, 70: PRINT " ³COM1³COM2";
LOCATE , , 0
outX = 0: inX = 0: spcX = 0
END SUB

FUNCTION GetByte$ (Bytes, ComPort)
cPort = ComPort
Lights true
eT! = TIMER + 1 + ((Bytes - 256) * .1)
in$ = ""
DO
  IF NOT EOF(ComPort) THEN
    IF LEN(in$) + LOC(ComPort) >= Bytes THEN
      in$ = in$ + INPUT$(Bytes - LEN(in$), ComPort)
      EXIT DO
    ELSE
      in$ = in$ + INPUT$(LOC(ComPort), ComPort)
    END IF
  END IF
LOOP UNTIL TIMER >= eT!
GetByte$ = in$
Lights false
END FUNCTION

FUNCTION GetInput$

END FUNCTION

SUB Highlight (x, y, Hlen, FG, BG)
IF x > 80 OR x < 1 OR y > 25 OR y < 1 OR x + Hlen > 80 THEN EXIT SUB
COLOR FG, BG
FOR a = x TO x + Hlen - 1
  NoKey$ = INKEY$
  LOCATE y, a
  PRINT CHR$(SCREEN(y, a));
NEXT a
END SUB

SUB inPr (text$)
VIEW PRINT 17 TO 19
IF inX = 0 THEN inX = 1: inY = 17
LOCATE inY, inX, 1
COLOR 15, 1
ss = true: IF RIGHT$(text$, 1) = "~" THEN ss = false: text$ = LEFT$(text$, LEN(text$) - 1)
FOR a = 1 TO LEN(text$)
  PRINT MID$(text$, a, 1);
NEXT a
IF ss THEN PRINT
inX = POS(0): inY = CSRLIN
END SUB

SUB Lights (Stat)
LOCATE 25, 70
IF po(cPort) THEN
  IF Stat THEN
    SELECT CASE cPort
      CASE 1
        Highlight 72, 25, 4, 4, 15
      CASE 2
        Highlight 78, 25, 4, 4, 15
    END SELECT
  ELSE
    SELECT CASE cPort
      CASE 1
        Highlight 72, 25, 4, 1, 15
      CASE 2
        Highlight 78, 25, 4, 1, 15
    END SELECT
  END IF
ELSE
  SELECT CASE cPort
    CASE 1
      Highlight 72, 25, 4, 15, 1
    CASE 2
      Highlight 78, 25, 4, 15, 1
  END SELECT
END IF
END SUB

SUB MainLoop
DO
  CheckPorts
  k$ = INKEY$
  CheckKey k$, false
  IF LEN(k$) THEN
    FOR a = 1 TO 2
      IF po(a) AND NOT Port(a).Dead AND NOT Port(a).BlockInto AND NOT Port(a).BlockAll THEN PutByte k$, a
    NEXT a
    IF k$ = CHR$(8) THEN k$ = CHR$(29)
    inPr k$ + "~"
  END IF
LOOP
END SUB

FUNCTION oPort (p)
IF p = 1 THEN oPort = 2 ELSE oPort = 1
END FUNCTION

SUB outPr (text$)
VIEW PRINT 1 TO 15
IF outX = 0 THEN outX = 1: outY = 1
LOCATE outY, outX, 0
COLOR 15, 1
ss = true: IF RIGHT$(text$, 1) = "~" THEN ss = false: text$ = LEFT$(text$, LEN(text$) - 1)
FOR a = 1 TO LEN(text$)
  PRINT MID$(text$, a, 1);
NEXT a
IF ss THEN PRINT
outX = POS(0): outY = CSRLIN
END SUB

SUB PutByte (Bytes$, ComPort)
cPort = ComPort
IF NOT chkPort THEN Lights true
IF po(cPort) THEN
  FOR a = 1 TO LEN(Bytes$)
    x$ = MID$(Bytes$, a, 1)
    PRINT #ComPort, x$;
    LastPress$ = x$
    'CheckPorts
    LastPress$ = ""
  NEXT a
END IF
IF NOT chkPort THEN Lights false
END SUB

SUB Quit
FOR a = 1 TO 2
  IF po(a) THEN
    chkPort = true
    PutByte CHR$(13) + "This is " + MyID$ + ", logging off." + CHR$(13), a
    PutByte "+++ATH" + CHR$(13), a
    CLOSE #a
    chkPort = false
    po(a) = false
  END IF
NEXT a
VIEW PRINT 1 TO 25
COLOR 7, 0
CLS
SYSTEM
END SUB

SUB spcPr (text$)
VIEW PRINT 21 TO 23
IF spcX = 0 THEN spcX = 1: spcY = 21
LOCATE spcY, spcX, 0
COLOR 15, 1
ss = true: IF RIGHT$(text$, 1) = "~" THEN ss = false: text$ = LEFT$(text$, LEN(text$) - 1)
FOR a = 1 TO LEN(text$)
  PRINT MID$(text$, a, 1);
NEXT a
IF ss THEN PRINT
spcX = POS(0): spcY = CSRLIN
END SUB

FUNCTION TR$ (what)
TR$ = LTRIM$(RTRIM$(STR$(what)))
END FUNCTION

SUB WaitKey
DO
  k$ = INKEY$
  CheckKey k$, true
  CheckPorts
LOOP UNTIL k$ <> ""
END SUB

