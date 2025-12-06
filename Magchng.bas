REM Filename: MAGCHNG.BAS
' Searches for a specific magazine requested by the user
' and then lets the user specify a different price
' Define the "look" of the record layout
TYPE magazine
   title    AS STRING * 33
   volume   AS STRING * 3
   issue    AS INTEGER
   price    AS SINGLE
   date     AS STRING * 8
END TYPE
'
' Define a record
DIM mag AS magazine
'
' Open the file that will hold the array's data
OPEN "C:\MAG.DAT" FOR RANDOM AS #1 LEN = LEN(mag)
'
' Find the highest record number
high = LOF(1) / LEN(mag)
' Ask the user for the search key
CLS
PRINT "** Magazine Collection Price Change **"
PRINT
INPUT "What title's price do you want to change"; search$
' Because the user might enter uppercase or lowercase and because
' the title in the file might be stated in a different case, the
' search title and each record's title is converted to uppercase
' so a proper comparison can be made
found = 0  ' We can check this later to see if search worked
recCnt = 0 ' So we'll know if we reach end of file
DO
   recCnt = recCnt + 1
   GET #1, recCnt, mag
   IF INSTR(UCASE$(mag.title), UCASE$(search$)) > 0 THEN
      found = 1  ' Later, we'll know the search was good
      PRINT
      PRINT "Here is the record as it appears in the file now:"
      PRINT "Title: "; mag.title
      PRINT "Volume: "; mag.volume; TAB(14);
      PRINT "Issue:"; mag.issue
      PRINT "Price:"; mag.price; TAB(14);
      PRINT "Date: "; mag.date
      PRINT
      PRINT "What price do you want to save in place of"; mag.price;
      INPUT newPrice
      mag.price = newPrice   ' Update record variable
      PUT #1, recCnt, mag          ' Replace the record on the disk
   END IF
LOOP WHILE (recCnt < high AND found = 0)
' Print an error if the search was unsuccessful
IF (found = 0) THEN
   BEEP
   PRINT "Sorry but your title is not in the file."
END IF
CLOSE #1
END

