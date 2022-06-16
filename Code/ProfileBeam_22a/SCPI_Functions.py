# Added:
# Read and print CPU Temperature
# SCPI_Functions
print(__name__)

# Carefully import auxiliary functions.
# Anything imported must begin with _ or it screw up the menu
from _SCPI_Help import _step, _lux, _light, _gain, _setGain, _intT, _setIntT

# Constants
# mechanical advantage * mm/rev of scew / steps per rev of motor
_UM_PER_STEP = (37 / 33) * 500 / 513
_BACKLASH = 50 # When moving in negative direction, take out backlash

# Global variables
_G_position = 0 # position in steps variable
_G_nData = 0 # Number of data points to take
_G_dStp = 0 # Number of steps for each data point
_G_gains = (0.125, 0.25, 1.0, 2.0) # Allowed light sensor gains
_G_gainDict = {"1.0":0, "2.0":1, "0.125":2, "0.25":3}
_G_gain_default = 1.0
_G_gain = _G_gain_default
_G_intTs = (25, 50, 100, 200, 400, 800) # Allowed integration times in ms
_G_intTDict = {"25":12, "50":8, "100":0, "200":1, "400":2, "800":3}
_G_intT_default = 25
_G_intT = _G_intT_default

def help():
    global help_doc
    # print("HELP function")
    for d in main_doc:
        print(d)
    # print("End HELP")
help_doc = "HELP - Prints this list."

def idn():
    from board import board_id
    print("Code", __name__, "running on", board_id)
idn_doc = "IDN - Identify software and hardware."

def seth():
    global _G_position
    _G_position = 0
seth_doc = "SETH - Set Home to current position."

def home():
    global _G_position
    step(-_G_position)
home_doc = "HOME - Go to Home position."
    
def rst():
    global _G_position, _G_nData
    seth() # position in steps variable
    ndat("0") # Number of data points to take
    dstp("0") # Number of steps per data point
    _G_gain = _G_gain_default
    _setGain()
    _G_intT = _G_intT_default
    _setIntT()

rst_doc = "RST - Resets default parameters."

def ndat(arg="?"):
    global _G_nData
    print("ndat arg = >", arg, "<")
    if "?" in arg:
        print(_G_nData)
    else:
        try:
            nData = int(arg)
        except ValueError:
            print("ndata exception")
            return
        if nData >= 0:
            _G_nData = nData
        else:
            print("nData must be positive or zero")        
ndat_doc = "NDAT [#?] - Set or return number of data points."

def dstp(arg="?"):
    global _G_dStp
    print("dstp arg = >", arg, "<")
    if "?" in arg:
        print(_G_dStp)
    else:
        try:
            dStp = int(arg)
        except ValueError:
            print("dStp exception")
            return
        if dStp >= 0:
            _G_dStp = dStp
        else:
            print("dStp must be positive or zero")        
dstp_doc = "DSTP [#?] - Set or return number of steps per data point."

def data():
    global _G_dStp, _G_nData
    print("data")
    if _G_nData < 1:
        return
    print(f"{_G_position}, {_UM_PER_STEP * _G_position}, {_light()}, {_lux()}")
    for iDat in range(_G_nData-1):
        step(_G_dStp)
        print(f"{_G_position}, {_UM_PER_STEP * _G_position}, {_light()}, {_lux()}")
    home()
data_doc = f"DATA - Takes {_G_nData} data points. Moves {_G_dStp} steps every point."

def lux():
    print(f" {_lux()} lux")
lux_doc = "LUX - Prints light sensor reading in lux."

def step(nSteps=0):
    global _G_position, _BACKLASH
    # print("_BACKLASH: ", _BACKLASH)
    try:
        nSteps = int(nSteps)
    except ValueError:
        nSteps = 0
    if nSteps <= 0:
        _step(nSteps - _BACKLASH)
        _step(_BACKLASH)
    else:
        _step(nSteps)
    _G_position += nSteps   
step_doc = "STEP # - Move stepper # steps. Negative is backward."

def stum(umArg=0.0):
    global _G_position, _BACKLASH
    microns = float(umArg)
    nSteps = round(microns / _UM_PER_STEP)
    if nSteps <= 0:
        _step(nSteps - _BACKLASH)
        _step(_BACKLASH)
    else:
        _step(nSteps)
    _G_position += nSteps   
stum_doc = "STUM # - Move # microns rounded to nearest step. Negative is backward."

def gain(arg="?"):
    global _G_gains, _G_gain, _G_gainDict
    arg = arg.lstrip().rstrip()
    print(">", arg, "<")
    if "?" in arg:
        print(_gain())
    else:
        try:
            iGain = _G_gainDict[arg]
            _setGain(iGain)
        except KeyError:
            print("Illegal gain")
            print(gain_doc)
gain_doc = f"GAIN [#?] - Set or return gain. Set must be from {_G_gains}."

def intt(arg="?"):
    global _G_intTs, _G_intT, _G_intTDict
    arg = arg.lstrip().rstrip()
    print(">", arg, "<")
    if "?" in arg:
        print(_intT())
    else:
        try:
            iArg = _G_intTDict[arg]
            _setIntT(iArg)
        except KeyError:
            print("Illegal integration time")
            print(intt_doc)
intt_doc = f"INTT [#?] - Set or return integration time. Set must be from {_G_intTs}."

def pos():
    global _G_position
    print(f"{_G_position}, {_UM_PER_STEP * _G_position}")
pos_doc = "POS - Prints current position in step and microns."

def quit():
    raise TypeError("Quitting SCPI program")
quit_doc = "QUIT - Exit to the REPL."

## Don't edit below |
##                  V
main_doc = []
_nameList = []

def _init():
    global main_doc
    # print("In init")
    gl = globals()
    keys = list(gl.keys())
    keys.sort()
    fcnList = []
    for k in keys:
        if k[0] != "_" and 'main' not in k:
            if "_doc" in k and 'main' not in k:
                main_doc.append(gl[k])
                _nameList.append(k[:k.find('_')])
            else:
                fcnList.append(gl[k])
    return (_nameList, fcnList)

# EOF
