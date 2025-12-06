DEFINT A-Z

'Declare subs
DECLARE SUB EnterText (text$)
DECLARE SUB scend.recve ()
DECLARE SUB block ()
DECLARE SUB Blk ()
DECLARE SUB Noinput ()
DECLARE SUB GetInput1 ()
DECLARE SUB GetInput2 ()
DECLARE SUB no ()
DECLARE SUB redraw (Derek)
DECLARE SUB Filter (InString$)

'This makes the vasrible used in all subs
DIM SHARED REC
DIM SHARED Anti
DIM SHARED ComNub
DIM SHARED REC$
DIM SHARED BlockX
DIM SHARED BlkX
DIM SHARED NoInputX
DIM SHARED StopX
DIM SHARED comx
DIM SHARED comy
DIM SHARED Rep
DIM SHARED repx
DIM SHARED FileRec
DIM SHARED DX
DIM SHARED comm1
DIM SHARED comm2
DIM SHARED ByePass
DIM SHARED Final$
DIM SHARED yy
DIM LastOut$
DIM SHARED Clears
'ON ERROR GOTO 2 'Sets up error trap

COLOR 7, 1                      ' Set screen color.
CLS

quit$ = CHR$(0) + CHR$(16)      ' Value returned by INKEY$
                                ' when ALT+q is pressed.

' Set up prompt on bottom line of screen and turn cursor on:
redraw (0)
VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.

' Open com 2 or modem (9600 baud, no parity, 8-bit data,
' 1 stop bit, 256-byte input buffer):

1
Filenum = FREEFILE
4
'OPEN "COM2:9600,N,8,1," FOR RANDOM AS #1 LEN = 256'     locate
'PRINT "Connected to Modem"
'BEEP
LOCATE 3, 1
'****************************************************************************
'****************************************************************************
c = 79
d = 1
DO                              ' Main communications loop.
5
'*****************************************************************************
IF Clears = 1 THEN
Newx = POS(0)
Newy = CSRLIN
VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.
b = b + 1
IF b > 4 THEN
b = 1
c = c - 1
END IF
IF d <> 1 THEN
        IF c = 70 THEN c = 79: d = d + 1: LOCATE d - 1, 71, 0: PRINT " ";
ELSE
        IF c = 0 THEN c = 79: d = d + 1: LOCATE 1, 1, 0: PRINT " ";
END IF
IF d = 24 THEN
LOCATE 22, 71, 1
PRINT " ";
c = 79
d = 1
Clears = 0
GOTO 1123
END IF

FOR a = 1 TO 8000: NEXT

LOCATE d, c, 0

SELECT CASE b
        CASE 1
                PRINT "-";
        CASE 2
                PRINT "/";
        CASE 3
                PRINT "|";
        CASE 4
                PRINT "\";
END SELECT
LOCATE d, c + 1, 0
IF d = 1 AND c + 1 = 70 THEN
        COLOR 10, 1
        PRINT "º";
        COLOR 7, 1
ELSE
        PRINT " ";
END IF
1123
VIEW PRINT 2 TO 23              ' Print between lines 1 & 23.
LOCATE Newy, Newx, 1
END IF
KeyInput$ = INKEY$           ' Check the keyboard.
  
'***************************** Resend Mesage ********************************
IF Rep = 1 THEN              'This resend a message over and over again
        IF comm1 = 1 THEN
                PRINT #1, word$
                LastOut$ = word$
        END IF
       
        IF comm2 = 1 THEN
                PRINT #2, word$
                LastOut$ = word$
        END IF
END IF

'******************************* ASCII***************************************
IF StopX = 1 THEN               'ASCII prints random ASCII charetors
208
        a = INT(RND * 255) + 1
        IF a = 16 THEN 208
        IF a = 7 THEN 208
        IF a = 12 THEN 208
        IF a = 11 THEN 208
        IF a = 13 THEN 208
        IF a = 9 THEN 208
        IF a = 10 THEN 208
        IF a = 28 THEN 208
        IF a = 29 THEN 208
        IF a = 30 THEN 208
        IF a = 31 THEN 208
        IF a = 32 THEN 208
       
        IF comm1 = 1 THEN
        PRINT #1, CHR$(a); '" "; : PRINT A
        LastOut$ = CHR$(a)
        END IF

        IF comm2 = 1 THEN
        PRINT #2, CHR$(a); '" "; : PRINT A
        LastOut$ = CHR$(a)
        END IF
END IF

