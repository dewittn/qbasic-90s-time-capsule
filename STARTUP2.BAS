DECLARE FUNCTION Center$ (a$)
CLS
COLOR 14, 9
CLS
PRINT
PRINT Center$("Nele's fun house")
COLOR 0, 9
PRINT "--------------------------------------------------------------------------------"
PRINT
COLOR 15, 9
PRINT "Log in time:"
PRINT TIME$, DATE$
w$ = TIME$: x$ = DATE$
PRINT
PRINT
COLOR 22, 9
OPEN "c:\info.slp" FOR INPUT AS #1
INPUT #1, a$
CLOSE #1
PRINT a$; b$
PRINT
PRINT
COLOR 15, 9
PRINT " Menu:"
PRINT "         1) Windows"
PRINT "         2) Dos"
PRINT "         3) Quick basic"
PRINT
COLOR 7, 9
PRINT "Note:  The Default is 1 and if user doesn't respond within 30 seconds"
PRINT "windows will automatically entered."
DO
c = c + 1
SLEEP 1
a$ = INKEY$
IF c = 30 THEN a$ = "1"
LOOP UNTIL a$ <> ""
SELECT CASE a$
CASE "1"
COLOR 7, 9
CLS
SHELL "win :"
CASE "2"
COLOR 7, 9
CLS
END
CASE "3"
SHELL "qb"
CASE ELSE
END
END SELECT
PRINT "Log in time :"; w$, x$
PRINT "Log out Time:"; TIME$, DATE$

FUNCTION Center$ (a$)
Center$ = SPACE$(40 - (LEN(a$) / 2)) + a$
END FUNCTION

