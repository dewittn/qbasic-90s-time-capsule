'***
' BIT_EDIT.BI - BitEdit Library Support File
'
'   Copyright 1996 Hauke Daempfling.
'   All Rights Reserved. All rights not expressly
'   licensed to the user are reserved to the developer.
'
'This file should be included into any program using the BIT_EDIT.QLB
'
DEFINT A-Z
DECLARE FUNCTION BitGet% (Num%, wBit%)
DECLARE FUNCTION BitVal% (wBit$)
DECLARE FUNCTION BitStr$ (Num%)
DECLARE SUB BitShift (Num%, WhichWay%, HowMany%)
DECLARE SUB BitSet (Num%, wBit%, bSet%)

