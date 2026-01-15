#!/bin/bash

MYFOLDER="$HOME/myfolder"

mkdir -p "$MYFOLDER"

{
    echo "Привет! Это файл 1."
    date +"%Y-%m-%d %H:%M:%S"
} > "$MYFOLDER/file1.txt"

touch "$MYFOLDER/file2.txt"
chmod 777 "$MYFOLDER/file2.txt"

< /dev/urandom tr -dc 'A-Za-z0-9' | head -c20 > "$MYFOLDER/file3.txt"

touch "$MYFOLDER/file4.txt" "$MYFOLDER/file5.txt"

echo "script1.sh: папка и файлы созданы."