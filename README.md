# AirCube 空气检测站

[English Version](README_EN.md)

AirCube 是一个开源的环境状态监测设备，可以监测各种环境状态，例如温度、湿度、二氧化碳浓度、PM 2.5 浓度等，还可以与 Domoticz、Home Assistant 等智能家居系统集成，建立家庭环境数据监测系统。

<img src="AirCube.png?raw=true" style="zoom:50%;" />

## 功能列表

* 概览页面，可以直观查看各种环境数据的当前数值，例如当前温度、湿度、PM 2.5 以及二氧化碳浓度。
* 各项数据的历史趋势数据，通过记录过去 12 小时的数据并通过图表展示环境数据的变化趋势。
* 特定传感器的详情数据，例如攀藤 PMS5003 可以同时检测 PM 1.0、PM 2.5、PM 10 浓度，在概览页面无法展示完全，就可以在详情页面展示出来。
* 设备信息界面，可以展示当前设备的名称、Wi-Fi 连接情况、运行时间等基础信息。
* 数据上报能力，可以通过 MQTT 将数据上报到 Domoticz 或 Home Assistant。
* 批量部署能力，通过脚本批量部署设备固件。

## 目录结构

* 3D_Model - 设备外壳 3D 模型文件，可以通过 FDM 类型 3D 打印机打印
  * AirCube_Back.stl - 后盖
  * AirCube_Eink.stl - 使用 E-ink 屏幕时的外壳模型
  * AirCube_Eink_Stand.stl - 使用 E-ink 屏幕时的屏幕支架
  * AirCube_LCD.stl - 使用 LCD 屏幕时的外壳模型
  * AirCube_LCD_Stand.stl - 使用 LCD 屏幕时的屏幕支架

* Firmware - 基于 ESPHome 的设备固件，因传感器造型可变化，未编译成二进行，可以自行编译
* Hardware - 包含用于制造 PCB 的 Gerber 文件和原理图

## PCB

PCB 尺寸为 6cm x 6cm，四角安装孔直径为 2mm。

* PCB 正面为屏幕及触摸按钮安装位置。

* PCB 底面为传感器及 NodeMCU 安装位置，目前版本预留了 IR、433MHz 以及电源接头，但并未使用。

<img src="Images/aircube-pcb-top.png?raw=true" alt="aircube-pcb-top" style="zoom:50%;" /><img src="Images/aircube-pcb-bottom.png?raw=true" alt="aircube-pcb-bottom" style="zoom:50%;" />

## 元件选型

| 图片                                                         | 类型         | 型号            | 价格（元） | 说明                                                         |
| ------------------------------------------------------------ | ------------ | --------------- | ---------- | ------------------------------------------------------------ |
| <img src="Images/aircube-part-bme280.png?raw=true" alt="BME280" style="width:200px;" /> | 温湿度       | BME280 或 SHT31 | 22         | 其中 BME280 还额外支持压强检测，同时支持这两种传感器主要是因为它们的引脚顺序相同，可以替换使用。 |
| <img src="Images/aircube-part-pms5003.png?raw=true" alt="PMS5003" style="width:200px" /> | 颗粒物浓度   | 攀藤 PMS5003    | 70         | 支持 PM 1.0、PM 2.5、PM 10 三种颗粒物浓度检测，以及 PMS5003ST，额外增加了甲醛浓度检测。另外 PMS7003 虽然同样可以使用，但是因为需要额外转接板，不能直接使用 1.25mm 8P 连接线，因此并不推荐。 |
| <img src="Images/aircube-part-mhz19.png?raw=true" alt="MH-Z19B" style="width:200px" /> | 二氧化碳浓度 | MH-Z19B         | 120        | 可以检测 400-5000 ppm 范围的二氧化碳浓度，当然也可以采用 SenseAir S8 传感器，它们的引脚位置和定义都完全一致。 |
| <img src="Images/aircube-part-bh1750.png?raw=true" alt="BH1750" style="width:200px" /> | 光照强度     | BH1750          | 4          | 如果使用光敏电阻还需要额外换算，还是直接采用传感器更简单直接。 |
| <img src="Images/aircube-part-touch-sensor.png?raw=true" alt="TTP223" style="width:200px;" /> | 触摸按钮     | TTP223          | 0.3        | 这个模块触摸感应距离大，可以隔着外壳完成触摸操作，用来切换信息页。 |
| <img src="Images/aircube-part-nodemcu32s.png?raw=true" alt="NodeMCU-32S" style="width:200px;;" /> | 单片机       | NodeMCU-32S     | 22         | 直接选用常见的 NodeMCU-32S 开发板，价格便宜，还可以直接给传感器提供 3.3V 供电。 |
| <img src="Images/aircube-part-lcd.png?raw=true" alt="1.54 LCD" style="width:200px" /> | 屏幕         | 1.54 LCD        | 20         | 1.54 寸 SPI 接口 IPS 屏幕：分辨率 240x240，主控 ST7789V。    |
| <img src="Images/aircube-part-eink.png?raw=true" alt="1.54 E-ink" style="width:200px;" /> | 屏幕         | 1.54 E-ink      | 30         | 1.54 寸 SPI 接口 E-ink 屏幕：单色屏，只支持黑白，分辨率 200x200。 |

