# AirCube - Environment Monitor Station

[中文版本](README.md)

An open source environmental state monitoring device that monitors various environmental states such as temperature, humidity, CO2 concentration, PM 2.5 concentration, etc.

<img src="https://github.com/ohdarling/AirCube/raw/master/AirCube.png" style="zoom:50%;" />

## Features

* The overview page allows you to visualize the current values of various environmental data, such as current temperature, humidity, PM 2.5 and CO2 concentration.
- Historical trend data for each data item, by recording the last 12 hours of data and showing the trend of environmental data in a graph.
- Detailed data of specific sensors, for example, Pantone PMS5003 can detect PM 1.0, PM 2.5 and PM 10 at the same time, which cannot be fully displayed in the overview page, so it can be displayed in the details page.
- The device information interface can display basic information such as the name of current device, Wi-Fi connection, operation time, etc.
- Data reporting capability, you can report data to Domoticz or Home Assistant via MQTT.
- Batch deployment capability, deploy device firmware in batch by script.

## Directory Structure

* 3D_Model - 3D model file of the device housing, which can be printed by FDM type 3D printers
- Firmware - device firmware based on ESPHome, not compiled as a duplex because the sensor shape can be changed, can be compiled by yourself
- Hardware - contains Gerber files and schematics for PCB manufacturing

