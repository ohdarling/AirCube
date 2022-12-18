# AirCube 空气检测站

[English Version](README_EN.md)

一个开源的环境状态监测设备，可以监测各种环境状态，例如温度、湿度、二氧化碳浓度、PM 2.5 浓度等。

<img src="https://github.com/ohdarling/AirCube/raw/master/AirCube.png" style="zoom:50%;" />

## 功能列表

* 概览页面，可以直观查看各种环境数据的当前数值，例如当前温度、湿度、PM 2.5 以及二氧化碳浓度。
* 各项数据的历史趋势数据，通过记录过去 12 小时的数据并通过图表展示环境数据的变化趋势。
* 特定传感器的详情数据，例如攀藤 PMS5003 可以同时检测 PM 1.0、PM 2.5、PM 10 浓度，在概览页面无法展示完全，就可以在详情页面展示出来。
* 设备信息界面，可以展示当前设备的名称、Wi-Fi 连接情况、运行时间等基础信息。
* 数据上报能力，可以通过 MQTT 将数据上报到 Domoticz 或 Home Assistant。
* 批量部署能力，通过脚本批量部署设备固件。

## 目录结构

* 3D_Model - 设备外壳 3D 模型文件，可以通过 FDM 类型 3D 打印机打印
* Firmware - 基于 ESPHome 的设备固件，因传感器造型可变化，未编译成二进行，可以自行编译
* Hardware - 包含用于制造 PCB 的 Gerber 文件和原理图

## 元件选型

| 图片                                                         | 类型         | 型号            | 价格（元） | 说明                                                         |
| ------------------------------------------------------------ | ------------ | --------------- | ---------- | ------------------------------------------------------------ |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-bme280.png" alt="BME280" style="width:200px;" /> | 温湿度       | BME280 或 SHT31 | 22         | 其中 BME280 还额外支持压强检测，同时支持这两种传感器主要是因为它们的引脚顺序相同，可以替换使用。 |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-pms5003.png" alt="PMS5003" style="width:200px" /> | 颗粒物浓度   | 攀藤 PMS5003    | 70         | 支持 PM 1.0、PM 2.5、PM 10 三种颗粒物浓度检测，以及 PMS5003ST，额外增加了甲醛浓度检测。另外 PMS7003 虽然同样可以使用，但是因为需要额外转接板，不能直接使用 1.25mm 8P 连接线，因此并不推荐。 |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-mhz19.png" alt="MH-Z19B" style="width:200px" /> | 二氧化碳浓度 | MH-Z19B         | 120        | 可以检测 400-5000 ppm 范围的二氧化碳浓度，当然也可以采用 SenseAir S8 传感器，它们的引脚位置和定义都完全一致。 |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-bh1750.png" alt="BH1750" style="width:200px" /> | 光照强度     | BH1750          | 4          | 如果使用光敏电阻还需要额外换算，还是直接采用传感器更简单直接。 |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-touch-sensor.png" alt="TTP223" style="width:200px;" /> | 触摸按钮     | TTP223          | 0.3        | 这个模块触摸感应距离大，可以隔着外壳完成触摸操作，用来切换信息页。 |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-nodemcu32s.png" alt="NodeMCU-32S" style="width:200px;;" /> | 单片机       | NodeMCU-32S     | 22         | 直接选用常见的 NodeMCU-32S 开发板，价格便宜，还可以直接给传感器提供 3.3V 供电。 |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-lcd.png" alt="1.54 LCD" style="width:200px" /> | 屏幕         | 1.54 LCD        | 20         | 1.54 寸 SPI 接口 IPS 屏幕：分辨率 240x240，主控 ST7789V。    |
| <img src="https://github.com/ohdarling/AirCube/raw/master/Images/aircube-part-eink.png" alt="1.54 E-ink" style="width:200px;" /> | 屏幕         | 1.54 E-ink      | 30         | 1.54 寸 SPI 接口 E-ink 屏幕：单色屏，只支持黑白，分辨率 200x200。 |

**注：表格中的价格为淘宝上大致价格，随卖家不同价格也会不太相同。**

## 编译固件

Firmware 目录中已经提供了 `build.sh` 脚本用于快速编译及烧录固件，需要本地安装乐鑫 `esptool.py`，另外 `build.sh` 还接受以下参数用于定制可替换部分元件型号或上报数据参数：

* DP - 屏幕类型，st7789v 或 eink，默认 st7789v
* CO2 - 二氧化碳传感器型号，mhz19 或 s8，默认 mhz19
* TEMP - 温湿度传感器型号，bme280 或 sht31，默认 bme280
* DOMOTICZ - 是否启用 Domoticz 支持，enable 或 disable，默认 disable
* ROOM - 当前节点所处房间名称，需要英文字符，例如 livingroom
* IP - 当前节点 IP，建议使用固定 IP，便于后续 OTA 更新固件
* IDX_BH1750，IDX_PM25，IDX_CO2，IDX_TEMP，IDX_PRESSURE，IDX_HOCO - Domoticz 中对应传感器的设备 ID

另外，如果设置了 `IDX_HOCO`，将会将 PM 2.5 传感器类型设置为 PMS5003ST。

另外，`build.sh` 还提供了 `upload` 参数，可以在编译完成后马上烧录固件。

如果所有传感器类型与默认一致，可以直接使用以下命令编译及烧录固件，注意，需要提前将 NodeMCU-32S 连接到电脑上：

`./build.sh upload`

如果需要定制传感器型号，例如将温湿度传感器替换为 sht31，可以使用以下命令：

`TEMP=sht31 ./build.sh upload`

## 焊接及组装

建议参考 [立创开源平台 AirCube](https://oshwhub.com/wandaeda/aircube) 项目中的 PCB 来进行焊接和组装，其中 BH1750 和 BME280 传感器建议使用 2.54 弯针排母。

3D 模型中，外壳和后盖均已预置 M2 螺丝孔，组装时使用 M2*5 自攻螺丝将 PCB 固定在外壳上，再将后盖固定在外壳上即可。

## 为什么会有这个项目

可以参考这篇文章 [超简单 DIY - AirCube 空气检测站](https://xujiwei.com/blog/2022/12/aircube-diy-environment-monitor-station/)。