**注：表格中的价格为淘宝上大致价格，随卖家不同价格也会不太相同。**

## 其他配件

| 配件                                                         | 型号                | 数量 | 用途                    |
| ------------------------------------------------------------ | ------------------- | ---- | ----------------------- |
| <img src="Images/aircube-5p-header-90.png?raw=true" alt="aircube-5p-header-90" style="width:100px" /> | 弯针 5P 2.54mm 母座 | 2    | 安装 BME280 以及 BH1750 |
| <img src="Images/aircube-3p-header.png?raw=true" alt="aircube-3p-header" style="width:100px" /> | 3P 2.54mm 母座      | 2    | 安装 TTP223 触摸传感器  |
| <img src="Images/aircube-15p-header.png?raw=true" alt="aircube-15p-header" style="width:100px" /> | 15P 2.54mm 母座     | 2    | 安装 NodeMCU-32S        |
| <img src="Images/aircube-5p-header.png?raw=true" alt="aircube-5p-header" style="width:100px" /> | 5P 2.54mm 母座      | 1    | 安装 MH-Z19B            |
| <img src="Images/aircube-4p-header.png?raw=true" alt="aircube-4p-header" style="width:100px" /> | 4P 2.54mm 母座      | 1    | 安装 MH-Z19B            |
| <img src="Images/aircube-8p-header.png?raw=true" alt="aircube-8p-header" style="width:100px" /> | 8P 2.54mm 母座      | 1    | 安装 1.54 寸 LCD        |
| <img src="Images/aircube-8p-1.25mm.png?raw=true" alt="aircube-8p-1.25mm" style="width:100px;" /> | 8P 1.25mm 直针座    | 1    | 安装 PMS5003            |
| <img src="Images/aircube-m2x5-screw.png?raw=true" alt="aircube-m2x5-screw" style="width:100px" /> | M2*5 沉头自攻螺丝   | 8    | 固定 PCB 以及后盖       |

## 焊接

**建议母座焊接顺序**

1. 5P 弯针 2.54mm 排母
2. 8P 1.25mm 直针座
3. 8P 2.54mm 母座
4. 3Px2 2.54mm 母座
5. 15P 2.54mm 母座
6. 5P 及 4P 2.54mm 母座

其中 BME280 预留位置为 6P，使用弯 5P 母座时，请使用下侧 5P，保留最上针脚留空。

建议参考 [立创开源平台 AirCube](https://oshwhub.com/wandaeda/aircube) 项目中的 PCB 来进行焊接。

## 组装

3D 模型中，外壳和后盖均已预置 M2 螺丝孔，组装时使用 M2*5 自攻螺丝将 PCB 固定在外壳上，再将后盖固定在外壳上即可。

**组装顺序**

1. 将 3D 打印的屏幕支架安装在 PCB 上
2. 将屏幕安装到排母上，并且 M2 螺丝固定在屏幕支架上
3. 将 2 个触摸传感器安装在排母上
4. 将 PMS5003 传感器的连接线连接到 1.25mm 针座上
5. 将 NodeMCU-32S 安装在排母上
6. 将 MH-Z19B 安装在排母上
7. 将 BH1750 安装在排母上
8. 将 PCB 放进外壳中（可以倾斜着放进去），使用 M2 螺丝固定
9. 将 PMS5003 固定在后盖上，有必要可以使用双面胶固定
10. 将后盖使用 M2 螺丝固定在外壳上
11. 将 BME280 在侧面安装在排母上

注意，BME280 预设安装位置为外壳外部，因此需要将其他部件安装完成，装入外壳固定好后，再从侧面将 BME280 插入 5P 母座。

另外，BH1750 的开孔是朝上的，如果需要避免积灰，可以使用透明胶带盖住。

## 编译和烧录固件

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

## 为什么会有这个项目

可以参考这篇文章 [超简单 DIY - AirCube 空气检测站](https://xujiwei.com/blog/2022/12/aircube-diy-environment-monitor-station/)。

