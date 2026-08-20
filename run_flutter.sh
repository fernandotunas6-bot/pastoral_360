#!/usr/bin/env bash
# ====================================================
# PASTORAL 360 - FLUTTER EXECUTION SCRIPT
# Autor: Valentino Canguele | MCASD 2026
# ====================================================

echo "=== INICIANDO PASTORAL 360 EM FLUTTER NATIVO ==="

if command -v flutter &> /dev/null; then
    echo "✅ Flutter SDK encontrado no sistema!"
    flutter --version
    echo "🚀 Executando: flutter run -d chrome"
    flutter run -d chrome
else
    echo "⚠️ Flutter CLI não está no PATH do terminal."
    echo "Procurando Flutter em caminhos comuns de instalação..."
    
    FLUTTER_PATHS=(
        "$HOME/development/flutter/bin/flutter"
        "$HOME/flutter/bin/flutter"
        "/Users/shared/flutter/bin/flutter"
        "/opt/homebrew/bin/flutter"
        "/usr/local/bin/flutter"
    )
    
    FOUND_FLUTTER=""
    for p in "${FLUTTER_PATHS[@]}"; do
        if [ -f "$p" ]; then
            FOUND_FLUTTER="$p"
            break
        fi
    done
    
    if [ -n "$FOUND_FLUTTER" ]; then
        echo "✅ Flutter encontrado em: $FOUND_FLUTTER"
        "$FOUND_FLUTTER" run -d chrome
    else
        echo "--------------------------------------------------------"
        echo "📌 PARA RODAR O COMANDO 'flutter run' NO SEU COMPUTADOR:"
        echo "1. Descarregue o Flutter SDK em: https://docs.flutter.dev/get-started/install/macos"
        echo "2. Adicione ao PATH executando no terminal:"
        echo "   export PATH=\"\$PATH:\$HOME/development/flutter/bin\""
        echo "3. Execute na pasta do projeto:"
        echo "   flutter run -d chrome"
        echo "--------------------------------------------------------"
    fi
fi
