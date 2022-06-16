"""
testLuxSensor_22b.py
"""
print("# testLuxSensor_22b")

import time
import board
import adafruit_veml7700

# For calculating statistics
from math import sqrt
N = 10

debug = False

# i2c = bitbangio.I2C(board.SCL, board.SDA)
i2c = board.I2C() # uses board.SCL and board.SDA 
veml7700 = adafruit_veml7700.VEML7700(i2c)

print(f"# gain, int. time (ms), ms/read, counts, stdCount, lux, stdLux, res")
for i in veml7700.gain_values:
    veml7700.light_gain = i
    for j in veml7700.integration_time_values:
        veml7700.light_integration_time = j
        # From tests it take two integration times to get a good reading.
        sleepIT = 2 * 1e-3 * veml7700.integration_time_value()
        # Take one set & throw away because readings aren't settled
        time.sleep(sleepIT)
        light0 = veml7700.light
        lux0 = veml7700.lux
        # Initialize for statistics
        avgL = 0.0
        stdL = 0.0
        avgX = 0.0
        stdX = 0.0
        # Start time
        t0 = time.monotonic_ns()
        for i in range(10):
            # Sleep before reading
            time.sleep(sleepIT)
            light0 = veml7700.light
            lux0 = veml7700.lux
            if debug:
                print(light0, lux0)
            # Calculate avg and std of readings
            avgL += light0
            stdL += light0 * light0
            avgX += lux0
            stdX += lux0 * lux0
        # end time
        dt_ms = 1e-6 * (time.monotonic_ns() - t0) / N
        #Calculate statistics
        avgL /= N
        stdL /= N
        arg = stdL - avgL * avgL
        if arg > 0:
            stdL = sqrt(arg)
        else:
            stdL = 0.0
        avgX /= N
        stdX /= N
        arg = stdX - avgX * avgX
        if arg > 0:
            stdX = sqrt(arg)
        else:
            stdX = 0.0
        
        print( \
f"{veml7700.gain_value():5.3f}, {veml7700.integration_time_value():3d}, "+\
f"{dt_ms:4.0f}, {avgL:7.1f}, {stdL:4.1f}, {avgX:8.1f}, {stdX:4.1f}, "+\
f"{veml7700.resolution():6.4f}")
        # print(1e-9 * (time.monotonic_ns() - t0))


# EOF