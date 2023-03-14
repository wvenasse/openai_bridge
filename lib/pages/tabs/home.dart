import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter25/utils/dio_http.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  _sendRequest () async {
    // https://chat-lab.leqee.com/index.php
    String url = 'https://chat-lab.leqee.com/index.php/bridge/OpenAiApiV1/getModels';
    BaseOptions options = BaseOptions();
    const PASS_ID = 'shwang';
    var TimeStampInSecond = (DateTime.now().millisecondsSinceEpoch/1000).toString();
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
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                print("执行跳转");
                Navigator.pushNamed(context, "/chat");
              },
              child: const Text("Chat")
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                print("执行跳转");
                Navigator.pushNamed(context, "/completion");
              },
              child: const Text("Completion")
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/dallE");
              },
              child: const Text("DALL.E")
          ),
        ],
      ),
    );
  }
}
