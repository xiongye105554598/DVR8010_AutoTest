# _*_ coding:utf-8 _*_
import os, subprocess, tkinter.messagebox, re, time, cv2
from PIL import Image
from moviepy.editor import VideoFileClip

def cmd(command):
    """执行cmd命令"""
    subprocess.Popen(str(command), shell=True, stdout=subprocess.PIPE).wait()

def cmd_popen(command):
    """执行cmd命令，并返回结果"""
    b = os.popen(command)
    return b.read()

def ResultCmd(command):
    """执行cmd命令，并等待返回结果"""
    if command == '':
        print('传入命令为空，请检查!')
        return
    else:
        p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, encoding='utf-8')
        p.wait()
        result = p.stdout.readlines()
        return result

def ResultCmdNoWait(command):
    """执行cmd命令，返回执行的结果"""
    if command == '':
        print('传入命令为空，请检查!')
        return
    else:
        p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, encoding='utf-8')
        result = p.stdout.readlines()
        return result

def Image_Compare_Similarity(image_name):
    """比较两张照片相似度"""
    image_new_path = os.getcwd() + '\Image_new\\' + image_name + '.png'     #新照片路径
    image_old_path = os.getcwd() + '\Image_old\\' + image_name + '.png'     #旧照片路径
    image1 = Image.open(image_new_path)  # 打开图片
    image2 = Image.open(image_old_path)
    gray_image1 = image1.resize((320, 240)).convert('RGB')  # 转换图片大小及RGB模式
    gray_image2 = image2.resize((320, 240)).convert('RGB')
    image_hg1 = gray_image1.histogram()  # 返回图像的直方图
    image_hg2 = gray_image2.histogram()
    assert len(image_hg1) == len(image_hg2)  # 断言
    hist = sum(1 - (0 if l == r else float(abs(l - r)) / max(l, r)) for l, r in zip(image_hg1, image_hg2)) / len(
        image_hg1)  # 直方图计算相似度
    return hist

def Pull_pic(image_name):
    """截取照片，并拷贝到本地目录"""
    pic_cmd = 'adb shell /system/bin/screencap -p /sdcard/screenshot.png'           #截取设备照片
    pull_cmd = 'adb pull /sdcard/screenshot.png ./Image_new/' + image_name + '.png'  #拷贝到本地目录
    cmd(pic_cmd)
    cmd(pull_cmd)
    print("截图保存路径:", './Image_new/' + image_name + '.png')

def Crop_pic(image_name, a, b, c, d):
    """按指定坐标裁剪照片"""
    img = Image.open(os.getcwd() + '\Image_new\\' + image_name + '.png')
    img2 = img.crop((int(a), int(b), int(c), int(d)))          #裁剪照片
    img2.save(os.getcwd() + '\Image_new\\' + image_name + '.png')

def Prompt_box(news):
    # tkinter.Tk().withdraw()
    """弹出提示框"""
    tkinter.messagebox.showinfo('提示', "  " + news + "  ")

def emmc_mode(mode):
    """切换SD卡模式或EMMC模式"""
    if mode == 'emmc':
        os.chdir(os.path.join(os.getcwd(), 'emmc_mode'))
        cmd('adb root')
        cmd('adb push factory.ini /mnt/vendor/persist')          #上传emmc模式配置文件
        os.chdir(os.path.dirname(os.getcwd()))
        cmd('adb reboot')
        print('设备切换成EMMC模式')

    elif mode == 'sd':
        print(os.getcwd())
        os.chdir(os.path.join(os.getcwd(), 'sd_mode'))
        cmd('adb root')
        cmd('adb push factory.ini /mnt/vendor/persist')          #上传sd卡模式配置文件
        os.chdir(os.path.dirname(os.getcwd()))
        cmd('adb reboot')
        print('设备切换成SD卡模式')
    else:
        print('mode输入错误，请检查')

def Update_time():
    """更新设备系统时间"""
    cmd('adb root')
    cmd('adb shell date %s set' % time.strftime("%m%d%H%M%Y.%S", time.localtime()))
    print("更新设备时间")

def Clear():
    '''删除file目录的文件，清理环境'''
    file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
    for file in os.listdir(file_path):
        if re.search('.mp4', file) or re.search('.jpg', file) or re.search('.txt', file) or re.search('.log', file):
            os.remove(os.path.join(file_path, file))
    print('环境清理完毕！')

def logcat():
    """抓取设备日志"""
    file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
    log_path = os.path.join(file_path, 'auto.log')
    log_cmd = 'start /b adb logcat >> %s' % log_path
    print('抓取log')
    os.system(log_cmd)

def Sdcard():
    """返回设备sd卡挂载的name"""
    sdcard = ''
    cmd_sd = 'adb shell "cd /storage && ls "'
    result = ResultCmd(cmd_sd)
    if result != '':
        for line in result:
            try:
                temp = line.strip().split()
                if temp == "emulated":
                    continue
                elif temp == "self":
                    continue
                else:
                    sdcard = temp
                    break
            except BaseException as a:
                print(a)
        if (sdcard == ''):
            print("未搜索到sd卡，准备退出")
            return sdcard
        else:
            print('SD卡挂载名称：', sdcard)
            return sdcard
    else:
        print("未搜索到sd卡，准备退出")
        return sdcard

