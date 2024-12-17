#!/bin/bash

# Ensure GUI session for Zenity
export DISPLAY=:0
xhost +SI:localuser:$(whoami)

# Directories to monitor
MONITOR_DIRS="/usr/bin /snap"

# Log file for debugging
LOG_FILE="/var/log/folder-monitor.log"

# Check if the log file is writable
if [ ! -w "$LOG_FILE" ]; then
    echo "Error: Cannot write to $LOG_FILE"
    exit 1
fi

echo "Monitoring directories: $MONITOR_DIRS" >> "$LOG_FILE"

# Monitor directories for new files (both created and moved)
inotifywait -m -r -e create -e moved_to --format '%w%f' "$MONITOR_DIRS" | while read -r new_file; do
    if [[ -x "$new_file" && ! -d "$new_file" ]]; then
        echo "New executable found: $new_file" >> "$LOG_FILE"

        # Get the base name of the file
        bin_name=$(basename "$new_file")

        # Display Zenity dialog for verification
        zenity --question --title="New Application Detected" \
            --text="Verification required: Was '$bin_name' authorized to be installed on this system?" \
            --ok-label="Yes" --cancel-label="No" --width=300

        # Check the exit status of the Zenity command
        if [[ $? -eq 0 ]]; then
            # Display next Zenity dialog for sandboxing options
            zenity --question --title="Application Processing" \
                --text="The application '$bin_name' will be sandboxed with limited functionality. To lift restrictions, we'll ask questions to configure permissions. Proceed?" \
                --ok-label="Proceed" --cancel-label="Postpone" --width=300

            if [[ $? -eq 0 ]]; then
                echo "Moving $bin_name to processing. This may take 5 minutes." >> "$LOG_FILE"
                sleep 300
                echo "Processing for $bin_name completed." >> "$LOG_FILE"
            else
                echo "User chose to postpone processing of $bin_name." >> "$LOG_FILE"

                # Zenity delay selection dialog
                delay=$(zenity --list --title="Postpone Processing" \
                    --text="How long would you like to delay processing for '$bin_name'? Note: The app may not work properly during this time." \
                    --column="Delay Duration" "10 minutes" "30 minutes" "1 hour" "3 hours" \
                    --width=300 --height=200)

                if [[ -n "$delay" ]]; then
                    echo "User selected delay: $delay" >> "$LOG_FILE"

                    case "$delay" in
                        "10 minutes") sleep_time=600 ;;
                        "30 minutes") sleep_time=1800 ;;
                        "1 hour") sleep_time=3600 ;;
                        "3 hours") sleep_time=10800 ;;
                        *) sleep_time=0 ;;  # Default to no delay
                    esac

                    echo "Delaying processing of $bin_name for $delay." >> "$LOG_FILE"
                    sleep "$sleep_time"
                else
                    echo "No delay selected. Continuing without postponement." >> "$LOG_FILE"
                fi
            fi
        else
            echo "User denied authorization for $bin_name. No further action taken." >> "$LOG_FILE"
        fi
    fi
done
