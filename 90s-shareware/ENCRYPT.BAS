DEFINT A-Z
REM $DYNAMIC
DECLARE FUNCTION dCRC& (what$)
DECLARE SUB ExpPassw (Pw$)
DECLARE SUB Meter (Xp%, Yp%, CurVal&, MaxVal&)
DECLARE SUB ReGenTable (Table$, Pw$)
DECLARE FUNCTION mNOT% (v%, m%)
DECLARE FUNCTION sCRC% (what$)
DECLARE FUNCTION Decrypt1% (InFile$, Pw$, OutFile$)
DECLARE FUNCTION Encrypt1% (InFile$, Pw$, OutFile$)
DECLARE FUNCTION SimplEncr$ (In$, Pw$)
DECLARE FUNCTION rmarin% (ij AS INTEGER, kl AS INTEGER)
DECLARE FUNCTION ranmar% (rvec() AS DOUBLE, ln AS INTEGER)
CONST TRUE = -1
CONST FALSE = 0
DIM u(97) AS DOUBLE

CLS

OPEN "C:\TEST.ENC" FOR BINARY AS #1
CLOSE #1: KILL "C:\TEST.ENC"
s = Encrypt1("C:\TEST.TXT", "This is really cool!", "C:\TEST.ENC")

OPEN "C:\TEST.OUT" FOR BINARY AS #1
CLOSE #1: KILL "C:\TEST.OUT"
s = Decrypt1("C:\TEST.ENC", "This is really cool!", "C:\TEST.OUT")
SYSTEM

REM $STATIC
FUNCTION dCRC& (what$)
DIM x AS LONG
y = sCRC(what$)
x = y + y * &H100 + y * &H10000 + y * &H1000000
FOR a = 1 TO LEN(what$) - 3
  x = x XOR ASC(MID$(what$, a, 1))
  x = x XOR (ASC(MID$(what$, a + 1, 1)) * &H100&)
  x = x XOR (ASC(MID$(what$, a + 2, 1)) * &H10000)
  x = x XOR (ASC(MID$(what$, a + 3, 1)) * &H100000)
NEXT a
dCRC& = x AND &HFFFFFFFF
END FUNCTION

FUNCTION Decrypt1 (InFile$, Pw$, OutFile$)
Xp = POS(0): Yp = CSRLIN
DIM xRnd(1023) AS DOUBLE
Meter Xp, Yp, 0, 1
InFile$ = LTRIM$(RTRIM$(InFile$))
OutFile$ = LTRIM$(RTRIM$(OutFile$))
DataStr$ = ""

dRetr1:
xi1 = sCRC(Pw$)
xi2 = sCRC(DataStr$)
r = rmarin(xi1, xi2)
r = ranmar(xRnd(), 1024)
FOR a = 0 TO 1023
  NewChr$ = CHR$((xRnd(a) * 2048) AND &HFF)
  IF INSTR(DataStr$, NewChr$) = 0 THEN DataStr$ = DataStr$ + NewChr$
NEXT a
IF LEN(DataStr$) < 256 THEN GOTO dRetr1
DataStr$ = LEFT$(DataStr$, 256)
ReGenTable DataStr$, Pw$

f1 = FREEFILE
OPEN InFile$ FOR BINARY AS #f1
IF LOF(f1) = 0 THEN CLOSE #f1: EXIT FUNCTION
f2 = FREEFILE
OPEN OutFile$ FOR BINARY AS #f2
IF LOF(f2) THEN CLOSE #f1, #f2: EXIT FUNCTION
WorkStr$ = STRING$(256, 0)
DIM Fpos AS LONG, xtms AS LONG, Bytes AS LONG
xtms = LOF(f1) \ 256 + 1
l = 256
x$ = STRING$(14, 0)
GET #f1, , x$
'LOCATE 11, 1: PRINT "-"; x$; "-"; 14
IF LEFT$(x$, 5) <> "ENCID" THEN CLOSE #f1, #f2: EXIT FUNCTION
dc& = dCRC(Pw$)
r$ = CHR$(dc& AND &HFF)
r$ = r$ + CHR$((dc& AND &HFF00&) \ &H100&)
r$ = r$ + CHR$((dc& AND &HFF0000) \ &H10000)
r$ = r$ + CHR$((dc& AND &HFF000000) \ &H1000000)
dc& = dCRC(DataStr$)
r$ = r$ + CHR$(dc& AND &HFF)
r$ = r$ + CHR$((dc& AND &HFF00&) \ &H100&)
r$ = r$ + CHR$((dc& AND &HFF0000) \ &H10000)
r$ = r$ + CHR$((dc& AND &HFF000000) \ &H1000000)
IF MID$(x$, 6, 8) <> r$ THEN CLOSE #f1, #f2: EXIT FUNCTION
IF RIGHT$(x$, 1) <> CHR$(27) THEN CLOSE #f1, #f2: EXIT FUNCTION
x$ = ""

