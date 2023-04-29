var util = require('util');
var bleno = require('bleno');

var CHARACTERISTIC_NAME = 'HSV';

function TampiHSVCharacteristic(tampiState) {
  TampiHSVCharacteristic.super_.call(this, {
    uuid: '0002A7D3-D8A4-4FEA-8174-1736E808C066',
    properties: ['read', 'write', 'notify'],
    secure: [],
    descriptors: [
        new bleno.Descriptor({
            uuid: '2901',
            value: CHARACTERISTIC_NAME,
        }),
        new bleno.Descriptor({
           uuid: '2904',
           value: new Buffer([0x07, 0x00, 0x27, 0x00, 0x01, 0x00, 0x00])
        }),
    ],
  });

  this._update = null;

  this.changed_hsv =  function(h, s, m) {
    console.log('tampiState changed TampiHSVCharacteristic');
    if( this._update !== null ) {
        var data = new Buffer([h, s, m]);
        this._update(data);
    } 
  }

  this.tampiState = tampiState;

  this.tampiState.on('changed-hsv', this.changed_hsv.bind(this));

}

util.inherits(TampiHSVCharacteristic, bleno.Characteristic);

TampiHSVCharacteristic.prototype.onReadRequest = function(offset, callback) {
  console.log('onReadRequest');
  if (offset) {
    console.log('onReadRequest offset');
    callback(this.RESULT_ATTR_NOT_LONG, null);
  }
  else {
    var data = new Buffer(3);
    data.writeUInt8(Math.round(this.tampiState.hue), 0);
    data.writeUInt8(Math.round(this.tampiState.saturation), 1);
    data.writeUInt8(Math.round(this.tampiState.mode), 2);
    console.log('onReadRequest returning ', data);
    callback(this.RESULT_SUCCESS, data);
  }
};

TampiHSVCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
    console.log('onWriteRequest');
    if(offset) {
        callback(this.RESULT_ATTR_NOT_LONG);
    }
    else if (data.length !== 3) {
        callback(this.RESULT_INVALID_ATTRIBUTE_LENGTH);
    }
    else {
        var hue = data.readUInt8(0);
        var saturation = data.readUInt8(1);
        var mode = data.readUInt8(2);
        this.tampiState.set_hsm( hue, saturation, mode );
        callback(this.RESULT_SUCCESS);
    }
};

TampiHSVCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

TampiHSVCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}

module.exports = TampiHSVCharacteristic;