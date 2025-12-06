DEFINT A-Z

'Declare subs
DECLARE SUB scend.recve ()
DECLARE SUB block ()
DECLARE SUB blk ()
DECLARE SUB Noinput ()
DECLARE SUB getinput (LastOut$)
DECLARE SUB no ()
DECLARE SUB ReDraw (Derek)
DECLARE SUB FILTER (InString$)

'This makes the vasrible used in all subs
DIM SHARED REC
DIM SHARED ComNub
DIM SHARED REC$
DIM SHARED BlockX
DIM SHARED BlkX
DIM SHARED NoInputX
DIM SHARED StopX
DIM SHARED Rep
DIM SHARED repx
DIM SHARED FileRec
DIM SHARED DX
DIM SHARED comm1
DIM SHARED byepass
DIM SHARED yy
DIM LastOut$

ON ERROR GOTO 2 'Sets up error trap

COLOR 7, 1                      ' Set screen color.
CLS

quit$ = CHR$(0) + CHR$(16)      ' Value returned by INKEY$
                                ' when ALT+q is pressed.

' Set up prompt on bottom line of screen and turn cursor on:
ReDraw (0)
VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.

' Open com 2 or modem (9600 baud, no parity, 8-bit data,
' 1 stop bit, 256-byte input buffer):

1
Filenum = FREEFILE
4
OPEN "COM2:9600,N,8,1," FOR RANDOM AS #1 LEN = 256'     locate
PRINT "Connected to Modem"
BEEP

'****************************************************************************
'****************************************************************************
DO                              ' Main communications loop.
5
KeyInput$ = INKEY$           ' Check the keyboard.
  
'***************************** Resend Mesage ********************************
IF Rep = 1 THEN              'This resend a message over and over again
        IF comm1 = 1 THEN
        PRINT #1, word$
        LastOut$ = word$
        END IF
       
        IF comm2 = 1 THEN
        PRINT #3, word$
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
        PRINT #3, CHR$(a); '" "; : PRINT A
        LastOut$ = CHR$(a)
        END IF
END IF

