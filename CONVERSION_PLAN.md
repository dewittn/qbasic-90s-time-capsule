# QBasic to Python Conversion Plan

This document outlines the plan to convert select QBasic programs from the 1990s into modern Python, preserving functionality while adding clarity through proper variable names and comments.

## Design Principles

1. **Interactive CLI** - Recreate the original runtime experience
2. **Easter egg comments** - Preserve original typos ("Eneter", "Pime", "pulg in", "pionts", "figers") as comments only
3. **Side-by-side placement** - Python files live next to their .BAS counterparts
4. **Clean code** - Proper variable names, functions, and documentation
5. **Always provide an exit** - ESC key (or Ctrl+C) to quit any program, even if original lacked it
6. **Discoverable UI** - Show available commands/keys on screen where appropriate
7. **Clear prompts** - User-friendly input prompts that explain what's being asked for
8. **Readable variables** - Descriptive variable names (e.g., `first_coefficient` not `b_input`)

### Code Style Guidelines

**Variable Naming:**
- Use descriptive names: `polynomial_degree`, `divisor_value`, `x_coefficient`
- Avoid single letters except for loop counters or well-known math conventions
- Name collections clearly: `coefficients`, `factor_pairs`, `equations`

**User Prompts:**
- Be descriptive: `"Enter the x coefficient for equation 1: "` not `"X1: "`
- Include context: `"Enter coefficient for x² term (a): "`
- Show valid input: `"Continue? (y/n): "`
- Preserve Easter egg typos only in comments, not in actual prompts

**Example transformation:**
```python
# Original QBasic style (don't do this):
b_input = input("1: ")  # cryptic prompt

# Modern Python style (do this):
# Easter egg: Original prompt was just "1:"
middle_coefficient = int(input("Enter middle coefficient (b): "))
```

---

## Phase 1: Math Helpers

Location: `my-programs/math-helpers/`

### 1.1 MATH2.py - Simple Quadratic Factoring
- **Original**: MATH2.BAS (39 lines)
- **Purpose**: Factor quadratics of form x² + bx + c into (x+m)(x+n)
- **Features**:
  - Prompt for variable letter, b coefficient, c coefficient
  - Find factor pairs that multiply to c and add to b
  - Print "Pime" (sic) if unfactorable
- **Easter eggs**: "Pime" typo, "L:" and "1:", "2:" prompts

### 1.2 MATH3.py - Advanced Quadratic Factoring
- **Original**: MATH3.BAS (76 lines)
- **Purpose**: Factor quadratics of form ax² + bx + c (with leading coefficient)
- **Features**:
  - Handle leading coefficients by finding factor pairs of 'a'
  - More complex output formatting
- **Easter eggs**: Inherits MATH2 style

### 1.3 CHAPTER4.py - Linear System Solver
- **Original**: CHAPTER4.BAS (192 lines)
- **Purpose**: Solve 2-variable linear systems using elimination method
- **Features**:
  - Input two equations (coefficients for x, y, and answer)
  - Find LCM to eliminate variables
  - Show all algebraic steps
  - Option to solve for x using same method
- **Easter eggs**: "Eneter X1" typo

### 1.4 SENSUB.py - Synthetic Division
- **Original**: SENSUB.BAS (62 lines)
- **Purpose**: Perform synthetic division and show all work
- **Features**:
  - Input polynomial coefficients by degree
  - Input divisor value
  - Display synthetic division table with carry-down
  - Allow changing just the divisor for repeated runs
- **Easter eggs**: "pulg in" typo, "pionts" would be good to add

### 1.5 BASES.py - Number Base Conversion
- **Original**: BASES.BAS (34 lines)
- **Purpose**: Convert decimal numbers to other bases
- **Features**:
  - Input number and target base
  - Show conversion result
  - Display all bases from target down to 1

---

## Phase 2: Screensavers (pygame)

Location: `my-programs/screensavers/`

### 2.1 LINES.py - Radial Lines
- **Original**: LINES.BAS (22 lines)
- **Purpose**: Draw random colored lines from screen center
- **Features**:
  - Lines radiate from center (320, 240 in VGA)
  - Random colors (1-15)
  - Oscillating Y coordinate creates wave pattern
  - ESC to exit

### 2.2 BOUNCE.py - Bouncing Circle
- **Original**: BOUNCE.BAS (25 lines)
- **Purpose**: Animated bouncing circle with line to center
- **Features**:
  - Circle bounces off screen edges
  - Radius grows and shrinks (toggle with spacebar)
  - Line connects circle to screen center
  - Random colors on each frame

### 2.3 SQUBONC3.py - Configurable Bouncing Polygons
- **Original**: SQUBONC3.BAS (100 lines)
- **Purpose**: Multiple bouncing polygon shapes
- **Features**:
  - User configures number of "figers" (figures) and "pionts" (points)
  - Each vertex bounces independently
  - Lines connect vertices to form polygon
  - Color cycling
  - ESC to exit
- **Easter eggs**: "figers", "pionts" prompts preserved

