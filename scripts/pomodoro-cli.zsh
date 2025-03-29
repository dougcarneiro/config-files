# Pomodoro-CLI
# Requires https://github.com/caarlos0/timer to be installed
# Requires spd-say to be installed (speech-dispatcher-utils)
# Requires lolcat to be installed (lolcat)

declare -A pomo_options
pomo_options["study"]="25"
pomo_options["work"]="45"
pomo_options["break"]="10"
pomo_options["light-break"]="5"

pomodoro-cli () {
  val=$1
  custom_time=$2

  if [[ "$val" =~ ^[0-9]+$ ]]; then
    # Caso first argument is a number
    duration="${val}m"
    message="custom timer for $val minutes ⏱️"
  
  elif [ -n "$val" ] && [[ ${pomo_options["$val"]+_} ]]; then
    # Case it is a valid option
    case $val in
      "work")        message="we are working now 💼" ;;
      "break")       message="it's break time, alright 😌" ;;
      "light-break") message="let's take a small break 🕔" ;;
      "study")       message="let's study now 📚" ;;
    esac

    if [[ "$custom_time" =~ ^[0-9]+$ ]]; then
      duration="${custom_time}m"
    else
      duration="${pomo_options["$val"]}m"
    fi

  else
    echo "Usage: pomodoro-cli [study|work|break|light-break] [optional: minutes]"
    echo "     pomodoro-cli [minutes] # simple timer"
    return 1
  fi

  echo "$message" | lolcat
  timer --format 24h "$duration"

  if [ $? -eq 0 ]; then
    spd-say -i -80 "'$val' session done"
  fi
}