'*****************************************************************************
   SELECT CASE KeyInput$
        CASE quit$     ' Exit the loop if the user
                PRINT #1, CHR$(16)
                EXIT DO                   ' pressed ALT+q.
       
        '******************* F12 ********************************************
        'F12 Open Com 1
        CASE CHR$(0) + "†"
        IF comm1 = 0 THEN
                ComNub = 2
                OPEN "COM1:9600,N,8,1," FOR RANDOM AS #3 LEN = 32767
                PRINT "Connected to other computer"
                comm1 = 1
        ELSE
                CLOSE #3
                comm1 = 0
                PRINT "Disconnected to other computer"
        END IF
       
        '******************* F11 ********************************************
        'F11 Starts and end the recording of the comunication to a file.
        CASE CHR$(0) + "…"
        IF FileRec <> 1 THEN
                FileRec = 1
                INPUT "Enter File Name:"; FileName$
                OPEN FileName$ FOR OUTPUT AS #2
        ELSE
                FileRec = 0
                CLOSE #2
        END IF
        ReDraw (1)
        
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
                        PRINT #2, ""
                        TEXT$ = "My computer: Input Record ON."
                        PRINT #2, TEXT$
                END IF
        ELSE
                REC = 0
                IF FileRec = 1 THEN
                        TEXT$ = "My computer: Input Record Off."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                END IF
        END IF
        ReDraw (1)
       
        '******************* F8 *********************************************
        'F8
        CASE CHR$(0) + "B"
             IF comm2 = 0 THEN
                OPEN "COM2:9600,N,8,1," FOR RANDOM AS #1 LEN = 256'     locate
                PRINT "Connected to Modem"
                BEEP
                comm2 = 1
             ELSE
                CLOSE #1
                comm2 = 0
                PRINT "Disconnected to Modem"
             END IF

       
        '******************* F7 *********************************************
        'F7
        CASE CHR$(0) + "A"
        IF BlkX <> 1 THEN
                INPUT ; repx
                BlkX = 1
                skip = 1
                IF FileRec = 1 THEN
                        TEXT$ = "My computer: Deflector ON."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                END IF
        ELSE
                BlkX = 0
                skip = 0
                IF FileRec = 1 THEN
                        TEXT$ = "My computer: Deflector OFF."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                END IF
        END IF
        ReDraw (1)
       
        '******************* F6 *********************************************
        'F6
        CASE CHR$(0) + "@"
        IF Rep <> 1 THEN
                INPUT ; word$
                Rep = 1
                IF FileRec = 1 THEN
                        TEXT$ = "My computer: Repeatedly sending the Text (" + word$ + ")."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                END IF
        ELSE
                Rep = 0
                IF FileRec = 1 THEN
                        TEXT$ = "My computer: Repeated sending OFF."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                END IF
        END IF
        ReDraw (1)
       
        '******************* F5 *********************************************
        'F5
        'CASE CHR$(0) + "?"
        'scend.recve

        '******************* F4 *********************************************
        'F4
        CASE CHR$(0) + ">"
                PRINT #1, CHR$(16)
                CLOSE #1
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: Fake disconnect."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF

                DO
                LOOP UNTIL INKEY$ <> ""
                OPEN "COM1:9600,N,8,1" FOR RANDOM AS 1 LEN = 256
                ReDraw (1)
       
        '******************* F3 *********************************************
        'F3
        CASE CHR$(0) + "="
                IF StopX <> 0 THEN
                        StopX = 0
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: ASCII ON."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF
               
                ELSE
                        StopX = 1
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: ASCII OFF."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF

                END IF
                ReDraw (1)
       
        '******************* F2 *********************************************
        'F2
        CASE CHR$(0) + "<"
                IF DX <> 0 THEN
                        DX = 0
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: Antideflector ON."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF
                       
                ELSE
                        DX = 1
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: Antideflector OFF."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF
               
                END IF
                ReDraw (1)
               
        '******************* F1 *********************************************
        'F1
        CASE CHR$(0) + ";"
        ReDraw (0)

        '******************* Esc ********************************************
        'Esc
        CASE CHR$(27)
                IF NoInputX = 0 THEN
                        NoInputX = 1
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: Noinput ON."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF
               
                ELSE
                        NoInputX = 0
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: Noinput OFF."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF

                END IF
                ReDraw (1)
       
        '************************** Else ************************************
        CASE IS <> "" 'Otherwise, if the user has
                PRINT #1, KeyInput$;      ' pressed a key, send the
                IF comm1 = 1 THEN
                        ComNub = 2
                        PRINT #3, KeyInput$;
                END IF
                LastOut$ = KeyInput$
                FILTER KeyInput$
                IF FileRec = 1 THEN
                        PRINT #2, KeyInput$;
                END IF
                        x = POS(0)
                        y = CSRLIN
                        IF y >= 23 AND x = 69 THEN
                        PRINT
                        ReDraw (1)
                        ELSE
                        IF x = 70 THEN LOCATE y + 1, 1
                        END IF
                backy = y - 1
                IF backy = 0 THEN backy = 1
                IF KeyInput$ = CHR$(29) AND x = 1 THEN
                LOCATE backy, 70
                END IF

                PRINT KeyInput$;
                IF yy = 1 THEN
                ReDraw (1)
                yy = 0
                END IF
END SELECT                       ' character typed to the modem.
   
   ' Check the modem. If characters are waiting (EOF(1) is
   ' true), get them and print them to the screen:


IF NOT EOF(1) THEN
' LOC(1) gives the number of characters waiting:
'*********************
IF comm2 = 1 THEN
IF BlockX = 1 THEN
block
END IF

IF nox = 1 THEN
no
END IF

IF BlkX = 1 THEN
blk
END IF

'IF skip <> 1 THEN
        IF NoInputX = 1 THEN
                Noinput
        ELSE
                getinput (LastOut$)
        END IF
'END IF

'IF stopx <> 1 THEN
'stopxx
'getinput
END IF
END IF

