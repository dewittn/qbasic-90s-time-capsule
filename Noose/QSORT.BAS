DEFINT A-Z
DECLARE SUB QuickSort (Array%())
TYPE StackType
  low AS INTEGER
  hi AS INTEGER
END TYPE

CLS
RANDOMIZE TIMER
INPUT "Elements in array (1-20000)? ", MaxFill
DIM SortArray(1 TO MaxFill)
IF MaxFill > 20000 THEN MaxFill = 20000
IF MaxFill < 1 THEN MaxFill = 1
PRINT
PRINT "Filling integer array..."
FOR a = 1 TO MaxFill
  SortArray(a) = a
NEXT a
PRINT "Randomizing array..."
FOR a = 1 TO MaxFill
  SWAP SortArray(a), SortArray(INT(RND * MaxFill) + 1)
  SWAP SortArray(a), SortArray(INT(RND * MaxFill) + 1)
  SWAP SortArray(a), SortArray(INT(RND * MaxFill) + 1)
NEXT a
PRINT
PRINT "QuickSorting array..."
ST! = TIMER
QuickSort SortArray()
ET! = TIMER
PRINT "Time taken:"; ET! - ST!; "seconds."
PRINT
PRINT "Checking if sorted correctly..."
oNum = -32768: sortErr = 0
FOR a = 1 TO MaxFill
  nNum = SortArray(a)
  IF oNum > nNum THEN PRINT "Sorted incorrectly!": sortErr = -1: EXIT FOR
  oNum = nNum
NEXT a
IF sortErr = 0 THEN PRINT "Sorted correctly!"

DEFLNG A-Z
SUB QuickSort (Array() AS INTEGER)
DIM aStack(1 TO 128) AS StackType

  StackPtr = 1
  aStack(StackPtr).low = LBOUND(Array)
  aStack(StackPtr).hi = UBOUND(Array)
  StackPtr = StackPtr + 1

  DO
    StackPtr = StackPtr - 1
    low = aStack(StackPtr).low
    hi = aStack(StackPtr).hi
    DO
      i = low
      j = hi
      mid = (low + hi) \ 2
      compare = Array(mid)
      DO
        DO WHILE Array(i) < compare
          i = i + 1
        LOOP
        DO WHILE Array(j) > compare
          j = j - 1
        LOOP
        IF i <= j THEN
          SWAP Array(i), Array(j)
          i = i + 1
          j = j - 1
        END IF
      LOOP WHILE i <= j
      IF j - low < hi - i THEN
        IF i < hi THEN
          aStack(StackPtr).low = i
          aStack(StackPtr).hi = hi
          StackPtr = StackPtr + 1
        END IF
        hi = j
      ELSE
        IF low < j THEN
          aStack(StackPtr).low = low
          aStack(StackPtr).hi = j
          StackPtr = StackPtr + 1
        END IF
        low = i
      END IF
    LOOP WHILE low < hi
  LOOP WHILE StackPtr <> 1
ERASE aStack

END SUB

