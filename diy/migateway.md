+++
date = "2017-01-15T23:53:21+08:00"
title = "小米网关局域网控制"
tags = ["diy"]
categories = ["others"]
draft = true

+++

# migateway
## API DOC
小米网关协议文档参考

[原版](https://github.com/louisZL/lumi-gateway-local-api) 

[修正格式版](https://github.com/xuebing1110/lumi-gateway-local-api)

## FEATURES
* 支持网关自动发现(whois)
* 支持设备自动发现(get_id_list,read)
* 支持设备状态自动更新(report/heartbeat)
* 支持网关彩灯控制，并支持颜色、闪烁等控制(write)

## TODO LIST
* 支持智能插座的控制
* 支持无线开关的控制
* 支持86开关的控制
* 支持场景自动化联动
* 服务运行树莓派3上[树莓派安装文档](http://blog.bingbaba.com/post/diy/raspberrypi/)

## EXAMPLE
控制小米网关的灯依次为红黄蓝绿青橙紫灰、红灯闪烁

```golang
package main

import (
    "github.com/xuebing1110/migateway"
    "time"
)

func main() {
    gwm, err := migateway.NewGateWayManager(nil)
    if err != nil {
        panic(err)
    }

    conn := gwm.GateWayConn
    conn.SetAESKey("t7ew6r4y612eml0f")

    for _, color := range migateway.COLOR_ALL {
        err = gwm.ChangeColor(conn, color)
        if err != nil {
            panic(err)
        }
        time.Sleep(time.Second)
    }

    err = gwm.Flashing(conn, migateway.COLOR_RED)
    if err != nil {
        panic(err)
    }

    //do something...
    time.Sleep(10 * time.Second)
}

```

## 持续更新中...