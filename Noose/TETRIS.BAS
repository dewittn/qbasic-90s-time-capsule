'               ллллллл лллллл ллллллл лллл   ллллл  лллл
'                  л    л         л    л   л    л   л
'                  л    лллл      л    лллл     л    ллл
'                  л    л         л    л   л    л       л
'                  л    лллллл    л    л    л ллллл лллл
'
' 
'To win,Guide your Piece down the pit and form strait horzontal lines.
'on A-Type you must make 24 Lines.On B-Type you must make 100.On B-type
'Every ten lines you pass a level.Turn on NUM-LOCK
'
'Keys:
' rotate piece
'   4 Ф5Ф 6
'      Г
'      2
'Press SHIFT+F5 to play
'By Joshua Dickerson
'
'PROGRAMMER'S LOG: 4/23/96 -> I am updating this program for faster execution,
'                             effieciency, and readibility.

CLS : RANDOMIZE TIMER: DIM Stat(7), Block$(7, 4), B$(4): WIDTH 40
FOR i = 1 TO 7: READ Plength(i): NEXT: FOR i = 1 TO 7: FOR J = 1 TO Plength(i)
READ Block$(i, J): NEXT: NEXT
PRINT "Use Number Pad to select.Press ENTER to play": PRINT
PRINT " Type:              Level:"
PRINT "кФФФФФФФП          кФТФТФТФТФТФТФТФТФТФП"
PRINT "Г>A-TypeГ          Г"; : COLOR 0, 7: PRINT "0"; : COLOR 7, 0
PRINT "Г1Г2Г3Г4Г5Г6Г7Г8Г9Г": PRINT "Г B-TypeГ          РФСФСФСФСФСФСФСФСФСФй"
PRINT "РФФФФФФФй           Hieght": LOCATE 9, 20: PRINT "кФТФТФТФТФТФТФТФТФТФП"
LOCATE 10, 20: PRINT "Г0Г1Г2Г3Г4Г5Г6Г7Г8Г9Г"
LOCATE 11, 20: PRINT "РФСФСФСФСФСФСФСФСФСФй": Type$ = "A-Type": LOCATE 6, 20
WHILE A$ <> CHR$(13): A$ = INKEY$
IF A$ <> "" THEN LOCATE ASC(Type$) + -59, 2: PRINT " ": LOCATE 6, level * 2 + 21: PRINT USING "#"; level
IF A$ = "8" THEN Type$ = "A-Type"
IF A$ = "2" THEN Type$ = "B-Type"
IF A$ = "4" AND level > 0 THEN level = level - 1
IF A$ = "6" AND level < 9 THEN level = level + 1
LOCATE ASC(Type$) + -59, 2: PRINT ">": COLOR 0, 7: LOCATE 6, level * 2 + 21
PRINT USING "#"; level: COLOR 7, 0: WEND: IF Type$ = "B-Type" THEN GOTO Display
A$ = "": lines = 24: WHILE A$ <> CHR$(13): A$ = INKEY$
IF A$ <> "" THEN LOCATE 10, Hieght * 2 + 21: PRINT USING "#"; Hieght
IF A$ = "4" AND Hieght > 0 THEN Hieght = Hieght - 1
IF A$ = "6" AND Hieght < 9 THEN Hieght = Hieght + 1
LOCATE 10, Hieght * 2 + 21: COLOR 0, 7: PRINT USING "#"; Hieght: COLOR 7, 0
WEND
Display: top = 10000
COLOR 7, 0: CLS : PRINT Type$: PRINT "кФФФФФФФФФФП"
PRINT "ГStatisticsГ": FOR i = 1 TO 19: PRINT "Г          Г": NEXT
PRINT "РФФФФФФФФФФй": FOR i = 1 TO 7: LOCATE 1 + i * 3, 8: PRINT "-  0"
FOR J = 1 TO Plength(i): LOCATE J + 3 * i, 2: PRINT Block$(i, J): NEXT: NEXT
FOR J = 2 TO 21: LOCATE J, 15: PRINT "л          л": NEXT: LOCATE 22, 15
PRINT "лллллллллллл": LOCATE 1, 16: PRINT "Lines -"; lines: LOCATE 2, 33
PRINT "кФФФФФФП": FOR i = 3 TO 6: LOCATE i, 33: PRINT "Г      Г": NEXT
LOCATE 7, 33: PRINT "РФФФФФФй": LOCATE 3, 34: PRINT "Top:": LOCATE 4, 34
PRINT USING "######"; top: LOCATE 5, 34: PRINT "Score:": LOCATE 6, 34
PRINT "     0": LOCATE 8, 35: PRINT "кФФФФП": LOCATE 9, 35: PRINT "ГNextГ"
FOR i = 1 TO 4: LOCATE 9 + i, 35: PRINT "Г    Г": NEXT: LOCATE 14, 35
PRINT "РФФФФй": LOCATE 15, 34: PRINT "кФФФФФП": LOCATE 16, 34: PRINT "ГLevelГ"
LOCATE 17, 34: PRINT "Г "; USING "##"; level; : PRINT "  Г": LOCATE 18, 34
PRINT "РФФФФФй": NextBlock = 7: NextBlockColor = 1
IF Type$ = "B-Type" THEN GOTO SelectPiece
LOCATE 20, 33: PRINT "кФФФФФФП": LOCATE 21, 33: PRINT "ГHieghtГ"
LOCATE 22, 33: PRINT "Г  "; USING "##"; Hieght; : PRINT "  Г": LOCATE 23, 33
PRINT "РФФФФФФй": LOCATE 22 - Hieght: FOR i = 1 TO Hieght: FOR J = 1 TO 10
LOCATE 22 - i, 15 + J
IF INT(2 * RND(1)) = 1 THEN COLOR INT(15 * RND(1)) + 1: PRINT "л";
NEXT: NEXT
SelectPiece: Collided = 0: Block = NextBlock: BlockColor = NextBlockColor
Pbegin = Plength(Block) + 1: row = 1: col = 5
FOR i = 1 TO LEN(Block$(Block, Pbegin - 1)): A$ = MID$(Block$(Block, Pbegin - 1), i, 1)
A = SCREEN(2, 19 + i): IF A = 219 AND A$ = "л" THEN gameover = 1
NEXT: Stat(Block) = Stat(Block) + 1: LOCATE 1 + Block * 3, 9
PRINT USING "###"; Stat(Block): NextBlock = INT(7 * RND(1)) + 1
NextBlockColor = INT(15 * RND(1)) + 1: COLOR NextBlockColor: FOR i = 1 TO 4
LOCATE 9 + i, 36: PRINT "    ": NEXT: FOR i = 1 TO Plength(NextBlock)
LOCATE 9 + i, 36: PRINT Block$(NextBlock, i): NEXT: GOSUB DropPiece
WHILE INKEY$ <> "": WEND
MainLoop:
IF gameover THEN
   FOR i = 40 TO 10 STEP -.5
      SOUND INT(10 * i * RND) + 100, .1
   NEXT
   FOR i = 21 TO 2 STEP -1
      LOCATE i, 16
      PRINT "пппппппппп"
   NEXT
   END
