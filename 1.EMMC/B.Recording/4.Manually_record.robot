*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
事件录制时单击手动录影-emmc
    [Tags]    AUTO
    Cmd    adb shell settings put global event_time_span 5/15
    ${filelist1}    获取所有文件列表    ${air}    emmc
    触发中碰撞
    手动触发碰撞
    sleep    20
    还原
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

手动录制时单击手动录影-emmc
    [Tags]    AUTO
    Cmd    adb shell settings put global event_time_span 5/15
    ${filelist1}    获取所有文件列表    ${air}    emmc
    手动触发碰撞
    sleep    2
    手动触发碰撞
    sleep    20
    还原
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal
    布尔断言    ${flag}

手动录影时进入菜单
    [Tags]    AUTO
    手动触发碰撞
    菜单按钮
    sleep    15
    ${file}    事件录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    EVENT    ${file}    2    ${air}
    返回按钮
    ${flag}    Check    ${air}    ${copyfile}    15s_file
    布尔断言    ${flag}
