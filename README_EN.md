# AirCube - Environment Monitor Station

[中文版本](README.md)

An open source environmental state monitoring device that monitors various environmental states such as temperature, humidity, CO2 concentration, PM 2.5 concentration, etc.

<img src="https://github.com/ohdarling/AirCube/raw/master/AirCube.png" style="zoom:50%;" />

## Features

* The overview page allows you to visualize the current values of various environmental data, such as current temperature, humidity, PM 2.5 and CO2 concentration.
* Switch between pages with left and right touch button.
- Historical trend data for each data item, by recording the last 12 hours of data and showing the trend of environmental data in a graph.
- Detailed data of specific sensors, for example, Pantone PMS5003 can detect PM 1.0, PM 2.5 and PM 10 at the same time, which cannot be fully displayed in the overview page, so it can be displayed in the details page.
- The device information interface can display basic information such as the name of current device, Wi-Fi connection, operation time, etc.
- Data reporting capability, you can report data to Domoticz or Home Assistant via MQTT.
- Batch deployment capability, deploy device firmware in batch by script.

## Changelogs

* 2023.03.31
  
  * Disable automatic restart when MQTT cannot connect to prevent AirCube from restarting regularly due to an unconfigured MQTT Broker
  
* 2023.02.24

  * After comparing with Xiaomi Temp&Humdity Sensor, BME280 temperature calibration -2, humidity +10
  * Add reboot function, long press right button for more than 5 seconds, it will reboot AirCube
  - Add CO2 sensor calibration function, press and hold the left button for more than 5 seconds to turn on MH-Z19 or SenseAir S8 calibration function, please leave the AirCube outside and running for more than 20 minutes before calibration.
  - Use custom components to read BME280 data and avoid ESPHome initialization failures

## Components

| Image                                                        | Type                   | Model             | Memo                                                         |
| ------------------------------------------------------------ | ---------------------- | ----------------- | ------------------------------------------------------------ |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-bme280.png" alt="BME280" style="width:200px;" /> | Temperature & Humidity | BME280 or SHT31   | The BME280 additionally supports pressure detection, and both sensors are supported mainly because they have the same pin order and can be used interchangeably. |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-pms5003.png" alt="PMS5003" style="width:200px" /> | PM 2.5                 | Plantower PMS5003 | Supports PM 1.0, PM 2.5 and PM 10 particle concentration detection, as well as the PMS5003ST, which additionally adds formaldehyde concentration detection. The PMS7003 can also be used, but it is not recommended because it requires an additional adapter board and cannot be used directly with the 1.25mm 8P cable. |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-mhz19.png" alt="MH-Z19B" style="width:200px" /> | CO2                    | MH-Z19B           | This module can detect CO2 concentrations in the range of 400-5000 ppm, but of course it is also possible to use the SenseAir S8 sensor, which has the exact same pin locations and definitions. |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-bh1750.png" alt="BH1750" style="width:200px" /> | Lux                    | BH1750            | This makes it easier to obtain current brightness information than using a light-dependent resistor. |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-touch-sensor.png" alt="TTP223" style="width:200px;" /> | Lux                    | TTP223            | This module has a large touch sensing distance and can be used to switch information pages by completing touch operations across the case. |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-nodemcu32s.png" alt="NodeMCU-32S" style="width:200px;;" /> | MCU                    | NodeMCU-32S       | NodeMCU-32S development board, cheap, can also provide 3.3V to the sensors. |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-lcd.png" alt="1.54 LCD" style="width:200px" /> | Screen                 | 1.54 LCD          | 1.54 inch SPI IPS LCD, resolution 240x240, chip ST7789V.     |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-eink.png" alt="1.54 E-ink" style="width:200px;" /> | Screen                 | 1.54 E-ink        | 1.54 inch SPI  E-ink Scren, resolution 200x200.              |

## Compile/Flash Firmware

The Firmware directory already provides the `build.sh` script for fast compilation and burning of firmware, which requires local installation of Espressif esptool.py. In addition, `build.sh` accepts the following parameters for customizing the replaceable component models or reporting data parameters.

* DP - Screen model, st7789v or eink, default st7789v
* CO2 - CO2 sensor model, mhz19 or s8, default mhz19
* TEMP - Temperature and humidity sensor model, bme280 or sht31, default bme280
* DOMOTICZ - Enable Domoticz integration, enable or disable, default disable
* ROOM - Room name of current node, English characters only, such as livingroom
* IP - IP address of current node, a fixed IP is recommended for future OTA firmware updates.
* IDX_BH1750, IDX_PM25, IDX_CO2, IDX_TEMP, IDX_PRESSURE, IDX_HOCO - Device ID of sensor in Domoticz 

Also, if `IDX_HOCO` is set, the PM 2.5 sensor type will be set to PMS5003ST.

`build.sh` also provides the upload parameter to burn the firmware as soon as the build is complete.

If all sensor types are the same as the default, the firmware can be compiled and flashed directly using the following command (noting that the NodeMCU-32S needs to be connected to the computer first):

`./build.sh upload`

If you need to customize the sensor model, for example by replacing the temperature and humidity sensor with sht31, you can use the following command:

`TEMP=sht31 ./build.sh upload`

## Directory Structure

* 3D_Model - 3D model file of the device housing, which can be printed by FDM type 3D printers
- Firmware - device firmware based on ESPHome, not compiled as a duplex because the sensor shape can be changed, can be compiled by yourself
- Hardware - contains Gerber files and schematics for PCB manufacturing