END IF
IF lines < 1 AND Type$ = "A-Type" THEN LOCATE 12, 17: PRINT "Sucsess!": END
IF lines > 99 AND Type$ = "B-Type" THEN LOCATE 12, 17: PRINT "Sucsess!": END
t = TIMER: WHILE c$ <> "2" AND TIMER < t + ((10 - level) / 10)
c$ = INKEY$: IF c$ = "4" THEN x = -1: GOSUB MovePiece
IF c$ = "6" THEN x = 1: GOSUB MovePiece
IF c$ = "5" THEN
collision = 0: FOR i = 1 TO 4: B$(i) = "": NEXT: K = 0
FOR i = LEN(Block$(Block, 1)) TO 1 STEP -1: K = K + 1
FOR J = 1 TO Plength(Block): A$ = MID$(Block$(Block, J), K, 1)
B$(i) = B$(i) + A$: NEXT: NEXT: Ptemp = LEN(Block$(Block, 1))
Pend = row + Plength(Block) - Pbegin
IF Ptemp > Pend THEN Pbtemp = Ptemp - (Pend - 1): Rtemp = 1
IF Ptemp <= Pend THEN Pbtemp = 1: Rtemp = Pend - (Ptemp - 1)
Action = 1: GOSUB DisplayPiece: K = 0: FOR i = Pbtemp TO Ptemp: K = K + 1
FOR J = 1 TO LEN(B$(1)): A$ = MID$(B$(i), J, 1)
A = SCREEN(Rtemp + K, col + J + 14): IF A = 219 AND A$ = "л" THEN collision = 1
NEXT: NEXT: IF col + LEN(B$(1)) > 11 THEN collision = 1
IF collision = 1 THEN Action = 2: GOSUB DisplayPiece: GOTO MainLoop
Plength(Block) = Ptemp: FOR i = 1 TO Ptemp: Block$(Block, i) = B$(i): NEXT
Pbegin = Pbtemp: row = Rtemp: Action = 2: GOSUB DisplayPiece
SOUND 900, .3
END IF: WEND: c$ = "": GOSUB CheckForCollision
IF Collided = 0 THEN GOSUB DropPiece ELSE SOUND 100, 1: GOSUB EraseLine: GOTO SelectPiece
GOTO MainLoop

