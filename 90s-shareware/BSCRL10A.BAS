'BASScroll version 1.0a -- scroll screen
'Copyright (c)1995-6 Mark K. Kim
'E-mail: MarkKKim@aol.com
'http://users.aol.com/markkkim/
'* Freely distributed.  May be used in other programs with proper notice of
'  credit.
'* This program is provided "as-is".
'* Not compatible with PowerBASIC.
'* In QuickBASIC 4.5, run QB.EXE with /L option. If including QB.BI, then
'  replace the ABSOLUTE SUB declaration statement in QB.BI with the ABSOLUTE
'  SUB declaration within this program. Make other proper revisions.
'* CREDIT: Ralf Brown's interrupt list was used to get interrupt for the
'  function.  Microsoft DOS's Debug was used to convert Assembly code to
'  machine code.  Microsoft is a Registered Trademark of Microsoft Corp.
'  Thanks to beta testers, rt911@aol.com and wildgamer@aol.com
'Read the header of each function to find out the usage of those functions.
'These functions are designed to work with most other routines as it does
'not interfere with any other routines. It is especially designed to work
'with other functions in this BASxx series.

DECLARE SUB absolute (var1%, var2%, var3%, var4%, var5%, var6%, offset%)
'== BEGIN HEADER ==
DECLARE SUB scroll.up (lines%, x1%, y1%, x2%, y2%, attrib%)
DECLARE SUB scroll.down (lines%, x1%, y1%, x2%, y2%, attrib%)
'== END HEADER ==


'== START ==

SHELL "dir /w c:\dos"
LOCATE 25, 1: PRINT "*** Press any key to continue ***";

'slow scroll
LOCATE 24, 1: PRINT "*** SLOW SCROLL DEMONSTRATION ***";
DO
  FOR i% = 1 TO 10
    scroll.up 1, 5, 5, 75, 20, &H0
  NEXT i%
  FOR i% = 1 TO 10
    scroll.down 1, 5, 5, 75, 20, &H0
  NEXT i%
LOOP UNTIL INKEY$ <> ""

'faster scroll
LOCATE 24, 1: PRINT "*** FASTER SCROLL DEMONSTRATION ***";
DO
  FOR i% = 1 TO 5
    scroll.up 2, 5, 5, 75, 20, &H0
  NEXT i%
  FOR i% = 1 TO 5
    scroll.down 2, 5, 5, 75, 20, &H0
  NEXT i%
LOOP UNTIL INKEY$ <> ""

'even faster scroll
LOCATE 24, 1: PRINT "*** EVEN FASTER SCROLL DEMONSTRATION ***";
DO
  FOR i% = 1 TO 3
    scroll.up 3, 5, 5, 75, 20, &H0
  NEXT i%
  FOR i% = 1 TO 3
    scroll.down 3, 5, 5, 75, 20, &H0
  NEXT i%
LOOP UNTIL INKEY$ <> ""

'fastest scroll
LOCATE 24, 1: PRINT "*** FASTEST SCROLL DEMONSTRATION ***    ";
DO
  FOR i% = 1 TO 2
    scroll.up 4, 5, 5, 75, 20, &H0
  NEXT i%
  FOR i% = 1 TO 2
    scroll.down 4, 5, 5, 75, 20, &H0
  NEXT i%
LOOP UNTIL INKEY$ <> ""

