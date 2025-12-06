' Huffman encoder v2.00 for PDS & QB4.5
' by Rich Geldreich May 29th, 1992
' Revised for PDS July 13, 1992
' This program is in the public domain. Use it for what you want!
' Just give me credit. If you find any bugs in it, please tell me about
' them.
'
' QB4.5 users: use search & replace and change all of the "SSEG" strings
' in this program to "VARSEG" strings.
' Do not press ctrl+break while this program is compressing! The string
' pointers may change, which may result in an error! Also, to realize
' the true speed of this program you must run it compiled.
' The overall compression of this program is not optimal, because the
' entire tree is sent to the output file. This was done so the decoding
' program can be as simple and fast as possible(the tree takes up about
' 1000 bytes or so; it depends on the input file).
'
' This program is much, much better than my first huffman encoder. It's
' faster, and (should be) easier to understand. The entire program was
' rewritten from scratch. The following changes have been made:

' The huffman tree is now scanned using a recursive algorithm instead of
' a slow, down-up search.
' Instead of searching for the lowest 2 nodes using a slow, linear search,
' this program uses a much faster presorted table. The entire tree can
' be combined in less than a second on my 286-10!
' The input file is scanned & compressed with a very fast buffer loading
' system, to overcome QB's slowness with binary files.
' A new shell sort is used to sort the node table before the tree is
' combined. A simple bubble sort is then used thereafter.

DEFINT A-Z
DECLARE SUB InitTree ()
DECLARE SUB MakeSortTable ()
DECLARE SUB CombineTree ()
DECLARE SUB CleanUpTree ()
DECLARE SUB WriteTree ()

DECLARE SUB SortDistribution2 ()
DECLARE SUB SortDistribution ()
DECLARE SUB GetDistribution ()
DECLARE SUB RecurseTree (Node)

DECLARE SUB FillBuffer ()


CONST True = -1, False = 0
CONST Null = -2
CONST BufferLength = 10000

CLEAR , , 10000

DIM SHARED Father(512) AS LONG, LeftSon(512), RightSon(512)
DIM SHARED Index(512), RealIndex, Used(255) AS LONG
DIM SHARED Pointer(255), HighestEntry
DIM SHARED Code(255, 40), CodeLength(255)
DIM SHARED CurrentLength, CurrentCode(40)

DIM SHARED Buffer$, Address, EndAddress, Bits(8), CurrentByte, CurrentBit
DIM SHARED BufferSeg


CLS
LOCATE , , 0

Bits:
    DATA 1,2,4,8,16,32,64,128,256

'read the bit masks
RESTORE Bits
FOR A = 0 TO 8: READ Bits(A): NEXT

'initialize the tree
InitTree

'initialize the input buffer
Buffer$ = STRING$(BufferLength, 0)
EndAddress = 1: Address = 0

PRINT "Getting Distribution:";
'open input file
OPEN COMMAND$ FOR BINARY AS #1
'check to see if it exists
IF LOF(1) = 0 THEN
    CLOSE #1
    KILL COMMAND$
    PRINT
    PRINT COMMAND$; " not found"
    END
END IF
'read the input file and gather the distribution of each character
GetDistribution
'make a sorting table
MakeSortTable
'sort the table with the a shell sort
SortDistribution
'combine the tree until there is only one node at the "top"
CombineTree
'work down the tree finding codes which represent each character
TopOfTree = Pointer(0)
CurrentLength = 0
RecurseTree TopOfTree
'for debugging: prints the code for each character
'FOR A = 0 TO 255
'    IF Used(A) > 256 THEN
'        PRINT A;
'        FOR B = 0 TO CodeLength(A)
'            PRINT Code(A, B);
'        NEXT
'        PRINT "-";
'    END IF
'NEXT
'STOP
'"cleans" the tree up so it can be sent as small as possible
CleanUpTree

CurrentByte = 0: CurrentBit = 0
RealIndex = RealIndex - 1
'open output file
OPEN "output.huf" FOR BINARY AS #2
'kill file if it already exists
IF LOF(2) <> 0 THEN
    CLOSE #2
    KILL "output.huf"
    OPEN "output.huf" FOR BINARY AS #2
END IF

