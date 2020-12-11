*** Settings ***
Resource          ../L3公共层.robot

*** Keywords ***
事件录影文件列表(SDcard)
    [Arguments]    ${sd}
    ${file}    EventFilesSD    ${sd}
    [Return]    ${file}

照片文件列表(SDcard)
    [Arguments]    ${sd}
    ${file}    PictureFilesSD    ${sd}
    [Return]    ${file}

触发大碰撞
    Log    触发大碰撞事件
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 100 --el timeStamp `date +%s`000"
    sleep    1
    Cmd    adb shell input keyevent tap 160 230

触发交通信号灯
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 0 --el timeStamp `date +%s`000"
    sleep    15

触发行人穿越人行横道
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 9 --el timeStamp `date +%s`000"
    sleep    15

触发未在指定地点停车
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 29 --el timeStamp `date +%s`000"
    sleep    15

触发行人未走人行横道
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 10 --el timeStamp `date +%s`000"
    sleep    15

设置语言2
    [Arguments]    ${cmd}    ${image_name}
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第四栏
    向上滑动
    Cmd    ${cmd}
    sleep    2
    返回按钮
    ${value}    截图    ${image_name}
    大小断言    ${value}    0.96

设置语言1
    [Arguments]    ${cmd}    ${image_name}
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第四栏
    Cmd    ${cmd}
    sleep    2
    返回按钮
    ${value}    截图    ${image_name}
    大小断言    ${value}    0.96

进入装置讯息
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    向上滑动
    点击第二栏
    点击第一栏

屏幕关闭时间
    [Arguments]    ${cmd}    ${time}
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第二栏
    点击第二栏
    Cmd    adb shell input tap 90 110
    Cmd    ${cmd}
    返回录制页面
    sleep    ${time}
    ${brightness}    获取亮度
    急减速
    Should Be True    0==${brightness}    屏幕亮度值不在规定范围内

设置单位
    [Arguments]    ${cmd}    ${image_name}
    返回录制页面
    菜单按钮
    点击第三栏
    点击第二栏
    点击第三栏
    Cmd    ${cmd}
    返回按钮
    点击第三栏
    ${value}    截图    ${image_name}
    大小断言    ${value}    0.97
