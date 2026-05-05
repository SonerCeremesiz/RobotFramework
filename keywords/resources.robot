*** Settings ***
Library     OperatingSystem
Resource    ././resources_shared.robot

*** Keywords ***

##############################################################################################
# This is a wrapper to cover a keyword was available in the SeleniumLibrary with BrowserLibrary
Wait Until Location Contains    
    [Arguments]    ${text}    ${message}=${None}
    
    Get Url    *=     ${text}    ${message}

##############################################################################################

Wait Until Location Does Not Contain
    [Arguments]    ${text}
    
    Get Url    not contains     ${text}

##############################################################################################
# This is a wrapper to cover a keyword was available in the SeleniumLibrary with BrowserLibrary
Wait Until Element Is Visible
    [Arguments]    ${selector}    ${timeout}=${None}    ${message}=${None} 
    
    ${element_visible}=    Run Keyword And Return Status    Wait For Elements State    ${selector}    visible    timeout=${timeout}
    IF    not ${element_visible} 
        ${url}=    Get Url
        IF    $message==$None
            ${message}=    Set Variable    Selector '${selector}' not visible on '${url}' after ${timeout}
        END
        Fail    ${message}
    END

#############################################################################################

Wait Until Element Is Not Visible
    [Arguments]    ${selector}    ${timeout}=${None}    ${message}=${None} 
    
    ${element_invisible}=    Run Keyword And Return Status    Wait For Elements State    ${selector}    hidden    timeout=${timeout}
    IF    not ${element_invisible} 
        ${url}=    Get Url
        IF    ${message}==${None}
            ${message}=    Set Variable    Selector '${selector}' is visible on '${url}' after ${timeout}
        END
        Fail    ${message}
    END

##############################################################################################

# This is a wrapper to cover a keyword was available in the SeleniumLibrary with BrowserLibrary
Wait Until Element Is Enabled
    [Arguments]    ${selector}    ${timeout}=${None}    ${message}=${None} 
    
    ${element_enabled}=    Run Keyword And Return Status    Wait For Elements State    ${selector}    enabled    timeout=${timeout}
    IF    not ${element_enabled} 
        ${url}=    Get Url
        IF    ${message}==${None}
            ${message}=    Set Variable    Selector '${selector}' not enabled on '${url}' after ${timeout}
        END
        Fail    ${message}
    END

##############################################################################################

Element Should Contain Ignoring Spaces
    [Arguments]    ${selector}    ${text}
    
    ${text}=    Replace String    ${text}    ${SPACE}    ${EMPTY}
    ${selector_text}=    Get Text    ${selector}
    ${selector_text}=    Replace String    ${selector_text}    ${SPACE}    ${EMPTY}
    Should Contain         ${selector_text}     ${text} 
    
##############################################################################################

Element Should Contain    
    [Arguments]    ${selector}    ${text}

    ${text}=    Strip String    ${text}
    Get Text    ${selector}    *=    ${text}

##############################################################################################



Element Should Contain Case Insensitive
    [Arguments]    ${selector}    ${text}

    ${text}=    Strip String    ${text}
    ${text}=    Convert To Lower Case    ${text}
    ${element_text}=    Get Text    ${selector}
    ${element_text}=    Convert To Lower Case    ${element_text}
    Should Contain    ${element_text}    ${text}

##############################################################################################

Scroll To Top
    
    Evaluate JavaScript    body    window.scrollTo(0,0)
    Sleep    2 seconds

##############################################################################################

Scroll To Bottom
    
    Evaluate JavaScript    body    window.scrollTo(0,document.body.scrollHeight)
    Sleep    2 seconds
    
##############################################################################################

Clear Element Text By CTRL A DEL
    [Arguments]    ${selector}
    
    Click  ${selector}
    Press Keys    ${selector}    CTRL+a+DELETE    

##############################################################################################

