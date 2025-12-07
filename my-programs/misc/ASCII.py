#!/usr/bin/env python3
"""
ASCII.py - Random ASCII Art Generator

Original: ASCII.BAS (23 lines, ~1995)
Converted to modern Python

Prints random ASCII characters in random colors, creating a
colorful noise pattern. Skips control characters that would
mess up the display.

Controls:
  ESC or Ctrl+C to quit
"""

import random
import sys
import select
import tty
import termios


# ANSI color codes (DOS colors 1-14, avoiding 0/black and 15/white for variety)
COLORS = [
    '\033[34m',    # 1: Blue
    '\033[32m',    # 2: Green
    '\033[36m',    # 3: Cyan
    '\033[31m',    # 4: Red
    '\033[35m',    # 5: Magenta
    '\033[33m',    # 6: Brown/Yellow
    '\033[37m',    # 7: Light Gray
    '\033[90m',    # 8: Dark Gray
    '\033[94m',    # 9: Light Blue
    '\033[92m',    # 10: Light Green
    '\033[96m',    # 11: Light Cyan
    '\033[91m',    # 12: Light Red
    '\033[95m',    # 13: Light Magenta
    '\033[93m',    # 14: Yellow
]
RESET = '\033[0m'

# Characters to skip (control chars that mess up display)
# Original skipped: 7 (bell), 9-13 (tab, newlines), 28-32 (control chars)
SKIP_CHARS = {7, 9, 10, 11, 12, 13, 28, 29, 30, 31, 32}


def kbhit():
    """Check if a key has been pressed (non-blocking)."""
    dr, _, _ = select.select([sys.stdin], [], [], 0)
    return dr != []


def getch():
    """Get a single character from stdin."""
    return sys.stdin.read(1)


def main():
    print("ASCII.py - Random ASCII Art")
    print("Press ESC or Ctrl+C to quit")
    print()

    # Set terminal to raw mode for detecting ESC
    old_settings = termios.tcgetattr(sys.stdin)

    try:
        tty.setcbreak(sys.stdin.fileno())

        while True:
            # Check for ESC key
            if kbhit():
                ch = getch()
                if ch == '\x1b':  # ESC
                    break

            # Generate random character (1-255)
            char_code = random.randint(1, 255)

            # Skip control characters (original's exclusion list)
            if char_code in SKIP_CHARS:
                continue

            # Pick random color (1-14)
            color = random.choice(COLORS)

            # Print the character
            try:
                print(f"{color}{chr(char_code)}{RESET}", end='', flush=True)
            except (UnicodeEncodeError, ValueError):
                # Skip chars that can't be displayed in current terminal
                continue

    except KeyboardInterrupt:
        pass
    finally:
        # Restore terminal settings
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)
        print()
        print(f"{RESET}Goodbye!")


if __name__ == "__main__":
    main()
