'ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
'ณ               Molnar \ Kucalaba Production proudly present:               ณ
'ณ                                                                           ณ
'ณ                  "Little Bastard" Modem WarFare v1.3                      ณ
'ณ                                                                           ณ
'ณ   We would like to thank Mark Kim (ftp://members.aol.com/markkkim) for    ณ
'ณ    helping us tremendously with this program, lending us the "Connect"    ณ
'ณ           routine, and for just plain being a swell guy.                  ณ
'ณ                                                                           ณ
'ณ    Since this program was not going to be compiled, we crammed as many    ณ
'ณ features as we could into it, as long as the file stayed under or around  ณ
'ณ  45,000 bytes. Once we had all the normal stuff in, we put in some extra  ณ
'ณ   stuff, like the re-designed interface, the screen saver, and the phone  ณ
'ณ                    book features. Just a bit of info.                     ณ
'ณ                                                                           ณ
'ณ Huge thanks to Ben Johnson, who beta tested this with us for hours on end.ณ
'ณ                                                                           ณ
'ณ   If you use "Little Bastard" Modem WarFare a lot, a small contribution   ณ
'ณ   (around $4-5, but we'll take anything) is greatly appreciated, but not  ณ
'ณ    required. This took many hard hours of work to make and we hope you    ณ
'ณ      consider contributing. Complete details are in MWARFARE.DOC          ณ
'ณ                                                                           ณ
'ณ                                                                           ณ
'ณThe newest M \ K programs and lots of good examples are at your fingertips!ณ
'ณ                                                                           ณ
'ณ               FTP to : ftp://members.aol.com/blood225                     ณ
'ณ                                                                           ณ
'ณ          Over a megabyte of high quality QBasic programs!                 ณ
'ณ                                                                           ณ
'ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ                                                                             ณ

DECLARE SUB PhoneBook (N$)
DECLARE SUB FindBook (N$)
DECLARE SUB lnput (txt$, L%, Row%, Col%)
DECLARE SUB Menu (Array() AS ANY)
DECLARE SUB RaiseHell ()
DECLARE SUB ReadMe ()
DECLARE SUB StarField ()
DECLARE SUB SendFile (Ajax%, Text$)
DECLARE SUB Slide (Row%, Text$)
DECLARE SUB delay (Seconds!)
DECLARE SUB WaitConnect (Ty%)
DECLARE SUB PrintHStuff (High%)
DECLARE SUB PrintStuff ()
DECLARE SUB CStatus ()
DECLARE SUB FreeBase ()
DECLARE SUB GetPress ()
DECLARE SUB RInit ()
DECLARE SUB TurnOn ()
DECLARE SUB ComunA ()
DECLARE SUB Config ()
DECLARE SUB ScrollTextFile (Name$)
DECLARE SUB Guts ()
DECLARE SUB ScrollDelay (Seconds!)
DECLARE SUB SendMessage (Max%)
DECLARE FUNCTION Fixed$ (A$)
DECLARE SUB GetHandle ()
DECLARE SUB Bar ()
DECLARE SUB Chat ()
DECLARE SUB OpenCOM ()
DECLARE SUB Connect ()

'$DYNAMIC


'Beginning of code. Code is not very nice, I concentrated on making it work
'before it was nice. In most cases, it never got to the "nice" stage. I guess
'this is one of those programs you run and don't worry about how it works.

TYPE Stars
 XPos AS INTEGER
 YPos AS INTEGER
 Speed AS INTEGER
END TYPE

TYPE Config
 COMPort AS STRING * 1
 CW AS STRING * 1
 TP AS STRING * 1
END TYPE

TYPE OhMyGod
 Text AS STRING * 60
 VP AS INTEGER
END TYPE

TYPE OptionType
 Text AS STRING * 20
 VP AS INTEGER
 Showing AS INTEGER
END TYPE

TYPE BookType
 Number AS STRING * 14
 Des AS STRING * 59
END TYPE


CLEAR
DIM SHARED S(200) AS Stars
DIM SHARED Comun$, CurRow%, CurCol%, ChatMode%, Name$, Dest!, Text$, ShowCol%, NoFind%, RetVal%
DIM SHARED SFlag%, RFlag%, High%, Nb%, Book%
DIM SHARED FileBuffer AS STRING * 1, RecBuffer AS STRING * 1
DIM SHARED CFG AS Config
DIM SHARED MM(12) AS OhMyGod
DIM SHARED Cho(3) AS OhMyGod
DIM SHARED Bok(4) AS OhMyGod
DIM SHARED Han(3) AS OhMyGod
DIM SHARED Options(3) AS OptionType
DIM SHARED DText(3, 2) AS STRING * 29
DIM SHARED Phone(15) AS BookType

DText(1, 1) = "1"
DText(1, 2) = "2"
DText(2, 1) = "No"
DText(2, 2) = "Yes"
DText(3, 1) = "Tone"
DText(3, 2) = "Pulse"

RANDOMIZE TIMER
FOR Times% = 1 TO 200
 S(Times%).XPos = INT(RND * 640) + 1
 S(Times%).YPos = INT(RND * 480) + 1
 S(Times%).Speed = INT(RND * 5) + 1
NEXT
RESTORE NoBug
FOR Times% = 1 TO 3
 READ Options(Times%).Text, Options(Times%).VP, Options(Times%).Showing
NEXT
FOR t% = 1 TO 3
 READ Han(t%).VP, Han(t%).Text
NEXT
ON ERROR GOTO NoConfig
OPEN "lbmwf.cfg" FOR INPUT AS #1: CLOSE #1
ON ERROR GOTO 0
OPEN "lbmwf.cfg" FOR RANDOM AS #1
 GET #1, , CFG
CLOSE #1
IF NoFind% = 1 THEN
 CFG.COMPort = "2"
 CFG.CW = "N"
 CFG.TP = "T"
  OPEN "lbmwf.cfg" FOR RANDOM AS #1 LEN = LEN(CFG)
   PUT #1, , CFG
  CLOSE #1
END IF

ComunA

ON ERROR GOTO 0

CStatus

TurnOn

