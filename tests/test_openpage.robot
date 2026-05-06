*** Settings ***


Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s

Resource    ../keywords/resources.robot
Test Setup    Open Homepage
Test Teardown     Teardown Test 


#############################################################
*** Test Cases ***
Book a Training


    Open Company Training 
    Select a consulting appointement 
    Fill Contact Form 
    Verify Booking Success
  
############################################################
Verify Different Types of Training 
 
    Select All Training 
    Search for a Training      Atlassian 
    Search for a Training      KI 

#############################################################
Validate Contact Form 


    Open Company Training 
    Select a consulting appointement 
    Verify Contact Form  
 
###############################################################
    