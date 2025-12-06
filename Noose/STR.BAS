'  STR.BAS by Hauke Daempfling
'  (c)1996 VIVIDsoft, Hauke Daempfling
'Converts long integers and double-precision numbers into strings.
'When converting double-precision numbers all zeroes are added, the
'comma is placed, and exponent removed. Use CLNG/CDBL for converting
'numbers into long integers/double-precision values. Doesn't work
'correctly in some cases, I don't know why. Also, I'm not the best
'in math, so I'm not sure if I got the thing with the exponents correctly.
'The thing that (should) control that is on line 13, marked with (?).
DECLARE FUNCTION liStr$ (liWhat&)
DECLARE FUNCTION sdStr$ (sdWhat#)

CLS

'10000
X% = 10000: PRINT X%; "  =";
X$ = liStr$(CLNG(X%)): PRINT X$

'-10000
X% = -10000: PRINT X%; "  =";
X$ = liStr$(CLNG(X%)): PRINT X$

'1000000
X& = 1000000: PRINT X&; "=";
X$ = liStr$(X&): PRINT X$

'-1000000
X& = -1000000: PRINT X&; "=";
X$ = liStr$(X&): PRINT X$

'10000000000
X! = 1E+10: PRINT X!; "  =";
X$ = sdStr$(CDBL(X!)): PRINT X$

'.0000000001
'For some reason I get '.0000000001000000013351432' here...?
X! = 1E-10: PRINT X!; "  =";
X$ = sdStr$(CDBL(X!)): PRINT X$

'-10000000000
X! = -1E+10: PRINT X!; "  =";
X$ = sdStr$(CDBL(X!)): PRINT X$

'-.0000000001
'Again, for some reason I get '-.0000000001000000013351432' here...?
X! = -1E-10: PRINT X!; "  =";
X$ = sdStr$(CDBL(X!)): PRINT X$

'1000000000000000000000000000000
X# = 1D+30: PRINT X#; "  =";
X$ = sdStr$(X#): PRINT X$

'.000000000000000000000000000001
X# = 1D-30: PRINT X#; "  =";
X$ = sdStr$(X#): PRINT X$

'-1000000000000000000000000000000
X# = -1D+30: PRINT X#; "  =";
X$ = sdStr$(X#): PRINT X$

'-.000000000000000000000000000001
X# = -1D-30: PRINT X#; "  =";
X$ = sdStr$(X#): PRINT X$

FUNCTION liStr$ (liWhat&)
  liStr$ = LTRIM$(RTRIM$(STR$(liWhat&)))
END FUNCTION

FUNCTION sdStr$ (sdWhat#)
  tmp$ = UCASE$(LTRIM$(RTRIM$(STR$(sdWhat#))))
  IF INSTR(tmp$, "D") OR INSTR(tmp$, "E") THEN       ' with exponent
    Cmv% = VAL(RIGHT$(tmp$, 3))                      ' get exponent
    tmp$ = LEFT$(tmp$, LEN(tmp$) - 4)                ' get rest of string
    Cms% = SGN(VAL(tmp$)) = -1                       ' if number is negative
    IF Cms% THEN tmp$ = RIGHT$(tmp$, LEN(tmp$) - 1)  ' get rid of minus sign
    IF INSTR(tmp$, ".") THEN                         ' get rid of comma
      tmp$ = LEFT$(tmp$, 1) + RIGHT$(tmp$, LEN(tmp$) - 2)
    END IF
    Cmp% = 1                                         ' comma postion
    Cst% = SGN(Cmv%)                                 ' direction of shifting
    IF Cst% = -1 THEN Ccp% = 1 ELSE Ccp% = 0         ' counter (?)
    DO                                               ' shift comma
      Ccp% = Ccp% + Cst%                             ' times shifted
      Cmp% = Cmp% + Cst%                             ' position of comma
      IF Cmp% < 1 THEN                               ' if too far left
        tmp$ = "0" + tmp$                            ' add zero to front
        Cmp% = 1                                     ' shift comma back
      END IF
      IF Cmp% > LEN(tmp$) THEN                       ' if comma too far right
        tmp$ = tmp$ + "0"                            ' add zero to end
      END IF
    LOOP UNTIL Ccp% = Cmv%                           ' until exponent reached
    IF Cmp% < LEN(tmp$) THEN                         ' add comma to string
      tmp$ = LEFT$(tmp$, Cmp%) + "." + RIGHT$(tmp$, LEN(tmp$) - (Cmp% + 1))
    END IF
    IF LEFT$(tmp$, 1) = "0" THEN                     ' remove leftmost zero
      tmp$ = RIGHT$(tmp$, LEN(tmp$) - 1)
    END IF
    IF Cms% THEN tmp$ = "-" + tmp$                   ' add minus sign if neg
    sdStr$ = tmp$                                    ' output string
  ELSE                                               ' without exponent
    sdStr$ = tmp$                                    ' output string
  END IF
END FUNCTION