ON ERROR GOTO 0
WayBack:
High% = 1
SCREEN 0
WIDTH 80
Dat$ = ""
CLS
COLOR 15
RESTORE Title
FOR t% = 1 TO 23
 READ A$
 PRINT A$
NEXT
FOR t% = 1 TO 12
 READ MM(t%).VP, MM(t%).Text
 Slide MM(t%).VP, MM(t%).Text
NEXT
PCOPY 0, 2
DO
MakeTitle:
PCOPY 2, 0
High% = 1
COLOR 13
PCOPY 0, 1
Slide MM(1).VP, MM(1).Text
RetVal% = 0
Menu MM()

 SELECT CASE RetVal%
  CASE 1: Config
  CASE 2: GOSUB CallSomeOne
  CASE 3: PRINT #1, "+++ATH": : delay .5: PRINT #1, "ATZ": delay .5:  CLOSE #1: delay .5: OpenCOM
  CASE 4: PRINT #1, "ATM/M0": delay .55
  CASE 5: PRINT #1, "ATL/L0": delay .55
  CASE 6: PRINT #1, "ATL3": delay .45
  CASE 7: GOSUB KnockOff
  CASE 8: GOSUB TwoChat: GOTO WayBack
  CASE 9: FreeBase
  CASE 10: StarField: GOTO WayBack
  CASE 11: ReadMe
  CASE 12: CLOSE #1: RESET: SYSTEM
 END SELECT
LOOP

CallSomeOne:
CLS
COLOR 15
RESTORE Booky
FOR t% = 1 TO 8
 READ A$
 PRINT A$
NEXT
 FOR t% = 1 TO 4
  READ Bok(t%).VP, Bok(t%).Text
  Slide Bok(t%).VP, Bok(t%).Text
 NEXT
 PCOPY 0, 1
 High% = 1
 COLOR 13
 Slide Bok(1).VP, Bok(1).Text
 Menu Bok()
 Book% = RetVal%
 N$ = "book" + Fixed(STR$(RetVal%)) + ".pbk"
 FindBook N$
 PhoneBook N$
RETURN

'Slide 10, "726-2620, 726-3614"

KnockOff:
CLS
COLOR 15
Slide 2, "Is someone on the phone line? (Don't worry if not)"
GetPress
PRINT #1, "ATM2H1L1"
Slide 4, "Take that you queer! heh heh"
GetPress
PRINT #1, "ATZ"
PRINT #1, "+++ATH"
RETURN

TwoChat:
CLS
GetHandle
RESTORE Choose
 FOR t% = 1 TO 7
  READ A$
  PRINT A$
 NEXT
 FOR t% = 1 TO 3
  READ Cho(t%).VP, Cho(t%).Text
  Slide Cho(t%).VP, Cho(t%).Text
 NEXT
PCOPY 0, 1
High% = 1
COLOR 13
Slide Cho(1).VP, Cho(1).Text
Menu Cho()

               SELECT CASE RetVal%
                 CASE 1:  COLOR 15
                          Slide 10, "Number to call (i.e  123-4567)"
                          lnput Call$, 14, 11, 33
                          IF CFG.CW = "Y" THEN Call$ = "*70," + Call$
                          PRINT #1, "ATD" + CFG.TP + Call$
                          WaitConnect 0
                          RETURN
                 CASE 2:  COLOR 15
                          Slide 10, "You are waiting for the guy to call you now."
                          PRINT #1, "ATS0=1"
                          WaitConnect 0
                          RETURN
                 CASE 3: RETURN
                END SELECT

COLOR 15
FOR Times% = 1 TO 3
 Slide Cho(Times%).VP, Cho(Times%).Text
NEXT
COLOR 13
Slide Cho(High%).VP, Cho(High%).Text
































