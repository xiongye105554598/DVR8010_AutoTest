*** Settings ***
Test Setup        返回录制页面
Resource          ../../L2层关键字.robot

*** Test Cases ***
切换SDcard模式
    [Tags]    AUTO
    切换设备模式    sd
    sleep    30
    抓log

转到Alexa页面
    [Tags]    AUTO
    菜单按钮
    点击第三栏
    返回录制页面
    菜单按钮
    点击第三栏
    点击第四栏
    sleep    3
    ${value}    截图    Alexa
    大小断言    ${value}    0.90
