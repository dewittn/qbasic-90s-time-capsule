'NEWTXT.BAS - by Scott Hoopes Compuserve 73304,274
'placed into the public domain March 1995

'demonstrates how to create your own characters in text mode

'the default character for VGA is a 8x16 cell like the following:
'                  00000000
'                  00000000
'                  11111111
'                  11011011
'                  10011001
'                  00011000
'                  00011000
'                  00011000
'                  00011000
'                  00011000
'                  00011000
'                  00011000
'                  01111110
'                  00000000
'                  00000000
'                  00000000
'the above might be how a 'T' is represented.
'for demonstration, we will change the definition of ASCII 255 which by
'default would look like all zeros in the above example.

'first we need to access BIOS interrupts so the next few lines are
'neccessary
DEFINT A-Z
'$INCLUDE: 'qb.bi'
DIM inregs AS RegTypeX, outregs AS RegTypeX

'clear the screen and put some ASCII 255's on the screen
CLS
PRINT STRING$(80, 255);                    'so we can see it

DIM holder AS STRING * 16   'this is where we put our new ASCII 255
					   'must be a multiple of 16 bytes since
					   'each character is 16 bytes long

'now we develop a new character to replace ASCII 255
'                  00000000  0
'                  00000000  0
'                  00011000  24
'                  00100100  36
'                  01011010  90
'                  10100101  165
'                  10100001  161
'                  10100001  161    <-- these are the numbers we must
'                  10100101  165        put in 'holder' to represent
'                  01011010  90         our new char
'                  00100100  36
'                  00011000  24
'                  00000000  0
'                  00000000  0
'                  00000000  0
'                  00000000  0

DEF SEG = VARSEG(holder)      'set default segment to that of our
						'new character
						'we must poke each of the above values
						'into 'holder'
POKE VARPTR(holder), 0        'VARPTR(holder) is the offset of 'holder'
POKE VARPTR(holder) + 1, 0
POKE VARPTR(holder) + 2, 24
POKE VARPTR(holder) + 3, 36
POKE VARPTR(holder) + 4, 90
POKE VARPTR(holder) + 5, 165
POKE VARPTR(holder) + 6, 161
POKE VARPTR(holder) + 7, 161
POKE VARPTR(holder) + 8, 165
POKE VARPTR(holder) + 9, 90
POKE VARPTR(holder) + 10, 36
POKE VARPTR(holder) + 11, 24
POKE VARPTR(holder) + 12, 0
POKE VARPTR(holder) + 13, 0
POKE VARPTR(holder) + 14, 0
POKE VARPTR(holder) + 15, 0

DEF SEG                       'reset the default segment to BASIC

 inregs.ax = &H1100           'BIOS function to load new char definition
 inregs.bx = 16 * 256         '16 bytes/char - for 256 characters
 inregs.cx = 1                'number of characters to change
 inregs.dx = 255              'the character to change
 inregs.es = VARSEG(holder)   'segment of holder
 inregs.bp = VARPTR(holder)   'offset of holder
 CALL INTERRUPTX(&H10, inregs, outregs)

 SLEEP                        'so we see it until a key press


'now we must reset the video state so the BIOS resumes using the correct
'character definitions

 inregs.ax = &H3     'BIOS function to reset the video display to 80
				 'cols x 25 lines
 CALL INTERRUPTX(&H10, inregs, outregs)

END

