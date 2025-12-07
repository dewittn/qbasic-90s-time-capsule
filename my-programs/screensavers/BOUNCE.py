#!/usr/bin/env python3
"""
BOUNCE.py - Bouncing Circle Screensaver

Original: BOUNCE.BAS (25 lines, ~1995)
Converted to modern Python with pygame

Animated bouncing circle with a line connecting to screen center.
Circle bounces off edges and changes color randomly. Radius grows
and shrinks, controllable with spacebar.

Controls:
  SPACE - Toggle radius growth on/off
  ESC or close window to quit
"""

import pygame
import random
import sys


# VGA Screen 12 dimensions
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
CENTER_X = SCREEN_WIDTH // 2
CENTER_Y = SCREEN_HEIGHT // 2

# VGA 16-color palette (colors 1-14 for variety)
VGA_PALETTE = [
    (0, 0, 0),        # 0: Black (background)
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


def main():
    pygame.init()
    screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    pygame.display.set_caption("BOUNCE.py - Bouncing Circle (SPACE=toggle size, ESC=quit)")
    clock = pygame.time.Clock()

    # Circle state
    x = CENTER_X
    y = CENTER_Y
    radius = 20
    dir_x = 2
    dir_y = 2
    radius_change = 1
    radius_active = True  # radon = -1 in original means active

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                elif event.key == pygame.K_SPACE:
                    radius_active = not radius_active

        # Bounce off edges (check with radius)
        if x - radius <= 0:
            dir_x = random.randint(1, 3)
        if x + radius >= SCREEN_WIDTH:
            dir_x = -random.randint(1, 3)
        if y - radius <= 0:
            dir_y = random.randint(1, 3)
        if y + radius >= SCREEN_HEIGHT:
            dir_y = -random.randint(1, 3)

        # Radius bounds
        if radius >= 100:
            radius_change = -1
        if radius <= 5:
            radius_change = 1

        # Clear screen (original erased old shapes individually, we just clear)
        screen.fill((0, 0, 0))

        # Pick random color for circle
        color = VGA_PALETTE[random.randint(1, 14)]

        # Draw line from center to circle position
        pygame.draw.line(screen, (255, 255, 255), (CENTER_X, CENTER_Y), (x, y))

        # Draw circle
        pygame.draw.circle(screen, color, (x, y), radius, 1)

        # Update position
        x += dir_x
        y += dir_y

        # Update radius if active
        if radius_active:
            radius += radius_change

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
