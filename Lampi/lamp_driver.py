import pigpio

class LampDriver(object):
    def __init__(self):
        self.pi = pigpio.pi()
        self.PIN_R = 19
        self.PIN_G = 26
        self.PIN_B = 13
        self.PINS = [self.PIN_R, self.PIN_G, self.PIN_B]
        self.current = [0, 0, 0]
        self.power_off()
        for pin in self.PINS:
            self.pi.set_PWM_range(pin, 100)

    def set_color(self, values):
        for (pin, value) in zip(self.PINS, values):
            self.pi.set_PWM_dutycycle(pin, value * 100)

    def set_mode(self, value):
        # cycle mode
        if value == 0:
            #placeholder for now
            self.current = [1, 0, 0]
        # preset 1 mode
        elif value == 1:
            self.current = [.4, .6, .1]
        # preset 2 mode
        elif value == 2:
            self.current = [.7, .2, .4]

        self.set_color(self.current)

    def power_on(self, value):
        self.set_mode(value)

    def power_off(self):
        for pin in self.PINS:
            self.pi.write(pin, 0)

    def set_brightness(self, value):
        for val in self.current:
            val *= value
        self.set_color(self.current)
