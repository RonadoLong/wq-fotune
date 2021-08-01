# 理财项目APP

### 注意点
1. 打包或者运行时注意websocket_manager.dart在这里做好相应的代码注释
```
/// todo 运行web的时候打开
import 'package:web_socket_channel/html.dart';

/// todo 运行手机的时候打开
//import 'package:web_socket_channel/io.dart';

    /// todo 运行手机的时候打开
//    return IOWebSocketChannel.connect(url);

    /// todo 运行web的时候打开
     return HtmlWebSocketChannel.connect(url);
```
