#!/bin/bash

echo "Установка uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
export PATH="$HOME/.local/bin:$PATH"

echo "Проверка установки uv..."
uv --version

# Создание .venv и установка зависимостей
echo "Создание виртуального окружения и установка зависимостей..."
uv venv .venv
echo 'source .venv/bin/activate' >> $HOME/.bashrc

# Установка зависимостей из pyproject.toml (если есть)
if [ -f "pyproject.toml" ]; then
    echo "Установка зависимостей из pyproject.toml..."
    uv sync --python .venv/bin/python
else
    echo "Файл pyproject.toml не найден"
fi

if [ ! -f ".env" ]; then
    echo "Создание .env файла..."
    if [ -f ".env.dist" ]; then
        cp .env.dist .env
        echo ".env файл создан на основе .env.dist"
    else
        cat > .env << EOF
# Базовые переменные окружения
EOF
        echo ".env файл создан по умолчанию"
    fi
fi