# def Reverse(file):
#     """将目录文件倒序"""
#     file.reverse()
#     return file

def AllFiles(sd, flag):
    """获取normal/event/pic所有文件,当flag = emmc时，sd为空"""
    if flag == 'sdcard':
        normal_file = NormalFilesSD(sd)
        event_file = EventFilesSD(sd)
        picture_file = PictureFilesSD(sd)
    else:
        normal_file = NormalFilesEMMC()
        event_file = EventFilesEMMC()
        picture_file = PictureFilesEMMC()
    return [normal_file, event_file, picture_file]

def ConformList(*typelist):
    """把几个列表文件，整合为一个嵌套列表，如lista,listb,listc,输出zlist = [lista,listb,listc]"""
    result = list()
    for each in typelist:
        result.append(each)
    return result

def GetDeviceDate():
    """获取设备系统时间，返回日期年月日小时分秒，格式如20191213112910"""
    cmd = 'adb shell date'
    temp = ResultCmd(cmd)
    year = temp[0].split()[5]
    if temp[0].split()[1] == 'Jan':
        month = '01'
    elif temp[0].split()[1] == 'Feb':
        month = '02'
    elif temp[0].split()[1] == 'Mar':
        month = '03'
    elif temp[0].split()[1] == 'Apr':
        month = '04'
    elif temp[0].split()[1] == 'May':
        month = '05'
    elif temp[0].split()[1] == 'Jun':
        month = '06'
    elif temp[0].split()[1] == 'Jul':
        month = '07'
    elif temp[0].split()[1] == 'Aug':
        month = '08'
    elif temp[0].split()[1] == 'Sep':
        month = '09'
    elif temp[0].split()[1] == 'Oct':
        month = '10'
    elif temp[0].split()[1] == 'Nov':
        month = '11'
    elif temp[0].split()[1] == 'Dec':
        month = '12'
    day = temp[0].split()[2]
    if day == '1' or day == '2' or day == '3' or day == '4' or day == '5' or day == '6' or day == '7' or day == '8' or day == '9':
        day = '0' + temp[0].split()[2]
    time = ('').join(temp[0].split()[3].split(':'))
    new_time = str(year) + str(month) + str(day) + str(time)
    print('当前时间：%s' % new_time)
    return new_time

def NormalFilesSD(sdcard):
    """返回设备sdcard normal文件列表，返回文件列表"""
    list_normal = list()
    cmd = 'adb shell "cd /storage/%s && ls NORMAL/ -l|grep mp4"' % sdcard
    temp_list = ResultCmdNoWait(cmd)
    for line in temp_list:
        if re.match('.*.mp4', line):
            list_normal.append(line.split()[7].strip())
    if list_normal == []:
        print("Normal 文件为空")
    return list_normal

def NormalFilesEMMC():
    """返回设备emmc normal文件列表，返回文件列表"""
    list_normal = list()
    cmd = 'adb shell "cd /sdcard && ls NORMAL/ -l|grep mp4"'
    temp_list = ResultCmdNoWait(cmd)
    for line in temp_list:
        if re.match('.*.mp4', line):
            list_normal.append(line.split()[7].strip())
    if list_normal == []:
        print("Normal 文件为空")
    return list_normal

def EventFilesSD(sdcard):
    """返回设备sd event文件列表，返回文件列表"""
    list_event = list()
    cmd = 'adb shell "cd /storage/%s && ls EVENT/ -l|grep mp4"' % sdcard
    temp_list = ResultCmdNoWait(cmd)
    for line in temp_list:
        if re.match('.*.mp4', line):
            list_event.append(line.split()[7].strip())
    if list_event == []:
        print("Event文件为空")
    return list_event

def EventFilesEMMC():
    """返回设备emmc event文件列表，返回文件列表"""
    list_event = list()
    cmd = 'adb shell "cd /sdcard && ls EVENT/ -l|grep mp4"'
    temp_list = ResultCmdNoWait(cmd)
    for line in temp_list:
        if re.match('.*.mp4', line):
            list_event.append(line.split()[7].strip())
    if list_event == []:
        print("Event 文件为空")
    return list_event

def PictureFilesSD(sdcard):
    """返回设备sd PICTURE文件列表，返回文件列表"""
    list_picture = list()
    cmd = 'adb shell "cd /storage/%s && ls PICTURE/ -l|grep jpg"' % sdcard
    temp_list = ResultCmdNoWait(cmd)
    for line in temp_list:
        if re.match('.*.jpg', line):
            list_picture.append(line.split()[7].strip())
    if list_picture == []:
        print("Picture 文件为空")
    # print('Picture文件列表：', list_picture)
    return list_picture

