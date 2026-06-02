#!/bin/bash

LAB_NAME=$1

if [ -z "$LAB_NAME" ]; then
    echo "Uso: ./create_lab.sh LAB_A05"
    exit 1
fi

mkdir -p "$LAB_NAME"/{src,tb,sim,docs}

touch "$LAB_NAME"/README.md
touch "$LAB_NAME"/Makefile

cat > "$LAB_NAME"/.gitignore << EOF
sim/
*.vcd
*.out
*.log
EOF

echo "Laboratório $LAB_NAME criado com sucesso!"
