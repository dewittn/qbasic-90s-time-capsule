DEFINT A-Z
DECLARE SUB EDecode (text$)
DECLARE SUB EEncode (text$)
'
'   *** E-Coder ***
' by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This E-Coder codes strings with ANY characters in them so they are
'echo-compatible (like UUE-Encoding). Very fast and efficient. Do
'not change the length of a E-encoded string. The string is expanded
'when it is encoded, the ratio is 3:4 (Not Coded : Coded), or 133%.
'

CLS
DO
  PRINT "  *** E-Coder ***"
  PRINT "By Hauke Daempfling"
  PRINT
  PRINT "Text to be E-encoded?"
  LINE INPUT "", InText$
  IF InText$ = "" THEN EXIT DO
  PRINT
 
  PRINT "*** EEncode"
  PRINT "Input: "; InText$
  EEncode InText$
  PRINT "Output: "; InText$
  PRINT
  PRINT "*** EDecode"
  PRINT "Input: "; InText$
  EDecode InText$
  PRINT "Output: "; InText$
  PRINT

  SLEEP
  CLS
LOOP
CLS : PRINT : PRINT "Goodbye!"

SUB EDecode (text$)
out$ = "": text$ = UCASE$(text$)
FOR i = 1 TO LEN(text$) STEP 4
  in1 = ASC(MID$(text$, i, 1)) - 32
  in2 = ASC(MID$(text$, i + 1, 1)) - 32
  in3 = ASC(MID$(text$, i + 2, 1)) - 32
  in4 = ASC(MID$(text$, i + 3, 1)) - 32
  out1 = in1 + ((in4 AND 3) * 64)
  out2 = in2 + ((in4 AND 12) * 16)
  out3 = in3 + ((in4 AND 48) * 4)
  out$ = out$ + CHR$(out1) + CHR$(out2) + CHR$(out3)
NEXT i
text$ = RTRIM$(out$)
END SUB

SUB EEncode (text$)
out$ = ""
IF LEN(text$) MOD 3 <> 0 THEN text$ = text$ + SPACE$(3 - (LEN(text$) MOD 3))
FOR i = 1 TO LEN(text$) STEP 3
  in1 = ASC(MID$(text$, i, 1))
  in2 = ASC(MID$(text$, i + 1, 1))
  in3 = ASC(MID$(text$, i + 2, 1))
  out1 = (in1 AND 63)
  out2 = (in2 AND 63)
  out3 = (in3 AND 63)
  out4 = ((in1 \ 64) AND 3) + ((in2 \ 16) AND 12) + ((in3 \ 4) AND 48)
  out$ = out$ + CHR$(out1 + 32) + CHR$(out2 + 32) + CHR$(out3 + 32) + CHR$(out4 + 32)
NEXT i
text$ = out$
END SUB

