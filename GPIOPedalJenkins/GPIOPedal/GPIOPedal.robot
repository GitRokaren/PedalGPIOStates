*** Settings ***
Documentation    Version 1.3 of the Robotframework GPIO on RPi 
Library    RPi_GPIOZERO
Library    Collections    

*** Variables ***
${On}=    ${0} 
${Off}=    ${1}    #The numbers are reversed due to the GPIOzero logic, where input value is reversed to the voltage level


*** Test Cases ***
RunPedal
    ${Pin18}=    Set Out Pin    ${18}    #Setting GPIO18 to an out pin
    ${Pin17}=    Set Out Pin    ${17}    #Setting GPIO17 to an out pin
    ${Pin22}=    Set Out Pin    ${22}    #Setting GPIO22 to an out pin
    StopTransfer    ${Pin18}   #Safety measure, "clean" pins
    @{OutPins}=    Create List    ${Pin18}    ${Pin17}    ${Pin22}
    ${Pin23}=    Set In Pin    ${23}    #Setting GPIO23 to an in pin
    ${Pin24}=    Set In Pin    ${24}    #Setting GPIO24 to an in pin
    @{InPins}=    Create List    ${Pin23}    ${Pin24}
    #Sleep    5    
    StartTransfer    ${Pin18}
    RequestStates    ${Pin17}    ${Pin22}    ${3}
    ${result}=    CheckStates    ${Pin23}    ${Pin24}    ${3}
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail  
    #StopTransfer    ${Pin18}
    #Sleep    5  
    #StartTransfer    ${Pin18}      
    RequestStates    ${Pin17}    ${Pin22}    ${2}
    ${result}=    CheckStates    ${Pin23}    ${Pin24}    ${2}
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    #StopTransfer    ${Pin18}
    #Sleep    5  
    #StartTransfer    ${Pin18}   
    RequestStates    ${Pin17}    ${Pin22}    ${1}
    ${result}=    CheckStates    ${Pin23}    ${Pin24}    ${1}
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    #StopTransfer    ${Pin18}
    #Sleep    5     
    #StartTransfer    ${Pin18}
    RequestStates    ${Pin17}    ${Pin22}    ${0}
    ${result}=    CheckStates    ${Pin23}    ${Pin24}    ${0}
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    StopTransfer    ${Pin18}
    #Sleep    10     
    CloseOutPins    @{OutPins}
    CloseInPins    @{InPins}

*** Keywords ***
#18=Out, Start the test Pin
#23,24=in, Which state
#17,22=out, Requested State
StartTransfer
    [Arguments]    ${PinReady}
    Turn On Pin    ${PinReady}    #this is the pin that will tell the other Pi to get ready for transfer
    
StopTransfer
    [Arguments]    ${PinReady}
    Turn Off Pin    ${PinReady}
  #This function is used to "reset" the Pins so that they're ready to send the next
                                #request and fetch the state
  
RequestStates
    [Arguments]    ${PinOut1}    ${PinOut2}    ${StateNr} 
    Run Keyword If    ${StateNr}==${0}    RequestState0    ${PinOut1}    ${PinOut2}   
    Run Keyword If    ${StateNr}==${1}    RequestState1    ${PinOut1}    ${PinOut2} 
    Run Keyword If    ${StateNr}==${2}    RequestState2    ${PinOut1}    ${PinOut2} 
    Run Keyword If    ${StateNr}==${3}    RequestState3    ${PinOut1}    ${PinOut2}  
  
RequestState0
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn Off Pin    ${PinOut1}
    Turn Off Pin    ${PinOut2} 
    #Sleep    0.1    
    
RequestState1
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn Off Pin    ${PinOut1}
    Turn On Pin    ${PinOut2}
    #Sleep    0.1    
    
RequestState2
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn On Pin    ${PinOut1}
    Turn Off Pin    ${PinOut2}
    #Sleep    0.1    
    
RequestState3
    [Arguments]    ${PinOut1}    ${PinOut2}
    Turn On Pin    ${PinOut1}
    Turn On Pin    ${PinOut2}
    #Sleep    0.1    
    
CheckStates
    [Arguments]    ${PinIn1}    ${PinIn2}    ${StateNr}
    Run Keyword If    ${StateNr}==${0}    CheckState0    ${PinIn1}    ${PinIn2}   
    Run Keyword If    ${StateNr}==${1}    CheckState1    ${PinIn1}    ${PinIn2} 
    Run Keyword If    ${StateNr}==${2}    CheckState2    ${PinIn1}    ${PinIn2} 
    Run Keyword If    ${StateNr}==${3}    CheckState3    ${PinIn1}    ${PinIn2}  
    
CheckState0
    [Arguments]    ${PinIn1}    ${PinIn2}
    #Sleep    0.1    
    ${Check1}=    Read In Pin    ${PinIn1}
    ${Check2}=    Read In Pin    ${PinIn2}
    Log    Checks: ${Check1} & ${Check2} Vs: ${Off}    
    ${result}=    Evaluate    ${Check1}==${Off} & ${Check2}==${Off}  #State1 = 00 (or 11 due to reverse logic)
    Log    ${result} 
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect 
    [Return]    ${result}   
    
CheckState1
    [Arguments]    ${PinIn1}    ${PinIn2}
    #Sleep    0.1    
    ${Check1}=    Read In Pin    ${PinIn1}
    ${Check2}=    Read In Pin    ${PinIn2}
    Log    ${Check1} & ${Check2} Vs: ${Off} & ${On}
    ${result}=    Evaluate    ${Check1}==${Off} & ${Check2}==${On}  #State2 = 01 (or 10 due to reverse logic)
    Log    ${result}    
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect 
    [Return]    ${result}   
    
CheckState2
    [Arguments]    ${PinIn1}    ${PinIn2}
    #Sleep    0.1    
    ${Check1}=    Read In Pin    ${PinIn1}
    ${Check2}=    Read In Pin    ${PinIn2}
    Log    ${Check1} & ${Check2} Vs: ${On} & ${Off} 
    ${result}=    Evaluate    ${Check1}==${On} & ${Check2}==${Off}  #State3 = 10 (or 01 due to reverse logic)
    Log    ${result} 
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect  
    [Return]    ${result}   
    
CheckState3
    [Arguments]    ${PinIn1}    ${PinIn2}
    #Sleep    0.1    
    ${Check1}=    Read In Pin    ${PinIn1}
    ${Check2}=    Read In Pin    ${PinIn2}
    Log    ${Check1} & ${Check2} Vs: ${On} 
    ${result}=    Evaluate    ${Check1}==${On} & ${Check2}==${On}  #State4 = 11 (or 00 due to reverse logic)
    Log    ${result} 
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect 
    [Return]    ${result}   
    
StateIncorrect
    Log    The test failed due to the incoming state was not as expected    

StateCorrect
    Log    The state was as expected    
    
CloseOutPins
    [Arguments]    @{OutPins}
    FOR    ${OutPin}    IN    @{OutPins}
        Shutdown Out Pin    ${OutPin}
    END

CloseInPins
    [Arguments]    @{InPins}
    FOR    ${InPin}    IN    @{InPins}
        Shutdown In Pin    ${InPin}
    END