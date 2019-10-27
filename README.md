# 自动部署脚本

## 配置文件

`config.json`中的配置信息：
```json
{
  "username": "ubuntu",
  "ip": "18.162.194.181",
  "certPath": "~/ssh/barkis-testnet-hk.pem",
  "moniker": "barkisnet-testnet-hk3",
  "gasPrice": "0.01ubarkis",
  "networkConfig" : "https://raw.githubusercontent.com/pengqi-bc/testnet/master/barkisnet-testnet-1000"
}
```

|   名称   | 描述        | 是否需要用户自定义 |
| -------- | ----------- | ----------- |
| username | 服务器的用户名 | 是 |
| ip | 服务器的ip地址 | 是 |
| certPath | 服务器登陆的证书 | 是 |
| moniker | 区块链节点名称 | 是 |
| gasPrice | 最小gasPrice | 是 |
| networkConfig | 测试网创世块和配置文件的URL | 否 |

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