def PictureFilesEMMC():
    """返回设备emmc PICTURE文件列表，返回文件列表"""
    list_picture = list()
    cmd = 'adb shell "cd /sdcard && ls PICTURE/ -l|grep jpg"'
    temp_list = ResultCmdNoWait(cmd)
    for line in temp_list:
        if re.match('.*.jpg', line):
            list_picture.append(line.split()[7].strip())
    if list_picture == []:
        print("Picture 文件为空")
    return list_picture

def CopyFileSD(sd, file_type, file, num, main_2nd):
    """
    拷贝设备sd卡指定文件到本地file目录
    参数为sdcard挂载名称，文件类型(NORMAL/EVENT/PICTURE)，文件，文件数量(多个文件，参数有效)，视频类型main_2nd为main或者2nd,默认空
    """
    copy_file = list()
    if sd == '' or file_type == '' or file == '':
        print('参数错误，请检查！')
        return False
    path = '/storage/%s/%s/' % (sd, file_type)
    file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
    if not os.path.exists(file_path):  # 判断路径是否存在
        os.mkdir(file_path)  # 创建目录
    if type(file) == str:
        cmd = 'adb pull ' + path + file + ' ' + file_path
        copy_over = 0
        result = ResultCmd(cmd)
        for line in result:
            if re.match('.*1\s+file\s+pulled.*', line):
                copy_over = 1
                break
            else:
                continue
        if copy_over == 1:
            print('当前文件拷贝完成', file)
            copy_file.append(file)
            return copy_file
        else:
            print('当前文件拷贝失败,请检查！')
            return ''
    elif type(file) == list:
        if main_2nd == '':
            if file_type == 'EVENT':
                for i in range(int(num)):
                    cmd = 'adb pull ' + path + file[-i - 1] + ' ' + file_path
                    result = ResultCmd(cmd)
                    time.sleep(2)  # 增加时间2s，避免拷贝失败
                    copy_over = 0
                    for line in result:
                        if re.match('.*1\s+file\s+pulled.*', line):
                            copy_over = 1
                            break
                        else:
                            continue
                    if copy_over == 1:
                        # print('文件%s拷贝完成' % file[-i - 1])
                        copy_file.append(file[-i - 1])
                    else:
                        print('文件拷贝失败,请检查！')
            else:
                for i in range(int(num)):
                    cmd = 'adb pull ' + path + file[-i - 3] + ' ' + file_path
                    result = ResultCmd(cmd)
                    time.sleep(2)  # 增加时间2s，避免拷贝失败
                    copy_over = 0
                    for line in result:
                        if re.match('.*1\s+file\s+pulled.*', line):
                            copy_over = 1
                            break
                        else:
                            continue
                    if copy_over == 1:
                        # print('文件%s拷贝完成' % file[-i-3])
                        copy_file.append(file[-i - 3])
                    else:
                        print('文件拷贝失败,请检查！')
        elif main_2nd == 'main':
            '''拷贝main camera文件'''
            for i in range(int(num)):
                for j in range(len(file)):
                    if re.match('\d\d\d\d\d\d\d\d\d\d\d\d.mp4', file[-j - 3]) or re.match(
                            '\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.mp4', file[-j - 3]) or \
                            re.match('\d\d\d\d\d\d\d\d\d\d\d\d.jpg', file[-j - 3]) or re.match(
                        '\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.jpg', file[-j - 3]):
                        break
                    else:
                        continue
                cmd = 'adb pull ' + path + file[-j - 3] + ' ' + file_path
                result = ResultCmd(cmd)
                time.sleep(2)  # 增加时间2s，避免拷贝失败
                copy_over = 0
                for line in result:
                    if re.match('.*1\s+file\s+pulled.*', line):
                        copy_over = 1
                        break
                    else:
                        continue
                if copy_over == 1:
                    # print('文件%s拷贝完成' % file[-j-3])
                    copy_file.append(file.pop(-j - 3))
                else:
                    print('当前文件拷贝失败,请检查！')
        elif main_2nd == '2nd':
            for i in range(int(num)):
                for j in range(len(file)):
                    if re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2.mp4', file[-j - 3]) or re.match(
                            '\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.mp4', file[-j - 3]) or \
                            re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2.jpg', file[-j - 3]) or re.match(
                        '\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.jpg', file[-j - 3]):
                        break
                    else:
                        continue
                cmd = 'adb pull ' + path + file[-j - 3] + ' ' + file_path
                result = ResultCmd(cmd)
                """增加时间2s，避免拷贝失败"""
                time.sleep(2)
                copy_over = 0
                for line in result:
                    if re.match('.*1\s+file\s+pulled.*', line):
                        copy_over = 1
                        break
                    else:
                        continue
                if copy_over == 1:
                    # print('文件%s拷贝完成' % file[-j-3])
                    copy_file.append(file.pop(-j - 3))
                else:
                    print('当前文件拷贝失败,请检查！')
        else:
            print('参数main_2nd错误:', main_2nd)
    if copy_file != '':
        print('文件拷贝完成列表：', copy_file)
        return copy_file
    else:
        return False

