*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
检查事件录影记录时间
    [Tags]    AUTO
    触发中碰撞n次    1    20
    ${sd}    SD卡挂载名称
    ${time}    获取设备系统时间
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${flag}    Check    ${time}    ${file}    check_file
    布尔断言    ${flag}

main摄像机事件录影比特率
    [Tags]    AUTO
    触发中碰撞n次    5    20
    ${sd}    SD卡挂载名称
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    main
    ${flag}    Check    ${air}    ${copyfile}    check_bitrate
    布尔断言    ${flag}

2nd摄像机事件录影比特率
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    2nd
    ${flag}    Check    ${air}    ${copyfile}    check_bitrate
    布尔断言    ${flag}

main_2nd事件录影命名规则
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${time}    获取设备系统时间
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${flag}    Check    ${time}    ${file}    format_name
    布尔断言    ${flag}

man_2nd照片命名规则
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${time}    获取设备系统时间
    ${file}    照片文件列表(SDcard)    ${sd}
    ${flag}    Check    ${time}    ${file}    format_name
    布尔断言    ${flag}

main_2nd事件录影文件大小
    [Tags]    AUTO
    触发中碰撞n次    5    20
    ${sd}    SD卡挂载名称
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    5    ${air}
    ${flag}    Check    ${air}    ${copyfile}    event_file_size
    布尔断言    ${flag}

main_2nd照片文件大小
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${file}    照片文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    PICTURE    ${file}    5    ${air}
    ${flag}    Check    ${air}    ${copyfile}    picture_file_size
    布尔断言    ${flag}

最大事件录影时覆盖（8GB）
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞n次    1    20
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

最大照片时覆盖（8GB）
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发中碰撞n次    1    20
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_picture
    布尔断言    ${flag}

首先触发高优先级事件
    Cmd    adb shell settings put global event_time_span 5/15
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 100 --el timeStamp `date +%s`000"
    sleep    1
    Pull Pic    eventType_100_1
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 101 --el timeStamp `date +%s`000"
    sleep    1
    Cmd    adb shell input keyevent tap 160 230
    手动触发碰撞
    sleep    20
    还原
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    裁剪图片    eventType_100_1    20    25    280    160
    ${value}    获取图片相似度    eventType_100_1
    布尔断言    ${flag}
    大小断言    ${value}    0.95

首先触发低优先级事件
    Cmd    adb shell settings put global event_time_span 5/15
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    手动触发碰撞
    sleep    2
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 101 --el timeStamp `date +%s`000"
    sleep    2
    #Pull Pic    eventType_101
    Cmd    adb shell "am broadcast -a com.askey.dvr.eventsending.EVENT_NOTIFY_EVENT_DETECT --ei eventType 100 --el timeStamp `date +%s`000"
    sleep    20
    Pull Pic    eventType_100_2
    Cmd    adb shell input keyevent tap 160 230
    还原
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_3_event
    #裁剪图片    eventType_101    20    25    280    215
    #${value1}    获取图片相似度    eventType_101
    裁剪图片    eventType_100_2    20    25    280    160
    ${value2}    获取图片相似度    eventType_100_2
    布尔断言    ${flag}
    #大小断言    ${value1}    0.95
    大小断言    ${value2}    0.95

触发交道信号灯事件
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发交通信号灯
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

触发行人穿越人行横道事件
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发行人穿越人行横道
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

触发行人未走人行横道事件
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发行人穿越人行横道
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

触发未在指定地点停车事件
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${filelist1}    获取所有文件列表    ${sd}    sdcard
    触发未在指定地点停车
    ${filelist2}    获取所有文件列表    ${sd}    sdcard
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

两台摄像机同时事件录影
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${time}    获取设备系统时间
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${flag}    Check    ${time}    ${file}    record_simultaneous
    布尔断言    ${flag}

两台摄像机同时拍摄照片
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${time}    获取设备系统时间
    ${file}    照片文件列表(SDcard)    ${sd}
    ${flag}    Check    ${time}    ${file}    record_simultaneous
    布尔断言    ${flag}

main摄像机事件录影分辨率帧率
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    main
    ${flag}    Check    ${air}    ${copyfile}    check_resolution_main
    布尔断言    ${flag}

2nd摄像机事件录影分辨率帧率
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${file}    事件录影文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    EVENT    ${file}    3    2nd
    ${flag}    Check    ${air}    ${copyfile}    check_resolution_2nd
    布尔断言    ${flag}

main摄像机照片分辨率
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${file}    照片文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    PICTURE    ${file}    5    main
    ${flag}    Check    ${air}    ${copyfile}    check_pic_resolution
    布尔断言    ${flag}

2nd摄像机照片分辨率
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    ${file}    照片文件列表(SDcard)    ${sd}
    ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    PICTURE    ${file}    5    2nd
    ${flag}    Check    ${air}    ${copyfile}    check_pic_resolution
    布尔断言    ${flag}
