#!/bin/bash

# Проверка количества параметров
if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <буквы для папок> <буквы для файлов> <размер файла (до 100MB)>"
    exit 1
fi

FOLDER_CHARS="$1"
FILE_CHARS="$2"
FILE_SIZE="$3"

# Проверяем, что размер файла не превышает 100MB
MAX_SIZE_MB=100
SIZE_MB=${FILE_SIZE//[!0-9]/}  # Оставляем только цифры
if (( SIZE_MB > MAX_SIZE_MB )); then
    echo "Ошибка: Максимальный размер файла — 100MB!"
    exit 1
fi

# Лог-файл
LOG_FILE="file_creation.log"
echo "Создание файлов началось..." > "$LOG_FILE"

# Функция генерации случайного имени
generate_name() {
    local chars="$1"
    local length=$((RANDOM % 4 + 4))  # Длина от 4 до 7 символов
    local name=""
    for ((i=0; i<length; i++)); do
        name+="${chars:RANDOM%${#chars}:1}"
    done
    echo "${name}_$(date +%d%m%y)"
}

# Функция проверки свободного места
check_free_space() {
    local free_space=$(df --output=avail / | tail -n1)  # Свободное место в KB
    if (( free_space < 1048576 )); then  # 1GB = 1024 * 1024 KB
        echo "Достигнут лимит в 1GB свободного места. Завершаем работу."
        exit 0
    fi
}

# Основной цикл создания файлов
for ((i=0; i<100; i++)); do
    check_free_space

    # Используем только папку /tmp
    BASE_DIR="/tmp"
    NEW_FOLDER="$BASE_DIR/$(generate_name "$FOLDER_CHARS")"
    mkdir -p "$NEW_FOLDER"

    # Генерируем случайное количество файлов в папке
    NUM_FILES=$((RANDOM % 10 + 1))
    for ((j=0; j<NUM_FILES; j++)); do
        check_free_space
        FILE_NAME="$(generate_name "$FILE_CHARS").$(generate_name "$FILE_CHARS" | cut -c1-3)"
        fallocate -l "$FILE_SIZE" "$NEW_FOLDER/$FILE_NAME"
        echo "$NEW_FOLDER/$FILE_NAME | $(date) | $FILE_SIZE" >> "$LOG_FILE"
    done
done

echo "Файлы успешно созданы!"
