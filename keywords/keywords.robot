*** Settings ***

Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s
Library    ../custom_library.py
Resource    ././resources.robot 

*** Variables ***
${url}   https://www.testconsulting-academy.de
${url_production}   https://www.testconsulting.de/

#############################################################
# SETUP AND TEARDOWN
#############################################################
*** Keywords ***

Setup Test Environment
    [Arguments]    ${academy}==True

    New Browser    chromium      headless=False   
    ${video_path}   Set Video Path  
    New Context    recordVideo={'dir': '${video_path}'}    viewport={'width': 1440, 'height': 900}
    IF  ${academy}
        New Page    ${url}
    ELSE
        New Page    ${url_production}
    END
    Show Keyword Banner    True    top: 5px; bottom: auto; left: 5px; background-color: #00909077; font-size: 12px; color: black;
    Sleep    5s
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

##############################################################
Verify Training Details
  
    FOR   ${index}    IN RANGE    1   4  
        #verify the presence of training titles for the 3 slots 
        @{selectors}=    Get Dictionary Values    ${page.details}
        FOR    ${selector}    IN    @{selectors}
            ${selector_with_index}=    Build Selector    ${selector}    ${index}
            Wait Until Element Is Visible   ${selector_with_index}    5s
        END
    END

#############################################################
# FORM OPERATIONS
#############################################################
Select Consulting Request 
    
    Hover    css=a[id="schulung-button"]
    Click With Options    css=#schulung-menu li:nth-child(8) a       force=True
    Wait Until Location Contains     /schulungen/anfrage
   
#############################################################
Fill Conttact Form With Valid Data
    Scroll To Bottom
    Type Text    ${form.email_field}     test_email@test.de      delay=200ms
    Type Text    ${form.subject_field}    Test    delay=200ms
    Type Text    ${form.message_field}    Test    delay=200ms
    Click        ${form.submit_button}
    #catptcha handling is not possible, so we will just verify that the form submission was attempted by checking for the presence of input fields  
    Wait Until Element Is Visible    ${form.email_field}      5s
##############################################################
Verify Contact Form Validation Errors
    Scroll To Bottom
    Type Text    ${form.email_field}     . 
    Click    ${form.submit_button}   
    Wait Until Element Is Visible    ${form.error.email}   5s               

#############################################################
Select Training From Side Menu
    @{selectors}=    Get Dictionary Values    ${page.side_menu}
    @{locations}=    Get Dictionary Values    ${locations.navigation_side_menu}
    ${length}=    Get Length    ${selectors}
    # to ensure that the correct page is loaded after clicking on each training type in the side menu, we will loop through the list of selectors and their corresponding expected URL fragments, click on each selector, and verify that the URL contains the expected fragment. This approach allows us to efficiently test multiple navigation paths without duplicating code for each training type.
    FOR    ${index}    IN RANGE    0    ${length}
        ${selector}=    Get From List    ${selectors}    ${index}
        ${location}=    Get From List    ${locations}    ${index}
        Click    ${selector}
        Sleep    3s
        Wait Until Location Contains    ${location}
    END
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
###############################################################
Navigate To Home Page

    Click    ${header.home_button}     #home button 
    Wait Until Location Contains   testconsulting-academy.de/

###############################################################
Navigate to FAQ Page
    Click    ${header.FAQ}     #FAQ page button
    Wait Until Location Contains   /faq

###############################################################
Navigate To About Us Page 
  
    Click    ${header.about_us}    #about us page button
    Wait Until Location Contains   /about

##############################################################
Navigate To Testconsulting Page
    
    Click With Options       ${header.testconsulting}     force=True    #testconsulting page button
    ${url}=    Get Url
    Should Contain   ${url}   .testconsulting.de/
###############################################################
#keywords for Testconsulting production contact form
###############################################################
Navigate to Conatct Form TC

    Click   ${tc_header.contact}
    Wait Until Location Contains     /kontakt

#################################################################
Fill Contact Form TC 

    Scroll To Bottom
    Accept Cookie Policy
    Type Text    ${tc.form.name_field}    Test    delay=200ms
    Type Text    ${tc.form.email_field}    test_email@test.de     delay=200ms
    Type Text    ${tc.form.phone_field}    01758542369     delay=200ms
    Type Text    ${tc.form.subject_field}           Company event  delay=200ms
    Type Text    ${tc.form.message_field}     test msg      delay=200ms
    Click    ${tc.form.privacy_checkbox}
    Click    ${tc.form.submit_button}

##################################################################
Verify Contact Form Validation Errors TC

    Scroll To Bottom
    Accept Cookie Policy
    Click    ${tc.form.submit_button}   #submit button 
    Wait Until Element Is Visible    ${tc.form.error_alert}   5s               
    Wait Until Element Is Visible    ${tc.form.name_error}    5s                   
    Wait Until Element Is Visible    ${tc.form.subject_error}        5s  
    Wait Until Element Is Visible    ${tc.form.message_error}        5s   

#################################################################        
Verify Booking Confirmation Message TC 
   
    Wait Until Element Is Visible   ${tc.form.success_message}    5s    #success msg

#############################################################
Verify Header Navigation TC 

    @{selectors}=    Get Dictionary Values    ${tc_header}
    @{locations}=    Get Dictionary Values    ${locations.tc}
    ${length}=    Get Length    ${selectors}
    FOR    ${index}    IN RANGE    0    ${length}
        ${selector}=    Get From List    ${selectors}    ${index}
        ${location}=    Get From List    ${locations}    ${index}
        Click With Options   ${selector}     force=True    clickCount=2
        Sleep   3s
        Wait Until Location Contains   ${location}
    END
#############################################################
Navigate to Career Page TC

    Click With Options    ${tc_header.career}    clickCount=2     #career page button
    Sleep  3s
    Wait Until Location Contains   /karriere    

##################################################################
Verify Career Page Elements TC    
   
    @{selectors}=    Get Dictionary Values    ${tc.career_page}
    Wait Until All Elements Of List Are Visible       @{selectors}   

#################################################################