WhoMade:
DATA "þ"
DATA ""
DATA "                                                                               "
DATA "            'Little Bastard' Modem WarFare v1.1 Beta 2 Credits                 "
DATA "                                                                               "
DATA "Main Programmer        : Luke Molnar                                           "
DATA "Additional Programming : Luke Kucalaba                                         "
DATA "ASCII Art              : Luke Molnar, Luke Kucalaba                            "
DATA "Beta testing           : Ben Johnson                                           "              
DATA "Very Special Thanks    : Mark K Kim                                            "
DATA "Greetings              : AnSolaris, SWC Team 2, ReinierZ, YipYow               "                                          
DATA "                                                                               "
DATA "       ---> A Molnar \ Kucalaba Productions Presentation  <---                 "
DATA "                                                                               "
DATA ""
Advertise:
DATA ""
DATA "                                                                             "
DATA "               Little Bastard Modem War Fare version 1.3                     "
DATA "                                                                             "
DATA "            Brought to you by : Molnar \ Kucalaba Productions                "
DATA "                                                                             "
DATA ""
StarWarp:
DATA "     ึฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤท     "
DATA "     บ   ีออออธ ีออัออธ  ีอธ   ีออออธ    ั        ั  ีอธ   ีออออธีออออธ  บ     "
DATA "     บ   ณ         ณ    ีพ ิธ  ณ    ณ    ณ        ณ ีพ ิธ  ณ    ณณ    ณ  บ     "
DATA "     บ   ณ         ณ   ีพ   ิธ ณ    ณ    ิธ  ีธ  ีพีพ   ิธ ณ    ณณ    ณ  บ     "
DATA "     บ   ิออออธ    ณ   ฦอออออต ฦอออัพ ฤฤฤ ณ  ณณ  ณ ฦอออออต ฦอออัพฦออออพ  บ     "
DATA "     บ        ณ    ณ   ณ     ณ ณ   ณ      ิธีพิธีพ ณ     ณ ณ   ณ ณ       บ     "
DATA "     บ        ณ    ณ   ณ     ณ ณ   ณ       ณณ  ณณ  ณ     ณ ณ   ณ ณ       บ     "
DATA "     บ   ิออออพ    ฯ   ฯ     ฯ ฯ   ฯ       ิพ  ิพ  ฯ     ฯ ฯ   ฯ ฯ       บ     "
DATA "     ำฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฝ     "
Pieces:
DATA "                     ฺฤฤฤฤฟ                                                    "
DATA "                     ณ    ณ  ์    QBasic                                       "
DATA "                     รฤฤฤฤู  ย  ฺฤฤฟ  ฺฤฤฟ  ฺฤฤฟ  ฺฤฤฟ                         "
DATA "                     ณ       ณ  รฤฤู  ณ     รฤฤู  ภฤฤฟ                         "
DATA "                     ม       ม  ภฤฤู  ภฤฤู  ภฤฤู  ภฤฤู                         "
DATA "                                                                               "
DATA "                       Programmed by Luke Kucalaba                             "
DATA "              Brought to you by Molnar \ Kucalaba Productions                  "
DATA "                            DOWNLOAD TODAY!                                    "
YerMuther:
DATA "þ"
DATA "ษอป    ษอป ษอออป ษอป ษอป ษออออออป                                              "
DATA "บ บ    บ บ บ   บ บ บ บ บ บษออออปบ                                              "
DATA "บ บ    บ บ บษอปบ บ บ บ บ บบ  ษอผบ                                              "
DATA "บ ศออออผ บ บบ บบ บ บ บ บ บศออผษอผ                                              "
DATA "ศออป  ษออผ บบ บบ บ ศอผ บ บ ษอปศป                                               "
DATA "   บ  บ    บศอผบ บ     บ บ บ ศปศป                                              "
DATA "   บ  บ    บ   บ บ     บ บ บ  ศปบ                                              "
DATA "   ศออผ    ศอออผ ศอออออผ ศอผ   ศผ                                              "
DATA "                                                                               "
DATA "ษออป    ษออป ษอออป ษออออออป ษป ษป ษออออออป ษออออออป                            "
DATA "บ  ศป  ษผ  บ บ   บ ศออปษออผ บบ บบ บ ษออออผ บษออออปบ                            "
DATA "บษป บ  บ ษปบ บษอปบ    บบ    บศอผบ บ ศอออป  บบ  ษอผบ                            "
DATA "บบบ ศปษผ บบบ บบ บบ    บบ    บษอปบ บ ษอออผ  บศออผษอผ                            "
DATA "บบศป บบ ษผบบ บบ บบ    บบ    บบ บบ บ บ      บ ษอปศป                             "
DATA "บบ บ ศผ บ บบ บศอผบ    บบ    บบ บบ บ บ      บ บ ศปศป                            "
DATA "บบ ศออออผ บบ บ   บ    บบ    บบ บบ บ ศออออป บ บ  ศปบ                            "
DATA "ศผ        ศผ ศอออผ    ศผ    ศผ ศผ ศออออออผ ศอผ   ศผ                            "
House:
DATA "þ"
DATA "  ฑ   ฑ                  ฑ                                                     "
DATA "  ฑฑ ฑฑ  ฑฑฑ  ฑ ฑฑฑ        ฑฑฑ     ฑฑฑ ฑฑ  ฑ   ฑ                               "
DATA "   ฑฑฑ  ฑฑฑฑฑ  ฑฑ  ฑ     ฑ ฑ ฑ     ฑ  ฑ  ฑ  ฑฑฑ                                "
DATA " ฑ  ฑ   ฑ      ฑ         ฑ ฑ ฑ     ฑ  ฑ  ฑ   ฑ                                 "
DATA "  ฑฑ     ฑฑฑ  ฑฑ         ฑ ฑ ฑ     ฑ  ฑ  ฑ ฑฑ                                  "
DATA "                                                                               "
DATA "     ฑ                                  ฑ    ฑ   ฑฑฑ   ฑ           ฑ    ฑ      "
DATA "     ฑ                                  ฑฑ   ฑ  ฑ   ฑ  ฑ     ฑ     ฑ   ฑฑฑ     "
DATA "     ฑ     ฑฑ  ฑ  ฑ   ฑฑฑฑ  ฑฑฑ         ฑ ฑ  ฑ ฑ     ฑ  ฑ   ฑ ฑ   ฑ     ฑ      "
DATA "     ฑฑฑ  ฑ  ฑ ฑ  ฑ  ฑฑ    ฑฑฑฑฑ        ฑ  ฑ ฑ ฑ     ฑ  ฑ   ฑ ฑ   ฑ     ฑ      "
DATA "     ฑ  ฑ ฑ  ฑ ฑ  ฑ    ฑฑฑ ฑ            ฑ   ฑฑ  ฑ   ฑ    ฑ ฑ   ฑ ฑ             "
DATA "    ฑฑ  ฑ  ฑฑ   ฑฑฑฑ ฑฑฑฑ   ฑฑฑ         ฑ    ฑ   ฑฑฑ      ฑ     ฑ       ฑ      "
DATA "                                                                               "
Face:
DATA "þ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฑฑฑฑฑฑฑฑฑฑฑฑฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฑฑฑฒฒฒฒฒฒฒฒฒฒฒฒฑฑฑฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐÛÛฐฐฐฐÛÛฐฐฐฐฐÛÛÛฐฐฐฐฐฐฐฐฑฑฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฑฑฐฐฐฐฐฐÛÛฐฐฐฐÛÛฐฐฐฐฐÛÛÛฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐÛฐฐฐฐฐฐฑฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฑฐฐฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐÛฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฑฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฑฐฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฑฒฒฒฒฒฑฑฑฑฒฒฒฒฒฒฑฑฑฑฒฒฒฒฒฑฐฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฑฒฒฒฒฒฑฒÛÛฒฑฒฒฒฒฑฒÛÛฒฑฒฒฒฒฒฑฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฑฒฒฒฒฒฒฑฑฑฑฒฒฒฒฒฒฑฑฑฑฒฒฒฒฒฒฑฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛÛÛÛÛÛฐฐฐฐÛÛÛÛÛÛÛฐฐฐฑฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฑฐฐฐฐÛÛÛÛÛÛฐฐฐฐÛÛÛÛÛÛÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฑฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฑฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฑฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฑฐฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฑฒฒฒฒฒฑฑฑฑฑฑฑฑฑฑฑฑฑฑฒฒฒฒฒฑฐฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฑฒฒฒฒฒฒฒฒฑÛÛÛÛฑฒฒฒฒฒฒฒฒฑฐฐฐฐฐฐÛฐฐฐฐÛฐฐฐฐÛฐฐฐฐฐÛฐฐฐฐฐฐฐ"
DATA "ฐฐÛÛฐฐฐฐÛÛฐฐÛÛฐฐฐฐฐÛÛฐฐฐฐฐฑฑฒฒฒฒฒฒฒฑฑฑฑฒฒฒฒฒฒฒฑฑฐฐฐฐฐฐÛÛฐฐฐฐÛÛฐฐÛÛฐฐฐฐฐÛÛฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฑฑฑฒฒฒฒฒฒฒฒฒฒฒฒฑฑฑฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฑฑฑฑฑฑฑฑฑฑฑฑฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
DATA "ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ"
Mk:
DATA "þ"
DATA "                        ษออป         ษออป   ษอป                                "
DATA "                        บศป       ษผบ  ษผบ                                "
DATA "                        บศป     ษผบ ษผษผ                                "
DATA "                        บษปศป   ษผษปบษผษผ                                 "
DATA "                        บบศปศป ษผษผบศผษผ                                  "
DATA "                        บบ ศปศอผษผ บษผ                                   "
DATA "                        บบ  ศปษผ  บบ                                    "
DATA "                        บบ   ศปษผ   บศป                                   "
DATA "                        บบ    ศอผ    บษปศป                                  "
DATA "                        บบ           บบศปศป                                 "
DATA "                        บบ           บบ ศปศป                                "
DATA "                        บบ           บบ  ศปบ                                "
DATA "                        ศอผ           ศอผ   ศอผ                                "




