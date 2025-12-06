DEFINT A-Z
DECLARE FUNCTION SerialNr$ (text$, Mask$)
'
'*** Serial Number Generator ***
'     by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling.
'  All Rights Reserved.
'
'
'This program generates serial number for any string. It is very
'useful if, for example, you want to generate a serial number
'for shareware programs. The same serial number is generated
'for the same text, but each different text's serial number is
'unique. The Mask$ argument should be a string that contains the
'format of the output string. A "$" symbolizes that a letter
'should be placed at that position. A "#" means that a digit
'should be placed at that position. A "?" means that either a
'letter or a digit should be placed at that position. Any other
'characters are left the way they are. Please note that in some
'cases one character/digit of a serial number is always the same.
'This is the case with the example below, the 11th character
'(the first '#') is always '2'. Changing the length of the mask
'(adding a format character) elimiantes this problem.
'

CLS
Mask$ = "????-$$$$-####"
DO
  PRINT "String to generate serial number for? (ENTER=quit)"
  LINE INPUT "String: ", In$
  IF UCASE$(In$) = "" THEN EXIT DO
  Out$ = SerialNr$(In$, Mask$)
  PRINT "Serial: "; Out$
  PRINT
LOOP
CLS

FUNCTION SerialNr$ (text$, Mask$)
IF text$ = "" OR Mask$ = "" THEN EXIT FUNCTION

'*** Calculate CRC
DIM Power(0 TO 7)
DIM CRC AS LONG
FOR i = 0 TO 7: Power(i) = 2 ^ i: NEXT i
CRC = 0
CRCText$ = text$ + Mask$
FOR i = 1 TO LEN(CRCText$)
   ByteVal = ASC(MID$(CRCText$, i, 1))
   FOR J = 7 TO 0 STEP -1
      TestBit = ((CRC AND 32768) = 32768) XOR ((ByteVal AND Power(J)) = Power(J))
      CRC = ((CRC AND 32767&) * 2&)
      IF TestBit THEN CRC = CRC XOR &H8005&
   NEXT J
NEXT i
CRCText$ = ""

Map$ = LTRIM$(RTRIM$(STR$(CRC)))
DIM Map(4): FOR a = 0 TO 4: Map(a) = VAL(MID$(Map$, a + 1, 1)): NEXT a

'*** Generate Serial Number
temp$ = Mask$: NumStr$ = "1234567890": ChrStr$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
FOR a = 1 TO LEN(Mask$)
  SELECT CASE MID$(Mask$, a, 1)
   CASE "?"
    CS$ = NumStr$ + ChrStr$
   CASE "#"
    CS$ = NumStr$
   CASE "$"
    CS$ = ChrStr$
   CASE ELSE
    CS$ = " "
  END SELECT
 
  IF CS$ <> " " THEN
    LC = LEN(CS$)
    CharPos = ((Map(a MOD 5) * ASC(MID$(CS$, (a MOD LC) + 1, 1)) + 1))
    MID$(temp$, a, 1) = MID$(CS$, (CharPos MOD LC) + 1, 1)
  END IF
NEXT a

SerialNr$ = temp$
END FUNCTION

