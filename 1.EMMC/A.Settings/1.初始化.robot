*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
切换EMMC模式
    [Tags]    AUTO
    Clear
    切换设备模式    emmc
    sleep    30

初始化
    [Tags]    AUTO
    菜单按钮
    返回按钮
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第三栏
    Cmd    adb shell input tap 230 185
    sleep    240
    ${value1}    截图    Language_default
    ${brightness}    获取亮度
    Cmd    adb shell input tap 285 130
    Cmd    adb shell input tap 285 185
    向上滑动
    Cmd    adb shell input tap 285 110
    Cmd    adb shell input tap 285 160
    Cmd    adb shell input tap 285 210
    向下滑动
    FOR    ${i}    IN RANGE    0    int(10)
        Cmd    adb shell input tap 285 80
    END
    下一步
    sleep    60
    下一步
    Cmd    adb shell input tap 160 140
    Cmd    adb shell input tap 260 140
    下一步
    sleep    2
    ${value2}    截图    Calibration_center_point
    点击提示
    Prompt Box    请校准DVR中心点
    下一步
    sleep    2
    点击提示
    sleep    3
    ${value3}    截图    Drag_adjiust_volume
    点击提示
    大小断言    ${value1}    0.95
    范围断言    155    ${brightness}    150
    大小断言    ${value2}    0.95
    大小断言    ${value3}    0.95

首次进入播放页面
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    sleep    1
    点击第二栏
    sleep    1
    点击第二栏
    sleep    1
    点击第一栏
    sleep    3
    点击提示
    sleep    3
    ${value}    截图    First_play
    点击提示
    大小断言    ${value}    0.95
