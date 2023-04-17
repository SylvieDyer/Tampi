import pigpio

PWM_FREQUENCY = 1000
PWM_RANGE = 1000

RED_GPIO = 19
GREEN_GPIO = 26
BLUE_GPIO = 13

RGBS = [RED_GPIO, GREEN_GPIO, BLUE_GPIO]


class LampDriver(object):
    def __init__(self):
        self.pi = pigpio.pi()
        for p in RGBS:
            self.pi.set_PWM_frequency(p, PWM_FREQUENCY)
            self.pi.set_PWM_range(p, PWM_RANGE)
            self.pi.set_PWM_dutycycle(p, 0)

        self.current = [0, 0, 0]
        #self.power_off()

    def set_color(self, values):
        for (pin, value) in zip(self.PINS, values):
            self.pi.set_PWM_dutycycle(pin, value * 100)

    def set_mode(self, state, brightness, is_on):

        if is_on:
            # cycle mode
            if state == 0:
                #placeholder for now
                self.current = [1, 0, 0]
            # preset 1 mode
            elif state == 1:
                self.current = [.4, .6, .1]
            # preset 2 mode
            elif state == 2:
                self.current = [.7, .2, .4]

        for i in range(len(self.current)):
            self.current[i] = self.current[i] * brightness
            self.pi.set_PWM_dutycycle(RGBS[i], self.current[i] * PWM_RANGE)
        #self.set_color(self.current)

    def power_on(self, value):
        self.set_mode(value)

    def power_off(self):
        for pin in self.PINS:
            self.pi.write(pin, 0)

    def set_brightness(self, value):
        print("VAL RECIEVED: " + str(value))
        for val in self.current:
            print(self.current)
            val *= value
        self.set_color(self.current)
