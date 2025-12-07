#!/usr/bin/env python3
"""
LINES.py - Radial Lines Screensaver

Original: LINES.BAS (22 lines, ~1995)
Converted to modern Python with pygame

Draws random colored lines radiating from screen center with an
oscillating Y coordinate that creates a wave pattern.

Controls:
  ESC or close window to quit
"""

import pygame
import random
import sys
import os

# Fix for macOS window not appearing in front
os.environ['SDL_VIDEO_WINDOW_POS'] = '100,100'

# VGA Screen 12 dimensions
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
CENTER_X = 320
CENTER_Y = 240

# VGA 16-color palette (colors 1-15, skipping 0/black)
VGA_PALETTE = [
    (0, 0, 0),        # 0: Black (unused)
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
    pygame.display.set_caption("LINES.py - Radial Lines (ESC to quit)")
    clock = pygame.time.Clock()

    # macOS: Bring window to front
    if sys.platform == 'darwin':
        pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        pygame.event.pump()

    # Fill with black initially
    screen.fill((0, 0, 0))
    pygame.display.flip()

    # D oscillates between 0 and 500, creating wave pattern
    d = 0
    direction = 1  # 1 = increasing, -1 = decreasing

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False

        # Draw multiple lines per frame for faster visual effect
        for _ in range(10):
            # Pick random color (1-15, avoiding black)
            color = VGA_PALETTE[random.randint(1, 15)]

            # Random X endpoint (0-1000 in original)
            b = random.randint(0, 1000)

            # Draw line from center to (b, d)
            pygame.draw.line(screen, color, (CENTER_X, CENTER_Y), (b, d))

            # Update D with oscillation
            d += direction
            if d > 500:
                direction = -1
            elif d < 0:
                direction = 1

        pygame.display.flip()
        clock.tick(60)  # 60 FPS, drawing 10 lines per frame

    pygame.quit()
    sys.exit()


if __name__ == "__main__":
    main()
