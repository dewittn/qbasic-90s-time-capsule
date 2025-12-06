REM Filename: MAGDATA.BAS
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
FOR i = 1 TO 5   ' Because there are only 5 data values
   READ mag.title, mag.volume, mag.issue, mag.price, mag.date
   PUT #1, i, mag  ' i goes from 1 to 5 just like the record numbers
NEXT i
DATA "Lifeworks", "I", 2, 2.95, "1-2-88"
DATA "Newsmonth", "IV", 9, 4.29, "11-15-90"
DATA "WE", "II", 12, 1.95, "2-1-93"
DATA "Maps-R-Us", "III", 2, 3.50, "3-10-91"
DATA "Coffees", "V", 8, 4.00, "12-1-91"
CLOSE #1
END

