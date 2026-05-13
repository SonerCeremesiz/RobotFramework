
*** Variables ***

${project_dir}    ${CURDIR}${/}


*** Settings ***

Library    Browser    strict=False    timeout=30s    retry_assertions_for=20s
Library    RequestsLibrary
Library    requests
Library    JSONLibrary
Library    DependencyLibrary
Library    ScreenCapLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Library    Easter
Library    Process
Library    Screenshot
Library    XML
Library    String
Library    FakerLibrary
Library    SSHLibrary

# SHARED KEYWORDS
Resource     keywords.robot

Variables    ../locators/page.yaml
Variables    ../locators/header_footer.yaml 
Variables    ../locators/form.yaml
Variables    ../locations/navigation.yaml