CheckForCollision: Collided = 0: K = 0
IF Pbegin <> 1 THEN Pbegin = Pbegin - 1: row = 0
IF row + Plength(Block) = 21 THEN Collided = 1: RETURN
FOR i = Pbegin TO Plength(Block): K = K + 1: FOR J = 1 TO LEN(Block$(Block, 1))
A = SCREEN(row + K + 1, col + J + 14): A$ = MID$(Block$(Block, i), J, 1)
B$ = " ": IF i < Plength(Block) THEN B$ = MID$(Block$(Block, i + 1), J, 1)
IF A = 219 AND A$ = "л" AND B$ = " " THEN Collided = 1
NEXT: NEXT: IF row < 1 THEN row = 1: Pbegin = Pbegin + 1
RETURN

MovePiece: collision = 0: IF col = 1 AND x = -1 THEN RETURN
IF col + LEN(Block$(Block, 1)) = 11 AND x = 1 THEN RETURN
FOR i = 1 TO LEN(Block$(Block, 1)): K = 0: FOR J = Pbegin TO Plength(Block)
K = K + 1: A = SCREEN(row + K, col + i + 14 + x)
A$ = MID$(Block$(Block, J), i, 1): B$ = " "
IF i > 1 AND x = -1 THEN B$ = MID$(Block$(Block, J), i - 1, 1)
IF i < LEN(Block$(Block, 1)) AND x = 1 THEN B$ = MID$(Block$(Block, J), i + 1, 1)
IF A = 219 AND A$ = "л" AND B$ = " " THEN collision = 1
NEXT: NEXT: IF collision = 1 THEN RETURN
Action = 1: GOSUB DisplayPiece: col = col + x: Action = 2: GOSUB DisplayPiece
SOUND 1000, .3: RETURN

DropPiece: Action = 1: GOSUB DisplayPiece: row = row + 1
IF Pbegin > 1 THEN Pbegin = Pbegin - 1: row = 1
Action = 2: GOSUB DisplayPiece: RETURN

DisplayPiece:
COLOR BlockColor
K = 0
FOR i = Pbegin TO Plength(Block): K = K + 1
FOR J = 1 TO LEN(Block$(Block, 1))
   IF MID$(Block$(Block, i), J, 1) <> " " THEN
      LOCATE row + K, col + J + 14
      IF Action = 1 THEN PRINT " ";  ELSE PRINT CHR$(219);
   END IF
NEXT: NEXT: RETURN

EraseLine: K = 0: add = 500: FOR i = Pbegin TO Plength(Block): K = K + 1
Check = 0: FOR J = 1 TO 10: Check = Check + SCREEN(row + K, J + 15): NEXT
IF Check = 2190 THEN
FOR n = 1 TO 20: SOUND INT(500 * RND) + 100, .1: NEXT
FOR l = row + K TO 3 STEP -1: FOR m = 1 TO 10
COLOR SCREEN(l - 1, m + 15, 1): LOCATE l, m + 15
PRINT CHR$(SCREEN(l - 1, m + 15)): NEXT: NEXT: LOCATE 2, 16
PRINT "          ": score = score + add: add = add * 2
IF Type$ = "A-Type" THEN lines = lines - 1
IF Type$ = "B-Type" THEN lines = lines + 1: IF INT(lines / 10) > level THEN level = INT(lines / 10)
LOCATE 17, 36: PRINT level: LOCATE 1, 23: PRINT lines: LOCATE 6, 34
PRINT USING "######"; score
END IF: NEXT: RETURN
'Game A:
DATA 2,2,2,2,2,2,1,"ллл"," л ","ллл","  л","лл "," лл","лл","лл"," лл","лл "
DATA "ллл","л  ","лллл"

'Game B:
'DATA 2,1,2,2,2,2,1,"ллл "," ллл","л л"," л","л ","л  ","  л"," л ", "ллл","  л"
'DATA "л  ", "лллл"

'Game C:
'DATA 2,2,2,2,2,2,1,"л л"," л ","  лл","лл  ","л  л","лллл","л л","л л","лл"
'DATA " л"," лл ","лллл","лллл"

