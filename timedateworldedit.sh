#!/bin/zsh
# Command-line world clock by PPC 9/1/2022, GPL license

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Create preference file .world-clock.zones, if it's missing
if [ ! -f ~/GitFiles/cli_clocks/.world-clock.zones ]; then
   echo "Europe/London
   Europe/Paris
   Asia/Tokyo
   America/St_Johns
   Brazil/West" > ~/GitFiles/cli_clocks/.world-clock.zones
fi

: ${WORLDCLOCK_ZONES:=~/GitFiles/cli_clocks/.world-clock.zones}
: ${WORLDCLOCK_FORMAT:='+%Y-%m-%d %H:%M:%S %Z'}

# Function to display the world clock
function world_clock () {
   local_time=$(date "$WORLDCLOCK_FORMAT")
   
   # Display local time in green
   echo -e "${GREEN}Local Time             $local_time${RESET}"
   echo -e "${YELLOW}===============================================${RESET}"
   
   # Display time zones in cyan and format the output
   while read zone; do
      echo -e "${CYAN}$zone${RESET} ! $(TZ=$zone date "$WORLDCLOCK_FORMAT")"
   done < $WORLDCLOCK_ZONES |
      awk -F '!' '{ printf "%-20s  %s\n", $1, $2; }' |
      sort -b -r -k2,2 -k3,3
}

# Function to display the calendar
function date_ncal () {
    echo
    # Get the current day of the month
    current_day=$(date +%-d)

    # Display the calendar for the current month and highlight the current day in red
    ncal | awk -v current_day="$current_day" -v RED='\033[0;31m' -v WHITE='\033[1;37m' '
    {
        # Replace only the current day in the calendar output with a red square
        for (i = 1; i <= NF; i++) {
            if ($i == current_day) {
                $i = RED "[" $i "]" WHITE
            }
        }
        print $0
    }'
   echo -e "${YELLOW}===============================================${RESET}"
 }


# Function to display the calendar
 function date_ncal3 () {
    echo
    # Display calendar in white
    cal=$(ncal -w3)
    echo -e "${WHITE}$cal${RESET}"
 }

# Export the functions
export -f world_clock
export -f date_ncal
export -f date_ncal3

# Clear the screen and run the world clock and calendar
clear

while true; do
   world_clock
   date_ncal
   date_ncal3
   sleep 60
   clear
done

