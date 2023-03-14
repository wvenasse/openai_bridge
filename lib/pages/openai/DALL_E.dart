import 'package:flutter/material.dart';
import 'dart:math' as math;
import './res/listData.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter25/utils/dio_http.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:flutter/widgets.dart';
import '../widget/myDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

class DallE extends StatefulWidget {
  const DallE({super.key});

  @override
  State<DallE> createState() => _DallEState();
}

class _DallEState extends State<DallE> {
  var _prompt = '';
  var _promptController = TextEditingController();
    String generateMD5(String data) {
    Uint8List content = new Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  } 

  var imageUrl = "";
  var isCanDown = false;
  getImageUrl() async {
    String url = 'https://chat-lab.leqee.com/index.php/bridge/OpenAiApiV1/generateImageForUrl';
    BaseOptions options = BaseOptions();
    const PASS_ID = 'shwang';
    var TimeStampInSecond = (DateTime.now().millisecondsSinceEpoch/1000).toString();
    const SECRET = 'openA1=Bridge';
    var TOKEN = '$PASS_ID:$SECRET@$TimeStampInSecond';
    options.headers['X-BRIDGE-PASS-TOKEN'] = generateMD5(TOKEN);
    options.headers['X-BRIDGE-PASS-ID'] = PASS_ID;
    options.headers['X-BRIDGE-PASS-TIME'] = TimeStampInSecond;
    options.contentType = "application/json";
    options.method = "POST";
    Dio dio = new Dio(options);
    var _promptText = _promptController.text; 
    setState(() {
      _prompt = _promptText; 
    });
    Map params = {
      "prompt": _promptText,
    };
    var result  = await dio.post(url, data: params);
    // print(result); 
    String resultString = result.toString();
    var resultData = json.decode(resultString);
    // print(resultData['data']); 
    // // print(resultData['data']['models']); 
    var image_url = resultData['data']['image_urls'][0];
    // modelList = resultData['data']['models'];
    setState(() {
      print(image_url);
      imageUrl = image_url;
      isCanDown = true;
    });
  }
  downImageUrl() async {
    String url = 'https://chat-lab.leqee.com/index.php/bridge/OpenAiApiV1/generateImageForOutput';
    BaseOptions options = BaseOptions();
    const PASS_ID = 'shwang';
    var TimeStampInSecond = (DateTime.now().millisecondsSinceEpoch/1000).toString();
    const SECRET = 'openA1=Bridge';
    var TOKEN = '$PASS_ID:$SECRET@$TimeStampInSecond';
    options.headers['X-BRIDGE-PASS-TOKEN'] = generateMD5(TOKEN);
    options.headers['X-BRIDGE-PASS-ID'] = PASS_ID;
    options.headers['X-BRIDGE-PASS-TIME'] = TimeStampInSecond;
    options.contentType = "application/json";
    options.method = "POST";
    Dio dio = new Dio(options);
    Map params = {
      "prompt": _prompt,
    };
    var result  = await dio.post(url, data: params);
    // print(result); 
    String resultString = result.toString();
    var resultData = json.decode(resultString);
    // print(resultData['data']); 
    // // print(resultData['data']['models']); 
    // var choices = resultData['data']['choices'];
    // modelList = resultData['data']['models'];
    setState(() {
      // print(choices);
    });
  }

  bool validateText (String? text) {
    return text?.isNotEmpty ?? false;
  }
  

  final GlobalKey _globalKey = GlobalKey();
  // 动态申请权限，ios 要在info.plist 上面添加
  /// 动态申请权限，需要区分android和ios，很多时候它两配置权限时各自的名称不同
  /// 此处以保存图片需要的配置为例
  Future<bool> requestPermission() async {
    late PermissionStatus status;
    // 1、读取系统权限的弹框
    if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      status = await Permission.storage.request();
    }
    // 2、假如你点not allow后，下次点击不会在出现系统权限的弹框（系统权限的弹框只会出现一次），
    // 这时候需要你自己写一个弹框，然后去打开app权限的页面
    if (status != PermissionStatus.granted) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('You need to grant album permissions'),
              content: const Text(
                  'Please go to your mobile phone to set the permission to open the corresponding album'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('cancle'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('confirm'),
                  onPressed: () {
                    Navigator.pop(context);
                    // 打开手机上该app权限的页面
                    // openAppSettings();
                  },
                ),
              ],
            );
          });
    } else {
      return true;
    }
    return false;
  }

  // 保存图片的权限校验
  checkPermission(Future<dynamic> fun) async {
    bool mark = await requestPermission();
    mark ? fun : null;
  }

  // 保存网络图片
  saveNetworkImg(String imgUrl) async {
    var response = await Dio()
        .get(imgUrl, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100);
    if (result['isSuccess']) {
      EasyLoading.showToast("保存网络图片成功");
    } else {
      EasyLoading.showToast("保存网络图片失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("dall")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: "prompt",
                  hintText: "请输入prompt",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                decoration: const BoxDecoration(
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print('获取图片');
                    getImageUrl();
                  },
                  child: const Text('获取图片'),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              if (validateText(imageUrl)) Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                child: InkWell(
                onTap: () {
                  // checkPermission(saveNetworkImg(imageUrl));
                  },
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                ),
              ) ,
              const SizedBox(
                height: 4,
              ),
              if (isCanDown) Container(
                decoration: const BoxDecoration(
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print('下载图片');
                    // downImageUrl();
                    checkPermission(saveNetworkImg(imageUrl));
                  },
                  child: const Text('下载图片'),
                ),
              ),
            ],
          ),
        ));
  }
}
