' >> I've been trying to use an example program from Ethan Winer's
'  >> "Basic Tips and Tricks". I have successfully used other programs
'  >> of his, but I cannot get this example to work for love nor money..

' >> ------------------------ ethan winers Stuff Buffer example--------
'  >> SUB StuffBuffer (Cmd$) STATIC
'  >>
'  >>   '----- Limit the string to 14 characters plus Enter and save
'  >>   '      the length.
'  >>   Work$ = LEFT$(Cmd$, 14) + CHR$(13)
'  >>   Length = LEN(Work$)
'  >>
'  >>   '----- Set the segment for poking, define the buffer head and tail,
'  >>   '      and then poke each character.
'  >>   DEF SEG = 0
'  >>   POKE 1050, 30
'  >>   POKE 1052, 30 + Length * 2
'  >>   FOR X = 1 TO Length
'  >>     POKE 1052 + X * 2, ASC(MID$(Work$, X))
'  >>   NEXT
'  >>
'  >> END SUB

'There's nothing wrong with Ethan's code and the POKE addresses are the
'default ones for the keyboard buffer. However not all computers have
'the buffer in the usual place and if, for example, you have a keyboard
'enhancer program that gives you a larger typeahead buffer then it might
'have been moved elsewhere.

'As a quick check try running this little program...

'    DEF SEG = &H40
'    X& = PEEK(&H80) + (256& * PEEK(&H81))
'    PRINT X&

'If your keyboard buffer is in the standard place then X& should be equal
'to thirty. If you get any other value than 30 your buffer has definitely
'been moved since the two bytes at 0040:0080 are a pointer to the start of
'the keyboard buffer taken as an offset from segment 0040 (Hex) - the BIOS
'DATA area.

'Personally I would rewrite the second part of Ethan's procedure as
'follows:

'    DEF SEG = &H40                      ' Switch to BIOS data segment
'    Head% = &H1A                        ' Buffer head pointer
'    Tail% = &H1C                        ' Buffer tail pointer
'    Start& = PEEK(&H80) + (256& * PEEK(&H81))
                                        ' Pointer to keyboard buffer
'    FOR X = 1 TO Length                 ' Stuff the buffer
'        POKE Start& + (X - 1) * 2, ASC(MID$(work$, X, 1))
'    NEXT
'    POKE Head%, Start&                  ' Set new head pointer
'    POKE Tail%, Start& + (X - 1) * 2    ' Set new tail pointer

'This should work wherever the buffer is located.

'If you want to see how the keyboard buffer works, try running the
'program below. It displays the contents in real time so you can
'watch as each keypress is inserted.

'--- cut here ---------------------------------------------------------------
' KEYBUFF.BAS   continuously displays contents of keyboard buffer
'
'   Author:     Christy Gemmell
'   Date:       19/2/1990
'
    COLOR 15, 0: CLS : LOCATE , , 0
    READ Items%
    FOR I% = 1 TO Items%
        READ Row%, Col%, Text$
        LOCATE Row%, Col%: PRINT Text$;
    NEXT I%
    LOCATE 11, 68: COLOR 11
    DEF SEG = &H40
    Start& = &H400 + PEEK(&H80): Finish& = &H400 + PEEK(&H82)
    PRINT RIGHT$("0000" + HEX$(Start&), 4); " ";
    PRINT RIGHT$("0000" + HEX$(Finish&), 4);
    IF Start& <> &H41E THEN
       S& = Start& - &H400: Ix$ = ""
       FOR I% = 0 TO 15
           Ix$ = Ix$ + RIGHT$("0" + HEX$(S& + (I% * 2)), 2) + " "
       NEXT I%
       LOCATE 8, 17: COLOR 15: PRINT RTRIM$(Ix$);
    END IF
    DO
       LOCATE 11, 4: COLOR 11
       Head& = &H400 + PEEK(&H1A): Tail& = &H400 + PEEK(&H1C)
       PRINT RIGHT$("0000" + HEX$(Head&), 4); " ";
       PRINT RIGHT$("0000" + HEX$(Tail&), 4);
       COLOR 13: LOCATE 9, 17: PRINT SPACE$(48);
       LOCATE 9, 17 + ((Head& - &H41E) \ 2) * 3: PRINT CHR$(25);
       COLOR 12: LOCATE 13, 17: PRINT SPACE$(48);
       LOCATE 13, 17 + ((Tail& - &H41E) \ 2) * 3: PRINT CHR$(24);
       FOR I% = 0 TO 15
           Character% = PEEK((Start& - &H400) + (I% * 2))
           Scancode% = PEEK((Start& - &H400) + (I% * 2) + 1)
           IF Character% < 32 THEN
              Ky$ = "  "
           ELSE
              Ky$ = CHR$(Character%) + " "
           END IF
           LOCATE 11, 17 + (I% * 3): COLOR 14: PRINT Ky$;
           LOCATE 14, 17 + (I% * 3): COLOR 9
           PRINT RIGHT$("0" + HEX$(Character%), 2);
           LOCATE 15, 17 + (I% * 3): COLOR 10
           PRINT RIGHT$("0" + HEX$(Scancode%), 2);
'(Continued to next message)
'(Continued from previous message)
       NEXT I%
       IF Head& >= Tail& THEN
          Numkeys% = 16 - ((Head& - Tail&) \ 2)
       ELSE
          Numkeys% = (Tail& - Head&) \ 2
       END IF
       LOCATE 14, 76: IF Numkeys% = 16 THEN Numkeys% = 0
       PRINT RIGHT$(" " + LTRIM$(RTRIM$(STR$(Numkeys%))), 2);
       IF Numkeys% = 15 THEN
          LOCATE 15, 67: COLOR 28: PRINT "BUFFER FULL";
          Dummy$ = INPUT$(16)
          LOCATE , 67: PRINT SPACE$(11);
       END IF
    LOOP UNTIL PEEK((Tail& - &H400) - 2) = 27
    DEF SEG : COLOR 7, 0: LOCATE 20, 1, 1
    Dummy$ = INPUT$(Numkeys%)
END

DATA  20
DATA  6, 4, "Head Tail", 6, 33, "Keyboard buffer"
DATA  6, 67, "Buffer Area", 8, 4, "041A 041C"
DATA  8, 17, "1E 20 22 24 26 28 2A 2C 2E 30 32 34 36 38 3A 3C"
DATA  8, 68, "0480 0482", 10, 3, "-----|-----"
DATA  10, 16, "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|"
DATA  10, 67, "-----|-----", 11, 3, "           ", 11, 16, " "
DATA  11, 64, " ", 11, 67, "           ", 12, 3, "-----|-----"
DATA  12, 16, "|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|"
DATA  12, 67, "-----|-----", 14, 3, "ASCII Codes"
DATA  14, 67, "Waiting", 15, 3, "Scan Codes"
DATA  24, 31, "Press <Esc> to quit"


