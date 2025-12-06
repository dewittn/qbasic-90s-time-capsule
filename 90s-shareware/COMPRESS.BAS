DEFINT A-Z
DECLARE SUB QuickSort (Array() AS ANY)
DECLARE FUNCTION HashItIn% (dList() AS ANY, nKey%, Max%)
DECLARE FUNCTION HashFind% (dList() AS ANY, nKey%, What$, Max%)
DECLARE SUB Compress (Text$, CmpDict$)
DECLARE SUB GenerateDict (Text$, Dict$)
DECLARE SUB Meter (Xp%, Yp%, CurVal%, MaxVal%, FGC%, BGC%)
TYPE StackType
  low AS INTEGER
  hi AS INTEGER
END TYPE
TYPE DictEntryType
  Pair AS STRING * 2
  Occur AS LONG
  HashKey AS INTEGER
END TYPE

DIM dEntry(0) AS DictEntryType
SCREEN 0: CLS
LOCATE , , 0
PRINT "Hauke's Super Compressor Version 1.0! Wrote it all by myself!"
INPUT "Filename? ", file$
file$ = LTRIM$(RTRIM$(file$))
OPEN file$ FOR BINARY AS #1
IF LOF(1) = 0 THEN
  CLOSE #1
  KILL file$
  PRINT "Error: File not found."
  SYSTEM
END IF
IF LOF(1) > 10000 THEN PRINT "Uh-oh! File's too big! See ya!": SYSTEM
Test$ = INPUT$(LOF(1), 1)
CLOSE #1
OldLen = LEN(Test$)
PRINT "File size:"; OldLen; "Bytes"
PRINT "I'd say about"; OldLen * 3 / 1600; "seconds to compress and about"; OldLen / 1600; "seconds to "; "decompress. ";
PRINT "Although, you never know about those times... "
PRINT "Press any key to continue...": DO: LOOP UNTIL INKEY$ <> "": CLS
StartTime! = TIMER
LOCATE 2, 2: PRINT "  Please wait...            "
Compress Test$, CmpDict$
LOCATE 2, 2: PRINT "                            "
EndTime! = TIMER
NewLen = LEN(Test$)
LOCATE 3, 1
ratio = 100 - INT((NewLen / OldLen) * 100)
IF ratio > 0 THEN
  PRINT "The file has been shrunk by "; LTRIM$(RTRIM$(STR$(ratio))); "% in"; EndTime! - StartTime!; "seconds."
ELSE
  PRINT "The file has been expanded by "; LTRIM$(RTRIM$(STR$(-ratio))); "%! in"; EndTime! - StartTime!; "seconds."
END IF
LOCATE 4, 1: PRINT "Press any key to decompress..."
DO: LOOP UNTIL INKEY$ <> ""
LOCATE 3, 1: PRINT "                                                                        "
LOCATE 4, 1: PRINT "                              "
StartTime! = TIMER
LOCATE 2, 2: PRINT "  Please wait...            "
Compress Test$, CmpDict$
LOCATE 2, 2: PRINT "                           "
EndTime! = TIMER
New2Len = LEN(Test$)
LOCATE 3, 1
IF New2Len <> OldLen THEN
  PRINT "Decompressed incorrectly!"
ELSE
  PRINT "Decompressed correctly! (in"; EndTime! - StartTime!; "seconds)"
END IF

SUB Compress (Text$, CmpDict$)
   IF NOT LEFT$(Text$, 1) = CHR$(255) THEN
     Text$ = LTRIM$(RTRIM$(Text$))
    
     '*** E-Encode
     LOCATE 1, 1: PRINT "E-Encoding...            "
     out$ = ""
     IF LEN(Text$) MOD 7 <> 0 THEN Text$ = Text$ + SPACE$(7 - (LEN(Text$) MOD 7))
     FOR i = 1 TO LEN(Text$) STEP 7
       in1 = ASC(MID$(Text$, i, 1)): in2 = ASC(MID$(Text$, i + 1, 1))
       in3 = ASC(MID$(Text$, i + 2, 1)): in4 = ASC(MID$(Text$, i + 3, 1))
       in5 = ASC(MID$(Text$, i + 4, 1)): in6 = ASC(MID$(Text$, i + 5, 1))
       in7 = ASC(MID$(Text$, i + 6, 1))
       out1 = (in1 AND 127): out2 = (in2 AND 127): out3 = (in3 AND 127)
       out4 = (in4 AND 127): out5 = (in5 AND 127): out6 = (in6 AND 127)
       out7 = (in7 AND 127)
       out8 = ((in1 \ 128) AND 1) + ((in2 \ 64) AND 2) + ((in3 \ 32) AND 4)
       out8 = out8 + ((in4 \ 16) AND 8) + ((in5 \ 8) AND 16)
       out8 = out8 + ((in6 \ 4) AND 32) + ((in7 \ 2) AND 64)
       out$ = out$ + CHR$(out1) + CHR$(out2) + CHR$(out3) + CHR$(out4)
       out$ = out$ + CHR$(out5) + CHR$(out6) + CHR$(out7) + CHR$(out8)
       'Meter 2, 2, i, LEN(Text$) \ 7, 7, 0
     NEXT i
     Text$ = out$
    
     '*** Generate a Dictionary
     IF CmpDict$ = "" THEN GenerateDict Text$, CmpDict$
    
     '*** Compress
     LOCATE 1, 1: PRINT "Compressing...                                   "
     DO
       Cnt = Cnt + 1
       'Meter 2, 2, Cnt, LEN(Text$), 7, 0
       Char$ = MID$(Text$, Cnt, 2)
       IF Cnt = LEN(Text$) THEN
         Text$ = CHR$(255) + temp$ + MID$(Text$, Cnt, 1)
         EXIT SUB
       END IF
       xx = 1
