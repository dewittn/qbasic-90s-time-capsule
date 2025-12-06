'This is the UUDecoder that goes along with my UUEncoding program.  If you
'like them let me know.  If you decide to use either of them (or portions of
'them m in your programs, remember to include my name in the credits. Thanx.

'David J. Arigan

  DEFINT A-Z
  IF LEN(COMMAND$) = 0 THEN PRINT "Usage: UUDECODE <filename>": END
  file$ = COMMAND$
  IF INSTR(file$, " ") THEN file$ = LEFT$(file$, INSTR(file$, " ") - 1)
  unam$ = file$
  IF INSTR(pnam$, "\") THEN pnam$ = MID$(pnam$, INSTR(file$, "\") + 1)
  OPEN file$ FOR BINARY AS #1
  IF LOF(1) = 0 THEN
    PRINT "File '"; file$; "' does not exist."
    CLOSE #1: KILL file$: END
  END IF
  CLOSE #1
  OPEN unam$ FOR INPUT AS #1
  WHILE EOF(1) = 0
    LINE INPUT #1, l$: lc = lc + 1
    IF LCASE$(LEFT$(l$, 5)) = "begin" THEN
      n = INSTR(l$, " ")
      IF n <> 0 AND INSTR(n + 1, l$, " ") <> 0 THEN
        onam$ = RTRIM$(MID$(l$, INSTR(n + 1, l$, " ") + 1))
        OPEN onam$ FOR BINARY AS #2
        DO
          LINE INPUT #1, l$: lc = lc + 1
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
            PUT #2, , o$
          END IF
        LOOP UNTIL EOF(1)
        CLOSE #2
        IF success = 0 THEN
          PRINT "*** UUDecoding '"; onam$; " was not succesful."
        ELSE
          PRINT "Finished UUDecoding '"; onam$; "'"
          success = 0
        END IF
      END IF
    END IF
  WEND
  CLOSE #1
