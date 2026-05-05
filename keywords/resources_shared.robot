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




*** Variables ***
# PATH VARIABLES
