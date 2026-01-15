#!/bin/bash

MYFOLDER="$HOME/myfolder"

if [ ! -d "$MYFOLDER" ]; then
    echo "Папка $MYFOLDER не существует. Нечего обрабатывать."
    exit 0
fi

FILE_COUNT=$(find "$MYFOLDER" -maxdepth 1 -type f | wc -l)
echo "Найдено файлов в $MYFOLDER: $FILE_COUNT"

FILE2="$MYFOLDER/file2.txt"
if [ -f "$FILE2" ]; then
    chmod 664 "$FILE2"
    echo "Права файла $FILE2 изменены на 664."
else
    echo "Файл $FILE2 не найден — пропускаем изменение прав."
fi

for file in "$MYFOLDER"/*; do
    if [ -f "$file" ] && [ ! -s "$file" ]; then
        rm "$file"
        echo "Удалён пустой файл: $file"
    fi
done

for file in "$MYFOLDER"/*; do
    if [ -f "$file" ] && [ -s "$file" ]; then
        head -n1 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        echo "Оставлено только первая строка в файле: $file"
    fi
done

echo "script2.sh: обработка завершена."