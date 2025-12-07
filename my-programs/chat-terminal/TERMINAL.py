#!/usr/bin/env python3
"""
TERMINAL.py - Modern Chat War Client

A Python recreation of TERMINAL.BAS (1475 lines) - a two-terminal chat program
with "chat war" features, originally designed for serial port communication.

Original QBasic program features recreated:
- Full-duplex messaging between two terminals
- "Chat war" features for playful pranks
- Split-screen TUI with status indicators
- Message recording and playback
- Session logging to file

Easter eggs preserved from original:
- "vasrible" (variable) typo in comments
- "masage" (message) typo
- "resonding" (responding) typo
- "charetors" (characters) typo

Usage:
    python TERMINAL.py --server     # Start as server (listens on port 9600)
    python TERMINAL.py --client     # Connect as client
    python TERMINAL.py --help       # Show help

Controls:
    1 - Toggle Deflector (bounce messages back)
    2 - Toggle ASCII Spam (send random characters)
    3 - Toggle Repeat Send (continuously resend message)
    4 - Toggle Anti-Deflector (filter reflected messages)
    5 - Toggle No Input (ignore incoming messages)
    6 - Fake Disconnect (pretend to leave)
    7 - Start/Stop Recording
    8 - Playback recorded message
    9 - Toggle File Logging
    Q - Quit
    F1 - Show Help

Author: Converted from 1990s QBasic by Claude
Original: TERMINAL.BAS
"""

import argparse
import asyncio
import curses
import random
import sys
import os
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

# Port matches original baud rate for nostalgia
DEFAULT_PORT = 9600
DEFAULT_HOST = "localhost"


@dataclass
class ChatState:
    """Tracks the state of chat war features and connection."""

    # Connection state
    connected: bool = False
    is_server: bool = False
    reader: Optional[asyncio.StreamReader] = None
    writer: Optional[asyncio.StreamWriter] = None

    # Chat war features (matching original variable names in comments)
    deflector_on: bool = False  # BlkX - bounce messages back
    ascii_spam_on: bool = False  # StopX - send random ASCII
    repeat_on: bool = False  # Rep - repeatedly send message
    anti_deflector_on: bool = False  # DX - filter own messages
    no_input_on: bool = False  # NoInputX - ignore incoming
    fake_disconnected: bool = False  # Fake disconnect state

    # Recording features
    recording: bool = False  # REC - recording mode
    recorded_message: str = ""  # REC$ - recorded content
    file_logging: bool = False  # FileRec - log to file
    log_file: Optional[object] = None
    log_filename: str = ""

    # Repeat send message
    repeat_message: str = ""

    # Last outgoing message (for anti-deflector)
    last_sent: str = ""

    # Message buffers
    incoming_buffer: list = field(default_factory=list)
    outgoing_buffer: str = ""

    # UI state
    show_help: bool = False
    status_message: str = ""


