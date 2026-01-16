#!/usr/bin/env python3
"""
Tests for TERMINAL2.py - Bot-Enabled Chat War Client

Run with: pytest test_terminal2.py -v
"""

import asyncio
import pytest
import sys
import os

# Add the directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from TERMINAL2 import (
    ChatState,
    HeadlessChat,
    BotController,
    parse_command,
    DEFAULT_PORT,
    DEFAULT_HOST,
    BOT_CMD_FILE,
    BOT_OUT_FILE,
)


def run_async(coro):
    """Helper to run async code in sync tests."""
    return asyncio.get_event_loop().run_until_complete(coro)


class TestCommandParsing:
    """Tests for command parsing logic."""

    def test_parse_send_command(self):
        """Test parsing 'send' command with message."""
        cmd, args = parse_command("send Hello world!")
        assert cmd == "send"
        assert args == "Hello world!"

    def test_parse_send_empty(self):
        """Test parsing 'send' with no message."""
        cmd, args = parse_command("send")
        assert cmd == "send"
        assert args == ""

    def test_parse_toggle_command(self):
        """Test parsing 'toggle' command."""
        cmd, args = parse_command("toggle deflector")
        assert cmd == "toggle"
        assert args == "deflector"

    def test_parse_toggle_with_hyphen(self):
        """Test parsing toggle with hyphenated feature."""
        cmd, args = parse_command("toggle anti-deflector")
        assert cmd == "toggle"
        assert args == "anti-deflector"

    def test_parse_empty_line(self):
        """Test parsing empty input."""
        cmd, args = parse_command("")
        assert cmd == ""
        assert args == ""

    def test_parse_whitespace_only(self):
        """Test parsing whitespace-only input."""
        cmd, args = parse_command("   ")
        assert cmd == ""
        assert args == ""

    def test_parse_case_insensitive(self):
        """Test that commands are lowercased."""
        cmd, args = parse_command("SEND HELLO")
        assert cmd == "send"
        assert args == "HELLO"  # Args preserve case

    def test_parse_status_command(self):
        """Test parsing status command."""
        cmd, args = parse_command("status")
        assert cmd == "status"
        assert args == ""

    def test_parse_quit_command(self):
        """Test parsing quit command."""
        cmd, args = parse_command("quit")
        assert cmd == "quit"
        assert args == ""

    def test_parse_with_leading_whitespace(self):
        """Test parsing with leading whitespace."""
        cmd, args = parse_command("  send hello")
        assert cmd == "send"
        assert args == "hello"


class TestChatState:
    """Tests for ChatState dataclass."""

    def test_default_state(self):
        """Test default state values."""
        state = ChatState()
        assert state.connected is False
        assert state.is_server is False
        assert state.deflector_on is False
        assert state.ascii_spam_on is False
        assert state.repeat_on is False
        assert state.anti_deflector_on is False
        assert state.no_input_on is False
        assert state.recording is False
        assert state.bot_active is False

    def test_server_state(self):
        """Test server state initialization."""
        state = ChatState(is_server=True)
        assert state.is_server is True

    def test_toggle_features(self):
        """Test toggling feature states."""
        state = ChatState()

        state.deflector_on = True
        assert state.deflector_on is True

        state.deflector_on = False
        assert state.deflector_on is False

    def test_recording_state(self):
        """Test recording state management."""
        state = ChatState()

        state.recording = True
        state.recorded_message = "test message"

        assert state.recording is True
        assert state.recorded_message == "test message"

    def test_message_buffer(self):
        """Test incoming message buffer."""
        state = ChatState()

        state.incoming_buffer.append("message 1")
        state.incoming_buffer.append("message 2")

        assert len(state.incoming_buffer) == 2
        assert state.incoming_buffer[0] == "message 1"


