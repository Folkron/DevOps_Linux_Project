#!/bin/bash

start_time=$(date +%s.%N)

# Проверка параметров
if [ $# -ne 1 ]; then
  echo "Error: Directory path required. Example: $0 /path/to/dir/" >&2
  exit 1
fi

dir="$1"
if [[ "${dir: -1}" != "/" ]]; then
  echo "Error: Path must end with '/'." >&2
  exit 1
fi

if [ ! -d "$dir" ]; then
  echo "Error: Directory does not exist." >&2
  exit 1
fi

# Общее количество папок
total_folders=$(find "$dir" -type d 2>/dev/null | wc -l)

# Топ-5 папок по размеру
echo "Total number of folders (including all nested ones) = $total_folders"
echo "TOP 5 folders of maximum size:"
du -h "$dir" 2>/dev/null | sort -hr | head -5 | nl | awk -F'\t' '{printf "%d - %s, %s\n", $1, $2, $3}'

# Общее количество файлов
total_files=$(find "$dir" -type f 2>/dev/null | wc -l)

# Подсчёт файлов по типам
conf_files=$(find "$dir" -type f -name "*.conf" 2>/dev/null | wc -l)
text_files=$(find "$dir" -type f -exec file {} \; 2>/dev/null | grep -c "text")
exec_files=$(find "$dir" -type f -executable 2>/dev/null | wc -l)
log_files=$(find "$dir" -type f -name "*.log" 2>/dev/null | wc -l)
archive_files=$(find "$dir" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" \) 2>/dev/null | wc -l)
symlinks=$(find "$dir" -type l 2>/dev/null | wc -l)

# Топ-10 файлов по размеру
echo "TOP 10 files of maximum size:"
find "$dir" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10 | nl | awk -F'\t' '{printf "%d - %s, %s\n", $1, $2, $3}'

# Топ-10 исполняемых файлов с хешем
echo "TOP 10 executable files of the maximum size:"
find "$dir" -type f -executable -exec du -h {} + 2>/dev/null | sort -hr | head -10 | nl | while read -r line; do
  num=$(echo "$line" | awk '{print $1}')
  size=$(echo "$line" | awk '{print $2}')
  path=$(echo "$line" | awk '{print $3}')
  hash=$(md5sum "$path" 2>/dev/null | awk '{print $1}')
  echo "$num - $path, $size, $hash"
done

# Время выполнения
end_time=$(date +%s.%N)
elapsed=$(printf "%.1f" "$(echo "$end_time - $start_time" | bc)")
echo "Script execution time (in seconds) = $elapsed"