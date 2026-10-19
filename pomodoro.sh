# Pomodoro timer
pomodoro() {
    local phase=${1:-work}
    local max_hours=${2:-0}

    local start_time=$(date +%s)
    local work_accumulated=0
    local sessions=0

    local focused_seconds=0
    local break_seconds=0
    local interrupted=0

    # Catch Ctrl+C
    trap 'interrupted=1' INT

    while true; do

        local duration=${pomo_options[$phase]}
        local session_start=$(date +%s)

        if [[ "$phase" == "work" ]]; then
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
            echo "🚀 Work Session $((sessions + 1))" | lolcat
        else
            echo "☕ Break" | lolcat
        fi

        timer "${duration}m"
        local timer_status=$?

        # Calculate actual time spent in this phase
        local session_end=$(date +%s)
        local elapsed=$((session_end - session_start))

        if [[ "$phase" == "work" ]]; then
            focused_seconds=$((focused_seconds + elapsed))
            work_accumulated=$((work_accumulated + elapsed))
        else
            break_seconds=$((break_seconds + elapsed))
        fi

        # Handle interruption or timer failure
        if (( interrupted == 1 )) || (( timer_status != 0 )); then
            break
        fi

        spd-say "$phase session done"

        if [[ "$phase" == "work" ]]; then

            ((sessions++))

            echo "Completed Sessions: $sessions" | lolcat
            echo "Focused: $(format_time "$focused_seconds")" | lolcat

            # Stop after maximum elapsed hours if specified
            if (( max_hours > 0 )); then
                local total_elapsed=$(( $(date +%s) - start_time ))

                if (( total_elapsed >= max_hours * 3600 )); then
                    echo "Work limit reached" | lolcat
                    spd-say "Work limit reached"
                    break
                fi
            fi

            # Long break after 4 hours of focused work
            if (( work_accumulated >= 4 * 3600 )); then

                echo "🌴 Long Break" | lolcat

                local long_start=$(date +%s)

                timer "${pomo_options["long_break"]}m"
                local long_status=$?

                local long_end=$(date +%s)

                break_seconds=$((break_seconds + long_end - long_start))

                if (( long_status != 0 )); then
                    break
                fi

                spd-say "Long break done"
                work_accumulated=0
            fi

            phase="break"

        else
            phase="work"
        fi

    done

    # Restore normal Ctrl+C handling
    trap - INT

    # Final summary
    local total_seconds=$((focused_seconds + break_seconds))

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
    echo "       DAILY SUMMARY" | lolcat
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat

    echo "Completed sessions : $sessions"
    echo "Focused time       : $(format_time "$focused_seconds")"
    echo "Break time         : $(format_time "$break_seconds")"
    echo "Total time         : $(format_time "$total_seconds")"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat

    if (( interrupted == 1 )); then
        spd-say "Session stopped"
    else
        spd-say "Session finished"
    fi
}
