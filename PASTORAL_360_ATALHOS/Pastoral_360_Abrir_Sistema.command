#!/usr/bin/env bash
# ====================================================
# PASTORAL 360 - ATALHO DE ABERTURA NO NAVEGADOR
# Autor: Valentino Canguele | MCASD 2026
# ====================================================

echo "=== ABRINDO PASTORAL 360 NO NAVEGADOR ==="
python3 /Volumes/canguele/Excel/server.py &
sleep 1
open http://127.0.0.1:5000
echo "✅ Sistema Pastoral 360 aberto em http://127.0.0.1:5000"
