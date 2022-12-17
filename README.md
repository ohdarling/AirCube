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

## 为什么会有这个项目

可以参考这篇文章 [超简单 DIY - AirCube 空气检测站](https://xujiwei.com/blog/2022/12/aircube-diy-environment-monitor-station/)。

