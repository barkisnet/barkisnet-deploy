# 自动部署脚本

## 配置文件

`config.json`中的配置信息：
```json
{
  "username": "ubuntu",
  "ip": "18.162.194.181",
  "certPath": "~/ssh/barkis-testnet-hk.pem",
  "moniker": "testnet-hk3",
  "gasPrice": "0.01ubarkis",
  "barkisdPath": "binary/barkisd",
  "genesis": "https://raw.githubusercontent.com/pengqi-bc/barkis-testnet/master/genesis.json",
  "seed": "",
  "persistent_peers": "087eed6e217755923634ea5a2c7b0f868587fe67@39.100.156.135:26656,56379fcda0a13319ee772e6e6e28476b1f179676@52.198.244.242:26656"
}
```

|   名称   | 描述        | 是否需要用户自定义 |
| -------- | ----------- | ----------- |
| username | 服务器的用户名 | 是 |
| ip | 服务器的ip地址 | 是 |
| certPath | 服务器登陆的证书 | 是 |
| moniker | 区块链节点名称 | 是 |
| gasPrice | 最小gasPrice | 是 |
| barkisdPath | barkis区块链节点可执行文件 | 否 |
| genesis | 创世块的URL | 否 |
| seed | 种子节点 | 否 |
| persistent_peers | 长连接节点 | 否 |

## 命令

命令的格式如下：
```
./barkis.sh {deploy|start|stop|upgrade|changeGasPrice} {config file}
```

1. 部署新节点
  ```
  ./barkis.sh deploy config.json
  ```
 
2. 关闭节点
  ```
  ./barkis.sh stop config.json
  ``` 

3. 启动节点
  ```
  ./barkis.sh start config.json
  ``` 
  
4. 升级节点
  ```
  ./barkis.sh upgrade config.json
  ``` 
  
5. 修改gasPrice
  先修改config.json里面关于gasPrice的配置，然后执行以下命令：
  ```
  ./barkis.sh changeGasPrice config.json
  ``` 
