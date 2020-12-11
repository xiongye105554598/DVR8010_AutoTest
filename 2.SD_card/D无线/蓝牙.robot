*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
关闭蓝牙
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第一栏
    点击第二栏
    ${value1}    截图    Bluetooth_off
    run keyword if    ${value1}>0.97    cmd    adb shell input tap 280 80
    sleep    3
    cmd    adb shell input tap 280 80
    sleep    3
    ${value}    截图    Bluetooth_off
    Cmd    adb shell input tap 280 80
    大小断言    ${value}    0.97

打开蓝牙
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第一栏
    点击第二栏
    ${value1}    截图    Bluetooth_off
    run keyword if    ${value1}<0.97    Cmd    adb shell input tap 280 80
    sleep    3
    Cmd    adb shell input tap 280 80
    sleep    5
    截图    Bluetooth_on
    裁剪图片    Bluetooth_on    0    0    320    160
    ${value}    获取图片相似度    Bluetooth_on
    大小断言    ${value}    0.97
