' .VOC Player
' Edit VocFile$ to your desired file & directory

DECLARE SUB SetVoice (OnOff%)

'Set this to directory where VOC files are stored.

'-Div.Init (maybe you get the filename from commandline?
  VocFile$ = "C:\QUICK\TEST.VOC"        ' input-file
  VocFile% = FREEFILE
  Delay% = 3                                    ' value for delay

'-open the voc-file
  OPEN VocFile$ FOR BINARY AS #VocFile%

'-parameters for copy-to-soundblaster
  Bytes& = LOF(VocFile%)          ' number of bytes
  BytesRemaining& = Bytes&        ' number of remaining bytes
  BufferMax% = &H7F00             ' largest buffer
  Buffer$ = SPACE$(BufferMax%)    ' create buffer

  SetVoice 1                      ' Soundblaster on

'-read {BufferMax%} bytes from disc, output on SB
  DO
     BytesRemaining& = BytesRemaining& - BufferLen%
     IF BytesRemaining& = 0 THEN EXIT DO  ' nothing left over?
     IF BytesRemaining& > BufferMax% THEN ' how many bytes?
        BufferLen% = BufferMax%
     ELSE
        BufferLen% = BytesRemaining&     ' remaining (<BufferMax%)..
        'Buffer$ = SPACE$(BufferLen%)     ' ..throw it into SB :-)
     END IF
     
     GET #VocFile%, , Buffer$            ' read buffer
     DEF SEG = VARSEG(Buffer$)           ' get address of buffer
     VOff& = SADD(Buffer$)               ' erase buffer

     FOR t% = 1 TO BufferLen%            ' output od {bufferlen%}
         FOR qq% = 1 TO Delay%: NEXT qq% ' delay
         WAIT &H22C, &H80, &HFF          ' wait for data-ready
         OUT &H22C, &H10
         WAIT &H22C, &H80, &HFF
         OUT &H22C, PEEK(VOff&)
         VOff& = VOff& + 1
     NEXT t%
     
  LOOP WHILE INKEY$ = ""

  SetVoice 0                            ' SB off
  CLOSE #VocFile%                       ' close file
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

