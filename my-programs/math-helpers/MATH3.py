#!/usr/bin/env python3
"""
MATH3.py - Advanced Quadratic Factoring

Converted from: MATH3.BAS (1990s QBasic)
Purpose: Factor quadratics of the form ax² + bx + c into (px + m)(qx + n)
         where p * q = a (handles leading coefficients)

This is the advanced version of MATH2.py that handles leading coefficients.
The algorithm tries all factor pairs of 'a' to find valid factorizations.

Press Ctrl+C to quit.
"""


def find_factorization(leading_coef: int, middle_coef: int, constant: int) -> tuple[int, int, int, int] | None:
    """
    Find a factorization for ax² + bx + c.

    Searches for p, q, m, n such that:
    - p * q = a (factor pairs of leading coefficient)
    - m * n = c (factor pairs of constant)
    - p*n + q*m = b (cross multiplication gives middle term)

    Returns (p, m, q, n) for (px + m)(qx + n) if found, None if unfactorable.
    """
    if leading_coef == 0 or constant == 0:
        return None

    # Try all factor pairs of the leading coefficient
    for first_leading_factor in range(1, abs(leading_coef) + 1):
        for second_leading_factor in range(1, abs(leading_coef) + 1):
            if first_leading_factor * second_leading_factor != leading_coef:
                continue

            # Now try factor pairs of constant based on signs
            if middle_coef > 0:
                if constant > 0:
                    # Both constant factors positive
                    for first_const_factor in range(1, abs(constant) + 1):
                        for second_const_factor in range(1, abs(constant) + 1):
                            if (first_const_factor * second_const_factor == constant and
                                (first_const_factor * second_leading_factor) +
                                    (second_const_factor * first_leading_factor) == middle_coef):
                                return (first_leading_factor, first_const_factor,
                                        second_leading_factor, second_const_factor)
                else:
                    # constant < 0: constant factors have opposite signs
                    for first_const_factor in range(-1, constant - 1, -1):
                        for second_const_factor in range(-1, constant - 1, -1):
                            if (first_const_factor * -second_const_factor == constant and
                                (first_const_factor * second_leading_factor) +
                                    (-second_const_factor * first_leading_factor) == middle_coef):
                                return (first_leading_factor, -first_const_factor,
                                        second_leading_factor, -second_const_factor)
            else:
                # middle_coef <= 0
                if constant > 0:
                    # Both constant factors negative (to get negative middle)
                    for first_const_factor in range(1, abs(constant) + 1):
                        for second_const_factor in range(1, abs(constant) + 1):
                            if ((-first_const_factor) * (-second_const_factor) == constant and
                                (-first_const_factor * second_leading_factor) +
                                    (-second_const_factor * leading_coef) == middle_coef):
                                return (first_leading_factor, -first_const_factor,
                                        second_leading_factor, -second_const_factor)
                else:
                    # constant < 0: constant factors have opposite signs
                    for first_const_factor in range(-1, constant - 1, -1):
                        for second_const_factor in range(-1, constant - 1, -1):
                            if ((-first_const_factor) * second_const_factor == constant and
                                (-first_const_factor * second_leading_factor) +
                                    (second_const_factor * first_leading_factor) == middle_coef):
                                return (first_leading_factor, first_const_factor,
                                        second_leading_factor, -second_const_factor)

    return None


def format_binomial_with_coefficient(var_coef: int, variable: str, constant: int) -> str:
    """Format a binomial factor like (2x + 3) or (x - 2)."""
    if var_coef == 1:
        var_part = variable
    else:
        var_part = f"{var_coef}{variable}"

    if constant >= 0:
        return f"({var_part} + {constant})"
    else:
        return f"({var_part} - {abs(constant)})"


def format_quadratic(variable: str, leading: int, middle: int, constant: int) -> str:
    """Format a quadratic equation like 2x² + 3x - 5."""
    result = ""

    # Leading term
    if leading == 1:
        result = f"{variable}²"
    else:
        result = f"{leading}{variable}²"

    # Middle term
    if middle >= 0:
        result += f" + {middle}{variable}"
    else:
        result += f" - {abs(middle)}{variable}"

    # Constant term
    if constant >= 0:
        result += f" + {constant}"
    else:
        result += f" - {abs(constant)}"

    return result


def main():
    print("=" * 50)
    print("  Advanced Quadratic Factoring")
    print("  Factor ax² + bx + c into (px + m)(qx + n)")
    print("=" * 50)
    print("\nEnter 0 for leading or constant coefficient to quit.")
    print("Press Ctrl+C to exit at any time.\n")

    while True:
        try:
            variable_letter = input("Enter variable letter (default 'x'): ").strip() or "x"

            leading_input = input("Enter leading coefficient (a): ")
            leading_coefficient = int(leading_input) if leading_input.strip() else 0
            if leading_coefficient == 0:
                print("Goodbye!")
                break

            middle_input = input("Enter middle coefficient (b): ")
            middle_coefficient = int(middle_input) if middle_input.strip() else 0

            constant_input = input("Enter constant term (c): ")
            constant_term = int(constant_input) if constant_input.strip() else 0
            if constant_term == 0:
                print("Goodbye!")
                break

            # Display the equation being factored
            equation = format_quadratic(variable_letter, leading_coefficient,
                                        middle_coefficient, constant_term)
            print(f"\nFactoring: {equation}")

            # Find the factorization
            result = find_factorization(leading_coefficient, middle_coefficient, constant_term)

            if result:
                first_var_coef, first_const, second_var_coef, second_const = result
                first_binomial = format_binomial_with_coefficient(
                    first_var_coef, variable_letter, first_const)
                second_binomial = format_binomial_with_coefficient(
                    second_var_coef, variable_letter, second_const)
                print(f"Result: {first_binomial}{second_binomial}")
            else:
                print("Prime")  # Cannot be factored over integers

            print()

        except ValueError:
            print("Please enter valid integers.\n")
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break


if __name__ == "__main__":
    main()
