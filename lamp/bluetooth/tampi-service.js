var util = require('util');
var bleno = require('bleno');

var TampiOnOffCharacteristic = require('./tampi-onoff-characteristic');
var TampiBrightnessCharacteristic = require('./tampi-brightness-characteristic');
var TampiHSVCharacteristic = require('./tampi-hsv-characteristic');
var TampiModeCharacteristic = require('./tampi-mode-characteristic');

function TampiService(lampiState) {
    bleno.PrimaryService.call(this, {
        uuid: '0001A7D3-D8A4-4FEA-8174-1736E808C066',
        characteristics: [
            new TampiHSVCharacteristic(lampiState),
            new TampiBrightnessCharacteristic(lampiState),
            new TampiOnOffCharacteristic(lampiState),
            new TampiModeCharacteristic(lampiState),
        ]
    });
}

util.inherits(TampiService, bleno.PrimaryService);

module.exports = TampiService;