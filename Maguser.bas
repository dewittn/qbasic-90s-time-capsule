REM Filename: MAGUSER.BAS
' Reads and prints a magazine requested by the user
' LOF() helps ensure that user does not enter
'   an out of bounds record number
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
' Get the file's data and display it
CLS
PRINT "** Magazine Collection Listing **"
PRINT
DO
   INPUT "Which magazine record number do you want to see"; userRec
   IF (userRec < high AND userRec > 0) THEN
      GET #1, userRec, mag
      PRINT
      PRINT "Title: "; mag.title
      PRINT "Volume: "; mag.volume; TAB(14);
      PRINT "Issue:"; mag.issue
      PRINT "Price:"; mag.price; TAB(14);
      PRINT "Date: "; mag.date
      PRINT
   END IF
LOOP WHILE (userRec < high AND userRec >= 1)
CLOSE #1
END

