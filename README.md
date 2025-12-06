# QBasic Programs (1994-1997)

A collection of QBasic programs I wrote in middle school and high school, preserved from the mid-1990s. These programs represent my early programming journey, learning to code on DOS machines with QuickBASIC 4.5.

## Highlighted Programs

### TERMINAL.BAS - Serial Chat Client
**Location:** `my-programs/chat-terminal/`

A feature-rich serial port terminal program for PC-to-PC chat over null modem cables. This was part of a friendly "chat war" with a friend - we'd implement pranks and counter-measures against each other.

**Features:**
- Dual COM port support (COM1 for direct connection, COM2 for modem)
- Split-screen UI with status bar
- **Deflector** - Bounce incoming messages back at the sender
- **Anti-Deflector** - Filter out reflected messages
- **ASCII Spam** - Flood random characters
- **Repeat Send** - Message bombing
- **Fake Disconnect** - Pretend to leave, then surprise them
- Session logging to file
- Message recording and playback

*The TERMINA2, TERMINA3, and TERMINA4 files show the evolution as new features were added.*

---

### Screensaver Series
**Location:** `my-programs/screensavers/`

A progression of bouncing line/shape animations, each iteration adding new features:

| Program | Description |
|---------|-------------|
| **BOUNCE.BAS** | Simple bouncing circle |
| **BOUNCE2.BAS** | Added color cycling |
| **BOUNCE3.BAS** | Two objects with collision detection |
| **LINES.BAS** | Radial lines creating interference patterns |
| **SCREEN.BAS** | 20-point bouncing polygon |
| **SHBONCE2.BAS** | Mesh-connected bouncing points |
| **SQUBONC3.BAS** | User-configurable: choose number of shapes and vertices |

*These demonstrate learning graphics programming through iteration - each version building on the last.*

---

### Math Homework Helpers
**Location:** `my-programs/math-helpers/`

Programs I wrote to help with (or automate) algebra homework:

| Program | Description |
|---------|-------------|
| **MATH2.BAS** | Factors quadratic trinomials (x² + bx + c) |
| **MATH3.BAS** | Handles leading coefficients (ax² + bx + c) |
| **CHAPTER4.BAS** | Solves systems of linear equations using elimination |
| **SENSUB.BAS** | Synthetic division calculator - shows all work |
| **ABLRA*.BAS** | Various algebra problem solvers |

*Complete with typos like "Eneter" and "pionts" - authentic middle school code!*

---

### Prank Programs
**Location:** `my-programs/pranks/`

| Program | Description |
|---------|-------------|
| **FAKEDOS.BAS** | Fake DOS prompt that pretends to delete files, requires a Fibonacci sequence to escape (11235813213455) |
| **FORMAT_C.BAS** | Fake format C: command |

---

## Directory Structure

```
QBasic/
├── my-programs/           # Programs I wrote
│   ├── screensavers/      # Bouncing lines and shapes
│   ├── math-helpers/      # Algebra homework automation
│   ├── chat-terminal/     # Serial chat client (TERMINAL.BAS)
│   ├── graphics-demos/    # Graphics experiments
│   ├── pranks/            # FAKEDOS, FORMAT_C
│   └── misc/              # Other personal projects
│
├── samples/               # Code I didn't write
│   ├── microsoft/         # QB4.5 sample programs (TORUS, MANDEL, etc.)
│   └── third-party/       # Friend's code & downloaded programs
│
├── 90s-shareware/         # BBS/shareware collection from the era
│
├── qbasic-runtime/        # QB.EXE and supporting files
│
├── build-artifacts/       # Compiled .EXE, .OBJ, and data files
│
└── tools/                 # Modern helper scripts
    ├── qb.sh              # Launch programs in DOSBox
    └── convert_binary.sh  # Convert tokenized files to text
```

## Running These Programs

### Using DOSBox

The `tools/qb.sh` script launches programs in DOSBox:

```bash
# Open QuickBASIC IDE
./tools/qb.sh

# Open a program in the editor
./tools/qb.sh my-programs/screensavers/LINES.BAS

# Run a program directly
./tools/qb.sh my-programs/screensavers/LINES.BAS run
```

### Requirements
- [DOSBox](https://www.dosbox.com/) or [DOSBox-X](https://dosbox-x.com/)
- The QuickBASIC 4.5 runtime (included in `qbasic-runtime/`)

## Historical Context

These programs were written between 1994-1997 when I was in 8th-9th grade. They represent:

- **Learning through iteration** - Multiple versions of programs as I learned new techniques
- **Practical problem-solving** - Math helpers to automate tedious homework calculations
- **Creative exploration** - Screensavers pushing the limits of VGA graphics
- **Social coding** - The TERMINAL chat programs were part of a friendly rivalry, trading pranks and counter-measures with a friend over null modem cables

The code style reflects its era: line numbers (in some files), GOTO statements, global variables, and creative variable naming. It's preserved here as a time capsule of 1990s hobbyist programming.

## File Format Note

QBasic saved files in two formats:
- **Text** - Human-readable source code
- **Binary tokenized** - Compressed format starting with `0xFC` byte

Most files have been converted to text format for readability. The `tools/convert_binary.sh` script can convert any remaining binary files using DOSBox.
