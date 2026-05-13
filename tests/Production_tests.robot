*** Settings ***


Library    Browser    strict=False    
Resource    ../keywords/resources.robot
# set to false to change to testconsulting production page, otherwise it will run on academy page 
Test Setup    Setup Test Environment     False
Test Teardown    Teardown Test Environment 


#############################################################
*** Test Cases ***
#############################################################
Validate Contact form RegEx 
    [Tags]    TestConsulting Production Test

    Navigate to Conatct Form TC
    Verify Contact Form Validation Errors TC    

##############################################################
Book a Training
    [Tags]    TestConsulting Production Test

    Navigate to Conatct Form TC
    Fill Contact Form TC  
    Verify Booking Confirmation Message TC
  
###############################################################
Check Header Navigation
    [Tags]    TestConsulting Production Test

    Verify Header Navigation TC  

################################################################