Title:
DATA "ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ"
DATA "ณ                ฏย  ยฺยฟฺยฟย  ยฤฟ   ยฤฟยฤยฺฤฟฺยฟยฤย ยฤฟ ยฤฟฎ                 ณ"
DATA "ณ                 ณ  ณ ณ  ณ ณ  รด    รฤดรฤดภฤฟ ณ รฤด รฤด ณ ณ                  ณ"
DATA "ณ                 ภฤูม ม  ม ภฤูมฤู   มฤูม มภฤู ม ม ม ม ภ มฤู                  ณ"
DATA "ณ               ยฟฺยฺฤฟยฤฟยฤฟยฟฺย   ย  ย ยฤย ยฤฟ ยฤฟยฤย ยฤฟ ยฤฟ               ณ"
DATA "ณ               ณภูณณ ณณ ณรด ณภูณ   ณฺฟณ รฤด รฤด รด รฤด รฤด รด                ณ"
DATA "ณ               ม  มภฤูมฤูมฤูม  ม   มูภม ม ม ม ภ ม  ม ม ม ภ มฤู               ณ"
DATA "ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต"
DATA "ณ                         Please select an option:                            ณ"
DATA "ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต"
DATA "ณ                                                                             ณ"
ByteSaver:
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ณ                                                                             ณ"
DATA "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"
DATA 11, "1) Configure your modem"    
DATA 12, "2) Phone Book (connect to BBS's, etc)"
DATA 13, "3) Hang up and reset modem"
DATA 14, "4) Elimimate Ringing tone"
DATA 15, "5) Very low modem volume"
DATA 16, "6) Extremely loud and annoying modem volume"
DATA 17, "7) Kick person at your house off the phone"
DATA 18, "8) The famous Two Man Chat Room!
DATA 19, "9) Modem Free Base (type modem commands directly to modem)"
DATA 20, "10) Screen Saver"
DATA 21, "11) Read This!"
DATA 22, "12) Exit program"
NoBug:
DATA "COM Port",9,1,"Disable Call Waiting",11,1,"Dial",13,1
MoreBugs:
DATA 4, "1) Configure your modem"
DATA 5, "2) Try opening your modem again"
DATA 6, "3) Exit the program"

Choose:
DATA "ึฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤท"
DATA "บ                    You must choose...but choose wisely.                      บ"
DATA "วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ"
DATA "บ                                                                              บ"
DATA "บ                                                                              บ"
DATA "บ                                                                              บ"
DATA "ำฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฝ
DATA 4, "1) Call the guy"
DATA 5, "2) Wait for the guy to call you"
DATA 6, "3) Go back to the title screen"

Booky:
DATA "ึฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤท"
DATA "บ                 Hey man, pick a phone book to dial from!                     บ"
DATA "วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ"
DATA "บ                                                                              บ"
DATA "บ                                                                              บ"
DATA "บ                                                                              บ"
DATA "บ                                                                              บ"
DATA "ำฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฝ
DATA 4, "Phone Book 1"
DATA 5, "Phone Book 2"
DATA 6, "Phone Book 3"
DATA 7, "Phone Book 4"



NoConfig:
NoFind% = 1
CLS
RESUME NEXT

Check:
CLS
COLOR 15
RESTORE Choose
FOR Times% = 1 TO 7
 READ A$: PRINT A$
NEXT

Slide 2, "I had problems opening your modem. Right now you have 3 options."
FOR t% = 1 TO 3
 Slide Han(t%).VP, Han(t%).Text
NEXT
PCOPY 0, 1
High% = 1
COLOR 13
Slide Han(1).VP, Han(1).Text
Menu Han()
SELECT CASE RetVal%
 CASE 1: Config: ComunA: TurnOn: OpenCOM: GOTO WayBack
 CASE 2: OpenCOM: GOTO WayBack
 CASE 3: SYSTEM
END SELECT

BSend:
SFlag% = -1
RESUME NEXT

BRec:
RFlag% = -1
RESUME NEXT

NoBook:
Nb% = -1
RESUME NEXT

REM $STATIC
SUB Bar
COLOR 12
PRINT "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
PRINT "บ                                                                              บ"
PRINT "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
END SUB

