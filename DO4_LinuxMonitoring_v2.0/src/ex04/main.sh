#!/bin/bash

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

# Функция генерации лог-файла
generate_log() {
    local logfile="$LOG_DIR/access_$1.log"
    local num_entries=$((RANDOM % 900 + 100))  # От 100 до 1000 записей

    for ((i=0; i<num_entries; i++)); do
        ip="$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
        method=$(shuf -n 1 -e GET POST PUT DELETE)
        status=$(shuf -n 1 -e 200 201 400 401 403 404 500 501 502 503)
        url="/page$((RANDOM % 10)).html"
        agent=$(shuf -n 1 -e "Mozilla" "Chrome" "Safari" "Edge" "Bot")
        date=$(date -d "-$1 days" "+%d/%b/%Y:%H:%M:%S %z")

        echo "$ip - - [$date] \"$method $url HTTP/1.1\" $status $((RANDOM % 5000)) \"$agent\"" >> "$logfile"
    done
}

# Генерируем 5 логов за последние 5 дней
for i in {1..5}; do
    generate_log "$i"
done

echo "Логи сгенерированы в папке $LOG_DIR"
