'Here is a UUEncoder program I wrote for no particular reason whatsoever.
'It is fairly small and simple (pretty quick also).  Enjoy.

'David Arigan

  IF LEN(COMMAND$) = 0 THEN PRINT "Usage: UUENCODE <filename>": END
  file$ = COMMAND$
  IF INSTR(file$, " ") THEN file$ = LEFT$(file$, INSTR(file$, " ") - 1)
  unam$ = file$
  IF INSTR(unam$, ".") THEN unam$ = LEFT$(file$, INSTR(file$, ".") - 1)
  pnam$ = file$
  IF INSTR(pnam$, "\") THEN pnam$ = MID$(pnam$, INSTR(file$, "\") + 1)
  OPEN file$ FOR BINARY AS #1
  IF LOF(1) = 0 THEN
    PRINT "File '"; file$; "' does not exist."
    CLOSE #1: KILL file$: END
  END IF
  OPEN unam$ + ".uue" FOR OUTPUT AS #2
  PRINT #2, "begin 644 " + pnam$
  bl& = 45: fl& = LOF(1): bf$ = SPACE$(bl&)
  WHILE fl&
    IF fl& < bl& THEN bl& = fl&: bf$ = SPACE$(bl&)
    GET #1, , bf$: fl& = fl& - bl&
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
    PRINT #2, CHR$(32 + bl&); l$: l$ = ""
  WEND
  PRINT #2, : PRINT #2, "end"
  CLOSE #1, #2


