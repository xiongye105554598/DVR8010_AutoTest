*** Settings ***
Test Setup        返回录制页面
Resource          ../../L2层关键字.robot

*** Test Cases ***
亮度-默认值
    [Tags]    AUTO
    返回录制页面
    ${brightness}    获取亮度
    范围断言    155    ${brightness}    150

亮度-高到低
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第二栏
    点击第一栏
    向上滑动
    ${brightness5}    获取亮度
    Cmd    adb shell input swipe 160 60 160 120 1000
    ${brightness4}    获取亮度
    Cmd    adb shell input swipe 160 60 160 120 1000
    ${brightness3}    获取亮度
    Cmd    adb shell input swipe 160 60 160 120 1000
    ${brightness2}    获取亮度
    Cmd    adb shell input swipe 160 60 160 120 1000
    ${brightness1}    获取亮度
    Cmd    adb shell input swipe 160 60 160 120 1000
    ${brightness0}    获取亮度
    范围断言    255    ${brightness5}    250
    范围断言    205    ${brightness4}    200
    范围断言    155    ${brightness3}    150
    范围断言    105    ${brightness2}    100
    范围断言    55    ${brightness1}    50
    范围断言    10    ${brightness0}    1

亮度-低到高
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第二栏
    点击第一栏
    向下滑动
    ${brightness0}    获取亮度
    Cmd    adb shell input swipe 160 235 160 160 1000
    ${brightness1}    获取亮度
    Cmd    adb shell input swipe 160 235 160 160 1000
    ${brightness2}    获取亮度
    Cmd    adb shell input swipe 160 235 160 160 1000
    ${brightness3}    获取亮度
    Cmd    adb shell input swipe 160 235 160 160 1000
    ${brightness4}    获取亮度
    Cmd    adb shell input swipe 160 235 160 160 1000
    ${brightness5}    获取亮度
    范围断言    255    ${brightness5}    250
    范围断言    205    ${brightness4}    200
    范围断言    155    ${brightness3}    150
    范围断言    105    ${brightness2}    100
    范围断言    55    ${brightness1}    50
    范围断言    10    ${brightness0}    1

屏幕关闭时间-10s
    [Tags]    AUTO
    屏幕关闭时间    adb shell input tap 50 205    11

屏幕关闭时间-1min
    [Tags]    AUTO
    屏幕关闭时间    adb shell input tap 160 205    61

屏幕关闭时间-3min
    [Tags]    AUTO
    屏幕关闭时间    adb shell input tap 260 205    181

屏幕关闭时间-永久
    [Tags]    AUTO
    屏幕关闭时间-永久
    sleep    240
    ${brightness}    获取亮度
    Should Be True    ${brightness}>0    屏幕亮度值不在规定范围内
