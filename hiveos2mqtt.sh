#!/bin/bash
# MQTT settings
BROKER="192.168.2.10"
TOPIC="hiveos_worker001"
USER="mqtt-user"
PASS="1234567890"

# Ensure mosquitto-clients is installed
dpkg -s mosquitto-clients >/dev/null 2>&1 || apt update && apt install -y mosquitto-clients

# Stream logs to MQTT
tail /var/log/hive-agent.log | while read -r line; do
    json_line=$(echo ${line} | awk -F'[<>]' {'print $2'})
    if $(echo "$json_line" | jq -e 'has("method")'); then
        mosquitto_pub -h $BROKER -t $TOPIC -u "$USER" -P "$PASS" -m "$json_line"
    fi
done
