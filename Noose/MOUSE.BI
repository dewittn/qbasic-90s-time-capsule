
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                                     ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    '
	' Robert Seace                        ; QB Mouse Support Routines ;    '
	' RFD 2  Box 229                      '''''''''''''''''''''''''''''    '
	' Littleton, NH  03561                  Feel free to distribute!       '
	'                                                                      '
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'                        Filename: MOUSE.BI                            '
	'   Include by using the "'$include: 'mouse.bi'" metacommand           '
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	  
	' Must include the assembly support routines in QB.BI
	'$INCLUDE: 'qb.bi'

	' Note: To use these routines, you must either link in the compiled
	'       object code (MOUSE.OBJ) and the QB.LIB library, or simply use
	'       the included MOUSE.LIB library.  At the linker's prompt for
	'       libraries, type "mouse.lib" (actually, I would probably type
	'       "bcom45.lib+mouse.lib", which would also link in the compile
	'       time library to produce a stand-alone executable file, as well).
	'       Using this MOUSE.LIB method, you need not bother to link in the
	'       MOUSE.OBJ object code along with your own compiled object code,
	'       nor do you need to link in the QB.LIB library, as it is already
	'       contained within the MOUSE.LIB library.  Simply include MOUSE.BI
	'       at the top of your code (use the "'$include: 'mouse.bi'"
	'       metacommand; note that it must be within a comment, and there
	'       should be only spaces/tabs next to the dollar sign, unless it
	'       is put directly next to the FIRST single-quote (apostrophe)
	'       marking the comment), then compile your code, and link it with
	'       the MOUSE.LIB library, and you'll be all set.
	'       If you want to use the mouse functions within the QB environment,
	'       use the MOUSE.QLB QuickLibrary (start QB using the /L parameter:
	'       "qb /L mouse").
   
	
	' Structures/types used by my functions:

	' MouseEvent structure.  This stores the event information which is
	' returned by several of my functions, to indicate the position and
	' button status of the mouse.  To use such a function, just dimension
	' a variable as MouseEvent type (eg: "DIM event AS MouseEvent"), then
	' pass that variable to the function.  When the function/subroutine
	' returns, the MouseEvent variable that you passed it will be filled in
	' with the mouse info (dependent upon if there is a certain new event
	' in some functions), which you can then examine and use.
	' Note: The x and y positions of the mouse pointer are converted to
	' the appropriate positions for the screen size/mode which you specify
	' in MouseInit.  Eg: In text-mode (0), x would be between 1 and 80, and
	' y would be between 1 and 25.

	TYPE MouseEvent             ' Mouse event structure type
		x AS INTEGER            ' column position of mouse
		y AS INTEGER            ' row position of mouse
		buttons AS INTEGER      ' button info: LEFT, RIGHT, and/or MIDDLE
	END TYPE

	' BitMap structure.  This is used for changing the shape of the graphics
	' mouse pointer with the MouseGraphicsPtr subroutine.  You need to
	' dimension a variable of type BitMap (eg: "DIM map AS BitMap") then
	' fill in all the bitmap info and pass it to MouseGraphicsPtr along
	' with the position of the hotspot (spot returned as the location of the
	' mouse pointer) within the bitmap.  The BitMap structure contains 2
	' separate bitmaps: a screen mask, and a cursor mask.  Each are 16 x 16
	' bitmaps (16 integers, each 16 bits long).  The screen mask is first
	' ANDed with what is on the screen where the pointer is going to appear,
	' then the cursor mask is XORed with the result of that.  If you want no
	' effect from the screen mask (a see-through type pointer), just set all
	' screen mask bits to 1 (16 integers all equal to NOT 0 or -1).  If you
	' want the pointer to be solid and over-write the objects on the screen,
	' set the screen mask bits to be the exact compliments of the cursor
	' (pointer) mask bits (set each screen mask integer to equal the NOT of
	' the corresponding cursor mask integer).  If you want solid over-writing
	' but with a black outline around the pointer (useful when a white
	' pointer is on top of a white patch of screen), then you have to do a
	' little work. ;-)  You need to set all bits that are 0 in the cursor
	' mask to 1 in the screen mask, EXCEPT for a single bit wherever a 1 bit
	' bit in the cursor mask meets a 0 bit; the screen mask bit corresponding
	' to that edge 0 bit should be set to 0, not 1 as per normal.  Of course,
	' the easiest way of dealing with all of this confusing bitmap stuff is
	' just to use my included bitmap editor to produce the bitmaps, all in
	' the correct form to use with my functions. ;-)  A few useful bitmaps
	' that are already made are included in a file called BITMAPS.TXT,
	' which you can Merge into your code for use, as well.

	TYPE BitMap                 ' Bitmap structure type
		screen1 AS INTEGER
		screen2 AS INTEGER
		screen3 AS INTEGER
		screen4 AS INTEGER
		screen5 AS INTEGER
		screen6 AS INTEGER
		screen7 AS INTEGER
		screen8 AS INTEGER      ' 16 integers (each 16 bits) to represent
		screen9 AS INTEGER      ' the screen mask bitmap. (I suggest setting
		screen10 AS INTEGER     ' all bits to 1 (-1 or NOT 0 in Basic's
		screen11 AS INTEGER     ' method of storing integers) unless you
		screen12 AS INTEGER     ' want a solid over-writing type pointer.)
		screen13 AS INTEGER
		screen14 AS INTEGER
		screen15 AS INTEGER
		screen16 AS INTEGER
		ptr1 AS INTEGER
		ptr2 AS INTEGER
		ptr3 AS INTEGER
		ptr4 AS INTEGER
		ptr5 AS INTEGER
		ptr6 AS INTEGER
		ptr7 AS INTEGER
		ptr8 AS INTEGER         ' 16 integers (each 16 bits) to represent
		ptr9 AS INTEGER         ' the cursor mask bitmap. (This is the
		ptr10 AS INTEGER        ' actual bitmap which determines the shape
		ptr11 AS INTEGER        ' of the mouse pointer.)
		ptr12 AS INTEGER
		ptr13 AS INTEGER
		ptr14 AS INTEGER
		ptr15 AS INTEGER
		ptr16 AS INTEGER
	END TYPE

	
	' Set default type for my Mouse functions (beginning with "M"): Integer.

	DEFINT M

	' The following functions/subroutines are available for use:

	' ---------------------------=< MouseInit >=---------------------------
	' Function which initializes the mouse for use.  The argument passed
	' should be 0 for normal text-mode (80 columns X 25 rows) screen, or
	' 1 for graphics-mode resolution 1 (320 X 200), or 2 for graphics-mode
	' resolution 2 (640 X 200; same as mouse's own virtual screen).  The
	' return value is 0 if no mouse is available for use, otherwise it is
	' the number of buttons available on the mouse.
	
	DECLARE FUNCTION MouseInit (mode AS INTEGER)
	
	' ---------------------------=< MouseSetPos >=-------------------------
	' Sets the position of the mouse pointer.  The x argument is the column
	' to move to, and the y argument is the row to move to.  (Range of
	' legal values determined by screen mode, as set by MouseInit.  For
	' text-mode 0: x is 1 - 80, y is 1 - 25.  For graphics-mode 1: x is
	' 0 - 319, y is 0 - 199.  For graphics-mode 2: x is 0 - 639, y is
	' 0 - 199.)
	
	DECLARE SUB MouseSetPos (x AS INTEGER, y AS INTEGER)
	
	' ----------------------------=< MouseHide >=--------------------------
	' Hides the mouse pointer (shuts it off).  I advise hiding before every
	' CLS, then turning it back on with MouseShow after screen is fully
	' drawn (especially if changing screen color).
	
	DECLARE SUB MouseHide ()
	
	' ----------------------------=< MouseShow >=--------------------------
	' Shows the mouse pointer (turns it on).  See comments for MouseHide.
	' Pointer is turned on initially by MouseInit.
	
	DECLARE SUB MouseShow ()
	
	' ---------------------------=< MouseMove >=---------------------------
	' Detects whether or not the mouse has moved from its last position
	' (actual screen position, which is dependent upon screen mode).  If a
	' movement has occured, -1 (TRUE) is returned and the passed MouseEvent
	' structure is filled in with the appropriate info.  If no movement has
	' occured, then 0 (FALSE) is returned, and nothing is filled in on the
	' passed MouseEvent structure.
	
	DECLARE FUNCTION MouseMove (event AS MouseEvent)

	' ---------------------------=< MouseButton >=-------------------------
	' Detects whether or not a mouse button has been pressed.  Works the
	' same way as MouseMove (returns TRUE and updates passed MouseEvent
	' structure if button pressed, else returns FALSE).  The second
	' parameter of the function determines whether or not the buttons will
	' be "debounced" after reading a press.  Debouncing means that the
	' function will wait until the button is no longer pressed anymore
	' before it returns to the caller.  This is a good thing to use,
	' because a single click of a mouse button can often produce several
	' button-press events, due to the sensitivity of the mouse buttons.
	' Using the debounce option (passing TRUE, or any non-zero value, as
	' the second parameter) eliminates these extra button-press events and
	' prevents possible problems with thinking the user has clicked more
	' than he has.  However, I left the option of not debouncing because
	' it is possible you may want to keep track of held-down buttons (for
	' dragging the mouse through pull-down menus, or other such things
	' where the user must hold down the button); in this case, simply pass
	' FALSE (0) as the second parameter.

	DECLARE FUNCTION MouseButton (event AS MouseEvent, debounce AS INTEGER)

	' --------------------------=< MouseNewEvent >=-------------------------
	' This is sort of a combination of MouseMove and MouseButton.  It will
	' return TRUE if either the mouse pointer has moved from its last
	' position, or if a button has been pressed.  (Note: Debouncing is not
	' optional in this function; it always debounces.  If you need no
	' debouncing, then you'll have to use MouseButton and MouseMove
	' individually.)  A call to this function is essentially equivalent to
	' "MouseButton(event, TRUE) OR MouseMove(event)".

	DECLARE FUNCTION MouseNewEvent (event AS MouseEvent)
	
	' --------------------------=< MouseGetInfo >=--------------------------
	' This function gets the position of mouse pointer (actual screen
	' position, dependent upon screen mode), and the button info, whether
	' or not there is a new event (position has changed or button pressed).
	' The info is returned through the event parameter passed to it.
	' Note: Calling this subroutine updates the last known values for the
	' position of the mouse pointer, so that even if the position IS new
	' (it has moved), then calling MouseMove after calling this will NOT
	' reveal the change in position, as you've chosen to ignore the move
	' by calling this subroutine.
	' Note: No debouncing at all is done in this subroutine.  It simply
	' gives you the current status of the buttons, without caring whether
	' any of them are pressed or not.

	DECLARE SUB MouseGetInfo (event AS MouseEvent)

	' --------------------------=< MouseTextPtr >=----------------------------
	' This subroutine sets the color and shape of the text-mode mouse
	' pointer.  It normally defaults to simply a white block-cursor, but
	' you can change that with this subroutine.  The new pointer
	' attributes (cl, color of the pointer, and ch, character to use for the
	' pointer) will be XORed with the result of ANDing the screen attributes
	' (scl, screen color, and sch, screen character) with whatever is on the
	' screen where the pointer is to be, which will produce the color/shape
	' you see on the screen at that spot.  If you don't want the screen mask
	' to have any effect, just pass in a screen character with all 1 bits
	' CHR$(255) will work), as pass in a color that is the compliment of the
	' cursor color (use the NOT operator).  The colors and characters you
	' pass in will be converted into bit masks.
	' Note: If you pass more than a single-character string as the char,
	' only the first character will be used.

	DECLARE SUB MouseTextPtr (scl AS INTEGER, sch AS STRING, cl AS INTEGER, ch AS STRING)

	' ----------------------=< MouseGraphicsPtr >=------------------------
	' The graphics-mode version of MouseTextPrt.  You pass it the position
	' of the cursor hot-spot within the bitmap, and the actual 16 bit X
	' 16 bit bitmap you want to use as the new pointer shape, as well as a
	' similar such bitmap for the screen mask (this first gets ANDed with
	' what is on the screen where the pointer is, then the pointer's bitmap
	' gets XORed with the result of that).  There is a type defined (BitMap)
	' which contains the 32 integers (each 16 bits) necessary to hold both
	' of these bitmaps.

	DECLARE SUB MouseGraphicsPtr (hotx AS INTEGER, hoty AS INTEGER, map AS BitMap)

   
	
	' Some constants which are useful with my functions:
	 
	' Mouse button constants.  These can be used to check the status of
	' the mouse buttons, as returned in the buttons field of the MouseEvent
	' structure.  Examples of use:
	'   event.buttons AND LEFT > 0 == left button pressed (same for rest)
	'   event.buttons AND (LEFT OR RIGHT) > 0 == left & right buttons pressed
	'   event.buttons = LEFT  == ONLY left button pressed (same for rest)
	'   event.buttons = (LEFT + RIGHT)  == ONLY left & right buttons pressed
	'   etc...

	CONST LEFT = &H1            ' Left mouse button pressed
	CONST RIGHT = &H2           ' Right mouse button pressed
	CONST MIDDLE = &H4          ' Middle mouse button pressed

	' Boolean constants.  These are Basic's representations of TRUE and
	' FALSE.  They are returned by some of my functions.  You can use these
	' constants to check the return value (eg: "IF MouseMove(event) = TRUE")
	' or, better yet, just use the fact that a boolean value is being
	' returned and use the functions alone (eg: "IF MouseMove(event)").

	CONST FALSE = 0             ' Basic's representation of boolean FALSE
	CONST TRUE = NOT 0          ' Basic's representation of TRUE; -1
	

