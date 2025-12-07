#!/usr/bin/env python3
"""
SQUBONC3.py - Configurable Bouncing Polygons Screensaver

Original: SQUBONC3.BAS (100 lines, ~1995)
Converted to modern Python with pygame

Multiple bouncing polygon shapes where each vertex bounces
independently, connected by lines to form morphing polygons.

Easter eggs preserved from original:
  - "figers" (figures) typo in prompt
  - "pionts" (points) typo in prompt

Controls:
  ESC or close window to quit
"""

import pygame
import random
import sys


# VGA Screen 12 dimensions
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

# VGA 16-color palette
VGA_PALETTE = [
    (0, 0, 0),        # 0: Black
    (0, 0, 170),      # 1: Blue
    (0, 170, 0),      # 2: Green
    (0, 170, 170),    # 3: Cyan
    (170, 0, 0),      # 4: Red
    (170, 0, 170),    # 5: Magenta
    (170, 85, 0),     # 6: Brown
    (170, 170, 170),  # 7: Light Gray
    (85, 85, 85),     # 8: Dark Gray
    (85, 85, 255),    # 9: Light Blue
    (85, 255, 85),    # 10: Light Green
    (85, 255, 255),   # 11: Light Cyan
    (255, 85, 85),    # 12: Light Red
    (255, 85, 255),   # 13: Light Magenta
    (255, 255, 85),   # 14: Yellow
    (255, 255, 255),  # 15: White
]


def get_config():
    """Get configuration from user via terminal prompts."""
    print("SQUBONC3.py - Bouncing Polygons Screensaver")
    print("=" * 45)
    print()

    # Easter egg: Original prompt said "figers" (figures)
    while True:
        try:
            # Easter egg: Original said "figers"
            figures = int(input('Enter number of figers (1 to 20): ') or '3')
            # Easter egg comment: Original typo was "figers" instead of "figures"
            if 1 <= figures <= 20:
                break
            print("Please enter a number between 1 and 20.")
        except ValueError:
            print("Please enter a valid number.")

    # Easter egg: Original prompt said "pionts" (points)
    while True:
        try:
            # Easter egg: Original said "pionts"
            points = int(input('Enter number of pionts for each figure (1 to 20): ') or '4')
            # Easter egg comment: Original typo was "pionts" instead of "points"
            if 1 <= points <= 20:
                break
            print("Please enter a number between 1 and 20.")
        except ValueError:
            print("Please enter a valid number.")

    print()
    print("Starting screensaver... Press ESC or close window to quit.")
    return figures, points


def main():
    # Get configuration before starting pygame
    num_figures, num_points = get_config()

    pygame.init()
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("SQUBONC3.py - Bouncing Polygons (ESC to quit)")
    clock = pygame.time.Clock()

    # Initialize vertex positions and directions for each figure
    # xx[figure][point] = x position, yx[figure][point] = y position
    positions_x = []
    positions_y = []
    directions_x = []
    directions_y = []

    for _ in range(num_figures):
        fig_x = [random.randint(1, SCREEN_WIDTH) for _ in range(num_points)]
        fig_y = [random.randint(1, SCREEN_HEIGHT) for _ in range(num_points)]
        fig_dx = [1 for _ in range(num_points)]
        fig_dy = [1 for _ in range(num_points)]
        positions_x.append(fig_x)
        positions_y.append(fig_y)
        directions_x.append(fig_dx)
        directions_y.append(fig_dy)

    # Color cycles slowly
    color_value = 1.0

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False

        # Clear screen
        screen.fill((0, 0, 0))

        # Update color (cycles through palette)
        color_value += 0.1
        if color_value > 15:
            color_value = 1
        current_color = VGA_PALETTE[int(color_value)]

        # Update and draw each figure
        for fig in range(num_figures):
            # Update directions when hitting edges
            for pt in range(num_points):
                if positions_x[fig][pt] >= SCREEN_WIDTH:
                    directions_x[fig][pt] = -random.randint(1, 3)
                if positions_x[fig][pt] <= 0:
                    directions_x[fig][pt] = random.randint(1, 3)
                if positions_y[fig][pt] >= SCREEN_HEIGHT:
                    directions_y[fig][pt] = -random.randint(1, 3)
                if positions_y[fig][pt] <= 0:
                    directions_y[fig][pt] = random.randint(1, 3)

            # Draw polygon by connecting adjacent points
            for pt in range(num_points - 1):
                pygame.draw.line(
                    screen,
                    current_color,
                    (positions_x[fig][pt], positions_y[fig][pt]),
                    (positions_x[fig][pt + 1], positions_y[fig][pt + 1])
                )

            # Connect last point back to first (close the polygon)
            pygame.draw.line(
                screen,
                current_color,
                (positions_x[fig][0], positions_y[fig][0]),
                (positions_x[fig][num_points - 1], positions_y[fig][num_points - 1])
            )

            # Update positions
            for pt in range(num_points):
                positions_x[fig][pt] += directions_x[fig][pt]
                positions_y[fig][pt] += directions_y[fig][pt]

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
