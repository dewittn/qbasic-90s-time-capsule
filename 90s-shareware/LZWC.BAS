'Experimental LZW Compressor for PDS / QuickBASIC 4.5
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
DECLARE SUB PutCode (A)
DECLARE SUB Rebuild.Table (New.Entries)
DECLARE FUNCTION GetByte ()
DECLARE SUB Hash (Prefix, Suffix, Index, Found)

CONST True = -1, False = 0

DIM SHARED Prefix(6576), Suffix(6576), Code(6576)
DIM SHARED Used(4096)

DIM SHARED InBuffer$, IAddress, IEndAddress, Iseg
DIM SHARED OutBuffer$, OStartAddress, OAddress, OEndAddress, Oseg

DIM SHARED CodeSize, CurrentBit, Char&
DIM SHARED Shift(12) AS LONG


FOR A = 0 TO 12: READ Shift(A): NEXT
DATA 1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192


LOCATE , , 0
IF POS(0) <> 1 THEN PRINT


InBuffer$ = STRING$(4000, 0)   'input buffer
OutBuffer$ = STRING$(4000, 0)  'output buffer


A& = SADD(OutBuffer$)
A& = A& - 65536 * (A& < 0)
Oseg = VARSEG(OutBuffer$) + (A& \ 16)     'Segment of buffer
OAddress = (A& MOD 16)                  'Current address in disk buffer
OEndAddress = OAddress + 4000           'End address of  buffer
OStartAddress = OAddress                'Start of buffer

'Open input file
File$ = COMMAND$
IF File$ = "" THEN INPUT "File to compress? "; File$: File$ = LTRIM$(RTRIM$(File$))
IF File$ = "" THEN END
OPEN File$ FOR BINARY AS #1
FileLength& = LOF(1)
'Is it there?
IF FileLength& = 0 THEN
    CLOSE #1
    KILL COMMAND$
    PRINT COMMAND$; " not found"
    END
END IF
'Open output file
OPEN "output.lzw" FOR BINARY AS #2
'Is it already there?
IF LOF(2) <> 0 THEN
    'Kill output file and reopen it
    CLOSE #2
    KILL "output.lzw"
    OPEN "output.lzw" FOR BINARY AS #2
END IF
'CurrentLoc& - position in input file
CurrentLoc& = 2

'Compression codes:
'Code 256 = end of file
'Code 257 = increase code size
'Code 258 = rebuild table
'Code 259 - 4095 = available for strings
StartCode = 259                 'First LZW code that is available
NextCode = 259
'The maximum code that can be represented in 9 bits
MaxCode = 512
'Start with 9 bit code size
CodeSize = 9
'Current bit position in Char& - use for PutCode
CurrentBit = 0
'Char& is a temporary buffer; accumulates codes from main program and
'puts them in the output file once complete bytes have been
'built
Char& = 0

GOSUB ClearTable
'Get first byte from file(it's a special case)
Prefix = GetByte

PRINT "LZW Compressor For QuickBASIC 4.5"
PRINT "By Richard Geldreich June 2nd, 1992"
PRINT "Compressing "; File$
PRINT : PRINT : PRINT
'First line to start updating statistics
Y = CSRLIN - 3
'Main compression loop
DO
    DO
     
        IF CurrentLoc& > FileLength& THEN
            PutCode Prefix
            PutCode 256
            PutCode 0: PutCode 0
            OutBuffer$ = LEFT$(OutBuffer$, OAddress - OStartAddress)
            LOCATE Y, 1
            PRINT "Bytes In:"; CurrentLoc&; (100& * CurrentLoc&) \ FileLength&; "%"
            BytesOut& = LOF(2) + (OAddress - OStartAddress)
            PRINT "Bytes Out:"; BytesOut&
            PRINT "Total Compression:"; 100 - ((100& * BytesOut&) \ CurrentLoc&); "%                         ";
            PUT #2, , OutBuffer$
            CLOSE
            END
        ELSE
            
            Suffix = GetByte
            CurrentLoc& = CurrentLoc& + 1
            'We now have a Prefix:Suffix to search for.
            'If the search fails, put the Prefix in the output file
            'and set the Prefix equal to the character which caused
            'the failure.

            Hash Prefix, Suffix, Index, Found
            IF Found = True THEN
                Prefix = Code(Index)
                'update how many times this string was used
                Used(Prefix) = Used(Prefix) + 1
            END IF
        END IF
    LOOP WHILE Found = True

    'only increase the code size when required
    DO WHILE Prefix >= MaxCode AND CodeSize < 12
        PutCode 257
        MaxCode = MaxCode * 2
        CodeSize = CodeSize + 1
    LOOP
   
    PutCode Prefix

    'Put the new string into the hash table.
    Prefix(Index) = Prefix
    Suffix(Index) = Suffix
    Code(Index) = NextCode  'remember this string's code

    'Prefix is now equal to the character that caused the failure now.
    Prefix = Suffix
 
    NextCode = NextCode + 1
    'if there are too many strings then rebuild the encoding table
    IF NextCode > 4096 THEN
           
        PutCode 258 'send rebuild table code to decompressor

        Rebuild.Table New.Entries
        NextCode = New.Entries + StartCode
       
        IF NextCode > 4096 THEN
            GOSUB ClearTable
            NextCode = StartCode        'reset NextCode to top of tree
        END IF

        CodeSize = 9
        MaxCode = 512

        
    END IF

    'let the impatient user know we haven't hung up (yet!)
    PrintCounter = PrintCounter + 1     'see if time to update the
    IF PrintCounter = 128 THEN          'screen
        LOCATE Y, 1
        PRINT "Bytes In:"; CurrentLoc&; (100& * CurrentLoc&) \ FileLength&; "%"
        BytesOut& = LOF(2) + (OAddress - OStartAddress)
        PRINT "Bytes Out:"; BytesOut&
        PRINT "Compression:"; 100 - ((100& * BytesOut&) \ CurrentLoc&); "%  "; "CodeSize:"; CodeSize; "NextCode:"; NextCode; "   ";
        PrintCounter = 0
    END IF
