DECLARE SUB SetVoice (OnOff%)
CLS
'-maybe you get the filename from commandline?
  INPUT "Please enter a file path and name (.WAV):  ", WavFile$
  WavFile% = FREEFILE
 
  Delay% = 11                      ' value for delay

'-open the wav-file
  OPEN WavFile$ FOR BINARY AS #WavFile%
  IF LOF(WavFile%) = 0 THEN
    PRINT "Couldn't find file: "; WavFile$
    CLOSE #WavFile%
    KILL WavFile$
    END
  END IF

'-parameters for copy-to-soundblaster
  Bytes& = LOF(WavFile%)          ' number of bytes

  BytesRemaining& = Bytes&        ' number of remaining bytes
  BufferMax% = &H7F00             ' largest buffer
  Buffer$ = SPACE$(BufferMax%)    ' create buffer

  SetVoice 1                      ' Soundblaster on

'-read {BufferMax%} bytes from disc, output on SB
  DO
     BytesRemaining& = BytesRemaining& - BufferLen%
     IF BytesRemaining& = 0 THEN EXIT DO ' nothing left over?
     IF BytesRemaining& > BufferMax% THEN ' how many bytes?
        BufferLen% = BufferMax%          '
     ELSE
        BufferLen% = BytesRemaining&     ' remaining (<BufferMax%)..
        Buffer$ = SPACE$(BufferLen%)     ' ..throw it into SB :-)
     END IF

     GET #WavFile%, , Buffer$            ' read buffer
     DEF SEG = VARSEG(Buffer$)           ' get address of buffer
     VOff& = SADD(Buffer$)

     FOR t% = 1 TO BufferLen%            ' output od {bufferlen%}
         FOR qq% = 1 TO Delay: NEXT qq%  ' delay
         WAIT &H22C, &H80, &HFF          ' wait for data-ready
         OUT &H22C, &H10
         WAIT &H22C, &H80, &HFF
         OUT &H22C, PEEK(VOff&)
         VOff& = VOff& + 1
     NEXT t%


  LOOP WHILE INKEY$ = ""

  SetVoice 0                            ' SB off
  CLOSE #WavFile%                       ' close file
  END                                   ' .. good bye :-)

SUB SetVoice (OnOff%)
    IF OnOff% THEN
       WAIT &H22C, &H80, &HFF       ' wait for data-ready on SB
       OUT &H22C, &HD1              ' ON
    ELSE
       WAIT &H22C, &H80, &HFF
       OUT &H22C, &HD3              ' OFF
    END IF
END SUB

