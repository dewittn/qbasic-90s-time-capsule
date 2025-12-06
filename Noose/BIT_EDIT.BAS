DEFINT A-Z
DECLARE FUNCTION BitGet% (Num%, wBit%)
DECLARE FUNCTION BitVal% (wBit$)
DECLARE FUNCTION BitStr$ (Num%)
DECLARE SUB BitShift (Num%, derec%, HowMany%)
DECLARE SUB BitSet (Num%, wBit%, bSet%)

FUNCTION BitGet (Num, wBit) 'extracts bit at place wBit from Num
 
  IF wBit > 8 OR wBit < 1 THEN EXIT FUNCTION 'can't get bits that don't exist

  temp = 0                                   'clear temporary variable
                                          
  IF Num AND (2 ^ (wBit - 1)) THEN temp = 1  'if bit is on return 1

  BitGet = temp AND 255                      'return value
END FUNCTION

SUB BitSet (Num, wBit, bSet) 'sets the bit at place 'wBit' in 'Num' to 'bSet'

  IF bSet > 1 OR bSet < 0 THEN EXIT SUB  'you can only set a bit to 1 or 0
  IF wBit > 8 OR wBit < 1 THEN EXIT SUB  'can't set bits that don't exist

  temp$ = "": temp = 0                   'clear temporary variables

  wBit = 9 - wBit                        'bytes are read backwards
  temp$ = BitStr$(Num)                   'convert 'Num' to a string
  MID$(temp$, wBit, 1) = LTRIM$(RTRIM$(STR$(bSet)))  'change bit in 'temp$'
  temp = BitVal(temp$)                   'done, convert 'temp$' back

  Num = temp AND 255                     'return value
END SUB

SUB BitShift (Num, WhichWay, HowMany) 'shifts the bits in 'Num' by 'HowMany'

  IF HowMany >= 8 THEN Num = 0: EXIT SUB  'a shift of 8 or larger is always 0
  IF Num = 0 THEN EXIT SUB                '0 is always 0 after as shift
  IF HowMany <= 0 THEN EXIT SUB           'a shift of 0 is no shift

  temp = 0                                'clear temprorary variable

  IF WhichWay = 0 THEN                    '0 = left shift
    temp = Num * (2 ^ HowMany)
  ELSE                                    'not 0 = right shift
    temp = Num \ (2 ^ HowMany)
  END IF
 
  Num = temp AND 255                      'return value
END SUB

FUNCTION BitStr$ (Num) 'gives back 'Num' as a string of 1's and 0's

  IF Num = 255 THEN BitStr$ = "11111111": EXIT FUNCTION 'speed it up
  IF Num = 0 THEN BitStr$ = "00000000": EXIT FUNCTION

  temp$ = ""                    'clear temporary variables

  FOR a = 7 TO 0 STEP -1        'count down
    IF (Num AND (2 ^ a)) THEN   'check 'Num' against bit mask
      temp$ = temp$ + "1"       'add "1" to 'temp$' if bit is on
    ELSE
      temp$ = temp$ + "0"       'add "0" to 'temp$' if bit is off
    END IF
  NEXT a

  BitStr$ = temp$               'return vaue
END FUNCTION

FUNCTION BitVal (wBit$) 'returns the value of the 1's and 0's in 'wBit$'

  IF LEN(wBit$) <> 8 THEN EXIT FUNCTION  'can't process strings <> 8 chars
  IF wBit$ = "11111111" THEN BitVal = 255: EXIT FUNCTION 'speed it up a bit
  IF wBit$ = "00000000" THEN BitVal = 0: EXIT FUNCTION

  temp = 0                             'clear temporary variables

  FOR a = 1 TO 8                       'go through string
    IF MID$(wBit$, a, 1) = "1" THEN    'if a bit is 1 (on)
      temp = temp + (2 ^ (8 - a))      'add the corrosponding value to 'temp'
    END IF
  NEXT a

  BitVal = temp AND 255                'return value
END FUNCTION

