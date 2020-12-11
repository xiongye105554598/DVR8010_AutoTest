*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
关闭WIFI
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第一栏
    点击第一栏
    ${value1}    截图    wifi_off
    run keyword if    ${value1}>0.98    Cmd    adb shell input tap 280 80
    sleep    3
    Cmd    adb shell input tap 280 80
    sleep    5
    ${value}    截图    wifi_off
    大小断言    ${value}    0.98

打开WIFI
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第一栏
    点击第一栏
    ${value1}    截图    wifi_off
    run keyword if    ${value1}<0.97    Cmd    adb shell input tap 280 80
    sleep    5
    Cmd    adb shell input tap 280 80
    sleep    8
    截图    wifi_on
    裁剪图片    wifi_on    0    0    320    160
    ${value}    获取图片相似度    wifi_on
    大小断言    ${value}    0.97
