#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

TEMPERATURE_API="http://192.168.1.116/temperature"

response=$(curl -s $TEMPERATURE_API)

temp=$(echo "$response" | jq -r '.temperature')
unit=$(echo "$response" | jq -r '.unit')

LC_NUMERIC=C

formatted_temp=$(printf "%.1f" "$temp")

if [[ -n "$formatted_temp" && "$unit" == "celsius" ]]; then
    echo "{\"text\": \"🌡️ ${formatted_temp}°C\", \"tooltip\": \"Room Temperature: ${formatted_temp}°C\"}"
else
    echo '{"text": "🌡️ N/A", "tooltip": "Temperature data unavailable"}'
fi
