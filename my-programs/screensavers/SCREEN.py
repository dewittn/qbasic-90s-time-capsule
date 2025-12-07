#!/usr/bin/env python3
"""
SCREEN.py - Color-Cycling Polygon Screensaver

Original: SCREEN.BAS (93 lines, ~1995)
Converted to modern Python with pygame

A 20-point bouncing polygon with smooth RGB palette manipulation.
Uses VGA PALETTE command technique for smooth color transitions,
with RGB values derived from vertex positions creating a flowing
color effect.

Controls:
  ESC or close window to quit
"""

import pygame
import sys
import random


# VGA Screen 12 dimensions
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

# Number of vertices in the polygon
NUM_POINTS = 20


def main():
    pygame.init()
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("SCREEN.py - Color-Cycling Polygon (ESC to quit)")
    clock = pygame.time.Clock()

    # Initialize vertex positions (using xy/yy arrays like original)
    # Original had xx, yy, yx, xy but only used xy/yy for drawing
    xy = [random.randint(1, SCREEN_WIDTH) for _ in range(NUM_POINTS)]
    yy = [random.randint(1, SCREEN_HEIGHT) for _ in range(NUM_POINTS)]

    # Also track xx/yx even though original only drew xy/yy connections
    xx = [random.randint(1, SCREEN_WIDTH) for _ in range(NUM_POINTS)]
    yx = [random.randint(1, SCREEN_HEIGHT) for _ in range(NUM_POINTS)]

    # Direction arrays
    dir_xx = [1 for _ in range(NUM_POINTS)]
    dir_xy = [1 for _ in range(NUM_POINTS)]
    dir_yx = [1 for _ in range(NUM_POINTS)]
    dir_yy = [1 for _ in range(NUM_POINTS)]

    # Blue color oscillation (original: blue cycles 1-63, bld toggles direction)
    blue = 0
    blue_direction = 1

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False

        # Update directions when hitting edges
        for i in range(NUM_POINTS):
            if xx[i] >= SCREEN_WIDTH:
                dir_xx[i] = -random.randint(1, 3)
            if xx[i] <= 0:
                dir_xx[i] = random.randint(1, 3)
            if xy[i] >= SCREEN_WIDTH:
                dir_xy[i] = -random.randint(1, 3)
            if xy[i] <= 0:
                dir_xy[i] = random.randint(1, 3)
            if yx[i] >= SCREEN_HEIGHT:
                dir_yx[i] = -random.randint(1, 3)
            if yx[i] <= 0:
                dir_yx[i] = random.randint(1, 3)
            if yy[i] >= SCREEN_HEIGHT:
                dir_yy[i] = -random.randint(1, 3)
            if yy[i] <= 0:
                dir_yy[i] = random.randint(1, 3)

        # Clear screen
        screen.fill((0, 0, 0))

        # Calculate color using original's palette math
        # Original: PALETTE 1, 65536 * blue + 256 * green + red
        # VGA palette values were 0-63, we scale to 0-255
        blue += blue_direction
        if blue >= 63:
            blue_direction = -1
        if blue <= 1:
            blue_direction = 1

        # Original derived green/red from vertex positions
        # green = ABS(INT(xx(1) * .098))
        # red = ABS(INT(yy(1) * .13))
        green = abs(int(xx[0] * 0.098))
        red = abs(int(yy[0] * 0.13))

        # Scale from VGA (0-63) to modern (0-255)
        scaled_blue = min(255, blue * 4)
        scaled_green = min(255, green * 4)
        scaled_red = min(255, red * 4)

        color = (scaled_red, scaled_green, scaled_blue)

        # Draw polygon connecting adjacent xy/yy points
        for i in range(NUM_POINTS - 1):
            pygame.draw.line(
                screen,
                color,
                (xy[i], yy[i]),
                (xy[i + 1], yy[i + 1])
            )

        # Close the polygon (connect last to first)
        pygame.draw.line(
            screen,
            color,
            (xy[0], yy[0]),
            (xy[NUM_POINTS - 1], yy[NUM_POINTS - 1])
        )

        # Update all positions
        for i in range(NUM_POINTS):
            xx[i] += dir_xx[i]
            yy[i] += dir_yy[i]
            xy[i] += dir_xy[i]
            yx[i] += dir_yx[i]

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
