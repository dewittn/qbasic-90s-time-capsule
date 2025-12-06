REM                            Instructions
REM                                for
REM                        The Biotech Institute
REM                            Version 1.2
REM              
REM    This program was originally created for my biology semester
REM    project. Keep in mind I thought of the program first
REM    and the story later. OK here's the story (don't laugh): Your father
REM    works at this place called the Biotech Institute. Somehow, you were
REM    forgotten and left after the lights were turned out. With your trusty
REM    flashlight and piece of paper for a map, you are determined to find
REM    your way out in time for dinner. As this is a biology project, you
REM    may be wondering where biology comes into all this. It just so happens
REM    there are a great many doors in the building. Since everyone who works
REM    in the building has at least a masters degree in biological chemistry,
REM    botany, and stuff like that, you are required to answer a biology
REM    question to get through each door, (it's what they call security).
REM    To add a little challenge in case you think the questions are
REM    too easy (you probably won't have that opinion after playing the
REM    game for a little while) some of the doors require a passcard.
REM    The passcards, which are numbered, are scattered around
REM    on the floor here and there. Some of them you will be able to see
REM    before you pick them up. Others will be right on the other side of a
REM    door. So be sure to check the bottom of the screen for messages. Now
REM    it's time to move on to playing the game. The arrow keys are used
REM    for moving around, (if you are using the ten key pad be sure
REM    the num lock is off). The up and down keys move you forward and
REM    backward correspondingly, while the left and right keys
REM    rotate you in one spot. The controls will take a bit of getting
REM    used to. Pay attention! this is an important function!
REM    A map of where you have been (or rather where you have looked)
REM    will be displayed when you press the "m" button. On the map you are
REM    represented by a plus sign in one of the squares. The elevators
REM    (of course there are elevators) are shown as x's on the map. Please
REM    note that the doors are not displayed on the map. Just so you know,
REM    north is up on the map (the direction you are facing is shown at
REM    the bottom of the normal screen). The next command is the inventory
REM    command. Press "i" to see a list of the passcards you are carrying. You
REM    can save your game by pressing the "s" button. Your game will be saved
REM    in a text file which will be placed in the file where your running
REM    directory is located. Pressing "l" will prompt you to enter the name of
REM    the file to be loaded. The last option is the "quit" option which is
REM    used if you want to stop before finishing the game. Press "q" to be
REM    asked if you want to quit. This can also be used to "pause" the game
REM    since time stops until you answer. Time also stops during questions,
REM    which are all multi-choice. The clock is ticking for the rest
REM    of the time. If you are wondering what time has to do with the
REM    game, I'll let you know that one of the points given at the end
REM    of the game has to do with your time. The percentage of
REM    questions you got right is also displayed at the end of the game.
REM    All computers are not created equal, and your computer is probably
REM    not the same speed as my computer(an Intel 486sx). To acomadate for
REM    this, I have added a wait adjustment option. Press "w" to
REM    pick the speed that suits you best. For instance, the "slow"
REM    speed would best suit a Pentium or similar computer.
REM    Any other commands will be explained when the time comes to
REM    use them. One hint: messages on the walls won't be displayed
REM    normally. You have to get really close to see them. Feel free to look
REM    through the program listing and examine the notes on routines, but
REM    please don't alter the program or look at the last bunch of data
REM    (Looking at the questions and answers is considered cheating!)
REM    If you have any questions, suggestions for improvments, or just
REM    want to let me know that you liked the game, send E-mail to David at
REM    pvhsa07@ll.kcts.org . Good luck, and watch out for Grendel.
REM
REM                          Press F5 to start.




REM    The Biotech Institute written by David Carlton in Qbasic. David is
REM      twelve years old and lives in Seattle, WA. He is interested in
REM                computer programming as a profession.
REM
REM                                 VVV
REM                                 VVV
REM                                 VVV
REM                               VVVVVVV
REM                                 \V/




REM opening

ON ERROR GOTO 5250
SCREEN 12: SCREEN 0: COLOR 7
FOR i = 1 TO 10: PRINT : NEXT i
PRINT TAB(27); "The Biotech Institute": PRINT TAB(29); "By David Carlton": FOR i = 1 TO 10000: NEXT i

REM initialization

DIM w(4): DIM r(3): DIM rs(3): DIM rr(4, 6, 6): DIM q$(40): DIM qa(40): DIM pc(7): DIM rb(4, 6, 6): DIM qc(4): DIM qf(4)
r(1) = 2: r(2) = 1: r(3) = 1: d = 2: pr = 1: w = 1
FOR i = 1 TO 4
FOR j = 1 TO 6
FOR k = 1 TO 6
READ rr(i, k, j)
NEXT k
NEXT j
NEXT i
FOR i = 1 TO 40
READ q$(i): READ qa(i)
NEXT i

REM call to graphics routine

100 SCREEN 1: SCREEN 12
GOSUB 1000
rs(1) = r(1): rs(2) = r(2): rs(3) = r(3):  VIEW PRINT (27) TO (30)
GOSUB 5000

REM passcard, elevator, and item check

rb(r(1), r(2), r(3)) = 1
rt = rr(r(1), r(2), r(3))
IF rt = rr(2, 2, 2) OR rt = rr(2, 5, 2) OR rt = rr(2, 5, 5) OR rt = rr(2, 1, 6) THEN IF jr <> 1 THEN PRINT "elevator up": jr = 1: r(1) = r(1) + 1: FOR i = 1 TO 10000 * w: NEXT i: GOTO 100
IF rt = rr(2, 5, 6) OR rt = rr(1, 3, 4) OR rt = rr(1, 4, 6) OR rt = rr(3, 1, 5) THEN IF jr <> 1 THEN PRINT "elevator up": r(1) = r(1) + 1: jr = 1: FOR i = 1 TO 10000 * w: NEXT i: GOTO 100
IF rt = rr(2, 3, 4) OR rt = rr(2, 4, 6) OR rt = rr(3, 2, 2) OR rt = rr(3, 5, 2) THEN IF jr <> 1 THEN PRINT "elevator down": r(1) = r(1) - 1: jr = 1: FOR i = 1 TO 10000 * w: NEXT i: GOTO 100
IF rt = rr(3, 5, 5) OR rt = rr(3, 1, 6) OR rt = rr(3, 5, 6) OR rt = rr(4, 1, 5) THEN IF jr <> 1 THEN PRINT "elevator down": jr = 1: FOR i = 1 TO 10000 * w: NEXT i: GOTO 100
IF rt = rr(2, 2, 4) AND pc(1) <> 1 THEN PRINT "You picked up passcard 1": pc(1) = 1: rr(2, 2, 4) = rr(2, 2, 4) - 4096
IF rt = rr(1, 2, 6) AND pc(2) <> 1 THEN PRINT "You picked up passcard 2": pc(2) = 1: rr(1, 2, 6) = rr(1, 2, 6) - 4096
IF rt = rr(1, 3, 1) AND pc(3) <> 1 THEN PRINT "You picked up passcard 3": pc(3) = 1: rr(1, 3, 1) = rr(1, 3, 1) - 4096
IF rt = rr(3, 1, 2) AND pc(4) <> 1 THEN PRINT "You picked up passcard 4": pc(4) = 1: pr = 2: rr(3, 1, 2) = rr(3, 1, 2) - 4096
IF r(1) = 3 AND r(2) = 1 AND r(3) = 4 AND pc(5) <> 1 THEN PRINT "You picked up passcard 5": pc(5) = 1: rr(3, 1, 4) = rr(3, 1, 4) - 4096
IF rt = rr(4, 6, 4) AND pc(6) <> 1 THEN PRINT "You picked up passcard 6": pc(6) = 1: rr(4, 6, 4) = rr(4, 6, 4) - 4096
IF r(1) = 2 AND r(2) = 3 AND r(3) = 5 AND pc(7) <> 1 THEN PRINT "You picked up passcard 7": pc(7) = 1: rr(2, 3, 5) = rr(2, 3, 5) - 4096
IF r(1) = 1 AND r(2) = 2 AND r(3) = 5 AND d = 2 THEN PRINT "There is a map of level 2 on the wall. Press G to glance at it."
IF r(1) = 4 AND r(2) = 1 AND r(3) = 5 THEN pr = 3
IF r(1) = 4 AND r(2) = 6 AND r(3) = 6 THEN SCREEN 0: COLOR 7: PRINT "Yeah! You made it out.": GOTO 5500

REM playing screen setup

PRINT "level "; r(1); "  "; r(2); ","; r(3); "   ";
IF d = 1 THEN PRINT "north";
IF d = 2 THEN PRINT "east";
IF d = 3 THEN PRINT "south";
IF d = 4 THEN PRINT "west";
PRINT "    What now?"

REM keyboard check

105 in$ = INKEY$
IF RIGHT$(in$, 1) = CHR$(72) OR RIGHT$(in$, 1) = CHR$(80) THEN GOTO 155
IF RIGHT$(in$, 1) = CHR$(77) THEN d = d + 1: IF d = 5 THEN d = 1
IF RIGHT$(in$, 1) = CHR$(75) THEN d = d - 1: IF d = 0 THEN d = 4
IF RIGHT$(in$, 1) = CHR$(77) OR RIGHT$(in$, 1) = CHR$(75) THEN GOTO 100
IF in$ = "g" AND r(1) = 1 AND r(2) = 2 AND r(3) = 5 AND d = 2 THEN PRINT "I~~~~~~~~~~~I": m = 1: FOR i = 1 TO 100: NEXT i
IF in$ = "g" AND r(1) = 1 AND r(2) = 2 AND r(3) = 5 AND d = 2 THEN PRINT "I I~I I~~~I I": FOR i = 1 TO 1000 * w: NEXT i
IF in$ = "g" AND r(1) = 1 AND r(2) = 2 AND r(3) = 5 AND d = 2 THEN PRINT "I I   I  ~~ I": FOR i = 1 TO 1000 * w: NEXT i
IF in$ = "g" AND r(1) = 1 AND r(2) = 2 AND r(3) = 5 AND d = 2 THEN PRINT "I ~~I~~ I~~~~": FOR i = 1 TO 1000 * w: NEXT i
IF in$ = "g" AND r(1) = 1 AND r(2) = 2 AND r(3) = 5 AND d = 2 THEN PRINT "I___I~~~~": PRINT "What now?"
IF in$ = "i" THEN GOSUB 144
IF in$ = "m" THEN GOTO 3000
IF in$ = "l" THEN INPUT "Are you sure you want to load a different game?(y or n)"; in$: IF in$ = "y" THEN GOTO 5300 ELSE PRINT "What now?"
IF in$ = "s" THEN INPUT "Are you sure you want to save this game?(y or n)"; in$: IF in$ = "y" THEN GOSUB 5200 ELSE PRINT "What now?"
IF in$ = "w" THEN INPUT "What waiting interval would you like?(1)fast (2)normal (3)slow"; in: ON in GOTO 130, 131, 132
IF in$ = "q" THEN INPUT "Are you sure you want to quit?(y or n)"; in$: IF in$ = "y" THEN PRINT "Bye!": PRINT : PRINT : END ELSE PRINT "What now?"
t = t + 1 * w
GOTO 105

REM wait set routine

130 w = .1: GOTO 133
131 w = 1: GOTO 133
132 w = 3: GOTO 133
133 PRINT "What now?": GOTO 105

REM inventory routine

144 PRINT "You are carrying passcard(s): ";
IF pc(1) = 1 THEN PRINT "1 ";
IF pc(2) = 1 THEN PRINT "2 ";
IF pc(3) = 1 THEN PRINT "3 ";
IF pc(4) = 1 THEN PRINT "4 ";
IF pc(5) = 1 THEN PRINT "5 ";
IF pc(6) = 1 THEN PRINT "6 ";
IF pc(7) = 1 THEN PRINT "7 ";
PRINT : PRINT "What now?": RETURN

REM locked door check

145 lk = 0: na = 0
IF r(1) = 3 AND r(2) = 2 AND r(3) = 3 AND wd = 2 OR r(1) = 3 AND r(2) = 3 AND r(3) = 3 AND wd = 4 OR r(1) = 3 AND r(2) = 3 AND r(3) = 4 AND wd = 2 THEN IF pc(1) = 1 THEN lk = 1 ELSE na = 1
IF r(1) = 3 AND r(2) = 4 AND r(3) = 4 AND wd = 4 OR r(1) = 3 AND r(2) = 5 AND r(3) = 4 AND wd = 2 OR r(1) = 3 AND r(2) = 6 AND r(3) = 4 AND wd = 4 THEN IF pc(1) = 1 THEN lk = 1 ELSE na = 1
IF r(1) = 3 AND r(2) = 2 AND r(3) = 4 AND wd = 4 OR r(1) = 3 AND r(2) = 1 AND r(3) = 4 AND wd = 2 THEN IF pc(2) = 1 THEN lk = 1 ELSE na = 2
IF r(1) = 3 AND r(2) = 1 AND r(3) = 3 AND wd = 1 OR r(1) = 3 AND r(2) = 1 AND r(3) = 2 AND wd = 3 OR r(1) = 3 AND r(2) = 3 AND r(3) = 4 AND wd = 4 OR r(1) = 3 AND r(2) = 2 AND r(3) = 4 AND wd = 2 OR r(1) = 3 AND r(2) = 5 AND r(3) = 3 AND wd = 4 OR r(1) = 3 AND r(2) = 4 AND r(3) = 3 AND wd = 2 OR r(1) = 3 AND r(2) = 6 AND r(3) = 3 AND wd = 1 OR r(1) = 3 AND r(2) = 6 AND r(3) = 2 AND d = 3 THEN IF pc(3) = 1 THEN lk = 1 ELSE na = 3
IF r(1) = 1 AND r(2) = 1 AND r(3) = 4 AND wd = 3 OR r(1) = 1 AND r(2) = 1 AND r(3) = 5 AND wd = 1 THEN IF pc(4) = 1 THEN lk = 1 ELSE na = 4
IF r(1) = 1 AND r(2) = 3 AND r(3) = 6 AND wd = 2 OR r(1) = 1 AND r(2) = 4 AND r(3) = 6 AND wd = 4 THEN IF pc(5) = 1 THEN lk = 1 ELSE na = 5
IF r(1) = 2 AND r(2) = 4 AND r(3) = 5 AND wd = 4 OR r(1) = 2 AND r(2) = 3 AND r(3) = 5 AND wd = 2 OR r(1) = 4 AND r(2) = 3 AND r(3) = 4 AND wd = 2 OR r(1) = 4 AND r(2) = 4 AND r(3) = 4 AND wd = 4 OR r(1) = 4 AND r(2) = 4 AND r(3) = 6 AND wd = 2 OR r(1) = 4 AND r(2) = 5 AND r(3) = 6 AND wd = 4 THEN IF pc(6) = 1 THEN lk = 1 ELSE na = 6
IF r(1) = 4 AND r(2) = 6 AND r(3) = 5 AND wd = 3 THEN IF pc(7) = 1 THEN lk = 1 ELSE na = 7
IF na <> 0 THEN PRINT "Access denied. Passcard"; na; "required": PRINT "What now?"
RETURN

REM question routine

150 rn = INT(t / 14)
151 IF rn > 40 THEN rn = INT(rn - 40): GOTO 151
PRINT q$(rn); : INPUT aw: IF rn = 21 THEN qc(pr) = qc(pr) + 1: qc(4) = qc(4) + 1: w(wd) = 0: PRINT "What now?": RETURN
IF aw = qa(rn) THEN w(wd) = 0: qc(pr) = qc(pr) + 1: qc(4) = qc(4) + 1: PRINT "What now?": RETURN
qf(pr) = qf(pr) + 1: qf(4) = qf(4) + 1: qc(pr) = qc(pr) + 1: qc(4) = qc(4) + 1
PRINT "Nope.": PRINT "What now?": RETURN

REM moving routine

155  IF RIGHT$(in$, 1) = CHR$(80) THEN wd = d + 2: IF wd > 4 THEN wd = wd - 4
IF RIGHT$(in$, 1) = CHR$(72) THEN wd = d
IF w(wd) = 1 THEN PRINT "There's a wall in the way": PRINT "What now?"
IF w(wd) = 2 THEN GOSUB 150: IF w(wd) = 2 THEN GOTO 105
IF w(wd) = 3 THEN GOSUB 145: IF lk = 1 THEN GOSUB 150: IF w(wd) = 3 THEN GOTO 105
IF w(wd) <> 0 THEN GOTO 105
jr = 0
IF wd = 1 THEN r(3) = r(3) - 1: GOTO 100
IF wd = 2 THEN r(2) = r(2) + 1: GOTO 100
IF wd = 3 THEN r(3) = r(3) + 1: GOTO 100
IF wd = 4 THEN r(2) = r(2) - 1: GOTO 100

REM graphics routine

1000 rd = 0: rs(1) = r(1): rs(2) = r(2): rs(3) = r(3): COLOR r(1): GOSUB 5000
x5 = 0: y5 = 0: x6 = 400: y6 = 0: x7 = 400: y7 = 400: x8 = 0: y8 = 400: cx = 200: cy = 200
IF w(d) = 1 THEN GOSUB 2000: RETURN
IF w(d) = 2 OR w(d) = 3 THEN GOSUB 2500: RETURN
x1 = 0: y1 = 0: x2 = 400: y2 = 0: x3 = 400: y3 = 400: x4 = 0: y4 = 400: x5 = 100: y5 = 100: x6 = 300: y6 = 100: x7 = 300: y7 = 300: x8 = 100: y8 = 300
1500 rd = rd + 1: IF d = 1 THEN rs(3) = r(3) - rd
IF d = 2 THEN rs(2) = r(2) + rd
IF d = 3 THEN rs(3) = r(3) + rd
IF d = 4 THEN rs(2) = r(2) - rd
GOSUB 5000: rb(rs(1), rs(2), rs(3)) = 1
IF sp = 1 THEN GOSUB 2900
wd = d - 1: IF wd = 0 THEN wd = 4
IF w(wd) = 1 THEN GOSUB 2100
IF w(wd) = 2 OR w(wd) = 3 THEN GOSUB 2600
wd = d + 1: IF wd = 5 THEN wd = 1
IF w(wd) = 1 THEN GOSUB 2200
IF w(wd) = 2 OR w(wd) = 3 THEN GOSUB 2700
IF sp = 1 THEN GOSUB 2900
IF w(d) = 1 THEN GOSUB 2000: RETURN
IF w(d) = 2 OR w(d) = 3 THEN GOSUB 2500: RETURN
IF rd = 7 THEN RETURN
x1 = x5: y1 = y5: x2 = x6: y2 = y6: x3 = x7: y3 = y7: x4 = x8: y4 = y8
x5 = INT(((cx - x1) / 2) + x1): y5 = (((cy - y1) / 2) + y1): x6 = INT(((x2 - cx) / 2) + cx): y6 = INT(((cy - y2) / 2) + y2)
x7 = INT(((x3 - cx) / 2) + cx): y7 = INT(((y3 - cy) / 2) + cy): x8 = INT(((cx - x4) / 2) + x4): y8 = INT(((y4 - cy) / 2) + cy)
GOTO 1500
2000 LINE (x5, y5)-(x6, y6): LINE (x6, y6)-(x7, y7): LINE (x7, y7)-(x8, y8): LINE (x8, y8)-(x5, y5): RETURN
2100 LINE (x1, y1)-(x5, y5): LINE (x5, y5)-(x8, y8): LINE (x8, y8)-(x4, y4): LINE (x4, y4)-(x1, y1): RETURN
2200 LINE (x6, y6)-(x2, y2): LINE (x2, y2)-(x3, y3): LINE (x3, y3)-(x7, y7): LINE (x7, y7)-(x6, y6): RETURN
2500 LINE (x5, y5)-(INT(((cx - x5) / 2) + x5), y5): LINE (INT(((cx - x5) / 2) + x5), y5)-(INT(((cx - x8) / 2) + x8), y8): LINE (INT(((cx - x8) / 2) + x8), y8)-(x8, y8): LINE (x8, y8)-(x5, y5)
LINE (x6, y6)-(INT(((x6 - cx) / 2) + cx), y6): LINE (INT(((x6 - cx) / 2) + cx), y6)-(INT(((x7 - cx) / 2) + cx), y7): LINE (INT(((x7 - cx) / 2) + cx), y7)-(x7, y7): LINE (x7, y7)-(x6, y6): RETURN
2600 LINE (x1, y1)-(INT(((x5 - x1) / 4) + x1), INT(((y5 - y1) / 4) + x1)): LINE (INT(((x5 - x1) / 4) + x1), INT(((y5 - y1) / 4) + x1))-(INT(((x8 - x4) / 4) + x4), INT((((y4 - y8) / 4) * 3) + y8))
LINE (INT(((x8 - x4) / 4) + x4), INT((((y4 - y8) / 4) * 3) + y8))-(x4, y4): LINE (x4, y4)-(x1, y1)
LINE (INT((((x5 - x1) / 4) * 3) + x1), INT((((y5 - y1) / 4) * 3) + x1))-(x5, y5): LINE (x5, y5)-(x8, y8)
LINE (x8, y8)-(INT((((x8 - x4) / 4) * 3) + x4), INT(((y4 - y8) / 4) + y8)): LINE (INT((((x8 - x4) / 4) * 3) + x4), INT(((y4 - y8) / 4) + y8))-(INT((((x5 - x1) / 4) * 3) + x1), INT((((y5 - y1) / 4) * 3) + y1)): RETURN
2700 LINE (x6, y6)-(INT(((x2 - x6) / 4) + x6), INT((((y6 - y2) / 4) * 3) + y2)): LINE (INT(((x2 - x6) / 4) + x6), INT((((y6 - y2) / 4) * 3) + y2))-(INT(((x3 - x7) / 4) + x7), INT(((y3 - y7) / 4) + y7))
LINE (INT(((x3 - x7) / 4) + x7), INT(((y3 - y7) / 4) + y7))-(x7, y7): LINE (x7, y7)-(x6, y6)
LINE (x2, y2)-(x3, y3): LINE (x3, y3)-(INT((((x3 - x7) / 4) * 3) + x7), INT((((y3 - y7) / 4) * 3) + y7))
LINE (INT((((x3 - x7) / 4) * 3) + x7), INT((((y3 - y7) / 4) * 3) + y7))-(INT((((x2 - x6) / 4) * 3) + x6), INT(((y6 - y2) / 4) + y2)): LINE (INT((((x2 - x6) / 4) * 3) + x6), INT(((y6 - y2) / 4) + y2))-(x2, y2): RETURN
2900 LINE (INT((((cx - x8) / 4) * 3) + x8), INT(((y4 - y8) / 3) + y8))-(INT(((x7 - cx) / 4) + cx), INT(((y4 - y8) / 3) + y8)): LINE (INT(((x7 - cx) / 4) + cx), INT(((y4 - y8) / 3) + y8))-(INT(((x7 - cx) / 2) + cx), INT(((y3 - y7) / 2) + y7))
LINE (INT(((x7 - cx) / 2) + cx), INT(((y3 - y7) / 2) + y7))-(INT(((cx - x8) / 2) + x8), INT(((y4 - y7) / 2) + y7)): LINE (INT(((cx - x8) / 2) + x8), INT(((y4 - y7) / 2) + y7))-(INT((((cx - x8) / 4) * 3) + x8), INT(((y4 - y8) / 3) + y8)): RETURN

REM map routine

3000 SCREEN 1: SCREEN 12
x1 = 0: y1 = 0: x2 = 50: y2 = 0: x3 = 50: y3 = 50: x4 = 0: y4 = 50: COLOR r(1)
FOR i = 1 TO 6
FOR j = 1 TO 6
IF j = r(2) AND i = r(3) THEN LINE (25 + x1, y1)-(25 + x1, y4): LINE (x1, 25 + y1)-(x2, 25 + y1)
IF rb(r(1), j, i) <> 1 THEN GOTO 3010
rs(1) = r(1): rs(2) = j: rs(3) = i: GOSUB 5000
IF w(1) = 1 THEN LINE (x1, y1)-(x2, y2)
IF w(2) = 1 THEN LINE (x2, y2)-(x3, y3)
IF w(3) = 1 THEN LINE (x4, y4)-(x3, y3)
IF w(4) = 1 THEN LINE (x1, y1)-(x4, y4)
IF sp = 2 OR sp = 3 THEN LINE (x1, y1)-(x3, y3): LINE (x2, y2)-(x4, y4)
3010 x1 = x2: x4 = x3: x2 = x2 + 50: x3 = x3 + 50
NEXT j
x1 = 0: x2 = 50: x3 = 50: x4 = 0: y1 = y4: y2 = y3: y4 = y4 + 50: y3 = y3 + 50
NEXT i
FOR i = 1 TO 19: PRINT : NEXT i: PRINT "Press any key."
3020 in$ = INKEY$
IF in$ <> "" THEN GOTO 100
t = t + 1 * w
GOTO 3020

REM data reading routine

5000 s = rr(rs(1), rs(2), rs(3))
sp = INT(s / 4096)
s = s - (sp * 4096)
w(1) = INT(s / 512)
s = s - (w(1) * 512)
w(2) = INT(s / 64)
s = s - (w(2) * 64)
w(3) = INT(s / 8)
s = s - (w(3) * 8)
w(4) = INT(s)
RETURN

REM save/load routine

5200 INPUT "What name do you want to give the file"; n$
OPEN n$ FOR OUTPUT AS #1
PRINT #1, pr, d, m, t, jr, w, r(1), r(2), r(3)
FOR i = 1 TO 7
PRINT #1, pc(i)
NEXT i
FOR i = 1 TO 4
PRINT #1, qc(i), qf(i)
NEXT i
FOR i = 1 TO 4
FOR j = 1 TO 6
FOR k = 1 TO 6
PRINT #1, rr(i, j, k), rb(i, j, k)
NEXT k
NEXT j
NEXT i
CLOSE
PRINT "What now?"
RETURN
5250 PRINT "I couldn't find that file.": PRINT "What now?": RESUME 105
5300 INPUT "What file do you want to load"; n$
OPEN n$ FOR INPUT AS #1
INPUT #1, pr, d, m, t, jr, w, r(1), r(2), r(3)
FOR i = 1 TO 7
INPUT #1, pc(i)
NEXT i
FOR i = 1 TO 4
INPUT #1, qc(i), qf(i)
NEXT i
FOR i = 1 TO 4
FOR j = 1 TO 6
FOR k = 1 TO 6
INPUT #1, rr(i, j, k), rb(i, j, k)
NEXT k
NEXT j
NEXT i
CLOSE
GOTO 100

REM endgame routine

5500 PRINT "You got"; (INT(((qc(1) - qf(1)) * 100) / qc(1))); "% of the questions right in the first part of the game."
PRINT "You got"; (INT(((qc(2) - qf(2)) * 100) / qc(2))); "% of the questions right in the middle section of the game."
PRINT "You got"; (INT(((qc(3) - qf(3)) * 100) / qc(3))); "% of the questions right in the final third of the game."
PRINT "You got"; (INT(((qc(4) - qf(4)) * 100) / qc(4))); "% of the questions right total."
s = 0
IF m = 1 THEN s = s + 1
IF qf(4) = 0 THEN s = s + 1
IF t <= 30000 THEN s = s + 1
IF s = 3 THEN PRINT "You're a real maze master now, and you learned plenty of biology facts along theway!": END
PRINT "Your score was"; s; ". The best possible score is 3.": PRINT "Don't feel bad if you didn't get any points.": PRINT "They're only for ambitious people who want to do the best possible.": END

REM room data

DATA 641,578,4745,522,648,578,65,65,513,528,584,65,81,9,72,1025,576,65,1049,576,8713,0,128,74,1601,73,641,10,80,577,9,4680,201,8779,1033,72
DATA 513,520,512,520,520,576,65,8769,65,513,8776,65,65,137,74,1,520,72,1,4672,12809,72,593,593,9,72,4745,651,9290,1089,8841,522,520,12872,8713,72
DATA 649,522,528,576,521,592,4697,12809,1088,73,12865,1113,1545,712,75,713,67,1601,4809,715,715,651,202,67,8713,520,512,520,12872,65,12809,520,8,520,12872,73
DATA 513,648,522,592,529,592,17,584,521,1096,1105,1089,1089,641,522,648,1098,65,137,66,705,651,586,4169,12865,129,82,649,642,602,9,72,1161,714,75,1609

REM  DON'T LOOK AT THESE! THEY'RE THE QUESTIONS AND ANSWERS!

DATA "Which plant is NOT an example of a vegetativly propigating plant?(1)dandelion   (2)strawberry (3)potato (4)tulip",1,"Which type of plant germinates with the seed above ground?(1)monocot (2)dicot   (3)nonvascular (4)fibrous root plants",2,"What is the name of a new growth on a fern(1)fernling (2)frond (3)endosperm     (4)fiddlehead",4,"What is the underground part of the fern called?(1)sorus (2)root (3)rhizome     (4)internode",3,"What are the brown dots on the underside of a fern blade called?(1)spores       (2)sori (3)sporangia (4)zygotes",2
DATA "What is a dicotyledone characteristic?(1)roots are usually fibrous              (2)seeds contain one cotyledon (3)flower parts usually occur in multiples of    four or five (4)leaves have parallel veins",3,"What is a cotyledon?(1)a plant with one seed leaf (2)a plant with two seed      leaves (3)the seed leaf of a plant (4)a plant that has its seeds enclosed",3,"What type of venation is NOT common with dicots?(1)palmate (2)pinnate           (3)palisade (4)parallel" ,4,"What is the name for the center part of a woody stem?(1)pith (2)vascular        cambium (3)inner bark (4)cortex",1,"What is the name of the matter between the cork and the cortex of a woody stem? (1)bark (2)cork cambium (3)inner bark (4)phloem",2
DATA "What is the end of a root called?(1)epidermis (2)zone of maturation (3)sepal    (4)apical meristem",4,"What is the middle section of a root called?(1)zone of maturation (2)zone of    elongation (3)root hairs (4)apical meristem",2,"What is the part of the root closest to the plant body called?(1)zone of        maturation (2)apical meristem (3)style (4)root hairs",1,"Does David have to do his Shakespear assignment?(1)yes (2)no (3)maybe (4)wait a while",1,"What is the surface of the tip of a root called?(1)cork (2)cambium (3)root cap  (4)anther",3
DATA "What is(are) on the surface of the part of the root closest to the plant body?  (1)cambium (2)filaments (3)root cap (4)root hairs",4,"What are the individual leaves on the buds of a flower called?(1)petals (2)bud  leaves (3)pistils (4)sepals",4,"What is the end bud on a woody stem called?(1)terminal bud (2)lateral bud       (3)node (4)bud scale",1,"Which is the closest to the outside of a woody stem?(1)pith (2)phloem           (3)vascular cambium (4)vascular ray",2,"Which is closest to the center of a woody stem?(1)cork cambium (2)cork          (3)cortex (4)inner bark",3
DATA "Should David get an A on this project?(1)yes (2)of course (3)why certainly      (4)who would give him anything else",4,"Which plant group is a walnut tree in?(1)Rosaceae (2)Compositae                 (3)Juglandaceae (4)Aceraceae",3,"Which plant group does the banana belong to?(1)Gramineae (2)Rosaceae            (3)Iridaceae (4)Musaceae",4,"Which plant group does the maple belong to?(1)Aceraceae (2)Palmaceae            (3)Fabaceae (4)Solanaceae",1,"Which plant group does the tomato belong to?(1)Rosaceae (2)Solanaceae           (3)Cactaceae (4)Iridaceae",2,"Which plant group does the pea belong to?(1)Juglandaceae (2)Fabaceae            (3)Aceraceae (4)Palmaceae",2
DATA "Which group name is the most specific?(1)the phylum (2)the order (3)the kingdom (4)the family",4,"What part of the flower does the fruit come from?(1)ovary (2)style (3)ovule (4) pistil",1,"Which part of a woody stem's vascular system carries water and minerals from    the roots to the leaves?(1)phloem (2)cambium (3)xylem (4)vascular cambium",3,"What is an endosperm?(1)a plant with exposed seeds (2)the seed leaf of a plant  (3)a plant that makes reproductive cells (4)the food stored in the seed of a    plant",4
DATA "Which part of a woody stem's vascular system carries food manufactured in the   leaf to other parts of the plant?(1)phloem (2)vascular cambium (3)pith (4)xylem",1,"Which part of the leaf regulates the flow of gases?(1)palisade parenchyma       (2)stomata (3)guard cells (4) cuticle",3,"What is the chemical formula for photosynthesis?(1)energy+o6=h2o7+co2 (2)       6co2+12h20+energy=c6h12o6+6h2o+6o2 (3)h13+h6o9c4+energy=12h2o+o9+co2+ho10 (4)   h2o+energy=h2+o",2,"What type of venation does the Bigleaf Maple have?(1)palmate (2)whorled         (3)parrallel (4)pinnate",1,"What type of venation does a blade of grass have?(1)palmate (2)whorled (3)      pinnate (4)parrallel",4
DATA "What type of venation does a Pacific Dogwood have?(1)palmate (2)whorled (3)     pinnate (4)parrallel",3,"What is contained in each pollen grain?(1)sporangium (2)sporophyte (3)gamete (4)egg",3,"How many different species of plants are there in the phylum Anthophyta?(1)     12,000 (2)700 (3)1,750 (4)250,000",4,"Which one of these is a monocot characteristic?(1)leaves have netted veins      (2)flower parts usually occur in three's or six's (3)roots are usually taproots (4)young stems have vascular bundles in a ring",2,"What are the small cuplike structures on a liverwort called?(1)gemma cups (2)   gametophytes (3)gemmae (4)rhizoids",1

