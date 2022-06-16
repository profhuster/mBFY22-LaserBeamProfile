"""
testLuxCal.py

Print lux for different gains and integration times.

ProfHuster@gmail.com
2022-06-13
"""
import time
import board
import adafruit_veml7700

i2c = board.I2C() # uses board.SCL and board.SDA 
veml7700 = adafruit_veml7700.VEML7700(i2c)

print(f"lux = {veml7700.lux}")
# EOF