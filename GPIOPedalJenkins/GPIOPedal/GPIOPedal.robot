*** Settings ***
Documentation    Version 2.1  of the Robotframework GPIO on RPi 
#Library    RPi_GPIOZERO
Library    RPiGPIOLib
Library    StateCheck
Library    Collections    
Test Setup    Start Application
Test Teardown    Stop Application


*** Variables ***
${On}=    ${0} 
${Off}=    ${1}    #The numbers are reversed due to the GPIOzero logic, where input value is reversed to the voltage level


*** Test Cases ***
Main
    ${Pin18}=    Set Out Pin    ${18}    #Setting GPIO18 to an out pin
    ${Pin17}=    Set Out Pin    ${17}    #Setting GPIO17 to an out pin
    ${Pin22}=    Set Out Pin    ${22}    #Setting GPIO22 to an out pin
    StopTransfer    ${Pin18}   #Safety measure, "clean" pin
    @{OutPins}=    Create List    ${Pin18}    ${Pin17}    ${Pin22}

    ${Pin23}=    Set In Pin    ${23}    #Setting GPIO23 to an in pin
    ${Pin24}=    Set In Pin    ${24}    #Setting GPIO24 to an in pin
    @{InPins}=    Create List    ${Pin23}    ${Pin24}
    
    Sleep    1   
    
    RunPedal    ${Pin18}    ${Pin17}    ${Pin22}    ${Pin23}    ${Pin24}
    
    CloseOutPins    @{OutPins}
    CloseInPins    @{InPins}


*** Keywords ***
#18=Out, Start the test Pin
#23,24=in, Which state
#17,22=out, Requested State

Start Application
    Log    Starting the pedal application, hardcoded state changing  
    Sleep    1      
    
Stop Application
    Log    Application run over, view log for details  
    Sleep    1    
  
RunPedal
    [Arguments]    ${ReadyPin}    ${PinOut1}    ${PinOut2}    ${PinIn1}    ${PinIn2}
    StartTransfer    ${ReadyPin}
    SetStates    ${PinOut1}    ${PinOut2}    ${3}
    ${result}=    CheckStates    ${PinIn1}    ${PinIn2}    ${3}
    Log    ${result}    
    Run Keyword If    ${result}    HW Failure    
    Run Keyword If    ${result}==False    Fail    
    
    SetStates    ${PinOut1}    ${PinOut2}    ${2}
    ${result}=    CheckStates    ${PinIn1}    ${PinIn2}    ${2}
    Log    ${result}    
    Run Keyword If    ${result}    Pedal Down 
    Run Keyword If    ${result}==False    Fail    
   
    SetStates    ${PinOut1}    ${PinOut2}    ${1}
    ${result}=    CheckStates    ${PinIn1}    ${PinIn2}    ${1}
    Log    ${result}    
    Run Keyword If    ${result}    Pedal Up 
    Run Keyword If    ${result}==False    Fail 
      
    SetStates    ${PinOut1}    ${PinOut2}    ${0}
    ${result}=    CheckStates    ${PinIn1}    ${PinIn2}    ${0}
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail  
    Run Keyword If    ${result}    Disconnect   
    StopTransfer    ${ReadyPin}

StartTransfer
    [Arguments]    ${PinReady}
    Turn On Pin    ${PinReady}    #this is the pin that will tell the other Pi to get ready for transfer
    
StopTransfer
    [Arguments]    ${PinReady}
    Turn Off Pin    ${PinReady}
  #This function is used to "reset" the Pins so that they're ready to send the next
                                #request and fetch the state
  
SetStates
    [Arguments]    ${PinOut1}    ${PinOut2}    ${StateNr} 
    Run Keyword If    ${StateNr}==${0}    SetState0    ${PinOut1}    ${PinOut2}   
    Run Keyword If    ${StateNr}==${1}    SetState1    ${PinOut1}    ${PinOut2} 
    Run Keyword If    ${StateNr}==${2}    SetState2    ${PinOut1}    ${PinOut2} 
    Run Keyword If    ${StateNr}==${3}    SetState3    ${PinOut1}    ${PinOut2}  
  #This function will tell the raspberry to switch to a state depending on the argument ${stateNr}
SetState0
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn Off Pin    ${PinOut1}
    Turn Off Pin    ${PinOut2} 
    Sleep    0.1    
    
SetState1
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn Off Pin    ${PinOut1}
    Turn On Pin    ${PinOut2}
    Sleep    0.1    
    
SetState2
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn On Pin    ${PinOut1}
    Turn Off Pin    ${PinOut2}
    Sleep    0.1    
    
SetState3
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn On Pin    ${PinOut1}
    Turn On Pin    ${PinOut2}
    Sleep    0.1    
    
CheckStates
    [Arguments]    ${PinIn1}    ${PinIn2}    ${StateNr}
    Sleep    0.1    
    ${Check1}=    Read In Pin    ${PinIn1}
    ${Check2}=    Read In Pin    ${PinIn2}
    ${RealState}=    State Checker    ${Check1}    ${Check2}
    ${Result}=    Evaluate    ${RealState}==${StateNr}    
    [Return]    ${Result}
    #This function is used to check if the set-state corresponds with the state that the ctrl panel says it's in 
    
HW Failure
    Log    The pedal is experiencing hardware failure   

Disconnect
    Log    The pedal is disconnected
    
Pedal Down
    Log    The pedal is down    
    
Pedal Up
    Log    The pedal is up        
    
CloseOutPins
    [Arguments]    @{OutPins}
    FOR    ${OutPin}    IN    @{OutPins}
        Shutdown Out Pin    ${OutPin}
    END
#This function is used to turn off the pins in use, to prevent damage of hardware
CloseInPins
    [Arguments]    @{InPins}
    FOR    ${InPin}    IN    @{InPins}
        Shutdown In Pin    ${InPin}
    END