'put the header
A& = LOF(1)
PUT #2, , A&            'number of bytes in original file
PUT #2, , RealIndex     'number of nodes in tree
Top = Index(TopOfTree)
PUT #2, , Top           'top of tree

WriteTree               'writes the tree to the output file

'compresses the input file
PRINT : PRINT "Encoding...": PRINT : PRINT
Ypos = CSRLIN - 2

SEEK #1, 1
EndAddress = 1: Address = 0
'initialize the output buffer
A$ = STRING$(5000, 0)
A& = SADD(A$)
A& = A& - 65536 * (A& < 0)
OBufferSeg = VARSEG(A$) + (A& \ 16)
OAddress = (A& MOD 16)
OEndAddress = OAddress + 5000
Ostart = OAddress
'start compressing
FOR A& = 1 TO LOF(1)
   
    'get a byte from the input file
    Address = Address + 1
    'if Address=EndBuffer then it's time to fill the input buffer
    IF Address = EndAddress THEN FillBuffer
    B = PEEK(Address)
    'send out all of the bits that represent the input character
    FOR C = 0 TO CodeLength(B)
        IF Code(B, C) THEN
            CurrentByte = CurrentByte * 2 OR 1      'send "1"
        ELSE
            CurrentByte = CurrentByte * 2           'send "0"
        END IF
        CurrentBit = CurrentBit + 1
        'if CurrentBit=8 then we have a complete byte
        IF CurrentBit = 8 THEN
            DEF SEG = OBufferSeg
            POKE OAddress, CurrentByte
            OAddress = OAddress + 1
            'if Oaddress=Oendaddress then it's time to flush the
            'output buffer
            IF OAddress = OEndAddress THEN
                PUT #2, , A$
                B& = SADD(A$)
                B& = B& - 65536 * (B& < 0)
                OBufferSeg = VARSEG(A$) + (B& \ 16)
                OAddress = (B& MOD 16)
                OEndAddress = OAddress + 5000
                Ostart = OAddress
            END IF
            CurrentByte = 0: CurrentBit = 0
            DEF SEG = BufferSeg
        END IF
    NEXT
    'see if it's time to update screen
    PrintCount = PrintCount + 1
    IF PrintCount = 1024 THEN
        PrintCount = 0
        LOCATE Ypos, 1
        PRINT "Bytes In:"; A&; (A& * 100&) \ LOF(1); "%  "
        B& = LOF(2) + OAddress - Ostart
        PRINT "Bytes Out:"; B&; "   "
        PRINT "Compression:"; 100 - (B& * 100&) \ A&; "% ";
    END IF
NEXT
'put whatever is left of the byte buffer into the output buffer
DO UNTIL CurrentBit = 8
    CurrentByte = CurrentByte * 2
    CurrentBit = CurrentBit + 1
LOOP

DEF SEG = OBufferSeg
POKE OAddress, CurrentByte
A$ = LEFT$(A$, OAddress + 1 - Ostart)
PUT #2, , A$
'report compression
LOCATE Ypos, 1
PRINT "Bytes In:"; LOF(1); SPACE$(16)
PRINT "Bytes Out:"; LOF(2); SPACE$(16)
PRINT "Overall Compression:"; 100 - (LOF(2) * 100&) \ LOF(1); "%"; SPACE$(16);
CLOSE

END

'"Cleans" up the tree so it can be sent.
SUB CleanUpTree
    RealIndex = 0
    FOR A = 0 TO 512
        B& = Father(A)
        IF B& <> Null THEN
            IF B& < 256 THEN
                IF Used(B&) > 256 THEN
                    Index(A) = RealIndex
                    RealIndex = RealIndex + 1
                END IF
            ELSEIF B& > 256 THEN
                Index(A) = RealIndex
                RealIndex = RealIndex + 1
            END IF
        END IF
    NEXT

    FOR A = 0 TO 512
        B& = Father(A)
        IF B& <> Null THEN
            IF B& < 256 THEN
                IF Used(B&) > 256 THEN
                    IF LeftSon(A) <> Null THEN
                        LeftSon(A) = Index(LeftSon(A))
                    END IF
                    IF RightSon(A) <> Null THEN
                        RightSon(A) = Index(RightSon(A))
                    END IF
                END IF
            ELSEIF B& > 256 THEN
                IF LeftSon(A) <> Null THEN
                    LeftSon(A) = Index(LeftSon(A))
                END IF
                IF RightSon(A) <> Null THEN
                    RightSon(A) = Index(RightSon(A))
                END IF
            END IF
        END IF
    NEXT
