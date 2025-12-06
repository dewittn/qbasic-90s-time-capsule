REM Filename: MAGLOF.BAS
' Reads and prints a magazine collection file
' Read until LOF() signals the end of file is reached
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

FOR i = 1 TO LOF(1) / LEN(mag)
   GET #1, i, mag
   PRINT "Title: "; mag.title
   PRINT "Volume: "; mag.volume; TAB(14);
   PRINT "Issue:"; mag.issue
   PRINT "Price:"; mag.price; TAB(14);
   PRINT "Date: "; mag.date
   PRINT
NEXT i
CLOSE #1
END

