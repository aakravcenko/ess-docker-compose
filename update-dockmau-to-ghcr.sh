#!/bin/bash
# Скрипт для автоматической замены dock.mau.dev на ghcr.io в проекте
# Использование: ./update-dockmau-to-ghcr.sh

set -e

echo "Обновление ссылок с dock.mau.dev на ghcr.io..."

# Файлы для обновления
FILES=(
    "docker-compose.yml"
    "compose-variants/docker-compose.local.yml"
    "compose-variants/docker-compose.old.yml"
    "deploy.sh"
    "SETUP.md"
    "templates/.env.template"
)

# Замена во всех файлах
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Обновление $file..."
        # Замена dock.mau.dev/mautrix/ на ghcr.io/mautrix/
        sed -i 's|dock\.mau\.dev/mautrix/|ghcr.io/mautrix/|g' "$file"
        echo "✓ $file обновлен"
    else
        echo "⚠ Файл $file не найден, пропускаем"
    fi
done

# Проверка, остались ли еще ссылки на dock.mau.dev
echo ""
echo "Проверка оставшихся ссылок на dock.mau.dev..."
if grep -r "dock\.mau\.dev" . --include="*.yml" --include="*.yaml" --include="*.sh" --include="*.md" --include="*.txt" 2>/dev/null; then
    echo "⚠ Обнаружены оставшиеся ссылки на dock.mau.dev"
else
    echo "✓ Все ссылки на dock.mau.dev заменены"
fi

echo ""
echo "Обновление завершено!"
echo "Новые образы:"
echo "  • ghcr.io/mautrix/telegram:latest"
echo "  • ghcr.io/mautrix/whatsapp:latest"
echo "  • ghcr.io/mautrix/signal:latest"
echo ""
echo "Для применения изменений выполните:"
echo "  docker-compose pull"
echo "или перезапустите deploy.sh"