END SUB

'Combines the tree until there is only one node at the top.
SUB CombineTree
   
    Parents = HighestEntry + 1
    DO UNTIL Parents = 1
        'sort the current distribution
        SortDistribution2
        'find the lowest 2 entries
        Lowest = Pointer(HighestEntry)
        NextLowest = Pointer(HighestEntry - 1)
        'find new frequency
        NewFrequency& = Father(Lowest) + Father(NextLowest) - 256
        'combine the two nodes
        IF RightSon(Lowest) = Null AND RightSon(NextLowest) = Null THEN
            Father(NextLowest) = NewFrequency&
            RightSon(NextLowest) = LeftSon(Lowest)
            Father(Lowest) = Null
            Parents = Parents - 1
            HighestEntry = HighestEntry - 1
        ELSEIF RightSon(Lowest) = Null AND RightSon(NextLowest) <> Null THEN
            Father(Lowest) = NewFrequency&
            RightSon(Lowest) = NextLowest
            Pointer(HighestEntry - 1) = Pointer(HighestEntry)
            Parents = Parents - 1
            HighestEntry = HighestEntry - 1
        ELSEIF RightSon(Lowest) <> Null AND RightSon(NextLowest) = Null THEN
            Father(NextLowest) = NewFrequency&
            RightSon(NextLowest) = Lowest
            Parents = Parents - 1
            HighestEntry = HighestEntry - 1
        ELSEIF RightSon(Lowest) <> Null AND RightSon(NextLowest) <> Null THEN
            'search for new node
            FOR A = 512 TO 0 STEP -1
                IF Father(A) = Null THEN EXIT FOR
            NEXT
            Father(A) = NewFrequency&
            LeftSon(A) = Lowest
            RightSon(A) = NextLowest
      
            HighestEntry = HighestEntry - 1
            Pointer(HighestEntry) = A
            Parents = Parents - 1
        END IF
    'loop until there is only one node at the top
    LOOP
END SUB

'Fills the input buffer.
SUB FillBuffer
    GET #1, , Buffer$

    A& = SADD(Buffer$)
    A& = A& - 65536 * (A& < 0)
    BufferSeg = VARSEG(Buffer$) + (A& \ 16)
    Address = (A& MOD 16)
    EndAddress = Address + BufferLength
    DEF SEG = BufferSeg

END SUB

'Scans the input file for its distribution.
SUB GetDistribution
       
    FOR A& = 1 TO LOF(1)
        Address = Address + 1
        IF Address = EndAddress THEN
            FillBuffer
            PRINT ".";
        END IF
        B = PEEK(Address) * 2
        Father(B) = Father(B) + 1
    NEXT
    B = 0
    FOR A = 0 TO 510 STEP 2
        Used(B) = Father(A): B = B + 1
    NEXT
END SUB

'Initilizes the tree.
SUB InitTree
    B = 0
    FOR A = 0 TO 510 STEP 2
  
        Father(A) = 256
        LeftSon(A) = A + 1
        RightSon(A) = Null
  
        Father(A + 1) = B
        LeftSon(A + 1) = Null
        RightSon(A + 1) = Null
  
        B = B + 1
    NEXT
END SUB

'Makes a sorting table.
SUB MakeSortTable
    HighestEntry = 0
    FOR A = 0 TO 510 STEP 2
        IF Father(A) > 256 THEN
            Pointer(HighestEntry) = A
            HighestEntry = HighestEntry + 1
        END IF
    NEXT
    HighestEntry = HighestEntry - 1
END SUB