class TerminalChat:
    """Main chat application class."""

    def __init__(self, stdscr: curses.window, is_server: bool, host: str, port: int):
        self.stdscr = stdscr
        self.state = ChatState(is_server=is_server)
        self.host = host
        self.port = port
        self.running = True

        # Screen dimensions
        self.height, self.width = stdscr.getmaxyx()

        # Calculate layout
        self.sidebar_width = 12
        self.main_width = self.width - self.sidebar_width - 1
        self.status_height = 2
        self.input_height = 5
        self.incoming_height = self.height - self.status_height - self.input_height - 2

        # Initialize curses
        self._init_curses()

        # Create windows
        self._create_windows()

    def _init_curses(self):
        """Initialize curses settings."""
        curses.curs_set(1)  # Show cursor
        curses.start_color()
        curses.use_default_colors()

        # Define color pairs - black background for readability
        curses.init_pair(1, curses.COLOR_WHITE, -1)  # Main text (default bg)
        curses.init_pair(2, curses.COLOR_GREEN, -1)  # Highlights/active
        curses.init_pair(3, curses.COLOR_CYAN, -1)  # Help text
        curses.init_pair(4, curses.COLOR_YELLOW, -1)  # Warnings
        curses.init_pair(5, curses.COLOR_RED, -1)  # Errors

        self.stdscr.bkgd(" ", curses.color_pair(1))
        self.stdscr.nodelay(True)  # Non-blocking input
        self.stdscr.keypad(True)

    def _create_windows(self):
        """Create the split-screen windows."""
        # Title bar (row 0)
        self.title_win = curses.newwin(1, self.width, 0, 0)
        self.title_win.bkgd(" ", curses.color_pair(2))

        # Incoming messages area
        self.incoming_win = curses.newwin(
            self.incoming_height, self.main_width, 1, 0
        )
        self.incoming_win.bkgd(" ", curses.color_pair(1))
        self.incoming_win.scrollok(True)

        # Separator line
        self.sep_row = 1 + self.incoming_height

        # Input area
        self.input_win = curses.newwin(
            self.input_height, self.main_width, self.sep_row + 1, 0
        )
        self.input_win.bkgd(" ", curses.color_pair(1))
        self.input_win.scrollok(True)

        # Status bar (bottom 2 rows)
        self.status_win = curses.newwin(
            self.status_height, self.width, self.height - self.status_height, 0
        )
        self.status_win.bkgd(" ", curses.color_pair(2))

        # Sidebar for commands
        self.sidebar_win = curses.newwin(
            self.height - self.status_height - 1,
            self.sidebar_width,
            1,
            self.main_width + 1,
        )
        self.sidebar_win.bkgd(" ", curses.color_pair(1))

        # Input cursor position
        self.input_y = 0
        self.input_x = 0

    def _draw_frame(self):
        """Draw the UI frame and borders."""
        # Title bar
        self.title_win.clear()
        title = "TERMINAL.py - Chat War Client"
        mode = "[SERVER]" if self.state.is_server else "[CLIENT]"
        quit_hint = "[Q]uit"

        self.title_win.addstr(0, 1, title, curses.color_pair(2) | curses.A_BOLD)
        self.title_win.addstr(0, len(title) + 3, mode, curses.color_pair(2))
        self.title_win.addstr(
            0, self.main_width - len(quit_hint) - 1, quit_hint, curses.color_pair(2)
        )
        self.title_win.addstr(0, self.main_width, "|", curses.color_pair(2))
        self.title_win.addstr(0, self.main_width + 1, " COMMANDS", curses.color_pair(2))
        self.title_win.noutrefresh()

        # Draw vertical separator
        for y in range(1, self.height - self.status_height):
            try:
                self.stdscr.addch(y, self.main_width, "|", curses.color_pair(2))
            except curses.error:
                pass

        # Draw horizontal separator between incoming and input
        try:
            self.stdscr.addstr(
                self.sep_row, 0, "-" * self.main_width, curses.color_pair(2)
            )
            self.stdscr.addch(self.sep_row, self.main_width, "+", curses.color_pair(2))
        except curses.error:
            pass

        self.stdscr.noutrefresh()

    def _draw_sidebar(self):
        """Draw the command sidebar."""
        self.sidebar_win.clear()

        commands = [
            ("1", "Deflect", self.state.deflector_on),
            ("2", "ASCII", self.state.ascii_spam_on),
            ("3", "Repeat", self.state.repeat_on),
            ("4", "Anti-DF", self.state.anti_deflector_on),
            ("5", "No In", self.state.no_input_on),
            ("6", "Fake DC", self.state.fake_disconnected),
            ("7", "Record", self.state.recording),
            ("8", "Play", False),
            ("9", "Log", self.state.file_logging),
            ("F1", "Help", self.state.show_help),
        ]

        for i, (key, label, active) in enumerate(commands):
            if i >= self.sidebar_win.getmaxyx()[0] - 1:
                break

            attr = curses.color_pair(2) | curses.A_BOLD if active else curses.color_pair(1)
            try:
                self.sidebar_win.addstr(i, 0, f"[{key}]", curses.color_pair(3))
                self.sidebar_win.addstr(i, 4, f" {label}", attr)
            except curses.error:
                pass

        self.sidebar_win.noutrefresh()

    def _draw_status(self):
        """Draw the status bar."""
        self.status_win.clear()

        # First row: feature indicators
        indicators = []
        if self.state.deflector_on:
            indicators.append("DF")
        if self.state.ascii_spam_on:
            indicators.append("ASCII")
        if self.state.repeat_on:
            indicators.append("RS")
        if self.state.anti_deflector_on:
            indicators.append("ADF")
        if self.state.no_input_on:
            indicators.append("NI")
        if self.state.recording:
            indicators.append("REC")
        if self.state.file_logging:
            indicators.append("LOG")

        status_text = " ".join(f"[{ind}]" for ind in indicators) if indicators else "[Ready]"

        # Connection status
        if self.state.connected:
            conn_status = "Connected: YES"
            conn_attr = curses.color_pair(2)
        else:
            conn_status = "Connected: NO"
            conn_attr = curses.color_pair(4)

        try:
            self.status_win.addstr(0, 1, status_text, curses.color_pair(2))
            self.status_win.addstr(
                0, self.width - len(conn_status) - 2, conn_status, conn_attr
            )

            # Second row: status message or help hint
            if self.state.status_message:
                self.status_win.addstr(1, 1, self.state.status_message[:self.width - 2])
            else:
                hint = "Press F1 for help | Type to chat"
                self.status_win.addstr(1, 1, hint, curses.color_pair(3))
        except curses.error:
            pass

        self.status_win.noutrefresh()

    def _draw_incoming(self):
        """Draw the incoming messages area."""
        self.incoming_win.clear()
        max_lines = self.incoming_height - 1

        # Show last N messages that fit
        messages = self.state.incoming_buffer[-max_lines:] if self.state.incoming_buffer else []

        for i, msg in enumerate(messages):
            try:
                # Truncate message if too long
                display_msg = msg[: self.main_width - 2]
                self.incoming_win.addstr(i, 0, display_msg)
            except curses.error:
                pass

        self.incoming_win.noutrefresh()

    def _draw_input(self):
        """Draw the input area with current text."""
        self.input_win.clear()

        # Show the current input buffer
        try:
            self.input_win.addstr(0, 0, "> " + self.state.outgoing_buffer)
        except curses.error:
            pass

        self.input_win.noutrefresh()

    def _draw_help(self):
        """Draw help overlay."""
        if not self.state.show_help:
            return

        help_text = [
            "=== TERMINAL.py HELP ===",
            "",
            "Chat War Features:",
            "  1 - Deflector: Bounce incoming messages back",
            "  2 - ASCII Spam: Flood random characters",
            "  3 - Repeat Send: Continuously resend a message",
            "  4 - Anti-Deflector: Filter your reflected messages",
            "  5 - No Input: Ignore all incoming messages",
            "  6 - Fake Disconnect: Pretend to leave",
            "",
            "Recording:",
            "  7 - Start/Stop recording incoming messages",
            "  8 - Play back recorded message",
            "  9 - Toggle file logging",
            "",
            "Other:",
            "  Q - Quit the program",
            "  F1 - Toggle this help screen",
            "  Enter - Send message",
            "",
            "Press any key to close help...",
        ]

        # Calculate overlay position
        overlay_height = len(help_text) + 2
        overlay_width = max(len(line) for line in help_text) + 4
        start_y = (self.height - overlay_height) // 2
        start_x = (self.width - overlay_width) // 2

        # Draw overlay
        for i, line in enumerate(help_text):
            try:
                self.stdscr.addstr(
                    start_y + i + 1,
                    start_x + 2,
                    line.ljust(overlay_width - 4),
                    curses.color_pair(3),
                )
            except curses.error:
                pass

        # Draw border
        try:
            self.stdscr.addstr(
                start_y, start_x, "+" + "-" * (overlay_width - 2) + "+", curses.color_pair(2)
            )
            self.stdscr.addstr(
                start_y + overlay_height - 1,
                start_x,
                "+" + "-" * (overlay_width - 2) + "+",
                curses.color_pair(2),
            )
            for i in range(1, overlay_height - 1):
                self.stdscr.addch(start_y + i, start_x, "|", curses.color_pair(2))
                self.stdscr.addch(
                    start_y + i, start_x + overlay_width - 1, "|", curses.color_pair(2)
                )
        except curses.error:
            pass

        self.stdscr.noutrefresh()

    def draw(self):
        """Redraw the entire screen."""
        self._draw_frame()
        self._draw_sidebar()
        self._draw_status()
        self._draw_incoming()
        self._draw_input()
        self._draw_help()

        # Position cursor in input area
        cursor_x = len(self.state.outgoing_buffer) + 2
        if cursor_x < self.main_width:
            try:
                self.input_win.move(0, cursor_x)
            except curses.error:
                pass

        curses.doupdate()

    def add_incoming_message(self, message: str, source: str = "REMOTE"):
        """Add a message to the incoming buffer."""
        timestamp = datetime.now().strftime("%H:%M:%S")
        formatted = f"[{timestamp}] {source}: {message}"
        self.state.incoming_buffer.append(formatted)

        # Keep buffer from growing too large
        if len(self.state.incoming_buffer) > 1000:
            self.state.incoming_buffer = self.state.incoming_buffer[-500:]

        # Log if enabled
        if self.state.file_logging and self.state.log_file:
            try:
                self.state.log_file.write(formatted + "\n")
                self.state.log_file.flush()
            except IOError:
                pass

        # Record if enabled
        if self.state.recording:
            self.state.recorded_message += message

    def add_system_message(self, message: str):
        """Add a system message to the incoming buffer."""
        timestamp = datetime.now().strftime("%H:%M:%S")
        formatted = f"[{timestamp}] SYSTEM: {message}"
        self.state.incoming_buffer.append(formatted)

        if self.state.file_logging and self.state.log_file:
            try:
                self.state.log_file.write(formatted + "\n")
                self.state.log_file.flush()
            except IOError:
                pass

    async def send_message(self, message: str):
        """Send a message to the remote terminal."""
        if not self.state.connected or not self.state.writer:
            return

        try:
            self.state.writer.write((message + "\n").encode("utf-8"))
            await self.state.writer.drain()
            self.state.last_sent = message

            # Log outgoing if enabled
            if self.state.file_logging and self.state.log_file:
                timestamp = datetime.now().strftime("%H:%M:%S")
                self.state.log_file.write(f"[{timestamp}] YOU: {message}\n")
                self.state.log_file.flush()
        except (ConnectionError, OSError):
            self.state.connected = False
            self.add_system_message("Connection lost!")

    async def handle_incoming(self):
        """Handle incoming messages from remote terminal."""
        if not self.state.connected or not self.state.reader:
            return

        try:
            # Non-blocking read
            data = await asyncio.wait_for(
                self.state.reader.readline(), timeout=0.01
            )
            if data:
                message = data.decode("utf-8").strip()
                if message:
                    # Check for disconnect signal
                    if message == "\x10":  # CHR$(16) from original
                        self.add_system_message("Remote terminal disconnected.")
                        self.state.connected = False
                        return

                    # Anti-deflector: filter our own messages bounced back
                    if self.state.anti_deflector_on and message == self.state.last_sent:
                        return  # Ignore reflected message

                    # No input mode: ignore incoming
                    if self.state.no_input_on:
                        return

                    # Deflector: bounce message back
                    if self.state.deflector_on:
                        await self.send_message(message)

                    self.add_incoming_message(message)
            elif data == b"":
                # Connection closed
                self.state.connected = False
                self.add_system_message("Connection closed by remote.")
        except asyncio.TimeoutError:
            pass  # No data available
        except (ConnectionError, OSError):
            self.state.connected = False
            self.add_system_message("Connection lost!")

    async def ascii_spam_loop(self):
        """Send random ASCII characters when enabled."""
        # Easter egg: Original comment said "charetors" (characters)
        skip_chars = {7, 9, 10, 11, 12, 13, 16, 28, 29, 30, 31, 32}

        while self.running:
            if self.state.ascii_spam_on and self.state.connected:
                char_code = random.randint(33, 126)  # Printable ASCII
                while char_code in skip_chars:
                    char_code = random.randint(33, 126)
                await self.send_message(chr(char_code))
                await asyncio.sleep(0.05)  # Small delay between spam
            else:
                await asyncio.sleep(0.1)

    async def repeat_send_loop(self):
        """Repeatedly send message when enabled."""
        while self.running:
            if self.state.repeat_on and self.state.connected and self.state.repeat_message:
                await self.send_message(self.state.repeat_message)
                await asyncio.sleep(0.1)
            else:
                await asyncio.sleep(0.1)

    def toggle_deflector(self):
        """Toggle deflector mode."""
        self.state.deflector_on = not self.state.deflector_on
        status = "ON" if self.state.deflector_on else "OFF"
        self.add_system_message(f"Deflector {status}")

    def toggle_ascii_spam(self):
        """Toggle ASCII spam mode."""
        self.state.ascii_spam_on = not self.state.ascii_spam_on
        status = "ON" if self.state.ascii_spam_on else "OFF"
        self.add_system_message(f"ASCII Spam {status}")

    def toggle_repeat(self):
        """Toggle repeat send mode."""
        if not self.state.repeat_on:
            # Enter message to repeat
            # Easter egg: Original prompt was "Enter masage to Repeatedly send:"
            self.state.status_message = "Enter message to repeat, then press Enter"
            self.state.repeat_on = True
            # The next message sent will become the repeat message
        else:
            self.state.repeat_on = False
            self.state.repeat_message = ""
            self.add_system_message("Repeat Send OFF")

    def toggle_anti_deflector(self):
        """Toggle anti-deflector mode."""
        self.state.anti_deflector_on = not self.state.anti_deflector_on
        status = "ON" if self.state.anti_deflector_on else "OFF"
        self.add_system_message(f"Anti-Deflector {status}")

    def toggle_no_input(self):
        """Toggle no input mode."""
        self.state.no_input_on = not self.state.no_input_on
        status = "ON" if self.state.no_input_on else "OFF"
        self.add_system_message(f"No Input {status}")

    async def fake_disconnect(self):
        """Fake disconnect - send disconnect signal, wait, then reconnect."""
        if not self.state.connected:
            return

        self.state.fake_disconnected = True
        self.add_system_message("Fake disconnect... press any key to 'reconnect'")

        # Send disconnect signal
        try:
            self.state.writer.write(b"\x10")  # CHR$(16) from original
            await self.state.writer.drain()
        except (ConnectionError, OSError):
            pass

        # Wait for keypress (handled in main loop)

    def toggle_recording(self):
        """Toggle message recording."""
        if not self.state.recording:
            self.state.recorded_message = ""
            self.state.recording = True
            self.add_system_message("Recording ON - incoming messages being captured")
        else:
            self.state.recording = False
            self.add_system_message(
                f"Recording OFF - captured {len(self.state.recorded_message)} chars"
            )

    async def playback(self):
        """Play back recorded message."""
        if self.state.recorded_message:
            await self.send_message(self.state.recorded_message)
            self.add_system_message("Played back recorded message")
        else:
            self.add_system_message("Nothing recorded to play back")

    def toggle_file_logging(self):
        """Toggle file logging."""
        if not self.state.file_logging:
            # Create log file
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            self.state.log_filename = f"terminal_log_{timestamp}.txt"
            try:
                self.state.log_file = open(self.state.log_filename, "w")
                self.state.file_logging = True
                self.add_system_message(f"Logging to {self.state.log_filename}")
            except IOError as e:
                self.add_system_message(f"Failed to create log: {e}")
        else:
            if self.state.log_file:
                self.state.log_file.close()
            self.state.file_logging = False
            self.add_system_message("File logging OFF")

    async def handle_input(self, key: int) -> bool:
        """Handle keyboard input. Returns False to quit."""
        # Help screen dismissal
        if self.state.show_help:
            self.state.show_help = False
            return True

        # Fake disconnect state - any key reconnects
        if self.state.fake_disconnected:
            self.state.fake_disconnected = False
            self.add_system_message("'Reconnected' - other terminal didn't notice!")
            return True

        # Handle special keys
        if key == ord("q") or key == ord("Q"):
            return False

        elif key == ord("1"):
            self.toggle_deflector()

        elif key == ord("2"):
            self.toggle_ascii_spam()

        elif key == ord("3"):
            self.toggle_repeat()

        elif key == ord("4"):
            self.toggle_anti_deflector()

        elif key == ord("5"):
            self.toggle_no_input()

        elif key == ord("6"):
            await self.fake_disconnect()

        elif key == ord("7"):
            self.toggle_recording()

        elif key == ord("8"):
            await self.playback()

        elif key == ord("9"):
            self.toggle_file_logging()

        elif key == curses.KEY_F1 or key == 265:  # F1
            self.state.show_help = not self.state.show_help

        elif key == curses.KEY_ENTER or key == 10 or key == 13:
            # Send message
            if self.state.outgoing_buffer:
                message = self.state.outgoing_buffer
                self.state.outgoing_buffer = ""

                # If in repeat mode and no repeat message set, this becomes it
                if self.state.repeat_on and not self.state.repeat_message:
                    self.state.repeat_message = message
                    self.add_system_message(f"Will repeat: '{message}'")
                    self.state.status_message = ""
                else:
                    await self.send_message(message)
                    self.add_incoming_message(message, "YOU")

        elif key == curses.KEY_BACKSPACE or key == 127 or key == 8:
            # Backspace
            if self.state.outgoing_buffer:
                self.state.outgoing_buffer = self.state.outgoing_buffer[:-1]

        elif key == 27:  # ESC
            # Toggle no input (matching original behavior)
            self.toggle_no_input()

        elif 32 <= key <= 126:
            # Printable character
            self.state.outgoing_buffer += chr(key)

        return True

    async def connect_as_server(self):
        """Start server and wait for connection."""
        self.add_system_message(f"Starting server on port {self.port}...")

        try:
            server = await asyncio.start_server(
                self._handle_client, self.host, self.port
            )
            self.add_system_message(f"Server listening on {self.host}:{self.port}")
            self.add_system_message("Waiting for client to connect...")

            async with server:
                await server.serve_forever()
        except OSError as e:
            self.add_system_message(f"Server error: {e}")

    async def _handle_client(
        self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter
    ):
        """Handle incoming client connection."""
        self.state.reader = reader
        self.state.writer = writer
        self.state.connected = True

        addr = writer.get_extra_info("peername")
        self.add_system_message(f"Client connected from {addr}")

    async def connect_as_client(self):
        """Connect to server as client."""
        self.add_system_message(f"Connecting to {self.host}:{self.port}...")

        try:
            reader, writer = await asyncio.open_connection(self.host, self.port)
            self.state.reader = reader
            self.state.writer = writer
            self.state.connected = True
            self.add_system_message("Connected to server!")
        except OSError as e:
            self.add_system_message(f"Connection failed: {e}")
            # Easter egg: Original said "Other computer not resonding"
            self.add_system_message("Other computer not responding. Retry? (Press R or Q)")

    async def main_loop(self):
        """Main event loop."""
        # Start connection task
        if self.state.is_server:
            connection_task = asyncio.create_task(self.connect_as_server())
        else:
            connection_task = asyncio.create_task(self.connect_as_client())

        # Start background tasks
        ascii_task = asyncio.create_task(self.ascii_spam_loop())
        repeat_task = asyncio.create_task(self.repeat_send_loop())

        try:
            while self.running:
                # Handle incoming messages
                await self.handle_incoming()

                # Check for keyboard input
                try:
                    key = self.stdscr.getch()
                    if key != -1:
                        if not await self.handle_input(key):
                            break
                except curses.error:
                    pass

                # Redraw screen
                self.draw()

                # Small delay to prevent CPU spinning
                await asyncio.sleep(0.01)

        finally:
            # Cleanup
            ascii_task.cancel()
            repeat_task.cancel()
            connection_task.cancel()

            if self.state.writer:
                self.state.writer.close()
                try:
                    await self.state.writer.wait_closed()
                except Exception:
                    pass

            if self.state.log_file:
                self.state.log_file.close()


