#!/usr/bin/env python3
"""
CHAPTER4.py - Linear System Solver

Converted from: CHAPTER4.BAS (1990s QBasic)
Purpose: Solve 2-variable linear systems using the elimination method
         Shows all algebraic steps for educational purposes

Easter Eggs from original:
- "Eneter X1" typo (should be "Enter")

The program solves systems like:
  a₁x + b₁y = c₁
  a₂x + b₂y = c₂

Press Ctrl+C to quit.
"""

from math import gcd


def find_lcm(a: int, b: int) -> int:
    """Find the Least Common Multiple of two numbers."""
    return abs(a * b) // gcd(a, b) if a and b else 0


def find_multipliers(coef_1: int, coef_2: int) -> tuple[int, int]:
    """
    Find multipliers to make coefficients equal for elimination.
    Returns (mult_1, mult_2) such that coef_1 * mult_1 = coef_2 * mult_2 = LCM
    """
    if coef_1 == 0 or coef_2 == 0:
        return (1, 1)
    lcm = find_lcm(coef_1, coef_2)
    return (lcm // abs(coef_1), lcm // abs(coef_2))


def format_equation(x_coef: float, y_coef: float, answer: float, multiplier: int = 1) -> str:
    """Format an equation like '3x + 2y = 10' with proper signs."""
    x_term = x_coef * multiplier
    y_term = y_coef * multiplier
    result = answer * multiplier

    if y_term >= 0:
        return f"{x_term}x + {y_term}y = {result}"
    else:
        return f"{x_term}x {y_term}y = {result}"


def solve_by_elimination(eq1_x: float, eq1_y: float, eq1_answer: float,
                         eq2_x: float, eq2_y: float, eq2_answer: float,
                         eliminate_x: bool = True) -> tuple[float, float]:
    """
    Solve the system using elimination method.
    Shows all steps and returns (x, y) solution.
    """
    print()

    if eliminate_x:
        # Eliminate X first, solve for Y
        multiplier_1, multiplier_2 = find_multipliers(int(abs(eq1_x)), int(abs(eq2_x)))

        # Step 1: Show the multipliers being applied
        print("Step 1: Multiply equations to match x coefficients")
        print(f"  {multiplier_1}({format_equation(eq1_x, eq1_y, eq1_answer)})")
        print(f"  {multiplier_2}({format_equation(eq2_x, eq2_y, eq2_answer)})")
        print()

        # Step 2: Show expanded equations
        print("Step 2: Expand")
        print(f"  {format_equation(eq1_x, eq1_y, eq1_answer, multiplier_1)}")
        print(f"  {format_equation(eq2_x, eq2_y, eq2_answer, multiplier_2)}")
        print()

        # Calculate new coefficients after multiplication
        new_y1 = eq1_y * multiplier_1
        new_y2 = eq2_y * multiplier_2
        new_answer1 = eq1_answer * multiplier_1
        new_answer2 = eq2_answer * multiplier_2

        # Step 3: Show subtraction/addition to eliminate x
        print("Step 3: Subtract/add to eliminate x")
        print(f"  {format_equation(eq1_x, eq1_y, eq1_answer, multiplier_1)}")
        if (eq1_x > 0 and eq2_x > 0) or (eq1_x < 0 and eq2_x < 0):
            # Same signs - subtract
            print(f"- {format_equation(eq2_x, eq2_y, eq2_answer, multiplier_2)}")
            result_y = new_y1 - new_y2
            result_answer = new_answer1 - new_answer2
        else:
            # Different signs - add
            print(f"+ {format_equation(eq2_x, eq2_y, eq2_answer, multiplier_2)}")
            result_y = new_y1 + new_y2
            result_answer = new_answer1 + new_answer2
        print("-" * 30)

        # Step 4: Solve for Y
        print()
        print("Step 4: Solve for y")
        print(f"  {result_y}y = {result_answer}")
        y_value = result_answer / result_y
        print(f"  y = {result_answer} / {result_y}")
        print(f"  y = {y_value}")
        print()

        # Step 5: Back-substitute for X
        print("Step 5: Substitute y back into equation 1 to find x")
        x_numerator = eq1_answer - (y_value * eq1_y)
        print(f"  {eq1_x}x + {eq1_y}({y_value}) = {eq1_answer}")
        print(f"  {eq1_x}x = {x_numerator}")
        x_value = x_numerator / eq1_x
        print(f"  x = {x_numerator} / {eq1_x}")
        print(f"  x = {x_value}")

        return (x_value, y_value)

    else:
        # Eliminate Y first, solve for X
        multiplier_1, multiplier_2 = find_multipliers(int(abs(eq1_y)), int(abs(eq2_y)))

        # Step 1: Show the multipliers being applied
        print("Step 1: Multiply equations to match y coefficients")
        print(f"  {multiplier_1}({format_equation(eq1_x, eq1_y, eq1_answer)})")
        print(f"  {multiplier_2}({format_equation(eq2_x, eq2_y, eq2_answer)})")
        print()

        # Step 2: Show expanded equations
        print("Step 2: Expand")
        print(f"  {format_equation(eq1_x, eq1_y, eq1_answer, multiplier_1)}")
        print(f"  {format_equation(eq2_x, eq2_y, eq2_answer, multiplier_2)}")
        print()

        # Calculate new coefficients after multiplication
        new_x1 = eq1_x * multiplier_1
        new_x2 = eq2_x * multiplier_2
        new_answer1 = eq1_answer * multiplier_1
        new_answer2 = eq2_answer * multiplier_2

        # Step 3: Show subtraction/addition to eliminate y
        print("Step 3: Subtract/add to eliminate y")
        print(f"  {format_equation(eq1_x, eq1_y, eq1_answer, multiplier_1)}")
        if (eq1_y > 0 and eq2_y > 0) or (eq1_y < 0 and eq2_y < 0):
            # Same signs - subtract
            print(f"- {format_equation(eq2_x, eq2_y, eq2_answer, multiplier_2)}")
            result_x = new_x1 - new_x2
            result_answer = new_answer1 - new_answer2
        else:
            # Different signs - add
            print(f"+ {format_equation(eq2_x, eq2_y, eq2_answer, multiplier_2)}")
            result_x = new_x1 + new_x2
            result_answer = new_answer1 + new_answer2
        print("-" * 30)

        # Step 4: Solve for X
        print()
        print("Step 4: Solve for x")
        print(f"  {result_x}x = {result_answer}")
        x_value = result_answer / result_x
        print(f"  x = {result_answer} / {result_x}")
        print(f"  x = {x_value}")

        return (x_value, 0)  # Y not calculated in this path


def main():
    print("=" * 50)
    print("  Linear System Solver (Elimination Method)")
    print("=" * 50)
    print("\nSolves systems of the form:")
    print("  a₁x + b₁y = c₁")
    print("  a₂x + b₂y = c₂")
    print("\nShows all algebraic steps.")
    print("Press Ctrl+C to exit.\n")

    try:
        print("Enter coefficients for Equation 1:")
        # Easter egg: Original had "Eneter" typo
        eq1_x_coef = float(input("  x coefficient (a₁): "))
        eq1_y_coef = float(input("  y coefficient (b₁): "))
        eq1_answer = float(input("  answer (c₁): "))

        print("\nEnter coefficients for Equation 2:")
        eq2_x_coef = float(input("  x coefficient (a₂): "))
        eq2_y_coef = float(input("  y coefficient (b₂): "))
        eq2_answer = float(input("  answer (c₂): "))

        # Display the system
        print("\n" + "=" * 50)
        print("Solving the system:")
        print(f"  Equation 1: {format_equation(eq1_x_coef, eq1_y_coef, eq1_answer)}")
        print(f"  Equation 2: {format_equation(eq2_x_coef, eq2_y_coef, eq2_answer)}")
        print("=" * 50)

        # Solve for Y first (eliminate X)
        x_solution, y_solution = solve_by_elimination(
            eq1_x_coef, eq1_y_coef, eq1_answer,
            eq2_x_coef, eq2_y_coef, eq2_answer,
            eliminate_x=True
        )

        print("\n" + "=" * 50)
        print(f"  Solution: x = {x_solution}, y = {y_solution}")
        print("=" * 50)

        print()
        solve_alternate = input("Also solve for x using elimination on y? (y/n): ").strip().lower()
        if solve_alternate == 'y':
            solve_by_elimination(
                eq1_x_coef, eq1_y_coef, eq1_answer,
                eq2_x_coef, eq2_y_coef, eq2_answer,
                eliminate_x=False
            )

    except ValueError:
        print("Please enter valid numbers.")
    except ZeroDivisionError:
        print("Error: Division by zero - system may be inconsistent or dependent.")
    except KeyboardInterrupt:
        print("\nGoodbye!")


if __name__ == "__main__":
    main()
