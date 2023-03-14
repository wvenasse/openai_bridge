import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';
 
void main(List<String> arguments) async {
 
  var reqHandle = proxyHandler("https://chat-lab.leqee.com/index.php");//这儿就是你目标服务的地址
 
  /// 绑定本地端口，4500，转发到真正的服务器中
  var server = await shelf_io.serve(reqHandle, 'localhost', 4500);
  // 这里设置请求策略，允许所有
  server.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
  server.defaultResponseHeaders.add('Access-Control-Allow-Credentials', true);
  server.defaultResponseHeaders.add('Access-Control-Allow-Headers', '*');
  server.defaultResponseHeaders.add('Access-Control-Max-Age', 3600);//加这个是为了不会每次都检测跨域，然后总会有两次请求
  server.defaultResponseHeaders.add('Access-Control-Expose-Headers', '*');//加这个是为了能获取header里面的其他项
  print('Serving at http://${server.address.host}:${server.port}');
}