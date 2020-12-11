*** Settings ***
Test Setup
Resource          ../../L2层关键字.robot

*** Test Cases ***
单位km/h
    [Tags]    AUTO
    设置单位    adb shell input tap 90 110    unit_kmh

单位mph
    [Tags]    AUTO
    设置单位    adb shell input tap 230 110    unit_mph
