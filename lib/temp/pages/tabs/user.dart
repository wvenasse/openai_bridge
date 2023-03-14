import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter25/utils/dio_http.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
// import '../config.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  _sendRequest () async {
    String url = 'https://chat-lab.leqee.com/index.php/bridge/OpenAiApiV1/getModels';
    BaseOptions options = BaseOptions();
    const PASS_ID = 'shwang';
    var TimeStampInSecond = (DateTime.now().millisecond).toString();
    const SECRET = 'openA1=Bridge';
    var TOKEN = PASS_ID + ':' + SECRET + '@' + TimeStampInSecond;
    options.headers['X-BRIDGE-PASS-TOKEN'] = generateMD5(TOKEN);
    options.headers['X-BRIDGE-PASS-ID'] = PASS_ID;
    options.headers['X-BRIDGE-PASS-TIME'] = TimeStampInSecond;
    options.contentType = "application/json";
    options.method = "POST";
    Dio dio = new Dio(options);
    Map params = {};
    Response result  = await dio.post(url);
    print(result.data); 
    var resData = json.decode(result.data);
    print(resData);
  }
  String generateMD5(String data) {
   Uint8List content = new Utf8Encoder().convert(data);
   Digest digest = md5.convert(content);
   return digest.toString();
 }
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                print("执行跳转");
                Navigator.pushNamed(context, "/login");
              },
              child: const Text("登录")
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/registerFirst");
              },
              child: const Text("注册")
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                _sendRequest();
              },
              child: const Text("发送")
          )
        ],
      ),
    );
  }
}
