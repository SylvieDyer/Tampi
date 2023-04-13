import platform
from kivy.app import App
from kivy.properties import ColorProperty, NumericProperty, StringProperty, BooleanProperty
from kivy.clock import Clock
from kivy.uix.popup import Popup
from kivy.uix.label import Label
from lamp_driver import LampDriver

class TampiApp(App):
    curr_mode = NumericProperty(0)
    cycle = StringProperty('normal')
    preset1 = StringProperty('normal')
    preset2 = StringProperty('normal')
    brightness = NumericProperty()
    power = BooleanProperty(False)
    driver = LampDriver()

    def on_cycle(self, instance, value):
        self._update_lamp_mode(0, self.cycle)

    def on_preset1(self, instance, value):
        self._update_lamp_mode(1, self.preset1)

    def on_preset2(self, instance, value):
        self._update_lamp_mode(2, self.preset2)

    def on_brightness(self, instance, value):
        self._update_brightness(self.brightness)

    def on_power(self, instance, value):
        self._update_power(self.power)

    def _update_lamp_mode(self, value, state):
        self.curr_mode = value
        if (value == 0):
            self.cycle = 'down'
            self.preset1 = 'normal'
            self.preset2 = 'normal'
        elif (value == 1):
            self.cycle = 'normal'
            self.preset1 = 'down'
            self.preset2 = 'normal'
        elif (value == 2):
            self.cycle = 'normal'
            self.preset1 = 'normal'
            self.preset2 = 'down'
        if self.power:
            self.driver.set_mode(value)

    def _update_brightness(self, value):
        self.brightness = value
        if self.power:
            self.driver.set_brightness(value)

    def _update_power(self, value):
        self.power = value
        if value:
            self.driver.power_on(self.curr_mode)
        else:
            self.driver.power_off()

    def set_up_GPIO_and_device_status_popup(self):
        self.pi = pigpio.pi()
        self.pi.set_mode(17, pigpio.INPUT)
        self.pi.set_pull_up_down(17, pigpio_PUD_UP)
        Clock.schedule_interval(self._poll_GPIO, 0.05)
        self.network_status_popup = self._build_network_status_popup()
        self.network_status_popup.bind(on_open=self.update_device_status_popup)

    def _build_network_status_popup(self):
        return Popup(title='Device Status',
                     content=Label(text='IP ADDRESS WILL GO HERE'),
                     size_hint=(1, 1), auto_dismiss=False)

    def update_device_status_popup(self, instance):
        interface = "wlan0"
        ipaddr = lampi.lampi_util.get_ip_address(interface)
        deviceid = lampi.lampi_util.get_device_id()
        msg = ("{}: {}\n"
               "DeviceID: {}\n"
               "Broker Bridged: {}\n"
               "Async Analytics"
               ).format(
                        interface,
                        ipaddr,
                        deviceid,
                        self.mqtt_broker_bridged)
        instance.content.text = msg

    def on_gpio17_pressed(self, instance, value):
        if value:
            self.network_status_popup.open()
        else:
            self.network_status_popup.dismiss()

    def _poll_GPIO(self, dt):
        # GPIO17 is the rightmost button when looking front of LAMPI
        self.gpio17_pressed = not self.pi.read(17)
