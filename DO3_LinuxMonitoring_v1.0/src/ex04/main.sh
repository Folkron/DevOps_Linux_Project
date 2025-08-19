#!/bin/bash

# Конфигурация по умолчанию
declare -A default_config=(
  [column1_background]=6
  [column1_font_color]=1
  [column2_background]=6
  [column2_font_color]=1
)

# Чтение конфигурационного файла
config_file="config.conf"
if [ -f "$config_file" ]; then
  while IFS='=' read -r key value; do
    key=$(echo "$key" | tr -d ' ')
    value=$(echo "$value" | tr -d ' ')
    if [[ "$key" =~ ^column[12]_(background|font_color)$ ]] && [[ "$value" =~ ^[1-6]$ ]]; then
      default_config["$key"]="$value"
    fi
  done < "$config_file"
fi

# Проверка совпадения цветов
if [ "${default_config[column1_background]}" -eq "${default_config[column1_font_color]}" ] || \
   [ "${default_config[column2_background]}" -eq "${default_config[column2_font_color]}" ]; then
  echo "Error: Colors in config file are invalid (background = font)." >&2
  exit 1
fi

# Запуск Part 3 с параметрами из конфига
../03/main.sh \
  "${default_config[column1_background]}" \
  "${default_config[column1_font_color]}" \
  "${default_config[column2_background]}" \
  "${default_config[column2_font_color]}"

# Цветовая схема
declare -A color_names=(
  [1]="white" [2]="red" [3]="green" 
  [4]="blue" [5]="purple" [6]="black"
)

echo ""
echo "Column 1 background = ${default_config[column1_background]} (${color_names[${default_config[column1_background]}]})"
echo "Column 1 font color = ${default_config[column1_font_color]} (${color_names[${default_config[column1_font_color]}]})"
echo "Column 2 background = ${default_config[column2_background]} (${color_names[${default_config[column2_background]}]})"
echo "Column 2 font color = ${default_config[column2_font_color]} (${color_names[${default_config[column2_font_color]}]})"