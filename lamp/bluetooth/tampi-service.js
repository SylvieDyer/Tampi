var util = require('util');
var bleno = require('bleno');

var TampiOnOffCharacteristic = require('./tampi-onoff-characteristic');
var TampiBrightnessCharacteristic = require('./tampi-brightness-characteristic');
var TampiHSMCharacteristic = require('./tampi-hsm-characteristic');
var TampiDaysCharacteristic = require('./tampi-days-characteristic')

function TampiService(lampiState) {
    bleno.PrimaryService.call(this, {
        uuid: '0001A7D3-D8A4-4FEA-8174-1736E808C066',
        characteristics: [
            new TampiHSMCharacteristic(lampiState),
            new TampiBrightnessCharacteristic(lampiState),
            new TampiOnOffCharacteristic(lampiState),
            new TampiDaysCharacteristic(lampiState)
        ]
    });
}

util.inherits(TampiService, bleno.PrimaryService);

module.exports = TampiService;
