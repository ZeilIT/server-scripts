#!/bin/bash

# --- НАСТРОЙКИ ---
LOG_DIR="/var/log/my-updates"
LOG_FILE="$LOG_DIR/update-$(date +%Y-%m-%d).log"  # Каждый день — новый файл
LOCK_FILE="/tmp/update.lock"                      # Чтобы скрипт не запустился дважды

# --- ПРОВЕРКА БЛОКИРОВКИ ---
if [ -f "$LOCK_FILE" ]; then
    echo "$(date) - Скрипт уже запущен, выхожу" >> "$LOG_FILE"
    exit 1
fi
touch "$LOCK_FILE"

# --- ЗАПИСЬ СТАРТА ---
echo "========================================" >> "$LOG_FILE"
echo "$(date) - НАЧАЛО ОБНОВЛЕНИЯ" >> "$LOG_FILE"

# --- ОБНОВЛЕНИЕ СПИСКА ПАКЕТОВ ---
echo "$(date) - Обновление списка пакетов..." >> "$LOG_FILE"
apt update >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "$(date) - ОШИБКА: не удалось обновить список пакетов" >> "$LOG_FILE"
    rm -f "$LOCK_FILE"
    exit 1
fi

# --- ОБНОВЛЕНИЕ ПАКЕТОВ ---
echo "$(date) - Установка обновлений..." >> "$LOG_FILE"
apt upgrade -y >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    echo "$(date) - ОБНОВЛЕНИЕ УСПЕШНО ЗАВЕРШЕНО" >> "$LOG_FILE"
else
    echo "$(date) - ОШИБКА: сбой при обновлении" >> "$LOG_FILE"
fi

# --- ОЧИСТКА ---
apt autoremove -y >> "$LOG_FILE" 2>&1
echo "$(date) - ЗАВЕРШЕНИЕ СКРИПТА" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"

# --- УДАЛЕНИЕ БЛОКИРОВКИ ---
rm -f "$LOCK_FILE"
