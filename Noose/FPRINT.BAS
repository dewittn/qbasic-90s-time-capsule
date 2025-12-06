DEFINT A-Z
'$DYNAMIC
DECLARE SUB InitFprint ()
DECLARE SUB Fprint (text$, x%, y%, size%)
DIM SHARED StdFont$(94)

SCREEN 12
CLS
InitFprint

'   Font Print
' Hauke Daempfling
'Jan 1996

'This program displays resizable fonts in any screen mode (exept 0 and a few
' others). The font doesn't look to bad, but it took about 4 days to write up
' so please give me some credit if you use this program in any of yours :).

'    Syntax:
'  Fprint text$, x, y, size
'text$ = any text (ASCII characters that are <32 or >126 will be cut from it)
'x     = bottom left corner X location
'y     = bottom left corner Y location
'size  = any size from 1 to ??, if you use 0 the standard (4) will be used.

'Example:
Fprint "Aa Bb Cc Xx Yy Zz 0123456789", 8, 16, 0
Fprint "Aa Bb Cc Xx Yy Zz", 8, 64, 16
Fprint "0123456789", 64, 132, 16

Fprint "Font Print - by Hauke Daempfling", 8, 256, 8
Fprint "R", 8, 320, 2
Fprint "E", 16, 320, 4
Fprint "S", 26, 320, 6
Fprint "I", 38, 320, 8
Fprint "Z", 55, 320, 10
Fprint "E", 78, 320, 12
Fprint "A", 100, 320, 14
Fprint "B", 128, 320, 16
Fprint "L", 160, 320, 18
Fprint "E", 190, 320, 20

REM $STATIC
SUB Fprint (text$, x, y, size)
IF LEN(text$) = 0 THEN EXIT SUB
IF size = 0 THEN size = 4
scale$ = STR$(size)

FOR a = 1 TO LEN(text$)
  locate$ = STR$(x) + "," + STR$(y)              'where we'll draw
  x$ = MID$(text$, a, 1)                         'the character being drawn
  IF ASC(x$) < 32 OR ASC(x$) > 126 THEN          'if the character is not in
    GOTO Skip                                    ' the StdFont$ array
  ELSE
    draw$ = StdFont$(ASC(x$) - 32)               'the drawing commands from
    w = 0                                        ' StdFont$
    FOR q = 1 TO 50                              'separate+expand the drawing
      XX$ = ""                                   ' commands from StdFont$
      DO
        w = w + 1
        XX$ = XX$ + MID$(draw$, w, 1)
      LOOP UNTIL MID$(draw$, w, 1) = " " OR w >= LEN(draw$)
      IF XX$ = "" THEN EXIT FOR
      IF LEFT$(XX$, 1) = "X" THEN
        temp$ = temp$ + "B " + RIGHT$(XX$, LEN(XX$) - 1)
      ELSE
        temp$ = temp$ + "N " + XX$ + "B " + XX$
      END IF     'N=line, no move  B=move, no line
    NEXT q
    draw$ = temp$
    temp$ = ""
  END IF
  DRAW "S1 B M" + locate$ + " S" + scale$ + " " + draw$ 'draw the char
  x = x + (size * 2) + 1                                'next X position
Skip:
  draw$ = ""
NEXT a
END SUB

SUB InitFprint 'sets up the character variables
'Set up the drawing commands for the characters.

'Please note:
'These are not the normal DRAW commands, they are translated by the FOR-NEXT
' loop in the Fprint sub. Here you only have the direction (H,U,E,L,R,G,
' D,F) commands and the next line is always started where the last one ended.
' If you add "X" to the command the line will not be drawn but the location
' moved. When you are drawing you start at the bottom left corner of the
' character. The commands must be seperated by spaces and no spaces should
' be used in a single command.

'            | *** Short reference to drawing commands used below ***
'   H U E     | * [Direction command][Length]
'<- L   R ->  |      Line, move
'   G D F     | * X[Direction command][Length]
'            |      No line, move

'The drawing commands assume a character box size of 8x8.

