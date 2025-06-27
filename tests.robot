*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            https://www.saucedemo.com/v1/
${USERNAME}       standard_user
${PASSWORD}       secret_sauce
${INVALID_PASSWORD}    senha_errada
${BROWSER}        Chrome
${FIRST_NAME}        Marco
${LAST_NAME}         Borges
${POSTAL_CODE}       70390034

*** Test Cases ***
Login Com Sucesso
    [Documentation]    Testa login com credenciais válidas e verifica se o título "Products" é exibido.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id:user-name
    Input Text    id:user-name    ${USERNAME}
    Input Text    id:password     ${PASSWORD}
    Click Button  id:login-button
    Wait Until Page Contains Element    xpath://div[@class="product_label"]
    Element Text Should Be    xpath://div[@class="product_label"]    Products
    [Teardown]    Close Browser

Login Com Falha - Senha Inválida
    [Documentation]    Testa login com senha incorreta e verifica se mensagem de erro é exibida.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id:user-name
    Input Text    id:user-name    ${USERNAME}
    Input Text    id:password     ${INVALID_PASSWORD}
    Click Button  id:login-button
    Wait Until Page Contains Element    xpath://h3[@data-test="error"]
    ${mensagem}    Get Text    xpath://h3[@data-test="error"]
    Should Start With    ${mensagem}    Epic sadface:
    [Teardown]    Close Browser

Exibir Lista De Produtos Após Login
    [Documentation]    Verifica se a lista de produtos é exibida corretamente após o login.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login Com Credenciais Válidas
    Verificar Lista De Produtos Visível
    [Teardown]    Close Browser

Adicionar Produtos Ao Carrinho Com Sucesso
    [Documentation]    Testa se três produtos são adicionados ao carrinho e aparecem na lista de compras.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login Com Credenciais Válidas
    Adicionar Tres Produtos Ao Carrinho
    Verificar Produtos No Carrinho
    [Teardown]    Close Browser

Visualizar Detalhes Do Produto Sauce Labs Backpack
    [Documentation]    Verifica se a página de detalhes do produto "Sauce Labs Backpack" é exibida corretamente.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login Com Credenciais Válidas
    Clicar No Produto Sauce Labs Backpack
    Verificar Pagina De Detalhes Do Produto
    [Teardown]    Close Browser

Finalizar Compra Com Sucesso
    [Documentation]    Testa o fluxo completo: login, adicionar itens, checkout e finalização da compra.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login Com Credenciais Válidas
    Adicionar Dois Produtos Ao Carrinho
    Ir Para Carrinho E Iniciar Checkout
    Preencher Dados De Checkout
    Finalizar Pedido
    Verificar Mensagem De Sucesso
    [Teardown]    Close Browser

Iniciar Processo De Checkout
    [Documentation]    Verifica se o processo de checkout é iniciado corretamente após adicionar produtos ao carrinho.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login Com Credenciais Válidas
    Adicionar Tres Produtos Ao Carrinho
    Acessar Carrinho E Iniciar Checkout
    Verificar Tela De Checkout Iniciada
    [Teardown]    Close Browser

Preencher Dados Obrigatórios No Checkout
    [Documentation]    Verifica se ao preencher os dados obrigatórios (nome, sobrenome, CEP), o sistema permite continuar a compra.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login Com Credenciais Válidas
    Adicionar Um Produto Ao Carrinho
    Acessar Carrinho E Iniciar Checkout
    Preencher Dados De Checkout
    Verificar Avanço Para Resumo Da Compra
    [Teardown]    Close Browser

*** Keywords ***
Login Com Credenciais Válidas
    Wait Until Page Contains Element    id:user-name
    Input Text    id:user-name    ${USERNAME}
    Input Text    id:password     ${PASSWORD}
    Click Button  id:login-button
    Wait Until Page Contains Element    xpath://div[@class="product_label"]
    Element Text Should Be    xpath://div[@class="product_label"]    Products

Adicionar Tres Produtos Ao Carrinho
    Click Button    xpath://div[@class="inventory_list"]/div[1]//button[contains(text(), "ADD TO CART")]
    Click Button    xpath://div[@class="inventory_list"]/div[2]//button[contains(text(), "ADD TO CART")]
    Click Button    xpath://div[@class="inventory_list"]/div[3]//button[contains(text(), "ADD TO CART")]
    Click Link      id:shopping_cart_container

Verificar Produtos No Carrinho
    Wait Until Page Contains Element    xpath://div[@class="cart_item"]
    ${itens}    Get Element Count    xpath://div[@class="cart_item"]
    Should Be Equal As Integers    ${itens}    3

Verificar Lista De Produtos Visível
    Wait Until Page Contains Element    class:inventory_list
    Element Should Be Visible           class:inventory_list
    ${produtos}    Get Element Count    xpath://div[@class="inventory_list"]/div
    Should Be True    ${produtos} > 0

Clicar No Produto Sauce Labs Backpack
    Click Link    xpath://div[@class="inventory_item_name" and text()="Sauce Labs Backpack"]

Verificar Pagina De Detalhes Do Produto
    Wait Until Page Contains Element    xpath://div[@class="inventory_details_name"]
    Element Text Should Be              xpath://div[@class="inventory_details_name"]    Sauce Labs Backpack

Adicionar Dois Produtos Ao Carrinho
    Click Button    xpath://div[@class="inventory_list"]/div[1]//button[contains(text(), "ADD TO CART")]
    Click Button    xpath://div[@class="inventory_list"]/div[2]//button[contains(text(), "ADD TO CART")]

Ir Para Carrinho E Iniciar Checkout
    Click Link      id:shopping_cart_container
    Wait Until Page Contains Element    id:checkout
    Click Button    id:checkout

Preencher Dados De Checkout
    Input Text    id:first-name    ${FIRST_NAME}
    Input Text    id:last-name     ${LAST_NAME}
    Input Text    id:postal-code   ${POSTAL_CODE}
    Click Button  id:continue

Finalizar Pedido
    Wait Until Page Contains Element    id:finish
    Click Button    id:finish

Verificar Mensagem De Sucesso
    Wait Until Page Contains    THANK YOU FOR YOUR ORDER
    Page Should Contain         THANK YOU FOR YOUR ORDER

Acessar Carrinho E Iniciar Checkout
    Click Link      id:shopping_cart_container
    Wait Until Page Contains Element    id:checkout
    Click Button    id:checkout

Verificar Tela De Checkout Iniciada
    Wait Until Page Contains Element    id:first-name
    Element Should Be Visible           id:first-name

Adicionar Um Produto Ao Carrinho
    Click Button    xpath://div[@class="inventory_list"]/div[1]//button[contains(text(), "ADD TO CART")]

Verificar Avanço Para Resumo Da Compra
    Wait Until Page Contains    PAYMENT INFORMATION
    Page Should Contain         PAYMENT INFORMATION
