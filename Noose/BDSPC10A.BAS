'BASDriveSpace version 1.0a -- Find free and total space on a drive
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
DECLARE FUNCTION drv.freespace# (drive$)
DECLARE FUNCTION drv.totalspace# (drive$)
'== END HEADER ==


'== START ==

CLS
INPUT "Enter of the drive to find free and total spaces: ", drive$
freespace = drv.freespace(drive$)
IF freespace = -1 THEN
  PRINT "Error during free space calculation!"
  PRINT "Terminating program...."
  END
END IF
totalspace = drv.totalspace(drive$)
IF totalspace = -1 THEN
  PRINT "Error during total space calculation!"
  PRINT "Terminating program...."
  END
END IF
PRINT "The free space on "; LEFT$(drive$, 1); " is:";
 PRINT USING " ###############"; freespace;
 PRINT " bytes."
PRINT "The total space on "; LEFT$(drive$, 1); " is:";
 PRINT USING "###############"; totalspace;
 PRINT " bytes."
END

'Finds out the available free space of a drive in bytes.
'INPUT:
'þ Drive$ is the letter representation of the drive one wants to find out the
'  free space of.  If its length is zero, it is assumed to be the current
'  drive.  No space must come in front of the string (ie - " A:\" is not a
'  valid string)
'RETURN ON SUCCESS:
'þ The free space of the drive
'RETURN ON ERROR:
'þ -1 is returned on any type of error.  Such errors include non-alphabetic
'  drive letters and no such drive error
'COMMENT:
'þ Lost clusters are assumed to be in use
FUNCTION drv.freespace# (drive$)
  'convert drive letter to corresponding letter
  driveseg% = VARSEG(drive$)  'get drive$'s segment
  driveoff% = SADD(drive$)    'get drive$'s offset
  DEF SEG = driveseg%         'define segment
  drive% = PEEK(driveoff%)    'get ASCII equivalent of first letter of drive$
  DEF SEG
  IF drive$ = "" THEN         'if length of drive$ is zero, use default drive
    drive% = 0  'default drive
  ELSEIF drive% >= ASC("A") AND drive% <= ASC("Z") THEN
    drive% = drive% - 64
  ELSEIF drive% >= ASC("a") AND drive% <= ASC("z") THEN
    drive% = drive% - 96
  ELSE                        'if nothing fits, exit with error code (-1)
    drv.freespace = -1
    EXIT FUNCTION
  END IF

  'store machine code
  asm$ = ""
  asm$ = asm$ + CHR$(&H55)                              'push bp
  asm$ = asm$ + CHR$(&H89) + CHR$(&HE5)                 'mov bp, sp
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)     'mov bx, [bp+06]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)                 'mov dx, [bx]
  asm$ = asm$ + CHR$(&HB4) + CHR$(&H36)                 'mov ah, 36h
  asm$ = asm$ + CHR$(&HCD) + CHR$(&H21)                 'int 21h
  asm$ = asm$ + CHR$(&H53)                              'push bx
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC)     'mov bx, [bp+0c]
  asm$ = asm$ + CHR$(&H89) + CHR$(&H7)                  'mov [bx], ax
  asm$ = asm$ + CHR$(&H58)                              'pop ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)     'mov bx, [bp+0a]
  asm$ = asm$ + CHR$(&H89) + CHR$(&H7)                  'mov [bx], ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8)     'mov bx, [bp+08]
  asm$ = asm$ + CHR$(&H89) + CHR$(&HF)                  'mov [bx], cx
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)     'mov bx, [bp+06]
  asm$ = asm$ + CHR$(&H89) + CHR$(&H17)                 'mov [bx], dx
  asm$ = asm$ + CHR$(&H5D)                              'pop bp
  asm$ = asm$ + CHR$(&HCA) + CHR$(&H8) + CHR$(&H0)      'retf 0008h

  'execute
  asmseg% = VARSEG(asm$)      'get segment of stored machine codes
  asmoff% = SADD(asm$)        'get offset of stored machine codes
  DEF SEG = asmseg%           'define segment
  dx% = drive%                'transfer data from drive% to dx%
  CALL absolute(var1%, var2%, ax%, bx%, cx%, dx%, asmoff%) 'execute
  DEF SEG
  'if invalid drive
  IF ax% = &HFFFF THEN drv.freespace = -1: EXIT FUNCTION

  'convert integers to long integers (because of sign problems)
  ax& = ax% AND &H7FFF                            'ax = sectors per cluster
  IF (ax% AND &H8000) THEN ax& = (ax& OR &H8000&)
  bx& = bx% AND &H7FFF                            'bx = number of free clstrs
  IF (bx% AND &H8000) THEN bx& = (bx& OR &H8000&)
  cx& = cx% AND &H7FFF                            'cx = bytes per sector
  IF (cx% AND &H8000) THEN cx& = (cx& OR &H8000&)
  dx& = dx% AND &H7FFF                            'dx = total clusters
  IF (dx% AND &H8000) THEN dx& = (dx& OR &H8000&)

  'calculate free space and return
  drv.freespace# = 1# * ax& * bx& * cx& '(1# is for typecasting just in case)
