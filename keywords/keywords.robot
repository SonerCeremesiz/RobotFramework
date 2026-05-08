*** Settings ***

Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s
Library    custom_library.py
Resource    ././resources.robot 

*** Variables ***
${url}   https://www.testconsulting-academy.de

#############################################################
# SETUP AND TEARDOWN
#############################################################
*** Keywords ***

Setup Test Environment
    New Browser    chromium      headless=False   
    ${video_path}   Set Video Path  
    New Context    recordVideo={'dir': '${video_path}'}    viewport={'width': 1440, 'height': 900}
    New Page    ${url}
    Show Keyword Banner    True    top: 5px; bottom: auto; left: 5px; background-color: #00909077; font-size: 12px; color: black;
    Sleep    5s
    Log To Console      Page is open
    Accept Cookie Policy
############################################################
Teardown Test Environment
    Close Browser
#############################################################
Set Video Path
    ${date}=  Get Current Date   result_format=%d-%m-%Y
    ${time}=  Get Current Date   result_format=%H%M%S
    ${formatted_time}=  Evaluate  "${time}"[:2] + "h" + "${time}"[2:4] + "m" + "${time}"[4:] + "s"
    ${video_file_name}=    Set Variable     ${TEST_NAME}_${date}_${formatted_time}.webm
    ${video_path}=    Set Variable    ${OUTPUT_DIR}${/}video${/}${video_file_name}
    ${video_path}=    Make Path Windows Compatible    ${video_path}
    [Return]    ${video_path}
##############################################################
Accept Cookie Policy
    ${cookie_law}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${page.cookie_button}    5s
    IF      ${cookie_law}
        Click    ${page.cookie_button} 
    END

#############################################################
# NAVIGATION KEYWORDS
#############################################################

Navigate To Company Training
    Click   ${page.discover_trainings}   #schulungen entdecken 
    Wait Until Location Contains        schulungen
    Click   ${page.company_training}    #open firmen-schulungs seite 
    Wait Until Location Contains   schulungsarten
################################################################
Navigate To All Trainings
    Click    ${header.all_trainings_button}        #header button 
    Wait Until Location Contains    /Alle-Schulungen#schulungen
##############################################################
Open Training Details Page

    Click         ${page.first_training}
    Wait Until Location Contains    /Alle-Schulungen/6
    Wait Until Element Is Visible   ${page.check_appointement}    5s     #check appointements 
    FOR   ${index}    IN RANGE    1   3  
        ${training_title}=    Build Selector    ${page.training_title}    ${index}
        Wait Until Element Is Visible    ${training_title}    5s
    END

#############################################################
# FORM OPERATIONS
#############################################################
Select Consulting Appointment

    Click   ${page.consulting_appointment}
    Wait Until Location Contains     /kontakt
#################################################################
Fill Contact Form

    Scroll To Bottom
    Type Text    ${form.name_field}    Test    delay=200ms
    Type Text    ${form.email_field}    test_email@test.de     delay=200ms
    Type Text    ${form.phone_field}    01758542369     delay=200ms
    Type Text    ${form.subject_field}           Company event  delay=200ms
    Type Text    ${form.message_field}     test msg      delay=200ms
    Click    ${form.privacy_checkbox}
    Click    ${form.submit_button}
##################################################################
Verify Contact Form Validation Errors
    Scroll To Bottom
    Click    ${form.submit_button}   #submit button 
    Wait Until Element Is Visible    ${form.error_alert}   5s           #error alert message      
    Wait Until Element Is Visible    ${form.name_error}    5s            #name error msg        
    Wait Until Element Is Visible    ${form.subject_error}        5s   #subject error msg 
    Wait Until Element Is Visible    ${form.message_error}        5s        #msg field error
#################################################################        
Verify Booking Confirmation Message
    Wait Until Element Is Visible   ${form.success_message}    5s    #success msg

#############################################################
# SEARCH OPERATIONS
#############################################################

Search Training By Keyword
    [Arguments]    ${training}

    Type Text    ${footer.search_field}         ${training}     #footer search field
    Keyboard Key    press    Enter
    Wait Until Location Contains   ${training}
#############################################################
Search Using Header Search Field
    [Arguments]    ${training}

    Type Text    ${header.search_field}   ${training}    
    Keyboard Key    press    Enter
#############################################################
Verify Search Results
    [Arguments]    ${training}

    Wait Until Location Contains   ${training}