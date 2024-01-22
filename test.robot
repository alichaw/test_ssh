*** Settings ***
Library        DatabaseLibrary
Library        Selenium2Library
Variables        config.py

*** Test Cases ***
test Database
    Test In Web
    Check Data Key In

*** Keywords ***
Test In Web
    Open Browser    url=${WEB_URL}   browser=${BROWSER}
    Input Text    name:content    ${TEXT}
    Click Button    css=input[type='submit']
    Close Browser
Check Data Key In
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    ${result} =    Query    SELECT * FROM texts WHERE content = '${TEXT}';
    Log    ${result}
    Disconnect From Database
