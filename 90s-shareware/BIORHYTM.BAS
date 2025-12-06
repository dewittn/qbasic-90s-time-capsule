'**************************************************************
'*** I converted this program from some old GW-Basic code
'*** I came across and jazzed it up somewhat. As you can see
'*** it's *SPAGHETTI* but it does work. It will require loading
'*** with QB.LIB OR QBX.LIB to run properly. Lines longer than
'*** 65 columns have been cut to a new line with an underscore,
'*** many of these lines you will need to re-append manually.
'**************************************************************
'***  Mark H Butler (1:105/330.5)
'**************************************************************

TYPE RegType
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
END TYPE

DECLARE SUB PrintScreen ()
DECLARE SUB Pause (ticks%)
DECLARE SUB Cuckoo ()
DECLARE SUB Lineout ()
DECLARE SUB IDParse (IDLine$, NumberOfNames%, Name$(), MaxNames%)
DECLARE SUB INTERRUPT (intnum AS INTEGER, inreg AS RegType, outreg AS RegType)

CONST Digit$ = "1234567890"
CONST CenterLine$ = "1-2-3-4-5-6-7-8-9-0-"
CONST PI! = 3.1416
CONST Symbol23$ = "*", Symbol28$ = "#", Symbol33$ = "+"    ', BL
NK$ = " "
CONST FALSE = 0, TRUE = NOT FALSE
DIM Name$(1 TO 10)
DIM Month%(12), Month$(12)

80
 RESTORE 240
 FOR i% = 1 TO 12
    READ Month%(i%)
 NEXT i%

240 DATA 31,28,31,30,31,30,31,31,30,31,30,31
   
 FOR i% = 1 TO 12
    READ Month$(i%)
 NEXT i%
   
 DATA January,February,March,April,May,June,July,August,September,October,November,December

 CLS
 COLOR 0, 3
 LOCATE 3, 35, 0
 PRINT " BIORHYTHMS "
 COLOR 7, 0
 LOCATE 6, 1
 PRINT "The theory of biorhythms is that we are influenced by three rhythms, physical,": PRINT
 PRINT "emotional, and intellectual, beginning the day we are born.  The first and the": PRINT
 PRINT "middle days of each cycle are considered critical days. In the biorhythm chart": PRINT
 PRINT "which follows these days cross the dateline."
 PRINT
 PRINT
 PRINT "If you have a printer, a printed copy may be made by pressing the letter "; CHR$(34); "P"; CHR$(34); "."
 'SOUND 2200, 1

560
 LOCATE 20, 1
   
 DEF SEG = 0    '
 POKE 1047, 64  ''****** caps on
 DEF SEG    '
   
 LINE INPUT ; "Please enter your name: "; WHOM$
   
 DEF SEG = 0   '
 POKE 1047, 0  '****** caps off
 DEF SEG       '


 IF WHOM$ = "" THEN
    Cuckoo
    GOTO 560
 END IF
   
 IDParse WHOM$, NumberOfNames%, Name$(), 10
 IF NumberOfNames% > 1 THEN
    WHOM$ = Name$(1) + " " + Name$(NumberOfNames%)
 ELSE
    WHOM$ = Name$(1)
 END IF
    
600
   
 LOCATE 21, 1
 PRINT STRING$(78, " ")
 LOCATE 21, 1

 

 PRINT "What is "; WHOM$; "'s "; "birthdate? MM-DD-YY ";
 LINE INPUT DateString$
 ON ERROR GOTO 2760
   
 IF INSTR(Digit$, MID$(DateString$, 1, 1)) = 0 THEN ERROR 0
 N% = 1
 IF INSTR(Digit$, MID$(DateString$, 2, 1)) <> 0 THEN N% = 2
 BirthMonth% = VAL(MID$(DateString$, 1, N%))
 IF BirthMonth% < 1 OR BirthMonth% > 12 THEN ERROR 0
   
 S% = N% + 2
 IF INSTR(Digit$, MID$(DateString$, S%, 1)) = 0 THEN ERROR 0
 N% = 1: IF INSTR(Digit$, MID$(DateString$, S% + 1, 1)) <> 0 THEN N% = 2
 BirthDate% = VAL(MID$(DateString$, S%, N%))
 IF BirthDate% < 1 OR BirthDate% > 31 THEN ERROR 0
   
 S% = S% + N% + 1
 BirthYear% = VAL(MID$(DateString$, S%)): IF BirthYear% = 0 THEN ERROR 0
 IF BirthYear% < 100 THEN BirthYear% = BirthYear% + 1900
 IF BirthYear% < 1582 THEN ERROR 0

