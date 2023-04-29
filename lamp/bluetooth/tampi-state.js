var events = require('events');
var util = require('util');
var mqtt = require('mqtt');

function TampiState() {
    events.EventEmitter.call(this);

    this.mode = 0x00;
    this.days = 0x00;
    this.is_on = true;
    this.brightness = 0xFF;
    this.hue = 0xFF;
    this.saturation = 0xFF;
    this.value = 0xFF;
    this.clientId = 'lamp_bt_peripheral';
    this.has_received_first_update = false;

    var that = this;
    var client_connection_topic = 'lamp/connection/' + this.clientId + '/state';
    
    var mqtt_options = {
    clientId: this.clientId,
    'will' : {
        topic: client_connection_topic,
        payload: '0',
        qos: 2,
        retain: true,
        },
    }

    var mqtt_client = mqtt.connect('mqtt://localhost', mqtt_options);
    mqtt_client.on('connect', function() {
        console.log('connected!');
        mqtt_client.publish(client_connection_topic,
            '1', {qos:2, retain:true})
        mqtt_client.subscribe('lamp/changed');
    });

    mqtt_client.on('message', function(topic, message) {
        new_state = JSON.parse(message);
        console.log('NEW STATE: ', new_state);
        // if the client id matches ours and we have received
        //   at least one update before
        if( new_state['client'] == that.clientId
                && that.has_received_first_update) {
            console.log("...ignoring lamp changed update that we initiated");
            return;
        }

        var new_mode = new_state['mode'];
        var new_days = new_state['days'];
        var new_onoff = new_state['on'];
        var new_brightness = Math.round(new_state['brightness']*0xFF);
        var new_hue = Math.round(new_state['color']['h']*0xFF);
        var new_saturation = Math.round(new_state['color']['s']*0xFF);
        
        if (that.new_mode !== new_mode) {
            console.log('MQTT - NEW MODE');
            that.mode = new_mode;
            that.emit('changed-mode', that.mode);
        }
        if (that.new_days !== new_days) {
            console.log('MQTT - DAYS UPDATED');
            that.days = new_days;
            that.emit('changed-days', that.days);
        }
        if (that.is_on !== new_onoff) {
            console.log('MQTT - NEW ON/OFF');
            that.is_on = new_state['on'];
            that.emit('changed-onoff', that.is_on);
        }
        if (that.brightness !== new_brightness ) { 
            console.log('MQTT - NEW BRIGHTNESS %d', new_brightness);
            that.brightness = new_brightness;
            that.emit('changed-brightness', that.brightness);
        }
        if ( (that.hue !== new_hue ) || (that.saturation !== new_saturation) ) { 
            console.log('MQTT - NEW HSV %d %d', new_hue, new_saturation);
            that.hue = new_hue;
            that.saturation = new_saturation;
            that.emit('changed-hsv', that.hue, that.saturation, that.value);
        }
        that.has_received_first_update = true;
    });

    this.mqtt_client = mqtt_client;
    
}

util.inherits(TampiState, events.EventEmitter);

// TampiState.prototype.set_mode = function(mode) {
//     this.mode = mode;
//     var tmp = {'client': this.clientId, 'mode': this.mode};
//     this.mqtt_client.publish('lamp/set_config', JSON.stringify(tmp));
//     console.log('mode = ', this.mode, ' msg: ', JSON.stringify(tmp));
// };

TampiState.prototype.set_days = function(days) {
    this.days = days;
    var tmp = {'client': this.clientId, 'days': this.days};
    this.mqtt_client.publish('lamp/set_config', JSON.stringify(tmp));
    console.log('days = ', this.days, ' msg: ', JSON.stringify(tmp));
};

TampiState.prototype.set_onoff = function(is_on) {
    this.is_on = is_on;
    var tmp = {'client': this.clientId, 'on': this.is_on };
    this.mqtt_client.publish('lamp/set_config', JSON.stringify(tmp));
    console.log('is_on = ', this.is_on, ' msg: ', JSON.stringify(tmp));
};

TampiState.prototype.set_brightness = function(brightness) {
    this.brightness = brightness;
    var tmp = {'client': this.clientId, 'brightness' : this.brightness / 0xFF};
    this.mqtt_client.publish('lamp/set_config', JSON.stringify(tmp));
    console.log('brightness = ', this.brightness);
};

TampiState.prototype.set_hsm = function(hue, saturation, mode) {
    this.hue = hue;
    this.saturation = saturation;
    // this.value = value;
    this.mode = mode;
    var tmp = {'client': this.clientId,
               'mode' : this.mode,
               'color' : {'h': this.hue / 0xFF, 's': this.saturation / 0xFF}};
    this.mqtt_client.publish('lamp/set_config', JSON.stringify(tmp));
    console.log('hsm = ', this.hue, this.saturation, this.mode);
};

module.exports = TampiState;