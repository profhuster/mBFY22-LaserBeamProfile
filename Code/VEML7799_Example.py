import time
import board
import adafruit_veml7700

from adafruit_motorkit import MotorKit
from adafruit_motor import stepper


i2c = board.I2C() # uses board.SCL and board.SDA 
veml7700 = adafruit_veml7700.VEML7700(i2c)
kit = MotorKit(i2c=i2c)

# Print parameters
print(f"# Gain: {veml7700.gain_values[veml7700.gain_value()]}")
print(f"# Integration time: \
{veml7700.integration_time_values[veml7700.light_integration_time]}")
print(f"# Resolution: {veml7700.resolution()}")
time.sleep(1.0)

iLoop = 0
while True:
    if iLoop % 20 == 0:
        print(f"#  lux  ,   light,   white")
    print(f"{veml7700.lux:.4f}, {veml7700.light:7d}, {veml7700.white:7d}")
    time.sleep(1.0)
    iLoop += 1

# EOF