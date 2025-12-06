 ' --------------------------------------------------------------
 '| WCRENAME.BAS                                                 |
 '| Rename function that supports wildcard characters in file    |
 '| names.  Logan Ashby - Public Domain - 06/28/92               |
 ' --------------------------------------------------------------
 DEFINT A-Z
 ' $INCLUDE: 'QBX.BI'
 '-----------'QB.BI' for QB45

 ' --------------------------------------------------------------
 '| FUNCTION and TYPE Declarations to be used in module level    |
 '| code which calls Rename% Function                            |
 ' --------------------------------------------------------------
 DECLARE FUNCTION ReName% (OldName$, NewName$)

 TYPE DosPListT
     ax AS INTEGER
     bx AS INTEGER
     cx AS INTEGER
     dx AS INTEGER
     SI AS INTEGER
     di AS INTEGER
     ds AS INTEGER
     es AS INTEGER
     Rsrvd AS INTEGER
     CompID AS INTEGER
     ProcID AS INTEGER
 END TYPE

 ' ------------------------ ReName% -----------------------------
 '|  Renames file(s) using DOS Interrupt calls.  Works across    |
 '|  subdirectories if necessary.  Returns 0 if successful, DOS  |
 '|  error code if it fails.                                     |
 ' --------------------------------------------------------------
 FUNCTION ReName% (OldName$, NewName$)

 DIM InRegX AS RegTypeX
 DIM OutRegX AS RegTypeX
 DIM DOSParmList AS DosPListT
 DIM FileNameBuf AS STRING * 128

 Null$ = CHR$(0)

 FileNameBuf = OldName$ + Null$     '| Canonicalize OldName$
 InRegX.ax = &H6000
 InRegX.ds = VARSEG(FileNameBuf)
 InRegX.es = VARSEG(FileNameBuf)
 InRegX.SI = VARPTR(FileNameBuf)
 InRegX.di = VARPTR(FileNameBuf)
 CALL InterruptX(&H21, InRegX, OutRegX)
 IF (OutRegX.flags AND 1) THEN
     ReName% = OutRegX.ax
     PRINT "Error in Canonicalizing OldName$"
     EXIT FUNCTION
 ELSE
     TmpOldName$ = LEFT$(FileNameBuf, INSTR(FileNameBuf, Null$))
 END IF

 FileNameBuf = NewName$ + Null$     '| Canonicalize NewName$
 CALL InterruptX(&H21, InRegX, OutRegX)
 IF (OutRegX.flags AND 1) THEN
     ReName% = OutRegX.ax
     PRINT "Error in Canonicalizing NewName$"
     EXIT FUNCTION
 ELSE
     TmpNewName$ = LEFT$(FileNameBuf, INSTR(FileNameBuf, Null$))
 END IF

 InRegX.ax = &H5100                 '| Get PSP Segment
 CALL InterruptX(&H21, InRegX, OutRegX)

 PSPSeg% = OutRegX.bx

 DOSParmList.ax = &H5600            '| Build DOS Parameter List
 DOSParmList.cx = 0                 '|   Structure.
 DOSParmList.dx = SADD(TmpOldName$)
 DOSParmList.ds = SSEG(TmpOldName$) '| Use VARSEG for QB45
 DOSParmList.di = SADD(TmpNewName$)
 DOSParmList.es = SSEG(TmpNewName$) '| Use VARSEG for QB45
 DOSParmList.Rsrvd = 0
 DOSParmList.CompID = 0
 DOSParmList.ProcID = PSPSeg%

 InRegX.ax = &H5D00                 '| Do Rename, using Internal
 InRegX.ds = VARSEG(DOSParmList)    '|   Server Function Call to
 InRegX.dx = VARPTR(DOSParmList)    '|   support wildcards in
                                    '|   filenames.
 CALL InterruptX(&H21, InRegX, OutRegX)
 IF (OutRegX.flags AND 1) THEN
     ReName% = OutRegX.ax
     PRINT "Error in Renaming Files"
     EXIT FUNCTION
 END IF

 ReName% = 0

 END FUNCTION