END FUNCTION

'Finds out the total space of a drive in bytes.
'INPUT:
'þ Drive$ is the letter representation of the drive one wants to find out the
'  total space of.  If its length is zero, it is assumed to be the current
'  drive.  No space must come in front of the string (ie - " A:\" is not a
'  valid string)
'RETURN ON SUCCESS:
'þ The total space of the drive
'RETURN ON ERROR:
'þ -1 is returned on any type of error.  Such errors include non-alphabetic
'  drive letters and no such drive error)
FUNCTION drv.totalspace# (drive$)
  'convert drive letter to corresponding letter
  driveseg% = VARSEG(drive$)  'get drive$'s segment
  driveoff% = SADD(drive$)    'get drive$'s offset
  DEF SEG = driveseg%         'define segment
  drive% = PEEK(driveoff%)    'get ASCII equivalent of first letter of drive$
  DEF SEG
  IF drive$ = "" THEN         'if length of drive$ is zero, use default drive
    drive% = 0  'default drive
  ELSEIF drive% >= ASC("A") AND drive% <= ASC("Z") THEN
    drive% = drive% - 64
  ELSEIF drive% >= ASC("a") AND drive% <= ASC("z") THEN
    drive% = drive% - 96
  ELSE                        'if nothing fits, exit with error code (-1)
    drv.totalspace = -1
    EXIT FUNCTION
  END IF

  'store machine code
  asm$ = ""
  asm$ = asm$ + CHR$(&H55)                              'push bp
  asm$ = asm$ + CHR$(&H89) + CHR$(&HE5)                 'mov bp, sp
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)     'mov bx, [bp+06]
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H17)                 'mov dx, [bx]
  asm$ = asm$ + CHR$(&HB4) + CHR$(&H36)                 'mov ah, 36h
  asm$ = asm$ + CHR$(&HCD) + CHR$(&H21)                 'int 21h
  asm$ = asm$ + CHR$(&H53)                              'push bx
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HC)     'mov bx, [bp+0c]
  asm$ = asm$ + CHR$(&H89) + CHR$(&H7)                  'mov [bx], ax
  asm$ = asm$ + CHR$(&H58)                              'pop ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&HA)     'mov bx, [bp+0a]
  asm$ = asm$ + CHR$(&H89) + CHR$(&H7)                  'mov [bx], ax
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H8)     'mov bx, [bp+08]
  asm$ = asm$ + CHR$(&H89) + CHR$(&HF)                  'mov [bx], cx
  asm$ = asm$ + CHR$(&H8B) + CHR$(&H5E) + CHR$(&H6)     'mov bx, [bp+06]
  asm$ = asm$ + CHR$(&H89) + CHR$(&H17)                 'mov [bx], dx
  asm$ = asm$ + CHR$(&H5D)                              'pop bp
  asm$ = asm$ + CHR$(&HCA) + CHR$(&H8) + CHR$(&H0)      'retf 0008h

  'execute
  asmseg% = VARSEG(asm$)      'get segment of stored machine codes
  asmoff% = SADD(asm$)        'get offset of stored machine codes
  DEF SEG = asmseg%           'define segment
  dx% = drive%                'transfer data from drive% to dx%
  CALL absolute(var1%, var2%, ax%, bx%, cx%, dx%, asmoff%) 'execute
  DEF SEG
  'if invalid drive
  IF ax% = &HFFFF THEN drv.totalspace = -1: EXIT FUNCTION

  'convert integers to long integers (because of sign problems)
  ax& = ax% AND &H7FFF                            'ax = sectors per cluster
  IF (ax% AND &H8000) THEN ax& = (ax& OR &H8000&)
  bx& = bx% AND &H7FFF                            'bx = number of free clstrs
  IF (bx% AND &H8000) THEN bx& = (bx& OR &H8000&)
  cx& = cx% AND &H7FFF                            'cx = bytes per sector
  IF (cx% AND &H8000) THEN cx& = (cx& OR &H8000&)
  dx& = dx% AND &H7FFF                            'dx = total clusters
  IF (dx% AND &H8000) THEN dx& = (dx& OR &H8000&)

  'calculate total space and return
  drv.totalspace# = 1# * ax& * cx& * dx& '(1# is for typecasting just in case)
END FUNCTION

