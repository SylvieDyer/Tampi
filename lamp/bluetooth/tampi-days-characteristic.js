var util = require('util');
var bleno = require('bleno');

var CHARACTERISTIC_NAME = 'days';

function TampiDaysCharacteristic(tampiState) {
  TampiDaysCharacteristic.super_.call(this, {
    uuid: '0006A7D3-D8A4-4FEA-8174-1736E808C066',
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

  this.changed_days =  function(days) {
    console.log('tampiState changed TampiDaysCharacteristic');
    if( this._update !== null ) {
        console.log('updating new mode uuid=', this.uuid);
        var data = new Buffer(1);
        data.writeUInt8(Math.round(days));
        this._update(data);
    }
    }

  this.tampiState = tampiState;

  this.tampiState.on('update-days', this.changed_days.bind(this));

}

util.inherits(TampiDaysCharacteristic, bleno.Characteristic);

TampiDaysCharacteristic.prototype.onReadRequest = function(offset, callback) {
  console.log('onReadRequest');
  if (offset) {
    console.log('onReadRequest offset');
    callback(this.RESULT_ATTR_NOT_LONG, null);
  }
  else {
    var data = new Buffer(1);
    data.writeUInt8(Math.round(this.tampiState.days));
    console.log('onReadRequest returning ', data);
    callback(this.RESULT_SUCCESS, data);
  }
};

TampiDaysCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
    if(offset) {
        callback(this.RESULT_ATTR_NOT_LONG);
    }
    else if (data.length !== 1) {
        callback(this.RESULT_INVALID_ATTRIBUTE_LENGTH);
    }
    else {
        var days = data.readUInt8(0);
        this.tampiState.set_days( days );
        callback(this.RESULT_SUCCESS);
    }
};

TampiDaysCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

TampiDaysCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}


module.exports = TampiDaysCharacteristic;
