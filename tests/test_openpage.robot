*** Settings ***


Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s

Resource    ../keywords/resources.robot



#############################################################
*** Test Cases ***
Book a Training

    Open Homepage
    Open Company Training 
    Book a consulting appointement 
    Verify Booking Success
    Teardown Test 

#############################################################
