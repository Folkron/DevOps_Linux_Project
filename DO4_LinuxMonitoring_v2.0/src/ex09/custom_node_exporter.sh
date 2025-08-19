#!/bin/bash

# Директория, где будет храниться HTML-страница
OUTPUT_DIR="/var/www/html/metrics"
OUTPUT_FILE="$OUTPUT_DIR/metrics.html"

# Создаем директорию, если она не существует
mkdir -p $OUTPUT_DIR

# Бесконечный цикл для обновления метрик каждые 3 секунды
while true; do
    # Собираем метрики
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

    # Формируем HTML-страницу в формате Prometheus
    echo "# HELP cpu_usage CPU usage in percent" > $OUTPUT_FILE
    echo "# TYPE cpu_usage gauge" >> $OUTPUT_FILE
    echo "cpu_usage $CPU_USAGE" >> $OUTPUT_FILE

    echo "# HELP memory_usage Memory usage in percent" >> $OUTPUT_FILE
    echo "# TYPE memory_usage gauge" >> $OUTPUT_FILE
    echo "memory_usage $MEMORY_USAGE" >> $OUTPUT_FILE

    echo "# HELP disk_usage Disk usage in percent" >> $OUTPUT_FILE
    echo "# TYPE disk_usage gauge" >> $OUTPUT_FILE
    echo "disk_usage $DISK_USAGE" >> $OUTPUT_FILE

    # Ждем 3 секунды перед следующим обновлением
    sleep 3
done