*** Settings ***


Library    Browser    strict=False    
Resource    ../keywords/resources.robot

Test Setup    Setup Test Environment
Test Teardown    Teardown Test Environment 


#############################################################
*** Test Cases ***
Book a Training With Valid Data
    [Documentation]    This test case verifies that a user can successfully book a training by filling out the contact form with valid data (captcha must be deactivated).
    
    Select Consulting Request
    Fill Conttact Form With Valid Data

###########################################################
Validate Contact form RegEx 
    [Documentation]    This test case verifies that the contact form displays appropriate validation errors when invalid data is entered .subject field and message field do not have regex validation, only email field has, this must be fixed on the website.
    
    Select Consulting Request
    Verify Contact Form Validation Errors 

############################################################
Verify Different Types of Training 
    [Documentation]    This test case verifies that users can search(footer) for different types of training using the search functionality and that the search results are relevant to the search query.    
   
    Navigate To All Trainings
    Search Training By Keyword    Atlassian 
    Search Training By Keyword    KI 
    Search Training By Keyword    Testautomation
    Search Training By Keyword    Management
    Search Training By Keyword    Softwareentwicklung
 
###############################################################
Test Header Search 
    [Documentation]    This test case verifies that users can search for trainings using the header search field and that the search results are relevant to the search query, and verifies that users can navigate to the training details page from the search results and that the training details are displayed correctly.
   
    Search Using Header Search Field    KI
    Verify Search Results    KI 
    Open Training Details Page  
    Verify Training Details

###############################################################