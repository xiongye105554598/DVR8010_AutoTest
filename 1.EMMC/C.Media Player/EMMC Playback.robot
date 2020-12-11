*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
进入播放目录
    [Tags]    AUTO
    菜单按钮
    sleep    1
    点击第二栏
    sleep    2
    ${value}    截图    EMMC_playback_2
    大小断言    ${value}    0.98

检查播放目录中的文件
    [Tags]    AUTO
    log    EMMC系统模块中已测试