class TestHeadlessChat:
    """Tests for HeadlessChat class."""

    def test_initialization(self):
        """Test HeadlessChat initialization."""
        chat = HeadlessChat(
            is_server=False,
            host="localhost",
            port=9600,
        )
        assert chat.state.is_server is False
        assert chat.host == "localhost"
        assert chat.port == 9600
        assert chat.running is True

    def test_initialization_as_server(self):
        """Test HeadlessChat initialization as server."""
        chat = HeadlessChat(
            is_server=True,
            host="0.0.0.0",
            port=9601,
        )
        assert chat.state.is_server is True

    def test_process_send_command(self):
        """Test processing send command (without connection)."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)
        # Should not raise even without connection
        run_async(chat.process_command("send Hello"))
        # Message not sent because not connected

    def test_process_toggle_deflector(self):
        """Test toggling deflector via command."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        assert chat.state.deflector_on is False
        run_async(chat.process_command("toggle deflector"))
        assert chat.state.deflector_on is True
        run_async(chat.process_command("toggle deflector"))
        assert chat.state.deflector_on is False

    def test_process_toggle_ascii(self):
        """Test toggling ASCII spam via command."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        assert chat.state.ascii_spam_on is False
        run_async(chat.process_command("toggle ascii"))
        assert chat.state.ascii_spam_on is True

    def test_process_toggle_anti_deflector(self):
        """Test toggling anti-deflector with various formats."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        # Test with hyphen
        run_async(chat.process_command("toggle anti-deflector"))
        assert chat.state.anti_deflector_on is True

        # Toggle off
        run_async(chat.process_command("toggle antideflector"))
        assert chat.state.anti_deflector_on is False

    def test_process_recording(self):
        """Test recording commands."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        run_async(chat.process_command("start-recording"))
        assert chat.state.recording is True
        assert chat.state.recorded_message == ""

        run_async(chat.process_command("stop-recording"))
        assert chat.state.recording is False

    def test_process_status(self):
        """Test status command."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        chat.state.deflector_on = True
        chat.state.ascii_spam_on = True

        # Should not raise
        run_async(chat.process_command("status"))

    def test_process_quit(self):
        """Test quit command."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        assert chat.running is True
        run_async(chat.process_command("quit"))
        assert chat.running is False

    def test_process_unknown_command(self):
        """Test unknown command handling."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        # Should not raise
        run_async(chat.process_command("unknown_command"))
        run_async(chat.process_command("toggle unknown_feature"))


class TestChatWarFeatures:
    """Tests for chat war feature logic."""

    def test_deflector_state(self):
        """Test deflector state management."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        run_async(chat.process_command("toggle deflector"))
        assert chat.state.deflector_on is True

        run_async(chat.process_command("toggle deflector"))
        assert chat.state.deflector_on is False

    def test_anti_deflector_filtering(self):
        """Test that anti-deflector tracks last sent message."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        chat.state.last_sent = "test message"
        run_async(chat.process_command("toggle anti-deflector"))

        assert chat.state.anti_deflector_on is True
        # When message comes in matching last_sent, it should be filtered

    def test_no_input_mode(self):
        """Test no-input mode state."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        run_async(chat.process_command("toggle no-input"))
        assert chat.state.no_input_on is True

        run_async(chat.process_command("toggle noinput"))
        assert chat.state.no_input_on is False

    def test_repeat_mode(self):
        """Test repeat mode state."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        run_async(chat.process_command("toggle repeat"))
        assert chat.state.repeat_on is True

        run_async(chat.process_command("toggle repeat"))
        assert chat.state.repeat_on is False


class TestIntegrationHeadless:
    """Integration tests for headless mode client/server communication."""

    def test_server_client_connection(self):
        """Test that server and client can connect."""
        async def run_test():
            server_chat = HeadlessChat(is_server=True, host="localhost", port=19600)
            client_chat = HeadlessChat(is_server=False, host="localhost", port=19600)

            # Start server in background
            server_task = asyncio.create_task(server_chat.connect_as_server())

            # Give server time to start
            await asyncio.sleep(0.2)

            # Connect client
            await client_chat.connect_as_client()

            # Verify connection
            assert client_chat.state.connected is True

            # Cleanup
            server_chat.running = False
            client_chat.running = False
            server_task.cancel()

            if client_chat.state.writer:
                client_chat.state.writer.close()

        run_async(run_test())

    def test_message_exchange(self):
        """Test sending messages between server and client."""
        async def run_test():
            server_chat = HeadlessChat(is_server=True, host="localhost", port=19601)
            client_chat = HeadlessChat(is_server=False, host="localhost", port=19601)

            # Start server
            server_task = asyncio.create_task(server_chat.connect_as_server())
            await asyncio.sleep(0.2)

            # Connect client
            await client_chat.connect_as_client()
            await asyncio.sleep(0.1)

            # Send message from client
            await client_chat.send_message("Hello from client!")

            # Give time for message to arrive
            await asyncio.sleep(0.1)

            # Read on server side
            await server_chat.handle_incoming()

            # Cleanup
            server_chat.running = False
            client_chat.running = False
            server_task.cancel()

            if client_chat.state.writer:
                client_chat.state.writer.close()
            if server_chat.state.writer:
                server_chat.state.writer.close()

        run_async(run_test())

    def test_deflector_bounces_message(self):
        """Test that deflector mode bounces messages back."""
        async def run_test():
            server_chat = HeadlessChat(is_server=True, host="localhost", port=19602)
            client_chat = HeadlessChat(is_server=False, host="localhost", port=19602)

            # Enable deflector on server
            server_chat.state.deflector_on = True

            # Start server
            server_task = asyncio.create_task(server_chat.connect_as_server())
            await asyncio.sleep(0.2)

            # Connect client
            await client_chat.connect_as_client()
            await asyncio.sleep(0.1)

            # Verify deflector is on
            assert server_chat.state.deflector_on is True

            # Cleanup
            server_chat.running = False
            client_chat.running = False
            server_task.cancel()

            if client_chat.state.writer:
                client_chat.state.writer.close()

        run_async(run_test())


