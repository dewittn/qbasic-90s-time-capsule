DEFINT A-Z
DECLARE SUB block ()
DECLARE SUB blk ()
DECLARE SUB Noinput ()
DECLARE SUB GetInput (LastOut$)
DECLARE SUB no ()
DECLARE SUB ReDraw (Derek)
DECLARE SUB FILTER (InString$)
DIM SHARED Rec
DIM SHARED Rec$
DIM SHARED BlockX
DIM SHARED BlkX
DIM SHARED NoInputX
DIM SHARED StopX
DIM SHARED Rep
DIM SHARED repx
DIM SHARED FileRec
DIM SHARED DX
DIM SHARED Comm1
DIM LastOut$
ON ERROR GOTO 2
COLOR 7, 1                      ' Set screen color.
CLS

quit$ = CHR$(0) + CHR$(16)      ' Value returned by INKEY$
                                ' when ALT+q is pressed.

' Set up prompt on bottom line of screen and turn cursor on:
ReDraw (0)
VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.

' Open communications (1200 baud, no parity, 8-bit data,
' 1 stop bit, 256-byte input buffer):
1
Filenum = FREEFILE
4
OPEN "COM1:9600,n,8,1," FOR RANDOM AS #1 LEN = 32767'     locate
PRINT "Connected to other computer"
BEEP
'CLS
DIM NAME$(6)
NAME$(1) = "1"
NAME$(2) = "1"
NAME$(3) = "2"
NAME$(4) = "3"
NAME$(5) = "5"
NAME$(6) = "8"
COUNT = 1
'CLS
'COLOR 18, 0
'CLS
'LOCATE 13, 30
'PRINT #1, "I DON'T THINK SO"

SLEEP 1
'StopX = 1
DO                              ' Main communications loop.

   KeyInput$ = INKEY$           ' Check the keyboard.
   IF Rep = 1 THEN
        PRINT #1, word$
        LastOut$ = word$
   END IF

IF StopX = 1 THEN
208
a = INT(RND * 255) + 1
'B = INT(RND * 14) + 1
'COLOR B
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
PRINT #1, CHR$(a); '" "; : PRINT A
LastOut$ = CHR$(a)
END IF
'*****************************************************************************
   SELECT CASE KeyInput$
        CASE quit$     ' Exit the loop if the user
                PRINT #1, CHR$(16)
                EXIT DO                   ' pressed ALT+q.
        'F12
        CASE CHR$(0) + "†"
        OPEN "COM1:9600,N,8,1," FOR RANDOM AS #3 LEN = 32767
        Comm1 = 1
        'F11
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
        
        'F10
        CASE CHR$(0) + "D"
        PRINT #1, Rec$
        'PRINT Rec$
        'F9
        CASE CHR$(0) + "C"
        IF Rec <> 1 THEN
                Rec$ = ""
                Rec = 1
        IF FileRec = 1 THEN
        PRINT #2, ""
        TEXT$ = "My computer: Input Record ON."
        PRINT #2, TEXT$
        END IF
        ELSE
                Rec = 0
        IF FileRec = 1 THEN
        TEXT$ = "My computer: Input Record Off."
        PRINT #2, ""
        PRINT #2, TEXT$
        END IF
       
        END IF
        ReDraw (1)
        'F8
        CASE CHR$(0) + "B"
                IF BlockX <> 1 THEN
                        BlockX = 1
                        skip = 1
                ELSE
                        BlockX = 0
                        skip = 0
                END IF
                
                ReDraw (1)
       
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
       
        'F5
        CASE CHR$(0) + "?"
         PRINT #1, CHR$(12)
                        IF FileRec = 1 THEN
                        TEXT$ = "My computer: Clearing the other computer screen."
                        PRINT #2, ""
                        PRINT #2, TEXT$
                        END IF

       
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
               
       
        'F2
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
       
        CASE CHR$(0) + ";"
        ReDraw (0)
       
        CASE IS <> "" 'Otherwise, if the user has
        IF Comm1 = 1 THEN
        PRINT #3, KeyInput$;
        END IF
        PRINT #1, KeyInput$;      ' pressed a key, send the
        LastOut$ = KeyInput$
        FILTER KeyInput$
        IF FileRec = 1 THEN
        PRINT #2, KeyInput$;
        END IF
        PRINT KeyInput$;
   END SELECT                       ' character typed to the modem.
   
   ' Check the modem. If characters are waiting (EOF(1) is
   ' true), get them and print them to the screen:


   IF NOT EOF(1) THEN
                                
     
      ' LOC(1) gives the number of characters waiting:

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
                GetInput (LastOut$)
        END IF
END IF

'IF stopx <> 1 THEN
'stopxx
'getinput
END IF
LOOP
'*************************End Loop********************************************
IF ERR <> 0 THEN
2
SELECT CASE ERR
        CASE 24
                CLOSE #1
                IF FileRec = 1 THEN
                TEXT$ = "My computer: Other computer not resonding."
                PRINT #2, ""
                PRINT #2, TEXT$
                END IF
                INPUT "Other computer not resonding retry, or end.(R/E)"; a$
                ReDraw (0)
                a$ = UCASE$(a$)
                IF a$ = "R" THEN
                        RESUME 4
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
   PRINT #1, ModemInput$;
   IF Comm1 = 1 THEN
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
      END IF
   LOOP WHILE LineFeed

END SUB

SUB GetInput (LastOutx$)
ModemInput$ = INPUT$(LOC(1), #1)
IF Rec = 1 THEN
        Rec$ = Rec$ + ModemInput$
END IF
FILTER ModemInput$        ' Filter out line feeds and
        IF ModemInput$ = CHR$(16) THEN
                ReDraw (0)
                PRINT "Other computer has loged off."
                INPUT "Do you?(y/n)"; a$
                a$ = UCASE$(a$)
                IF a$ = "T" THEN PRINT #1, CHR$(7)
                        IF a$ = "Y" THEN
                        PRINT "Press any key to end"
                        BEEP
                        SLEEP 0
                'GOTO 3
                END IF
        ELSE
                IF DX = 1 THEN
                FOR a = 1 TO LEN(ModemInput$)
                        b = a - 1
                        IF b = 0 THEN b = 1
                        IF LastOutx$ = MID$(ModemInput$, a, 1) OR MID$(ModemInput$, a, 1) = MID$(ModemInput$, b, 1) THEN
                        ELSE
                                IF FileRec = 1 THEN
                                PRINT #2, MID$(ModemInput$, a, 1);
                                END IF
                                IF Comm1 = 1 THEN
                                PRINT #3, MID$(ModemInput$, a, 1);
                                END IF
                                PRINT MID$(ModemInput$, a, 1);        ' backspaces, then print.                 'hhjjjk
                        END IF
                NEXT
                ELSE
                        IF FileRec = 1 THEN
                        PRINT #2, ModemInput$;
                        END IF
                                IF Comm1 = 1 THEN
                                PRINT #3, ModemInput$;
                                END IF
                       
                        PRINT ModemInput$;        ' backspaces, then print.
                END IF
        END IF
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
PRINT "Noinput="; NoInputX; " ASCII="; StopX; " Resend="; Rep; " Deflect="; BlkX; " Antideflector="; DX; " Rec.="; Rec;
VIEW PRINT 1 TO 23              ' Print between lines 1 & 23.             ' Print between lines 1 & 23.
IF Derek = 1 THEN
LOCATE y, x
END IF
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

