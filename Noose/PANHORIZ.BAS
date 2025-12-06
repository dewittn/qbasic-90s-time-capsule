' PANDEM.BAS    demonstrates how to pan EGA/VGA screens
'
'   Author:     Christy Gemmell
'
    DECLARE SUB PanDisplay (x%, y%)

    CONST FALSE = 0, TRUE = NOT FALSE

    SCREEN 9
    LINE (0, 0)-(639, 349), 9, BF
    VIEW SCREEN (40, 25)-(600, 325), 0, 15
    CIRCLE (319, 174), 150, 14
    PAINT (319, 174), 14, 14

    x% = 0: y% = 0: Esc$ = CHR$(27)
    LeftArrow$ = CHR$(0) + CHR$(75): RightArrow$ = CHR$(0) + CHR$(77)
    UpArrow$ = CHR$(0) + CHR$(72): DownArrow$ = CHR$(0) + CHR$(80)

    DO
        DO
            KeyStroke$ = INKEY$
        LOOP WHILE KeyStroke$ = ""
        Pan% = TRUE
        SELECT CASE KeyStroke$
            CASE LeftArrow$
                 IF x% > 0 THEN x% = x% - 1
            CASE RightArrow$
                 IF x% < 79 THEN x% = x% + 1
            CASE UpArrow$
                 IF y% > 0 THEN y% = y% - 1
            CASE DownArrow$
                 IF y% < 22 THEN y% = y% + 1
            CASE ELSE
                 Pan% = FALSE
        END SELECT
        IF Pan% THEN PanDisplay x%, y% * 5
    LOOP UNTIL KeyStroke$ = Esc$
END

'   Set display window co-ordinates -- [MAIN CODE!!]
'   Works on EGA, VGA, MCGA, no CGA
SUB PanDisplay (x%, y%) STATIC
    OUT &H3D4, 12: OUT &H3D5, y%            ' Scroll screen vertically
    OUT &H3D4, 13: OUT &H3D5, x%            ' Scroll screen horizontally
END SUB
