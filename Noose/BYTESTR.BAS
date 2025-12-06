DECLARE FUNCTION ByteStr$ (v AS LONG)
'Turns a number of bytes into a string like "1.2 MB", "3.4 KB",
'or "121 bytes". See the example below.

CLS
PRINT
PRINT "===== Bytes ====|==== ByteStr$ ====="
PRINT "              1 = "; ByteStr$(1)
PRINT "             12 = "; ByteStr$(12)
PRINT "            123 = "; ByteStr$(123)
PRINT "          1,230 = "; ByteStr$(1230)
PRINT "         12,300 = "; ByteStr$(12300)
PRINT "        123,000 = "; ByteStr$(123000)
PRINT "      1,230,000 = "; ByteStr$(1230000)
PRINT "     12,300,000 = "; ByteStr$(12300000)
PRINT "    123,000,000 = "; ByteStr$(123000000)
PRINT "  1,230,000,000 = "; ByteStr$(1230000000)

DEFINT A-Z
FUNCTION ByteStr$ (v AS LONG)
SELECT CASE v
  CASE IS >= 1000000000
    s$ = LTRIM$(RTRIM$(STR$(v / 1000000000)))
    IF LEN(s$) > 4 THEN s$ = LEFT$(s$, 4)
    IF RIGHT$(s$, 1) = "." THEN s$ = LEFT$(s$, 4)
    s$ = s$ + " GB"
  CASE IS >= 1000000 AND v < 1000000000
    s$ = LTRIM$(RTRIM$(STR$(v / 1000000)))
    IF LEN(s$) > 4 THEN s$ = LEFT$(s$, 4)
    IF RIGHT$(s$, 1) = "." THEN s$ = LEFT$(s$, 4)
    s$ = s$ + " MB"
  CASE IS < 1000000 AND v >= 1000
    s$ = LTRIM$(RTRIM$(STR$(v / 1000)))
    IF LEN(s$) > 4 THEN s$ = LEFT$(s$, 4)
    IF INSTR(s$, ".") < LEN(s$) - 1 THEN s$ = LEFT$(s$, LEN(s$) - 1)
    IF RIGHT$(s$, 1) = "." THEN s$ = LEFT$(s$, 4)
    s$ = s$ + " KB"
  CASE IS < 1000
    s$ = LTRIM$(RTRIM$(STR$(v))) + " bytes"
  CASE ELSE
    s$ = LTRIM$(RTRIM$(STR$(v))) + " x"
END SELECT
ByteStr$ = s$
END FUNCTION

