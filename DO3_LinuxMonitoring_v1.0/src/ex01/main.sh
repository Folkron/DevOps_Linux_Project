#!/bin/bash

if [ -z "$1" ]; then
    echo "Ошибка: параметр не указан."
    exit 1
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: параметр не должен быть числом."
else
    echo "$1"
fi
