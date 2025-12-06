'----------------------------------------------------
'  FLIPLAY.BAS - FLI/FLC Animation Flic Player v2.0
'----------------------------------------------------
'       (c) Carl Gorringe 2/1/96
'
' This program will play an animation flic
'       FLI or FLC file in SCREEN 13.
'
'   This will only work with 320 x 200 flics.
' Although I have speeded up the program some
' by using POKEs instead of PSET to display
' on the screen, there is still much to be done
' to speed things up. For example, disk access
' could be greatly speeded up by buffering large
' portions of the file to memory before decoding
' it.
'
'    Released to the Public Domain.
'  You may use this any way you see fit,
'  just remember to give credit where
'  credit is due. This program is provided
'  "AS IS", therefore I am not responsible
'  for any consequences of using it.
'
' I can be contacted be sending a message to:
' CARL GORRINGE at FIDOnet's QUICK_BAS echo or
' Internet e-mail: <carl.gorringe@rhosoft.com>
'
'------------------------------------------------

CONST FALSE = 0
CONST TRUE = NOT FALSE

TYPE FLIheaderType
	Size AS LONG               'Size (in bytes) of entire Flic file
	ID AS INTEGER              'Always &hAF11 for FLI files
	Frames AS INTEGER          'Number of Frames (not including ring frame)
	Xres AS INTEGER            'Always 320 for FLI files
	Yres AS INTEGER            'Always 200 for FLI files
	ColorBits AS INTEGER       'Always 8 for FLI files (bits per pixel)
	Flags AS INTEGER           'Always 0 for FLI files
	Speed AS INTEGER           'Pauses 1/70 second between frames (FLI only)
	Reserved AS STRING * 110
END TYPE

TYPE FLIframeChunkType
	Size AS LONG               'Size of frame chunk, including header
	ID AS INTEGER              'Always &hF1FA for FLI files
	Chunks AS INTEGER          'Number of subordinate chunks in frame chunk
	Reserved AS STRING * 8
END TYPE

TYPE FLIdataChunkType
	Size AS LONG               'Size of data chunk, including header
	ID AS INTEGER              'Data Type ID (see below)
END TYPE

'-- Data Type ID has following values: --
'        4  - COLOR256 : Change Palette using values 0-255 for RGB
'        7  - SS2      : (FLC) Word Aligned Delta Compression (Pixel Data)
'        11 - COLOR64  : Change Palette using values 0-63 for RGB
'        12 - LC       : Byte Aligned Delta Compression (Pixel Data)
'        13 - BLACK    : Black Screen
'        15 - BRUN     : Byte Run Length Compression (Pixel Data)
'        16 - COPY     : Bitmap of entire image (Pixel Data)

DECLARE SUB FLIplay (FileName$, ErrCode%)

'---------------------------------------------------------------------------

'--- Credits ---
	SCREEN 0: WIDTH 80, 25
	CLS
	PRINT "FLIPLAY.BAS v2.0 - Programmed by Carl Gorringe <carl.gorringe@rhosoft.com>"
	PRINT
	PRINT

'--- Input File Name ---
	PRINT "Enter FLI or FLC File Name with extension (Enter=Quit):"
	INPUT "> ", FileName$

	IF LTRIM$(RTRIM$(FileName$)) = "" THEN END
	IF INSTR(FileName$, ".") = 0 THEN FileName$ = FileName$ + ".FLI"

'--- Setup Screen ---
	SCREEN 13
	CLS
	LOCATE 25, 1: PRINT "Loading "; FileName$;
	LOCATE 1, 1

'--- Simple File Exist Checking ---
	FileNum% = FREEFILE
	OPEN FileName$ FOR INPUT AS FileNum%
	CLOSE FileNum%

'--- Play Animation Flic ---
	CALL FLIplay(FileName$, ErrCode%)

	IF ErrCode% > 0 THEN
		LOCATE 3, 1
		PRINT "Error Occured! : ErrCode ="; ErrCode%
	END IF

'--- Pause to Exit ---
	I$ = INPUT$(1)
	SCREEN 0: WIDTH 80, 25: CLS
	END

SUB FLIplay (FileName$, ErrCode%)

' (c) Carl Gorringe  2/1/96  << v2.0 >>
'-----------------------------------------
'  Plays a FLI or FLC Animation Flic File.
'  Make sure graphics mode is set to
'  SCREEN 13 before entering. Also,
'  this doesn't check if FileName$ exists!
'  ErrCode% is Error Code returned: 0=OK
'-----------------------------------------
'<< Done - Tested OK >>

DIM Header AS FLIheaderType
DIM FrameChunk AS FLIframeChunkType
DIM DataChunk AS FLIdataChunkType
DIM Byte AS STRING * 1

ErrCode% = 0

FileNum% = FREEFILE
OPEN FileName$ FOR BINARY AS FileNum%