FOR Fpos = 1 TO xtms
  l = 256
  IF Bytes + 256 > LOF(f1) THEN l = LOF(f1) - Bytes - 14
  WorkStr$ = STRING$(l, 0)
  GET #f1, , WorkStr$

  WorkStr$ = WorkStr$ + CHR$(123)
  FOR a = l TO 1 STEP -1
    cb = ASC(MID$(WorkStr$, a, 1))
    nb = ASC(MID$(WorkStr$, a + 1, 1))
    x = mNOT(cb, nb)
    MID$(WorkStr$, a, 1) = CHR$(x)
  NEXT a
  WorkStr$ = LEFT$(WorkStr$, LEN(WorkStr$) - 1)
 
  FOR a = 1 TO l
    I = ASC(MID$(WorkStr$, a, 1))
    x = mNOT(I, a - 1)
    MID$(WorkStr$, a, 1) = CHR$(x)
  NEXT a
 
  IF l = 256 THEN
    FOR a = 256 TO 1 STEP -1
      p = ASC(MID$(DataStr$, a, 1)) + 1
      x$ = MID$(WorkStr$, p, 1)
      MID$(WorkStr$, p, 1) = MID$(WorkStr$, a, 1)
      MID$(WorkStr$, a, 1) = x$
    NEXT a
  END IF
 
  FOR a = 1 TO l
      I = ASC(MID$(WorkStr$, a, 1))
      p = ASC(MID$(DataStr$, a, 1))
      x = mNOT(I, p)
      MID$(WorkStr$, a, 1) = CHR$(x)
  NEXT a

  PUT #f2, , WorkStr$

  Bytes = Bytes + 256

  Meter Xp, Yp, Bytes, LOF(f1)

  ReGenTable DataStr$, Pw$
NEXT Fpos

Meter Xp, Yp, 1, 1

CLOSE f1, f2
END FUNCTION

FUNCTION Encrypt1 (InFile$, Pw$, OutFile$)
Xp = POS(0): Yp = CSRLIN
DIM xRnd(1023) AS DOUBLE
Meter Xp, Yp, 0, 1
InFile$ = LTRIM$(RTRIM$(InFile$))
OutFile$ = LTRIM$(RTRIM$(OutFile$))
DataStr$ = ""

eRetr1:
xi1 = sCRC(Pw$)
xi2 = sCRC(DataStr$)
r = rmarin(xi1, xi2)
r = ranmar(xRnd(), 1024)
FOR a = 0 TO 1023
  NewChr$ = CHR$((xRnd(a) * 2048) AND &HFF)
  IF INSTR(DataStr$, NewChr$) = 0 THEN DataStr$ = DataStr$ + NewChr$
NEXT a
IF LEN(DataStr$) < 256 THEN GOTO eRetr1
DataStr$ = LEFT$(DataStr$, 256)
ReGenTable DataStr$, Pw$

