DECLARE SUB Instructions ()
DECLARE SUB MusicConfig ()
DECLARE SUB SaveFile (PlayIt$)
DECLARE SUB LoadFile (PlayIt$, found$)
DECLARE SUB ComposeMusic (PlayIt$)
DO
CLS
PRINT "The MusicComposer"
PRINT "Programmed by Krisjanis 'The Hacker' Gale"
PRINT
PRINT "Type:": PRINT
PRINT "1) To get instructions."
PRINT "2) To compose a new music."
PRINT "3) To replay newly made or loaded music."
PRINT "4) To save music currently in memory."
PRINT "5) To load previously composed music from a file."
PRINT "6) To Quit.": PRINT
LOCATE 23, 1
PRINT "Press number of selection..."
DO
LET in$ = INKEY$
LOOP WHILE in$ = ""
SELECT CASE in$
CASE "1"
  CALL Instructions
CASE "2"
  IF PlayIt$ <> "" THEN
    CLS
    INPUT "Erase what exists?(y/n)...>", erase$
    IF erase$ = "y" THEN
      CLS
      LET PlayIt$ = ""
      CALL ComposeMusic(PlayIt$)
    END IF
    IF erase$ = "n" THEN
      INPUT "Add on to what exists?(y/n)...>", addon$
      IF addon$ = "y" THEN
        CLS
        PRINT PlayIt$
        CALL ComposeMusic(PlayIt$)
      END IF
    END IF
  ELSE
    CLS
    CALL ComposeMusic(PlayIt$)
  END IF
CASE "3"
  CLS
  INPUT "Loop music indefinately?(y/n)...>", yesno$
  IF yesno$ = "y" THEN
    PRINT "Press ESC to stop music loop."
    DO
      PLAY PlayIt$
    LOOP UNTIL INKEY$ = CHR$(27)
  END IF
  IF yesno$ = "n" THEN
    PLAY PlayIt$
  END IF
CASE "4"
  CALL SaveFile(PlayIt$)
CASE "5"
  CALL LoadFile(PlayIt$, found$)
CASE "6"
  LOCATE 22, 1
  PRINT "Thanks for using my program."
  PRINT "                 --Krisjanis 'The Hacker' Gale--"
  SLEEP 1
END SELECT
LOOP UNTIL in$ = "6"
END

SUB ComposeMusic (PlayIt$)
PRINT "Play!"
DO
SLEEP
LET in$ = INKEY$
SELECT CASE in$
CASE "a"
  PLAY "c"
  PRINT "C ";
  LET PlayIt$ = PlayIt$ + "c"
CASE "w"
  PLAY "c#"
  PRINT "C# ";
  LET PlayIt$ = PlayIt$ + "c#"
CASE "s"
  PLAY "d"
  PRINT "D ";
  LET PlayIt$ = PlayIt$ + "d"
CASE "e"
  PLAY "e-"
  PRINT "E- ";
  LET PlayIt$ = PlayIt$ + "e-"
CASE "d"
  PLAY "e"
  PRINT "E ";
  LET PlayIt$ = PlayIt$ + "e"
CASE "f"
  PLAY "f"
  PRINT "F ";
  LET PlayIt$ = PlayIt$ + "f"
CASE "t"
  PLAY "f#"
  PRINT "F# ";
  LET PlayIt$ = PlayIt$ + "f#"
CASE "g"
  PLAY "g"
  PRINT "G ";
  LET PlayIt$ = PlayIt$ + "g"
CASE "y"
  PLAY "a-"
  PRINT "A- ";
  LET PlayIt$ = PlayIt$ + "a-"
CASE "h"
  PLAY "a"
  PRINT "A ";
  LET PlayIt$ = PlayIt$ + "a"
CASE "u"
  PLAY "b-"
  PRINT "B- ";
  LET PlayIt$ = PlayIt$ + "b-"
CASE "j"
  PLAY "b"
  PRINT "B ";
  LET PlayIt$ = PlayIt$ + "b"
CASE "k"
  PLAY ">c<"
  PRINT "HiC ";
  LET PlayIt$ = PlayIt$ + ">c<"
CASE ","
  PRINT "1/12 note "
  PLAY "l6"
  LET PlayIt$ = PlayIt$ + "l6"
CASE "."
  PRINT "3/2 len. ";
  LET PlayIt$ = PlayIt$ + "."
CASE "["
  PLAY "<"
  PRINT "OctvDn ";
  LET PlayIt$ = PlayIt$ + "<"
CASE "]"
  PLAY ">"
  PRINT "OctvUp ";
  LET PlayIt$ = PlayIt$ + ">"
CASE "p"
  PLAY "n0"
  PRINT "Pause ";
  LET PlayIt$ = PlayIt$ + "n0"
CASE "1"
  PLAY "l1"
  PRINT "Whole ";
  LET PlayIt$ = PlayIt$ + "l1"
CASE "2"
  PLAY "l2"
  PRINT "Half ";
  LET PlayIt$ = PlayIt$ + "l2"
CASE "3"
  PLAY "l4"

  PRINT "Quarter ";
  LET PlayIt$ = PlayIt$ + "l4"
