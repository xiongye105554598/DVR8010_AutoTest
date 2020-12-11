*** Settings ***
Resource          ../../L2层关键字.robot

*** Test Cases ***
抓取一个日志
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第四栏
    sleep    3
    Cmd    adb shell input tap 305 65
    Cmd    adb shell input tap 160 215
    sleep    5
    ${value}    截图    loggin_1
    Cmd    adb shell input tap 160 215
    Cmd    adb shell input tap 25 25
    大小断言    ${value}    0.98

抓取多个日志
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第四栏
    sleep    3
    Cmd    adb shell input tap 305 65
    Cmd    adb shell input tap 305 100
    Cmd    adb shell input tap 305 130
    Cmd    adb shell input tap 160 215
    sleep    5
    ${value}    截图    loggin_n
    Cmd    adb shell input tap 160 215
    Cmd    adb shell input tap 25 25
    大小断言    ${value}    0.98

抓取日志时选择其它项目
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第四栏
    sleep    3
    Cmd    adb shell input tap 305 65
    Cmd    adb shell input tap 160 215
    Cmd    adb shell input tap 305 165
    ${value}    截图    loggin_select
    Cmd    adb shell input tap 160 215
    Cmd    adb shell input tap 160 215
    Cmd    adb shell input tap 25 25
    大小断言    ${value}    0.97

检查日志
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第四栏
    sleep    3
    Cmd    adb shell input tap 305 65
    Cmd    adb shell input tap 160 215
    sleep    5
    Cmd    adb shell input tap 160 215
    Cmd    adb shell input tap 25 25
    #${loggin}    Get Loggin
    ${flag}    Check    ${air}    ${air}    log
    布尔断言    ${flag}