Get Attribute From Locator
    [Arguments]  ${selector}  ${attribute}

    ${pre}	${post} =	Split String	${selector}	=	1
    IF    "${pre}" == "xpath"
        ${text}=  Evaluate Javascript  ${selector}    document.evaluate("${post}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.${attribute}
    ELSE IF    "${pre}" == "css"
        ${text}=  Evaluate Javascript   ${selector}    document.querySelector("${post}").${attribute}
    END
    RETURN  ${text}

##############################################################################################

Load Json
    [Arguments]    ${file_path}
## ÄNDERUNGEN SC
    ${file_path}=    Make Path Windows Compatible    ${file_path}
    ${json}=    Load Json From File    ${file_path}    encoding=UTF-8
    RETURN    ${json}

##############################################################################################

Make Path Windows Compatible
    [Arguments]    ${path}

    ${path}=    Replace String    ${path}    \\    \\\\
    RETURN    ${path}

##############################################################################################

Wait Until One Element Of List Is Visible
    [Arguments]    @{selectors}    ${timeout}=${None}
    [Documentation]    Determines, if one of the elements in the list of elements passed to the keyword is visible. It will return 
    ...    the list index of the first element it finds to be visible, even if other elements in the list are also visible. 
    ...    The timeout for each try to find an element visible is 10ms. If the list is passed, it will be processed again from the 
    ...    beginning. The amount of passes through the list, before the keyword fails, is given by the maximum total time the keyword 
    ...    is supposed to run. The maximum total time is given by the Browser library timeout.
    
    ${first_element_found}=    Set Variable    -1
    ${time_delta}=    Set Variable    10 milliseconds
    # The next two lines get the current value of the Browser library timeout. It can only be obtained, when also setting a new value.
    # Hence, the first line gets the value and sets it to 30s, and the second line sets it back to the original value.
    IF    ${timeout}==${None}
        ${timeout} =    Set Browser Timeout    30 seconds
        Set Browser Timeout    ${timeout}    
    END
    ${timeout_float}=    Convert Time    ${timeout}
    ${time_delta_float}=    Convert Time    ${time_delta}
    # Calculate max. number of passes through the selectors list
    ${repeats}=    Evaluate    ${timeout_float}/${time_delta_float}

    FOR    ${counter}    IN RANGE    1    ${repeats}    
        FOR    ${index}    IN RANGE    len(${selectors})
            ${is_visible}=    Run Keyword And Return Status    Wait For Elements State    ${selectors}[${index}]    visible    timeout=${time_delta}
            IF    ${is_visible}
                ${first_element_found}=    Set Variable    ${index}
                Exit For Loop
            END
        END
        Exit For Loop If    ${is_visible}
    END
    IF    "${first_element_found}" == "-1"
        Fail    Unable to find any visible element in list @{selectors}
    END
    RETURN    ${first_element_found}

##############################################################################################
Wait Until All Elements Of List Are Visible
    [Arguments]    @{selector_list} 

    FOR    ${selector}    IN    @{selector_list}
        Wait Until Element Is Visible    ${selector}
    END
##############################################################################################
Wait Until All Elements Of List Are Not Visible
    [Arguments]    @{selector_list} 

    FOR    ${selector}    IN    @{selector_list}
        Wait Until Element Is Not Visible    ${selector}
    END
##############################################################################################
Wait Until specific Elements Of List Are Visible
    [Arguments]    @{selector_list} 

    FOR    ${selector}    IN    @{selector_list}[2:]
        Wait Until Element Is Visible    ${selector}
    END
##############################################################################################

Get Random Item From List
    [Arguments]    @{list}
    ${random_int}=    Evaluate    random.randint(0, len(${list})-1)	
    RETURN    ${list}[${random_int}]

##############################################################################################

Wait Until Location Contains One Of List
    [Arguments]    @{locations}    ${timeout}=${None}
    [Documentation]    Determines, if the url contains one of the list items. 
    ...    The timeout for each try to find an element visible is 10ms. If the list is passed, it will be processed again from the 
    ...    beginning. The amount of passes through the list, before the keyword fails, is given by the maximum total time the keyword 
    ...    is supposed to run. The maximum total time is given by the Browser library timeout.
    
    ${first_element_found}=    Set Variable    -1
    ${time_delta}=    Set Variable    50 milliseconds
    ${old} =    Set Retry Assertions For    ${time_delta}        
    IF    ${timeout}==${None}
        ${timeout}=    Set Variable    20s
    END
    ${timeout_float}=    Convert Time    ${timeout}
    ${time_delta_float}=    Convert Time    ${time_delta}
    # Calculate max. number of passes through the selectors list, devided by two to compensate processing time
    ${repeats}=    Evaluate    (${timeout_float}/(${time_delta_float}*len(${locations})))/2

    FOR    ${counter}    IN RANGE    1    ${repeats}    
        FOR    ${index}    IN RANGE    len(${locations})
            ${has_location}=    Run Keyword And Return Status    Get Url    *=    ${locations}[${index}]    
            IF    ${has_location}
                ${first_element_found}=    Set Variable    ${index}
                Exit For Loop
            END
        END
        Exit For Loop If    ${has_location}
    END
    IF    "${first_element_found}" == "-1"
        Fail    Unable to find any visible element in list @{locations}
    END
    Set Retry Assertions For    ${old}
    RETURN    ${first_element_found}

##############################################################################################

Type Text With Keyboard Keys
    [Arguments]    ${selector}    ${text}

    ${list}=    Convert To List    ${text}
    Press Keys   ${selector}    @{list}

##############################################################################################
Type Text And Retry
    #To ensure that inserted Text is correct inserted  (in case of inserting not works direclty/ 
    #Type Text with delay timedelta not smoothly)
    [Arguments]   ${input_field_selector}      ${input_value}=${None}        ${retry}=3        
    
    FOR    ${i}    IN RANGE    ${retry}
        Type Text     ${input_field_selector}  ${input_value}  
        ${actual_text}    Get Text    ${input_field_selector}
        Run Keyword If    '${actual_text}' == '${input_value}'    Exit For Loop
        Sleep    1s
    Log    Text not inserted correctly. Retrying...
    END
    Should Be Equal As Strings    ${actual_text}   ${input_value}  
    
##############################################################################################

Delete Files Matching Pattern
    [Arguments]    ${directory}    ${pattern}

    ${files}=    OperatingSystem.List Files In Directory    ${directory}    ${pattern}
    FOR    ${file}    IN    @{files}
        ${full_path}=    Join Path    ${directory}    ${file}
        Remove File    ${full_path}
        Log    Deleted: ${full_path}
    END

##############################################################################################