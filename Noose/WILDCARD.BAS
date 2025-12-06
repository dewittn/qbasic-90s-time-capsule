DEFINT A-Z
DECLARE FUNCTION WildCardCount% (WCstr$)
DECLARE FUNCTION WildCardString$ (WCstr$, Istr$, Wone%)
DECLARE FUNCTION WildCardMatch% (WCstr$, Istr$)
'
'   *** Wildcard Handling ***
'      by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This program will count, check matches, and retreive wildcard strings.
'Anything's valid for input, except you CANNOT put two wildcards after
'one another, the matching routine will not know how many characters
'to give to the wildcards. Invalid would is "**" and "*?". Valid IS
'"??" and "?*". You would have problems with "* *" or any mask
'containing two *'s after one another with 3 or less characters
'between them, since WildCardMatch/String sorts out the wildcards
'according to the charactes between them. For a mask like "* *" and
'input string like "this is cool", WildCardString for 1 will return
'"this" for the first * and "is cool" for the second *, even though
'you might want it the other way around.
'

mask$ = "test * this *man? !!*"
text$ = "test ABC this DmanE !!FGH IJK"

CLS
PRINT "Wilcard string:  "; mask$
PRINT "Input string:    "; text$
PRINT

PRINT "Counting wildcards..."
x = WildCardCount(mask$)
IF x = -1 THEN PRINT ">>> Error" ELSE PRINT ">>>"; x

PRINT
PRINT "Checking match..."
x = WildCardMatch(mask$, text$)
IF x = 0 THEN PRINT ">>> No match/Error" ELSE PRINT ">>> Match"

FOR a = 1 TO WildCardCount(mask$)
  PRINT
  PRINT "Getting wildcard string"; a; "..."
  x$ = WildCardString$(mask$, text$, a)
  IF x$ = "" THEN PRINT ">>> No match/Error" ELSE PRINT ">>> "; x$
NEXT a

PRINT : PRINT "Press any key..."
DO: LOOP UNTIL INKEY$ <> "": CLS

PRINT "Please wait..."
mask$ = "abc*def*ghi?jk??lm*"
text$ = "abcXXXdefXghiXjkXXlmXX"
sT# = TIMER
FOR a = 1 TO 2000
  x = WildCardMatch(mask$, text$)
