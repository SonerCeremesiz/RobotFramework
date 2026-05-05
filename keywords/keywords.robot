*** Settings ***

Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s

Resource    ././resources.robot 

*** Variables ***
# add cloudflare credentials 
#${url}   https://www.testconsulting.de/
#${cookie_selector}    css=p:nth-child(3) button.api--function-all.btn.btn-primary.btn-sm
${url}   https://www.testconsulting-academy.de
${cookie_selector}    css=p:nth-child(3) button.api--function-all.btn.btn-primary.btn-sm
${selector_entdecke_schulungen}   css=div.home-hero [href="#schulungen"]
${selector_firmenschulung}     css=#schulungen > div > div:nth-child(1) > a

#############################################################
*** Keywords ***
#############################################################
Open Homepage

    New Browser    chromium      headless=False   
    ${video_path}   Set Video Path  
    New Context    recordVideo={'dir': '${video_path}'}    viewport={'width': 1440, 'height': 900}
    New Page    ${url}
    Show Keyword Banner    True    top: 5px; bottom: auto; left: 5px; background-color: #00909077; font-size: 12px; color: black;
    Sleep    5s
    Log To Console      Page is open 

#############################################################
Open Company Training 
    
    Click   ${selector_entdecke_schulungen}   #schulungen entdecken 
    Wait Until Location Contains        schulungen
    Click   ${selector_firmenschulung}    #open firmen-schulungs seite 
    Wait Until Location Contains   schulungsarten

############################################################
Book a consulting appointement 
    
    Click       css=div:nth-child(2) > div.tca-card-body > div.tca-actions > a 
    Wait Until Location Contains     /kontakt
    Accept Cookie Policy  
    Scroll To Bottom
    Type Text    css=input[id="f-279-name"]    Test    delay=200ms
    Type Text    css=input[id="f-279-email"]    test_email@test.de     delay=200ms
    Type Text    css=input[id="f-279-phone"]    01758542369     delay=200ms
    Type Text    css=input[id="f-279-subject"]           Company event  delay=200ms
    Type Text    css= [id="f-279-message"]     test msg      delay=200ms

    Click    css=span.checkmark
    Click    css=button[id="f-279-submit"]
 
#############################################################
Verify Booking Success  
    
    Wait Until Element Is Visible   css=div.alert.alert-success    5s

#############################################################
Accept Cookie Policy 
    ${cookie_law}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${cookie_selector}    5s
    IF      ${cookie_law}
        Click    ${cookie_selector} 
    END 
##############################################################
Set Video Path 

    ${date}=  Get Current Date   result_format=%d-%m-%Y
    ${time}=  Get Current Date   result_format=%H%M%S
    ${formatted_time}=  Evaluate  "${time}"[:2] + "h" + "${time}"[2:4] + "m" + "${time}"[4:] + "s"
    ${video_file_name}=    Set Variable     ${TEST_NAME}_${date}_${formatted_time}.webm
    ${video_path}=    Set Variable    ${OUTPUT_DIR}${/}video${/}${video_file_name}
    ${video_path}=    Make Path Windows Compatible    ${video_path}
   
    [Return]    ${video_path}
################################################################
Teardown Test 
  
    Close Browser   