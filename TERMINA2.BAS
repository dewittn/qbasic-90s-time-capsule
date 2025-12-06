DEFINT A-Z
DECLARE SUB redraw (clss)
DECLARE SUB filter (inString$)
CONST retry = 0
ON ERROR GOTO errortrap
COLOR 7, 1                      ' Set screen color.
CLS
DIM SHARED clss AS INTEGER
DIM SHARED sent$
DIM SHARED connected
DIM SHARED txt$
DIM SHARED x
DIM SHARED y
DIM SHARED z
quit$ = CHR$(0) + CHR$(16)      ' Value returned by INKEY$
                                ' when ALT+q is pressed.

' Set up prompt on bottom line of screen and turn cursor on:
'lOCATE 24, 1, 1
'PRINT STRING$(80, "_");
redraw (1)
VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.
5   KeyInput$ = INKEY$ ' Check the keyboard.
   IF KeyInput$ = quit$ THEN CLOSE #1: END

' Open communications (1200 baud, no parity, 8-bit data,    ' 1 stop bit, 256-byte input buffer):
LOCATE 1, 1
'redraw
'PRINT "Other Computer Not Connected"
IF z <> 1 THEN OPEN "COM3:9600,N,8,1,OP100" FOR RANDOM AS #1 LEN = 32767
connected = 1
'BEEP
LOCATE 1, 1
redraw (1)
PRINT "Other Computer Connected"
DO                              ' Main communications loop.


   KeyInput$ = INKEY$ ' Check the keyboard.
  
IF x = 1 THEN PRINT #1, txt$; 6
IF y = 1 THEN ModemInput$ = ""
 
   SELECT CASE KeyInput$
       
        'F2
        CASE CHR$(0) + "<"
        CLOSE #1
        z = 1
        redraw (0)
        DO
        LOOP UNTIL INKEY$ = CHR$(0) + "<"
        z = 0
        redraw (0)
        GOTO 5
       
        'Down arrow
        CASE CHR$(0) + "P"
        PRINT #1, quit$
        sent$ = "quit$"
        redraw (0)
       
        'F3
        CASE CHR$(0) + "="
        PRINT #1, CHR$(13)
        sent$ = "CHR$(13)"
        redraw (0)

        'F4
        CASE CHR$(0) + ">"
        PRINT #1, CHR$(29)
        sent$ = "CHR$(29)"
        redraw (0)

        'F5
        CASE CHR$(0) + "?"
        PRINT #1, "You Suck!"
        sent$ = "You Suck!"
        redraw (0)

        'F6
        CASE CHR$(0) + "@"
       
        'CTRL + X
        CASE CHR$(24)
        IF x = 1 THEN
        x = 0
        ELSE
        x = 1
        INPUT txt$
        END IF
        redraw (0)
       
        'ESC
        CASE CHR$(27)
        IF y = 1 THEN y = 0 ELSE y = 1
        redraw (1)
       
        CASE quit$     ' Exit the loop if the user
        PRINT #1, CHR$(16)
        EXIT DO                   ' pressed ALT+q.
       
        'F1
        CASE CHR$(0) + ";"
        CLS
6
        redraw (1)
        CASE IS <> "" 'Otherwise, if the user has
        PRINT #1, KeyInput$;      ' pressed a key, send the
        filter KeyInput$
        PRINT KeyInput$;
   END SELECT                       ' character typed to the modem.
   
   ' Check the modem. If characters are waiting (EOF(1) is
   ' true), get them and print them to the screen:
   IF NOT EOF(1) THEN

      ' LOC(1) gives the number of characters waiting:
      ModemInput$ = INPUT$(LOC(1), #1)
      
      IF ModemInput$ = CHR$(16) THEN
      x = 0: connected = 0
      redraw (1)
      LOCATE 1, 1
      'BEEP: BEEP
      PRINT "Other Computer Has disconnected (chr$(16))"
      END IF
     
      IF y = 1 THEN ModemInput$ = ""
      filter ModemInput$        ' Filter out line feeds and
      PRINT ModemInput$;        ' backspaces, then print.
   END IF
LOOP

CLOSE                           ' End communications.
CLS
END
errortrap:
IF ERR = 52 THEN
z = 0
RESUME 5
END IF
IF ERR = 69 THEN
CLOSE #1
RESUME 5
END IF
IF ERR = 24 THEN
LOCATE 1, 1
x = 0
redraw (1)
PRINT "Other Computer is Not responding. (true disconnect)"
SYSTEM
connected = 0
RESUME 5
ELSE
PRINT "Error #"; ERR; "Has occoured"
END
END IF

'
' ========================= FILTER ==========================
'     Filters characters in an input string.
' ============================================================
'
SUB filter (inString$) STATIC
   ' Look for backspace characters and recode them to
   ' CHR$(29) (the LEFT cursor key):
   DO
      BackSpace = INSTR(inString$, CHR$(8))
      IF BackSpace THEN
         MID$(inString$, BackSpace) = CHR$(29)
      END IF
   LOOP WHILE BackSpace

   ' Look for line-feed characters and remove any found:
   'DO
   '   LineFeed = INSTR(inString$, CHR$(10))
   '   IF LineFeed THEN
   '      inString$ = LEFT$(inString$, LineFeed - 1) + MID$(inString$, LineFeed + 1)
   '   END IF
  ' LOOP WHILE LineFeed

END SUB

SUB redraw (clss)
IF clss = 1 THEN CLS  ELSE curx = POS(0): cury = CSRLIN
VIEW PRINT 1 TO 25
LOCATE 24, 1, 1
PRINT STRING$(80, "_");
LOCATE 25, 1
IF txt$ = "" THEN PRINT STRING$(80, " "); : LOCATE 25, 1: GOTO 7
'IF x = 1 THEN PRINT "Sending "; txt$;  ELSE PRINT STRING$(80, " "); : LOCATE 25, 1

7
IF sent$ <> "" THEN PRINT "Sent: "; sent$; : sent$ = ""
PRINT " | ";
IF y = 1 THEN COLOR 6: PRINT "I";  ELSE COLOR 15: PRINT "I";
IF z = 1 THEN COLOR 6: PRINT " FD";  ELSE COLOR 15: PRINT " FD";

COLOR 15
VIEW PRINT 1 TO 23
IF clss <> 1 THEN LOCATE cury, curx
END SUB

