*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
进入播放目录停止一般录影-emmc
    [Tags]    AUTO
    返回录制页面
    ${filelist1}    获取所有文件列表    ${air}    emmc
    菜单按钮
    点击第二栏
    sleep    57
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal_no
    布尔断言    ${flag}

退出播放目录开始一般录影-emmc
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第二栏
    ${filelist1}    获取所有文件列表    ${air}    emmc
    返回录制页面
    sleep    15
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal
    布尔断言    ${flag}

进入非播放目录继续一般录影-emmc
    [Tags]    AUTO
    返回录制页面
    ${filelist1}    获取所有文件列表    ${air}    emmc
    菜单按钮
    sleep    58
    ${filelist2}    获取所有文件列表    ${air}    emmc
    返回按钮
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal
    布尔断言    ${flag}

播放录影时停止一般录影-emmc
    [Tags]    AUTO
    返回录制页面
    ${filelist1}    获取所有文件列表    ${air}    emmc
    菜单按钮
    点击第二栏
    点击第二栏
    点击第一栏
    sleep    58
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal_no
    布尔断言    ${flag}

退出播放视频开始一般录影-emmc
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第二栏
    点击第二栏
    点击第一栏
    ${filelist1}    获取所有文件列表    ${air}    emmc
    返回录制页面
    sleep    15
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal
    布尔断言    ${flag}

一般录影不会被警告信息中断-emmc
    [Tags]    AUTO
    ${filelist1}    获取所有文件列表    ${air}    emmc
    急减速
    sleep    1
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal_no
    布尔断言    ${flag}

进入非播放目录继续事件录影-emmc
    [Tags]    AUTO
    触发中碰撞
    菜单按钮
    sleep    15
    ${file}    事件录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    EVENT    ${file}    2    ${air}
    ${flag}    Check    ${air}    ${copyfile}    15s_file
    布尔断言    ${flag}

事件录影不会被警告信息中断-emmc
    [Tags]    AUTO
    返回录制页面
    Cmd    adb shell settings put global RECSET_event_time_span 5/15
    sleep    1
    触发中碰撞
    急减速
    sleep    20
    还原
    ${file}    事件录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    EVENT    ${file}    2    ${air}
    ${flag}    Check    ${air}    ${copyfile}    20s_file
    布尔断言    ${flag}
