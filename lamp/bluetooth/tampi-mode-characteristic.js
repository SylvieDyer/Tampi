var util = require('util');
var bleno = require('bleno');

var CHARACTERISTIC_NAME = 'mode';

function TampiModeCharacteristic(tampiState) {
  TampiModeCharacteristic.super_.call(this, {
    uuid: '0005A7D3-D8A4-4FEA-8174-1736E808C066',
    properties: ['read', 'write', 'notify'],
    secure: [],
    descriptors: [
        new bleno.Descriptor({
            uuid: '2901',
            value: CHARACTERISTIC_NAME,
        }),
        new bleno.Descriptor({
           uuid: '2904',
           value: new Buffer([0x04, 0x00, 0x27, 0x00, 0x01, 0x00, 0x00])
        }),
    ],
  });

  this._update = null;

  this.changed_mode =  function(mode) {
    console.log('tampiState changed TampiModeCharacteristic');
    if( this._update !== null ) {
        console.log('updating new mode uuid=', this.uuid);
        var data = new Buffer(1);
        data.writeUInt8(Math.round(mode));
        this._update(data);
    }
    }

  this.tampiState = tampiState;

  this.tampiState.on('changed-mode', this.changed_mode.bind(this));

}

util.inherits(TampiModeCharacteristic, bleno.Characteristic);

TampiModeCharacteristic.prototype.onReadRequest = function(offset, callback) {
  console.log('onReadRequest');
  if (offset) {
    console.log('onReadRequest offset');
    callback(this.RESULT_ATTR_NOT_LONG, null);
  }
  else {
    var data = new Buffer(1);
    data.writeUInt8(Math.round(this.tampiState.mode));
    console.log('onReadRequest returning ', data);
    callback(this.RESULT_SUCCESS, data);
  }
};

TampiModeCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
    if(offset) {
        callback(this.RESULT_ATTR_NOT_LONG);
    }
    else if (data.length !== 1) {
        callback(this.RESULT_INVALID_ATTRIBUTE_LENGTH);
    }
    else {
        var mode = data.readUInt8(0);
        this.tampiState.set_mode( mode );
        callback(this.RESULT_SUCCESS);
    }
};

TampiModeCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

TampiModeCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}


module.exports = TampiModeCharacteristic;
