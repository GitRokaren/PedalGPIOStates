import RPi.GPIO as GPIO

class RPiGPIOLib(object):
    
    ROBOT_LIBRARY_VARSION = 1.0
    
    def __init__(self):
        pass
    
    def declareGPIOMode(self, Mode):
        CapsMode = Mode.upper()
        if(CapsMode == "BCM"):
            GPIO.setmode(GPIO.BCM)
        elif(CapsMode == "BOARD"):
            GPIO.setmode(GPIO.BOARD)
        else:
            print("Invalid declaration of GPIO mode")
    
    def declarePin(self, Nr, Mode):
        CapsMode = Mode.upper()
        if(CapsMode == "OUT"):
            GPIO.setup(Nr, GPIO.OUT)
        elif(CapsMode == "IN"):
            GPIO.setup(Nr, GPIO.IN)
        else:
            print("Invalid declaration of out/in mode")
            
    def configOutPin(self, Nr, Value):
        if(Value == 0 or Value == 1):
            GPIO.output(Nr, Value)
        else:
            print("Invalid value, choose 0 or 1")
            
    def readInPin(self, Nr):
        return GPIO.input(Nr)
    
    def resetPins(self):
        GPIO.cleanup()
            
            