IF comm1 = 1 THEN
   IF NOT EOF(3) THEN
                               
    
      ' LOC(1) gives the number of characters waiting:
byepass = 1
IF BlockX = 1 THEN
block
END IF

IF nox = 1 THEN
no
END IF

IF BlkX = 1 THEN
blk
END IF

IF skip <> 1 THEN
        IF NoInputX = 1 THEN
                Noinput
        ELSE
                getinput (LastOut$)
        END IF
END IF

'IF stopx <> 1 THEN
'stopxx
'getinput
END IF
END IF
byepass = 0
LOOP
'*************************End Loop********************************************
IF ERR <> 0 THEN
2
SELECT CASE ERR
        CASE 24
                'CLOSE #1
                IF ComNub = 2 THEN
                        comm1 = 0
                        CLOSE #3
                        PRINT "Other computer has left"
                        RESUME 5
                END IF
               
                IF FileRec = 1 THEN
                TEXT$ = "My computer: Other computer not resonding."
                PRINT #2, ""
                PRINT #2, TEXT$
                END IF
                INPUT "Other computer not resonding retry, or end.(R/E)"; a$
                ReDraw (0)
                a$ = UCASE$(a$)
                IF a$ = "R" THEN
                        RESUME 5
                END IF
        CASE 69
        IF FileRec = 1 THEN
        TEXT$ = "Error 69."
        PRINT #2, ""
        PRINT #2, TEXT$
        END IF
        CLOSE #1
        RESUME 4
        CASE 52
        IF FileRec = 1 THEN
        TEXT$ = "Error 52."
        PRINT #2, ""
        PRINT #2, TEXT$
        END IF
        CLOSE #1
        RESUME 4
CASE ELSE
        IF FileRec = 1 THEN
        TEXT$ = "Error " + STR$(ERR) + "."
        PRINT #2, ""
        PRINT #2, TEXT$
        END IF

PRINT "Error #"; ERR; " has occured now exiting."
PRINT ERL;
SLEEP 0
END SELECT
END IF
CLS
PRINT "You Quit first."
3
IF FileRec = 1 THEN
TEXT$ = "Ending communications."
PRINT #2, ""
PRINT #2, TEXT$
END IF
CLOSE #1                          ' End communications.
CLOSE #2
BEEP
END

