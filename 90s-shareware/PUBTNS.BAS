'========================================
'  Nice looking TEXT Pop-up Buttons
'  Programmed by William Yu  (02-14-96)
'
'  Features:
'    One subroutine call
'    Shadow can be placed on either side
'    Up/Down button position
'    User defined colours (colors USA)
'    Multiple high-lightable characters
'    EASY to use!
'
'  This routine was not used within the
'  ABC Reader v1.00, I programmed this
'  subroutine after.
'
'  You may wish to cut down or abbr. the
'  variables later.  I used the huge
'  variable names for easy reference.
'========================================

DEFINT A-Z
DECLARE SUB TextButton (Position%, XButton%, YButton%, Button$, ButtonForeColour%, ButtonBackColour%, ButtonHiLightChar%, ShadowColour%, ShadowBackGround%, Shadow%)
DECLARE SUB Pause (Seconds!)

SCREEN 0, , 0, 0

COLOR , 1: CLS      ' Create a coloured background for demonstration purposes

CONST Right = -1    ' Whatever number you want, but RIGHT <> LEFT
CONST Left = 0
CONST Up = -1       ' Whatever number you want, but UP <> DOWN
CONST Down = 0

X = 35: Y = 11                ' X and Y coordinates of button
HelpButton$ = "~Help (~F~1)"  ' Spaces not required, automatically included
ButtonForeColour = 0          ' Letters colour are BLACK
ButtonBackColour = 7          ' Colour of button is GREY
ButtonHiLightChar = 15        ' High-lighted character is WHITE
ButtonShadowColour = 0        ' Button shadow is DARK GREY
ShadowBackGround = 1          ' Shadow's background colour is BLACK
Shadow = Right                ' Place shadow to the RIGHT of button

DO       ' Drive user crazy with this loop!
  TextButton Up, X, Y, HelpButton$, ButtonForeColour, ButtonBackColour, ButtonHiLightChar, ButtonShadowColour, ShadowBackGround, Shadow
  Pause .3
  TextButton Down, X, Y, HelpButton$, ButtonForeColour, ButtonBackColour, ButtonHiLightChar, ButtonShadowColour, ShadowBackGround, Shadow
  Pause .4
LOOP UNTIL INKEY$ <> ""

' Equivalent lines without all the variables:
'
' TextButton Up, 40, 10, "~Help", 0, 7, 15, 8, 0, Right
' TextButton Down, 40, 10, "~Help", 0, 7, 15, 8, 0, Right

SUB Pause (Seconds!)

T! = TIMER                        ' Pause routine
WHILE NOT TIMER - T! > Seconds!   ' Delay for how many Seconds!
WEND                              ' WHILE...WEND or DO...LOOP  Whatever

END SUB

SUB TextButton (Position, XButton, YButton, Button$, ButtonForeColour, ButtonBackColour, ButtonHiLightChar, ShadowColour, ShadowBackGround, Shadow)

XCor = XButton

IF (Shadow = Left) AND (Position = Up) THEN      ' Place shadows on the
  LOCATE YButton, XButton - 1                    ' left side of button
  COLOR ShadowColour, ShadowBackGround
  PRINT "Ü";
  LOCATE YButton + 1, XButton - 1: PRINT "ßß";
END IF

IF Position = Down THEN        ' This routine removes the shadows
  LOCATE YButton, XButton
  COLOR , ShadowBackGround
  PRINT " ";
  IF Shadow = Right THEN XCor = XCor + 1 ELSE XCor = XCor - 1
  LOCATE YButton + 1, XCor: PRINT " ";
END IF

LOCATE YButton, XCor
COLOR ButtonForeColour, ButtonBackColour
PRINT " ";              ' Spaces are automatically inserted, remove if desired

Length = LEN(Button$)   ' Number of characters in BUTTON$
FOR I = 1 TO Length     ' Parse them all
  IF MID$(Button$, I, 1) = "~" THEN
    COLOR ButtonHiLightChar
  ELSE
    XCor = XCor + 1
    LOCATE YButton, XCor
    PRINT MID$(Button$, I, 1);
    COLOR ShadowColour, ShadowBackGround
    IF Position = Up THEN
      LOCATE YButton + 1, XCor: PRINT "ß";
    ELSE
      LOCATE YButton + 1, XCor: PRINT " ";
    END IF
    COLOR ButtonForeColour, ButtonBackColour
  END IF
NEXT I

IF Position = Down THEN        ' This routine also removes the shadows
  LOCATE YButton + 1, XCor + 1
  COLOR ShadowColour, ShadowBackGround
  PRINT " ";
  IF Shadow = Left THEN
    LOCATE YButton, XCor + 2: PRINT " ";
  END IF
END IF

COLOR ButtonForeColour, ButtonBackColour
LOCATE YButton, XCor + 1
PRINT " ";              ' Spaces are automatically inserted, remove if desired

IF (Shadow = Right) AND (Position = Up) THEN
  COLOR ShadowColour, ShadowBackGround
  PRINT "Ü";
  LOCATE YButton + 1, XCor + 1: PRINT "ßß";
END IF

END SUB

