DEFINT A-Z
DECLARE SUB LedInit (Leds() AS ANY, Xp%, Yp%, Clr%)
DECLARE SUB LedSet (Leds() AS ANY, Fval AS SINGLE)
TYPE LedType
  Xpos AS INTEGER
  Ypos AS INTEGER
  Clr  AS INTEGER
  Stat AS INTEGER
  Lval AS SINGLE
END TYPE
'
'   *** LED Display ***
'   by Hauke Daempfling
'
'(c)1996 VIVIDsoft, Hauke Daempfling
'  All Rights Reserved.
'
'This program simulates a LED display in any screen mode execpt 0. To
'set up a led display, DIM an array of LedType to how may digits you
'want displayed and run LedInit, passing the array, the (top left) x
'and y coordinates, and the color (1 for red and 2 for green) as
'arguments. Then, to get the display to show something, run LedSet,
'passing the LedType array and the value you want displayed. The
'value can be negative and can have up to two spaces behind the comma.
'When LedSet encounters values it cannot display it simply does not
'display anything. Note: you might get funny results if displaying
'a number with more than two spaces behind the comma.
'

SCREEN 13                        'Whatever screen mode you want
DIM Led(6) AS LedType            'Set up and initialize led display array
LedInit Led(), 10, 10, 2

LedSet Led(), -12.34             'Show a negative number with decimal point
DO: LOOP UNTIL INKEY$ <> ""
FOR a! = -12345 TO 12345 STEP 5  'Count from -12345 to +12345 in steps of 5
  LedSet Led(), a!
  IF INKEY$ <> "" THEN EXIT FOR  'In case the user gets bored
NEXT a!
DO: LOOP UNTIL INKEY$ <> ""
SCREEN 2: SCREEN 0: SYSTEM

SUB LedInit (Leds() AS LedType, Xp, Yp, Clr)

MaxLeds = UBOUND(Leds)
IF MaxLeds = 0 THEN EXIT SUB

FOR a = 1 TO MaxLeds
  Leds(a).Xpos = Xp * a
  Leds(a).Ypos = Yp
  Leds(a).Clr = Clr
NEXT a
END SUB

SUB LedSet (Leds() AS LedType, Fval AS SINGLE)
MaxLeds = UBOUND(Leds)
IF MaxLeds = 0 THEN EXIT SUB

'*** Set up leds
LedStr$ = SPACE$(MaxLeds)  'string to store led values in

RSET LedStr$ = LTRIM$(STR$(Fval))  'store led values

msign = 0: comma = 0
IF INT(Fval) <> Fval OR Fval < 0 THEN  'check for comma and minus sign
  FOR a = 1 TO MaxLeds
    IF MID$(LedStr$, a, 1) = "." THEN  'comma, store location and remove it
      comma = a                        ' from string
      IF msign THEN msign = msign + 1  'shift minus sign to the right
      FOR b = a TO 2 STEP -1
        MID$(LedStr$, b, 1) = MID$(LedStr$, b - 1, 1)
      NEXT b
    END IF
    IF MID$(LedStr$, a, 1) = "-" THEN  'store loc. of minus sign
      msign = a
    END IF
  NEXT a
END IF

FOR a = 1 TO MaxLeds
  temp! = VAL(MID$(LedStr$, a, 1))  'get value
  Leds(a).Stat = -1                 'turn led on
  IF a = msign THEN                 'if it's the minus sign's location
    Leds(a).Lval = -1
  ELSEIF temp! = 0 AND a < msign THEN  'erase any zeros left of the minus
    Leds(a).Stat = 0                   ' sign
  ELSEIF MID$(LedStr$, a, 1) = " " THEN  'if there's a space in the string
    Leds(a).Stat = 0                     ' the led is off
  ELSE
    IF a = comma THEN temp! = temp! + .1  'if it's the comma's location
    Leds(a).Lval = temp!
  END IF
NEXT a

'*** Draw leds
DIM E(MaxLeds, 8), Lval AS SINGLE  'led elements

'  ___1
'2|   |3     you could store a single led element as a byte, but that
' 4---        would get pretty messy.
'5|___|6 .8
'   7
Clr = Leds(1).Clr  'led color

IF Clr = 1 THEN  'color settings
  Clr1 = 0: Clr2 = 12
ELSEIF Clr = 2 THEN
  Clr1 = 0: Clr2 = 10
END IF

FOR a = 1 TO MaxLeds  'set led elements according to stored values
  IF Leds(a).Stat THEN
  Lval = Leds(a).Lval
  FOR b = 1 TO 8: E(a, b) = Clr1: NEXT b
  SELECT CASE INT(Lval)
   CASE 0
     E(a, 1) = Clr2: E(a, 2) = Clr2: E(a, 3) = Clr2: E(a, 5) = Clr2: E(a, 6) = Clr2
     E(a, 7) = Clr2
   CASE 1
     E(a, 3) = Clr2: E(a, 6) = Clr2
   CASE 2
     E(a, 1) = Clr2: E(a, 3) = Clr2: E(a, 4) = Clr2: E(a, 5) = Clr2: E(a, 7) = Clr2
   CASE 3
     E(a, 1) = Clr2: E(a, 3) = Clr2: E(a, 4) = Clr2: E(a, 6) = Clr2: E(a, 7) = Clr2
   CASE 4
     E(a, 2) = Clr2: E(a, 3) = Clr2: E(a, 4) = Clr2: E(a, 6) = Clr2
   CASE 5
     E(a, 1) = Clr2: E(a, 2) = Clr2: E(a, 4) = Clr2: E(a, 6) = Clr2: E(a, 7) = Clr2
   CASE 6
     E(a, 1) = Clr2: E(a, 2) = Clr2: E(a, 4) = Clr2: E(a, 5) = Clr2: E(a, 6) = Clr2
     E(a, 7) = Clr2
   CASE 7
     E(a, 1) = Clr2: E(a, 2) = Clr2: E(a, 3) = Clr2: E(a, 6) = Clr2
   CASE 8
     E(a, 1) = Clr2: E(a, 2) = Clr2: E(a, 3) = Clr2: E(a, 4) = Clr2: E(a, 5) = Clr2
     E(a, 6) = Clr2: E(a, 7) = Clr2
   CASE 9
     E(a, 1) = Clr2: E(a, 2) = Clr2: E(a, 3) = Clr2: E(a, 4) = Clr2: E(a, 6) = Clr2
     E(a, 7) = Clr2
   CASE IS < 0
     E(a, 4) = Clr2
  END SELECT
  IF Lval - INT(Lval) > 0 AND Lval - INT(Lval) < 1 THEN E(a, 8) = Clr2
  END IF
NEXT a

FOR a = 1 TO MaxLeds  'draw leds
  X = Leds(a).Xpos: Y = Leds(a).Ypos
  LINE (X + 2, Y + 1)-(X + 5, Y + 1), E(a, 1)
  LINE (X + 1, Y + 2)-(X + 1, Y + 6), E(a, 2)
  LINE (X + 6, Y + 2)-(X + 6, Y + 6), E(a, 3)
  LINE (X + 2, Y + 7)-(X + 5, Y + 7), E(a, 4)
  LINE (X + 1, Y + 8)-(X + 1, Y + 13), E(a, 5)
  LINE (X + 6, Y + 8)-(X + 6, Y + 13), E(a, 6)
  LINE (X + 2, Y + 14)-(X + 5, Y + 14), E(a, 7)
  PSET (X + 8, Y + 14), E(a, 8)
NEXT a
END SUB

