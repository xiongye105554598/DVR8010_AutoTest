*** Settings ***
Resource          ../L2层关键字.robot

*** Test Cases ***
检查播放目录中的文件
    [Tags]    AUTO
    菜单按钮
    返回录制页面
    菜单按钮
    点击第二栏
    点击第一栏
    sleep    1
    ${value}    截图    EMMC_playback_1
    大小断言    ${value}    0.95

SD卡容量按钮状态
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第三栏
    点击第一栏
    ${value}    截图    EMMC_SDcard_storage
    大小断言    ${value}    0.90

格式化SD卡按钮状态
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第三栏
    ${value}    截图    EMMC_FormatSDcard
    大小断言    ${value}    0.97