'*****************************************************************************
   SELECT CASE KeyInput$
        CASE quit$     ' Exit the loop if the user
                'PRINT #1, CHR$(16)
                EXIT DO                   ' pressed ALT+q.
       
        '******************* F12 ********************************************
        'F12 Open Com 1
        CASE CHR$(0) + ";"
        IF comm1 = 0 THEN
                ComNub = 2
                PRINT "Would you Like to do a continus retry(y/n):"
                Retry$ = INPUT$(1)
                IF UCASE$(Retry$) = "Y" THEN Retry = 1
                OPEN "COM1:9600,N,8,1," FOR RANDOM AS #1 LEN = 32767
                BEEP
                PRINT
                PRINT "Connected to other computer"
                comm1 = 1
                Retry = 0
                redraw (1)
        ELSE
                CLOSE #1
                comm1 = 0
                PRINT
                PRINT "Disconnected to other computer"
                redraw (1)
        END IF
       
        '******************* F11 ********************************************
        'F11 Starts and end the recording of the comunication to a file.
        CASE CHR$(0) + "…"
        IF FileRec <> 1 THEN
                FileRec = 1
                INPUT "Enter File Name:"; FileName$
                OPEN FileName$ FOR OUTPUT AS #4
        ELSE
                FileRec = 0
                CLOSE #4
        END IF
        redraw (1)
        
        '******************* F10 ********************************************
        'F10 Sends message recorded by F9
        CASE CHR$(0) + "D"
        PRINT #1, REC$
       
        '******************* F9 *********************************************
        'F9 Starts and stops record of a message to be sent.
        CASE CHR$(0) + "C"
        IF REC <> 1 THEN
                REC$ = ""
                REC = 1
                IF FileRec = 1 THEN
                        PRINT #4, ""
                        text$ = "My computer: Input Record ON."
                        PRINT #4, text$
                END IF
        ELSE
                REC = 0
                IF FileRec = 1 THEN
                        text$ = "My computer: Input Record Off."
                        PRINT #4, ""
                        PRINT #4, text$
                END IF
        END IF
        redraw (1)
       
        '******************* F8 *********************************************
        'F8
        CASE CHR$(0) + "<"
             IF comm2 = 0 THEN
                OPEN "COM2:9600,N,8,1,RB32767" FOR RANDOM AS #2 LEN = 256'     locate
                PRINT
                PRINT "Connected to Modem"
                BEEP
                comm2 = 1
                comx = 0
                comy = 3
                redraw (3)
             ELSE
                CLOSE #2
                comm2 = 0
                PRINT
                PRINT "Disconnected to Modem"
                redraw (1)
             END IF

       
        '******************* F7 *********************************************
        'F7
        CASE CHR$(0) + "A"
        IF BlkX <> 1 THEN
                INPUT ; repx
                BlkX = 1
                skip = 1
                IF FileRec = 1 THEN
                        text$ = "My computer: Deflector ON."
                        PRINT #4, ""
                        PRINT #4, text$
                END IF
        ELSE
                BlkX = 0
                skip = 0
                IF FileRec = 1 THEN
                        text$ = "My computer: Deflector OFF."
                        PRINT #4, ""
                        PRINT #4, text$
                END IF
        END IF
        redraw (1)
       
        '******************* F6 *********************************************
        'F6
        CASE CHR$(0) + "@"
        IF Rep <> 1 THEN
                EnterText "Enter masage to Repeatedly send:"
                word$ = Final$
                Final$ = ""
                Rep = 1
                IF FileRec = 1 THEN
                        text$ = "My computer: Repeatedly sending the Text (" + word$ + ")."
                        PRINT #4, ""
                        PRINT #4, text$
                END IF
        ELSE
                Rep = 0
                IF FileRec = 1 THEN
                        text$ = "My computer: Repeated sending OFF."
                        PRINT #4, ""
                        PRINT #4, text$
                END IF
        END IF
        redraw (1)
       
        '******************* F5 *********************************************
        'F5
        CASE CHR$(0) + "?"
        IF Anti = 1 THEN
         Anti = 0
        ELSE
         Anti = 1
        END IF
        IF comm2 THEN
         redraw (2)
        ELSE
         redraw (1)
        END IF
        '******************* F4 *********************************************
        'F4
        CASE CHR$(0) + ">"
                PRINT #1, CHR$(16)
                CLOSE #1
                        IF FileRec = 1 THEN
                        text$ = "My computer: Fake disconnect."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF

                DO
                LOOP UNTIL INKEY$ <> ""
                OPEN "COM1:9600,N,8,1" FOR RANDOM AS 1 LEN = 256
                redraw (1)
       
        '******************* F3 *********************************************
        'F3
        CASE CHR$(0) + "="
                IF StopX <> 0 THEN
                        StopX = 0
                        IF FileRec = 1 THEN
                        text$ = "My computer: ASCII ON."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF
               
                ELSE
                        StopX = 1
                        IF FileRec = 1 THEN
                        text$ = "My computer: ASCII OFF."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF

                END IF
                redraw (1)
       
        '******************* F2 *********************************************
        'F2
        CASE CHR$(0) + "B"
                IF DX <> 0 THEN
                        DX = 0
                        IF FileRec = 1 THEN
                        text$ = "My computer: Antideflector ON."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF
                       
                ELSE
                        DX = 1
                        IF FileRec = 1 THEN
                        text$ = "My computer: Antideflector OFF."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF
               
                END IF
                redraw (1)
               
        '******************* F1 *********************************************
        'F1
        CASE CHR$(0) + "†"
        IF comm2 = 1 THEN
        redraw (3)
        ELSE
        redraw (0)
        END IF
        '******************* Esc ********************************************
        'Esc
        CASE CHR$(27)
                IF NoInputX = 0 THEN
                        NoInputX = 1
                        IF FileRec = 1 THEN
                        text$ = "My computer: Noinput ON."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF
               
                ELSE
                        NoInputX = 0
                        IF FileRec = 1 THEN
                        text$ = "My computer: Noinput OFF."
                        PRINT #4, ""
                        PRINT #4, text$
                        END IF

                END IF
                redraw (1)
       
        '************************** Else ************************************
        CASE IS <> "" 'Otherwise, if the user has
                IF comm2 = 1 THEN
                        PRINT #2, KeyInput$;      ' pressed a key, send the
                        ComNub = 2
                END IF
                IF comm1 = 1 THEN
                        ComNub = 1
                        PRINT #1, KeyInput$;
                END IF
               
                LastOut$ = KeyInput$
                Filter KeyInput$
               
                IF FileRec = 1 THEN
                        PRINT #4, KeyInput$;
                END IF
                       
                        x = POS(0)
                        y = CSRLIN
                        IF y >= 23 AND x = 69 THEN
                         PRINT
                         redraw (1)
                        ELSE
                         IF x = 70 THEN LOCATE y + 1, 1
                        END IF
                backy = y - 1
                IF backy = 2 THEN backy = 3
                IF KeyInput$ = CHR$(29) AND x = 1 THEN
                 LOCATE backy, 70
                END IF

                PRINT KeyInput$;
                IF KeyInput$ = CHR$(13) AND y = 23 THEN
                IF comm2 = 1 THEN
                 redraw (2)
                ELSE
                 redraw (1)
                END IF
                END IF
