*** Settings ***
Test Setup
Resource          ../../L2层关键字.robot

*** Test Cases ***
恢复出厂设置-取消
    [Tags]    AUTO
    [Setup]
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第三栏
    Cmd    adb shell input tap 85 185
    ${value}    截图    Restore_factory_Cancel
    大小断言    ${value}    0.98

恢复出厂设置-重置
    [Tags]    AUTO
    log    初始化中已测试

装置讯息-运营商
    [Tags]    AUTO
    进入装置讯息
    点击第一栏
    ${value}    截图    Carrier_info
    大小断言    ${value}    0.98

装置讯息-MAC
    [Tags]    AUTO
    进入装置讯息
    点击第三栏
    ${value}    截图    MAC_info
    大小断言    ${value}    0.98

装置讯息-蓝牙
    [Tags]    AUTO
    进入装置讯息
    点击第四栏
    ${value}    截图    Bluetooth_info
    大小断言    ${value}    0.98

装置讯息-机型
    [Tags]    AUTO
    进入装置讯息
    向上滑动
    点击第一栏
    ${value}    截图    Model_info
    大小断言    ${value}    0.98

装置讯息-序号
    [Tags]    AUTO
    进入装置讯息
    向上滑动
    点击第二栏
    ${value}    截图    SN_info
    大小断言    ${value}    0.98

装置讯息-IMEI
    [Tags]    AUTO
    进入装置讯息
    向上滑动
    点击第三栏
    ${value}    截图    IMEI_info
    大小断言    ${value}    0.98

装置讯息-ADAS
    [Tags]    AUTO
    进入装置讯息
    向上滑动
    点击第四栏
    ${value}    截图    ADAS_info
    大小断言    ${value}    0.98
