DECLARE FUNCTION INIgetEntry$ (Ifile$, Isection$, Ientry$, Iflags%)
DECLARE FUNCTION INIsetEntry% (Ifile$, Isection$, Ientry$, Ivalue$, tmpFile$, Iflags%)

DEFINT A-Z
FUNCTION INIgetEntry$ (Ifile$, Isection$, Ientry$, Iflags)
' This function will return the entry Ientry$ in section Isection$ of Ifile$.
Ifile$ = LTRIM$(RTRIM$(Ifile$))
IF Ifile$ = "" THEN EXIT FUNCTION
Isection$ = LTRIM$(RTRIM$(Isection$))
IF Isection$ = "" THEN EXIT FUNCTION
Ientry$ = LTRIM$(RTRIM$(Ientry$))
IF Ientry$ = "" THEN EXIT FUNCTION
f = FREEFILE
INIgetEntry$ = ""
OPEN Ifile$ FOR INPUT AS #f
IF LOF(f) = 0 THEN CLOSE #f: KILL Ifile$: EXIT FUNCTION
InSec = 0: TheSec = 0: doFnd = 0
DO
  LINE INPUT #f, tmp$
  tmp$ = LTRIM$(RTRIM$(tmp$))
  IF LEFT$(tmp$, 1) = "[" AND InSec = 0 THEN
    x$ = MID$(tmp$, 2, LEN(tmp$) - 2)
    x$ = UCASE$(LTRIM$(RTRIM$(x$)))
    IF TheSec = -1 THEN doFnd = 0: EXIT DO
    InSec = -1
    IF x$ = UCASE$(Isection$) THEN
      TheSec = -1
    ELSEIF RIGHT$(x$, 6) = "](MAIN" AND (Iflags AND 1) THEN
      TheSec = -2
    END IF
  ELSEIF tmp$ <> "" AND TheSec AND InSec = -1 THEN
    x$ = UCASE$(LTRIM$(RTRIM$(LEFT$(tmp$, INSTR(tmp$, "=") - 1))))
    IF x$ = UCASE$(Ientry$) THEN
      x$ = LTRIM$(RTRIM$(RIGHT$(tmp$, LEN(tmp$) - INSTR(tmp$, "="))))
      doFnd = -1
      EXIT DO
    END IF
  ELSEIF tmp$ = "" THEN
    InSec = 0
  END IF
LOOP UNTIL EOF(1)
CLOSE #f
IF doFnd THEN INIgetEntry$ = x$
END FUNCTION

FUNCTION INIsetEntry% (Ifile$, Isection$, Ientry$, Ivalue$, tmpFile$, Iflags)
' This function will set Ientry$ in Ifile$ in Isection$ to Ivalue$,
'  using tmpFile$ as a temporary file.
Ifile$ = LTRIM$(RTRIM$(Ifile$))
IF Ifile$ = "" THEN EXIT FUNCTION
Isection$ = LTRIM$(RTRIM$(Isection$))
IF Isection$ = "" THEN EXIT FUNCTION
Ientry$ = LTRIM$(RTRIM$(Ientry$))
IF Ientry$ = "" THEN EXIT FUNCTION
Ivalue$ = LTRIM$(RTRIM$(Ivalue$))
IF Ivalue$ = "" THEN EXIT FUNCTION
tmpFile$ = LTRIM$(RTRIM$(tmpFile$))
IF tmpFile$ = "" THEN EXIT FUNCTION
f = FREEFILE
OPEN Ifile$ FOR INPUT AS #f
IF LOF(f) = 0 THEN CLOSE #f: KILL Ifile$: EXIT FUNCTION
t = FREEFILE
OPEN tmpFile$ FOR OUTPUT AS #t
IF LOF(t) THEN CLOSE #f: KILL tmpFile$: EXIT FUNCTION
InSec = 0: TheSec = 0: doFnd = 0
DO
  LINE INPUT #f, tmp$
  tmp$ = LTRIM$(RTRIM$(tmp$))
  IF LEFT$(tmp$, 1) = "[" AND InSec = 0 THEN
    x$ = MID$(tmp$, 2, LEN(tmp$) - 2)
    x$ = UCASE$(LTRIM$(RTRIM$(x$)))
    IF TheSec = -1 THEN doFnd = 0: EXIT DO
    InSec = -1
    IF x$ = UCASE$(Isection$) THEN
      TheSec = -1
    ELSEIF RIGHT$(x$, 6) = "](MAIN" AND (Iflags AND 1) THEN
      TheSec = -2
    END IF
    o$ = tmp$
  ELSEIF tmp$ <> "" AND TheSec AND InSec = -1 THEN
    x$ = LTRIM$(RTRIM$(LEFT$(tmp$, INSTR(tmp$, "=") - 1)))
    IF UCASE$(x$) = UCASE$(Ientry$) THEN
      o$ = x$ + "=" + Ivalue$
      doFnd = -1
    ELSE
      o$ = tmp$
    END IF
  ELSEIF tmp$ = "" THEN
    o$ = ""
    InSec = 0
  ELSE
    o$ = tmp$
  END IF
  PRINT o$
  PRINT #t, o$
LOOP UNTIL EOF(1)
CLOSE #f, #t
IF doFnd THEN
  KILL Ifile$
  OPEN Ifile$ FOR OUTPUT AS #f
  OPEN tmpFile$ FOR INPUT AS #t
  DO
    LINE INPUT #t, tmp$
    PRINT #f, tmp$
  LOOP UNTIL EOF(t)
  CLOSE #f, #t
END IF
KILL tmpFile$
INIsetEntry = doFnd
END FUNCTION

