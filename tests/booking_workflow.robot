*** Settings ***


Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s

Resource    ../keywords/resources.robot
Test Setup    Setup Test Environment
Test Teardown    Teardown Test Environment 


#############################################################
*** Test Cases ***
Book a Training

    Navigate To Company Training
    Select Consulting Appointment
    Fill Contact Form
    Verify Booking Confirmation Message
  
############################################################
Verify Different Types of Training 
 
    Navigate To All Trainings
    Search Training By Keyword    Atlassian 
    Search Training By Keyword    KI 

#############################################################
Validate Contact form 

    Navigate To Company Training
    Select Consulting Appointment
    Verify Contact Form Validation Errors  
 
###############################################################
Test Header Search 
    
    Search Using Header Search Field    KI
    Verify Search Results    KI 
    Open Training Details Page  

###############################################################