NEXT a
eT# = TIMER
PRINT "2000 wilcard strings matched in"; eT# - sT#; "seconds. "
PRINT "That's about one wildcard match in"; (eT# - sT#) / 2000#; "seconds."

FUNCTION WildCardCount (WCstr$)
IF WCstr$ = "" THEN WildCardCount = -1: EXIT FUNCTION
FOR a = 1 TO LEN(WCstr$)    'simpily count the wildcards
  IF MID$(WCstr$, a, 1) = "*" OR MID$(WCstr$, a, 1) = "?" THEN WCC = WCC + 1
NEXT a
WildCardCount = WCC
END FUNCTION

FUNCTION WildCardMatch (WCstr$, Istr$)
WCM = -1: Wpos = 0: Rpos = 0   'init variables
IF WCstr$ = "" OR Istr$ = "" THEN WildCardMatch = 0: EXIT FUNCTION
  '^^^ can't process null strings
IF LEFT$(WCstr$, 1) = "*" THEN WCstr$ = " " + WCstr$: Istr$ = " " + Istr$
DO                '^^^ can't process * at beginning of string
  Rpos = Rpos + 1    'position in Istr$
  Wpos = Wpos + 1    'position in WCstr$
  'for debugging, look at it if you don't understand WildCardMatch
  'SLEEP 1: CLS
  'PRINT WCstr$: PRINT SPACE$(Wpos - 1); "^"
  'PRINT Istr$: PRINT SPACE$(Rpos - 1); "^"
  IF MID$(WCstr$, Wpos, 1) = "*" THEN  'if there's a * wildcard
    'the idea of this is to skip over whatever characters are in
    ' Istr$ supplementing the * wildcard by setting Rpos according
    ' to the position of NextChrs$ in Istr$ so we can continue scanning
    'NextChrs$ are the characters between the current wildcard and the
    ' next one, that is why two wildcards next to one another are not
    ' allowed (NextChrs$ would be "", or " ", etc.).
    NextPos = INSTR(Wpos + 1, WCstr$, "*") - 1    'find the next *
    IF NextPos <= 0 THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
      '^^^ if there's no * left, there might be a ?
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)
      '^^^ if there's still no ?/* found, then that was the last wildcard
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos) 'get string between
    IF NextChrs$ = "" THEN                             ' the two *'s
      IF Wpos = LEN(WCstr$) THEN     'if we're at the end of the string
        EXIT DO                      ' and it's matched so far, then it's
      ELSE                           ' a match
        WCM = 0: EXIT DO             'if not, no match
      END IF
    END IF
    IF INSTR(NextChrs$, "?") THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)          'this is in case
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos)  ' it's a sequence
    IF NextChrs$ = "" THEN WCM = 0: EXIT DO             ' of * ? *
    Cnt = 0                                         'find our positon
    FOR a = Rpos TO LEN(Istr$) - LEN(NextChrs$) + 1 ' in Istr$
      IF MID$(Istr$, a, LEN(NextChrs$)) = NextChrs$ THEN Cnt = a: EXIT FOR
    NEXT a
    IF Cnt = 0 THEN WCM = 0: EXIT DO    'if we didn't find it then no match
    Rpos = Cnt - 1                      'set the scan positon in Istr$
  ELSE
    IF MID$(WCstr$, Wpos, 1) = MID$(Istr$, Rpos, 1) THEN
      'Match
    ELSEIF MID$(WCstr$, Wpos, 1) = "?" THEN
      'Match
    ELSE
      'No match
      WCM = 0: EXIT DO
    END IF
  END IF
LOOP UNTIL Rpos > LEN(Istr$)
WildCardMatch = WCM
END FUNCTION

FUNCTION WildCardString$ (WCstr$, Istr$, Wone)
IF Wone <= 0 THEN WildCardString$ = "": EXIT FUNCTION
  '^^^ can't process negative wildcards
FOR a = 1 TO LEN(WCstr$)  'find the position of the wildcard we want
  IF MID$(WCstr$, a, 1) = "*" OR MID$(WCstr$, a, 1) = "?" THEN WCC = WCC + 1
  IF WCC = Wone THEN
    WCC = a: EXIT FOR
  END IF
NEXT a
IF WCC = 0 THEN WildCardString$ = "": EXIT FUNCTION
'this routine is practically like WildCardMatch
IF LEFT$(WCstr$, 1) = "*" THEN WCstr$ = " " + WCstr$: Istr$ = " " + Istr$
DO
  Rpos = Rpos + 1
  Wpos = Wpos + 1
  'debugging
  'SLEEP 1: CLS
  'PRINT WCstr$: PRINT SPACE$(Wpos - 1); "^"
  'PRINT Istr$: PRINT SPACE$(Rpos - 1); "^"
  IF MID$(WCstr$, Wpos, 1) = "*" THEN
    NextPos = INSTR(Wpos + 1, WCstr$, "*") - 1
    IF NextPos <= 0 THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos)
    IF NextChrs$ = "" THEN
      IF Wpos = LEN(WCstr$) THEN
        WCS$ = MID$(Istr$, Rpos): EXIT DO  'get wildcard string
      ELSE
        WCS$ = "": EXIT DO
      END IF
    END IF
    IF INSTR(NextChrs$, "?") THEN NextPos = INSTR(Wpos + 1, WCstr$, "?") - 1
    IF NextPos <= 0 THEN NextPos = LEN(WCstr$)
    NextChrs$ = MID$(WCstr$, Wpos + 1, NextPos - Wpos) 'get wilcard string
    IF NextChrs$ = "" THEN WCS$ = "": EXIT DO
    Cnt = 0
    FOR a = Rpos TO LEN(Istr$) - LEN(NextChrs$) + 1
      IF MID$(Istr$, a, LEN(NextChrs$)) = NextChrs$ THEN Cnt = a: EXIT FOR
    NEXT a
    IF Cnt = 0 THEN WCS$ = "": EXIT DO
    IF Wpos = WCC THEN WCS$ = MID$(Istr$, Rpos, Cnt - Rpos): EXIT DO
    Rpos = Cnt - 1          '^^^ get wildcard string
  ELSE
    IF MID$(WCstr$, Wpos, 1) = MID$(Istr$, Rpos, 1) THEN
      'Match
    ELSEIF MID$(WCstr$, Wpos, 1) = "?" THEN
      'Match
      IF Wpos = WCC THEN WCS$ = MID$(Istr$, Rpos, 1): EXIT DO
    ELSE                        '^^^ get wilcard character
      WCS$ = "": EXIT DO
    END IF
  END IF
LOOP UNTIL Rpos > LEN(Istr$)
WildCardString$ = WCS$
END FUNCTION