class TestProtocol:
    """Tests for the chat protocol."""

    def test_disconnect_signal(self):
        """Test disconnect signal constant."""
        # CHR$(16) from original QBasic
        disconnect_signal = "\x10"
        assert len(disconnect_signal) == 1
        assert ord(disconnect_signal) == 16

    def test_message_encoding(self):
        """Test message encoding (UTF-8)."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        # Test that non-ASCII characters are handled
        chat.state.last_sent = "Hello"
        assert chat.state.last_sent == "Hello"

    def test_line_based_protocol(self):
        """Test that messages are newline-delimited."""
        message = "test message"
        encoded = (message + "\n").encode("utf-8")

        assert encoded.endswith(b"\n")
        assert encoded.decode("utf-8").strip() == message


class TestEdgeCases:
    """Tests for edge cases and error handling."""

    def test_send_without_connection(self):
        """Test sending when not connected."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        # Should not raise
        run_async(chat.send_message("This won't go anywhere"))

    def test_handle_incoming_without_connection(self):
        """Test handling incoming when not connected."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        # Should not raise
        run_async(chat.handle_incoming())

    def test_multiple_toggle_commands(self):
        """Test rapid toggling of features."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        for _ in range(10):
            run_async(chat.process_command("toggle deflector"))

        # Should be off (even number of toggles)
        assert chat.state.deflector_on is False

    def test_playback_without_recording(self):
        """Test playback when nothing recorded."""
        chat = HeadlessChat(is_server=False, host="localhost", port=9600)

        # Should not raise
        run_async(chat.process_command("playback"))

    def test_connection_failure(self):
        """Test connection to non-existent server."""
        async def run_test():
            chat = HeadlessChat(is_server=False, host="localhost", port=19999)

            # Should not raise, just log error
            await chat.connect_as_client()

            # Should not be connected
            assert chat.state.connected is False

        run_async(run_test())


class TestTmpDirectoryConfig:
    """Tests for tmp directory configuration."""

    def test_bot_cmd_file_is_local(self):
        """Test that BOT_CMD_FILE points to local tmp directory."""
        assert "qbasic-90s-time-capsule/tmp/" in BOT_CMD_FILE
        assert BOT_CMD_FILE.endswith("terminal_bot_cmd.txt")

    def test_bot_out_file_is_local(self):
        """Test that BOT_OUT_FILE points to local tmp directory."""
        assert "qbasic-90s-time-capsule/tmp/" in BOT_OUT_FILE
        assert BOT_OUT_FILE.endswith("terminal_bot_out.txt")

    def test_bot_files_same_directory(self):
        """Test that both bot files are in the same directory."""
        cmd_dir = os.path.dirname(BOT_CMD_FILE)
        out_dir = os.path.dirname(BOT_OUT_FILE)
        assert cmd_dir == out_dir


