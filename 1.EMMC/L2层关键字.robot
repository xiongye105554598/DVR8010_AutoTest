*** Settings ***
Resource          ../L3公共层.robot

*** Keywords ***
一般录影文件列表(EMMC)
    ${file}    Normal Files EMMC
    [Return]    ${file}

事件录影文件列表(EMMC)
    ${file}    Event Files EMMC
    [Return]    ${file}

照片文件列表(EMMC)
    ${file}    Picture Files EMMC
    [Return]    ${file}

文件拷贝到本地(EMMC)
    [Arguments]    ${file_type}    ${file}    ${num}    ${main_2nd}
    ${copyfile}    Copy File EMMC    ${file_type}    ${file}    ${num}    ${main_2nd}
    [Return]    ${copyfile}
