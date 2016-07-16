+++
date = "2016-07-16T18:52:34+08:00"
title = "北京实时公交爬虫"
tags = ["diy"]
categories = ["others"]
draft = true

+++

# 1.公交线路
## 1.1 获取cookie
从首页获取cookie: http://www.bjbus.com/home/index.php

# 2.公交方向
## 请求URL
```bash
curl 'http://www.bjbus.com/home/ajax_search_bus_stop_token.php?act=getLineDirOption&selBLine=675' -H 'Cookie: PHPSESSID=1cd1e41e9493df06c0b97b48deb7de92; SERVERID=c40443f9636cc324fbdb5c25c09256b6|1468631025|1468623690'  -H 'X-Requested-With: XMLHttpRequest'
```
## 响应结果
```html
<option value="">请选择行车方向</option><option value="5070699917922499506">675(左家庄-通州李庄)</option><option value="5764185530132571880">675(通州李庄-左家庄)</option>
```

## 截取正则
```
<option value=['"]?(\d+)['"]?>\d+\((\S+?)\)<\/option>
```

# 3.公交站列表
## 请求URL
```bash
curl 'http://www.bjbus.com/home/ajax_search_bus_stop_token.php?act=getDirStationOption&selBLine=675&selBDir=5764185530132571880' -H 'Cookie: PHPSESSID=1cd1e41e9493df06c0b97b48deb7de92; Hm_lpvt_2c630339360dacc1fc1fd8110f283748=1468630563; SERVERID=c40443f9636cc324fbdb5c25c09256b6|1468631049|1468623690' -H 'X-Requested-With: XMLHttpRequest'
```

## 响应
```html
<option value="">请选择上车站</option><option value="1">通州李庄</option><option value="2">通州李庄南</option><option value="3">上潞园小区</option><option value="4">潞邑西路</option><option value="5">小潞邑北站</option><option value="6">小潞邑</option><option value="7">耿庄桥北</option><option value="8">结研所</option><option value="9">北京物资学院南站</option><option value="10">天赐良园</option><option value="11">北京物资学院</option><option value="12">邓家窑</option><option value="13">地铁草房站东</option><option value="14">地铁草房站</option><option value="15">东十里堡村</option><option value="16">高安屯路南口</option><option value="17">地铁常营站</option><option value="18">常营路口东</option><option value="19">常营路口西</option><option value="20">黄渠村</option><option value="21">地铁褡裢坡站</option><option value="22">白家楼桥东</option><option value="23">亮马厂</option><option value="24">黄杉木店</option><option value="25">青年路口</option><option value="26">十里堡北里</option><option value="27">农民日报社</option><option value="28">农民日报社北</option><option value="29">石佛营东里</option><option value="30">豆各庄路口南</option><option value="31">豆各庄路口西</option><option value="32">朝阳公园桥东</option><option value="33">朝阳公园南门</option><option value="34">甜水园街北口</option><option value="35">团结湖</option><option value="36">亮马桥</option><option value="37">燕莎桥南</option><option value="38">燕莎桥西</option><option value="39">新源南路西口</option><option value="40">新源里</option><option value="41">左家庄</option>
```

# 4.实时状态

## 请求
```bash
curl 'http://www.bjbus.com/home/ajax_search_bus_stop_token.php?act=busTime&selBLine=675&selBDir=5764185530132571880&selBStop=27' -H 'Cookie: PHPSESSID=1cd1e41e9493df06c0b97b48deb7de92; =b6e721ca8fa8f1065ade14ce5cd80b3a|1468681127|1468680903' -H 'X-Requested-With: XMLHttpRequest' 
```

## 响应
具体html见下
```javascript
{"html":"...","w":1964,"seq":"27"}
```


## 正则

截取字段分别为：
* 公交站ID
* 公交站状态(途中/到站): buss表示`途中`,即`即将到站`;busc表示到站
* 公交站名

```
(?:s)<div id="(\d+)">(?:<i class="(\w+)" clstag="[^"]"></i>)?.+?<span title="[^"]+">([^<]+)</span></div>
```