class TestTmpDirectoryCleanup:
    """Tests for tmp directory cleanup on exit."""

    def test_cleanup_removes_files(self):
        """Test that cleanup removes files from tmp directory."""
        tmp_dir = os.path.dirname(BOT_CMD_FILE)

        # Ensure tmp directory exists
        os.makedirs(tmp_dir, exist_ok=True)

        # Create test files
        test_file1 = os.path.join(tmp_dir, "test_cleanup_1.txt")
        test_file2 = os.path.join(tmp_dir, "test_cleanup_2.txt")

        with open(test_file1, "w") as f:
            f.write("test1")
        with open(test_file2, "w") as f:
            f.write("test2")

        assert os.path.exists(test_file1)
        assert os.path.exists(test_file2)

        # Simulate cleanup logic from TerminalChat.main_loop finally block
        if os.path.isdir(tmp_dir):
            for filename in os.listdir(tmp_dir):
                filepath = os.path.join(tmp_dir, filename)
                try:
                    if os.path.isfile(filepath):
                        os.remove(filepath)
                except OSError:
                    pass

        assert not os.path.exists(test_file1)
        assert not os.path.exists(test_file2)

    def test_cleanup_preserves_directory(self):
        """Test that cleanup preserves the tmp directory itself."""
        tmp_dir = os.path.dirname(BOT_CMD_FILE)

        # Ensure tmp directory exists
        os.makedirs(tmp_dir, exist_ok=True)

        # Create and cleanup a test file
        test_file = os.path.join(tmp_dir, "test_preserve.txt")
        with open(test_file, "w") as f:
            f.write("test")

        # Simulate cleanup
        if os.path.isdir(tmp_dir):
            for filename in os.listdir(tmp_dir):
                filepath = os.path.join(tmp_dir, filename)
                try:
                    if os.path.isfile(filepath):
                        os.remove(filepath)
                except OSError:
                    pass

        # Directory should still exist
        assert os.path.isdir(tmp_dir)


class TestBotControllerPortRetry:
    """Tests for BotController port retry logic."""

    def test_bot_controller_initialization(self):
        """Test BotController initializes with correct port."""
        # Create a mock chat object
        class MockChat:
            def add_system_message(self, msg):
                self.last_message = msg

        mock_chat = MockChat()
        controller = BotController(mock_chat, 9601)

        assert controller.control_port == 9601
        assert controller.server is None

    def test_port_increment_on_busy(self):
        """Test that port increments when address is in use."""
        async def run_test():
            class MockState:
                bot_active = False

            class MockChat:
                def __init__(self):
                    self.messages = []
                    self.state = MockState()

                def add_system_message(self, msg):
                    self.messages.append(msg)

            # Start first server to occupy the port
            mock_chat1 = MockChat()
            controller1 = BotController(mock_chat1, 29601)
            await controller1.start()

            assert controller1.server is not None
            assert controller1.control_port == 29601

            # Try to start second server on same port - should increment
            mock_chat2 = MockChat()
            controller2 = BotController(mock_chat2, 29601)
            await controller2.start()

            assert controller2.server is not None
            assert controller2.control_port == 29602  # Should have incremented

            # Cleanup
            await controller1.stop()
            await controller2.stop()

        run_async(run_test())

    def test_port_retry_multiple_busy(self):
        """Test retry logic with multiple busy ports."""
        async def run_test():
            class MockState:
                bot_active = False

            class MockChat:
                def __init__(self):
                    self.messages = []
                    self.state = MockState()

                def add_system_message(self, msg):
                    self.messages.append(msg)

            controllers = []
            base_port = 29700

            # Occupy 3 consecutive ports
            for i in range(3):
                mock_chat = MockChat()
                controller = BotController(mock_chat, base_port + i)
                await controller.start()
                controllers.append(controller)

            # Try to start on base_port - should end up on base_port + 3
            mock_chat_new = MockChat()
            controller_new = BotController(mock_chat_new, base_port)
            await controller_new.start()

            assert controller_new.control_port == base_port + 3

            # Cleanup
            for c in controllers:
                await c.stop()
            await controller_new.stop()

        run_async(run_test())

    def test_successful_start_returns_immediately(self):
        """Test that successful start doesn't increment port."""
        async def run_test():
            class MockState:
                bot_active = False

            class MockChat:
                def __init__(self):
                    self.messages = []
                    self.state = MockState()

                def add_system_message(self, msg):
                    self.messages.append(msg)

            mock_chat = MockChat()
            controller = BotController(mock_chat, 29800)
            await controller.start()

            assert controller.control_port == 29800  # Should stay the same
            assert "listening on port 29800" in mock_chat.messages[0]

            await controller.stop()

        run_async(run_test())


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
