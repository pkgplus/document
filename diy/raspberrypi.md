+++
date = "2017-01-15T09:35:34+08:00"
title = "树莓派安装教程"
tags = ["diy", "raspberpi"]
categories = ["others"]
draft = true

+++

# raspberrypi
## 安装准备
* 树莓派3主板
* Micro USB线(安卓数据线)
* SD卡及SD卡读卡器
* 上网网线

## 制作系统安装盘
使用SD卡制作Raspberrpi系统安装盘
### 下载系统镜像
1. 下载最新[Raspbian系统镜像](http://downloads.raspberrypi.org/raspbian_latest)
2. 下载完成后解压
```sh
➜  download ls ./*raspbian*.img
./2017-01-11-raspbian-jessie.img
```

### 确认SD卡挂载的设备文件
插入SD卡，用df命令查看当前挂载的卷：
```sh
➜  download df -h
Filesystem      Size   Used  Avail Capacity iused      ifree %iused  Mounted on
/dev/disk1     112Gi   88Gi   23Gi    80% 1727257 4293240022    0%   /
devfs          185Ki  185Ki    0Bi   100%     640          0  100%   /dev
map -hosts       0Bi    0Bi    0Bi   100%       0          0  100%   /net
map auto_home    0Bi    0Bi    0Bi   100%       0          0  100%   /home
/dev/disk2s1   121Gi   36Gi   85Gi    30%  291384     698560   29%   /Volumes/Transcend
/dev/disk4s1    30Gi  105Mi   30Gi     1%        0          0  100%   /Volumes/SDXC
```
根据SD卡的`Size`和`Used`找到SD卡在系统中的设备文件(这里是/dev/disk4s1)
> SD卡多个分区时会有多个设备文件

### 卸载分区(设备文件)
使用`diskutil unmount`命令卸载上步找到的设备文件(我这里是`/dev/disk4s1`)
```sh
➜  download sudo diskutil unmount /dev/disk4s1
2
Volume SDXC on disk4s1 unmounted
➜  download 
➜  download sudo diskutil list
/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *32.0 GB    disk4
   1:             Windows_FAT_32 boot                    66.1 MB    disk4s1
➜  download 
➜  download 
```

使用`diskutil list`确认一下设备,找出SD卡对应的块设备(/dev/disk数字),此处是*/dev/disk4*
> /dev/disk4 是块设备，/dev/disk4s1 是分区

### 镜像写入
使用dd命令将系统镜像写入到SD卡中，此步骤需要好几分钟，不用着急，慢慢等...

```sh
➜  download sudo dd bs=4m if=2017-01-11-raspbian-jessie.img of=/dev/disk4
462+1 records in
462+1 records out
1939865600 bytes transferred in 163.133220 secs (11891297 bytes/sec)
➜  download 
```

### 卸载设备
```
➜  download diskutil unmountDisk  /dev/disk4
Unmount of all volumes on disk4 was successful
➜  download 
```

### 默认开启ssh
重新将SD卡插到电脑上，在移动设备boot中创建名字为`ssh`的文件
> 注意：此ssh文件没有后缀，文件名字就是ssh

## 系统安装
1. 将SD卡插到树莓派上；
2. 给树莓派插上网线；
3. 给树莓派插上电源(Micro USB线)，等待系统安装完成

> 等待几分钟后，等树莓派网口的灯亮了说明安装成功

## 配置树莓派
### ssh登陆
* 登陆树莓派所连接路由器，找到树莓派IP地址
* 默认用户名：pi，密码: raspberry
* 参考命令：`ssh pi@树莓派ip地址`

> 建议给树莓派配置固定静态IP

### apt配置及更新
#### 备份apt源配置文件
```sh
pi@raspberrypi:~ $ cp /etc/apt/sources /etc/apt/sources.list_bk
```
#### 配置apt源
[源地址列表](http://shumeipai.nxez.com/2013/08/31/raspbian-chinese-software-source.html)
/etc/apt/sources.list文件中内容
```
#deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
#deb-src http://archive.raspbian.org/raspbian/ jessie main contrib non-free rpi
deb http://mirrors.neusoft.edu.cn/raspbian/raspbian/ jessie main contrib non-free rpi
deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ jessie main contrib non-free rpi
```
#### 应用更新(此步骤比较慢可不做)
```
pi@raspberrypi:~ $ sudo apt-get update
```

### 树莓派配置
在SSH终端输入`sudo raspi-config`, 这里需要打开几个选项:

1. Expand Filesystem – 将根分区扩展到整张SD卡;
2. Change User Password – 默认的用户名是pi，密码是raspberry;
3. Internationalisation Options/Change Timezone – 更改时区, 选择Asia – Shanghai;
4. Internationalisation Options/Change Keyboard Layout, 选English（US）;
5. Internationalisation Options/Change Locale – 更改语言设置，选择en_US.UTF-8和zh_CN.UTF-8
6. 设置完成后，选择Finish，会提示是否重启，选择Yes

### 安装vnc(图形化工具)
#### 树莓派上安装
1. 安装命令：`sudo apt-get install tightvncserver`
2. 修改vnc密码命令: `vncpasswd`
3. 创建vnc-server配置文件:`sudo vi /etc/init.d/tightvncserver`，文件内容：

```
### BEGIN INIT INFO
# Provides:          tightvncserver
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop tightvncserver
### END INIT INFO

# More details see:
# http://www.penguintutor.com/linux/tightvnc

### Customize this entry
# Set the USER variable to the name of the user to start tightvncserver under
export USER='pi'
### End customization required

eval cd ~$USER

case "$1" in
  start)
    su $USER -c '/usr/bin/tightvncserver -depth 16 -geometry 800x600 :1'
    echo "Starting TightVNC server for $USER "
    ;;
  stop)
    su $USER -c '/usr/bin/tightvncserver -kill :1'
    echo "Tightvncserver stopped"
    ;;
  *)
    echo "Usage: /etc/init.d/tightvncserver {start|stop}"
    exit 1
    ;;
esac
exit 0
```

然后给增加执行权限，并启动服务：
```
sudo chmod +x /etc/init.d/tightvncserver
sudo service tightvncserver stop
sudo service tightvncserver start
```

将vnc服务设为开机启动：
```
systemctl enable tightvncserver
```

#### PC上安装vnc
[vnc官网下载](https://www.realvnc.com/download/vnc/)

#### VNC Viewer连接
PC打开VNC Viewer连接树莓派，地址栏输入`树莓派IP地址:1`

**然后就可以跟操作windows一样操作树莓派了!**