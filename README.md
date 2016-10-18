chat_client (rails event)
===============
```{bash}
基于 rails 的即时聊天客户端

在工程中的 /app/views/layoutes/application.html.erb 文件中修改 ip

<script src="https://cdn.socket.io/socket.io-1.4.5.js"></script>
<script>
  var socket = io.connect('http://(你的服务器 ip 地址):8080/');
</script>

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