END SELECT                       ' character typed to the modem.
   
   ' Check the modem. If characters are waiting (EOF(1) is
   ' true), get them and print them to the screen:



' LOC(1) gives the number of characters waiting:
'*********************
'IF Comm2 = 1 THEN
'IF NOT EOF(1) THEN
'IF BlockX = 1 THEN
'block
'END IF
'
'IF nox = 1 THEN
'no
'END IF
'
'IF BlkX = 1 THEN
'blk
'END IF
'
''IF skip <> 1 THEN
'        IF NoInputX = 1 THEN
'                Noinput
'        ELSE
'                GetInput (LastOut$)
'        END IF
''END IF
'
''IF stopx <> 1 THEN
''stopxx
''getinput
'END IF
'END IF
'
'IF Comm1 = 1 THEN
'   IF NOT EOF(1) THEN
'                  
'
'      ' LOC(1) gives the number of characters waiting:
'ByePass = 1
'IF BlockX = 1 THEN
'block
'END IF
'
'IF nox = 1 THEN
'no
'END IF
'
'IF BlkX = 1 THEN
'blk
'END IF
'
'IF skip <> 1 THEN
'        IF NoInputX = 1 THEN
'                Noinput
'        ELSE
'                GetInput (LastOut$)
'        END IF
'END IF
'
''IF stopx <> 1 THEN
''stopxx
''getinput
'END IF
'END IF
'ByePass = 0
IF BlkX = 1 THEN
 Blk
ELSE
 IF comm1 = 1 THEN
         IF NOT EOF(1) THEN GetInput1
 END IF
 IF comm2 = 1 THEN
         IF NOT EOF(2) THEN GetInput2
 END IF
END IF
LOOP
'*************************End Loop********************************************

'*************************END END END****************************************
3
IF FileRec = 1 THEN
        text$ = "Ending communications."
        PRINT #4, ""
        PRINT #4, text$
END IF

'CLOSE #1                          ' End communications.
'CLOSE #4
'BEEP
'END

SYSTEM
'************************ Error Handler **************************************
IF ERR <> 0 THEN
2
SELECT CASE ERR
        CASE 24
                'CLOSE #1
                IF ComNub = 1 THEN
                        IF Retry = 1 THEN RESUME
                        comm1 = 0
                        CLOSE #1
                        PRINT "Other computer has left"
                        redraw (1)
                        RESUME 5
                END IF
               
                IF FileRec = 1 THEN
                text$ = "My computer: Other computer not resonding."
                PRINT #4, ""
                PRINT #4, text$
                END IF
                INPUT "Other computer not resonding retry, or end.(R/E)"; a$
                redraw (0)
                a$ = UCASE$(a$)
                IF a$ = "R" THEN
                        RESUME 5
                END IF
        CASE 69
        IF FileRec = 1 THEN
        text$ = "Error 69."
        PRINT #4, ""
        PRINT #4, text$
        END IF
        IF comm1 = 1 THEN
        CLOSE #1
        OPEN "COM1:9600,N,8,1," FOR RANDOM AS #1 LEN = 256'     locate
        END IF
        IF comm2 = 1 THEN
        CLOSE #2
        OPEN "COM1:9600,N,8,1," FOR RANDOM AS #2 LEN = 256'     locate
        END IF
        RESUME 4
       
        CASE 52
        IF FileRec = 1 THEN
        text$ = "Error 52."
        PRINT #4, ""
        PRINT #4, text$
        END IF
        CLOSE #3
        IF comm1 = 1 THEN
        CLOSE #1
        OPEN "COM1:9600,N,8,1," FOR RANDOM AS #2 LEN = 256'     locate
        END IF
        IF comm2 = 1 THEN
        CLOSE #2
        OPEN "COM1:9600,N,8,1," FOR RANDOM AS #2 LEN = 256'     locate
        END IF
        RESUME 4
