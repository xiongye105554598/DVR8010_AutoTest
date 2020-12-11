*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
触发大碰撞事件
    返回录制页面
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发大碰撞
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

触发中碰撞事件
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

事件记录期间触发新事件
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 100 --el timeStamp `date +%s`000"
    sleep    1
    触发大碰撞
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_2_event
    布尔断言    ${flag}

设备重启后触发事件
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    Cmd    adb reboot
    sleep    70
    触发中碰撞
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

10s事件录影
    ${sd}    SD卡挂载名称
    Cmd    adb shell settings put global event_time_span 5/5
    触发中碰撞n次    3    10
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    ${air}
    还原
    ${flag}    Check    ${air}    ${copyfile}    10s_file
    布尔断言    ${flag}

15s事件录影
    ${sd}    SD卡挂载名称
    Cmd    adb shell settings put global event_time_span 10/5
    触发中碰撞n次    3    15
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    ${air}
    ${flag1}    Check    ${air}    ${copyfile}    15s_file
    Cmd    adb shell settings put global event_time_span 5/10
    触发中碰撞n次    3    15
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    ${air}
    ${flag2}    Check    ${air}    ${copyfile}    15s_file
    还原
    布尔断言    ${flag1}
    布尔断言    ${flag2}

20s事件录影
    ${sd}    SD卡挂载名称
    Cmd    adb shell settings put global event_time_span 10/10
    触发中碰撞n次    3    20
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    ${air}
    ${flag1}    Check    ${air}    ${copyfile}    20s_file
    Cmd    adb shell settings put global event_time_span 15/5
    触发中碰撞n次    3    20
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    ${air}
    ${flag2}    Check    ${air}    ${copyfile}    20s_file
    还原
    布尔断言    ${flag1}
    布尔断言    ${flag2}

事件照片数量6
    Cmd    adb shell settings put global event_time_span 5/5
    Cmd    adb shell settings put global event_pics 0,5,9
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞n次    1    10
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_event_06
    还原
    布尔断言    ${flag}

事件照片数量8
    Cmd    adb shell settings put global event_time_span 10/5
    Cmd    adb shell settings put global event_pics 0,5,10,15
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞n次    1    15
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_event_08
    布尔断言    ${flag}

事件照片数量10
    Cmd    adb shell settings put global event_time_span 10/5
    Cmd    adb shell settings put global event_pics 0,5,7,10,15
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞n次    1    15
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_event_10
    还原
    布尔断言    ${flag}

事件照片数量12
    Cmd    adb shell settings put global event_time_span 10/10
    Cmd    adb shell settings put global event_pics 0,3,6,10,12,15
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞n次    1    20
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_event_12
    还原
    布尔断言    ${flag}
