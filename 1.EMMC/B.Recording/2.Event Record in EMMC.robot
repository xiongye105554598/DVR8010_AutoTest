*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
检查事件录影记录时间-emmc
    [Tags]    AUTO
    触发中碰撞n次    1    20
    ${time}    获取设备系统时间
    ${file}    事件录影文件列表(EMMC)
    ${flag}    Check    ${time}    ${file}    check_file
    布尔断言    ${flag}

main摄像机事件录影比特率-emmc
    [Tags]    AUTO
    触发中碰撞n次    5    20
    ${file}    事件录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    EVENT    ${file}    3    main
    ${flag}    Check    ${air}    ${copyfile}    check_bitrate
    布尔断言    ${flag}

2nd摄像机事件录影比特率-emmc
    [Tags]    AUTO
    ${file}    事件录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    EVENT    ${file}    3    2nd
    ${flag}    Check    ${air}    ${copyfile}    check_bitrate
    布尔断言    ${flag}

main_2nd事件录影命名规则-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    事件录影文件列表(EMMC)
    ${flag}    Check    ${time}    ${file}    format_name
    布尔断言    ${flag}

man_2nd照片命名规则-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    照片文件列表(EMMC)
    ${flag}    Check    ${time}    ${file}    format_name
    布尔断言    ${flag}

main_2nd事件录影文件大小-emmc
    [Tags]    AUTO
    触发中碰撞n次    5    20
    ${file}    事件录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    EVENT    ${file}    5    ${air}
    ${flag}    Check    ${air}    ${copyfile}    event_file_size
    布尔断言    ${flag}

main_2nd照片文件大小-emmc
    [Tags]    AUTO
    ${file}    照片文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    PICTURE    ${file}    5    ${air}
    ${flag}    Check    ${air}    ${copyfile}    picture_file_size
    布尔断言    ${flag}

最大事件录影时覆盖-emmc
    [Tags]    AUTO
    ${filelist1}    获取所有文件列表    ${air}    emmc
    触发中碰撞n次    1    20
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_event
    布尔断言    ${flag}

最大照片时覆盖-emmc
    [Tags]    AUTO
    ${filelist1}    获取所有文件列表    ${air}    emmc
    触发中碰撞n次    1    20
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_picture
    布尔断言    ${flag}