f1 = FREEFILE
OPEN InFile$ FOR BINARY AS #f1
IF LOF(f1) = 0 THEN EXIT FUNCTION
f2 = FREEFILE
OPEN OutFile$ FOR BINARY AS #f2
IF LOF(f2) THEN EXIT FUNCTION
WorkStr$ = STRING$(256, 0)
DIM Fpos AS LONG, tms AS LONG, Bytes AS LONG
tms = LOF(f1) \ 256 + 1
l = 256
dc& = dCRC(Pw$)
r$ = CHR$(dc& AND &HFF)
r$ = r$ + CHR$((dc& AND &HFF00&) \ &H100&)
r$ = r$ + CHR$((dc& AND &HFF0000) \ &H10000)
r$ = r$ + CHR$((dc& AND &HFF000000) \ &H1000000)
dc& = dCRC(DataStr$)
r$ = r$ + CHR$(dc& AND &HFF)
r$ = r$ + CHR$((dc& AND &HFF00&) \ &H100&)
r$ = r$ + CHR$((dc& AND &HFF0000) \ &H10000)
r$ = r$ + CHR$((dc& AND &HFF000000) \ &H1000000)
x$ = "ENCID" + r$ + CHR$(27)
'LOCATE 10, 1: PRINT "-"; x$; "-"; LEN(x$)
PUT #f2, , x$

FOR Fpos = 1 TO tms
  l = 256
  IF Bytes + 256 > LOF(f1) THEN l = LOF(f1) - Bytes
  WorkStr$ = STRING$(l, 0)
  GET #f1, , WorkStr$
 
  FOR a = 1 TO l
      I = ASC(MID$(WorkStr$, a, 1))
      p = ASC(MID$(DataStr$, a, 1))
      x = mNOT(I, p)
      MID$(WorkStr$, a, 1) = CHR$(x)
  NEXT a
 
  IF l = 256 THEN
    FOR a = 1 TO 256
      p = ASC(MID$(DataStr$, a, 1)) + 1
      x$ = MID$(WorkStr$, p, 1)
      MID$(WorkStr$, p, 1) = MID$(WorkStr$, a, 1)
      MID$(WorkStr$, a, 1) = x$
    NEXT a
  END IF

  FOR a = 1 TO l
    I = ASC(MID$(WorkStr$, a, 1))
    x = mNOT(I, a - 1)
    MID$(WorkStr$, a, 1) = CHR$(x)
  NEXT a
 
  WorkStr$ = WorkStr$ + CHR$(123)
  FOR a = 1 TO l
    cb = ASC(MID$(WorkStr$, a, 1))
    nb = ASC(MID$(WorkStr$, a + 1, 1))
    x = mNOT(cb, nb)
    MID$(WorkStr$, a, 1) = CHR$(x)
  NEXT a
  WorkStr$ = LEFT$(WorkStr$, LEN(WorkStr$) - 1)

  PUT #f2, , WorkStr$
 
  Bytes = Bytes + 256
 
  Meter Xp, Yp, Bytes, LOF(f1)
 
  ReGenTable DataStr$, Pw$
NEXT Fpos

Meter Xp, Yp, 1, 1

CLOSE f1, f2
END FUNCTION

SUB ExpPassw (Pw$)
DIM RandTable(255) AS DOUBLE
l = 256 - LEN(Pw$)
r = rmarin(sCRC(Pw$), 12343)
r = ranmar(RandTable(), 256)
FOR a = 1 TO l
  x = ((RandTable(a) * 2048) AND 255)
  Pw$ = Pw$ + CHR$(x)
NEXT a
ERASE RandTable
END SUB

SUB Meter (Xp, Yp, CurVal AS LONG, MaxVal AS LONG)
IF Xp > 55 OR Xp < 1 OR Yp > 25 OR Yp < 1 THEN EXIT SUB
PerVal = (CurVal / MaxVal) * 100
IF PerVal > 100 THEN EXIT SUB
LOCATE Yp, Xp
PRINT STRING$(PerVal \ 5, "Û"); STRING$(20 - PerVal \ 5, "°"); " ";
IF PerVal = 100 THEN PRINT "Done" ELSE PRINT LTRIM$(RTRIM$(STR$(PerVal))) + "%"
END SUB

FUNCTION mNOT (v, m)
mNOT = (((NOT (v AND m)) AND m) + (v AND (NOT m))) AND 255
END FUNCTION