def CopyFileEMMC(file_type, file, num, main_2nd):
    """
    拷贝设备emmc指定文件到本地file目录
    文件类型(NORMAL/EVENT/PICTURE)，文件，数量(多个文件，参数有效),视频类型main_2nd为main或者2nd,默认空
    """
    copy_file = list()
    if file_type == '' or file == '':
        print('参数错误，请检查！')
        return False
    path = '/sdcard/%s/' % file_type
    file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
    if not os.path.exists(file_path):  # 判断路径是否存在
        os.mkdir(file_path)  # 创建目录
    if type(file) == str:
        cmd = 'adb pull ' + path + file + ' D:/temp/'
        copy_over = 0
        result = ResultCmd(cmd)
        for line in result:
            if re.match('.*1\s+file\s+pulled.*', line):
                copy_over = 1
                break
            else:
                continue
        if copy_over == 1:
            print('当前文件拷贝完成:', file)
            copy_file.append(file)
            return copy_file
        else:
            print('当前文件拷贝失败,请检查！')
            return ''
    elif type(file) == list:
        if main_2nd == '':
            if file_type == 'EVENT':
                for i in range(int(num)):
                    cmd = 'adb pull ' + path + file[-i - 1] + ' ' + file_path
                    result = ResultCmd(cmd)
                    time.sleep(2)  # 增加时间2s，避免拷贝失败
                    copy_over = 0
                    for line in result:
                        if re.match('.*1\s+file\s+pulled.*', line):
                            copy_over = 1
                            break
                        else:
                            continue
                    if copy_over == 1:
                        # print('文件%s拷贝完成' % file[-i - 1])
                        copy_file.append(file[-i - 1])
                    else:
                        print('文件拷贝失败,请检查！')
            else:
                for i in range(int(num)):
                    cmd = 'adb pull ' + path + file[-i - 3] + ' ' + file_path
                    result = ResultCmd(cmd)
                    time.sleep(2)  # 增加时间2s，避免拷贝失败
                    copy_over = 0
                    for line in result:
                        if re.match('.*1\s+file\s+pulled.*', line):
                            copy_over = 1
                            break
                        else:
                            continue
                    if copy_over == 1:
                        # print('文件%s拷贝完成' % file[-i-3])
                        copy_file.append(file[-i - 3])
                    else:
                        print('文件拷贝失败,请检查！')
        elif main_2nd == 'main':
            for i in range(int(num)):
                for j in range(len(file)):
                    if re.match('\d\d\d\d\d\d\d\d\d\d\d\d.mp4', file[-j - 3]) or re.match(
                            '\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.mp4', file[-j - 3]) or \
                            re.match('\d\d\d\d\d\d\d\d\d\d\d\d.jpg', file[-j - 3]) or re.match(
                        '\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.jpg', file[-j - 3]):
                        break
                    else:
                        continue
                cmd = 'adb pull ' + path + file[-j - 3] + ' ' + file_path
                result = ResultCmd(cmd)
                time.sleep(2)  # 增加时间2s，避免拷贝失败
                copy_over = 0
                for line in result:
                    if re.match('.*1\s+file\s+pulled.*', line):
                        copy_over = 1
                        break
                    else:
                        continue
                if copy_over == 1:
                    # print('文件%s拷贝完成' % file[-j-3])
                    copy_file.append(file.pop(-j - 3))
                else:
                    print('当前文件拷贝失败,请检查！')
        elif main_2nd == '2nd':
            for i in range(int(num)):
                for j in range(len(file)):
                    if re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2.mp4', file[-j - 3]) or re.match(
                            '\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.mp4', file[-j - 3]) or \
                            re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2.jpg', file[-j - 3]) or re.match(
                        '\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.jpg', file[-j - 3]):
                        break
                    else:
                        continue
                cmd = 'adb pull ' + path + file[-j - 3] + ' ' + file_path
                result = ResultCmd(cmd)
                """增加时间2s，避免拷贝失败"""
                time.sleep(2)
                copy_over = 0
                for line in result:
                    if re.match('.*1\s+file\s+pulled.*', line):
                        copy_over = 1
                        break
                    else:
                        continue
                if copy_over == 1:
                    # print('文件%s拷贝完成' % file[-j-3])
                    copy_file.append(file.pop(-j - 3))
                else:
                    print('当前文件拷贝失败,请检查！')
            else:

                print('参数main_2nd错误:', main_2nd)
            if copy_file != '':
                print('文件拷贝完成列表：', copy_file)
                return copy_file
            else:
                return False
    if copy_file != '':
        print('文件拷贝完成列表：', copy_file)
        return copy_file
    else:
        return False