CASE "4"
  PLAY "l8"
  PRINT "Eighth ";
  LET PlayIt$ = PlayIt$ + "l8"
CASE "5"
  PLAY "l16"
  PRINT "Sixteenth ";
  LET PlayIt$ = PlayIt$ + "l16"
CASE "6"
  PLAY "l32"
  PRINT "Thirty-Second ";
  LET PlayIt$ = PlayIt$ + "l32"
CASE "7"
  PLAY "l64"
  PRINT "Sixty-Fourth ";
  LET PlayIt$ = PlayIt$ + "l64"
CASE "8"
  PLAY "ms"
  PRINT "Staccato ";
  LET PlayIt$ = PlayIt$ + "ms"
CASE "9"
  PLAY "mn"
  PRINT "Normal ";
  LET PlayIt$ = PlayIt$ + "mn"
CASE "0"
  PLAY "ml"
  PRINT "Lengato ";
  LET PlayIt$ = PlayIt$ + "ml"
CASE "="
  INPUT "Octave(0-6)...>", octave
  PLAY "o" + STR$(octave)
  LET PlayIt$ = PlayIt$ + "o" + MID$(STR$(octave), 2, LEN(STR$(octave)))
CASE "-"
  INPUT "Tempo?(32-255 qtr.notes/sec.)...>", tempo
  PLAY "t" + STR$(tempo)
  LET PlayIt$ = PlayIt$ + "t" + MID$(STR$(tempo), 2, LEN(STR$(tempo)))
END SELECT
LOOP UNTIL in$ = CHR$(27)
END SUB

SUB Instructions
CLS
PRINT "Welcome to my music composition program."
PRINT "Summary of menu choices:"
PRINT "1) Displays this help file."
PRINT "2) Allows you to create new music and store it in RAM."
PRINT "   (See summary of keys below.)  When you are done, press ESC."
PRINT "3) Replays music that was just composed and is still in RAM."
PRINT "4) Allows you to save newly composed music to a file."
PRINT "5) Lets you load a file that you already saved so that you don't have"
PRINT "   to start over and recompose the music."
PRINT "6) Like it says.  QUITS the program."
LOCATE 11, 1
PRINT
PRINT "Notes:"
PRINT "a: C"; TAB(10); "w: C#"; TAB(20); "s: D"; TAB(30); "e: E-";
PRINT TAB(40); "d: E"; TAB(50); "f: F"; TAB(60); "t: F#"
PRINT "g: G"; TAB(10); "y: A-"; TAB(20); "h: A"; TAB(30); "u: B-"; TAB(40); "j: B";
PRINT TAB(50); "k: hiC"
PRINT

PRINT "Functions:"
PRINT ",: 1/12 note (for eighth note triplets)"
PRINT ".: 3/2 length"; TAB(20); "p: pause"
PRINT "=: Select octave"; TAB(25); "[: Lowers octave"; TAB(50); "]:"; Raises; octave; ""
PRINT "-: Change tempo"; TAB(25); "1-7: Changes note length (1: whole, 2: half, etc.)"
PRINT "8: Staccatto"; TAB(25); "9: Normal"; TAB(50); "0: Lengato"
PRINT
LOCATE 23, 1
PRINT "Press any key to continue..."
DO
LOOP WHILE INKEY$ = ""
END SUB

SUB LoadFile (PlayIt$, found$)
CLS
DO
CHDIR "\"
FILES "*."
INPUT "Please enter PATH where you saved the file...>", path$
CHDIR path$
FILES "*."
INPUT "Is the file there?(y/n)...>", found$
IF found$ = "n" THEN
  INPUT "Give up search?(y/n)...>", abort$
END IF
LOOP UNTIL found$ = "y" OR abort$ = "y"
IF found$ = "y" THEN
INPUT "Please specify which file (from those above)...>", name$
OPEN name$ FOR INPUT AS #1
INPUT #1, PlayIt$
CLOSE #1
END IF
END SUB

SUB SaveFile (PlayIt$)
CLS
INPUT "Will this be a NEW or PREVIOUS file?(n/p)...>", neworprev$
IF neworprev$ = "n" THEN
  CHDIR "\"
  FILES "*."
  INPUT "Please enter PATH to save file to...>", path$
  CHDIR path$
  INPUT "Enter new file name (please use no file extension!)...>", name$
END IF
IF neworprev$ = "p" THEN
  DO
  CHDIR "\"
  FILES "*."
  INPUT "Please enter PATH where you saved the file...>", path$
  CHDIR "\"
  CHDIR path$
  FILES "*."
  INPUT "Is the file there?(y/n)...>", found$
    IF found$ = "n" THEN
      INPUT "Give up search?(y/n)...>", abort$
    END IF
  LOOP UNTIL found$ = "y" OR abort$ = "y"
  IF found$ = "y" THEN
    INPUT "Enter previous file name (it WILL be overwritten!)...>", name$
  END IF
END IF
OPEN name$ FOR OUTPUT AS #1
PRINT #1, PlayIt$
CLOSE #1
END SUB