ReDo:  x = INSTR(xx, CmpDict$, Char$)
       IF x THEN
         IF (x \ 2) = (x / 2) THEN
           xx = x + 1
           GOTO ReDo
         END IF
         temp$ = temp$ + CHR$((x \ 2) + 128)
         Cnt = Cnt + 1
       ELSE
         temp$ = temp$ + MID$(Text$, Cnt, 1)
       END IF
     LOOP WHILE Cnt < LEN(Text$)
     Text$ = CHR$(255) + temp$
     'OPEN "C:\TEST.CMP" FOR BINARY AS #1
     'PUT #1, , Text$
     'CLOSE #1
     EXIT SUB
   ELSE
     '*** Decompress
     LOCATE 1, 1: PRINT "Decompressing...                               "
     comp$ = RIGHT$(Text$, LEN(Text$) - 1)
     Text$ = ""
     FOR x = 1 TO LEN(comp$)
       'Meter 2, 2, x, LEN(comp$), 7, 0
       Char = ASC(MID$(comp$, x, 1))
       IF Char > 127 THEN
         Text$ = Text$ + MID$(CmpDict$, (Char - 128) * 2 + 1, 2)
       ELSE
         Text$ = Text$ + MID$(comp$, x, 1)
       END IF
     NEXT x

     '*** E-Decode
     LOCATE 1, 1: PRINT "E-Decoding...                                "
     out$ = "": Text$ = UCASE$(Text$)
     FOR i = 1 TO LEN(Text$) STEP 8
       'Meter 2, 2, i, LEN(Text$) \ 8, 7, 0
       in1 = ASC(MID$(Text$, i, 1)): in2 = ASC(MID$(Text$, i + 1, 1))
       in3 = ASC(MID$(Text$, i + 2, 1)): in4 = ASC(MID$(Text$, i + 3, 1))
       in5 = ASC(MID$(Text$, i + 4, 1)): in6 = ASC(MID$(Text$, i + 5, 1))
       in7 = ASC(MID$(Text$, i + 6, 1)): in8 = ASC(MID$(Text$, i + 7, 1))
       out1 = in1 + ((in8 AND 1) * 128): out2 = in2 + ((in8 AND 2) * 64)
       out3 = in3 + ((in8 AND 4) * 32): out4 = in4 + ((in8 AND 8) * 16)
       out5 = in5 + ((in8 AND 16) * 8): out6 = in6 + ((in8 AND 32) * 4)
       out7 = in7 + ((in8 AND 64) * 2)
       out$ = out$ + CHR$(out1) + CHR$(out2) + CHR$(out3) + CHR$(out4)
       out$ = out$ + CHR$(out5) + CHR$(out6) + CHR$(out7)
     NEXT i
     'Meter 2, 2, 1, 1, 7, 0
     Text$ = RTRIM$(out$)
   END IF
END SUB

SUB GenerateDict (Text$, Dict$)
LOCATE 1, 1: PRINT "Finding and counting pairs...                  "
Ltxt = LEN(Text$)
DIM dEntry(Ltxt * 1.3) AS DictEntryType
Arraysize = UBOUND(dEntry)
FOR a = 1 TO Ltxt - 1
 'Meter 2, 2, a, Ltxt - 1, 7, 0
 What$ = MID$(Text$, a, 2)
 nKey = ASC(MID$(Text$, a, 1)) + ASC(MID$(Text$, a, 1)) * 256
 IF nKey = 0 THEN nKey = (Ltxt - 10) * 1.3
 IsPos = HashFind(dEntry(), nKey, What$, Arraysize)
 IF IsPos > 0 THEN
   dEntry(IsPos).Occur = dEntry(IsPos).Occur + 1
 ELSE
   InArray = InArray + 1
   InPos = HashItIn(dEntry(), nKey, Arraysize)
   IF InPos = 0 THEN LOCATE 5, 1: PRINT "Hashing error! Array full! (An Impossible Error!!! How could it happen!)"
   dEntry(InPos).HashKey = nKey
   dEntry(InPos).Pair = What$: dEntry(InPos).Occur = 1
 END IF