SUB blk
   ModemInput$ = INPUT$(LOC(1), #1)
   FOR a = 1 TO repx
  
   IF comm2 = 1 THEN
   ComNub = 1
   PRINT #1, ModemInput$;
   END IF
  
   IF comm1 = 1 THEN
   ComNub = 2
   PRINT #3, ModemInput$;
   END IF
  
   NEXT
   LastOut$ = ModemInput$
END SUB

SUB block
        ModemInput$ = INPUT$(LOC(1), #1)
        FILTER ModemInput$        ' Filter out line feeds and
        IKEY$ = UCASE$(ModemInput$)
END SUB

'
' ========================= FILTER ==========================
'     Filters characters in an input string.
' ============================================================
'
SUB FILTER (InString$) STATIC

  ' Look for backspace characters and recode them to
   ' CHR$(29) (the LEFT cursor key):
  
   DO
      Del = INSTR(InString$, CHR$(83))
      IF Del THEN
         MID$(InString$, Del) = CHR$(0) + "S"
      END IF
   LOOP WHILE Del
  
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
        PRINT #2, ""
        PRINT #2, ""
        END IF
        
         InString$ = LEFT$(InString$, LineFeed - 1) + MID$(InString$, LineFeed + 1)
         yy = 1
      END IF
   LOOP WHILE LineFeed

END SUB

SUB getinput (LastOutx$)
      IF byepass <> 1 THEN
      IF comm2 = 1 THEN
      ModemInput$ = INPUT$(LOC(1), #1)
      END IF
      ELSE
      IF comm1 = 1 THEN
        ModemInput2$ = INPUT$(LOC(3), #3)
      END IF
      END IF
     
      IF REC = 1 THEN
      IF comm2 = 1 THEN
      REC$ = REC$ + ModemInput$
      END IF
     
      IF comm1 = 1 THEN
      REC$ = REC$ + ModemInput2$
      END IF
      END IF
     
      FILTER ModemInput$        ' Filter out line feeds and
      FILTER ModemInput2$
       
        'IF ModemInput$ = CHR$(16) THEN
        '        ReDraw (0)
        '        PRINT "Other computer has loged off."
        '        INPUT "Do you?(y/n)"; a$
        '        a$ = UCASE$(a$)
        '        IF a$ = "T" THEN PRINT #1, CHR$(7)
        '                IF a$ = "Y" THEN
        '                PRINT "Press any key to end"
        '                BEEP
        '                SLEEP 0
        '        'GOTO 3
        '        END IF
        'ELSE
                IF DX = 1 THEN
                FOR a = 1 TO LEN(ModemInput$)
                        b = a - 1
                        IF b = 0 THEN b = 1
                        IF LastOutx$ = MID$(ModemInput$, a, 1) OR MID$(ModemInput$, a, 1) = MID$(ModemInput$, b, 1) THEN
                        ELSE
                                IF FileRec = 1 THEN
                                PRINT #2, MID$(ModemInput$, a, 1);
                                IF comm1 = 1 THEN
                                PRINT #2, MID$(ModemInput2$, a, 1);
                                END IF
                                END IF
                                IF comm1 = 1 THEN
                                ComNub = 2
                                PRINT #3, MID$(ModemInput$, a, 1);
                                END IF
                                IF comm1 = 1 THEN
                        x = POS(0)
                        y = CSRLIN
                        IF x = 69 THEN LOCATE y, 1
                                PRINT MID$(ModemInput2$, a, 1);
                                END IF
                        x = POS(0)
                        y = CSRLIN
                        IF x = 69 THEN LOCATE y, 1
                               
                                PRINT MID$(ModemInput$, a, 1);        ' backspaces, then print.                 'hhjjjk
                        END IF
                NEXT
               
                ELSE
                        IF FileRec = 1 THEN
                        PRINT #2, ModemInput$;
                                IF comm1 = 1 THEN
                                ComNub = 2
                                PRINT #3, ModemInput$;
                                END IF
                       
                        END IF
                       
                        IF comm1 = 1 THEN
                        x = POS(0)
                        y = CSRLIN
                        IF x = 69 THEN LOCATE y, 1
                        PRINT ModemInput2$;
                        PRINT #1, ModemInput2$;
                        ComNub = 2
                        PRINT #3, ModemInput$;
                        END IF
                        'IF byepass <> 1 THEN
                        PRINT ModemInput$;        ' backspaces, then print.
                        'END IF
                END IF
        'END IF
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
nullmodeminput$ = INPUT$(LOC(1), #1)
END SUB

SUB PrintInput

END SUB

SUB ReDraw (Derek)
IF Derek = 0 THEN
CLS
ELSE
x = POS(0)
y = CSRLIN
END IF

VIEW PRINT 1 TO 25
LOCATE 24, 1, 1
PRINT STRING$(80, "_");
LOCATE 25, 1

IF NoInputX = 1 THEN COLOR 10, 1
PRINT "NI"; ' NoInputX;
COLOR 7, 1

IF DX = 1 THEN COLOR 10, 1
PRINT " ADF"; ' DX;
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

FOR a = 1 TO 23
LOCATE a, 70
PRINT "|";
NEXT

VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.

IF Derek = 1 THEN
LOCATE y, x
END IF

END SUB

SUB scend.recve
INPUT "Enter file name to send: ", FileName$
OPEN FileName$ FOR BINARY AS #4
Max = 56
'DO WHILE NOT EOF(4)
'Max = Max + 1
'LOOP
'  Read and print contents of each record.
FOR I = 1 TO Max
   INPUT #4, FileRec$
   ComNub = 2
   PRINT #3, FileRec$
NEXT I
FileRec$ = "nelson"
ComNub = 2
PRINT #3, FileRec$
CLOSE #4
END SUB

SUB stopxx
'        IKEY$ = UCASE$(modeminput$)
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