def Check(time, file, flag):
    """断言方法,通过对比返回True或False用于RF断言，传入参数为系统时间time，文件file,flag类型为断言类型"""
    if file == [] or flag == '':
        return False

    elif flag == 'format_name':                         #检查设备录制视频和照片命令规则和格式
        name_y = time[2:6]
        name_main = '\d\d\d\d\d\d\d\d\d\d\d\d.mp4'
        name_2nd = '\d\d\d\d\d\d\d\d\d\d\d\d_2.mp4'
        name_main_2 = '\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.mp4'
        name_2nd_2 = '\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.mp4'
        name_main_3 = '\d\d\d\d\d\d\d\d\d\d\d\d.jpg'
        name_2nd_3 = '\d\d\d\d\d\d\d\d\d\d\d\d_2.jpg'
        name_main_4 = '\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.jpg'
        name_2nd_4 = '\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.jpg'
        is_format = True
        for each in file:
            if re.match(name_y, each) and re.match(name_main, each):
                continue
            elif re.match(name_y, each) and re.match(name_2nd, each):
                continue
            elif re.match(name_y, each) and re.match(name_main_2, each):
                continue
            elif re.match(name_y, each) and re.match(name_2nd_2, each):
                continue
            elif re.match(name_y, each) and re.match(name_main_3, each):
                continue
            elif re.match(name_y, each) and re.match(name_2nd_3, each):
                continue
            elif re.match(name_y, each) and re.match(name_main_4, each):
                continue
            elif re.match(name_y, each) and re.match(name_2nd_4, each):
                continue
            else:
                is_format = False
                break
        if is_format == True:
            print('命名规则符合要求')
            return True
        else:
            return False

    elif flag == 'check_file':                   #检查设备录制视频名称是否符合设备系统时间
        name_f = time[2:12]
        name_f2 = str(int(time[2:12]) - 1)
        name_f_u = time[2:8]
        uname = 'UNKNOWN'
        is_file = False
        for each in file:
            if re.match(name_f, each) or re.match(name_f2, each):
                is_file = True
                break
            elif re.match(name_f_u, each) and re.search(uname, each):
                is_file = True
                break
            else:
                continue
        if is_file == True:
            print('文件时间符合要求')
            return True
        else:
            return False

    elif flag == 'record_simultaneous':           #检查设备前后摄像头录制文件名称是否同步
        main_list = list()
        snd_list = list()
        count = 0
        for each in file:
            if re.match('\d\d\d\d\d\d\d\d\d\d\d\d.mp4', each) or re.match('\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.mp4', each):
                main_list.append(each)
            elif re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2.mp4', each) or re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.mp4',
                                                                              each):
                snd_list.append(each)
            elif re.match('\d\d\d\d\d\d\d\d\d\d\d\d.jpg', each) or re.match('\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.jpg',
                                                                            each):
                main_list.append(each)
            elif re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2.jpg', each) or re.match('\d\d\d\d\d\d\d\d\d\d\d\d_2_UNKNOWN.jpg',
                                                                              each):
                snd_list.append(each)
            else:
                print("视频格式不正确，请检查！")

        for m in main_list:
            flag = 0
            for s in snd_list:
                if re.search('UNKNOWN', m) and re.match(m.split('_')[0], s):
                    flag = 1
                    break
                elif re.match(m.split('.')[0], s):
                    flag = 1
                    break
                else:
                    continue
            if flag == 0:
                count += 1
        ratio = count / len(main_list) * 100
        if ratio > 5:
            print('命名不同步的比例为：%.1f%%,大于5%%，不符合要求' % ratio)
            return False
        else:
            print('命名不同步的比例为：%.1f%%,小于5%%，符合要求' % ratio)
            return True

    elif flag == 'normal_file_size':      #检查normal目录视频文件大小
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            file_byte = os.path.getsize(mp4_path)
            file_M = int(file_byte / 1024 / 1024)
            if 42 <= file_M <= 57:
                print("当前录影 %s 大小满足45M：%sM" % (each, file_M))
                os.remove(mp4_path)
            elif file_M > 100:
                print("当前录影 %s 大于100M：%sM" % (each, file_M))
                flag += 1
            elif file_M == 0:
                print("当前录影 %s 为0M：%sM" % (each, file_M))
                flag += 1
            else:
                print("当前录影 %s 大小不满足45M：%sM" % (each, file_M))
                flag += 1

        if flag == 0:
            print("一般录影大小满足45M要求！")
            return True
        else:
            print("一般录影大小不满足45M要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'event_file_size':           #检查event目录视频文件大小
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            file_byte = os.path.getsize(mp4_path)
            file_M = int(file_byte / 1024 / 1024)
            if 10 <= file_M <= 22:
                print("当前录影 %s 大小满足12M：%sM" % (each, file_M))
                os.remove(mp4_path)
            else:
                print("当前录影 %s 大小不满足12M：%sM" % (each, file_M))
                flag += 1
        if flag == 0:
            print("一般录影大小满足45M要求！")
            return True
        else:
            print("一般录影大小不满足45M要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'picture_file_size':              #检查picture目录文件大小
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            file_byte = os.path.getsize(mp4_path)
            file_M = int(file_byte / 1024)
            if 100 <= file_M <= 200:
                print("当前照片 %s 大小满足100-200KB：%sKB" % (each, file_M))
                os.remove(mp4_path)
            else:
                print("当前照片 %s 大小满足100-200KB：%sKB" % (each, file_M))
                flag += 1
        if flag == 0:
            print("照片大小满足100-200KB要求！")
            return True
        else:
            print("照片大小不满足100-200KB要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == '1min_file':                #检查设备录制的normal视频是否为1min
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            clip = VideoFileClip(mp4_path)
            time = int(clip.duration)  # 时长
            if float(time) >= 59 and float(time) <= 61:  # 大于59s，小于61s，判定为文件长度正常
                print("当前录影%s时长满足1min：%ss" % (each, time))
            else:
                print("当前录影%s时长不满足1min：%ss" % (each, time))
                flag += 1
        if flag == 0:
            print("一般录影时长满足1min要求！")
            return True
        else:
            print("一般录影时长不满足1min要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == '10s_file':                 #检查设备录制的event视频是否为10s
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            clip = VideoFileClip(mp4_path)
            time = int(clip.duration)  # 时长
            if 9 <= float(time) <= 11:  # 大于14s，小于16s，判定为文件长度正常
                print("当前事件录影%s时长满足10s：%ss" % (each, time))
            else:
                print("当前事件%s时长不满足10s：%ss" % (each, time))
                flag += 1
        if flag == 0:
            print("事件录影时长满足10s要求！")
            return True
        else:
            print("事件录影时长不满足10s要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == '15s_file':                    #检查设备录制的event视频是否为15s
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            clip = VideoFileClip(mp4_path)
            time = int(clip.duration)  # 时长
            if 14 <= float(time) <= 16:  # 大于14s，小于16s，判定为文件长度正常
                print("当前录影%s时长满足15s：%ss" % (each, time))
            else:
                print("当前录影%s时长不满足15s：%ss" % (each, time))
                flag += 1
        if flag == 0:
            print("事件录影时长满足15s要求！")
            return True
        else:
            print("事件录影时长不满足15s要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == '20s_file':                      #检查设备录制的event视频是否为20s
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            clip = VideoFileClip(mp4_path)
            time = int(clip.duration)  # 时长
            if 19 <= float(time) <= 21:
                print("当前录影%s时长满足20s：%ss" % (each, time))
            else:
                print("当前录影%s时长不满足20s：%ss" % (each, time))
                flag += 1
        if flag == 0:
            print("事件录影时长满足20s要求！")
            return True
        else:
            print("事件录影时长不满足20s要求,不满足个数：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'check_resolution_main':           #检查设备录制main摄像头视频的分辨率和帧率
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            cap = cv2.VideoCapture(mp4_path)
            width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))  # 分辨率-宽度
            height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))  # 分辨率-高度
            fps = int(round(cap.get(cv2.CAP_PROP_FPS)))  # 帧率
            if width == 1920 and height == 1080 and 26 <= fps <= 28:  # fps大于26s，小于28s，判定为正常fps 27
                print("当前main文件 %s 分辨率为：%dx%d,帧率为：%d,符合要求" % (each, width, height, fps))
            else:
                print("当前main文件 %s 分辨率为：%dx%d,帧率为：%d,不符合要求" % (each, width, height, fps))
                flag += 1
        if flag == 0:
            print("main文件满足1920x1080 & 27fps,检查完毕！")
            return True
        else:
            print("main文件不满足1920x1080 & 27fps,不符合要求数量：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'check_resolution_2nd':            #检查设备录制2nd摄像头视频的分辨率和帧率
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            cap = cv2.VideoCapture(mp4_path)
            width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))  # 分辨率-宽度
            height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))  # 分辨率-高度
            fps = int(round(cap.get(cv2.CAP_PROP_FPS)))  # 帧率
            if width == 1920 and height == 1080 and 14 <= fps <= 16:  # fps大于26s，小于28s，判定为正常fps 27
                print("当前2nd文件 %s 分辨率为：%dx%d,帧率为：%d,符合要求" % (each, width, height, fps))
            else:
                print("当前2nd文件 %s 分辨率为：%dx%d,帧率为：%d,不符合要求" % (each, width, height, fps))
                flag += 1
        if flag == 0:
            print("2nd文件满足1920x1080 & 15fps,检查完毕！")
            return True
        else:
            print("2nd文件不满足1920x1080 & 15fps,不符合要求数量：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'check_pic_resolution':
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            cap = cv2.VideoCapture(mp4_path)
            width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))  # 分辨率-宽度
            height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))  # 分辨率-高度
            if width == 1920 and height == 1080:
                print("当前照片文件 %s 分辨率为：%dx%d，符合要求" % (each, width, height))
            else:
                print("当前照片文件 %s 分辨率为：%dx%d,不符合要求" % (each, width, height))
                flag += 1
        if flag == 0:
            print("图片文件满足1920x1080,检查完毕！")
            return True
        else:
            print("图片文件不满足1920x1080,不符合要求数量：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'check_bitrate':              #检查设备录制视频的比特率
        flag = 0
        file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'file')
        video_info_path = os.path.join(file_path, 'video_info.txt')
        for each in file:
            mp4_path = os.path.join(file_path, each)
            cmd1 = 'ffmpeg -i ' + mp4_path + ' output 2> ' + video_info_path
            cmd(cmd1)
            bitrate = 0
            audio = 0
            f = open(video_info_path, 'r', encoding='ISO-8859-1')
            result = f.readlines()
            f.close()
            os.remove(video_info_path)
            for line in result:
                if re.search('Duration:.*, bitrate: (\d+) kb/s', line):
                    temp = float(re.search('Duration:.*, bitrate: (\d+) kb/s', line).group(1))
                    bitrate = float(temp / 1000)
                    break
            if re.match('\d\d\d\d\d\d\d\d\d\d\d\d.mp4', each) or re.match('\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.mp4', each):
                for line in result:
                    if re.search('Stream.*, fltp, (\d+) kb/s', line):
                        audio = int(re.search('Stream.*, fltp, (\d+) kb/s', line).group(1))
                        break
            if 6 <= bitrate <= 7:  # 判断比特率
                print("当前文件 %s 满足6Mbps比特率：%s" % (each, bitrate))
            else:
                print("当前文件 %s 不满足6Mbps比特率：%s" % (each, bitrate))
                flag += 1
            if re.match('\d\d\d\d\d\d\d\d\d\d\d\d.mp4', each) or re.match('\d\d\d\d\d\d\d\d\d\d\d\d_UNKNOWN.mp4', each):
                if 127 <= audio <= 129:
                    print("当前文件 %s 满足128kbps音频比特率：%s" % (each, audio))
                else:
                    print("当前文件 %s 不满足128kbps音频比特率：%s" % (each, audio))
                    flag += 1
        if flag == 0:
            print("文件满足比特率,检查完毕！")
            return True
        else:
            print("文件不满足比特率,不符合要求：" + str(flag) + "/" + str(len(file)))
            return False

    elif flag == 'check_overwrite_normal':         #检查设备录制的normal视频被覆写情况
        filelist_old = file[0]
        filelist_new = file[1]
        if len(filelist_old) != len(filelist_new):
            print('文件不满足覆写条件，请检查！')
            return False
        else:
            '''比较normal文件'''
            normal_old = filelist_old[0]
            normal_new = filelist_new[0]
            for i in range(len(normal_old)):
                flag = 0
                for j in normal_new:
                    if normal_old[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    if i == 0 or i == 1:
                        print('第%s个文件不存在，已覆写:' % i, normal_old[i])
                    else:
                        print('中间文件被覆写，覆写异常！请检查！')
                        return False
            for i in range(len(normal_new)):
                flag = 0
                for j in normal_old:
                    if normal_new[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    if i == len(normal_new) - 1 or i == len(normal_new) - 2:
                        print('第%s个文件不存在，已新增:' % i, normal_new[i])
                    else:
                        print('中间文件被覆写，新增异常！请检查！')
                        return False
            print('Normal文件overwrite检查完成，正常覆写！')
            return True

    elif flag == 'check_overwrite_normal_no':            #检查设备录制的normal视频未被覆写情况
        filelist_old = file[0]
        filelist_new = file[1]
        if len(filelist_old) != len(filelist_new):
            print('新旧一般录影文件数量不相同，请检查！')
            return False
        else:
            '''比较normal文件'''
            normal_old = filelist_old[0]
            normal_new = filelist_new[0]
            for i in range(len(normal_old)):
                flag = 0
                for j in normal_new:
                    if normal_old[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    print('一般录影文件被覆写！')
                    return False
            print('一般录影文件未被覆写！')
            return True

    elif flag == 'check_overwrite_event':                #检查设备录制的event视频被覆写情况
        filelist_old = file[0]
        filelist_new = file[1]
        if len(filelist_old) != len(filelist_new):
            print('文件不满足overwrite条件，请检查！')
            return False
        else:
            '''比较event文件'''
            event_old = filelist_old[1]
            event_new = filelist_new[1]
            for i in range(len(event_old)):
                flag = 0
                for j in event_new:
                    if event_old[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    if i == 0 or i == 1:
                        print('第%s个文件不存在，已覆写:' % i, event_old[i])
                    else:
                        print('中间文件被覆写，覆写异常！请检查！')
                        return False
            for i in range(len(event_new)):
                flag = 0
                for j in event_old:
                    if event_new[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    if i == len(event_new) - 1 or i == len(event_new) - 2:
                        print('第%s个文件不存在，已新增:' % i, event_new[i])
                    else:
                        print('中间文件被覆写，新增异常！请检查！')
                        return False
            print('Event文件overwrite检查完成，正常覆写！')
            return True

    elif flag == 'check_overwrite_picture':       #检查设备录制的照片被覆写情况
        filelist_old = file[0]
        filelist_new = file[1]
        if len(filelist_old) != len(filelist_new):
            print('文件不满足overwrite条件，请检查！')
            return False
        else:
            '''比较picture文件'''
            picture_old = filelist_old[2]
            picture_new = filelist_new[2]
            print(picture_old)
            print(picture_new)
            print(len(picture_old))
            for i in range(len(picture_old)):
                flag = 0
                for j in picture_new:
                    if picture_old[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    if i == 0 or i == 1 or i == 2 or i == 3 or i == 4 or i == 5 or i == 6 or i == 7:
                        print('第%s个文件不存在，已覆写:' % i, picture_old[i])
                    else:
                        print('中间文件被覆写，覆写异常！请检查！')
                        return False
            for i in range(len(picture_new)):
                flag = 0
                for j in picture_old:
                    if picture_new[i] == j:
                        flag = 1
                        break
                    else:
                        continue
                if flag == 1:
                    pass
                else:
                    if i == len(picture_new) - 1 or i == len(picture_new) - 2 or i == len(picture_new) - 3 or i == len(
                            picture_new) - 4 or \
                            i == len(picture_new) - 5 or i == len(picture_new) - 6 or i == len(
                        picture_new) - 7 or i == len(picture_new) - 8:
                        print('第%s个文件不存在，已新增:' % i, picture_new[i])
                    else:
                        print('中间文件被覆写，新增异常！请检查！')
                        return False
            print('picture文件overwrite检查完成，正常覆写！')
            return True

    elif re.match('check_event_', flag):           #检查设备录制的event视频与照片数量是否对应
        if re.search('check_event_(\d)', flag):
            e_p = int(re.search('check_event_(\d\d)', flag).group(1))
        else:
            print('参数输入错误,请检查！')
        filelist_old = file[0]
        filelist_new = file[1]
        event_old = filelist_old[1]  # 比较文件
        event_new = filelist_new[1]
        picture_old = filelist_old[2]
        picture_new = filelist_new[2]
        for i in range(len(event_new)):
            flag = 0
            for j in event_old:
                if event_new[i] == j:
                    flag = 1
                    break
                else:
                    continue
            if flag == 1:
                pass
            else:
                if i == len(event_new) - 1 or i == len(event_new) - 2:
                    print('第%s个event已新增:' % i, event_new[i])
                else:
                    print('中间event文件被覆写，新增异常！请检查！')
                    return False
        pic_num = 0
        for i in range(len(picture_new)):
            flag = 0
            for j in picture_old:
                if picture_new[i] == j:
                    flag = 1
                    break
                else:
                    continue
            if flag == 1:
                pass
            else:
                if i == len(picture_new) - 1 or i == len(picture_new) - 2 or i == len(picture_new) - 3 or i == len(
                        picture_new) - 4 or i == len(picture_new) - 5 or i == len(picture_new) - 6 or i == len(
                        picture_new) - 7 or i == len(picture_new) - 8 or len(picture_new) - 9 or i == len(
                    picture_new) - 10 or len(picture_new) - 11 or i == len(picture_new) - 12:
                    print('第%s个picture已新增:' % i, picture_new[i])
                    pic_num += 1
                else:
                    print('中间picture文件被覆写，新增异常！请检查！')
                    return False
        if pic_num == e_p:
            print('Event与照片数量符合要求，1个event对应%d张照片' % pic_num)
            return True
        else:
            print('Event与照片数量不符合要求，1个event对应%d张照片' % pic_num)
            return False

    elif flag == 'check_2_event':          #检查设备连续产生2个event视频覆写情况
        filelist_old = file[0]
        filelist_new = file[1]
        event_old = filelist_old[1]  # 比较文件
        event_new = filelist_new[1]
        n = 0
        for i in range(len(event_new)):
            flag = 0
            for j in event_old:
                if event_new[i] == j:
                    flag = 1
                    break
                else:
                    continue
            if flag == 1:
                pass
            else:
                if i == len(event_new) - 1 or i == len(event_new) - 2 or i == len(event_new) - 3 or i == len(
                        event_new) - 4:
                    print('第%s个event已新增:' % i, event_new[i])
                    n += 1
                else:
                    print('中间event文件被覆写，新增异常！请检查！')
                    return False
        if n == 4:
            print('新增Event数量:%d个,满足要求' % n)
            return True
        else:
            print('新增Event数量:%d个,不满足要求' % n)
            return False

    elif flag == 'check_3_event':                      #检查设备连续产生3个event视频覆写情况
        filelist_old = file[0]
        filelist_new = file[1]
        event_old = filelist_old[1]  # 比较文件
        event_new = filelist_new[1]
        n = 0
        for i in range(len(event_new)):
            flag = 0
            for j in event_old:
                if event_new[i] == j:
                    flag = 1
                    break
                else:
                    continue
            if flag == 1:
                pass
            else:
                if i == len(event_new) - 1 or i == len(event_new) - 2 or i == len(event_new) - 3 or i == len(
                        event_new) - 4 or i == len(event_new) - 5 or i == len(event_new) - 6:
                    print('第%s个event已新增:' % i, event_new[i])
                    n += 1
                else:
                    print('中间event文件被覆写，新增异常！请检查！')
                    return False
        if n == 6:
            print('新增Event数量:%d个,满足要求' % n)
            return True
        else:
            print('新增Event数量:%d个,不满足要求' % n)
            return False

    elif flag == 'log':            #检查设备内是否产生log文件
        b = cmd_popen('adb shell find /sdcard/_log/system')
        if b in 'NO':
            return False
        else:
            return True

    else:
        return False