NEXT a

LOCATE 1, 1: PRINT "Sorting dictionary...                         "
QuickSort dEntry()

IF InArray < 128 THEN MaxDict = InArray ELSE MaxDict = 128
FOR a = 1 TO MaxDict
  'PRINT dEntry(a).Occur;
  Dict$ = Dict$ + dEntry(a).Pair
NEXT a
ERASE dEntry
END SUB

FUNCTION HashFind (dList() AS DictEntryType, nKey, What$, Max)
CheckPos = nKey MOD Max
RetryHashFind:
Tried = Tried + 1
IF Tried >= Max THEN
  FOR a = 1 TO Max
    IF dList(a).HashKey = nKey AND dList(a).Pair = What$ THEN HashFind = a: EXIT FUNCTION
  NEXT a
  HashFind = 0
  EXIT FUNCTION
END IF
IF CheckPos > Max THEN CheckPos = CheckPos MOD Max
IF dList(CheckPos).HashKey = 0 THEN HashFind = 0: EXIT FUNCTION
IF dList(CheckPos).HashKey = nKey AND dList(CheckPos).Pair = What$ THEN HashFind = CheckPos: EXIT FUNCTION
CheckPos = CheckPos - (Max - CheckPos) + 1
IF CheckPos < 1 THEN CheckPos = CheckPos + Max
GOTO RetryHashFind
END FUNCTION

FUNCTION HashItIn (dList() AS DictEntryType, nKey, Max)
NewPos = nKey MOD Max
RetryHashItIn:
Tried = Tried + 1
IF Tried >= Max THEN
  FOR a = 1 TO Max
    IF dList(a).HashKey = 0 THEN HashItIn = a: EXIT FUNCTION
  NEXT a
  HashItIn = 0
  EXIT FUNCTION
END IF
IF NewPos > Max THEN NewPos = NewPos MOD Max
IF dList(NewPos).HashKey = 0 THEN HashItIn = NewPos: EXIT FUNCTION
NewPos = NewPos - (Max - NewPos) + 1
IF NewPos < 1 THEN NewPos = NewPos + Max
GOTO RetryHashItIn
END FUNCTION

SUB Meter (Xp, Yp, CurVal, MaxVal, FGC, BGC)
SHARED StartTime!
IF Xp > 55 OR Xp < 1 OR Yp > 25 OR Yp < 1 THEN EXIT SUB
PerVal = (CurVal / MaxVal) * 100
IF PerVal > 100 THEN EXIT SUB
COLOR FGC, BGC
LOCATE Yp, Xp
PRINT STRING$(PerVal \ 5, "Û"); STRING$(20 - PerVal \ 5, "°"); " ";
IF PerVal = 100 THEN PRINT "Done";  ELSE PRINT LTRIM$(RTRIM$(STR$(PerVal))) + "%"; "  ";
END SUB

SUB QuickSort (Array() AS DictEntryType)
DIM aStack(1 TO 256) AS StackType

  StackPtr = 1
  aStack(StackPtr).low = LBOUND(Array)
  aStack(StackPtr).hi = UBOUND(Array)
  StackPtr = StackPtr + 1

  DO
        StackPtr = StackPtr - 1
        low = aStack(StackPtr).low
        hi = aStack(StackPtr).hi
       
        DO
          i = low
          j = hi
          mid = (low + hi) \ 2
          compare = Array(mid).Occur
          DO
                DO WHILE Array(i).Occur > compare
                  i = i + 1
                LOOP
        DO WHILE Array(j).Occur < compare
                  j = j - 1
                LOOP
                IF i <= j THEN
                  SWAP Array(i), Array(j)
                  i = i + 1
                  j = j - 1
                END IF
          LOOP WHILE i <= j
          IF j - low < hi - i THEN
                IF i < hi THEN
                  aStack(StackPtr).low = i
                  aStack(StackPtr).hi = hi
                  StackPtr = StackPtr + 1
                END IF
                hi = j
          ELSE
                IF low < j THEN
                  aStack(StackPtr).low = low
                  aStack(StackPtr).hi = j
                  StackPtr = StackPtr + 1
                END IF
                low = i
          END IF
        LOOP WHILE low < hi
        'IF StackPtr > maxsp THEN maxsp = StackPtr
  LOOP WHILE StackPtr <> 1
ERASE aStack
END SUB

