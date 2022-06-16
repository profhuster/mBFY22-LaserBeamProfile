"""
ProfileBeam_22a

Runs laser beam profiler
Uses SCPI-like commands over USB

Commands:
  - HELP - Print this list.
  - IDN - Identify microcontroller and code version.
  - RST - Reset to initial defaults.
  - LUX - Return current light measurement.
  - POS - Get current position.
  - QUIT - Exit and go to REPL.
  - STEP # - Move # steps. Negative is backward.
  - SETH - Set home p[osition
  - HOME - Move to home position
  - NDAT [#?] - Get/set number of data points.
  - DSTP [#?] - Get/set steps per data point.
  - DATA - Take position, lux data. Return home.
  - STUM # - Move # microns rounded to nearest step. Negative is backward.
==== To Be Implemented ====
  - CAL [#?] - Get/set lux sensor range.
"""
print("ProfileBeam_22a")
import SCPI_Functions

(nameList, fcnList) = SCPI_Functions._init()
print(f"nameList = >{nameList}<")

# Get help function
for i in range(len(nameList)):
    if 'help' == nameList[i]:
        helpFcn = fcnList[i]
helpFcn()

# Main SCPI Loop
while True:
    response = input(">> ").lower().strip()
    print(f">{response}<")
    
    found = False
    for i in range(len(nameList)):
        # Find function
        if nameList[i] in response:
            found = True
            # Find args, if any
            if len(response) > len(nameList[i]):
                arg = response[len(nameList[i]):]
                fcnList[i](arg)
            else:
                fcnList[i]()
            break

    if not found:
        print(response, "Not found")
        helpFcn()

# EOF