'Experimental LZW Decompressor for PDS / QuickBASIC 4.5
'By Rich Geldreich 1992
'This program is in the public domain: use as you wish!
'(QB4.5 users: Use search & replace to change all of the "SSEG" strings
'to "VARSEG" strings in this program.)
'If you have and questions or problems, write/call:

'Rich Geldreich
'410 Market St.
'Gloucester City, NJ 08030
'(609)-742-8752
'
' Do not press ctrl+break while this program is decompressing! The string
' pointers may change, which may result in an error!

DEFINT A-Z
DECLARE SUB PutByte (A)
DECLARE SUB Rebuild.Table (New.Entries)
DECLARE FUNCTION GetCode ()
DECLARE FUNCTION GetByte ()
CONST True = -1, False = 0

'Prefix & Suffix of each code
DIM SHARED Prefix(4096), Suffix(4096), Used(4096)
DIM OutCode(4096)               'simulates a hardware stack

'Input and output disk buffers
DIM SHARED InBuffer$, IAddress, IEndAddress, Iseg
DIM SHARED OutBuffer$, OStartAddress, OAddress, OEndAddress, Oseg

'Used for screen updating
DIM SHARED BytesIn&

'Powers of two
DIM SHARED Powers(7)
DIM SHARED LongPowers(12) AS LONG
'Mask for each codesize
DIM SHARED Masks(12)
'Current codesize
DIM SHARED CodeSize
'Initialize each array
FOR A = 0 TO 7: Powers(A) = 2 ^ A: NEXT
FOR A = 0 TO 12: LongPowers(A) = 2 ^ A: NEXT
FOR A = 1 TO 12: Masks(A) = (2 ^ A) - 1: NEXT
'Turn on cursor
LOCATE , , 1
'Initialize each disk buffer
InBuffer$ = STRING$(5000, 0)
OutBuffer$ = STRING$(5000, 0)
'Find address of output buffer
A& = SADD(OutBuffer$)
A& = A& - 65536 * (A& < 0)
Oseg = VARSEG(OutBuffer$) + (A& \ 16)
OAddress = (A& MOD 16)
OEndAddress = OAddress + 5000
OStartAddress = OAddress
BytesIn& = 0
'Open files
OPEN "OUTPUT.LZW" FOR BINARY AS #1
OPEN COMMAND$ FOR BINARY AS #2

'First code is 259
FreeCode = 259
StartCode = 259
'First codesize is 9 bits
CodeSize = 9
'Get First code(special case)
Code = GetCode
CurCode = Code
OldCode = Code
FinChar = Code
PutByte FinChar

FileLength& = LOF(1)
IF POS(0) <> 1 THEN PRINT
PRINT "LZW Decompressor in QuickBASIC 4.5"
PRINT "By Richard Geldreich June 2nd, 1992"
PRINT "Decompressing:";
Y = CSRLIN: X = POS(0)
'Main decompression loop
DO
    'Update screen every 1,024 codes
    OutputCounter = OutputCounter + 1
    IF OutputCounter = 1024 THEN
        LOCATE Y, X
        PRINT (100& * BytesIn&) \ FileLength&; "% done";
        OutputCounter = 0
    END IF

GetCode:
    'Get code from input file
    Code = GetCode
    'Process code
    SELECT CASE Code
    'End of file code
    CASE 256
        OutBuffer$ = LEFT$(OutBuffer$, OAddress - OStartAddress)
        PUT #2, , OutBuffer$
        LOCATE Y, X
        PRINT " done       "
        CLOSE : END
    'Increase code size code
    CASE 257
        CodeSize = CodeSize + 1
    CASE 258
        Rebuild.Table New.Entries
        FreeCode = New.Entries + StartCode
        CodeSize = 9

        IF FreeCode > 4096 THEN
            FreeCode = StartCode
            Code = GetCode
             
            CurCode = Code
            OldCode = Code
             
            FinChar = Code
            PutByte FinChar
        ELSE
            'prevents an invalid code from entering the table
            Ignore.Next = True
        END IF

    'Process a code
    CASE ELSE
       
        CurCode = Code
        InCode = Code
        'Do we have this string yet?
        IF Code >= FreeCode THEN
            'If Code>FreeCode then stop decompression: this can't be right!
            IF Code > FreeCode THEN PRINT "??BAD LZW CODE IN FILE": CLOSE : END
            'Trick decompressor to use last code
            
            Used(Code) = Used(Code) + 1
            CurCode = OldCode
            OutCode(OutCount) = FinChar
            OutCount = OutCount + 1
        END IF
        
        'Does this code represent a string?
        IF CurCode >= StartCode THEN
            'Get each character from the table and push it onto the stack
            
            DO
                Used(CurCode) = Used(CurCode) + 1
                OutCode(OutCount) = Suffix(CurCode)
                OutCount = OutCount + 1
                CurCode = Prefix(CurCode)
            'keep on doing this until we have a normal character
            LOOP UNTIL CurCode <= 255
        END IF
        FinChar = CurCode
        OutCode(OutCount) = FinChar
        'Pop all the codes of the stack and put them into the output file
        FOR A = OutCount TO 0 STEP -1
            PutByte OutCode(A)
        NEXT
        OutCount = 0
        'Put the new string into the table
        IF Ignore.Next THEN
            Ignore.Next = False
        ELSE
            Prefix(FreeCode) = OldCode
            Suffix(FreeCode) = FinChar
            FreeCode = FreeCode + 1
        END IF
        OldCode = InCode
    END SELECT
