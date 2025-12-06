' Huffman decoder v2.00 for PDS & QB4.5
' by Rich Geldreich May 29th, 1992
' Revised for PDS July 13, 1992
' This program is in the public domain.
' QB4.5 users: use search & replace and change all of the "SSEG" strings
' in this program to "VARSEG" strings.
' Do not press ctrl+break while this program is decompressing! The string
' pointers may change, which may result in an error! Also, to realize
' the true speed of this program you must run it compiled!
' See HUFFMAN2.BAS for info.

DEFINT A-Z

DECLARE FUNCTION GetBit ()
DECLARE SUB FillBuff ()

CONST True = -1, False = 0
CONST Null = -2
CONST BufferLength = 10000

DIM SHARED Bits(8)
DIM SHARED Father(512)
DIM SHARED LeftSon(512)
DIM SHARED RightSon(512)

DIM SHARED Buffer$, Address, EndAddress, CurrentByte, BitsIn, BufferSeg

Bits:
    DATA 1,2,4,8,16,32,64,128,256

RESTORE Bits
FOR A = 0 TO 8: READ Bits(A): NEXT
'disk buffer
Buffer$ = STRING$(BufferLength, 0): EndAddress = 1: Address = 0: BitsIn = -1
'turn on cursor
LOCATE , , 1
'open the compressed file
OPEN "output.huf" FOR BINARY AS #1
'get the header
GET #1, , FileLength&
GET #1, , RealIndex
GET #1, , TopOfTree
'read in the tree
FOR A = 0 TO RealIndex
    IF GetBit THEN
        Father = 0
        FOR C = 0 TO 7
            IF GetBit THEN Father = Father + Bits(C)
        NEXT
        Father(A) = Father
        RightSon(A) = Null
        LeftSon(A) = Null
    ELSE
        Father(A) = 256
        IF GetBit THEN
            Son = 0
            FOR C = 0 TO 8
                IF GetBit THEN Son = Son + Bits(C)
            NEXT
            LeftSon(A) = Son
        ELSE
            LeftSon(A) = Null
        END IF
        IF GetBit THEN
            Son = 0
            FOR C = 0 TO 8
                IF GetBit THEN Son = Son + Bits(C)
            NEXT
            RightSon(A) = Son
        ELSE
            RightSon(A) = Null
        END IF
    END IF
NEXT
'when PrintCounter=1024 then screen is updated
PrintCounter = 0
'A$ is the output buffer
A$ = STRING$(5000, 0)
A& = SADD(A$)
A& = A& - 65536 * (A& < 0)
OutputSeg = VARSEG(A$) + (A& \ 16)
OAddress = (A& MOD 16)
OEndAddress = OAddress + 5000
OStart = OAddress
'start decoding
PRINT "Decoding:";
Xpos = POS(0): Ypos = CSRLIN
'open output file
OPEN COMMAND$ FOR BINARY AS #2
'decode each byte
FOR CurrentByte& = 1 TO FileLength&
    DEF SEG = BufferSeg
    'start at top of tree
    A = TopOfTree
    'keep on getting bits until a character is found
    DO
        'if BitsIn<0 then time to fill byte buffer
        IF BitsIn < 0 THEN
            Address = Address + 1
            'if Address=EndBuffer then time to fill disk buffer
            IF Address = EndAddress THEN
                FillBuff
            END IF
            CurrentByte = PEEK(Address): BitsIn = 7
        END IF
        'see if we go left or right
        IF (CurrentByte AND Bits(BitsIn)) THEN A = LeftSon(A) ELSE A = RightSon(A)
        BitsIn = BitsIn - 1
        F = Father(A)
        'loop until an ascii character is found
    LOOP UNTIL F < 256
    'put byte into output buffer
    DEF SEG = OutputSeg
    POKE OAddress, F
    OAddress = OAddress + 1
    IF OAddress = OEndAddress THEN
        PUT #2, , A$
        A& = SADD(A$)
        A& = A& - 65536 * (A& < 0)
        OutputSeg = VARSEG(A$) + (A& \ 16)
        OAddress = (A& MOD 16)
        OEndAddress = OAddress + 5000
        OStart = OAddress
    END IF
    'see if time to update the screen
    PrintCounter = PrintCounter + 1
    IF PrintCounter = 1024 THEN
        PrintCounter = 0
        LOCATE Ypos, Xpos
        PRINT (CurrentByte& * 100) \ FileLength&; "%";
    END IF
'loop until all of the characters have been restored
NEXT
'save whatever is currently in the output buffer
A$ = LEFT$(A$, OAddress - OStart)
PUT #2, , A$
CLOSE
'all done
LOCATE Ypos, Xpos
PRINT " done."

END

'fills the input buffer
SUB FillBuff
    GET #1, , Buffer$
    A& = SADD(Buffer$)
    A& = A& - 65536 * (A& < 0)
    BufferSeg = VARSEG(Buffer$) + (A& \ 16)
    Address = (A& MOD 16)
    EndAddress = Address + BufferLength
    DEF SEG = BufferSeg
END SUB

'gets one bit from the input file(only used when the tree
'is read in)
FUNCTION GetBit STATIC
    IF BitsIn < 0 THEN
        Address = Address + 1
        IF Address = EndAddress THEN
            FillBuff
        END IF
        CurrentByte = PEEK(Address): BitsIn = 7
    END IF
    GetBit = (CurrentByte AND Bits(BitsIn)): BitsIn = BitsIn - 1
END FUNCTION
