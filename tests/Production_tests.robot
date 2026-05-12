*** Settings ***


Library    Browser    strict=False    
Resource    ../keywords/resources.robot

Test Setup    Setup Test Environment
Test Teardown    Teardown Test Environment 


#############################################################
*** Test Cases ***
#############################################################
#Validate Contact form RegEx 
   #[Tags]    TestConsulting Production Test

    #Navigate To Company Training
    #Select Consulting Appointment TC 
    #Verify Contact Form Validation Errors TC      
##############################################################
#Book a Training
    #[Tags]    TestConsulting Production Test
    #Navigate To Company Training
    #Select Consulting Appointment TC 
    #Fill Contact Form TC 
    #Verify Booking Confirmation Message TC
  
###############################################################