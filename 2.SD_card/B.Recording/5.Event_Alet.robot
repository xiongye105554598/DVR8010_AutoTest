*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
RAPID_ACCELERATION
    [Tags]    AUTO
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 102 --el timeStamp `date +%s`000"
    截图    RAPID_ACCELERATION
    裁剪图片    RAPID_ACCELERATION    20    25    280    215
    ${value}    获取图片相似度    RAPID_ACCELERATION
    大小断言    ${value}    0.97

RAPID_DECELERATION
    [Tags]    AUTO
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 103 --el timeStamp `date +%s`000"
    截图    RAPID_DECELERATION
    裁剪图片    RAPID_DECELERATION    20    25    280    215
    ${value}    获取图片相似度    RAPID_DECELERATION
    大小断言    ${value}    0.97

ABRUPT_HANDLE_LEFT
    [Tags]    AUTO
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 104 --el timeStamp `date +%s`000"
    截图    ABRUPT_HANDLE_LEFT
    裁剪图片    ABRUPT_HANDLE_LEFT    20    25    280    215
    ${value}    获取图片相似度    ABRUPT_HANDLE_LEFT
    大小断言    ${value}    0.97

ABRUPT_HANDLE_RIGHT
    [Tags]    AUTO
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 105 --el timeStamp `date +%s`000"
    截图    ABRUPT_HANDLE_RIGHT
    裁剪图片    ABRUPT_HANDLE_RIGHT    20    25    280    215
    ${value}    获取图片相似度    ABRUPT_HANDLE_RIGHT
    大小断言    ${value}    0.97
