' This is a TWO Part Snippet,  ELIZA.BAS & ELIZA.DAT

10 '
20 ' Eliza/Doctor
30 ' Original author: Joseph Weizenbaum
40 ' This version: Frederick B. Maxwell, Jr.
50 ' Version 1.0    2/12/85        Initial CP/M (MBASIC) release.
60 ' Version 2.0    6/13/89        Initial PC (GWBASIC) release.
70 '
80 '***********************************************************************
90 '
100 '     This version of Eliza is released into the public domain.
110 '
120 '***********************************************************************
130 '
140 DEFINT A-Z:      ' no floating point is used.
150 DIM REPLIES$(300):    ' up to 300 responses.
160 DIM KWD$(200):   ' up to 200 keywords.
170 DIM FIRST(200):  ' first reply for keyword number in subscript.
180 DIM LAST(200):   ' last reply   "     "      "     "     "    .
190 DIM OFFSET(200): ' offset from first reply for each keyword.
200 '
210 '***********************************************************************
220 '
230 '     -Initialization-
240 '     We will read in data from the file ELIZA.DAT in the following format:
250 '          KEYWORD 1
260 '          KEYWORD N all keywords which will get the same responses
270 '          !         indicates end of keywords
280 '          RESPONSE 1     all responses for this/these keywords.
290 '          RESPONSE N
300 '          .         indicates end of responses
310 '
320 '***********************************************************************
330 '
340 OPEN "I", 1, "ELIZA.DAT":       ' file with keyword/response data.
350 MAXKEY = 0:                ' number of keywords
360 MINREPLY = 1:              ' first reply for first keyword.
370 '
380 WHILE NOT EOF(1)
390      NUMKEYS = 0:               ' number of keys with same responses.
400      LINE INPUT #1, F$:         ' get keyword or !
410      IF F$ = "!" THEN 480:      ' if ! then get replys.
420      MAXKEY = MAXKEY + 1:       ' we've got one more keyword
430      PRINT "."; :          ' let user know we're still alive.
440      NUMKEYS = NUMKEYS + 1:          ' 1 more keyword with same replys.
450      KWD$(MAXKEY) = " " + F$ + " ":  ' put in a keyword bounded with spaces.
460      GOTO 400
470      '
480      LINE INPUT #1, F$:         ' get the reply or .
490      IF F$ = "." THEN 540:      ' check for end of reply list.
500      MAXREPLY = MAXREPLY + 1:   ' 1 more reply.
510      REPLIES$(MAXREPLY) = F$
520      GOTO 480
530      '
540      FOR KWD = MAXKEY - NUMKEYS + 1 TO MAXKEY
550           FIRST(KWD) = MINREPLY:          ' first reply for key.
560           LAST(KWD) = MAXREPLY:      ' last reply for key.
570      NEXT KWD
580      MINREPLY = MAXREPLY + 1:        ' set up for next keyword.
590      '
600 WEND
610 CLOSE
620 '
630 '***********************************************************************
640 '
650 '     Here we go!  Send intro message to "patient".
660 '
670 '***********************************************************************
680 '
690 PRINT
700 PRINT "HI!  I'M ELIZA.  LET'S TALK.  TYPE `BYE' TO END THIS SESSION."
710 '
720 '***********************************************************************
730 '
740 '     Get the user input into I$.
750 '
760 '***********************************************************************
770 '
780 PRINT ">"; : LINE INPUT I$:          ' Get user input.
790 IF I$ = "" THEN 780:  ' Just hitting return isn't good enough.
800 I$ = " " + I$ + " ": ' Put a space on each end.
810 '
820 '***********************************************************************
830 '
840 '     Get rid of punctuation/extraneous characters, and make uppercase.
850 '
860 '***********************************************************************
870 '
880 L = 1:           ' Start at the first character
890 C$ = MID$(I$, L, 1):  ' Get the character.
900 '
910 '     Capitalize if necessary.
920 '
930 IF C$ >= "a" AND C$ <= "z" THEN MID$(I$, L, 1) = CHR$(ASC(C$) - &H20): GOTO 890
940 '
950 IF C$ = " " THEN 990:           ' Spaces are OK.
960 IF C$ >= "0" AND C$ <= "9" THEN 990: ' So are numbers.
970 IF C$ >= "A" AND C$ <= "Z" THEN 990: ' So are capital letters.
980 I$ = LEFT$(I$, L - 1) + MID$(I$, L + 1): GOTO 890: ' Delete character.
990 L = L + 1:                 ' Next character.
1000 IF L <= LEN(I$) THEN 890:           ' Keep on processin'
1010 '
1020 '***********************************************************************
1030 '
1040 '    Has he/she said this before?  Does he/she want to terminate session?
1050 '
1060 '***********************************************************************
1070 '
1080 IF I$ = PREVIOUS$ THEN PRINT "PLEASE DON'T REPEAT YOURSELF!": GOTO 730
1090 PREVIOUS$ = I$:                ' Set up for next run.
1100 '
1110 IF I$ = " BYE " THEN PRINT "TALK TO YOU LATER!  BYE!": END
1120 '
1130 '***********************************************************************
1140 '
1150 '    Find keyword in user input string (I$).
1160 '
1170 '***********************************************************************
1180 '
1190 FOR K = 1 TO MAXKEY - 1:  ' Start search at keyword number 1.
1200      C = INSTR(I$, KWD$(K)):        ' Look for the keyword in the string.
1210      IF C <> 0 THEN 1230:      ' Exit on match.
1220 NEXT K
1230 KWD = K:                  ' Keyword number.
1240 IF KWD = MAXKEY THEN 1280:          ' We don't need anything if no match.
1250 REMAINS$ = MID$(I$, C - 1 + LEN(KWD$(K))): ' Grab remainder for reply.
1260 '
1270 '***********************************************************************
1280 '
1290 '    Take everything after the keyword (remains$) and conjugate it
1300 '         using the data for conjugation.
1310 '
1320 '***********************************************************************
1330 '
1340 RESTORE
1350 READ S$, R$:                   ' Read search and replacement words.
1360 IF S$ = "." THEN 1430:         ' Periods (.) idicate end of data.
1370 C = INSTR(REMAINS$, S$):       ' Search for string S$ in REMAINS$
1380 IF C = 0 THEN 1350:            ' If no match, try the next one.
1390 TEMP$ = LEFT$(REMAINS$, C - 1): ' Replacement.
1400 TEMP$ = TEMP$ + R$:             ' Word.
1410 REMAINS$ = TEMP$ + MID$(REMAINS$, C + LEN(S$)): ' Right side.
1420 GOTO 1350:                ' Next conjugation to be done.
1430 C = INSTR(REMAINS$, "+"):      ' Strip the plus signs out.
1440 IF C = 0 THEN 1470
1450 REMAINS$ = LEFT$(REMAINS$, C - 1) + MID$(REMAINS$, C + 1):  ' Strip it.
1460 GOTO 1430:                ' Go for the next one.
1470 '
1480 ' Handle the special case of " I " being the last word.
1490 '
1500 IF RIGHT$(REMAINS$, 3) <> " I " THEN 1540
1510 REMAINS$ = LEFT$(REMAINS$, LEN(REMAINS$) - 2) + "ME "
1520 '
1530 '***********************************************************************
1540 '
1550 '    Get the reply using the keyword number (KWD).
1560 '
1570 '***********************************************************************
1580 '
1590 REPLY$ = REPLIES$(FIRST(KWD) + OFFSET(KWD)):            ' Get reply.
1600 OFFSET(KWD) = OFFSET(KWD) + 1:      ' Point to next reply.
1610 IF OFFSET(KWD) + FIRST(KWD) > LAST(KWD) THEN OFFSET(KWD) = 0: ' Wrap.
1620 '
1630 '    Bump offsets on all keywords that use these replys.
1640 '
1650 FOR TEMP = 1 TO MAXKEY
1660      IF FIRST(TEMP) = FIRST(KWD) THEN OFFSET(TEMP) = OFFSET(KWD)
1670 NEXT TEMP
1680 '
1690 '    If the last character of the reply is *, append REMAINS$ to reply.
1700 '
1710 IF RIGHT$(REPLY$, 1) = "*" THEN REPLY$ = LEFT$(REPLY$, LEN(REPLY$) - 1) + REMAINS$
1720 PRINT REPLY$
1730 GOTO 730
1740 '
1750 '***********************************************************************
1760 '
1770 '    Data for conjugations in the following form:
1780 '         Word to replace , Replacement with + appended on end
1790 '    + is to keep the word from being switched back later and will
1800 '    be stripped before output.
1810 '
1820 '***********************************************************************
1830 '
1840 DATA " ARE "  ,  " AM+ "
1850 DATA " AM "   ,  " ARE+ "
1860 DATA " WERE " ,  " WAS+ "
1870 DATA " WAS "  ,  " WERE+ "
1880 DATA " YOU "  ,  " I+ "
1890 DATA " I "    ,  " YOU+ "
1900 DATA " YOUR " ,  " MY+ "
1910 DATA " MY "   ,  " YOUR+ "
1920 DATA " IVE "  ,  " YOUVE+ "
1930 DATA " YOUVE ",  " IVE+ "
1940 DATA " IM "   ,  " YOURE+ "
1950 DATA " ME "   ,  " YOU+ "
1960 DATA " US "   ,  " YOU+ "
1970 DATA " WE "   ,  " YOU+ "
1980 DATA ".","."
1990 '


'-------------------8<------[ Begin ELIZA.DAT ]------->8--------------------
'-------------------8<------[ End ELIZA.DAT ]------->8--------------------
