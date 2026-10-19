# FocusTimer

A lightweight Pomodoro timer(**vibe coded**) with Bash for Linux. It helps structure focused work sessions, schedule breaks, and track how much time you actually spend working.

## Features

- **60-minute work sessions** by default.
- **10-minute short breaks** between work sessions.
- **30-minute long break** after every 4 hours of accumulated focused work.
- **Completed session counter**.
- **Focused-time tracking** — records actual time spent in work sessions, including interrupted sessions.
- **Break-time tracking** — records time spent in short and long breaks.
- **Total-time summary** — combines focused time and break time.
- **Ctrl+C handling** — pressing `Ctrl+C` ends the timer and prints a summary, including time spent in the current session.
- **Optional time limit** for a Pomodoro run.

## Requirements

The script is intended for Linux and requires:

- Bash
- [`timer`](https://github.com/caarlos0/timer) command
- [`lolcat`](https://github.com/busyloop/lolcat)
- `spd-say` (provided by `speech-dispatcher`)
- Standard GNU/Linux utilities such as `date`

On Ubuntu, install the supporting packages with:

```bash
sudo apt update
sudo apt install lolcat speech-dispatcher
```

Install the `timer` command separately using its installation instructions.

Check that the commands are available:

```bash
command -v timer
command -v lolcat
command -v spd-say
```

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/focustimer.git
cd focustimer
```

Make the script executable:

```bash
chmod +x pomodoro.sh
```

Run it:

```bash
./pomodoro.sh
```

Alternatively, source the script from your `~/.bashrc` to make the `pomodoro` function available in every Bash session:

```bash
source /path/to/pomodoro.sh
```

Then reload your shell:

```bash
source ~/.bashrc
```

## Usage

### Start a Pomodoro session

```bash
pomodoro
```

This starts the default cycle:

1. 60 minutes of focused work.
2. 10 minutes of break.
3. Repeat until interrupted.

After 4 hours of accumulated focused work, the timer starts a 30-minute long break.

### Set a time limit

You can pass a maximum elapsed-time limit in hours:

```bash
pomodoro work 5
```

The current implementation checks this limit after a completed work session. The limit measures elapsed wall-clock time, including breaks.

### Stop a session

Press:

```text
Ctrl+C
```

The timer stops and prints a summary of the run.

## Example summary

```text
━━━━━━━━━━━━━━━━━━━━━━━━━━
       DAILY SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━

Completed sessions : 2
Focused time       : 2h 25m
Break time         : 20m
Total time         : 2h 45m

━━━━━━━━━━━━━━━━━━━━━━━━━━
```

An interrupted work session contributes its elapsed time to focused time, but does not count as a completed session.

## Configuration

Edit the settings near the top of the script:

```bash
declare -A pomo_options
pomo_options["work"]="60"
pomo_options["break"]="10"
pomo_options["long_break"]="30"
```

All durations are in minutes.

For example, to use 50-minute work sessions and 10-minute breaks:

```bash
pomo_options["work"]="50"
pomo_options["break"]="10"
```

The long-break threshold is configured in the Pomodoro function. By default, it is 4 hours of accumulated focused work:

```bash
if (( work_accumulated >= 4 * 3600 )); then
```

## Notes

- The summary covers one invocation of `pomodoro`; it is not a persistent daily report.
- Time is measured using elapsed seconds, so partially completed sessions are included.
- The timer tracks time spent inside work and break sessions. Time between sessions is not included.
- `spd-say` requires a working speech-dispatcher setup. You can remove the `spd-say` lines if you do not want audio announcements.

## Contributing

Suggestions, bug reports, and pull requests are welcome.
