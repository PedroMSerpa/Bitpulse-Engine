*** Settings ***
Library     SeleniumLibrary

Suite Setup       Dado que o simulador esteja aberto
Suite Teardown    E o navegador seja fechado

*** Variables ***
${URL}              http://localhost:3000
${BROWSER}          chrome

${SELECT_GATE}      id=gate
${SELECT_A}         id=inputA
${SELECT_B}         id=inputB
${BTN_GATE}         id=btnGate
${RESULT_GATE}      id=resultGate

*** Test Cases ***

CT01 - Porta AND com entradas 1 e 1 retorna saida 1
    Dado que o usuário seleciona a porta    AND
    E define a entrada A    1
    E define a entrada B    1
    Quando clicar no botão simular
    Então o resultado renderizado deve conter    "saida": 1

CT02 - Porta OR com entradas 0 e 0 retorna saida 0
    Dado que o usuário seleciona a porta    OR
    E define a entrada A    0
    E define a entrada B    0
    Quando clicar no botão simular
    Então o resultado renderizado deve conter    "saida": 0

CT03 - Porta NOT com entrada 1 retorna saida 0
    Dado que o usuário seleciona a porta    NOT
    E define a entrada A    1
    Quando clicar no botão simular
    Então o resultado renderizado deve conter    "saida": 0

CT04 - Porta XOR com entradas 1 e 1 retorna saida 0
    Dado que o usuário seleciona a porta    XOR
    E define a entrada A    1
    E define a entrada B    1
    Quando clicar no botão simular
    Então o resultado renderizado deve conter    "saida": 0

*** Keywords ***

Dado que o simulador esteja aberto
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${SELECT_GATE}    timeout=10s

Dado que o usuário seleciona a porta
    [Arguments]    ${porta}
    Wait Until Element Is Visible    ${SELECT_GATE}    timeout=5s
    Select From List By Value    ${SELECT_GATE}    ${porta}

E define a entrada A
    [Arguments]    ${valor}
    Wait Until Element Is Visible    ${SELECT_A}    timeout=5s
    Select From List By Value    ${SELECT_A}    ${valor}

E define a entrada B
    [Arguments]    ${valor}
    # Só interage com o campo B se a interface não o tiver ocultado (regra da porta NOT)
    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${SELECT_B}
    IF    ${status}
        Select From List By Value    ${SELECT_B}    ${valor}
    END

Quando clicar no botão simular
    Click Button    ${BTN_GATE}

Então o resultado renderizado deve conter
    [Arguments]    ${texto_esperado}
    Wait Until Element Is Visible    ${RESULT_GATE}    timeout=5s
    Element Should Contain    ${RESULT_GATE}    ${texto_esperado}

E o navegador seja fechado
    Close Browser