StdFont$(1) = "XR3 U1 R1 D1 L1 XU3 U5 R1 D5 L1"                     '!
StdFont$(2) = "XR3 XU8 D1 XR1 U1"                                   '"
StdFont$(3) = "XR2 U8 XR4 D8 XR2 XU2 L8 XU4 R8"                     '#
StdFont$(4) = "XR1 XU2 F2 R2 E2 U1 L6 U1 E2 R2 F2 XU3 XL3 D8"       '$
StdFont$(5) = "XR1 E6 XL4 D1 XD3 XR3 D1"                            '%
StdFont$(6) = "" 'no idea of how to draw this :)                    '&
StdFont$(7) = "XR4 XU8 D1 G1"                                       ''
StdFont$(8) = "XR6 H2 U4 E2"                                        '(
StdFont$(9) = "XR1 E2 U4 H2"                                        ')
StdFont$(10) = "XR3 XU4 R2 L1 U1 D2 XR1 H2 XR2 G2"                  '*
StdFont$(11) = "XR3 XU4 R2 L1 U1 D2"                                '+
StdFont$(12) = "XR4 XU2 D1 G1"                                      ',
StdFont$(13) = "XR2 XU4 R4"                                         '-
StdFont$(14) = "XR1 U1 R1 D1 L1"                                    '.
StdFont$(15) = "XR1 E6"                                             '/

StdFont$(16) = "XR2 R2 E2 U4 H2 L2 G2 D4 F2"                        '0
StdFont$(17) = "XR3 U8 G1"                                          '1
StdFont$(18) = "XR6 L5 U1 E5 U1 H1 L3 G1"                           '2
StdFont$(19) = "XR1 XU1 F1 R3 E1 U2 H1 E1 U2 H1 L3 G1"              '3
StdFont$(20) = "XR1 XU4 E4 D8 U4 L4 R5"                             '4
StdFont$(21) = "XR6 XU8 L5 D3 R4 F1 D3 G1 L3 H1"                    '5
StdFont$(22) = "XR5 XU7 H1 L1 G2 D5 F1 R2 E1 U3 H1 L3"              '6
StdFont$(23) = "XR1 XU8 R5 D2 G3 D3"                                '7
StdFont$(24) = "XR2 R2 E1 U2 H1 L2 G1 D2 F1 XU4 H1 U2 E1 R2 F1 D2 G1"'8
StdFont$(25) = "XR2 R1 E2 U5 H1 L2 G1 D2 F1 R3"                     '9

StdFont$(26) = "XR2 XU2 U1 R1 D1 L1 XU3 U1 R1 D1 L1"                ':
StdFont$(27) = "XR2 XU1 U2 R1 D1 G1 XU4 U1 R1 D1 L1"                ';
StdFont$(28) = "XR5 H4 E4"                                          '<
StdFont$(29) = "XR2 XU2 U1 R3 D1 L3 XU3 U1 R3 D1 L3"                '=
StdFont$(30) = "XR2 E4 H4"                                          '>
StdFont$(31) = "XR3 U1 XU1 U2 E2 U1 H1 L2 G1"                       '?
StdFont$(32) = "XR6 L4 H1 U5 E1 R3 F1 D3 L2 U1"                     '@

StdFont$(33) = "XR1 U5 E3 F3 D5 U3 L6"                              'A
StdFont$(34) = "XR1 U8 R4 F1 D2 G1 L4 R4 F1 D2 G1 L4"               'B
StdFont$(35) = "XR7 XU2 G2 L2 H2 U4 E2 R2 F2"                       'C
StdFont$(36) = "XR1 U8 R3 F2 D4 G2 L3"                              'D
StdFont$(37) = "XR1 U8 R6 XD4 XL2 L4 D4 R6"                         'E
StdFont$(38) = "XR1 U8 R6 XD4 XL2 L4"                               'F
StdFont$(39) = "XR5 XU4 R2 D2 G2 L3 H2 U4 E2 R4"                    'G
StdFont$(40) = "XR1 U8 D4 R6 D4 U8"                                 'H
StdFont$(41) = "XR2 R6 L3 U8 L3 R6"                                 'I
StdFont$(42) = "XR7 XU8 D6 G2 L2 H2"                                'J
StdFont$(43) = "XR2 U8 D4 E4 G4 F4"                                 'K
StdFont$(44) = "XR7 L6 U8"                                          'L
StdFont$(45) = "XR1 U8 F3 E3 D8"                                    'M
StdFont$(46) = "XR1 U8 F6 XD2 U8"                                   'N
StdFont$(47) = "XR2 R3 E2 U4 H2 L3 G2 D4 F2"                        'O
StdFont$(48) = "XR1 U8 R4 F2 G2 L4"                                 'P
StdFont$(49) = "XR3 R3 E2 U4 H2 L3 G2 D4 F2 XR5 H2"                 'Q
StdFont$(50) = "XR1 U8 R4 F2 G2 L4 F4"                              'R
StdFont$(51) = "XR1 XU2 F2 R2 E2 U2 L6 U2 E2 R2 F2"                 'S
StdFont$(52) = "XR4 U8 R3 L6"                                       'T
StdFont$(53) = "XR1 XU8 D6 F2 R2 E2 U6"                             'U
StdFont$(54) = "XR1 XU8 D5 F3 E3 U5"                                'V
StdFont$(55) = "XR1 XU8 D6 F2 E1 F1 E2 U6"                          'W
StdFont$(56) = "XU8 F8 XU8 G8"                                      'X
StdFont$(57) = "XR4 U5 H3 XR6 G3"                                   'Y
StdFont$(58) = "XR1 XU8 R6 D1 G6 D1 R6"                             'Z

