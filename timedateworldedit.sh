#!/bin/zsh
# Command-line world clock by PPC 9/1/2022, GPL license
#Adapted from https://gist.github.com/rangersmyth74/4c7e291b64d48c1beb7029e9b07b6bca
#and from examples over at stackoverflow like over at https://stackoverflow.com/questions/370075/command-line-world-clock

# create preference file .world-clock.zones, if it's missing
if [ ! -f ~/GitFiles/mac_dotfiles/cli_clocks/.world-clock.zones ]; then
   echo "Europe/London
   Europe/Paris
   Asia/Tokyo
   America/St_Johns
   Brazil/West" > ~/GitFiles/mac_dotfiles/cli_clocks/.world-clock.zones
fi

: ${WORLDCLOCK_ZONES:=~/GitFiles/mac_dotfiles/cli_clocks/.world-clock.zones}
: ${WORLDCLOCK_FORMAT:='+%Y-%m-%d %H:%M:%S %Z'}

function world-clock ()
{
   echo
   echo "               CLI World Clock:"
   echo
   local_time=$(date "$WORLDCLOCK_FORMAT")
   echo "Local Time            $local_time"
   echo

   while read zone
   do echo $zone '!' $(TZ=$zone date "$WORLDCLOCK_FORMAT")
   done < $WORLDCLOCK_ZONES |
      awk -F '!' '{ printf "%-20s  %s\n", $1, $2;}' |
      sort -b -r -k2,2 -k3,3
   echo
}

export -f world-clock
clear

while true;
do
      world-clock;
         sleep 1;
            clear
         done
