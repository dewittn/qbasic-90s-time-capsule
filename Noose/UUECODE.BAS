
DEFINT A-Z
'by David Arigan, tweaked by Hauke Daempfling
SUB UUDecode (InFile$, OutFile$)
  InFile$ = LTRIM$(RTRIM$(InFile$))
  OutFile$ = LTRIM$(RTRIM$(OutFile$))
  dnam$ = InFile$
  FOR a = LEN(InFile$) TO 1 STEP -1
    IF RIGHT$(dnam$, 1) = "\" THEN EXIT FOR ELSE dnam$ = LEFT$(dnam$, LEN(dnam$) - 1)
  NEXT a
  FRF1 = FREEFILE
  OPEN InFile$ FOR BINARY AS #FRF1
  FRF2 = FREEFILE
  IF LOF(1) = 0 THEN
    PRINT "File '"; InFile$; "' does not exist."
    CLOSE #FRF1: KILL InFile$: EXIT SUB
  END IF
  CLOSE #FRF1
  OPEN InFile$ FOR INPUT AS #FRF1
  WHILE EOF(1) = 0
    LINE INPUT #FRF1, l$: lc = lc + 1
    IF LCASE$(LEFT$(l$, 5)) = "begin" THEN
      N = INSTR(l$, " ")
      IF N <> 0 AND INSTR(N + 1, l$, " ") <> 0 THEN
        IF OutFile$ = "" THEN
           onam$ = dnam$ + RTRIM$(MID$(l$, INSTR(N + 1, l$, " ") + 1))
        ELSE
           onam$ = OutFile$
        END IF
        OPEN onam$ FOR BINARY AS #FRF2
        DO
          LINE INPUT #FRF1, l$: lc = lc + 1
          IF LCASE$(LEFT$(l$, 3)) = "end" THEN success = -1: EXIT DO
          IF LEN(l$) THEN
            ls = (ASC(l$) - 32) MOD 64: o$ = ""
            IF ls < 0 OR ls > 45 OR ls > ((LEN(l$) - 1) * 3 \ 4) THEN
              PRINT "*** Error in line #"; lc; " (Bad length)": EXIT DO
            END IF
            FOR i = 1 TO ls
              p = ((i - 1) \ 3) * 4
              SELECT CASE (i - 1) MOD 3
                CASE 0
                  c% = (ASC(MID$(l$, p + 2)) - 32) * 4
                  c% = c% + (ASC(MID$(l$, p + 3)) - 32) \ 16
                CASE 1
                  c% = ((ASC(MID$(l$, p + 3)) - 32) * 16) AND &HF0
                  c% = c% + (ASC(MID$(l$, p + 4)) - 32) \ 4
                CASE 2
                  c% = ((ASC(MID$(l$, p + 4)) - 32) * 64) AND &HC0
                  c% = c% + (ASC(MID$(l$, p + 5)) - 32)
              END SELECT
              o$ = o$ + CHR$(c)
            NEXT i
            PUT #FRF2, , o$
          END IF
        LOOP UNTIL EOF(1)
        CLOSE #FRF2
        IF success = 0 THEN
          PRINT "*** UUDecoding '"; onam$; " was not succesful."
        ELSE
          PRINT "Finished UUDecoding '"; onam$; "'"
          success = 0
        END IF
      END IF
    END IF
  WEND
  CLOSE #FRF2

END SUB

'by David Arigan, tweaked by Hauke Daempfling
SUB UUEncode (InFile$, OutFile$)
  InFile$ = LTRIM$(RTRIM$(InFile$))
  OutFile$ = LTRIM$(RTRIM$(OutFile$))
  pnam$ = InFile$
RetryAddUUE1:
  IF INSTR(pnam$, "\") THEN
    pnam$ = MID$(pnam$, INSTR(pnam$, "\") + 1): GOTO RetryAddUUE1
  END IF
  FRF1 = FREEFILE
  OPEN InFile$ FOR BINARY AS #FRF1
  FRF2 = FREEFILE
  IF LOF(FRF1) = 0 THEN
    PRINT "File '"; InFile$; "' does not exist."
    CLOSE #FRF1: KILL InFile$: EXIT SUB
  END IF
  OPEN OutFile$ FOR OUTPUT AS #FRF2
  PRINT #FRF2, "begin 644 " + pnam$
  bl& = 45: fl& = LOF(FRF1): bf$ = SPACE$(bl&)
  WHILE fl&
    IF fl& < bl& THEN bl& = fl&: bf$ = SPACE$(bl&)
    GET #FRF1, , bf$: fl& = fl& - bl&
    IF bl& MOD 3 <> 0 THEN bf$ = bf$ + STRING$(3 - bl& MOD 3, 0)
    FOR i = 1 TO bl& STEP 3
      c1 = ASC(MID$(bf$, i, 1))
      c2 = ASC(MID$(bf$, i + 1, 1))
      c3 = ASC(MID$(bf$, i + 2, 1))
      l$ = l$ + CHR$(c1 \ 4 + 32)
      l$ = l$ + CHR$((c1 * 16 + c2 \ 16 AND &H3F) + 32)
      l$ = l$ + CHR$((c2 * 4 + c3 \ 64 AND &H3F) + 32)
      l$ = l$ + CHR$((c3 AND &H3F) + 32)
    NEXT
    PRINT #FRF2, CHR$(32 + bl&); l$: l$ = ""
  WEND
  PRINT #FRF2, : PRINT #FRF2, "end"
  CLOSE #FRF1, #FRF2
END SUB

