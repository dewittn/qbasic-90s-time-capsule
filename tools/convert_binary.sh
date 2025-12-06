#!/bin/bash
# QBasic Binary to Text Converter
# Uses DOSBox and AppleScript automation on macOS

QBASIC_DIR="/Users/dewittn/Programing/dewittn/Other/QBasic"
CONVERTED_DIR="$QBASIC_DIR/converted"

# Create converted directory if it doesn't exist
mkdir -p "$CONVERTED_DIR"

# List of binary files to convert (root directory only for first pass)
BINARY_FILES=(
    "ABLRA5.BAS"
    "ALBRA4-3.BAS"
    "ALBRA4-4.BAS"
    "ALBRA5-6.BAS"
    "ALBRE5-4.BAS"
    "ALGEBRA2.BAS"
    "ASCII.BAS"
    "BOUNCE.BAS"
    "BOUNCE2.BAS"
    "BOUNCE3.BAS"
    "CIRSTNG2.BAS"
    "CIRSTNGE.BAS"
    "CONCET4.BAS"
    "DATA.BAS"
    "END.BAS"
    "END2.BAS"
    "FAKEDOS.BAS"
    "FLYASTX.BAS"
    "FORMAT_C.BAS"
    "HAUKE.BAS"
    "JOYGRAF.BAS"
    "JOYGRAF2.BAS"
    "JOYINFO.BAS"
    "JOYSTICK.BAS"
    "JOYSTIK.BAS"
    "LINBONCE.BAS"
    "LINEA.BAS"
    "LINES.BAS"
    "MATH.BAS"
    "MATH2.BAS"
    "MATH3.BAS"
    "MONEY.BAS"
    "NWAUTO.BAS"
    "Pcswipe.bas"
    "QCARDS.BAS"
    "SCREEN.BAS"
    "SENSUB.BAS"
    "SHBONCE2.BAS"
    "SQUBONC2.BAS"
    "SQUBONC3.BAS"
    "SQUBONCE.BAS"
    "STARTUP.BAS"
    "Swipenos.bas"
    "TEST.BAS"
    "TORUS.BAS"
    "XWAUTO.BAS"
)

# Function to convert a single file
convert_file() {
    local filename="$1"
    local basename="${filename%.*}"

    echo "Converting: $filename"

    # Create a temporary DOSBox config that opens QB with this file
    cat > /tmp/dosbox_convert.conf << EOF
[sdl]
fullscreen=false
output=opengl
windowresolution=800x600

[cpu]
cycles=max

[autoexec]
mount c "$QBASIC_DIR"
c:
QB.EXE $filename
EOF

    # Launch DOSBox in background
    /Applications/dosbox-x.app/Contents/MacOS/dosbox-x -conf /tmp/dosbox_convert.conf 2>/dev/null &
    DOSBOX_PID=$!

    # Wait for DOSBox to start
    sleep 3

    # Send keystrokes via AppleScript to save as text
    # Sequence: Alt+F (File), A (Save As), Tab Tab Tab (to format), Enter (select),
    # Down (to Text), Enter (confirm), Tab Tab (to filename), Enter (save)
    osascript << 'APPLESCRIPT'
    tell application "System Events"
        -- Wait a moment for QB to fully load
        delay 1

        -- Alt+F to open File menu
        key code 3 using option down
        delay 0.3

        -- 'A' for Save As
        keystroke "a"
        delay 0.5

        -- Tab to Format field (may need adjustment)
        keystroke tab
        keystroke tab
        delay 0.2

        -- Space or Enter to open format dropdown
        keystroke return
        delay 0.2

        -- Down arrow to select Text format
        key code 125
        delay 0.2

        -- Enter to confirm format
        keystroke return
        delay 0.2

        -- Tab back to OK/Save button
        keystroke tab
        keystroke tab
        keystroke tab
        delay 0.2

        -- Enter to save
        keystroke return
        delay 1

        -- Alt+F, X to exit QB
        key code 3 using option down
        delay 0.2
        keystroke "x"
        delay 0.5

    end tell
APPLESCRIPT

    # Wait for DOSBox to close
    sleep 2

    # Kill DOSBox if still running
    kill $DOSBOX_PID 2>/dev/null

    echo "  Done: $filename"
}

