REM Filename: MAGWRITE.BAS
' Creates a magazine collection file
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
' Get the file's data from the user
CLS
DO
   PRINT
   INPUT "What is the magazine's title"; mag.title
   INPUT "What is the magazine's volume number"; mag.volume
   INPUT "What is the magazine's issue number"; mag.issue
   INPUT "What is the magazine's price"; mag.price
   INPUT "What is the magazine's date"; mag.date
   PUT #1, , mag   ' No record number needed
   INPUT "Do you want to continue (Y/N)"; ans$
LOOP UNTIL (UCASE$(LEFT$(ans$, 1)) = "N")
CLOSE #1
END

