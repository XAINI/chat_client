chat_client (rails event)
===============
```{bash}
基于 rails 的即时聊天客户端

项目内打开 .gitignore 里增加
config/application.yml

项目内 config 下创建文件 application.yml
CHAT_SERVER_APP_HOST: (你服务器 host 端口为 8080，例如：http://127.0.0.1:8080/)

```

Detail
==================
```{bash}

运行起来工程之后需要注意如下几点：
1. 地址栏键入 (你的 ip 地址)/auth 进行登录；
2. 转到 (你的 ip 地址)/rooms 进入首页，点击 “登录 socket” 按钮登录 socket (如果不想收到其他提示消息点击 “登出 socket” 既可)；
3. 如果收到来自其他房间或其他用户的消息时，需要进入该房间或私聊室才能看到消息。

```


Install
==================

```{bash}

git clone https://github.com/XAINI/chat_client.git
cd chat_client
bundle install

```

