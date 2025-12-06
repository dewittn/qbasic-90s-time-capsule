REM Filename: MAGREAD.BAS
' Reads a magazine collection file and prints the data
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
' Get the file's data and display it
CLS
PRINT "** Magazine Collection Listing **"
PRINT
FOR i = 1 TO 5   ' Because there are only 5 data values
   GET #1, , mag
   PRINT "Title: "; mag.title
   PRINT "Volume: "; mag.volume; TAB(14);
   PRINT "Issue:"; mag.issue
   PRINT "Price:"; mag.price; TAB(14);
   PRINT "Date: "; mag.date
   PRINT
NEXT i
CLOSE #1
END