LOOP

FUNCTION GetByte STATIC
    IF IAddress = IEndAddress THEN
        GET #1, , InBuffer$
        A& = SADD(InBuffer$)
        A& = A& - 65536 * (A& < 0)
        Iseg = VARSEG(InBuffer$) + (A& \ 16)
        IAddress = (A& MOD 16)
        IEndAddress = IAddress + 5000
    END IF
    DEF SEG = Iseg
    GetByte = PEEK(IAddress)
    BytesIn& = BytesIn& + 1
    IAddress = IAddress + 1
END FUNCTION

FUNCTION GetCode STATIC
    IF BitsLeft = 0 THEN
        TempChar = GetByte
        BitsLeft = 8
    END IF
    WorkCode& = TempChar \ Powers(8 - BitsLeft)
    DO WHILE CodeSize > BitsLeft
        TempChar = GetByte
        WorkCode& = WorkCode& OR TempChar * LongPowers(BitsLeft)
        BitsLeft = BitsLeft + 8
    LOOP
    BitsLeft = BitsLeft - CodeSize
    GetCode = WorkCode& AND Masks(CodeSize)
END FUNCTION

SUB PutByte (A) STATIC
    IF OAddress = OEndAddress THEN
        PUT #2, , OutBuffer$
        OAddress = OStartAddress
    END IF
    DEF SEG = Oseg
    POKE OAddress, A
    OAddress = OAddress + 1
END SUB

SUB Rebuild.Table (New.Entries)
    DIM P(4095), S(4095), U(4095) AS LONG, Pn(4095), C(4095)
    DIM location(4095)
   
    SHARED StartCode, OldCode
   
    Num.Entries = 0
    FOR A = StartCode TO 4095
        IF Used(A) > 0 THEN
            Used(A) = 0
            P = Prefix(A): S = Suffix(A)
            P(Num.Entries) = P
            S(Num.Entries) = S
            U(Num.Entries) = P * 4096& + S
            C(A) = Num.Entries
            Num.Entries = Num.Entries + 1
        END IF
    NEXT
  

    Num.Entries = Num.Entries - 1
    FOR A = 0 TO Num.Entries
        Pn(A) = A
    NEXT
  
    Mid = Num.Entries \ 2
    DO
        FOR A = 0 TO Num.Entries - Mid
            IF U(Pn(A)) > U(Pn(A + Mid)) THEN
                SWAP Pn(A), Pn(A + Mid)
                Swap.Flag = True
                CompareLow = A - Mid
                CompareHigh = A
                DO WHILE CompareLow >= 0
                    IF U(Pn(CompareLow)) > U(Pn(CompareHigh)) THEN
                        SWAP Pn(CompareLow), Pn(CompareHigh)
                        CompareHigh = CompareLow
                        CompareLow = CompareLow - Mid
                    ELSE
                        EXIT DO
                    END IF
                LOOP
              
            END IF
        NEXT
       
        Mid = Mid \ 2
    LOOP WHILE Mid > 0
   
   
    FOR A = 0 TO Num.Entries
        location(Pn(A)) = A
    NEXT
   
    
   
    FOR A1 = 0 TO Num.Entries
        A = Pn(A1)
     
        P = P(A)
        S = S(A)
        IF P >= StartCode THEN
            P = StartCode + location(C(P))
        END IF
        IF S >= StartCode THEN
            S = StartCode + location(C(S))
        END IF
       
        Prefix(A1 + StartCode) = P
        Suffix(A1 + StartCode) = S
       
    NEXT
    
    IF OldCode >= StartCode THEN
        OldCode = StartCode + location(C(OldCode))
    END IF
   
    New.Entries = Num.Entries + 1

END SUB