'Scrolls down text on screen.
'INPUTS;
'* lines%   : Scroll this many lines down
'* x1%, y1% : Top-left coordinate
'* x2%, y2% : Bottom-right coordinate
'* (x1, y1)-(x2, y2) is the "box" area to be scrolled down.
'* attrib%  : Attributes of the text (color, blink, bold, etc.)
SUB scroll.down (lines%, x1%, y1%, x2%, y2%, attrib%)
  asm$ = ""
  asm$ = asm$ + CHR$(&H55)                            'push bp
  asm$ = asm$ + CHR$(&H89) + CHR$(&HE5)               'mov bp, sp
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H10)  'mov bx, [bp+10]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H7)                'mov ax, [bx]
  asm$ = asm$ + CHR$(&HB4) + CHR$(&H7)                'mvo ah, 07
  asm$ = asm$ + CHR$(&H50)                            'push ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HE)   'mov bx, [bp+0e]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H7)                'mov ax, [bx]
  asm$ = asm$ + CHR$(&HB1) + CHR$(&H8)                'mov cl, 08
  asm$ = asm$ + CHR$(&HD3) + CHR$(&HE0)               'shl ax, cl
  asm$ = asm$ + CHR$(&H50)                            'push ax,
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC)   'mov bx, [bp+0c]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&HF)                'mov cx, [bx]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)   'mov bx, [bp+0a]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)               'mov dx, [bx]
  asm$ = asm$ + CHR$(&H88) + CHR$(&HCC)               'mov ah, cl
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)   'mov bx, [bp+0a]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)               'mov dx, [bx]
  asm$ = asm$ + CHR$(&H88) + CHR$(&HCC)               'mov ah, cl
  asm$ = asm$ + CHR$(&H88) + CHR$(&HD0)               'mov al, dl
  asm$ = asm$ + CHR$(&H50)                            'push ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8)   'mov bx, [bp+08]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&HF)                'mov cx, [bx]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)   'mov bx, [bp+06]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)               'mov dx, [bx]
  asm$ = asm$ + CHR$(&H88) + CHR$(&HCC)               'mov ah, cl
  asm$ = asm$ + CHR$(&H88) + CHR$(&HD0)               'mov al, dl
  asm$ = asm$ + CHR$(&H50)                            'push ax
  asm$ = asm$ + CHR$(&H5A)                            'pop dx
  asm$ = asm$ + CHR$(&H59)                            'pop cx
  asm$ = asm$ + CHR$(&H5B)                            'pop bx
  asm$ = asm$ + CHR$(&H58)                            'pop ax
  asm$ = asm$ + CHR$(&HCD) + CHR$(&H10)               'int 10
  asm$ = asm$ + CHR$(&H5D)                            'pop bp
  asm$ = asm$ + CHR$(&HCB)                            'retf
  asmseg% = VARSEG(asm$)
  asmoff% = SADD(asm$)
  DEF SEG = asmseg%
  CALL absolute(lines%, attrib%, y1% - 1, x1% - 1, y2% - 1, x2% - 1, asmoff%)
  DEF SEG
END SUB

'Scrolls up text on screen.
'INPUTS;
'* lines%   : Scroll this many lines up
'* x1%, y1% : Top-left coordinate
'* x2%, y2% : Bottom-right coordinate
'* (x1, y1)-(x2, y2) is the "box" area to be scrolled up.
'* attrib%  : Attributes of the text (color, blink, bold, etc.)
SUB scroll.up (lines%, x1%, y1%, x2%, y2%, attrib%)
  asm$ = ""
  asm$ = asm$ + CHR$(&H55)                            'push bp
  asm$ = asm$ + CHR$(&H89) + CHR$(&HE5)               'mov bp, sp
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H10)  'mov bx, [bp+10]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H7)                'mov ax, [bx]
  asm$ = asm$ + CHR$(&HB4) + CHR$(&H6)                'mvo ah, 06
  asm$ = asm$ + CHR$(&H50)                            'push ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HE)   'mov bx, [bp+0e]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H7)                'mov ax, [bx]
  asm$ = asm$ + CHR$(&HB1) + CHR$(&H8)                'mov cl, 08
  asm$ = asm$ + CHR$(&HD3) + CHR$(&HE0)               'shl ax, cl
  asm$ = asm$ + CHR$(&H50)                            'push ax,
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC)   'mov bx, [bp+0c]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&HF)                'mov cx, [bx]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)   'mov bx, [bp+0a]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)               'mov dx, [bx]
  asm$ = asm$ + CHR$(&H88) + CHR$(&HCC)               'mov ah, cl
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)   'mov bx, [bp+0a]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)               'mov dx, [bx]
  asm$ = asm$ + CHR$(&H88) + CHR$(&HCC)               'mov ah, cl
  asm$ = asm$ + CHR$(&H88) + CHR$(&HD0)               'mov al, dl
  asm$ = asm$ + CHR$(&H50)                            'push ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8)   'mov bx, [bp+08]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&HF)                'mov cx, [bx]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)   'mov bx, [bp+06]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)               'mov dx, [bx]
  asm$ = asm$ + CHR$(&H88) + CHR$(&HCC)               'mov ah, cl
  asm$ = asm$ + CHR$(&H88) + CHR$(&HD0)               'mov al, dl
  asm$ = asm$ + CHR$(&H50)                            'push ax
  asm$ = asm$ + CHR$(&H5A)                            'pop dx
  asm$ = asm$ + CHR$(&H59)                            'pop cx
  asm$ = asm$ + CHR$(&H5B)                            'pop bx
  asm$ = asm$ + CHR$(&H58)                            'pop ax
  asm$ = asm$ + CHR$(&HCD) + CHR$(&H10)               'int 10
  asm$ = asm$ + CHR$(&H5D)                            'pop bp
  asm$ = asm$ + CHR$(&HCB)                            'retf
  asmseg% = VARSEG(asm$)
  asmoff% = SADD(asm$)
  DEF SEG = asmseg%
  CALL absolute(lines%, attrib%, y1% - 1, x1% - 1, y2% - 1, x2% - 1, asmoff%)
  DEF SEG
END SUB