###转换具体内容
```html
<div class="inquiry_header">
  <div class="left fixed">
    <h3 id="lh">675路</h3></div>
  <div class="inner">
    <h2 id="lm">通州李庄-左家庄</h2>
    <article>
      <p>农民日报社 4:50-22:00 分段计价 所属客二分公司</p>
      <p>最近一辆车距离此还有 3 站，
        <span>0</span>米，预计到站时间
        <span>0</span>秒</p></article>
  </div>
</div>
<div id="cc_stop" class="inquiry_main" unselectable="on" onselectstart="return false;">
  <ul class="fixed">
    <li>
      <div id="1">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="通州李庄">通州李庄</span></div>
    </li>
    <li>
      <div id="2m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="2">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="通州李庄南">通州李庄南</span></div>
    </li>
    <li>
      <div id="3m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="3">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="上潞园小区">上潞园小区</span></div>
    </li>
    <li>
      <div id="4m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="4">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="潞邑西路">潞邑西路</span></div>
    </li>
    <li>
      <div id="5m">
        <i class="busc" clstag="13342"></i>
      </div>
    </li>
    <li>
      <div id="5">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="小潞邑北站">小潞邑北站</span></div>
    </li>
    <li>
      <div id="6m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="6">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="小潞邑">小潞邑</span></div>
    </li>
    <li>
      <div id="7m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="7">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="耿庄桥北">耿庄桥北</span></div>
    </li>
    <li>
      <div id="8m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="8">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="结研所">结研所</span></div>
    </li>
    <li>
      <div id="9m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="9">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="北京物资学院南站">北京物资学院
          <br/>...</span></div>
    </li>
    <li>
      <div id="10m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="10">
        <i class="buss" clstag="-1"></i>
        <p class="sicon"></p>
        <span title="天赐良园">天赐良园</span></div>
    </li>
    <li>
      <div id="11m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="11">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="北京物资学院">北京物资学院</span></div>
    </li>
    <li>
      <div id="12m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="12">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="邓家窑">邓家窑</span></div>
    </li>
    <li>
      <div id="13m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="13">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="地铁草房站东">地铁草房站东</span></div>
    </li>
    <li>
      <div id="14m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="14">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="地铁草房站">地铁草房站</span></div>
    </li>
    <li>
      <div id="15m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="15">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="东十里堡村">东十里堡村</span></div>
    </li>
    <li>
      <div id="16m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="16">
        <i class="buss" clstag="-1"></i>
        <p class="sicon"></p>
        <span title="高安屯路南口">高安屯路南口</span></div>
    </li>
    <li>
      <div id="17m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="17">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="地铁常营站">地铁常营站</span></div>
    </li>
    <li>
      <div id="18m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="18">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="常营路口东">常营路口东</span></div>
    </li>
    <li>
      <div id="19m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="19">
        <i class="buss" clstag="-1"></i>
        <p class="sicon"></p>
        <span title="常营路口西">常营路口西</span></div>
    </li>
    <li>
      <div id="20m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="20">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="黄渠村">黄渠村</span></div>
    </li>
    <li>
      <div id="21m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="21">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="地铁褡裢坡站">地铁褡裢坡站</span></div>
    </li>
    <li>
      <div id="22m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="22">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="白家楼桥东">白家楼桥东</span></div>
    </li>
    <li>
      <div id="23m">
        <i class="busc" clstag="1743"></i>
      </div>
    </li>
    <li>
      <div id="23">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="亮马厂">亮马厂</span></div>
    </li>
    <li>
      <div id="24m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="24">
        <i class="buss" clstag="-1"></i>
        <p class="sicon"></p>
        <span title="黄杉木店">黄杉木店</span></div>
    </li>
    <li>
      <div id="25m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="25">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="青年路口">青年路口</span></div>
    </li>
    <li>
      <div id="26m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="26">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="十里堡北里">十里堡北里</span></div>
    </li>
    <li>
      <div id="27m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="27">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="农民日报社" style="font-size: 16px;font-weight:700;">农民日报社</span></div>
    </li>
    <li>
      <div id="28m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="28">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="农民日报社北">农民日报社北</span></div>
    </li>
    <li>
      <div id="29m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="29">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="石佛营东里">石佛营东里</span></div>
    </li>
    <li>
      <div id="30m">
        <i class="busc" clstag=""></i>
      </div>
    </li>
    <li>
      <div id="30">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="豆各庄路口南">豆各庄路口南</span></div>
    </li>
    <li>
      <div id="31m">
        <i class="busc" clstag=""></i>
      </div>
    </li>
    <li>
      <div id="31">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="豆各庄路口西">豆各庄路口西</span></div>
    </li>
    <li>
      <div id="32m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="32">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="朝阳公园桥东">朝阳公园桥东</span></div>
    </li>
    <li>
      <div id="33m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="33">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="朝阳公园南门">朝阳公园南门</span></div>
    </li>
    <li>
      <div id="34m">
        <i class="busc" clstag=""></i>
      </div>
    </li>
    <li>
      <div id="34">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="甜水园街北口">甜水园街北口</span></div>
    </li>
    <li>
      <div id="35m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="35">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="团结湖">团结湖</span></div>
    </li>
    <li>
      <div id="36m">
        <i class="busc" clstag=""></i>
      </div>
    </li>
    <li>
      <div id="36">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="亮马桥">亮马桥</span></div>
    </li>
    <li>
      <div id="37m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="37">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="燕莎桥南">燕莎桥南</span></div>
    </li>
    <li>
      <div id="38m">
        <i class="busc" clstag=""></i>
      </div>
    </li>
    <li>
      <div id="38">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="燕莎桥西">燕莎桥西</span></div>
    </li>
    <li>
      <div id="39m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="39">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="新源南路西口">新源南路西口</span></div>
    </li>
    <li>
      <div id="40m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="40">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="新源里">新源里</span></div>
    </li>
    <li>
      <div id="41m">
        <i>
        </i>
      </div>
    </li>
    <li>
      <div id="41">
        <i>
        </i>
        <p class="sicon"></p>
        <span title="左家庄">左家庄</span></div>
    </li>
  </ul>
</div>
<div class="inquiry_footer">
  <section>
    <div class="inner">
      <span class="buss">途中车辆</span>
      <span class="busc">到站车辆</span></div>
  </section>
</div>
```