DEFSNG A-Z
FUNCTION ranmar% (rvec() AS DOUBLE, ln AS INTEGER)
SHARED u() AS DOUBLE, C AS DOUBLE, cd AS DOUBLE, cm AS DOUBLE
SHARED i97 AS INTEGER, j97 AS INTEGER, test AS INTEGER
  DIM uni AS DOUBLE
  DIM ivec AS INTEGER

  IF NOT test THEN
    PRINT "RANMAR: Call the initialization routine (RMARIN) ";
    PRINT "before calling RANMAR."
    ranmar = 1
    EXIT FUNCTION
  END IF
  FOR ivec = 0 TO ln - 1
    uni = u(i97) - u(j97)
    IF uni < 0# THEN uni = uni + 1#
    u(i97) = uni
    i97 = i97 - 1
    IF i97 < 0 THEN i97 = 96
    j97 = j97 - 1
    IF j97 < 0 THEN j97 = 96
    C = C - cd
    IF C < 0# THEN C = C + cm
    uni = uni - C
    IF uni < 0# THEN uni = uni + 1#
    rvec(ivec) = uni
    ranmar = 0
  NEXT ivec
END FUNCTION

DEFINT A-Z
SUB ReGenTable (Table$, Pw$)
DIM SwapTable(256) AS DOUBLE
IF LEN(Pw$) < 256 THEN Pw$ = Pw$ + SPACE$(256 - LEN(Pw$))
r = ranmar(SwapTable(), 257)
FOR a = 1 TO 256
  p = ((SwapTable(a) * 2048) AND 255) + 1
  x$ = MID$(Table$, p, 1)
  MID$(Table$, p, 1) = MID$(Table$, a, 1)
  MID$(Table$, a, 1) = CHR$(mNOT(ASC(x$), ASC(MID$(Pw$, a, 1))))
NEXT a
ERASE SwapTable
END SUB

DEFSNG A-Z
FUNCTION rmarin% (ij AS INTEGER, kl AS INTEGER)
SHARED u() AS DOUBLE, C AS DOUBLE, cd AS DOUBLE, cm AS DOUBLE
SHARED i97 AS INTEGER, j97 AS INTEGER, test AS INTEGER
  DIM s AS DOUBLE, t AS DOUBLE
  DIM I AS INTEGER, j AS INTEGER, k AS INTEGER, l AS INTEGER, m AS INTEGER
  DIM ii AS INTEGER, jj AS INTEGER

  test = TRUE
  IF (ij < 0 OR ij > 31328) OR (kl < 0 OR kl > 30081) THEN
    PRINT "RMARIN: The first random number seed must have a ";
    PRINT "value between 0 and 31328"
    PRINT "        The second random number seed must have a ";
    PRINT "value between 0 and 30081"
    rmarin = 1
    EXIT FUNCTION
  END IF
  I = INT(ij / 177# MOD 177#) + 2
  j = INT(ij MOD 177#) + 2
  k = INT(kl / 169# MOD 178#) + 1
  l = INT(kl MOD 169#)
  FOR ii = 0 TO 96
    s = 0#
    t = .5
    FOR jj = 0 TO 23
      m = INT(k * (I * j MOD 179#) MOD 179#)
      I = j
      j = k
      k = m
      l = INT((l * 53# + 1#) MOD 169#)
      IF (l * m MOD 64#) >= 32 THEN
        s = s + t
      END IF
      t = t * .5
    NEXT jj
    u(ii) = s
  NEXT
  C = 362436# / 16777216#
  cd = 7654321# / 16777216#
  cm = 16777213# / 16777216#
  i97 = 96
  j97 = 32
  test = TRUE
  rmarin = 0
END FUNCTION

DEFINT A-Z
FUNCTION sCRC (what$)
x = 123
FOR a = 1 TO LEN(what$)
  x = x XOR ASC(MID$(what$, a, 1))
NEXT a

sCRC = x AND &HFF
END FUNCTION

FUNCTION SimplEncr$ (In$, Pw$)
Out$ = ""
FOR a = LEN(In$) TO 1 STEP -1
  I = ASC(RIGHT$(In$, a))
  p = ASC(RIGHT$(Pw$, a))
  x = mNOT(I, p)
  Out$ = Out$ + CHR$(x)
NEXT a
SimplEncr$ = Out$
END FUNCTION

