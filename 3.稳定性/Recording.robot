*** Settings ***
Resource          ../L3公共层.robot

*** Test Cases ***
50次重复启动正常录影
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    FOR    ${i}    IN RANGE    1    int(51)
        log    重启次数：${i}/50
        ${filelist1}    获取所有文件列表    ${sd}    sdcard
        Cmd    adb reboot
        sleep    80
        ${filelist2}    获取所有文件列表    ${sd}    sdcard
        ${filelist}    合并列表    ${filelist1}    ${filelist2}
        ${flag}    Check    ${air}    ${filelist}    check_overwrite_normal
        布尔断言    ${flag}
    END

500次切换main和2nd摄像头预览
    [Tags]    AUTO
    抓log
    返回录制页面
    FOR    ${i}    IN RANGE    1    int(501)
        log    切换次数：${i}/500
        Cmd    adb shell input swipe 270 140 40 140
        Cmd    adb shell input swipe 40 140 270 140
    END

12H一般录影是否有0kb和大文件
    [Tags]    AUTO
    ${sd}    SD卡挂载名称
    FOR    ${i}    IN RANGE    1    int(721)
        sleep    60
        log    文件数：${i}/720
        ${file}    一般录影文件列表(SDcard)    ${sd}
        ${copyfile}    文件拷贝到本地(SDcard)    ${sd}    NORMAL    ${file}    2    ${air}
        ${flag}    Check    ${air}    ${copyfile}    normal_file_size
        布尔断言    ${flag}
    END
    Cmd    adb reboot
