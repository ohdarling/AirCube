#!/bin/bash

echo Building ...

CONFIG=aircube.yaml

DEV_DP=$DP
if [ "$DEV_DP" == "" ]; then
    DEV_DP=st7789v
fi

DEV_CO2=$CO2
if [ "$DEV_CO2" == "" ]; then
    DEV_CO2=mhz19
fi

DEV_TEMP=$TEMP
if [ "$TEMP" == "" ]; then
    DEV_TEMP=bme280
fi

PRES_PREFIX=""
if [ "$DEV_TEMP" != "bme280" ]; then
    PRES_PREFIX="//"
fi

if [ "$IP" == "" ]; then
    IP=""
fi

DEV_DOMOTICZ=disable
DOMOTICZ_FLAG=false
if [ "$DOMOTICZ" == "enable" ]; then
    DEV_DOMOTICZ=enable
    DOMOTICZ_FLAG=true
fi

PMS_TYPE=PMSX003
if [ "$IDX_HOCO" != "" ]; then
    PMS_TYPE=PMS5003ST
fi

echo ========================================
echo Custom Components
echo Room: $ROOM
echo IP: $IP
echo Display: ${DEV_DP}
echo CO2 Sensor: ${DEV_CO2}
echo Temperature Sensor: ${DEV_TEMP}
echo Domoticz: ${DEV_DOMOTICZ}
echo ========================================

cat > custom.yaml <<- EOF
substitutions:
  room_name: '$ROOM'
  wifi_ip: '$IP'
  pressure_sensor_prefix: '$PRES_PREFIX'
  pms_type: '$PMS_TYPE'
  domoticz_flag: '$DOMOTICZ_FLAG'
  domoticz_bh1750_idx: '$IDX_BH1750'
  domoticz_pm25_idx: '$IDX_PM25'
  domoticz_co2_idx: '$IDX_CO2'
  domoticz_temp_idx: '$IDX_TEMP'
  domoticz_pressure_idx: '$IDX_PRESSURE'
  domoticz_hoco_idx: '$IDX_HOCO'

packages:
  sensor_co2: !include components/co2_${DEV_CO2}.yaml
  sensor_temp: !include components/temperature_${DEV_TEMP}.yaml
  display: !include components/display_${DEV_DP}.yaml
  graphsize: !include components/graphsize_${DEV_DP}.yaml
  font: !include components/font_${DEV_DP}.yaml
EOF

esphome compile $CONFIG
COMPILE_RET=$?

if [ $COMPILE_RET == "0" ]; then
    echo Build done.

    if [ "$1" == "upload" ]; then
        if [ "$IP" != "" ] && [ "$OTA" == "true" ]; then
            esphome upload $CONFIG
        else
            esphome upload $CONFIG
        fi
    fi

fi
