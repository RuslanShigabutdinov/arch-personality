#!/bin/bash
# A robust wofi toggle script using a PID file.

PID_FILE="/tmp/wofi_toggle.pid"

# Check if the PID file exists AND if the process it points to is actually running.
if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null; then
    # If both are true, the window is open. Kill the process and remove the file.
    kill "$(cat "$PID_FILE")"
    rm "$PID_FILE"
else
    # If the file doesn't exist, or the process isn't running (stale PID file),
    # we need to launch wofi.
    
    # Ensure any stale PID file is gone before we start.
    rm -f "$PID_FILE"
    
    # Launch wofi in the background.
    wofi &
    
    # Immediately save the new, correct PID to our PID file.
    echo $! > "$PID_FILE"
fi