'--- Get the File's Header ---
	GET #FileNum%, , Header

	IF Header.ID <> &HAF11 AND Header.ID <> &HAF12 THEN
		ErrCode% = 1            '<-- Not a FLI or FLC file (error)
		CLOSE FileNum%
		EXIT SUB
	END IF
	IF Header.Xres <> 320 OR Header.Yres <> 200 THEN
		ErrCode% = 2            '<-- Not a 320x200x256 Color Flic (error)
		LOCATE 21, 1: PRINT "Xres:"; Header.Xres;
		LOCATE 22, 1: PRINT "Yres:"; Header.Yres;
		LOCATE 23, 1: PRINT "ColorBits:"; Header.ColorBits;
		LOCATE 1, 1
		CLOSE FileNum%
		EXIT SUB
	END IF

'--- Loop Thru Each Frame ---
	DEF SEG = &HA000
	FOR Frame% = 1 TO Header.Frames

		'*** FRAMES: Displays Frame Number in Upper-Left Corner ***
		LOCATE 1, 1: PRINT Frame%;
	  
		FramePos& = LOC(FileNum%)        '<-- Needed? --
		GET #FileNum%, , FrameChunk

		IF FrameChunk.ID = &HF1FA THEN
		  
			FOR Chunk% = 1 TO FrameChunk.Chunks
				
				DataPos& = LOC(FileNum%)        '<-- Needed? -- << v1.1 >>
				GET #FileNum%, , DataChunk

				SELECT CASE DataChunk.ID
				 CASE 4, 11        '--*-- COLOR256/COLOR64: Change Palette --*--
				  
					Index% = 0
					GET #FileNum%, , PacketNum%
					FOR A% = 1 TO PacketNum%
						GET #FileNum%, , Byte: SkipByte% = ASC(Byte)
						GET #FileNum%, , Byte: ChangeByte% = ASC(Byte)
						Index% = Index% + SkipByte%
						IF ChangeByte% = 0 THEN ChangeByte% = 256
						FOR B% = 1 TO ChangeByte%
							GET #FileNum%, , Byte: RedByte% = ASC(Byte)
							GET #FileNum%, , Byte: GreenByte% = ASC(Byte)
							GET #FileNum%, , Byte: BlueByte% = ASC(Byte)
							IF DataChunk.ID = 4 THEN
								'-- Change Palette (0-255) --
								OUT &H3C8, Index%
								OUT &H3C9, RedByte% \ 4
								OUT &H3C9, GreenByte% \ 4
								OUT &H3C9, BlueByte% \ 4
							ELSE
								'-- Change Palette (0-63) --
								OUT &H3C8, Index%
								OUT &H3C9, RedByte%
								OUT &H3C9, GreenByte%
								OUT &H3C9, BlueByte%
							END IF
							Index% = Index% + 1
						NEXT B%
					NEXT A%
				
				 CASE 12           '--*-- LC: Byte Aligned Delta Compression --*--

					GET #FileNum%, , StartLine%
					GET #FileNum%, , Byte: NumLines% = ASC(Byte)
					LinePos& = StartLine% * 320&
					GET #FileNum%, , Byte: StartByte% = ASC(Byte)
					FOR Y% = 1 TO NumLines%
						GET #FileNum%, , Byte: PacketByte% = ASC(Byte)
						X% = StartByte%
						FOR A% = 1 TO PacketByte%
							GET #FileNum%, , Byte: SkipByte% = ASC(Byte)
							GET #FileNum%, , Byte: SizeByte% = ASC(Byte)
							X% = X% + SkipByte%
							IF SizeByte% > 127 THEN
								SizeByte% = -(SizeByte% OR &HFF00)
								GET #FileNum%, , Byte: PixelByte% = ASC(Byte)
								FOR B% = 1 TO SizeByte%
									'DEF SEG = &HA000
									POKE LinePos& + X%, PixelByte%
									'DEF SEG
									X% = X% + 1
								NEXT B%
							ELSE
								FOR B% = 1 TO SizeByte%
									GET #FileNum%, , Byte: PixelByte% = ASC(Byte)
									POKE LinePos& + X%, PixelByte%
									X% = X% + 1
								NEXT B%
							END IF
						NEXT A%
						LinePos& = LinePos& + 320
					NEXT Y%
					GET #FileNum%, , Byte      '<-- Needed? --
				
				 CASE 7  '--*-- SS2: Word Aligned Delta Compression (FLC Only)--*--

					LinePos& = 0
					GET #FileNum%, , NumLines%
					FOR Y% = 1 TO NumLines%
						''LastPixel% = -1    '<-- For ODD Width Flics (not used)
						DO
							GET #FileNum%, , Word%
							WordType% = (Word% AND &HC000)
							SELECT CASE WordType%
								CASE 0: PacketCount% = Word%
								CASE &H8000: LastPixel% = (Word% AND &HFF)
								CASE &HC000: LinePos& = LinePos& + (Word% * -320&)
							END SELECT
						LOOP UNTIL WordType% = 0
						X% = 0
						FOR A% = 1 TO PacketCount%
							GET #FileNum%, , Byte: SkipByte% = ASC(Byte)
							GET #FileNum%, , Byte: SizeByte% = ASC(Byte)
							X% = X% + SkipByte%
							IF SizeByte% > 127 THEN
								SizeByte% = -(SizeByte% OR &HFF00)
								'GET #FileNum%, , PixelWord%
								'PixelByte1% = PixelWord% AND &HFF
								'PixelByte2% = PixelWord% \ 255  'Don't Work for Neg #
								GET #FileNum%, , Byte: PixelByte1% = ASC(Byte)
								GET #FileNum%, , Byte: PixelByte2% = ASC(Byte)
								FOR B% = 1 TO SizeByte%
									POKE LinePos& + X%, PixelByte1%
									POKE LinePos& + X% + 1, PixelByte2%
									X% = X% + 2
								NEXT B%
							ELSE
								FOR B% = 1 TO SizeByte%
									'GET #FileNum%, , PixelWord%
									GET #FileNum%, , Byte: PixelByte1% = ASC(Byte)
									GET #FileNum%, , Byte: PixelByte2% = ASC(Byte)
									'POKE LinePos& + X%, (PixelWord% AND &HFF)
									'POKE LinePos& + X% + 1, (PixelWord% \ 255)
									POKE LinePos& + X%, PixelByte1%
									POKE LinePos& + X% + 1, PixelByte2%
									X% = X% + 2
								NEXT B%
							END IF
						NEXT A%
						''-- Following is for ODD Width Flics (not used) --
						''IF LastPixel% > -1 THEN
						''   POKE LinePos& + Header.Xres - 1, LastPixel%
						''END IF
						LinePos& = LinePos& + 320
					NEXT Y%
				
				 CASE 13           '--*-- BLACK: Black-Out Screen --*--
					CLS
				
				 CASE 15           '--*-- BRUN: Byte Run Length Compression --*--
				  
					LinePos& = 0
					FOR Y% = 1 TO 200
						GET #FileNum%, , Byte
						X% = 0
						DO
							GET #FileNum%, , Byte: SizeByte% = ASC(Byte)
							IF SizeByte% > 127 THEN
								SizeByte% = -(SizeByte% OR &HFF00)
								FOR B% = 1 TO SizeByte%
									GET #FileNum%, , Byte: PixelByte% = ASC(Byte)
									POKE LinePos& + X%, PixelByte%
									X% = X% + 1
								NEXT B%
							'ELSEIF SizeByte% = 0 THEN       '*** Test ***
							ELSE
								GET #FileNum%, , Byte: PixelByte% = ASC(Byte)
								FOR B% = 1 TO SizeByte%
									POKE LinePos& + X%, PixelByte%
									X% = X% + 1
								NEXT B%
							END IF
						LOOP UNTIL X% >= 320
						LinePos& = LinePos& + 320
					NEXT Y%
					GET #FileNum%, , Byte         '<-- Needed? --

				 CASE 16           '--*-- COPY: Bitmap of Entire Image --*--

					FOR P& = 0 TO 64000
						GET #FileNum%, , Byte: PixelByte% = ASC(Byte)
						POKE P&, PixelByte%
					NEXT P&
				
				 CASE ELSE         '--*-- Unknown Data Chunk, so Skip Over --*--

					'*** Test ***
					'LOCATE 24, 1: PRINT "Chunk:"; Chunk%; "  Unknown Data:"; DataChunk.ID;
					'I$ = INPUT$(1)
					'LOCATE 24, 1: PRINT "                                 ";

					'SEEK FileNum%, LOC(FileNum%) - LEN(DataChunk) + DataChunk.Size
					SEEK FileNum%, DataPos& + DataChunk.Size + 1    '<< v1.1 >>

				END SELECT
		  
			NEXT Chunk%

		ELSE  '--- Unknown Frame Chunk, so Skip Over ---

			'*** Test ***
			'LOCATE 1, 5: PRINT "Unknown Frame:"; FrameChunk.ID;
			'I$ = INPUT$(1)
			'LOCATE 1, 5: PRINT "                      ";

			'SEEK FileNum%, LOC(FileNum%) - LEN(FrameChunk) + FrameChunk.Size

		END IF
	  
		SEEK FileNum%, FramePos& + FrameChunk.Size + 1     '<-- Needed? --
	  
		'*** PAUSE: Uncomment Following Lines for a Pause Between Frames! ***
		'LOCATE 1, 35: PRINT "Pause";
		'I$ = INPUT$(1)
		'LOCATE 1, 35: PRINT "     ";

		''NOTE: The REAL Pause should be Header.Speed * 1/70 of a second,
		''      but because the frame updates are so slow, I didn't include
		''      the pause here. (FLI files ONLY!)

	NEXT Frame%
	DEF SEG

CLOSE FileNum%

LOCATE 1, 35: PRINT " Done";     '*** Test ***

END SUB

