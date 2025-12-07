#!/usr/bin/env python3
"""
SENSUB.py - Synthetic Division

Converted from: SENSUB.BAS (1990s QBasic)
Purpose: Perform synthetic division and show all work in a formatted table

Easter Eggs from original:
- "pulg in" typo (should be "plug in")

Synthetic division is a shortcut method for dividing a polynomial by a
linear factor (x - c). This program displays the traditional table format.

Press Ctrl+C to quit.
"""


def get_polynomial_coefficients(highest_degree: int) -> list[float]:
    """
    Get polynomial coefficients from user, from highest degree to constant.

    For a polynomial like 2x³ + 3x² - x + 5, the user enters:
    - Coefficient for x³: 2
    - Coefficient for x²: 3
    - Coefficient for x¹: -1
    - Constant term: 5

    Returns list [2, 3, -1, 5] (highest to lowest degree)
    """
    coefficients = []

    for power in range(highest_degree, -1, -1):
        if power == 0:
            prompt = "  Constant term: "
        elif power == 1:
            prompt = "  Coefficient for x: "
        else:
            prompt = f"  Coefficient for x^{power}: "

        coefficient = float(input(prompt))
        coefficients.append(coefficient)

    return coefficients


def perform_synthetic_division(coefficients: list[float], divisor: float) -> list[float]:
    """
    Perform synthetic division and return the result coefficients.

    The result has one less degree than the input polynomial.
    The last value is the remainder.
    """
    result = [0.0] * len(coefficients)
    result[0] = coefficients[0]  # Bring down first coefficient

    for i in range(1, len(coefficients)):
        carry_value = result[i - 1] * divisor
        result[i] = carry_value + coefficients[i]

    return result


def display_synthetic_division_table(coefficients: list[float], divisor: float):
    """Display the synthetic division in traditional table format."""
    result_row = [0.0] * len(coefficients)
    carry_row = [0.0] * len(coefficients)

    # Calculate spacing - need to accommodate all numbers
    column_width = 10

    # Print header
    print()
    print("Synthetic Division Table:")
    print()

    # Print divisor and original coefficients
    divisor_label = f"{divisor:g}]"
    print(f"{divisor_label:>6}", end="")
    for coef in coefficients:
        print(f"{coef:>{column_width}g}", end="")
    print()

    # Bring down first coefficient
    result_row[0] = coefficients[0]

    # Calculate carries and results
    for i in range(1, len(coefficients)):
        carry_row[i] = result_row[i - 1] * divisor
        result_row[i] = carry_row[i] + coefficients[i]

    # Print the carry row (values being added)
    print(" " * 6, end="")  # Space for divisor
    for i, carry in enumerate(carry_row):
        if i == 0:
            print(" " * column_width, end="")  # No carry for first column
        else:
            print(f"{carry:>{column_width}g}", end="")
    print()

    # Print divider line
    print("-" * (6 + column_width * len(coefficients)))

    # Print result row
    print(" " * 6, end="")
    for value in result_row:
        print(f"{value:>{column_width}g}", end="")
    print()

    # Show interpretation
    print()
    quotient_degree = len(coefficients) - 2
    if quotient_degree >= 0:
        quotient_terms = []
        for i, coef in enumerate(result_row[:-1]):
            power = quotient_degree - i
            if power == 0:
                quotient_terms.append(f"{coef:g}")
            elif power == 1:
                quotient_terms.append(f"{coef:g}x")
            else:
                quotient_terms.append(f"{coef:g}x^{power}")

        quotient_str = " + ".join(quotient_terms).replace("+ -", "- ")
        remainder = result_row[-1]

        print(f"Quotient:  {quotient_str}")
        print(f"Remainder: {remainder:g}")

        if remainder == 0:
            print(f"\nSince remainder is 0, (x - {divisor:g}) is a factor!")

    return result_row


def format_polynomial(coefficients: list[float], variable: str = "x") -> str:
    """Format a polynomial for display."""
    degree = len(coefficients) - 1
    terms = []

    for i, coef in enumerate(coefficients):
        power = degree - i
        if coef == 0:
            continue

        if power == 0:
            terms.append(f"{coef:g}")
        elif power == 1:
            if coef == 1:
                terms.append(variable)
            elif coef == -1:
                terms.append(f"-{variable}")
            else:
                terms.append(f"{coef:g}{variable}")
        else:
            if coef == 1:
                terms.append(f"{variable}^{power}")
            elif coef == -1:
                terms.append(f"-{variable}^{power}")
            else:
                terms.append(f"{coef:g}{variable}^{power}")

    result = " + ".join(terms).replace("+ -", "- ")
    return result if result else "0"


def main():
    print("=" * 50)
    print("  Synthetic Division Calculator")
    print("=" * 50)
    print("\nDivide a polynomial by (x - c)")
    print("Press Ctrl+C to exit.\n")

    try:
        while True:
            # Get polynomial degree and coefficients
            highest_degree = int(input("Enter the highest degree of the polynomial: "))
            print(f"\nEnter coefficients (from x^{highest_degree} down to constant):")
            coefficients = get_polynomial_coefficients(highest_degree)

            # Display the polynomial
            polynomial_str = format_polynomial(coefficients)
            print(f"\nPolynomial: {polynomial_str}")

            # Easter egg: Original had "pulg in" typo
            divisor_value = float(input("\nEnter the divisor value (c in 'x - c'): "))
            print(f"Dividing by: (x - {divisor_value:g})")

            while True:
                display_synthetic_division_table(coefficients, divisor_value)

                print()
                try_another = input("\nTry another division? (y/n): ").strip().lower()
                if try_another != 'y':
                    print("Goodbye!")
                    return

                change_divisor_only = input("Change only the divisor value? (y/n): ").strip().lower()
                if change_divisor_only == 'y':
                    divisor_value = float(input("Enter new divisor value: "))
                    print(f"Dividing by: (x - {divisor_value:g})")
                else:
                    print()
                    break  # Get new polynomial

    except ValueError:
        print("Please enter valid numbers.")
    except KeyboardInterrupt:
        print("\nGoodbye!")


if __name__ == "__main__":
    main()