'Recursive procedure to go down the tree and build up codes
'that represent each character.
SUB RecurseTree (Node)
    'are we at a character?
    IF Father(Node) < 256 THEN
        'yup! CurrentCode() has this character's bit sequence
        Char = Father(Node)
        FOR A = 0 TO CurrentLength - 1
            Code(Char, A) = CurrentCode(A)
        NEXT
        CodeLength(Char) = CurrentLength - 1
    END IF
    'go to the left if there's something there
    IF LeftSon(Node) <> Null THEN
        CurrentCode(CurrentLength) = 1      'add "1" to the current code
        CurrentLength = CurrentLength + 1
        RecurseTree LeftSon(Node)           'go down
        CurrentLength = CurrentLength - 1   'take "1" from the current code
    END IF
    'go to the right if there's something there
    IF RightSon(Node) <> Null THEN
        CurrentCode(CurrentLength) = 0      'add "0" to the current code
        CurrentLength = CurrentLength + 1
        RecurseTree RightSon(Node)          'got down
        CurrentLength = CurrentLength - 1   'take "0" from the current code
    END IF
END SUB

'A REAL Shell sort follows. It is much faster than the well-known one.
'Sorts the nodes according to the sorting table.
SUB SortDistribution
    Offset = HighestEntry \ 2
    DO
        FOR I = 0 TO HighestEntry - Offset
            IF Father(Pointer(I)) < Father(Pointer(I + Offset)) THEN
                SWAP Pointer(I), Pointer(I + Offset)
                CompareLow = I - Offset
                CompareHigh = I
                DO WHILE CompareLow >= 0
                    IF Father(Pointer(CompareLow)) < Father(Pointer(CompareHigh)) THEN
                        SWAP Pointer(CompareLow), Pointer(CompareHigh)
                        CompareHigh = CompareLow
                        CompareLow = CompareLow - Offset
                    ELSE
                        EXIT DO
                    END IF
                LOOP
            END IF
        NEXT
        Offset = Offset \ 2
    LOOP WHILE Offset > 0
    

END SUB

'A simple bubble sort... used while combining the tree.
SUB SortDistribution2
    
    DO
        SwapFlag = False
        FOR A = HighestEntry - 1 TO 0 STEP -1
            IF Father(Pointer(A + 1)) > Father(Pointer(A)) THEN
                SWAP Pointer(A + 1), Pointer(A)
                SwapFlag = True
            END IF
        NEXT
    LOOP WHILE SwapFlag
    
END SUB

'Writes the tree to disk.
SUB WriteTree
    

    FOR A = 0 TO 512
        B& = Father(A)
        IF B& <> Null THEN
            IF B& < 256 THEN
                IF Used(B&) > 256 THEN
                    GOSUB SendOne
                    FOR C = 0 TO 7
                        IF (B& AND Bits(C)) > 0 THEN
                            GOSUB SendOne
                        ELSE
                            GOSUB SendZero
                        END IF
                    NEXT
                END IF
            ELSEIF B& > 256 THEN
                GOSUB SendZero
                IF LeftSon(A) <> Null THEN
                    GOSUB SendOne
                    Son = LeftSon(A)
               
                    FOR C = 0 TO 8
                        IF (Son AND Bits(C)) > 0 THEN
                            GOSUB SendOne
                        ELSE
                            GOSUB SendZero
                        END IF
                    NEXT
                ELSE
                    GOSUB SendZero
                END IF
                IF RightSon(A) <> Null THEN
                    GOSUB SendOne
                    Son = RightSon(A)
                   
                    FOR C = 0 TO 8
                        IF (Son AND Bits(C)) > 0 THEN
                            GOSUB SendOne
                        ELSE
                            GOSUB SendZero
                        END IF
                    NEXT
                ELSE
                    GOSUB SendZero
                END IF
            END IF
        END IF
    NEXT

    EXIT SUB

SendZero:
    CurrentByte = CurrentByte * 2
    CurrentBit = CurrentBit + 1
    IF CurrentBit = 8 THEN
        A$ = CHR$(CurrentByte)
        PUT #2, , A$
        CurrentByte = 0: CurrentBit = 0
    END IF
RETURN

SendOne:
   
    CurrentByte = CurrentByte * 2 OR 1
    CurrentBit = CurrentBit + 1
    IF CurrentBit = 8 THEN
        A$ = CHR$(CurrentByte)
        PUT #2, , A$
        CurrentByte = 0: CurrentBit = 0
    END IF
RETURN

END SUB

