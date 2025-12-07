#!/usr/bin/env python3
"""
FAKEDOS.py - Fake DOS Prompt Prank

Original: FAKEDOS.BAS (114 lines, ~1995)
Converted to modern Python

A fake DOS prompt that pretends to delete files and requires a
Fibonacci sequence password to exit: 11235813213455

Easter eggs:
  - "Squids Rule" on CLS command
  - MS-DOS Version 1.00
  - Volume Serial Number 1701-DM25 (Star Trek reference!)
  - The fakeid delay loop wrote "steve rules" to a temp file

Commands:
  DIR      - Shows empty directory
  DEL      - Pretends to delete random number of files
  VER      - Shows "MS-DOS Version 1.00"
  CLS      - Prints "Squids Rule" in random colors, then clears
  CD <dir> - Always says directory doesn't exist
  A:/C:/D:/E: - Switch drives
  UNFORMAT - "ERROR! BAD DISK SECTORS!"
  EXIT     - Requires Fibonacci password to actually exit
  HELP     - Shows available commands (not in original)

Controls:
  Type EXIT and enter password 11235813213455 to quit
  Or press Ctrl+C
"""

import random
import time
import sys


# ANSI color codes (simulating DOS colors 0-15)
COLORS = [
    '\033[30m',    # 0: Black
    '\033[34m',    # 1: Blue
    '\033[32m',    # 2: Green
    '\033[36m',    # 3: Cyan
    '\033[31m',    # 4: Red
    '\033[35m',    # 5: Magenta
    '\033[33m',    # 6: Brown/Yellow
    '\033[37m',    # 7: Light Gray (default)
    '\033[90m',    # 8: Dark Gray
    '\033[94m',    # 9: Light Blue
    '\033[92m',    # 10: Light Green
    '\033[96m',    # 11: Light Cyan
    '\033[91m',    # 12: Light Red
    '\033[95m',    # 13: Light Magenta
    '\033[93m',    # 14: Yellow
    '\033[97m',    # 15: White
]
RESET = '\033[0m'
BLINK = '\033[5m'


def fake_delay(iterations: int):
    """
    Simulates the original's delay loop.

    Easter egg: Original wrote "steve rules" to a temp file repeatedly
    as a way to create delays on slow DOS machines.
    """
    # Easter egg comment: Original delay loop wrote "steve rules" to c:\fakeid.slp
    time.sleep(iterations * 0.05)


def clear_screen():
    """Clear the terminal screen."""
    print('\033[2J\033[H', end='')


def print_squids_rule():
    """
    CLS easter egg: Print "Squids Rule" in random colors 1000 times.
    """
    for _ in range(1000):
        color = COLORS[random.randint(0, 14)]
        print(f"{color}Squids Rule{RESET}", end='')
    print()
    time.sleep(0.5)
    clear_screen()


def handle_dir():
    """Handle DIR command - shows empty directory."""
    fake_delay(2)
    print()
    print("Volume in drive C has no label")
    # Easter egg: 1701-DM25 is a Star Trek reference (NCC-1701)
    print("Volume Serial Number is 1701-DM25")
    print("Directory of C:\\")
    print()
    print("File not found")


def handle_del():
    """Handle DEL command - pretends to delete files."""
    print("All files in directory will be deleted!")
    print("Are you sure (Y/N)?", end='', flush=True)
    time.sleep(0.3)
    print("y")
    fake_delay(35)
    num_files = random.randint(1, 200)
    print(f"{COLORS[7]}Total {num_files} files deleted{RESET}")


def handle_exit() -> bool:
    """
    Handle EXIT command - requires Fibonacci password.
    Returns True if correct password entered.
    """
    # Easter egg: Password is Fibonacci sequence: 1,1,2,3,5,8,13,21,34,55
    print(f"{BLINK}Enter password:{RESET}", end='')
    # Original used COLOR 0 (black on black) to hide password input
    try:
        password = input()
    except EOFError:
        return False

    if password == "11235813213455":
        print(f"{COLORS[7]}Access granted. Exiting...{RESET}")
        return True
    else:
        print(f"{COLORS[7]}Sorry, incorrect password{RESET}")
        print("Returning to DOS")
        return False


def handle_cd(path: str):
    """Handle CD command - always fails."""
    fake_delay(2)
    print("Invalid directory")
    print(f"Directory: C:\\{path} does not exist")


def handle_unformat():
    """Handle UNFORMAT command."""
    fake_delay(8)
    print("ERROR!  BAD DISK SECTORS!")
    print("aborting unformat.")


def handle_ver():
    """Handle VER command."""
    print()
    print("MS-DOS Version 1.00")


def handle_help():
    """Handle HELP command (not in original, but useful)."""
    print()
    print("Available commands:")
    print("  DIR       - List directory contents")
    print("  DEL       - Delete files")
    print("  CD <dir>  - Change directory")
    print("  CLS       - Clear screen")
    print("  VER       - Show DOS version")
    print("  UNFORMAT  - Attempt to unformat drive")
    print("  EXIT      - Exit to real DOS")
    print("  A: C: D: E: - Change drive")
    print()


def main():
    random.seed()
    clear_screen()

    current_drive = "C:\\"

    print("FAKEDOS.py - A 1990s prank program")
    print("Type HELP for commands, EXIT to quit (password required)")
    print()

    while True:
        try:
            prompt = current_drive[0:2] + "\\>"
            command = input(prompt).strip().upper()
        except (EOFError, KeyboardInterrupt):
            print()
            print("^C")
            print("Use EXIT command to leave DOS.")
            continue

        if not command:
            continue

        # Check for CD command first
        if command.startswith("CD "):
            path = command[3:].strip()
            handle_cd(path)
            continue

        # Drive change commands
        if command in ("A:", "A"):
            current_drive = "A:\\"
            continue
        if command in ("C:", "C"):
            current_drive = "C:\\"
            continue
        if command in ("D:", "D"):
            current_drive = "D:\\"
            continue
        if command in ("E:", "E"):
            current_drive = "E:\\"
            continue

        # Other commands
        if command == "DEL" or command.startswith("DEL "):
            handle_del()
        elif command == "UNFORMAT":
            handle_unformat()
        elif command == "VER":
            handle_ver()
        elif command == "DIR" or command == "MOO":
            # Easter egg: MOO also shows DIR
            handle_dir()
        elif command == "EXIT":
            if handle_exit():
                break
        elif command == "COMMAND":
            fake_delay(1)
        elif command == "CLS":
            print_squids_rule()
        elif command == "HELP" or command == "?":
            handle_help()
        else:
            fake_delay(3)
            print("Bad command or file name")


if __name__ == "__main__":
    main()
