#!/usr/bin/env python3
"""
BASES.py - Number Base Conversion

Converted from: BASES.BAS (1990s QBasic)
Purpose: Convert decimal numbers to other bases and display results

The original program had an interesting feature where it displayed the
conversion result for every base from the target down to base 1.

Easter Eggs from original:
- "Enrer" typo (should be "Enter")

Press Ctrl+C to quit.
"""

import sys


def convert_decimal_to_base(decimal_number: int, target_base: int) -> str:
    """
    Convert a decimal number to the specified base.

    Args:
        decimal_number: The number in base 10 to convert
        target_base: The base to convert to (2-36)

    Returns:
        The number as a string in the new base.
        Uses letters A-Z for digits 10-35.
    """
    if decimal_number == 0:
        return "0"
    if target_base < 2:
        return str(decimal_number)

    digits = []
    remaining = abs(decimal_number)

    while remaining > 0:
        digit_value = remaining % target_base
        digits.append(digit_value)
        remaining //= target_base

    # Reverse to get most significant digit first
    digits.reverse()

    # Convert to string (use letters for bases > 10)
    result_chars = []
    for digit in digits:
        if digit < 10:
            result_chars.append(str(digit))
        else:
            result_chars.append(chr(ord('A') + digit - 10))

    result = "".join(result_chars)
    return "-" + result if decimal_number < 0 else result


def wait_for_keypress():
    """Wait for any keypress to continue."""
    try:
        import termios
        import tty
        file_descriptor = sys.stdin.fileno()
        old_settings = termios.tcgetattr(file_descriptor)
        try:
            tty.setraw(file_descriptor)
            sys.stdin.read(1)
        finally:
            termios.tcsetattr(file_descriptor, termios.TCSADRAIN, old_settings)
    except (ImportError, termios.error):
        # Fallback for Windows or non-tty environments
        input()


def main():
    print("=" * 45)
    print("  Number Base Conversion")
    print("=" * 45)
    print("\nConvert decimal numbers to other bases.")
    print("Press Ctrl+C to exit.\n")

    try:
        decimal_number = int(input("Enter the decimal number to convert: "))

        # Easter egg: Original had "Enrer" typo
        target_base = int(input("Enter the target base (2-36): "))

        if target_base < 1 or target_base > 36:
            print("Error: Base must be between 1 and 36.")
            return

        print()
        print("=" * 45)
        print(f"Converting {decimal_number} (base 10)")
        print("=" * 45)

        # Show the primary conversion
        if target_base >= 2:
            converted_result = convert_decimal_to_base(decimal_number, target_base)
            print(f"\nResult in base {target_base}: {converted_result}")

        # Ask if user wants to see all bases (original behavior)
        print()
        show_all = input("Show conversion for all bases from target down to 2? (y/n): ").strip().lower()

        if show_all == 'y':
            print("\nPress any key to see next base...")
            print("-" * 45)

            for current_base in range(target_base, 1, -1):
                converted = convert_decimal_to_base(decimal_number, current_base)
                print(f"Base {current_base:2}: {converted}")

                if current_base > 2:
                    wait_for_keypress()

            print("-" * 45)
            print("Done!")

    except ValueError:
        print("Please enter valid integers.")
    except KeyboardInterrupt:
        print("\nGoodbye!")


if __name__ == "__main__":
    main()