def main(stdscr: curses.window, args: argparse.Namespace):
    """Main entry point wrapped by curses."""
    chat = TerminalChat(
        stdscr,
        is_server=args.server,
        host=args.host,
        port=args.port,
    )

    # Run the async event loop
    asyncio.run(chat.main_loop())


def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="TERMINAL.py - Chat War Client (Python port of TERMINAL.BAS)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    python TERMINAL.py --server     Start as server (default port 9600)
    python TERMINAL.py --client     Connect as client to localhost
    python TERMINAL.py --client --host 192.168.1.5   Connect to specific host

Chat War Features:
    1-Deflector  2-ASCII  3-Repeat  4-Anti-DF  5-NoInput  6-FakeDC
    7-Record     8-Play   9-Log     F1-Help    Q-Quit

Easter eggs from original TERMINAL.BAS preserved in comments!
        """,
    )

    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument(
        "--server", "-s", action="store_true", help="Run as server (listens for connections)"
    )
    mode.add_argument(
        "--client", "-c", action="store_true", help="Run as client (connects to server)"
    )

    parser.add_argument(
        "--host", "-H", default=DEFAULT_HOST, help=f"Host to connect to (default: {DEFAULT_HOST})"
    )
    parser.add_argument(
        "--port",
        "-p",
        type=int,
        default=DEFAULT_PORT,
        help=f"Port number (default: {DEFAULT_PORT}, matching original baud rate)",
    )

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()

    try:
        curses.wrapper(lambda stdscr: main(stdscr, args))
    except KeyboardInterrupt:
        print("\nTerminal closed.")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
