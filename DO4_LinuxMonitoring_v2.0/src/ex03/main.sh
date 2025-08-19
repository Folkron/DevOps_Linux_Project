#!/bin/bash

LOG_FILE="../ex02/file_creation.log"

# Проверка наличия параметра
if [ "$#" -ne 1 ]; then
    echo "Использование: $0 <метод очистки (1 - лог, 2 - дата, 3 - маска)>"
    exit 1
fi

METHOD="$1"

# Очистка по лог-файлу
if [ "$METHOD" -eq 1 ]; then
    if [ ! -f "$LOG_FILE" ]; then
        echo "Ошибка: Лог-файл $LOG_FILE не найден!"
        exit 1
    fi
    echo "Удаление файлов по лог-файлу..."
    cut -d'|' -f1 "$LOG_FILE" | while read -r file; do
        if [ -e "$file" ]; then
            rm -rf "$file"
            echo "Удалено: $file"
        fi
    done
    rm -f "$LOG_FILE"
    echo "Очистка завершена."

# Очистка по дате создания
elif [ "$METHOD" -eq 2 ]; then
    read -p "Введите дату начала (ДДММГГ ЧЧММ): " START_DATE
    read -p "Введите дату окончания (ДДММГГ ЧЧММ): " END_DATE

    echo "Удаление файлов, созданных с $START_DATE по $END_DATE..."
    find /tmp -type f -newermt "$(date -d "$START_DATE" '+%Y-%m-%d %H:%M')" ! -newermt "$(date -d "$END_DATE" '+%Y-%m-%d %H:%M')" -delete
    find /tmp -type d -empty -delete
    echo "Очистка завершена."

# Очистка по маске
elif [ "$METHOD" -eq 3 ]; then
    read -p "Введите маску имени файла (например, az_070225): " MASK
    echo "Удаление файлов, содержащих '$MASK'..."
    find /tmp -type f -name "*$MASK*" -delete
    find /tmp -type d -empty -delete
    echo "Очистка завершена."

else
    echo "Ошибка: Неверный метод очистки!"
    exit 1
fi
