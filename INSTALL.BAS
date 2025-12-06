CLS
PRINT "Installing more rooms form doom"
INPUT "Enter name of the directory the game Doom is in.(c:\doom)", a$
SHELL "a:\"
SHELL "pkunzip moredoom.zip " + a$
SHELL "c:\"
SHELL "cd " + a$
END

