*** Settings ***
Library          SeleniumLibrary

Suite Setup      Dado que a aplicação BitPulse esteja iniciada
Suite Teardown   E o navegador seja encerrado
Test Template    Validar Conversão IEEE 754

*** Variables ***
${URL}              http://localhost:3000
${BROWSER}          chrome

${INPUT_VALOR}      id=valor
${BTN_IEEE}         id=btnIeee
${RESULT_IEEE}      id=resultIeee

*** Test Cases *** VALOR     PROPRIEDADE_ESPERADA

*** Test Cases ***
CT01 - Entrada Positiva Real
    [Template]    Validar Conversão IEEE 754
    0.5    "sinal": "0"

CT02 - Entrada Negativa Real
    [Template]    Validar Conversão IEEE 754
    -3.14    "sinal": "1"

CT03 - Fronteira Nula (Zero)
    [Template]    Validar Conversão IEEE 754
    0    "binario32": "00000000000000000000000000000000"

CT04 - Número Inteiro Grande
    [Template]    Validar Conversão IEEE 754
    2026    "expoente": "10001001"

*** Keywords ***

Dado que a aplicação BitPulse esteja iniciada
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${INPUT_VALOR}    timeout=10s

Validar Conversão IEEE 754
    [Arguments]    ${numero_decimal}    ${texto_esperado}
    
    # Executa a limpeza robusta do campo simulando comandos de teclado (Ctrl + A + Backspace)
    Wait Until Element Is Visible    ${INPUT_VALOR}    timeout=5s
    Press Keys    ${INPUT_VALOR}    CTRL+a+BACKSPACE
    
    # Insere o novo valor para processamento
    Input Text    ${INPUT_VALOR}    ${numero_decimal}
    
    # Dispara a requisição através do clique no botão da interface
    Click Button    ${BTN_IEEE}
    
    # Inspeciona a área de log gerada na tela para validar o resultado estruturado
    Wait Until Element Is Visible    ${RESULT_IEEE}    timeout=5s
    Element Should Contain    ${RESULT_IEEE}    ${texto_esperado}

E o navegador seja encerrado
    Close Browser