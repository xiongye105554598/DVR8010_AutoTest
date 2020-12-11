*** Settings ***
Resource          ../../L2层关键字.robot

*** Test Cases ***
合约条款
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    向上滑动
    点击第三栏
    点击第一栏
    sleep    8
    ${value}    截图    General_terms
    大小断言    ${value}    0.99

隐私权政策
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    向上滑动
    点击第三栏
    点击第二栏
    sleep    5
    ${value}    截图    Privacy_policy
    大小断言    ${value}    0.99

电信规范
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    向上滑动
    点击第三栏
    点击第三栏
    sleep    2
    ${value}    截图    Regulatory
    大小断言    ${value}    0.99
