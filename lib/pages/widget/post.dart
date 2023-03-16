import 'package:flutter/material.dart';
import './config.dart';
import 'dart:math' as math;
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

_sendPost (url, params) async {
  var baseUrl = Config.BaseUrl + url;
  BaseOptions options = BaseOptions();
  const PASS_ID = 'shwang';
  var TimeStampInSecond = (DateTime.now().millisecondsSinceEpoch/1000).toString();
  const SECRET = Config.SECRET;
  var TOKEN = '$PASS_ID:$SECRET@$TimeStampInSecond';
  options.headers['X-BRIDGE-PASS-TOKEN'] = generateMD5(TOKEN);
  options.headers['X-BRIDGE-PASS-ID'] = PASS_ID;
  options.headers['X-BRIDGE-PASS-TIME'] = TimeStampInSecond;
  options.contentType = "application/json";
  options.method = "POST";
  Dio dio = new Dio(options);
  try {
    var result  = await dio.post(baseUrl, data: params);
    String resultString = result.toString();
    var resultData = json.decode(resultString);
    return resultData;
  } on DioError catch (e) {
   // 请求错误处理
    print(e);
  }
  
}

String generateMD5(String data) {
  Uint8List content = new Utf8Encoder().convert(data);
  Digest digest = md5.convert(content);
  return digest.toString();
}


  