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

  // c - cycleLength
  // p - periodLength
  // f - predicted (future) start
  this.changed_days =  function(c, p, f) {
    console.log('tampiState changed TampiDaysCharacteristic');
    if( this._update !== null ) {
        console.log('updating new mode uuid=', this.uuid);
        // var data = new Buffer(1);
        // data.writeUInt8(Math.round(days));
        var data = new Buffer([c, p, f]);
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
    // var data = new Buffer(1);
    var data = new Buffer(3);
    // CHANGE TAMPISTATE
    data.writeUInt8(Math.round(this.tampiState.cycleLength), 0);
    data.writeUInt8(Math.round(this.tampiState.periodLength), 1);
    data.writeUInt8(Math.round(this.tampiState.predictedStart), 2);
    console.log('onReadRequest returning ', data);
    callback(this.RESULT_SUCCESS, data);
  }
};

TampiDaysCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
    if(offset) {
        callback(this.RESULT_ATTR_NOT_LONG);
    }
    else if (data.length !== 3) {
        callback(this.RESULT_INVALID_ATTRIBUTE_LENGTH);
    }
    else {
        var cycleLength = data.readUInt8(0);
        var periodLength = data.readUInt8(1);
        var predictedStart = data.readUInt8(2);
        // CHANGE SET DAYS
        this.tampiState.set_days( cycleLength, periodLength, predictedStart );
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