SUB Chat
CLS
SCREEN 12
RANDOMIZE TIMER
PALETTE 13, 63
PALETTE 14, 65536 * 63
PALETTE 12, 65536 * 63 + 63
Bar
CurRow% = 4
CurCol% = 1
ShowRow% = 2
ShowCol% = 2
DO
Ch$ = INKEY$
LOCATE 2, ShowCol%: PRINT ""
 
  SELECT CASE Ch$
     CASE CHR$(8):
      IF ShowCol% > 2 THEN
       LOCATE 2, ShowCol% - 1
       PRINT " ",
       LOCATE 2, ShowCol% - 1
       Text$ = LEFT$(Text$, LEN(Text$) - 1)
      END IF
      IF ShowCol% > 2 THEN ShowCol% = ShowCol% - 1
      Ch$ = ""
     CASE CHR$(13):
                     SELECT CASE Fixed(Text$)
                      CASE "/clear": CLS : Bar: CurCol% = 1: CurRow% = 4: RInit
                      CASE "/hangup": EXIT SUB
                      CASE "/whomade": RESTORE WhoMade: SendMessage 15
                      CASE "/starwarp": RESTORE StarWarp: SendMessage 9
                      CASE "/advertise": RESTORE Advertise: SendMessage 7
                      CASE "/pieces": RESTORE Pieces: SendMessage 9
                      CASE "/jomomma": RESTORE YerMuther: SendMessage 18
                      CASE "/whodamen?": RESTORE Mk: SendMessage 14
                      CASE "//roll": NText$ = "OnlineHost : " + Name$ + " rolled 2 6-sided dice : " + STR$(INT(RND * 6) + 1) + STR$(INT(RND * 6) + 1)
                                     NText$ = NText$ + SPACE$(79 - LEN(NText$)) + CHR$(13)
                                     PRINT #1, NText$
                                     LOCATE CurRow%, 1: PRINT NText$
                                     CurRow% = CurRow% + 1
                                     IF CurRow% = 28 THEN CLS : Bar: CurRow% = 4
                                     Text$ = ""
                                     LOCATE 2, 2: PRINT SPACE$(78): ShowCol% = 2
                      CASE "/house": RESTORE House: SendMessage 14
                      CASE "/face": RESTORE Face: SendMessage 20
                     END SELECT
  
                   IF LEFT$(Fixed(Text$), 4) = "/big" THEN
                    CLS : Bar: CurRow% = 6: CurCol% = 1
                     COLOR 13: LOCATE 2, 2: PRINT Text$
                      FOR O5 = 18 TO 30
                       LOCATE CurRow%, 1
                        FOR I5 = 47 TO 129
                         IF POINT(I5, O5) <> 0 THEN PRINT "Û"; : PRINT #1, "Û"
                         IF POINT(I5, O5) = 0 THEN PRINT " "; : PRINT #1, " "
                        NEXT
                        PRINT #1, CHR$(13)
                        CurRow% = CurRow% + 1
                      NEXT
                    END IF
                    IF LEFT$(Fixed(Text$), 5) = "/mask" THEN
                     Text$ = MID$(Text$, 7, LEN(Text$))
                     Text$ = Text$ + SPACE$(79 - LEN(Text$)) + CHR$(13)
                     LOCATE CurRow%
                     PRINT Text$
                     CurRow% = CurRow% + 1
                     PRINT #1, Text$

                     IF CurRow% = 28 THEN CLS : Bar: CurRow% = 4
                     Text$ = ""
                     LOCATE 2, 2: PRINT SPACE$(78): ShowCol% = 2
                    END IF
                   
                    IF LEFT$(Fixed(Text$), 5) = "/send" THEN
                     SFlag% = 0
                     ON ERROR GOTO BSend
                      na$ = MID$(Text$, 7, LEN(Text$))
                      OPEN na$ FOR INPUT AS #2
                      CLOSE #2
                     ON ERROR GOTO 0
                     IF SFlag% <> -1 THEN
                      PRINT #1, "๚"
                      SendFile 1, Text$
                      CLS : Bar: RInit: CurCol% = 1
                     END IF
                      SFlag% = 0
                      Text$ = ""
                    END IF
                  IF Text$ <> "" THEN
                    Text$ = Name$ + " : " + Text$
                     Text$ = Text$ + SPACE$(79 - LEN(Text$)) + CHR$(13)
                     PRINT #1, LEFT$(Text$, 80)
                     LOCATE 2, 2: PRINT SPACE$(78)
                     LOCATE CurRow%
                     PRINT Text$: CurRow% = CurRow% + 1: CurCol% = 1
                     IF CurRow% = 29 THEN CLS : Bar: CurRow% = 4: LOCATE 4, 1: PRINT Text$
                     Text$ = "": ShowCol% = 2
                     LOCATE CurRow%: COLOR 13: PRINT Text$
                  END IF
     CASE IS <> "":
                IF Ch$ <> CHR$(13) AND ShowCol% < 66 THEN
                                            Text$ = Text$ + Ch$
                                            ShowCol% = ShowCol% + 1
                                            COLOR 13
                                            LOCATE 2, 2: PRINT Text$
                END IF
               
     CASE CHR$(27): PRINT #1, "+++ATH": PRINT #1, "atz": RESET: EXIT SUB
    END SELECT

