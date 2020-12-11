*** Settings ***
Resource          ../../L2层关键字.robot

*** Test Cases ***
SD卡容量显示
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第三栏
    点击第一栏
    ${value}    截图    SDcard_storage
    大小断言    ${value}    0.90

格式化记忆卡-取消
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第三栏
    点击第二栏
    Cmd    adb shell input tap 85 185
    ${value}    截图    FormatSDcard_Cancel
    大小断言    ${value}    0.98

格式化记忆卡-格式化
    [Tags]    AUTO
    返回录制页面
    菜单按钮
    点击第三栏
    点击第三栏
    点击第二栏
    Cmd    adb shell input tap 230 185
    sleep    80
    截图    FormatSDcard
    Cmd    adb shell input tap 160 190
    裁剪图片    FormatSDcard    20    25    280    215
    ${value1}    获取图片相似度    FormatSDcard
    返回按钮
    返回按钮
    点击第二栏
    sleep    3
    ${value2}    截图    Playlist
    大小断言    ${value1}    0.97
    大小断言    ${value2}    0.97
