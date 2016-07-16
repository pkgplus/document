+++
date = "2016-07-14T14:34:34+08:00"
title = "ElasticSearch使用scroll分页查询"
tags = ["elasticsearch","scroll"]
categories = ["elasticsearch"]
draft = true
+++



# 1.首页查询
## 1.1 原生scroll方式
具体使用说明见[官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/search-request-scroll.html)

>scroll对应时间为预先查询下一批数据结果的时间，非读取所有数据的时间，建议大于es查询超时时间*shard 或者更大

## 1.2 ElasticSearch Sql方式
需安装 [elasticsearch-sql插件](https://github.com/NLPchina/elasticsearch-sql)

http请求：
```bash
curl -XPOST http://127.0.0.1:9200/_sql -d 'SELECT /*! USE_SCROLL(1,300000) */ * FROM myindex order by time'
```

# 2. 非首页查询

* 根据首次查询结果中的_scroll_id查询剩余结果;
* scroll需要使用带有单位;
* 返回结果中hits无数据时代表最后一页，无需继续查询

http请求:
```bash
curl http://127.0.0.1:9200/_search/scroll -d '{
"scroll" : "300000ms",
"scroll_id" : "cXVlcnlUaGVuRmV0Y2g7NTsyOTQ2MjM6aUdZdHlwdlpULWlMazJqcmVyWGJYQTszNTYxMTY6bm85d0pfeFpUR21FRzh0SDd2ZWZ6QTszODY0OTpVdnZLTXo5VFJJS09RQjNfRFNfdHd3OzM1NjExNTpubzl3Sl94WlRHbUVHOHRIN3ZlZnpBOzM4NjUwOlV2dktNejlUUklLT1FCM19EU190d3c7MDs="
}'
```

# 结果样例
```javascript
{
    "_scroll_id":"cXVlcnlUaGVuRmV0Y2g7NTsyOTQzMTg6aUdZdHlwdlpULWlMazJqcmVyWGJYQTszNTU4MTE6bm85d0pfeFpUR21FRzh0SDd2ZWZ6QTszODU1MzpVdnZLTXo5VFJJS09RQjNfRFNfdHd3OzM1NTgxMDpubzl3Sl94WlRHbUVHOHRIN3ZlZnpBOzM4NTU0OlV2dktNejlUUklLT1FCM19EU190d3c7MDs=",
    "took":9,
    "timed_out":false,
    "_shards":{
        "total":5,
        "successful":5,
        "failed":0
    },
    "hits":{
        "total":132,
        "max_score":null,
        "hits":[
            {
                "_index":"myindex",
                "_type":"TYPE",
                "_id":"IDIDIDIDID",
                "_score":null,
                "_source":{
                    "field1":"value1",
                    "field2":"value2"
                },
                "sort":[
                    1468234637000
                ]
            }
        ]
    }
}
```