IF LOC(1) <> 0 THEN Inchar$ = INPUT$(1, #1) ELSE Inchar$ = ""

IF Inchar$ <> "" THEN
 SELECT CASE Inchar$
  CASE "þ": CLS : Bar: RInit: CurCol% = 1: CurRow% = 4
  CASE "๚": SendFile 0, Blank$: CLS : Bar: RInit: CurCol% = 1
  CASE ELSE:  LOCATE CurRow%, CurCol%
              IF Inchar$ <> CHR$(13) THEN
               CurCol% = CurCol% + 1
              END IF
              COLOR 14
              PRINT Inchar$
 END SELECT

 IF CurCol% = 80 THEN CurRow% = CurRow% + 1: CurCol% = 1
 IF CurRow% = 28 THEN CLS : Bar: CurRow% = 4
END IF
LOOP


END SUB

SUB ComunA
Comun$ = "COM" + CFG.COMPort + ":19200"
END SUB

SUB Config
CLS
COLOR 15
RESTORE ByteSaver
 PRINT "ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ"
FOR y% = 1 TO 2
 FOR t% = 1 TO 6
  READ A$
  PRINT A$
 NEXT
  IF y% = 1 THEN PRINT "ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต"
 NEXT
Slide 2, "'Little Bastard' Modem WarFare Configurations"
Slide 4, "To change your modem configuration, simply select the field you wish to"
Slide 5, "change and press Enter to toggle through the possible options. When you are"
Slide 6, "done, press Escape to save the options to disk and return to the menu, or"
Slide 7, "press the space bar to leave without saving your changes."
PrintStuff
High% = 1
PrintHStuff High%
NKy: aa$ = INKEY$: IF aa$ = "" THEN GOTO NKy

SELECT CASE aa$
 CASE CHR$(0) + "P": IF High% < 3 THEN High% = High% + 1 ELSE High% = 1
 CASE CHR$(0) + "H": IF High% > 1 THEN High% = High% - 1 ELSE High% = 3
 CASE CHR$(13): LOCATE Options(High%).VP, 2: PRINT SPACE$(61)
                IF Options(High%).Showing = 1 THEN Options(High%).Showing = 2 ELSE Options(High%).Showing = 1
 CASE CHR$(27): IF Options(1).Showing = 1 THEN CFG.COMPort = "1" ELSE CFG.COMPort = "2"
                IF Options(2).Showing = 1 THEN CFG.CW = "N" ELSE CFG.CW = "Y"
                IF Options(3).Showing = 1 THEN CFG.TP = "T" ELSE CFG.TP = "P"
                  OPEN "lbmwf.cfg" FOR RANDOM AS #2 LEN = LEN(CFG)
                   PUT #2, , CFG
                  CLOSE #2
                 EXIT SUB
 CASE " ": EXIT SUB
END SELECT

PrintStuff
PrintHStuff High%
GOTO NKy

END SUB

SUB Connect
  CLS
  COLOR 14
  Slide 2, "If you NEED to, press Escape to exit. That is not recommended."
  Slide 4, "Connected."
  DO
    Ch$ = INKEY$
    IF Ch$ = CHR$(27) THEN PRINT #1, "+++ATH": PRINT #1, "ATZ": EXIT SUB
    IF Ch$ <> "" THEN PRINT #1, Ch$;
    Ch$ = ""
    Guts
  LOOP
END SUB

SUB CStatus
CLS
COLOR 10
Slide 2, "Here's what we came up with for your options, just so you know:"
IF NoFind% = 1 THEN Slide 4, "Configuration file was not found!"
COLOR 12
Slide 6, "COM Port : " + CFG.COMPort
Slide 8, "(T)one or (P)ulse : " + CFG.TP
Slide 10, "Disable Call Waiting : " + CFG.CW
COLOR 10
Slide 20, "If any of these need to be changed, go to Configure from the main menu."
GetPress
END SUB

SUB delay (Seconds!) STATIC

   Begin! = TIMER
   DO UNTIL (TIMER - Begin! > Seconds!) OR (TIMER - Begin! < 0)
   LOOP

END SUB

SUB FindBook (N$)

ON ERROR GOTO NoBook
OPEN N$ FOR INPUT AS #2: CLOSE #2
ON ERROR GOTO 0

IF Nb% = -1 THEN
  OPEN N$ FOR BINARY AS #2
  FOR t% = 1 TO 15
   Phone(t%).Number = "000-0000"
   Phone(t%).Des = "<empty slot>"
   PUT #2, , Phone(t%).Number
   PUT #2, , Phone(t%).Des
  NEXT
  CLOSE #2
Nb% = 0
END IF

 OPEN N$ FOR BINARY AS #2
  FOR t% = 1 TO 15
   GET #2, , Phone(t%).Number
   GET #2, , Phone(t%).Des
  NEXT
 CLOSE #2
END SUB

FUNCTION Fixed$ (A$)
Fixed$ = LTRIM$(RTRIM$(LCASE$(A$)))
END FUNCTION

SUB FreeBase
CLS
COLOR 11
Slide 2, "Go ahead and type in commands. For example, typing ATZ will soft reset"
Slide 3, "your modem. Hit escape to Exit, enter to send a command"
COLOR 15
PRINT "                 = what you say"; : COLOR 13: PRINT " = what I say"; : COLOR 12: PRINT " = what modem says"
Total$ = ""
DO UNTIL Ty$ = CHR$(27)
Ty$ = INKEY$
 SELECT CASE Ty$
  CASE CHR$(8):
               IF POS(0) <> 1 THEN
                LOCATE , POS(0) - 1
                PRINT " ";
                LOCATE , POS(0) - 1
               ELSEIF POS(0) = 1 AND CSRLIN <> 1 THEN
                LOCATE CSRLIN - 1, 80
                PRINT " ";
               END IF
               IF LEN(Total$) > 1 THEN Total$ = LEFT$(Total$, LEN(Total$) - 1)

  CASE CHR$(13): PRINT #1, Total$: delay .45: COLOR 13: PRINT " sending " + Total$ + "...": Total$ = "": COLOR 15
  CASE IS <> "":
                   IF Ty$ <> CHR$(13) AND Ty$ <> CHR$(8) THEN
                                 PRINT Ty$; : Total$ = Total$ + Ty$
                   END IF
 END SELECT
 IF LOC(1) <> 0 THEN
  Inchar$ = INPUT$(1, 1)
   IF Inchar$ <> "" THEN
    COLOR 12: PRINT Inchar$; : COLOR 15
   END IF
 END IF
LOOP
END SUB

SUB GetHandle
CLS
COLOR 15
PRINT "ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ"
PRINT "ณ"; SPACE$(77); "ณ"
PRINT "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"
Slide 2, "What would you like to be called? (screen name -- limit 10 characters)"
LOCATE 4, 1
lnput Name$, 10, 4, 33
IF LEN(Name$) < 10 THEN Name$ = Name$ + SPACE$(10 - LEN(Name$)) ELSE Name$ = LEFT$(Name$, 10)
CLS
END SUB

SUB GetPress
DO: LOOP UNTIL INKEY$ <> ""
END SUB

SUB Guts
    IF LOC(1) <> 0 THEN Inchar$ = INPUT$(1, #1) ELSE Inchar$ = ""
    IF Inchar$ = CHR$(8) AND POS(0) <> 1 THEN
      LOCATE , POS(0) - 1
      PRINT " ";
      LOCATE , POS(0) - 1
    ELSEIF Inchar$ = CHR$(8) AND POS(0) = 1 AND CSRLIN <> 1 THEN
      LOCATE CSRLIN - 1, 80
      PRINT " ";
    ELSEIF Inchar$ = CHR$(8) THEN
    ELSEIF Inchar$ = CHR$(13) THEN
    ELSE PRINT Inchar$;
    END IF
    Inchar$ = ""
END SUB

SUB lnput (txt$, L%, Row%, Col%)
LOCATE Row%, Col%
COLOR 12
FOR Times% = 1 TO L%
 PRINT "_";
 NEXT
LOCATE Row%, Col%
COLOR 15
DO
ax$ = INKEY$
SELECT CASE ax$
 CASE CHR$(8):
               IF POS(0) <> 1 AND POS(0) > Col% THEN
                IF LEN(txt$) > 0 THEN txt$ = LEFT$(txt$, LEN(txt$) - 1)
                LOCATE , POS(0) - 1
                COLOR 12
                PRINT "_";
                COLOR 15
                LOCATE , POS(0) - 1
               END IF
 CASE CHR$(13): PRINT
                EXIT SUB
 CASE ELSE:
            IF LEN(txt$) < L% THEN
             txt$ = txt$ + ax$
             LOCATE , POS(0): PRINT ax$;
            END IF
END SELECT
LOOP
END SUB

SUB Menu (Array() AS OhMyGod)
Inky: aa$ = INKEY$: IF aa$ = "" THEN GOTO Inky
SELECT CASE aa$
 CASE CHR$(0) + "P": IF High% < UBOUND(Array) THEN High% = High% + 1 ELSE High% = 1
 CASE CHR$(0) + "H": IF High% > 1 THEN High% = High% - 1 ELSE High% = UBOUND(Array)
 CASE CHR$(13): RetVal% = High%: EXIT SUB
END SELECT
COLOR 13
PCOPY 1, 0
Slide Array(High%).VP, Array(High%).Text
GOTO Inky
END SUB

SUB OpenCOM
RESET
OPEN Comun$ + ", N,8,1,BIN,RB2048,TB2048" FOR RANDOM AS #1
PRINT #1, "ATZ"
END SUB

SUB PhoneBook (N$)
CLS
COLOR 15
PRINT "ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ"
PRINT "ณ               'Little Bastard' Modem WarFare Phone Book  #" + Fixed(STR$(Book%)) + "                 ณ"
PRINT "ฦออออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต"
FOR t% = 1 TO 15
 PRINT "ณ " + Phone(t%).Number + " ณ " + Phone(t%).Des + "ณ"
NEXT
PRINT "ฦออออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต"
PRINT "ณ Use the arrow keys to navigate. Press enter to edit an existing field. Hit  ณ"
PRINT "ณ 'D' to dial the highlighted number. Press 'S' to save phone book to disk.   ณ"
PRINT "ณ              Finally, press Escape to return to the main menu.              ณ"
PRINT "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"
HRow% = 1
HCol% = 1
PCOPY 0, 1
COLOR 13
LOCATE 4, 3: PRINT Phone(1).Number
Lable: aa$ = INKEY$: IF aa$ = "" THEN GOTO Lable

SELECT CASE UCASE$(aa$)
 CASE CHR$(0) + "K", CHR$(0) + "M": IF HRow% = 1 THEN HRow% = 2 ELSE HRow% = 1
 CASE CHR$(0) + "H": IF HCol% > 1 THEN HCol% = HCol% - 1 ELSE HCol% = 15
 CASE CHR$(0) + "P": IF HCol% < 15 THEN HCol% = HCol% + 1 ELSE HCol% = 1
 CASE CHR$(13):
                 IF HRow% = 1 THEN
                   L% = 14: Sz% = 3
                 ELSE
                   L% = 59: Sz% = 20
                 END IF
                 lnput Ret$, L%, HCol% + 3, Sz%
                 IF HRow% = 1 THEN
                  Phone(HCol%).Number = Ret$
                  LOCATE HCol% + 3, 3: PRINT Phone(HCol%).Number
                 ELSE
                  Phone(HCol%).Des = Ret$
                  LOCATE HCol% + 3, 20: PRINT Phone(HCol%).Des
                 END IF
                 PCOPY 0, 1
                 Ret$ = ""
 CASE "S":
           OPEN N$ FOR BINARY AS #2
            FOR t% = 1 TO 15
             PUT #2, , Phone(t%).Number
             PUT #2, , Phone(t%).Des
            NEXT
           CLOSE #2
 CASE "D":
          IF HRow% = 1 THEN
           IF CFG.CW = "Y" THEN Call$ = "*70," + Call$
           PRINT #1, "ATD" + CFG.TP + Phone(HCol%).Number
           WaitConnect 1
          END IF
 CASE CHR$(27): EXIT SUB
END SELECT

SELECT CASE HRow%
 CASE 1: COLOR 13
         PCOPY 1, 0
         LOCATE HCol% + 3, 3: PRINT Phone(HCol%).Number
 CASE 2: COLOR 13
         PCOPY 1, 0
         LOCATE HCol% + 3, 20: PRINT Phone(HCol%).Des
END SELECT

GOTO Lable

END SUB

SUB PrintHStuff (High%)
 COLOR 14
 Show$ = LTRIM$(RTRIM$(Options(High%).Text)) + " : " + RTRIM$(LTRIM$(DText(High%, Options(High%).Showing)))
 LOCATE Options(High%).VP, 41 - LEN(Show$) \ 2
 PRINT Show$
END SUB

SUB PrintStuff
COLOR 15
FOR Times% = 1 TO 3
 Show$ = LTRIM$(RTRIM$(Options(Times%).Text)) + " : " + RTRIM$(LTRIM$(DText(Times%, Options(Times%).Showing)))
 LOCATE Options(Times%).VP, 41 - LEN(Show$) \ 2: PRINT Show$
NEXT
END SUB

SUB ReadMe
CLS
COLOR 15
Slide 2, "All author info, registration info, and help is listed in the"
Slide 4, "file LBMWF.DOC. You have to read it!"
GetPress
END SUB

SUB RInit
Text$ = "": ShowCol% = 2
END SUB

SUB SendFile (Ajax%, Text$)
CLS

IF Ajax% = 0 THEN
  RFlag% = 0
   DO UNTIL FileISValid = 1
    INPUT "Receive what file: "; Rec$
    ON ERROR GOTO BRec
     OPEN Rec$ FOR BINARY AS #2: CLOSE #2
     KILL Rec$
     IF RFlag% = 0 THEN FileISValid = 1
    ON ERROR GOTO 0
   LOOP
  PRINT #1, ""
END IF

IF Ajax% = 1 THEN
 Name$ = MID$(Text$, 7, LEN(Text$))
 PRINT Name$
 END
 DO UNTIL Inchar$ = ""
  IF LOC(1) <> 0 THEN Inchar$ = INPUT$(1, 1)
 LOOP
END IF


CLS
IF Ajax% = 1 THEN PRINT "Sending : "; Name$
IF Ajax% = 0 THEN PRINT "Receiving file : "; Rec$
SELECT CASE Ajax%
 CASE 1: OPEN Name$ FOR BINARY AS #2
 CASE 0: OPEN Rec$ FOR BINARY AS #2
END SELECT

IF Ajax% = 1 THEN
           LOCATE 3, 1:
           PRINT "Bytes Sent : ";
           Bytes& = 1
           Leng& = LOF(2)
           b$ = STR$(LOF(2))
           PRINT #1, b$
           PRINT #1, ""
       DO UNTIL Inchar$ = ""
          IF LOC(1) <> 0 THEN
           Inchar$ = INPUT$(1, 1)
          END IF
       LOOP

   FOR Bytes& = 1 TO Leng& + 1
           GET #2, Bytes&, FileBuffer
           PUT #1, , FileBuffer
           LOCATE 3, 9: PRINT Bytes&
            FOR t# = 1 TO 5: NEXT t#
   NEXT
  CLOSE #2
END IF

IF Ajax% = 0 THEN
       DO UNTIL Inchar$ = ""
          IF LOC(1) <> 0 THEN
           Inchar$ = INPUT$(1, 1)
           Le$ = Le$ + Inchar$
          END IF
       LOOP
       PRINT #1, ""
       Length& = VAL(Le$)
       LOCATE 7, 1: PRINT "File Length: "; Length&
       LOCATE 3, 1:
       PRINT "Bytes Received : ";
       Bytes& = 1

 
  DO UNTIL Bytes& = Length& + 1
             IF LOC(1) <> 0 THEN
              GET #1, , RecBuffer
              PUT #2, Bytes&, RecBuffer
              Bytes& = Bytes& + 1
              LOCATE 3, 18: PRINT Bytes&
             END IF
  LOOP
 CLOSE #2
END IF

END SUB

SUB SendMessage (Max%)
SHARED CurRow%
CLS : Bar: CurRow% = 4: CurCol% = 1
COLOR 13
                                        FOR Times% = 1 TO Max%
                                         READ NText$
                                         PRINT #1, NText$ + CHR$(13)
                                         LOCATE CurRow%
                                         IF NText$ <> "þ" THEN PRINT NText$
                                         CurRow% = CurRow% + 1
                                         IF CurRow% = 29 THEN CLS : Bar: CurRow% = 4: LOCATE 4, 1: PRINT Text$
                                        NEXT
                                        RInit
END SUB

SUB Slide (Row%, Text$)
Text$ = LTRIM$(RTRIM$(Text$))
LOCATE Row%, 41 - INT(LEN(Text$) / 2): PRINT Text$
END SUB

SUB StarField
CLS
SCREEN 12
PALETTE 1, 1513239: PALETTE 2, 2170913: PALETTE 3, 2829099: PALETTE 4, 3487029: PALETTE 5, 4144959
DO UNTIL INKEY$ <> ""
 FOR t% = 1 TO 200
  PSET (S(t%).XPos, S(t%).YPos), 0
   S(t%).XPos = S(t%).XPos + S(t%).Speed
    IF S(t%).XPos >= 640 THEN S(t%).YPos = INT(RND * 480) + 1: S(t%).XPos = 0
  PSET (S(t%).XPos, S(t%).YPos), S(t%).Speed
 NEXT t%
LOOP
SCREEN 0
WIDTH 80
END SUB

SUB TurnOn
ON ERROR GOTO Check
CLS
COLOR 11
Slide 2, "You *MUST* turn on your modem right now! Hit any key when you are"
Slide 4, "ready. If I can't find it than you will be able to configure it."
Slide 6, "This process make take several moments, so don't worry."
GetPress
OpenCOM
END SUB

SUB WaitConnect (Ty%)
CLS
COLOR 15
PRINT "Waiting for Connection..."
Rot$ = "|"
Rot% = 0
DO UNTIL RIGHT$(Con$, 8) = "CONNECT " OR RIGHT$(Con$, 4) = "BUSY"
 LOCATE 1, 26: PRINT Rot$
  SELECT CASE Rot%
   CASE 1: Rot$ = "\"
   CASE 2: Rot$ = "-"
   CASE 3: Rot$ = "/"
   CASE 4: Rot$ = "|": Rot% = 0
  END SELECT
 Rot% = Rot% + 1
 aa$ = INKEY$
 delay .08
 IF aa$ = CHR$(27) THEN PRINT #1, "+++ATH": EXIT SUB
  IF LOC(1) <> 0 THEN
   M$ = INPUT$(1, 1)
   Con$ = Con$ + M$
  END IF
LOOP
IF RIGHT$(Con$, 4) = "BUSY" THEN EXIT SUB
bps$ = "1"
DO UNTIL VAL(bps$) = 0
  IF LOC(1) <> 0 THEN bps$ = INPUT$(1, 1)
LOOP
DO UNTIL bps$ <> "0"
 IF LOC(1) <> 0 THEN bps$ = INPUT$(1, 1)
LOOP
IF Ty% = 1 THEN Connect ELSE Chat
END SUB

