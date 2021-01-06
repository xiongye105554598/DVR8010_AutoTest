*** Settings ***
Library           Public.py

*** Variables ***
${air}            ${EMPTY}

*** Keywords ***
截图
    [Arguments]    ${image_name}
    Pull Pic    ${image_name}
    ${value}    Image Compare Similarity    ${image_name}
    [Return]    ${value}

裁剪图片
    [Arguments]    ${image_name}    ${x1}    ${x2}    ${y1}    ${y2}
    Crop Pic    ${image_name}    ${x1}    ${x2}    ${y1}    ${y2}

范围断言
    [Arguments]    ${max}    ${value}    ${min}
    Should Be True    ${max}>=${value}>=${min}    判断值是否在规定范围内

大小断言
    [Arguments]    ${value1}    ${value2}
    Should Be True    ${value1}>=${value2}

布尔断言
    [Arguments]    ${flag}
    should be true    ${flag}

返回录制页面
    返回按钮
    返回按钮
    返回按钮
    返回按钮
    返回按钮
    返回按钮

向上滑动
    Cmd    adb shell input swipe 160 230 160 30 1000
    Cmd    adb shell input swipe 160 230 160 30 1000

向下滑动
    Cmd    adb shell input swipe 160 60 160 230 1000
    Cmd    adb shell input swipe 160 60 160 230 1000

返回按钮
    Cmd    adb shell input tap 40 25

菜单按钮
    Cmd    adb shell input tap 50 210

点击第一栏
    Cmd    adb shell input tap 160 80

点击第二栏
    Cmd    adb shell input tap 160 145

点击第三栏
    Cmd    adb shell input tap 160 190

点击第四栏
    Cmd    adb shell input tap 160 230

下一步
    Cmd    adb shell input tap 280 25

点击提示
    Cmd    adb shell input tap 160 225

急减速
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 103 --el timeStamp `date +%s`000"
    sleep    3

获取亮度
    Cmd    adb root
    ${brightness}    Cmd Popen    adb shell cat sys/class/leds/lcd-backlight/brightness
    [Return]    int(${brightness})

获取图片相似度
    [Arguments]    ${image_name}
    ${value}    Image Compare Similarity    ${image_name}
    [Return]    ${value}

屏幕关闭时间-永久
    返回录制页面
    菜单按钮
    Cmd    adb shell input tap 160 220
    点击第二栏
    点击第二栏
    点击第二栏
    Cmd    adb shell input tap 210 110
    返回录制页面
    log    屏幕关闭时间设置为永久

更新设备时间
    Update Time

切换设备模式
    [Arguments]    ${mode}
    Emmc Mode    ${mode}
    sleep    70

触发中碰撞
    Log    触发中碰撞事件
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 101 --el timeStamp `date +%s`000"
    sleep    1
    Cmd    adb shell input keyevent tap 160 230

触发中碰撞n次
    [Arguments]    ${num}    ${time}
    FOR    ${i}    IN RANGE    1    int(${num}+1)
        Log    触发中碰撞：${i}/${num}
        Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 101 --el timeStamp `date +%s`000"
        sleep    ${time}
        Cmd    adb shell input keyevent tap 160 230
    END

SD卡挂载名称
    ${sd}    Sdcard
    [Return]    ${sd}[0]

获取所有文件列表
    [Arguments]    ${sd}    ${flag}
    ${allfile}    AllFiles    ${sd}    ${flag}
    [Return]    ${allfile}

合并列表
    [Arguments]    ${filelist1}    ${filelist2}
    ${filelist}    ConformList    ${filelist1}    ${filelist2}
    [Return]    ${filelist}

获取设备系统时间
    ${time}    GetDeviceDate
    [Return]    ${time}

一般录影文件列表(SDcard)
    [Arguments]    ${sd}
    ${file}    NormalFilesSD    ${sd}
    [Return]    ${file}

文件拷贝到本地(SDcard)
    [Arguments]    ${sd}    ${file_type}    ${file}    ${num}    ${main_2nd}
    ${copyfile}    CopyFileSD    ${sd}    ${file_type}    ${file}    ${num}    ${main_2nd}
    [Return]    ${copyfile}

还原
    Cmd    adb shell settings put global RECSET_event_time_span 10/5
    Cmd    adb shell settings put global RECSET_event_pics 0,5,10,15

手动触发碰撞
    Cmd    adb shell input tap 290 205

抓log
    Logcat