LOOP
'clears the hash table
ClearTable:
    FOR A = 0 TO 6576
        Prefix(A) = -1
        Suffix(A) = -1
        Code(A) = -1
    NEXT
RETURN

'Reads one byte from the input buffer, and fills the buffer if it's emty.
FUNCTION GetByte STATIC
    IF IAddress = IEndAddress THEN
        GET #1, , InBuffer$
        A& = SADD(InBuffer$)
        A& = A& - 65536 * (A& < 0)
        Iseg = VARSEG(InBuffer$) + (A& \ 16)
        IAddress = (A& MOD 16)
        IEndAddress = IAddress + 4000
    END IF
    DEF SEG = Iseg
    GetByte = PEEK(IAddress)
    IAddress = IAddress + 1
END FUNCTION

'Attempts to finds a prefix:suffix string.
SUB Hash (Prefix, Suffix, Index, Found)
    
    Index = (Prefix * 256& XOR Suffix) MOD 6577 'XOR hashing
    IF Index = 0 THEN  'is Index lucky enough to be 0?
        Offset = 1     'Set offset to 1, because 6577-0=6577
    ELSE
        Offset = 6577 - Index
    END IF
    DO 'until we find a match or don't
        IF Code(Index) = -1 THEN      'is there nothing here?
            Found = False             'yup, not found
            EXIT SUB
        'is this entry what we're looking for?
        ELSEIF Prefix(Index) = Prefix AND Suffix(Index) = Suffix THEN
            Found = True              'yup, found
            EXIT SUB
        ELSE 'retry until we find what were looking for or we find a blank
             'entry
            Index = Index - Offset
            IF Index < 0 THEN 'is index too far down?
                Index = Index + 6577 'yup, bring it up then
            END IF
        END IF
    LOOP
END SUB

'Throws a byte into the output buffer and writes the buffer if it's full.
SUB PutByte (A) STATIC
    IF OAddress = OEndAddress THEN
        PUT #2, , OutBuffer$
        OAddress = OStartAddress
    END IF
    DEF SEG = Oseg
    POKE OAddress, A
    OAddress = OAddress + 1
END SUB

'Throws one multi-bit code to the output file.
SUB PutCode (A) STATIC
    SHARED MaxCode
    IF A >= MaxCode THEN STOP

    Char& = Char& + A * Shift(CurrentBit)
    CurrentBit = CurrentBit + CodeSize
    DO WHILE CurrentBit > 7
        PutByte Char& AND 255
        Char& = Char& \ 256
        CurrentBit = CurrentBit - 8
    LOOP
END SUB

'This is the "experimental" part of the program. This procedure eliminates
'any strings which are not used in the encoding table: the usual result of
'doing this is greater compression.
'It isn't documented well yet... I'm still working on it.
SUB Rebuild.Table (New.Entries)
    DIM P(4096), S(4096), U(4096) AS LONG, Pn(4096), C(4096)
    DIM Location(4096)
   
    SHARED StartCode, MaxCode, Prefix
    Num.Entries = 0
    
    FOR A = 0 TO 6576
        C = Code(A)
        IF C <> -1 THEN 'valid code?
            IF Used(C) > 0 THEN 'was it used at all?
                Used(C) = 0
                P = Prefix(A): S = Suffix(A)
                P(Num.Entries) = P          'put it into a temporary table
                S(Num.Entries) = S
                U(Num.Entries) = P * 4096& + S
                C(C) = Num.Entries
                Num.Entries = Num.Entries + 1
            END IF
        END IF
    NEXT
    

    Num.Entries = Num.Entries - 1
    FOR A = 0 TO Num.Entries
        Pn(A) = A
    NEXT
        'sort the table according to it's prefix:suffix
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
        Location(Pn(A)) = A
    NEXT
    'clear the old hash table
    FOR A = 0 TO 6576
        Prefix(A) = -1
        Suffix(A) = -1
        Code(A) = -1
    NEXT
    
    'put each prefix:suffix into the hash table
    FOR A1 = 0 TO Num.Entries
        A = Pn(A1)
       
        P = P(A)
        S = S(A)
        IF P >= StartCode THEN 'is it pointing twards a string?
            P = StartCode + Location(C(P)) 'yup; update the pointer
        END IF
        IF S >= StartCode THEN
            S = StartCode + Location(C(S))
        END IF
        'where does this prefix:suffix go?
        Hash P, S, Index, 0
        'put it there
        Prefix(Index) = P
        Suffix(Index) = S
        Code(Index) = A1 + StartCode
        
    NEXT
    '# of entries in the hash table now
    New.Entries = Num.Entries + 1
END SUB

