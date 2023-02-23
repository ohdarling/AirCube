#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const { exit } = require('process');

function parse_csv(content) {
    const lines = content.split('\n').map(v => v.trim()).filter(v => v.length > 0);
    if (lines.length < 2) {
        return [];
    }

    function parse_value(val) {
        if (val.length >= 2 && val.substr(0, 1) == '"' && val.substr(val.length-1, 1) == '"') {
            return val.substr(1, val.length-2);
        } else {
            return val;
        }
    }

    const fields = lines[0].split(',').map(parse_value);
    const rows = lines.slice(1).map(v => v.split(',')).map(cols => {
        let obj = {};
        cols.map(parse_value).map((v, idx) => {
            obj[fields[idx]] = v;
        });
        return obj;
    });
    return rows;
}

const csv_content = fs.readFileSync('devices_table.csv', {encoding: 'utf8'});
const rows = parse_csv(csv_content);
// console.log(rows);

let update_devices = rows;

if (process.argv.length > 2) {
    const devs = process.argv.slice(2);
    update_devices = rows.filter(obj => {
        return devs.indexOf(obj.Name) > -1;
    });
    if (update_devices.length == 0) {
        console.log('Device not found:', single_dev);
        exit(0);
    }
}

console.log('Updating', update_devices.length, 'devices ...');

const use_ota = process.env['OTA'] ?? 'true';
const action = process.env['ACTION'] ?? 'upload';

update_devices.forEach(obj => {
    console.log('>>>>>>>>>>>>>>>>>>>>>>>>>');
    console.log('Updating', obj.Title, '...');
    const domoticz_enable = obj.TemperatureIdx || obj.CO2Idx || obj.PM25Idx || obj.LuxIdx || obj.HOCOIdx || obj.PressureIdx;
    const cmd = `OTA=${use_ota} DOMOTICZ=${domoticz_enable ? 'enable' : 'disable'} ROOM=${obj.Name} IP=${obj.IP} DP=${obj.Display} CO2=${obj.CO2} TEMP=${obj.Temperature} IDX_BH1750=${obj.LuxIdx} IDX_PM25=${obj.PM25Idx} IDX_CO2=${obj.CO2Idx} IDX_TEMP=${obj.TemperatureIdx} IDX_PRESSURE=${obj.PressureIdx} IDX_HOCO=${obj.HOCOIdx} ./build.sh ${action}`
    console.log(cmd);
    execSync(cmd, { stdio: 'inherit' });
});
