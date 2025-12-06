PRINT "Reboot"
PRINT "1. Warm Boot"
PRINT "2. Cold Boot"
PRINT "3. Quit"
INPUT ReBoot%
IF ReBoot% = 1 THEN
  DEF SEG = 0
  POKE &H473, &H12 ' Setup for Warm Boot
  POKE &H472, &H34
  DEF SEG = &HFFFF
  CALL Absolute(0)
ELSEIF ReBoot% = 2 THEN
  DEF SEG = 0
  POKE &H472, &H12 ' Setup for Cold Boot
  POKE &H473, &H34 ' tho not really nessary
  DEF SEG = &HFFFF
  CALL Absolute(0)
ELSE
  SYSTEM
END IF

