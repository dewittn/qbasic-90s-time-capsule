DECLARE SUB BaudLatch (Port%, Speed%)

CLS
PRINT "Press any key...": SLEEP
PRINT "Opening COM..."
CLOSE
OPEN "COM2:19200,N,8,1,BIN" FOR RANDOM AS #1
BaudLatch 2, 3

PRINT "Press any key...": SLEEP
PRINT "Sending test data..."
PRINT #1, "ATD"

PRINT "Press any key...": SLEEP
PRINT "Closing COM..."
CLOSE

SUB BaudLatch (Port%, Speed%)
'Speed: 3 = 38.4, 2 = 56000, 1 = 115K

SELECT CASE Port
        CASE 1
                BaseAddress% = &H3F8
        CASE 2
                BaseAddress% = &H2F8
        CASE 3
                BaseAddress% = &H3E8
        CASE 4
                BaseAddress% = &H2E8
        CASE ELSE
                EXIT SUB
END SELECT
       
        OldLSR% = INP(BaseAddress% + 3)
        OUT (BaseAddress% + 3), (OldLSR% OR &H80)   ' Enable the Divisor Latch
        OUT (BaseAddress% + 0), (Speed% MOD &HFF)   ' Lo Byte of Baud Rate
        OUT (BaseAddress% + 1), (Speed% \ &H100)    ' Hi Byte of baud Rate
        OUT (BaseAddress% + 3), OldLSR%             ' Disable Divisor Latch
END SUB