# Main conversion function for single file mode
convert_single() {
    if [ -z "$1" ]; then
        echo "Usage: $0 single <filename.bas>"
        exit 1
    fi
    convert_file "$1"
}

# Interactive mode - one file at a time with user control
convert_interactive() {
    echo "=== QBasic Binary to Text Converter (Interactive Mode) ==="
    echo ""
    echo "This will open each binary .BAS file in QuickBASIC."
    echo "For each file, manually save as Text format:"
    echo "  1. File menu (Alt+F)"
    echo "  2. Save As... (A)"
    echo "  3. Tab to Format, select 'Text'"
    echo "  4. Press Enter to save"
    echo "  5. Exit QB (Alt+F, X) to continue to next file"
    echo ""
    echo "Press Enter to start, or Ctrl+C to cancel..."
    read

    for file in "${BINARY_FILES[@]}"; do
        echo ""
        echo ">>> Opening: $file"
        echo "    (Save as Text, then exit QB to continue)"

        # Launch DOSBox with QB and this file
        cat > /tmp/dosbox_convert.conf << EOF
[sdl]
fullscreen=false
output=opengl
windowresolution=800x600

[cpu]
cycles=max

[autoexec]
mount c "$QBASIC_DIR"
c:
QB.EXE $file
EOF

        # Detect which DOSBox is installed
        if [ -d "/Applications/dosbox-x.app" ]; then
            /Applications/dosbox-x.app/Contents/MacOS/dosbox-x -conf /tmp/dosbox_convert.conf 2>/dev/null
        elif [ -d "/Applications/DOSBox.app" ]; then
            /Applications/DOSBox.app/Contents/MacOS/DOSBox -conf /tmp/dosbox_convert.conf 2>/dev/null
        elif command -v dosbox &> /dev/null; then
            dosbox -conf /tmp/dosbox_convert.conf 2>/dev/null
        else
            echo "ERROR: DOSBox not found. Please install DOSBox or DOSBox-X."
            exit 1
        fi

        echo "    Converted: $file"
    done

    echo ""
    echo "=== Conversion complete! ==="
}

# Show help
show_help() {
    echo "QBasic Binary to Text Converter"
    echo ""
    echo "Usage:"
    echo "  $0 interactive    - Convert files one at a time (manual save)"
    echo "  $0 single <file>  - Convert a single file"
    echo "  $0 list           - List all binary files that need conversion"
    echo ""
    echo "Files will be saved in-place as Text format by QuickBASIC."
}

# List files that need conversion
list_files() {
    echo "Binary tokenized files that need conversion:"
    echo ""
    for file in "${BINARY_FILES[@]}"; do
        echo "  $file"
    done
    echo ""
    echo "Total: ${#BINARY_FILES[@]} files"
    echo ""
    echo "Noose subdirectory files (convert separately):"
    echo "  Noose/B-Bots.BAS"
    echo "  Noose/BCOMPILE.BAS"
    echo "  Noose/BIT_DEMO.BAS"
    echo "  Noose/DECRYPT.BAS"
    echo "  Noose/DIALNET.BAS"
    echo "  Noose/FRACTAL.BAS"
    echo "  Noose/HDWIN.BAS"
    echo "  Noose/LINEOUT.BAS"
    echo "  Noose/LOGIX.BAS"
    echo "  Noose/MEMSCAN.BAS"
    echo "  Noose/MUS_LAB.BAS"
    echo "  Noose/PARSE.BAS"
    echo "  Noose/QPAINT.BAS"
    echo "  Noose/SANDPILE.BAS"
    echo "  Noose/SUD.BAS"
    echo "  Noose/UATTACK.BAS"
}

# Main
case "${1:-help}" in
    interactive)
        convert_interactive
        ;;
    single)
        convert_single "$2"
        ;;
    list)
        list_files
        ;;
    *)
        show_help
        ;;
esac
