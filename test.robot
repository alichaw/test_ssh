*** Settings ***
Library        DatabaseLibrary
Library        SeleniumLibrary
Library        SSHLibrary
Variables      config.py

*** Test Cases ***
Test Database
    Create SSH Tunnel
    Start Flask
    Test In Web
    Check Data Key In
    Close SSH Tunnel

*** Keywords ***
Create SSH Tunnel
    Open Connection    ${SSH_HOST}    port=${SSH_PORT}
    Login    ${SSH_USER}    ${SSH_PASS}
    ${db_tunnel_id}=    Start Command    ssh -L ${LOCAL_DB_PORT}:localhost:${DB_PORT} -N -f -p ${SSH_PORT} ${SSH_USER}@${SSH_HOST}
    ${output}=    Read
    Log    ${output}
    ${web_tunnel_id}=   Start Command    ssh -L ${LOCAL_WEB_PORT}:localhost:8000 -N -f -p ${SSH_PORT} ${SSH_USER}@${SSH_HOST}
    ${output}=    Read
    Log    ${output}
    Set Suite Variable    ${db_tunnel_id}
    Set Suite Variable    ${web_tunnel_id}

Close SSH Tunnel
    Stop Command    ${db_tunnel_id}
    Stop Command    ${web_tunnel_id}
    Close All Connections

Start Flask
    Start Command        ${CONDA_CMD}
    ${flask_cmd}=    Catenate    SEPARATOR=    export FLASK_APP=${FLASK_APP} && nohup ${FLASK_RUN_COMMAND} &
    ${output}=    Start Command    ${flask_cmd}    return_stdout=True
    Log    ${output}
Test In Web
    Open Browser    ${WEB_URL}    ${BROWSER}
    Input Text    name:content    ${TEXT}
    Click Button    css=input[type='submit']
    Close Browser

Check Data Key In
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    localhost    ${LOCAL_DB_PORT}
    ${result} =    Query    SELECT * FROM texts WHERE content = '${TEXT}';
    Log    ${result}
    Disconnect From Database
