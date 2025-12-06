DECLARE FUNCTION rmarin% (ij AS INTEGER, kl AS INTEGER)
DECLARE FUNCTION ranmar% (rvec() AS DOUBLE, ln AS INTEGER)

'************************************************************************
'This random number generator originally appeared in "Toward a Universal
'Random Number Generator" by George Marsaglia and Arif Zaman.
'Florida State University Report: FSU-SCRI-87-50 (1987)
'
'It was later modified by F. James and published in "A Review of Pseudo-
'random Number Generators"
'
'Converted from FORTRAN to C by Phil Linttell, James F. Hickling
'Management Consultants Ltd, Aug. 14, 1989.
'
'THIS IS THE BEST KNOWN RANDOM NUMBER GENERATOR AVAILABLE.
'      (However, a newly discovered technique can yield
'        a period of 10^600. But that is still in the development stage.)
'
'It passes ALL of the tests for random number generators and has a period
'  of 2^144, is completely portable (gives bit identical results on all
'  machines with at least 24-bit mantissas in the floating point
'  representation).
'
'The algorithm is a combination of a Fibonacci sequence (with lags of 97
'  and 33, and operation "subtraction plus one, modulo one") and an
'  "arithmetic sequence" (using subtraction).
'
'On a Vax 11/780, this random number generator can produce a number in
'   13 microseconds.
'***********************************************************************

  CONST TRUE = -1
  CONST FALSE = 0

  DIM SHARED u(97) AS DOUBLE, c AS DOUBLE, cd AS DOUBLE, cm AS DOUBLE
  DIM SHARED i97 AS INTEGER, j97 AS INTEGER, test AS INTEGER

  DIM temp(100) AS DOUBLE
  DIM i AS INTEGER
  DIM ij AS INTEGER, kl AS INTEGER, ln AS INTEGER

  ' These are the seeds needed to produce the test case results

  ij = 1802
  kl = 9373

  ' Do the initialization

  IF rmarin(ij, kl) = 1 THEN END

  ' Generate 20000 random numbers

  ln = 100
  FOR i = 0 TO 199
    IF ranmar(temp(), ln) = 1 THEN END
  NEXT i

  ' If the random number generator is working properly,
  ' the next six random numbers should be:
  '
  '          6533892.0  14220222.0   7275067.0
  '          6172232.0   8354498.0  10633180.0

  ln = 6
  IF ranmar(temp(), ln) = 1 THEN END
  FOR i = 0 TO 5
    PRINT USING "############.#"; 4096# * 4096# * temp(i)
  NEXT

FUNCTION ranmar% (rvec() AS DOUBLE, ln AS INTEGER)
  DIM uni AS DOUBLE
  DIM ivec AS INTEGER

  IF NOT test THEN
    PRINT "RANMAR: Call the initialization routine (RMARIN) ";
    PRINT "before calling RANMAR."
    ranmar = 1
    EXIT FUNCTION
  END IF
  FOR ivec = 0 TO ln - 1
    uni = u(i97) - u(j97)
    IF uni < 0# THEN uni = uni + 1#
    u(i97) = uni
    i97 = i97 - 1
    IF i97 < 0 THEN i97 = 96
    j97 = j97 - 1
    IF j97 < 0 THEN j97 = 96
    c = c - cd
    IF c < 0# THEN c = c + cm
    uni = uni - c
    IF uni < 0# THEN uni = uni + 1#
    rvec(ivec) = uni
    ranmar = 0
  NEXT ivec
END FUNCTION

'************************************************************************
'This is the initialization routine for the random number generator RANMAR()
'NOTE: The seed variables can have values between:    0 <= IJ <= 31328
'                                                     0 <= KL <= 30081
'The random number sequences created by these two seeds are of sufficient
'length to complete an entire calculation with. For example, if several
'different groups are working on different parts of the same calculation,
'each group could be assigned its own IJ seed. This would leave each group
'with 30000 choices for the second seed. That is to say, this random
'number generator can create 900 million different subsequences -- with
'each subsequence having a length of approximately 10^30.
'
'Use IJ = 1802 & KL = 9373 to test the random number generator. The
'subroutine RANMAR should be used to generate 20000 random numbers.
'Then display the next six random numbers generated multiplied by 4096*4096
'If the random number generator is working properly, the random numbers
'should be:
'          6533892.0  14220222.0   7275067.0
'          6172232.0   8354498.0  10633180.0
'***********************************************************************
FUNCTION rmarin% (ij AS INTEGER, kl AS INTEGER)
  DIM s AS DOUBLE, t AS DOUBLE
  DIM i AS INTEGER, j AS INTEGER, k AS INTEGER, l AS INTEGER, m AS INTEGER
  DIM ii AS INTEGER, jj AS INTEGER

  ' Change FALSE to TRUE in the next statement to test the
  ' random routine.

  test = TRUE
  IF (ij < 0 OR ij > 31328) OR (kl < 0 OR kl > 30081) THEN
    PRINT "RMARIN: The first random number seed must have a ";
    PRINT "value between 0 and 31328"
    PRINT "        The second random number seed must have a ";
    PRINT "value between 0 and 30081"
    rmarin = 1
    EXIT FUNCTION
  END IF
  i = INT(ij / 177# MOD 177#) + 2
  j = INT(ij MOD 177#) + 2
  k = INT(kl / 169# MOD 178#) + 1
  l = INT(kl MOD 169#)
  FOR ii = 0 TO 96
    s = 0#
    t = .5
    FOR jj = 0 TO 23
      m = INT(k * (i * j MOD 179#) MOD 179#)
      i = j
      j = k
      k = m
      l = INT((l * 53# + 1#) MOD 169#)
      IF (l * m MOD 64#) >= 32 THEN
        s = s + t
      END IF
      t = t * .5
    NEXT jj
    u(ii) = s
  NEXT
  c = 362436# / 16777216#
  cd = 7654321# / 16777216#
  cm = 16777213# / 16777216#
  i97 = 96
  j97 = 32
  test = TRUE
  rmarin = 0
END FUNCTION

