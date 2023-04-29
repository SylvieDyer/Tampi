import platform
import lamp_util
import pigpio
import os
import json
from kivy.app import App
from kivy.properties import AliasProperty, BooleanProperty, ColorProperty, NumericProperty, StringProperty
from kivy.clock import Clock
from kivy.uix.popup import Popup
from kivy.uix.label import Label
from paho.mqtt.client import Client
from tampi_common import *
import lamp_util

MQTT_CLIENT_ID= "lamp_ui"

class TampiApp(App):
    _updated = False
    _updatingUI = False
    curr_mode = NumericProperty()
    _remainingDays = NumericProperty(20)
    _cycle = StringProperty('normal')
    _preset1 = StringProperty('normal')
    _preset2 = StringProperty('normal')
    _brightness = NumericProperty()
    lamp_is_on = BooleanProperty()

    def _get_cycle(self):
        return self._cycle

    def _set_cycle(self, value):
        self._cycle = value
        if value == "down":
            self._preset1 = "normal"
            self._preset2 = "normal"
            self.curr_mode = 0

    def _get_preset1(self):
        return self._preset1

    def _set_preset1(self, value):
        self._preset1 = value
        if value == "down":
            self._cycle = "normal"
            self._preset2 = "normal"
            self.curr_mode = 1

    def _get_preset2(self):
        return self._preset2

    def _set_preset2(self, value):
        self._preset2 = value

        if value == "down":
            self._cycle = "normal"
            self._preset1 = "normal"
            self.curr_mode = 2

    def _get_brightness(self):
        return self._brightness

    def _set_brightness(self, value):
        self._brightness = value

    def _get_remainingDays(self):
        return self._remainingDays

    def _set_remainingDays(self, value):
        self._remainingDays = value

    remainingDays = AliasProperty(_get_remainingDays, _set_remainingDays, bind=['_remainingDays'])
    cycle = AliasProperty(_get_cycle, _set_cycle, bind=['_cycle'])
    preset1 = AliasProperty(_get_preset1, _set_preset1, bind=['_preset1'])
    preset2 = AliasProperty(_get_preset2, _set_preset2, bind=['_preset2'])
    brightness = AliasProperty(_get_brightness, _set_brightness, bind=['_brightness'])
    gpio17_pressed = BooleanProperty(False)

    def on_start(self):
        self._publish_clock = None
        self.mqtt_broker_bridge = False
        self._assocaited = True
        self.mqtt = Client(client_id=MQTT_CLIENT_ID)
        self.mqtt.enable_logger()
        self.mqtt.on_connect = self.on_connect
        self.mqtt.connect(MQTT_BROKER_HOST, port=MQTT_BROKER_PORT,
                          keepalive=MQTT_BROKER_KEEP_ALIVE_SECS)
        self.mqtt.loop_start()
        self.set_up_GPIO_and_device_status_popup()

    def on_cycle(self, instance, value):
        if self._updatingUI:
            return

        if self._publish_clock is None:
            self._publish_clock = Clock.schedule_once(
                lambda dt: self._update_lamp_mode(), 0.01)
        #self._update_lamp_mode(0, self.cycle)

    def on_preset1(self, instance, value):
        if self._updatingUI:
            return

        if self._publish_clock is None:
            self._publish_clock = Clock.schedule_once(
                lambda dt: self._update_lamp_mode(), 0.01)

    def on_preset2(self, instance, value):
        if self._updatingUI:
            return

        if self._publish_clock is None:
            self._publish_clock = Clock.schedule_once(
                lambda dt: self._update_lamp_mode(), 0.01)

    def on_brightness(self, instance, value):
        if self._updatingUI:
            return

        if self._publish_clock is None:
            self._publish_clock = Clock.schedule_once(
                lambda dt: self._update_lamp_mode(), 0.01)

    def on_lamp_is_on(self, instance, value):
        if self._updatingUI:
            return

        if self._publish_clock is None:
            self._publish_clock = Clock.schedule_once(
                lambda dt: self._update_lamp_mode(), 0.01)


    def on_connect(self, client, userdata, flags, rc):
        self.mqtt.publish(client_state_topic(MQTT_CLIENT_ID), b"1",
                          qos=2, retain=True)
        self.mqtt.message_callback_add(TOPIC_LAMP_CHANGE_NOTIFICATION,
                                       self.receive_new_lamp_state)
        self.mqtt.subscribe(TOPIC_LAMP_CHANGE_NOTIFICATION, qos=1)


    def receive_new_lamp_state(self, client, userdata, message):
        print("NEW MESSAGE")
        new_state = json.loads(message.payload.decode('utf-8'))
        Clock.schedule_once(lambda dt: self._update_ui(new_state), 0.01)

    def _update_ui(self, new_state):
        if self._updated and new_state['client'] == MQTT_CLIENT_ID:
            print("NO UPDATE")
            return

        self._updatingUI = True
        try:
            print("updating UI")
            if 'mode' in new_state:
                self.curr_mode = new_state['mode']
                if self.curr_mode == 0:
                    self.cycle = 'down'

                elif self.curr_mode == 1:
                    self.preset1 = 'down'

                elif self.curr_mode == 2:
                    self.preset2 = 'down'

            if 'brightness' in new_state:
                print("NEW BRIGHTNESS:{}".format(new_state['brightness']))
                self.brightness = new_state['brightness'] * 100

            if 'on' in new_state:
                self.lamp_is_on = new_state['on']

            if 'days' in new_state:
                self.remainingDays = new_state['days']
        finally:
            self._updatingUI = False

        print("NOT UPDATING")
        self._updated = True


    def _update_lamp_mode(self):
        print("update lamp mode: ")
        print(self._brightness)
        msg = {'mode': self.curr_mode,
               'days': self.remainingDays,
               'brightness': self._brightness,
               'on': self.lamp_is_on,
               'client': MQTT_CLIENT_ID}
        self.mqtt.publish(TOPIC_SET_LAMP_CONFIG,
                          json.dumps(msg).encode('utf-8'),
                          qos=1, retain=True)
        self._publish_clock = None

    def set_up_GPIO_and_device_status_popup(self):
        self.pi = pigpio.pi()
        self.pi.set_mode(17, pigpio.INPUT)
        self.pi.set_pull_up_down(17, pigpio.PUD_UP)
        Clock.schedule_interval(self._poll_GPIO, 0.05)
        self.network_status_popup = self._build_network_status_popup()
        self.network_status_popup.bind(on_open=self.update_device_status_popup)

    def _build_network_status_popup(self):
        return Popup(title='Device Status',
                     content=Label(text='IP ADDRESS WILL GO HERE'),
                     size_hint=(1, 1), auto_dismiss=False)

    def update_device_status_popup(self, instance):
        interface = "wlan0"
        print("MAKING CALLS")
        ipaddr = lamp_util.get_ip_address(interface)
        deviceid = lamp_util.get_device_id()
        msg = ("{}: {}\n"
               "DeviceID: {}\n"
               ).format(
                        interface,
                        ipaddr,
                        deviceid)
        instance.content.text = msg

    def on_gpio17_pressed(self, instance, value):
        print("BUTTON PRESSED")
        if value:
            self.network_status_popup.open()
        else:
            self.network_status_popup.dismiss()

    def _poll_GPIO(self, dt):
        # GPIO17 is the rightmost button when looking front of LAMPI
        self.gpio17_pressed = not self.pi.read(17)
