class StateCheck(object):
#This class represents a small library containing one function 
#which returns the current state by reading the value of the pins.
    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self):
        pass

    def StateChecker(self, Pin1, Pin2):
        if(Pin1==0):
            if(Pin2==0):
                return 3
            else:
                return 2
        else:
            if(Pin2==0):
                return 1
            else:
                return 0
        
