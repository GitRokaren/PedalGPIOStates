import gpiozero
from gpiozero.output_devices import LED
from gpiozero.input_devices import Button

class RPi_GPIOZERO(object):
#This class represents a library for GPIO integration to Robotframework tasks.
#The integration is done thanks to the gpiozero library.
    ROBOT_LIBRARY_VERSION = 1.1

    def __init__(self):
        pass

    def SetOutPin(self, Nr):
        led = LED(Nr)
        return led
        #This function is used to declare an out pin with the desired number
        #the desired number corresponds to GPIO.BCM numbering => the number is XX in GPIOXX
        #Refer to this schematic for better understanding:
        # https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_4b_4p0_reduced.pdf
        #In gpiozero the output pins are declared as a LED
    
    def SetInPin(self, Nr):
        btn = Button(Nr)
        return btn
        #This function is used to declare an in pin with the desired number
        #the desired number corresponds to GPIO.BCM numbering
        #In gpiozero the input pins are declared as a Button
    
    def TurnOnPin(self, LED):
        print("Before")
        print(LED.is_active)
        if(LED.is_active==False):
            LED.on()
            print("After")
            print(LED.is_active)
        #This function is used to turn on an output pin, the pin which is supposed to turn on
        #is entered as a parameter
        
    def TurnOffPin(self, LED):
        print("Before")
        print(LED.is_active)
        if(LED.is_active):
            LED.off()
            print("After")
            print(LED.is_active)
        #This function is used to turn off an output pin, the pin which is supposed to turn off
        #is entered as a parameter
        
    def ReadInPin(self, Button):
        return int(Button.value)
        #This function is used to read the value of an input pin, the pin which is supposed to be read
        #is entered as a parameter
    
    def ShutdownOutPin(self, LED):
        LED.close()
        #This function is used to close the output pin in use, so that it doesn't 
        #affect the test when it is supposed to be done

        
    def ShutdownInPin(self, Button):
        Button.close()
        #This function is used to close the input pin in use, so that it doesn't 
        #affect the test when it is supposed to be done