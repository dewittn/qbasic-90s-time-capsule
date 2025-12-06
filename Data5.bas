' run qb, load this program, then load sbtalker driver in high mem
CONST names = 36
CONST when = 16
CONST what = 55
CONST where = 20
CLS
RANDOMIZE TIMER
DO
IF INKEY$ = CHR$(27) THEN END
CLS
RESTORE
1 d = INT(RND(1) * 20) + 1
e = INT(RND(1) * 28) + 1
2 f = INT(RND * 15) + 1
IF f = 16 THEN 2
                        a = INT(RND(1) * names) + 1
IF a = 0 THEN 1
FOR bloop = 1 TO a
IF INKEY$ = CHR$(27) THEN END
READ text$
IF bloop = a THEN
LOCATE 9, 1
COLOR f
PRINT text$; " ";
END IF
NEXT bloop
RESTORE
                        b = INT(RND(names + 1) * when) + (names + 1)
FOR bloopx = 1 TO b
IF INKEY$ = CHR$(27) THEN END
READ text2$
IF bloopx = b THEN
PRINT text2$; " ";
END IF
NEXT bloopx
RESTORE
                        c = INT(RND(names + when + 1) * what) + (names + when + 1)
FOR bloopx = 1 TO c
IF INKEY$ = CHR$(27) THEN END
READ text3$
IF bloopx = c THEN
PRINT text3$; " ";
END IF
NEXT bloopx
RESTORE
                        d = INT(RND(names + when + what + 1) * where) + (what + names + when + 1)
FOR bloopx = 1 TO d
IF INKEY$ = CHR$(27) THEN END
READ text4$
IF bloopx = d THEN
PRINT text4$; "."
END IF
NEXT bloopx
OPEN "c:\temp.tmp" FOR OUTPUT AS #1
text5$ = text$ + " " + text2$ + " " + text3$ + " " + text4$
PRINT #1, text5$
CLOSE
COLOR 0
LOCATE 24, 1
SHELL ("d:\sbtalker\read <c:\temp.tmp")
'DO
'IF INKEY$ = CHR$(27) THEN END
'a = a + 1
'LOOP UNTIL INKEY$ <> "" OR a = 10000
SLEEP 1
IF INKEY$ = CHR$(27) THEN GOTO 12
LOOP
DATA A cow,Mr. Splot,Captain Sock, Super Squish, Paul, Bill Nye, Nelson, Steve, Mr. Bloop, Evan, Mrs. Avocado, Some idiot, A homicidal killer, A green alien from Mars, Jim the giraffe, Bill Gates, Nick
DATA Bill Clinton, Katie, David, Katlyn, Sara, Mom, Dad, Gary, Domino, Nuzzle, Matt, Ben, Amelia, No one in particular, Mr. Moo, A refried bean, An Oreo Cookie, Phill, Carolyn

DATA is,was,has been,will be,could be,can never be,can be,should be,always will be,feels like being,soon will be,wants to be,wishes to be,thinks no one can be,thinks everyone is
DATA could very possibly be

DATA cool, rad, the best,tubular,terrible,daring,special,splotted,dead,recycled,blooped,turned into a green pulp, dumped into radioactive chemicals,slashed,shot,decapitated,burned,married,loved,hated
DATA smart,stupid,liquidated,squished,crushed,funky,fuzzy,furry
DATA tasty, smelly, hooked on phonics, sniffing glue, happy, sniffing White-Out, a hippie, an avocado-colored flesh-eating slime-ball, mentally challenged, physically challenged, emotionally challenged
DATA socially challenged, fatuous, vertically challenged, horizontally challenged, refried, dumped, eating, drinking, burping, sleeping, crying, sneezing, programming, talking, eating squid, flying

DATA at a bar, in Paris, at home, when drowning in a lake, in Lake Save-Me, in Kalamazoo, on the range, in space, during the war, in a car, in a plane, in Navoo, in Wyoming, under a bed, on Cody Pass
DATA on 37 Williston Road, in Never-Never Land, in Toledo Ohio,in a galaxy far far away, on the U.S.S. Enterprise 1_7_O_1_d
12
COLOR 3
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT "                         ษอออออออออออออออออออป"
PRINT "                         บ      Bloop!       บ"
PRINT "                         ศอออออออออออออออออออผ"

