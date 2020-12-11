*** Settings ***
Suite Setup
Resource          ../L2层关键字.robot

*** Test Cases ***
前置条件
    [Tags]    AUTO
    更新设备时间
    返回录制页面
    抓log
    屏幕关闭时间-永久
    触发中碰撞n次    35    20

检查一般录影记录时间-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${flag}    Check    ${time}    ${file}    check_file
    布尔断言    ${flag}

1min一般录影-emmc
    [Tags]    AUTO
    sleep    480
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    NORMAL    ${file}    5    ${air}
    ${flag}    Check    ${air}    ${copyfile}    1min_file
    布尔断言    ${flag}

main摄像机一般录影比特率-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    NORMAL    ${file}    5    main
    ${flag}    Check    ${air}    ${copyfile}    check_bitrate
    布尔断言    ${flag}

2nd摄像机一般录影比特率-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    NORMAL    ${file}    5    2nd
    ${flag}    Check    ${air}    ${copyfile}    check_bitrate
    布尔断言    ${flag}

main_2nd一般录影命名规则-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${flag}    Check    ${time}    ${file}    format_name
    布尔断言    ${flag}

main摄像机一般录影分辨率帧率-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    NORMAL    ${file}    5    main
    ${flag}    Check    ${air}    ${copyfile}    check_resolution_main
    布尔断言    ${flag}

2nd摄像机一般录影分辨率帧率-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    NORMAL    ${file}    5    2nd
    ${flag}    Check    ${air}    ${copyfile}    check_resolution_2nd
    布尔断言    ${flag}

main_2nd一般录影文件大小-mmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${copyfile}    文件拷贝到本地(EMMC)    NORMAL    ${file}    5    ${air}
    ${flag}    Check    ${air}    ${copyfile}    normal_file_size
    布尔断言    ${flag}

两台摄像机同时一般录影-emmc
    [Tags]    AUTO
    ${time}    获取设备系统时间
    ${file}    一般录影文件列表(EMMC)
    ${flag}    Check    ${time}    ${file}    record_simultaneous
    布尔断言    ${flag}

最大一般录影时覆盖-emmc
    [Tags]    AUTO
    ${filelist1}    获取所有文件列表    ${air}    emmc
    sleep    60
    ${filelist2}    获取所有文件列表    ${air}    emmc
    ${filelist}    合并列表    ${filelist1}    ${filelist2}
    ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal
    布尔断言    ${flag}

擦除所有文件-emmc
    [Tags]    AUTO
    log    初始化中已测试
