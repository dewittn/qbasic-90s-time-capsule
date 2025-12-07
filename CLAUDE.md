# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

A historical software preservation project containing QBasic programs written in the early-to-mid 1990s (1994-1997). This is a time capsule of hobbyist programming from the DOS/QuickBASIC era, featuring personal projects, educational utilities, games/demos, and period-appropriate shareware.

## Key Commands

### Running QBasic Programs
```bash
# Open QB IDE
./tools/qb.sh

# Edit a specific program
./tools/qb.sh my-programs/screensavers/LINES.BAS

# Run a program directly
./tools/qb.sh my-programs/screensavers/LINES.BAS run
```

### Converting Binary Files
QBasic saved programs in two formats: text (readable) and binary tokenized (0xFC magic byte). Most files have been converted to text.

```bash
# List binary tokenized files
./tools/convert_binary.sh list

# Convert interactively
./tools/convert_binary.sh interactive my-programs/

# Convert single file
./tools/convert_binary.sh single <file.bas>
```

## Directory Structure

- `my-programs/` - Personal programs organized by category:
  - `chat-terminal/` - Serial port chat client with "chat war" features (TERMINAL.BAS is the flagship)
  - `screensavers/` - Bouncing shape animations showing progression (BOUNCE → BOUNCE2 → LINES → etc.)
  - `math-helpers/` - Algebra homework automation (quadratics, factoring, synthetic division)
  - `graphics-demos/` - VGA graphics experiments
  - `pranks/` - Fake DOS/format programs
  - `misc/` - Various utility and test programs

- `samples/` - Not personally written
  - `microsoft/` - QuickBASIC 4.5 official samples
  - `third-party/` - Friend's code and downloaded programs

- `90s-shareware/` - BBS/shareware collection from the era

- `qbasic-runtime/` - QuickBASIC 4.5 runtime (QB.EXE, BC.EXE, BRUN45.EXE)

- `build-artifacts/` - Compiled .EXE, .OBJ, and data files

- `tools/` - Modern helper scripts (qb.sh, convert_binary.sh)

## Technical Context

- **Language**: QBasic (QuickBASIC 4.5) running in DOSBox
- **Requirements**: DOSBox or DOSBox-X (tools auto-detect installation)
- **Platform**: Scripts optimized for macOS (convert_binary.sh uses AppleScript)
- **Code Style**: Authentic 90s hobbyist code with era-appropriate patterns (GOTO, global variables, line numbers in some files)
