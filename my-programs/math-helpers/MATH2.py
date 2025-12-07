#!/usr/bin/env python3
"""
MATH2.py - Simple Quadratic Factoring

Converted from: MATH2.BAS (1990s QBasic)
Purpose: Factor quadratics of the form x² + bx + c into (x+m)(x+n)

Easter Eggs from original:
- Original used cryptic "L:", "1:", "2:" prompts
- Displayed "Pime" typo when unfactorable (should be "Prime")

Press Ctrl+C to quit.
"""


def find_factor_pair(middle_coef: int, constant: int) -> tuple[int, int] | None:
    """
    Find two numbers that multiply to give the constant term
    and add to give the middle coefficient.

    For x² + bx + c, finds m and n where:
    - m * n = c (constant term)
    - m + n = b (middle coefficient)

    Returns (m, n) if found, None if unfactorable.
    """
    if constant == 0:
        return None

    # Determine the search range based on the sign of the constant
    if constant > 0:
        # Both factors have the same sign
        if middle_coef > 0:
            # Both positive
            for m in range(1, abs(constant) + 1):
                for n in range(1, abs(constant) + 1):
                    if m * n == constant and m + n == middle_coef:
                        return (m, n)
        else:
            # Both negative
            for m in range(1, abs(constant) + 1):
                for n in range(1, abs(constant) + 1):
                    if m * n == constant and -m + -n == middle_coef:
                        return (-m, -n)
    else:
        # constant < 0: factors have opposite signs
        if middle_coef > 0:
            # Larger factor is positive
            for m in range(1, abs(constant) + 1):
                for n in range(1, abs(constant) + 1):
                    if m * -n == constant and m + -n == middle_coef:
                        return (m, -n)
        else:
            # Larger factor is negative
            for m in range(1, abs(constant) + 1):
                for n in range(1, abs(constant) + 1):
                    if -m * n == constant and -m + n == middle_coef:
                        return (-m, n)

    return None


def format_binomial(variable: str, constant: int) -> str:
    """Format a binomial factor like (x + 3) or (x - 2)."""
    if constant >= 0:
        return f"({variable} + {constant})"
    else:
        return f"({variable} - {abs(constant)})"


def main():
    print("=" * 45)
    print("  Simple Quadratic Factoring")
    print("  Factor x² + bx + c into (x + m)(x + n)")
    print("=" * 45)
    print("\nEnter 0 for any coefficient to quit.")
    print("Press Ctrl+C to exit at any time.\n")

    while True:
        try:
            # Easter egg: Original prompt was just "L:"
            variable_letter = input("Enter variable letter (default 'x'): ").strip() or "x"

            # Easter egg: Original prompt was just "1:"
            middle_input = input("Enter middle coefficient (b): ")
            middle_coefficient = int(middle_input) if middle_input.strip() else 0
            if middle_coefficient == 0:
                print("Goodbye!")
                break

            # Easter egg: Original prompt was just "2:"
            constant_input = input("Enter constant term (c): ")
            constant_term = int(constant_input) if constant_input.strip() else 0
            if constant_term == 0:
                print("Goodbye!")
                break

            # Display the equation being factored
            if middle_coefficient >= 0:
                print(f"\nFactoring: {variable_letter}² + {middle_coefficient}{variable_letter} + {constant_term}")
            else:
                print(f"\nFactoring: {variable_letter}² - {abs(middle_coefficient)}{variable_letter} + {constant_term}")

            # Find the factor pair
            factors = find_factor_pair(middle_coefficient, constant_term)

            if factors:
                first_factor, second_factor = factors
                result = f"{format_binomial(variable_letter, first_factor)}{format_binomial(variable_letter, second_factor)}"
                print(f"Result: {result}")
            else:
                # Easter egg: Original typo - "Pime" instead of "Prime"
                print("Pime")  # Cannot be factored over integers

            print()

        except ValueError:
            print("Please enter valid integers.\n")
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break


if __name__ == "__main__":
    main()
