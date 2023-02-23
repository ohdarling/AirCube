#pragma once

#include "esphome.h"
#include <Wire.h>
#include <Adafruit_BME280.h>

class CustomBME280Sensor : public PollingComponent {
public:
    Adafruit_BME280 bme280_;
    Sensor *temperature_sensor = new Sensor();
    Sensor *humdity_sensor = new Sensor();
    Sensor *pressure_sensor = new Sensor();

    CustomBME280Sensor() : PollingComponent(15000) { }

    void setup() override {
        bme280_.begin(0x76, &Wire);
    }

    void loop() override {

    }

    void update() override {
        auto temperature = bme280_.readTemperature();
        auto humdity = bme280_.readHumidity();
        auto pressure = bme280_.readPressure();
        temperature_sensor->publish_state(temperature);
        humdity_sensor->publish_state(humdity);
        pressure_sensor->publish_state(pressure / 100.0);
    }
};