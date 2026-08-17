#!/bin/bash
exec > /var/log/my-updates/runner-$(date +%Y-%m-%d).log 2>&1
echo "=== Запуск: $(date) ==="
cd /home/kydza/repo || { echo "Не могу перейти в repo"; exit 1; }
echo "Выполняю git pull..."
/usr/bin/git pull origin main || { echo "Ошибка git pull"; exit 1; }
echo "Запускаю update.sh..."
/bin/bash /home/kydza/repo/update.sh
echo "=== Завершено: $(date) ==="
