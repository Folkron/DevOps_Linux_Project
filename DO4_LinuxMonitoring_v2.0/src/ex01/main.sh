#!/bin/bash

# Проверка количества параметров
if [ "$#" -ne 6 ]; then
    echo "Использование: $0 <путь> <количество папок> <буквы для папок> <количество файлов> <буквы для файлов> <размер файла>"
    exit 1
fi

# Получаем параметры
TARGET_DIR="$1"
NUM_DIRS="$2"
DIR_CHARS="$3"
NUM_FILES="$4"
FILE_CHARS="$5"
FILE_SIZE="$6"

# Проверка, что путь существует
if [ ! -d "$TARGET_DIR" ]; then
    echo "Ошибка: Директория $TARGET_DIR не существует!"
    exit 1
fi

# Проверяем, что размер файла не превышает 100КБ
MAX_SIZE_KB=100
SIZE_KB=${FILE_SIZE//[!0-9]/}  # Убираем символы кроме цифр
if (( SIZE_KB > MAX_SIZE_KB )); then
    echo "Ошибка: Максимальный размер файла — 100KB!"
    exit 1
fi

# Файл для логов
LOG_FILE="file_creation.log"
echo "Создание файлов началось..." > "$LOG_FILE"

# Функция генерации имени (папки или файла)
generate_name() {
    local chars="$1"
    local length=$((RANDOM % 4 + 4))  # Длина от 4 до 7 символов
    local name=""
    for ((i=0; i<length; i++)); do
        name+="${chars:RANDOM%${#chars}:1}"
    done
    echo "${name}_$(date +%d%m%y)"
}

# Создаём папки и файлы
for ((i=0; i<NUM_DIRS; i++)); do
    NEW_FOLDER="$TARGET_DIR/$(generate_name "$DIR_CHARS")"
    mkdir -p "$NEW_FOLDER"

    for ((j=0; j<NUM_FILES; j++)); do
        FILE_NAME="$(generate_name "$FILE_CHARS").$(generate_name "$FILE_CHARS" | cut -c1-3)"
        fallocate -l "$FILE_SIZE" "$NEW_FOLDER/$FILE_NAME"
        echo "$NEW_FOLDER/$FILE_NAME | $(date) | $FILE_SIZE" >> "$LOG_FILE"
    done
done

echo "Файлы успешно созданы!"
