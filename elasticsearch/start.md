# 安全重启

## 暂停集群的shard自动均衡
```bash
curl -XPUT http://127.0.0.1:9200/_cluster/settings -d '{
    "transient" : {
        "cluster.routing.allocation.enable" : "none"
    }
}'
```

## shutdown要升级的节点
```bash
curl -XPOST http://127.0.0.1:9200/_cluster/nodes/_local/_shutdown
```
> 或者直接kill进程

## 启动
```bash
cd /data/slot2/elk/elasticsearch/bin
ES_HEAP_SIZE=20g ./elasticsearch -d
```

## 启动集群的shard均衡
```bash
curl -XPUT http://127.0.0.1:9200/_cluster/settings -d '{
    "transient" : {
        "cluster.routing.allocation.enable" : "all"
    }
}'
```
