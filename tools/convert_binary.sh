#!/bin/bash
# QBasic Binary to Text Converter
# Uses DOSBox and AppleScript automation on macOS

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QBASIC_DIR="$(dirname "$SCRIPT_DIR")"

# Function to convert a single file
convert_file() {
    local filename="$1"
    local dos_filename=$(echo "$filename" | sed 's|/|\\|g')

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
qbasic-runtime\\QB.EXE $dos_filename
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
    local target_dir="${1:-.}"

    echo "=== QBasic Binary to Text Converter (Interactive Mode) ==="
    echo ""
    echo "Scanning for binary tokenized files in: $target_dir"
    echo ""

    # Find binary files (start with 0xFC byte)
    local binary_files=()
    while IFS= read -r -d '' file; do
        if [ -f "$file" ] && head -c1 "$file" | xxd -p | grep -q "^fc"; then
            binary_files+=("$file")
        fi
    done < <(find "$QBASIC_DIR/$target_dir" -name "*.BAS" -o -name "*.bas" -print0 2>/dev/null)

    if [ ${#binary_files[@]} -eq 0 ]; then
        echo "No binary tokenized files found."
        exit 0
    fi

    echo "Found ${#binary_files[@]} binary file(s):"
    for file in "${binary_files[@]}"; do
        echo "  ${file#$QBASIC_DIR/}"
    done
    echo ""
    echo "For each file, manually save as Text format:"
    echo "  1. File menu (Alt+F)"
    echo "  2. Save As... (A)"
    echo "  3. Tab to Format, select 'Text'"
    echo "  4. Press Enter to save"
    echo "  5. Exit QB (Alt+F, X) to continue to next file"
    echo ""
    echo "Press Enter to start, or Ctrl+C to cancel..."
    read

    for file in "${binary_files[@]}"; do
        local rel_path="${file#$QBASIC_DIR/}"
        local dos_path=$(echo "$rel_path" | sed 's|/|\\|g')

        echo ""
        echo ">>> Opening: $rel_path"
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
qbasic-runtime\\QB.EXE $dos_path
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

        echo "    Converted: $rel_path"
    done

    echo ""
    echo "=== Conversion complete! ==="
}

# Show help
show_help() {
    echo "QBasic Binary to Text Converter"
    echo ""
    echo "Usage:"
    echo "  $0 interactive [dir]  - Convert binary files in directory (default: all)"
    echo "  $0 single <file>      - Convert a single file"
    echo "  $0 list [dir]         - List binary files that need conversion"
    echo ""
    echo "Examples:"
    echo "  $0 list                        - List all binary files"
    echo "  $0 list 90s-shareware          - List binary files in 90s-shareware/"
    echo "  $0 interactive my-programs     - Convert files in my-programs/"
    echo "  $0 single my-programs/misc/TEST.BAS"
    echo ""
    echo "Files will be saved in-place as Text format by QuickBASIC."
}

# List files that need conversion
list_files() {
    local target_dir="${1:-.}"

    echo "Scanning for binary tokenized files in: $target_dir"
    echo ""

    local count=0
    while IFS= read -r -d '' file; do
        if [ -f "$file" ] && head -c1 "$file" | xxd -p | grep -q "^fc"; then
            echo "  ${file#$QBASIC_DIR/}"
            ((count++))
        fi
    done < <(find "$QBASIC_DIR/$target_dir" -name "*.BAS" -o -name "*.bas" -print0 2>/dev/null)

    echo ""
    echo "Total: $count binary file(s) need conversion"
}

# Main
case "${1:-help}" in
    interactive)
        convert_interactive "$2"
        ;;
    single)
        convert_single "$2"
        ;;
    list)
        list_files "$2"
        ;;
    *)
        show_help
        ;;
esac
