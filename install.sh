#!/bin/bash

# URL для скачивания Giga IDE
DOWNLOAD_URL="https://www.renpy.org/dl/8.4.1/renpy-8.4.1-sdk.tar.bz2"
FILENAME="renpySDK.tar.bz2"
DIR_NAME="renpy-8.4.1-sdk"
INSTALL_PATH="/opt/$DIR_NAME"

# Проверка наличия необходимых утилит
if ! command -v curl &> /dev/null; then
    echo "Ошибка: curl не установлен. Установите его с помощью: sudo apt install curl"
    exit 1
fi

if ! command -v tar &> /dev/null; then
    echo "Ошибка: tar не установлен. Установите его с помощью: sudo apt install tar"
    exit 1
fi

# Скачивание архива
echo "Скачивание Renpy..."
curl -L -o "$FILENAME" "$DOWNLOAD_URL"

# Проверка успешности скачивания
if [ $? -ne 0 ]; then
    echo "Ошибка при скачивании Renpy"
    rm -f "$FILENAME"
    exit 1
fi

# Распаковка архива
echo "Распаковка архива..."
tar -xzf "$FILENAME"

# Проверка успешности распаковки
if [ $? -ne 0 ]; then
    echo "Ошибка при распаковке архива"
    rm -f "$FILENAME"
    exit 1
fi

# Удаление архива
rm -f "$FILENAME"

# Перемещение в /opt/ (требуются права суперпользователя)
echo "Установка в $INSTALL_PATH..."
sudo mkdir -p /opt
sudo mv "$DIR_NAME" "$INSTALL_PATH"

# Проверка существования исполняемого файла
if [ -f "$INSTALL_PATH/renpy.sh" ]; then

    EXEC_FILE="renpy.sh"
fi

# Создание .desktop файла
DESKTOP_FILE="$HOME/.local/share/applications/renpy.desktop"
echo "Создание файла запуска..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Renpy
Comment=RenpySDK
Exec="$INSTALL_PATH/$EXEC_FILE" %f
Icon=$INSTALL_PATH/launcher/icon.icns
Categories=Development;IDE;
Terminal=false
EOF

# Даем права на выполнение .desktop файла
chmod +x "$DESKTOP_FILE"

# Обновляем кэш приложений
update-desktop-database "$HOME/.local/share/applications" &> /dev/null

echo -e "\033[1;32mRenpySDK успешно установлена!\033[0m"
echo "Вы можете найти её в меню приложений в разделе Разработка (Development)"
echo ""
echo "Если возникнут проблемы с запуском, проверьте файл $DESKTOP_FILE"
echo "и убедитесь, что путь к исполняемому файлу корректен."