CASE ELSE
        IF FileRec = 1 THEN
        text$ = "Error " + STR$(ERR) + "."
        PRINT #4, ""
        PRINT #4, text$
        END IF

PRINT "Error #"; ERR; " has occured now exiting."
PRINT ERL;
SLEEP 0
END SELECT
END IF
'CLS
PRINT "You Quit first."
RESUME 3

SUB AntiDf
DO
 IF comm2 = 1 THEN
  null$ = INPUT$(LOC(2), #2)
  IF null$ = "" THEN
         exitanti = 1
  ELSE
         exitanti = 0
  END IF
 END IF

 IF comm1 = 1 THEN
  null$ = INPUT$(LOC(1), #1)
  IF null$ = "" THEN
         exitanti = 1
  ELSE
         exitanti = 0
  END IF
 END IF
LOOP UNTIL exitanti = 1

'redraw (2)
END SUB

SUB Blk
   
   FOR a = 1 TO repx
  
   IF comm2 = 1 THEN
   ComNub = 1
   ModemInput2$ = INPUT$(LOC(2), #2)
   PRINT #2, ModemInput2$;
   END IF
  
   IF comm1 = 1 THEN
   ComNub = 2
   ModemInput2$ = INPUT$(LOC(1), #1)
   PRINT #1, ModemInput2$;
   END IF
  
   NEXT
   LastOut$ = ModemInput2$
END SUB

SUB block
        ModemInput2$ = INPUT$(LOC(1), #1)
        Filter ModemInput2$        ' Filter out line feeds and
        IKEY$ = UCASE$(ModemInput2$)
END SUB

SUB EnterText (text$)
oldx = POS(0)
oldy = CSRLIN
VIEW PRINT 1 TO 23
c = 79
d = 1
DO
b = b + 1
IF b > 4 THEN
b = 1
c = c - 1
END IF
IF d <> 1 THEN
        IF c = 70 THEN c = 79: d = d + 1: LOCATE d - 1, 71, 0: PRINT " ";
ELSE
        IF c = 0 THEN c = 79: d = d + 1: LOCATE 1, 1, 0: PRINT " ";
END IF
IF d = 23 THEN 1124

'FOR a = 1 TO 15000: NEXT

LOCATE d, c

SELECT CASE b
        CASE 1
                PRINT "-";
        CASE 2
                PRINT "/";
        CASE 3
                PRINT "|";
        CASE 4
                PRINT "\";
END SELECT
IF c = 79 THEN
IF d <> 1 THEN LOCATE d - 1, 71, 0
ELSE
LOCATE d, c + 1, 0
END IF
IF d = 1 AND c + 1 = 70 THEN
        COLOR 10, 1
        PRINT "º";
        COLOR 7, 1
ELSE
        PRINT " ";
END IF

LOOP 'UNTIL INKEY$ = CHR$(27)
1124
LOCATE 22, 71, 1
PRINT " "



LOCATE 1, 1
PRINT text$;
LOCATE 1, 71
DO

Letters$ = INKEY$
IF Letters$ <> "" THEN
x = POS(0)
y = CSRLIN
IF y >= 23 AND x = 80 THEN
PRINT
redraw (1)
VIEW PRINT 1 TO 23
PRINT STRING$(69, " ");
LOCATE 1, 1
PRINT text$
LOCATE 23, 71
ELSE
        IF x = 80 THEN LOCATE y + 1, 71
END IF
IF INSTR(Letters$, CHR$(13)) THEN
        LOCATE oldy, oldx
        Clears = 1
        redraw (1)
        EXIT SUB
END IF

IF INSTR(Letters$, CHR$(8)) = 0 THEN
        Final$ = Final$ + Letters$
ELSE
        Letters$ = CHR$(29)
        Final$ = MID$(Final$, 1, (LEN(Final$) - 1))
END IF
PRINT Letters$;
END IF
Newx = POS(0)
Newy = CSRLIN

IF comm2 = 1 THEN
        ModemInput2$ = INPUT$(LOC(2), #2)
        ComNub = 2
        IF comm1 = 1 THEN
                PRINT #1, ModemInput1$;
        END IF
       
        IF LEN(ModemInput2$) <> 0 THEN
        DO
        a = a + 1
        Filter (ModemInput2$)
        LOCATE oldy, oldx
        IF oldy >= 23 AND oldx = 69 THEN
                PRINT
                redraw (1)
        ELSE
                IF oldx = 70 THEN LOCATE oldy + 1, 1
        END IF
        backy = oldy - 1
        IF backy = 2 THEN backy = 3
        IF KeyInput$ = CHR$(29) AND x = 1 THEN
                LOCATE backy, 70
        END IF
        IF comm1 = 1 THEN PRINT #2, MID$(ModemInput2$, a, 1);
        PRINT MID$(ModemInput2$, a, 1);
        oldx = POS(0)
        oldy = CSRLIN
        LOOP UNTIL a = LEN(ModemInput2$)
        a = 0
        LOCATE Newy, Newx
        END IF
END IF

IF comm1 = 1 THEN
        ModemInput1$ = INPUT$(LOC(1), #1)
        ComNub = 1
        IF comm2 = 1 THEN
                PRINT #2, ModemInput1$;
        END IF
       
        IF LEN(ModemInput1$) <> 0 THEN
        DO
        a = a + 1
        Filter (ModemInput1$)
        LOCATE oldy, oldx
        IF oldy >= 23 AND oldx = 69 THEN
                PRINT
                redraw (1)
        ELSE
                IF oldx = 70 THEN LOCATE oldy + 1, 1
        END IF
        backy = oldy - 1
        IF backy = 2 THEN backy = 3
        IF KeyInput$ = CHR$(29) AND x = 1 THEN
                LOCATE backy, 70
        END IF
     
        PRINT MID$(ModemInput1$, a, 1);
        IF comm2 = 1 THEN PRINT #1, MID$(ModemInput1$, a, 1);
        oldx = POS(0)
        oldy = CSRLIN
        LOOP UNTIL a = LEN(ModemInput1$)
        a = 0
        LOCATE Newy, Newx
        END IF
END IF
LOOP
END SUB

'
' ========================= FILTER ==========================
'     Filters characters in an input string.
' ============================================================
'
SUB Filter (InString$) STATIC

  ' Look for backspace characters and recode them to
   ' CHR$(29) (the LEFT cursor key):
  
   'DO
   '   Del = INSTR(InString$, CHR$(83))
   '   IF Del THEN
   '      MID$(InString$, Del) = CHR$(0) + "S"
   '   END IF
   'LOOP WHILE Del
  
   DO                                                         'open
      BackSpace = INSTR(InString$, CHR$(8))
      IF BackSpace THEN
         MID$(InString$, BackSpace) = CHR$(29)
      END IF
   LOOP WHILE BackSpace

   ' Look for line-feed characters and remove any found:
   DO
      LineFeed = INSTR(InString$, CHR$(10))
      IF LineFeed THEN
        IF FileRec = 1 THEN
        PRINT #4, ""
        PRINT #4, ""
        END IF
        
         InString$ = LEFT$(InString$, LineFeed - 1) + MID$(InString$, LineFeed + 1)
         yy = 1
     END IF
   LOOP WHILE LineFeed

END SUB

SUB GetInput1

IF comm1 = 1 THEN
        ModemInput1$ = INPUT$(LOC(1), #1)
       
        ComNub = 2
        IF comm2 = 1 THEN
                PRINT #2, ModemInput1$;
        END IF
       
        IF LEN(ModemInput1$) <> 0 THEN
                DO
                Filter ModemInput1$        ' Filter out line feeds and
                IF ModemInput1$ = CHR$(16) THEN
                        redraw (1)
                        CLOSE #1
                        EXIT SUB
                END IF
                a = a + 1
                x = POS(0)
                y = CSRLIN
                IF y >= 23 AND x = 69 THEN
                        PRINT
                        redraw (1)
                ELSE
                        IF x = 69 THEN LOCATE y + 1, 1
                END IF
                backy = y - 1
                IF backy = 2 THEN backy = 3
                IF ModemInput1$ = CHR$(29) AND x = 1 THEN LOCATE backy, 70
                PRINT MID$(ModemInput1$, a, 1);        ' backspaces, then print.
                IF ModemInput1$ = CHR$(13) AND y = 23 THEN redraw (1)
                LOOP UNTIL a = LEN(ModemInput1$)
        END IF
END IF

IF REC = 1 THEN
      IF comm2 = 1 THEN
        REC$ = REC$ + ModemInput2$
      END IF
      IF comm1 = 1 THEN
        REC$ = REC$ + ModemInput1$
      END IF
END IF
    

      
       
IF FileRec = 1 THEN
        IF comm2 = 1 THEN
                PRINT #4, MID$(ModemInput2$, a, 1);
        END IF
        IF comm1 = 1 THEN
                PRINT #4, MID$(ModemInput1$, a, 1);
        END IF
END IF
      

'IF FileRec = 1 THEN
'        PRINT #4, ModemInput2$;
'        IF comm1 = 1 THEN
'                ComNub = 2
'                PRINT #2, ModemInput2$;
'        END IF
'
'        IF comm2 = 1 THEN
'                ComNub = 2
'                PRINT #2, ModemInput2$;
'        END IF
'
'END IF
        
END SUB

SUB GetInput2
IF comm2 = 1 THEN
        xxa = POS(0)
        yya = CSRLIN
        VIEW PRINT 3 TO 12
        ModemInput2$ = INPUT$(LOC(2), #2)
        ComNub = 2
        IF comm1 = 1 THEN
                PRINT #1, ModemInput2$;
        END IF
      
        IF LEN(ModemInput2$) <> 0 THEN
                DO
                Filter ModemInput2$        ' Filter out line feeds and
                IF ModemInput2$ = CHR$(16) THEN
                        redraw (3)
                        CLOSE #2
                        EXIT SUB
                END IF
                a = a + 1
                x = comx
                y = comy
                'IF y >= 12 AND x = 69 THEN
                '        PRINT
                '        redraw (3)
                '        comx = 1
                '        comy = 12
                'ELSE
                        IF x = 69 THEN
                                LOCATE y + 1, 1
                                comy = comy + 1
                                comx = 0
                        END IF
                        comx = comx + 1
               ' END IF
              
                backy = y - 1
                IF backy = 2 THEN backy = 3
              
                IF ModemInput2$ = CHR$(29) AND x = 1 THEN LOCATE backy, 70
                IF x >= 68 AND y >= 11 THEN
                LOCATE comy, comx
                PRINT
                comx = 1
                comy = 12
                LOCATE comy, comx
                redraw (4)
                ELSE
                IF comy >= 13 THEN comy = 12
                LOCATE comy, comx
                END IF
                PRINT MID$(ModemInput2$, a, 1);        ' backspaces, then print.
                IF ModemInput2$ = CHR$(13) AND y = 13 THEN redraw (3)
              
                LOOP UNTIL a >= LEN(ModemInput2$)
        END IF
END IF
VIEW PRINT 14 TO 23
LOCATE yya, xxa
END SUB

SUB no
'                IF IKEY$ <> "" THEN
'                        IF IKEY$ <> NAME$(COUNT) THEN
'                                IF COUNT > 1 THEN
'                                DEREK$ = DEREK$ + IKEY$
'                                PRINT DEREK$;
'                                COUNT = 1
'                                DEREK$ = ""
'                                ELSE
'                                COUNT = 1
'                                PRINT IKEY$;
'                                END IF
'                        END IF
'                END IF
'                IF IKEY$ = NAME$(COUNT) THEN
'                        DEREK$ = DEREK$ + IKEY$
 '                       COUNT = COUNT + 1
 '                       IF COUNT > 6 THEN
 ''                               DEREK$ = ""
 '                               COUNT = 1
 '                               nox = 1
 '                       END IF
 '               END IF
 '
END SUB

SUB Noinput

IF comm2 = 1 THEN
        nullModemInput2$ = INPUT$(LOC(2), #2)
END IF
IF comm1 = 1 THEN
        nullModemInput1$ = INPUT$(LOC(1), #1)
END IF

END SUB

SUB PrintInput

END SUB

SUB redraw (Derek)

SELECT CASE Derek
       
        CASE 0
                CLS
                x = POS(0)
                y = CSRLIN
                VIEW PRINT 1 TO 25
                LOCATE 24, 1, 1
                COLOR 10, 1
                PRINT STRING$(69, "Í");
                PRINT "Î";
                PRINT STRING$(10, "Í");
                LOCATE 25, 1
                COLOR 7, 1
                IF NoInputX = 1 THEN COLOR 10, 1
                PRINT "NI"; ' NoInputX;
                COLOR 7, 1

                IF Anti = 1 THEN COLOR 10, 1
                PRINT " ADF"; Anti;
                COLOR 7, 1

                IF StopX = 1 THEN COLOR 10, 1
                PRINT " ASCII"; ' StopX;
                COLOR 7, 1

                IF Rep = 1 THEN COLOR 10, 1
                PRINT " RS"; ' Rep;
                COLOR 7, 1

                IF BlkX = 1 THEN COLOR 10, 1
                PRINT " DF"; ' BlkX;
                COLOR 7, 1
               
                IF REC = 1 THEN COLOR 10, 1
                PRINT " Rec"; 'REC;
                COLOR 7, 1
               
                COLOR 3, 1
                PRINT " Press F1 for help";
                COLOR 7, 1
               
                COLOR 10, 1
               
                LOCATE 25, 70
                PRINT "º";
                COLOR 7, 1
                IF comm1 = 1 THEN
                        LOCATE 25, 71
                        COLOR 10, 1
                        PRINT "Com1";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 71
                        PRINT "Com1";
                END IF

                IF comm2 = 1 THEN
                        LOCATE 25, 75
                        COLOR 10, 1
                        PRINT " Com2";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 75
                        PRINT " Com2";
                END IF

                COLOR 10, 1
                FOR a = 3 TO 23
                        LOCATE a, 70
                        PRINT "º";
                NEXT

                LOCATE 1, 70
                PRINT "º";
                LOCATE 2, 1
                PRINT STRING$(69, "Í");
                PRINT "¹";
                COLOR 7, 1
                VIEW PRINT 3 TO 23              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.

                IF Derek = 1 THEN
                        LOCATE y, x
                ELSE
                        LOCATE 3, 1
                END IF
       
        CASE 1
                x = POS(0)
                y = CSRLIN
                VIEW PRINT 1 TO 25
                LOCATE 24, 1, 1
                COLOR 10, 1
                PRINT STRING$(69, "Í");
                PRINT "Î";
                PRINT STRING$(10, "Í");
                LOCATE 25, 1
                COLOR 7, 1
                IF NoInputX = 1 THEN COLOR 10, 1
                PRINT "NI"; ' NoInputX;
                COLOR 7, 1

                IF Anti = 1 THEN COLOR 10, 1
                PRINT " ADF"; Anti;
                COLOR 7, 1

                IF StopX = 1 THEN COLOR 10, 1
                PRINT " ASCII"; ' StopX;
                COLOR 7, 1

                IF Rep = 1 THEN COLOR 10, 1
                PRINT " RS"; ' Rep;
                COLOR 7, 1

                IF BlkX = 1 THEN COLOR 10, 1
                PRINT " DF"; ' BlkX;
                COLOR 7, 1

                IF REC = 1 THEN COLOR 10, 1
                PRINT " Rec"; 'REC;
                COLOR 7, 1

                COLOR 10, 1
                LOCATE 25, 70
                PRINT "º";
                COLOR 7, 1
               
                IF comm1 = 1 THEN
                        LOCATE 25, 71
                        COLOR 10, 1
                        PRINT "Com1";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 71
                        PRINT "Com1";
                END IF

                IF comm2 = 1 THEN
                        LOCATE 25, 75
                        COLOR 10, 1
                        PRINT " Com2";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 75
                        PRINT " Com2";
                END IF
                COLOR 10, 1
                FOR a = 3 TO 23
                        LOCATE a, 70
                        PRINT "º";
                NEXT

                LOCATE 1, 70
                PRINT "º";
                LOCATE 2, 1
                PRINT STRING$(69, "Í");
                PRINT "¹";
                COLOR 7, 1
                VIEW PRINT 3 TO 23              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.

                IF Derek = 1 THEN
                        LOCATE y, x
                ELSE
                        LOCATE 3, 1
                END IF
        CASE 2
                x = POS(0)
                y = CSRLIN
                VIEW PRINT 3 TO 25
                LOCATE 24, 1, 1
                COLOR 10, 1
                PRINT STRING$(69, "Í");
                PRINT "Î";
                PRINT STRING$(10, "Í");
                LOCATE 25, 1
                COLOR 7, 1
                IF NoInputX = 1 THEN COLOR 10, 1
                PRINT "NI"; ' NoInputX;
                COLOR 7, 1

                IF Anti = 1 THEN COLOR 10, 1
                PRINT " ADF"; Anti;
                COLOR 7, 1

                IF StopX = 1 THEN COLOR 10, 1
                PRINT " ASCII"; ' StopX;
                COLOR 7, 1

                IF Rep = 1 THEN COLOR 10, 1
                PRINT " RS"; ' Rep;
                COLOR 7, 1

                IF BlkX = 1 THEN COLOR 10, 1
                PRINT " DF"; ' BlkX;
                COLOR 7, 1


                IF REC = 1 THEN COLOR 10, 1
                PRINT " Rec"; 'REC;
                COLOR 7, 1
                COLOR 10, 1
                LOCATE 25, 70
                PRINT "º";
                COLOR 7, 1
                IF comm1 = 1 THEN
                        LOCATE 25, 71
                        COLOR 10, 1
                        PRINT "Com1";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 71
                        PRINT "Com1";
                END IF

                IF comm2 = 1 THEN
                        LOCATE 25, 75
                        COLOR 10, 1
                        PRINT " Com2";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 75
                        PRINT " Com2";
                END IF

                COLOR 10, 1
                FOR a = 3 TO 23
                        LOCATE a, 70
                        IF a = 13 THEN
                         PRINT "¹";
                        ELSE
                         PRINT "º";
                        END IF
                NEXT
                VIEW PRINT 1 TO 25
                LOCATE 13, 1
                PRINT STRING$(69, "Í");
                LOCATE 1, 70
                PRINT "º";
                LOCATE 2, 1
                PRINT STRING$(69, "Í");
                PRINT "¹";
                COLOR 7, 1
                VIEW PRINT 14 TO 23              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.

                IF Derek = 2 THEN
                        LOCATE y, x
                ELSE
                        LOCATE 14, 1
                END IF

         
         
          CASE 3
                
                x = POS(0)
                y = CSRLIN
                VIEW PRINT 1 TO 25
                CLS
                LOCATE 24, 1, 1
                COLOR 10, 1
                PRINT STRING$(69, "Í");
                PRINT "Î";
                PRINT STRING$(10, "Í");
                LOCATE 25, 1
                COLOR 7, 1
                IF NoInputX = 1 THEN COLOR 10, 1
                PRINT "NI"; ' NoInputX;
                COLOR 7, 1

                IF Anti = 1 THEN COLOR 10, 1
                PRINT " ADF"; Anti;
                COLOR 7, 1

                IF StopX = 1 THEN COLOR 10, 1
                PRINT " ASCII"; ' StopX;
                COLOR 7, 1

                IF Rep = 1 THEN COLOR 10, 1
                PRINT " RS"; ' Rep;
                COLOR 7, 1

                IF BlkX = 1 THEN COLOR 10, 1
                PRINT " DF"; ' BlkX;
                COLOR 7, 1


                IF REC = 1 THEN COLOR 10, 1
                PRINT " Rec"; 'REC;
                COLOR 7, 1
                COLOR 10, 1
                LOCATE 25, 70
                PRINT "º";
                COLOR 7, 1
                IF comm1 = 1 THEN
                        LOCATE 25, 71
                        COLOR 10, 1
                        PRINT "Com1";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 71
                        PRINT "Com1";
                END IF

                IF comm2 = 1 THEN
                        LOCATE 25, 75
                        COLOR 10, 1
                        PRINT " Com2";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 75
                        PRINT " Com2";
                END IF

                COLOR 10, 1
                FOR a = 3 TO 23
                        LOCATE a, 70
                        IF a = 13 THEN
                         PRINT "¹";
                        ELSE
                         PRINT "º";
                        END IF
                NEXT
                LOCATE 13, 1
                PRINT STRING$(69, "Í");
                LOCATE 1, 70
                PRINT "º";
                LOCATE 2, 1
                PRINT STRING$(69, "Í");
                PRINT "¹";
                COLOR 7, 1
                VIEW PRINT 14 TO 23              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.

                IF Derek = 1 THEN
                        LOCATE y, x
                ELSE
                        LOCATE 14, 1
                END IF
           CASE 4
                x = POS(0)
                y = CSRLIN
                VIEW PRINT 3 TO 25
                LOCATE 24, 1, 1
                COLOR 10, 1
                PRINT STRING$(69, "Í");
                PRINT "Î";
                PRINT STRING$(10, "Í");
                LOCATE 25, 1
                COLOR 7, 1
                IF NoInputX = 1 THEN COLOR 10, 1
                PRINT "NI"; ' NoInputX;
                COLOR 7, 1

                IF Anti = 1 THEN COLOR 10, 1
                PRINT " ADF"; Anti;
                COLOR 7, 1

                IF StopX = 1 THEN COLOR 10, 1
                PRINT " ASCII"; ' StopX;
                COLOR 7, 1

                IF Rep = 1 THEN COLOR 10, 1
                PRINT " RS"; ' Rep;
                COLOR 7, 1

                IF BlkX = 1 THEN COLOR 10, 1
                PRINT " DF"; ' BlkX;
                COLOR 7, 1


                IF REC = 1 THEN COLOR 10, 1
                PRINT " Rec"; 'REC;
                COLOR 7, 1
                COLOR 10, 1
                LOCATE 25, 70
                PRINT "º";
                COLOR 7, 1
                IF comm1 = 1 THEN
                        LOCATE 25, 71
                        COLOR 10, 1
                        PRINT "Com1";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 71
                        PRINT "Com1";
                END IF

                IF comm2 = 1 THEN
                        LOCATE 25, 75
                        COLOR 10, 1
                        PRINT " Com2";
                        COLOR 7, 1
                ELSE
                        LOCATE 25, 75
                        PRINT " Com2";
                END IF

                COLOR 10, 1
                FOR a = 3 TO 23
                        LOCATE a, 70
                        IF a = 13 THEN
                         PRINT "¹";
                        ELSE
                         PRINT "º";
                        END IF
                NEXT
                VIEW PRINT 1 TO 25
                LOCATE 13, 1
                PRINT STRING$(69, "Í");
                LOCATE 1, 70
                PRINT "º";
                LOCATE 2, 1
                PRINT STRING$(69, "Í");
                PRINT "¹";
                COLOR 7, 1
                VIEW PRINT 3 TO 12              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.

                IF Derek = 4 THEN
                        LOCATE y, x
                ELSE
                        LOCATE 14, 1
                END IF

        
        

END SELECT
END SUB

SUB stopxx
'        IKEY$ = UCASE$(ModemInput2$)
'                IF IKEY$ <> "" THEN
'                        IF IKEY$ <> NAME$(COUNT) THEN
'                                COUNT = 1
'                        END IF
'                END IF
'                IF IKEY$ = NAME$(COUNT) THEN
'                        COUNT = COUNT + 1
'                        IF COUNT > 6 THEN stopx = 1
'               END IF

END SUB

