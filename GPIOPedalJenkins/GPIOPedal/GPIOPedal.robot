*** Settings ***
Documentation    Version 1.1 of the Robotframework GPIO on RPi 
Library    RPi_GPIOZERO
Library    Collections    

*** Variables ***
${On}=    ${0} 
${Off}=    ${1}    #The numbers are reversed due to the GPIOzero logic, where input value is reversed to the voltage level
${Pin18}
${Pin17}
${Pin22}
${Pin23}
${Pin24}
@{OutPins}
@{InPins}

*** Test Cases ***
RunPedal
    StartOutConf
    StartInConf
    Sleep    1    
    RequestState1
    ${result}=    CheckState1
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    Sleep    2        
    RequestState2
    ${result}=    CheckState1
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    Sleep    2     
    RequestState3
    ${result}=    CheckState1
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    Sleep    2     
    RequestState4
    ${result}=    CheckState1
    Log    ${result}    
    Run Keyword If    ${result}==False    Fail    
    Sleep    2     
    CloseAllPins

*** Keywords ***
#18=Out, Start the test Pin
#23,24=in, Which state
#17,22=out, Requested State
StartOutConf
    ${Pin18}=    Set Out Pin    ${18}    #Setting GPIO18 to an out pin
    ${Pin17}=    Set Out Pin    ${17}    #Setting GPIO17 to an out pin
    ${Pin22}=    Set Out Pin    ${22}    #Setting GPIO22 to an out pin
    Turn Off Pin    ${Pin18}
    Turn Off Pin    ${Pin17}
    Turn Off Pin    ${Pin22}    #Turn off all the ouput pins so that they're "clean"
    @{OutPins}=    Create List    ${Pin18}    ${Pin17}    ${Pin22}
    #[Return]    @{OutPins}
    
StartInConf
    ${Pin23}=    Set In Pin    ${23}    #Setting GPIO23 to an in pin
    ${Pin24}=    Set In Pin    ${24}    #Setting GPIO24 to an in pin
    @{InPins}=    Create List    ${Pin23}    ${Pin24}
    #[Return]    @{InPins}

StartTransfer
    Turn On Pin    ${Pin18}    #this is the pin that will tell the other Pi to get ready for transfer
    
StopTransfer
    Turn Off Pin    ${Pin18}
    Turn Off Pin    ${Pin17}
    Turn Off Pin    ${Pin22}    #This function is used to "reset" the Pins so that they're ready to send the next
                                #request and fetch the state
    
RequestState1
    Turn Off Pin    ${Pin17}
    Turn Off Pin    ${Pin22} 
    
RequestState2
    Turn Off Pin    ${Pin17}
    Turn On Pin    ${Pin22}
    
RequestState3
    Turn On Pin    ${Pin17}
    Turn Off Pin    ${Pin22}
    
RequestState4
    Turn On Pin    ${Pin17}
    Turn On Pin    ${Pin22}
    
CheckState1
    StartTransfer
    ${Check1}=    Read In Pin    ${Pin23}
    ${Check2}=    Read In Pin    ${Pin24}
    Log    Checks: ${Check1} & ${Check2} Vs: ${Off}    
    ${result}=    Evaluate    ${Check1}==${Off} & ${Check2}==${Off}  #State1 = 00 (or 11 due to reverse logic)
    Log    ${result} 
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect 
    StopTransfer  
    [Return]    ${result}   
    
CheckState2
    StartTransfer
    ${Check1}=    Read In Pin    ${Pin23}
    ${Check2}=    Read In Pin    ${Pin24}
    Log    ${Check1} & ${Check2} Vs: ${Off} & ${On}
    ${result}=    Evaluate    ${Check1}==${Off} & ${Check2}==${On}  #State2 = 01 (or 10 due to reverse logic)
    Log    ${result}    
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect 
    StopTransfer
    [Return]    ${result}   
    
CheckState3
    StartTransfer
    ${Check1}=    Read In Pin    ${Pin23}
    ${Check2}=    Read In Pin    ${Pin24}
    Log    ${Check1} & ${Check2} Vs: ${On} & ${Off} 
    ${result}=    Evaluate    ${Check1}==${On} & ${Check2}==${Off}  #State3 = 10 (or 01 due to reverse logic)
    Log    ${result} 
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect  
    StopTransfer   
    [Return]    ${result}   
    
CheckState4
    StartTransfer
    ${Check1}=    Read In Pin    ${Pin23}
    ${Check2}=    Read In Pin    ${Pin24}
    Log    ${Check1} & ${Check2} Vs: ${On} 
    ${result}=    Evaluate    ${Check1}==${On} & ${Check2}==${On}  #State4 = 11 (or 00 due to reverse logic)
    Log    ${result} 
    Run Keyword If    ${result}==False    StateIncorrect   
    Run Keyword If    ${result}    StateCorrect 
    StopTransfer  
    [Return]    ${result}   
    
StateIncorrect
    Log    The test failed due to the incoming state was not as expected    

StateCorrect
    Log    The state was as expected    
    
CloseAllPins
    FOR    ${OutPin}    IN    @{OutPins}
        Shutdown Out Pin    ${OutPin}
    END
    FOR    ${InPin}    IN    @{InPins}
        Shutdown In Pin    ${InPin}
    END