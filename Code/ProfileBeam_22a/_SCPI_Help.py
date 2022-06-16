"""
_SCPI_Help.py

Note: This module and its global have to start with _ to avoid the
automatic menu generation of SCPI_Functions.py

- Wemos/Lolin S2Mini
- Motor FeatherWing
- 28BYJ-48, 5 V stepper motor
- FW Motor + to VBUS
- FW Motor - to GND
- FW M1 and M2 are, in order, are motor pink-orange-blue-yellow
- Running Adafruit CircuitPython 7.2.4 on 2022-03-31; FeatherS2 with ESP32S2
- library adafruit-circuitpython-bundle-7.x-mpy-20220119

Results:
Two turns took 12.039 seconds.
"""
import time
import bitbangio
import board
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper
import adafruit_veml7700

# i2c = bitbangio.I2C(board.SCL, board.SDA)
i2c = board.I2C() # uses board.SCL and board.SDA 
kit = MotorKit(i2c=i2c)
veml7700 = adafruit_veml7700.VEML7700(i2c)

def _step(n = 1):
    n = round(n)
    t0 = time.monotonic()
    if n > 0:
        for i in range(n):
            kit.stepper1.onestep(style=stepper.DOUBLE, direction=stepper.FORWARD)
    elif n < 0:
        for i in range(-n):
            kit.stepper1.onestep(style=stepper.DOUBLE, direction=stepper.BACKWARD)
    print(f"Took {time.monotonic() - t0} s")
    kit.stepper1.release()

def _lux():
    return veml7700.lux

def _light():
    return veml7700.light

def _gain():
    return veml7700.gain_value()

def _setGain(iGain=0):
    veml7700.light_gain = iGain

def _intT():
    return veml7700.integration_time_value()

def _setIntT(arg=12):
    veml7700.light_integration_time = arg

# EOF