StdFont$(59) = "XR7 L1 U8 R1"                                       '[
StdFont$(60) = "XR7 H6"                                             '\
StdFont$(61) = "XR1 R1 U8 L1"                                       ']
StdFont$(62) = "XR3 XU7 E1 F1"                                      '^
StdFont$(63) = "XR1 R6"                                             '_
StdFont$(64) = "XR4 XU8 F1"                                         '`

StdFont$(65) = "XR1 XU1 U1 E1 R1 F1 XD1 G1 L1 H1 XR3 XD1 U3"        'a
StdFont$(66) = "XR1 U7 D5 E1 R1 F1 D1 G1 L1 H1"                     'b
StdFont$(67) = "XR4 XU1 G1 L1 H1 U1 E1 R1 F1"                       'c
StdFont$(68) = "XR4 U7 D5 H1 L1 G1 D1 F1 R1 E1"                     'd
StdFont$(69) = "XR4 XU1 G1 L1 H1 U1 E1 R1 F1 L3"                    'e
StdFont$(70) = "XR2 U3 L1 R2 XL1 U2 E1 R1 F"                        'f
StdFont$(71) = "XR4 XU1 G1 L1 H1 U1 E1 R1 F1 U1 D4 G1 L1 H1"        'g
StdFont$(72) = "XR1 U7 D5 E1 R1 F1 D2"                              'h
StdFont$(73) = "XR2 U3 XU1 U1"                                      'i
StdFont$(74) = "XR2 XU5 D1 XD1 D4 G1 L1 H1"                         'j
StdFont$(75) = "XR1 U7 D5 E2 G2 F2"                                 'k
StdFont$(76) = "XR2 U7"                                             'l
StdFont$(77) = "XR1 U3 D1 E1 F1 E1 F1 D2"                           'm
StdFont$(78) = "XR1 U3 D1 E1 R1 F1 D2"                              'n
StdFont$(79) = "XR2 R1 E1 U1 H1 L1 G1 D1 F1"                        'o
StdFont$(80) = "XR1 U3 D1 E1 R1 F1 D1 G1 L1 H1 D3"                  'p
StdFont$(81) = "XR3 XU1 G1 L1 H1 U1 E1 R1 F1 U1 D5"                 'q
StdFont$(82) = "XR1 U3 D1 E1 R1 F"                                  'r
StdFont$(83) = "XR1 XU1 F1 R1 E1 U1 L3 U1 E1 R1 F1"                 's
StdFont$(84) = "XR3 U7 D3 L1 R2"                                    't
StdFont$(85) = "XR1 XU3 D2 F1 R1 E1 U2 D3"                          'u
StdFont$(86) = "XR1 XU3 D2 F1 E1 U2"                                'v
StdFont$(87) = "XR1 XU3 D2 F1 E1 F1 E1 U2"                          'w
StdFont$(88) = "XR1 XU3 F3 XU3 G3"                                  'x
StdFont$(89) = "XR1 XU3 D2 F1 R2 U3 D4 G1 L1"                       'y
StdFont$(90) = "XR1 XU3 R3 G3 R3"                                   'z

StdFont$(91) = "XR7 L1 H1 U3 L1 R1 U3 E1 R1"                        '{
StdFont$(92) = "XR4 U8"                                             '|
StdFont$(93) = "XR1 R1 E1 U3 R1 L1 U3 H1 L1"                        '}
StdFont$(94) = "XR2 XU7 E1 F1 E1"                                   '~

END SUB