980
 LOCATE 22, 1
 PRINT STRING$(78, " ")
 LOCATE 22, 1
 LINE INPUT "Start the biorhythm at : MM-YY "; DateString$
   
 ON ERROR GOTO 2780
   
 IF INSTR(Digit$, MID$(DateString$, 1, 1)) = 0 THEN ERROR 0
 N% = 1: IF INSTR(Digit$, MID$(DateString$, 2, 1)) <> 0 THEN N% = 2
 CalcMonth% = VAL(MID$(DateString$, 1, N%))
 IF CalcMonth% < 1 OR CalcMonth% > 12 THEN ERROR 0
 S% = N% + 2
 FOR i% = S% TO LEN(DateString$)
    IF INSTR(Digit$, MID$(DateString$, i%, 1)) = 0 THEN ERROR 0
 NEXT
 CalcYear% = VAL(MID$(DateString$, S%)): IF CalcYear% = 0 THEN ERROR 0
 IF CalcYear% < 100 THEN CalcYear% = CalcYear% + 1900
 IF CalcYear% < 1582 THEN ERROR 0
 IF CalcYear% < BirthYear% THEN ERROR 0
 IF (CalcYear% = BirthYear%) AND (CalcMonth% < BirthMonth%) THEN ERROR 0
 ON ERROR GOTO 0

'DAYS FROM BIRTH TO END OF MONTH
 TotalDays = Month%(BirthMonth%) - BirthDate% + 1
 YEAR% = BirthYear%
 GOSUB 2820
 IF BirthMonth% <= 2 AND YEAR% = 0 THEN TotalDays = TotalDays + 1
                            'LEAP YEAR ^
 FOR i% = (BirthMonth% + 1) TO 12        'REST OF BIRTH YEAR

    TotalDays = TotalDays + Month%(i%)
 NEXT i%
   
 YEAR% = CalcYear% - BirthYear% - 1       'YEARS IN BETWEEN
 C23% = 20 * YEAR%
 C28% = 1 * YEAR%
 C33% = 2 * YEAR%
   
 FOR i% = (BirthYear% + 1) TO (CalcYear% - 1)  'LEAP YEARS IN BETWEEN
    YEAR% = i%
    GOSUB 2820
    IF YEAR% = 0 THEN TotalDays = TotalDays + 1
 NEXT i%
 
 FOR i% = 1 TO (CalcMonth% - 1)        'MONTHS
    TotalDays = TotalDays + Month%(i%)
 NEXT i%
 
 YEAR% = CalcYear%
 GOSUB 2820
 IF CalcMonth% >= 2 AND YEAR% = 0 THEN TotalDays = TotalDays + 1 'LEAP YEAR
 
 C23% = (C23% + TotalDays) MOD 23      'CALCULATE DAYS INTO CYCLE
 C28% = (C28% + TotalDays) MOD 28
 C33% = (C33% + TotalDays) MOD 33
   
 COLOR 0, 1
 CLS
 COLOR 0, 3
 PRINT SPACE$(80);
 LOCATE 1, 1
 PRINT " "; WHOM$; "'s Biorhythm for "; Month$(CalcMonth%); CalcYear%;
 Birthdayline$ = "Birthdate is " + Month$(BirthMonth%) + STR$(BirthDate%) + STR$(BirthYear%)
 LOCATE , 80 - LEN(Birthdayline$)
 PRINT Birthdayline$
 LOCATE 25, 1
 COLOR 0, 2
 PRINT " "; Symbol23$; " PHYSICAL  ";
 COLOR 0, 12
 PRINT " "; Symbol28$; " EMOTIONAL  ";
 COLOR 0, 5
 PRINT " "; Symbol33$; " INTELLECTUAL  ";
 COLOR 0, 3
 PRINT SPC(7); "More BIORHYTHMS? Y/N ";
 COLOR 16
 PRINT "Y"; SPACE$(7);
 LOCATE 13, 9
 COLOR 0, 3
 PRINT CenterLine$; CenterLine$; CenterLine$; "1"
 J% = Month%(CalcMonth%)
 YEAR% = CalcYear%
 GOSUB 2820
 IF CalcMonth% = 2 AND YEAR% = 0 THEN J% = J% + 1
 K% = 1
 C% = 9
2200
 P23 = SIN(2! * PI! * CSNG(C23%) / 23!)
 P28 = SIN(2! * PI! * CSNG(C28%) / 28!)
 P33 = SIN(2! * PI! * CSNG(C33%) / 33!)
 PNN = P23
 GOSUB 2580
 LOCATE INN%, C%
 COLOR 0, 2
 PRINT Symbol23$;
 PNN = P28
 GOSUB 2580
 LOCATE INN%, C%
 COLOR 0, 12
 PRINT Symbol28$;
 PNN = P33
 GOSUB 2580
 LOCATE INN%, C%
 COLOR 0, 5
 PRINT Symbol33$;
 K% = K% + 1
 C% = C% + 2
 C23% = C23% + 1            'next day

 C28% = C28% + 1
 C33% = C33% + 1
 IF K% <= J% THEN 2200
 COLOR 7, 0
