                                                                      PAGE   1
                                                                      09 Jul 97
                                                                      15:40:47
Offset  Data    Source Line      Microsoft (R) QuickBASIC Compiler Version 4.50

 0030   0006    DIM check$(1000)
 0030   0006    DIM checktemp$(1000)
 0030   0006    CLS
 0030   1F4E    OPEN "c:\access1.dat" FOR INPUT AS #1
 0030   1F4E     DO UNTIL EOF(1)
 004E   1F4E     numb = numb + 1
 004E   1F4E     INPUT #1, check$(numb)
 0078   1F52     INPUT #1, checktemp$(numb)
 00A2   1F52    LOOP
 00C6   1F52    FOR a = 1 TO numb
 00DA   1F56     FOR b = 1 TO numb
 00EE   1F5A     IF check$(a) = checktemp$(b) THEN Bad = Bad + 1
 012F   1F66    NEXT
 0153   1F66    NEXT
 017A   1F66    IF Bad > 0 THEN PRINT "U have "; Bad; " Duplicates"
 01AF   1F66    PRINT "THere are "; numb; " Enteries"
 01AF   1F66    SLEEP
 01AF   1F66    CLOSE
 01AF   1F66    
 01AF   1F66    
 01E5   1F66    

43869 Bytes Available
43039 Bytes Free

    0 Warning Error(s)
    0 Severe  Error(s)
