#!/bin/bash
# QBasic Launcher for DOSBox
# Usage: ./qb.sh [PROGRAM.BAS] [run]
#   No args     - Opens QuickBASIC IDE
#   PROGRAM.BAS - Opens program in QB editor
#   PROGRAM.BAS run - Runs the program directly

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QBASIC_DIR="$(dirname "$SCRIPT_DIR")"

# Determine what to launch
PROGRAM="$1"
RUN_MODE="$2"

# Build the autoexec commands
if [ -z "$PROGRAM" ]; then
    # No program - just open QB
    QB_CMD="qbasic-runtime\\QB.EXE"
    echo "Launching QuickBASIC IDE..."
elif [ "$RUN_MODE" = "run" ]; then
    # Run the program directly (convert path to DOS format)
    DOS_PROGRAM=$(echo "$PROGRAM" | sed 's|/|\\|g')
    QB_CMD="qbasic-runtime\\QB.EXE /RUN $DOS_PROGRAM"
    echo "Running: $PROGRAM"
else
    # Open program in editor (convert path to DOS format)
    DOS_PROGRAM=$(echo "$PROGRAM" | sed 's|/|\\|g')
    QB_CMD="qbasic-runtime\\QB.EXE $DOS_PROGRAM"
    echo "Opening: $PROGRAM"
fi

# Create temporary DOSBox config
cat > /tmp/dosbox_qb.conf << EOF
[sdl]
fullscreen=false
output=opengl
windowresolution=800x600

[cpu]
cycles=max

[autoexec]
mount c "$QBASIC_DIR"
c:
$QB_CMD
EOF

# Detect and launch DOSBox
if [ -d "/Applications/dosbox-x.app" ]; then
    /Applications/dosbox-x.app/Contents/MacOS/dosbox-x -conf /tmp/dosbox_qb.conf 2>/dev/null
elif [ -d "/Applications/DOSBox.app" ]; then
    /Applications/DOSBox.app/Contents/MacOS/DOSBox -conf /tmp/dosbox_qb.conf 2>/dev/null
elif command -v dosbox &> /dev/null; then
    dosbox -conf /tmp/dosbox_qb.conf 2>/dev/null
else
    echo "ERROR: DOSBox not found. Please install DOSBox or DOSBox-X."
    exit 1
fi
