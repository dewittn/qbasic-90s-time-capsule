#!/usr/bin/env python3
"""
bot_bridge.py - Simple TCP bridge for Claude Code to control TERMINAL2.py

Connects to TERMINAL2's control port and provides stdin/stdout interface.

Usage:
    python bot_bridge.py [--port PORT] [--host HOST]

Commands (send via stdin):
    send <message>     Send a chat message
    toggle <feature>   Toggle: deflector, ascii, repeat, antideflector, noinput
    status             Show current feature status
    quit               Disconnect

Messages from the chat appear on stdout.

Example:
    python bot_bridge.py --port 9601
    > send Hello from Claude!
    > toggle deflector
    > status
"""

import argparse
import asyncio
import sys

DEFAULT_HOST = "localhost"
DEFAULT_PORT = 9601


async def read_socket(reader: asyncio.StreamReader, running: list):
    """Read from socket and print to stdout."""
    try:
        while running[0]:
            try:
                data = await asyncio.wait_for(reader.readline(), timeout=0.1)
                if data:
                    message = data.decode("utf-8").rstrip()
                    print(message, flush=True)
                elif data == b"":
                    print("[BRIDGE] Connection closed by server", flush=True)
                    running[0] = False
                    break
            except asyncio.TimeoutError:
                pass
    except (ConnectionError, OSError) as e:
        print(f"[BRIDGE] Connection error: {e}", flush=True)
        running[0] = False


async def read_stdin(writer: asyncio.StreamWriter, running: list):
    """Read from stdin and send to socket."""
    loop = asyncio.get_event_loop()
    reader = asyncio.StreamReader()
    protocol = asyncio.StreamReaderProtocol(reader)
    await loop.connect_read_pipe(lambda: protocol, sys.stdin)

    try:
        while running[0]:
            try:
                line = await asyncio.wait_for(reader.readline(), timeout=0.1)
                if line:
                    command = line.decode("utf-8").strip()
                    if command:
                        writer.write((command + "\n").encode("utf-8"))
                        await writer.drain()
                        if command.lower() == "quit":
                            running[0] = False
                            break
                elif line == b"":
                    # EOF on stdin
                    running[0] = False
                    break
            except asyncio.TimeoutError:
                pass
    except (ConnectionError, OSError) as e:
        print(f"[BRIDGE] Send error: {e}", flush=True)
        running[0] = False


async def main(host: str, port: int):
    """Main bridge loop."""
    print(f"[BRIDGE] Connecting to {host}:{port}...", flush=True)

    try:
        reader, writer = await asyncio.open_connection(host, port)
        print(f"[BRIDGE] Connected! Type commands or 'quit' to exit.", flush=True)
        print(f"[BRIDGE] Commands: send <msg>, toggle <feature>, status, quit", flush=True)
    except OSError as e:
        print(f"[BRIDGE] Connection failed: {e}", flush=True)
        return 1

    running = [True]  # Use list for mutability in async tasks

    socket_task = asyncio.create_task(read_socket(reader, running))
    stdin_task = asyncio.create_task(read_stdin(writer, running))

    try:
        while running[0]:
            await asyncio.sleep(0.1)
    finally:
        socket_task.cancel()
        stdin_task.cancel()
        writer.close()
        try:
            await writer.wait_closed()
        except Exception:
            pass

    print("[BRIDGE] Disconnected.", flush=True)
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="TCP bridge for Claude Code to control TERMINAL2.py"
    )
    parser.add_argument(
        "--host", "-H", default=DEFAULT_HOST, help=f"Host (default: {DEFAULT_HOST})"
    )
    parser.add_argument(
        "--port", "-p", type=int, default=DEFAULT_PORT, help=f"Port (default: {DEFAULT_PORT})"
    )
    args = parser.parse_args()

    try:
        sys.exit(asyncio.run(main(args.host, args.port)))
    except KeyboardInterrupt:
        print("\n[BRIDGE] Interrupted.", flush=True)
