*** Settings ***
Suite Setup
Test Setup
Resource          ../../L2层关键字.robot

*** Test Cases ***
繁体中文
    [Tags]    AUTO
    设置语言1    adb shell input tap 285 180    Language_繁体中文

日本语
    [Tags]    AUTO
    设置语言1    adb shell input tap 285 130    Language_日本语

Deutsch
    [Tags]    AUTO
    设置语言1    adb shell input tap 285 230    Language_Deutsch

espanol
    [Tags]    AUTO
    设置语言2    adb shell input tap 285 180    Language_espanol

Francais
    [Tags]    AUTO
    设置语言2    adb shell input tap 285 230    Language_Francais

English
    [Tags]    AUTO
    设置语言1    adb shell input tap 285 80    Language_English
