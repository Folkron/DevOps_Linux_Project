#!/bin/bash

# Проверка параметров
if [ $# -ne 4 ]; then
  echo "Error: 4 arguments required (1-6). Example: $0 1 2 3 4" >&2
  exit 1
fi

bg1=$1; fg1=$2; bg2=$3; fg2=$4

# Проверка диапазона
for param in $bg1 $fg1 $bg2 $fg2; do
  if [[ ! "$param" =~ ^[1-6]$ ]]; then
    echo "Error: All parameters must be numbers 1-6." >&2
    exit 1
  fi
done

# Проверка совпадения цветов
if [ "$bg1" -eq "$fg1" ] || [ "$bg2" -eq "$fg2" ]; then
  echo "Error: Background and text colors must not match." >&2
  exit 1
fi

# ANSI-коды цветов
declare -A colors=(
  [1]='47'  # white
  [2]='41'  # red
  [3]='42'  # green
  [4]='44'  # blue
  [5]='45'  # purple
  [6]='40'  # black
)

declare -A font_colors=(
  [1]='37'  # white
  [2]='31'  # red
  [3]='32'  # green
  [4]='34'  # blue
  [5]='35'  # purple
  [6]='30'  # black
)

# Форматирование
title_bg="\e[${colors[$bg1]}m"
title_fg="\e[${font_colors[$fg1]}m"
value_bg="\e[${colors[$bg2]}m"
value_fg="\e[${font_colors[$fg2]}m"
reset="\e[0m"

# Функция для сбора данных
get_system_info() {
  HOSTNAME=$(hostname)
  TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3, $4}')
  USER=$(whoami)
  OS=$(lsb_release -ds | sed 's/"//g')
  DATE=$(date "+%d %b %Y %H:%M:%S")
  UPTIME=$(uptime -p | sed 's/up //')
  UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
  IP=$(hostname -I | awk '{print $1}')
  MASK=$(ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $4}' | head -1)
  GATEWAY=$(ip route | grep default | awk '{print $3}')
  RAM_TOTAL=$(free -m | awk '/Mem:/ {printf "%.3f GB", $2/1024}')
  RAM_USED=$(free -m | awk '/Mem:/ {printf "%.3f GB", $3/1024}')
  RAM_FREE=$(free -m | awk '/Mem:/ {printf "%.3f GB", $4/1024}')
  SPACE_ROOT=$(df / | awk 'NR==2 {printf "%.2f MB", $2/1024}')
  SPACE_ROOT_USED=$(df / | awk 'NR==2 {printf "%.2f MB", $3/1024}')
  SPACE_ROOT_FREE=$(df / | awk 'NR==2 {printf "%.2f MB", $4/1024}')
}

# Получение данных
get_system_info

# Цветной вывод
echo -e "${title_bg}${title_fg}HOSTNAME${reset} = ${value_bg}${value_fg}${HOSTNAME}${reset}"
echo -e "${title_bg}${title_fg}TIMEZONE${reset} = ${value_bg}${value_fg}${TIMEZONE}${reset}"
echo -e "${title_bg}${title_fg}USER${reset} = ${value_bg}${value_fg}${USER}${reset}"
echo -e "${title_bg}${title_fg}OS${reset} = ${value_bg}${value_fg}${OS}${reset}"
echo -e "${title_bg}${title_fg}DATE${reset} = ${value_bg}${value_fg}${DATE}${reset}"
echo -e "${title_bg}${title_fg}UPTIME${reset} = ${value_bg}${value_fg}${UPTIME}${reset}"
echo -e "${title_bg}${title_fg}UPTIME_SEC${reset} = ${value_bg}${value_fg}${UPTIME_SEC}${reset}"
echo -e "${title_bg}${title_fg}IP${reset} = ${value_bg}${value_fg}${IP}${reset}"
echo -e "${title_bg}${title_fg}MASK${reset} = ${value_bg}${value_fg}${MASK}${reset}"
echo -e "${title_bg}${title_fg}GATEWAY${reset} = ${value_bg}${value_fg}${GATEWAY}${reset}"
echo -e "${title_bg}${title_fg}RAM_TOTAL${reset} = ${value_bg}${value_fg}${RAM_TOTAL}${reset}"
echo -e "${title_bg}${title_fg}RAM_USED${reset} = ${value_bg}${value_fg}${RAM_USED}${reset}"
echo -e "${title_bg}${title_fg}RAM_FREE${reset} = ${value_bg}${value_fg}${RAM_FREE}${reset}"
echo -e "${title_bg}${title_fg}SPACE_ROOT${reset} = ${value_bg}${value_fg}${SPACE_ROOT}${reset}"
echo -e "${title_bg}${title_fg}SPACE_ROOT_USED${reset} = ${value_bg}${value_fg}${SPACE_ROOT_USED}${reset}"
echo -e "${title_bg}${title_fg}SPACE_ROOT_FREE${reset} = ${value_bg}${value_fg}${SPACE_ROOT_FREE}${reset}"