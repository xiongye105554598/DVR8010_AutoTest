*** Settings ***
Test Setup        返回录制页面
Resource          ../../L2层关键字.robot

*** Test Cases ***
系统音量-默认值
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第一栏
    点击第一栏
    ${value}    截图    System_volume_default
    大小断言    ${value}    0.98

系统音量-高到低
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第一栏
    点击第一栏
    向上滑动
    返回按钮
    点击第一栏
    ${value5}    截图    System_volume_5
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第一栏
    ${value4}    截图    System_volume_4
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第一栏
    ${value3}    截图    System_volume_3
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第一栏
    ${value2}    截图    System_volume_2
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第一栏
    ${value1}    截图    System_volume_1
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第一栏
    ${value0}    截图    System_volume_0
    大小断言    ${value5}    0.98
    大小断言    ${value4}    0.98
    大小断言    ${value3}    0.98
    大小断言    ${value2}    0.98
    大小断言    ${value1}    0.98
    大小断言    ${value0}    0.98

系统音量-低到高
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第一栏
    点击第一栏
    向下滑动
    返回按钮
    点击第一栏
    ${value0}    截图    System_volume_0
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第一栏
    ${value1}    截图    System_volume_1
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第一栏
    ${value2}    截图    System_volume_2
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第一栏
    ${value3}    截图    System_volume_3
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第一栏
    ${value4}    截图    System_volume_4
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第一栏
    ${value5}    截图    System_volume_5
    大小断言    ${value0}    0.98
    大小断言    ${value1}    0.98
    大小断言    ${value2}    0.98
    大小断言    ${value3}    0.98
    大小断言    ${value4}    0.98
    大小断言    ${value5}    0.98

播放音量-默认值
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第一栏
    点击第二栏
    ${value}    截图    Play_volume_default
    大小断言    ${value}    0.99

播放音量-高到低
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第一栏
    点击第二栏
    向上滑动
    返回按钮
    点击第二栏
    ${value5}    截图    Play_volume_5
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第二栏
    ${value4}    截图    Play_volume_4
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第二栏
    ${value3}    截图    Play_volume_3
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第二栏
    ${value2}    截图    Play_volume_2
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第二栏
    ${value1}    截图    Play_volume_1
    Cmd    adb shell input swipe 160 60 160 120 1000
    返回按钮
    点击第二栏
    ${value0}    截图    Play_volume_0
    大小断言    ${value5}    0.98
    大小断言    ${value4}    0.98
    大小断言    ${value3}    0.98
    大小断言    ${value2}    0.98
    大小断言    ${value1}    0.98
    大小断言    ${value0}    0.98

播放音量-低到高
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第一栏
    点击第二栏
    向下滑动
    返回按钮
    点击第二栏
    ${value0}    截图    Play_volume_0
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第二栏
    ${value1}    截图    Play_volume_1
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第二栏
    ${value2}    截图    Play_volume_2
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第二栏
    ${value3}    截图    Play_volume_3
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第二栏
    ${value4}    截图    Play_volume_4
    Cmd    adb shell input swipe 160 235 160 160 1000
    返回按钮
    点击第二栏
    ${value5}    截图    Play_volume_5
    大小断言    ${value0}    0.98
    大小断言    ${value1}    0.98
    大小断言    ${value2}    0.98
    大小断言    ${value3}    0.98
    大小断言    ${value4}    0.98
    大小断言    ${value5}    0.98

*** Keywords ***