### 2.4 SCREEN.py - Color-Cycling Polygon
- **Original**: SCREEN.BAS (93 lines)
- **Purpose**: 20-point bouncing polygon with RGB palette manipulation
- **Features**:
  - Uses VGA PALETTE command for smooth color transitions
  - RGB values derived from vertex positions
  - Creates flowing color effect

---

## Phase 3: Terminal Chat (Modernized)

Location: `my-programs/chat-terminal/`

### 3.1 TERMINAL.py - Modern Chat War Client
- **Original**: TERMINAL.BAS (1475 lines)
- **Purpose**: Two-terminal chat program with "prank" features
- **Architecture**:
  - Single script with `--server` / `--client` modes
  - TCP localhost connection (extensible to network)
  - `curses` or `blessed` for split-screen TUI
  - `asyncio` for simultaneous send/receive

- **UI Layout** (improved from original with discoverable commands):
  ```
  ┌─────────────────────────────────────────────────────────────────────┬──────────┐
  │ TERMINAL.py - Chat War Client                              [Q]uit  │ COMMANDS │
  ├─────────────────────────────────────────────────────────────────────┤──────────┤
  │                                                                     │[1] Deflect│
  │ Incoming messages area                                              │[2] ASCII  │
  │                                                                     │[3] Repeat │
  ├─────────────────────────────────────────────────────────────────────┤[4] Anti-DF│
  │                                                                     │[5] No In  │
  │ Your typing area                                                    │[6] Fake DC│
  │                                                                     │[7] Record │
  ├─────────────────────────────────────────────────────────────────────┤[8] Play   │
  │ Status: [DF] [  ] [  ] [  ] [  ] [  ]              Connected: ✓    │[9] Log    │
  └─────────────────────────────────────────────────────────────────────┴──────────┘
  ```

- **Chat War Features** (using number keys for easier discovery):
  | Key | Feature | Description |
  |-----|---------|-------------|
  | 1 | Deflector | Bounce incoming messages back at sender |
  | 2 | ASCII Spam | Flood random ASCII characters |
  | 3 | Repeat Send | Continuously resend a message |
  | 4 | Anti-Deflector | Filter out your own reflected messages |
  | 5 | No Input | Ignore all incoming messages |
  | 6 | Fake Disconnect | Pretend to leave, wait for keypress, reconnect |
  | 7 | Record | Start/stop recording a message |
  | 8 | Playback | Send the recorded message |
  | 9 | File Log | Log session to file |
  | Q | Quit | Exit the program |

- **Connection Flow**:
  1. Server: `python TERMINAL.py --server` (listens on port 9600, matching original baud rate)
  2. Client: `python TERMINAL.py --client`
  3. Handshake establishes connection
  4. Full-duplex messaging begins

---

## Phase 4: Fun Extras

### 4.1 FAKEDOS.py - Fake DOS Prompt
- **Location**: `my-programs/pranks/`
- **Original**: FAKEDOS.BAS (114 lines)
- **Purpose**: Fake DOS prompt that pretends to delete files
- **Features**:
  - Simulates DOS commands (DIR, DEL, VER, CLS, etc.)
  - DEL pretends to delete random number of files
  - EXIT requires Fibonacci password: `11235813213455`
  - CLS prints "Squids Rule" in random colors
  - VER shows "MS-DOS Version 1.00"
- **Easter eggs**: The entire thing is an easter egg

### 4.2 ASCII.py - Random ASCII Art
- **Location**: `my-programs/misc/`
- **Original**: ASCII.BAS (23 lines)
- **Purpose**: Print random colored ASCII characters
- **Features**:
  - Random characters, random colors
  - Skip control characters
  - ESC to exit

---

## Implementation Order

1. **Phase 1** - Math Helpers (straightforward, testable)
   - MATH2.py
   - MATH3.py
   - CHAPTER4.py
   - SENSUB.py
   - BASES.py

2. **Phase 2** - Screensavers (requires pygame setup)
   - LINES.py
   - BOUNCE.py
   - SQUBONC3.py
   - SCREEN.py

3. **Phase 3** - Terminal Chat (largest project)
   - TERMINAL.py

4. **Phase 4** - Fun Extras
   - FAKEDOS.py
   - ASCII.py

---

## Dependencies

```
# Phase 1: No dependencies (stdlib only)

# Phase 2: Screensavers
pygame

# Phase 3: Terminal Chat
blessed  # or curses (stdlib on Unix)

# Optional: requirements.txt
pygame>=2.0
blessed>=1.20
```

---

## Notes

- All Python files should include a header comment referencing the original .BAS file
- Include "Easter Egg" comments for preserved typos
- Use `if __name__ == "__main__":` pattern for CLI entry
- Target Python 3.8+ for compatibility

## Exit Behavior

Every program should have a clear exit mechanism:

| Program Type | Exit Method | Display |
|--------------|-------------|---------|
| Math helpers | Ctrl+C or enter 0/blank | Show "Press Ctrl+C to quit" or "Enter 0 to quit" |
| Screensavers (pygame) | ESC key or close window | Show "ESC to quit" on startup |
| Terminal chat | Q key | Visible in sidebar |
| FAKEDOS | Type "EXIT" + password | Part of the prank |

For pygame screensavers, also handle the window close (X) button gracefully.
