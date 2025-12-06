DECLARE SUB StuffBuffer (Cmd$)

CLS
PRINT "The StuffBuffer Routine!"

PRINT "String to put into buffer?"
LINE INPUT ">", IntoBuff$
PRINT "Dumping into buffer..."
StuffBuffer IntoBuff$
PRINT
PRINT "Getting string from buffer..."
OutBuff$ = INPUT$(LEN(IntoBuff$))
PRINT OutBuff$;
PRINT : PRINT
PRINT "String to put into buffer for program exit?"
LINE INPUT ">", IntoBuff$
IntoBuff$ = LEFT$(IntoBuff$, 14) + CHR$(13)
PRINT "Dumping into buffer..."
StuffBuffer IntoBuff$
PRINT "Exiting program..."
END

SUB StuffBuffer (Cmd$)
'----- Limit the string to 14 characters plus Enter and save
'      the length.

work$ = LEFT$(Cmd$, 15)
Length = LEN(work$)

'----- Set the segment for poking, define the buffer head and tail,
'      and then poke each character.

'(OLD VERSION)
'DEF SEG = 0
'POKE 1050, 30
'POKE 1052, 30 + Length * 2
'FOR X = 1 TO Length
'  POKE 1052 + X * 2, ASC(MID$(Work$, X))
'NEXT

'(NEW VERSION)
DEF SEG = &H40                      ' Switch to BIOS data segment
Head% = &H1A                        ' Buffer head pointer
Tail% = &H1C                        ' Buffer tail pointer
Start& = PEEK(&H80) + (256& * PEEK(&H81)) ' Pointer to keyboard buffer
FOR X = 1 TO Length                 ' Stuff the buffer
  POKE Start& + (X - 1) * 2, ASC(MID$(work$, X, 1))
NEXT
POKE Head%, Start&                  ' Set new head pointer
POKE Tail%, Start& + (X - 1) * 2    ' Set new tail pointer
DEF SEG
END SUB

