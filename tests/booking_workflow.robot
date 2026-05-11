*** Settings ***


Library    Browser    strict=False    
Resource    ../keywords/resources.robot

Test Setup    Setup Test Environment
Test Teardown    Teardown Test Environment 


#############################################################
*** Test Cases ***
Book a Training
    
    Select Consulting Request
    Fill Conttact Form With Valid Data
    
############################################################
Verify Different Types of Training 
    #TODO: Add more training types to the test case
    Navigate To All Trainings
    Search Training By Keyword    Atlassian 
    Search Training By Keyword    KI 

#############################################################
#Validate Contact form RegEx 

    #Navigate To Company Training
    #Select Consulting Appointment TC 
    #Verify Contact Form Validation Errors TC      
 
###############################################################
Test Header Search 
    
    Search Using Header Search Field    KI
    Verify Search Results    KI 
    Open Training Details Page  
    Verify Training Details

###############################################################