2540
 LOCATE 25, 71
 DateString$ = INPUT$(1)
 DateString$ = UCASE$(DateString$)
 IF DateString$ = CHR$(13) OR DateString$ = "Y" THEN
    RUN 80
 ELSEIF DateString$ = "N" THEN
    Lineout
 ELSEIF DateString$ = "P" THEN
    ON ERROR GOTO PrintError
    CALL PrintScreen
    ON ERROR GOTO 0
 ELSE
    Cuckoo
 END IF
 GOTO 2540
2580
 REM ROUTINE TO COMPUTE ROW NUMBER
 REM
 PSGN = SGN(PNN)
 PTT = PSGN * .05
 IF PTT = 0 THEN PTT = .05
 PQQ = -(PNN + PTT) / .1
 INN% = FIX(PQQ) + 13
 'SOUND 900, .05
 'SOUND 37, .05
 Pause 1
 RETURN

2760
 PRINT DateString$; " is an invalid date, please reenter"; STRING$(20, " ")
 Cuckoo
 RESUME 600
2780
 PRINT DateString$; " is an invalid date, please reenter"; STRING$(20, " ")
 Cuckoo
 RESUME 980
2820
 IF YEAR% MOD 4 <> 0 THEN RETURN   'LEAP YEAR CALCULATION
 IF (YEAR% MOD 100 = 0) AND (YEAR% MOD 400 <> 0) THEN RETURN
 YEAR% = 0
 RETURN

PrintError:
 CLS
 PRINT "Printer access error."
 END

DEFINT A-Z
SUB Cuckoo
    'SOUND 750, 1
    'SOUND 550, 1
END SUB

SUB IDParse (IDLine$, NumberOfNames%, Name$(), MaxNames%) STATIC
 NumberOfNames% = 0: In% = FALSE
 Cl$ = IDLine$
 L = LEN(Cl$)
 FOR i% = 1 TO L
    C$ = MID$(Cl$, i%, 1)
    IF (C$ <> " " AND C$ <> CHR$(9) AND C$ <> "/") THEN
        IF NOT In% THEN
            IF NumberOfNames% = MaxNames% THEN EXIT FOR
            NumberOfNames% = NumberOfNames% + 1
            In% = TRUE
        END IF
        Name$(NumberOfNames%) = Name$(NumberOfNames%) + C$
    ELSE
        In% = FALSE
    END IF
 NEXT i%
 FOR i% = 1 TO NumberOfNames%
    IDLen% = LEN(Name$(i%))
    Big$ = UCASE$(LEFT$(Name$(i%), 1))
    Little$ = LCASE$(MID$(Name$(i%), 2, IDLen%))
    Name$(i%) = Big$ + Little$
 NEXT i%
END SUB

SUB Lineout STATIC
DIM Lines$(1 TO 24)
   
 Lines$(1) = STRING$(80, CHR$(196))
 Sp% = 2
 Ln% = 76
 FOR i% = 2 TO 21
    Lines$(i%) = SPACE$(Sp%) + STRING$(Ln%, CHR$(196)) + SPACE$(2)
    Sp% = Sp% + 2
    Ln% = Ln% - 4
 NEXT i%
   
 Lines$(22) = SPACE$(39) + CHR$(254) + SPACE$(2)
 Lines$(23) = SPACE$(39) + CHR$(249) + SPACE$(2)
 
 COLOR 0, 0
 X% = 1
 y% = 25
 FOR i% = 1 TO 12
    LOCATE y%, 1
    PRINT STRING$(80, CHR$(32));
    LOCATE X%, 1
    PRINT STRING$(80, CHR$(32));
    Pause 1
    X% = X% + 1
    y% = y% - 1
 NEXT i%
 COLOR 3, 0
 FOR i% = 1 TO 23
    LOCATE 13, 1: PRINT Lines$(i%);
    Pause 1
 NEXT i%
 COLOR 7, 0
 CLS
 LOCATE , , 1, 6, 7
END SUB

SUB Pause (ticks%)
 DEF SEG = 0
 DO UNTIL TestTick% > ticks%
    LastTick% = GetTick%
    GetTick% = PEEK(&H46C)
    IF LastTick% <> GetTick% THEN
        TestTick% = TestTick% + 1
    END IF
 LOOP
 DEF SEG
END SUB

SUB PrintScreen
    DIM InRegs AS RegType
    'CALL INTERRUPT(5, InRegs, InRegs)
    LPRINT CHR$(12);
END SUB

