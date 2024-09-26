#!/bin/bash

# Define o caminho para o arquivo de brilho
brightness_file="/sys/class/leds/input5::scrolllock/brightness"

if [ ! -f "$brightness_file" ]; then

brightness_file="/sys/class/leds/input6::scrolllock/brightness"
fi

# Lê o conteúdo atual do arquivo
current_brightness=$(cat "$brightness_file")

# Inverte o valor do brilho
if [ "$current_brightness" = "0" ]; then
    new_brightness="1"
else
    new_brightness="0"
fi

# Escreve o novo valor de brilho no arquivo
echo "$new_brightness" | sudo tee "$brightness_file" > /dev/null


