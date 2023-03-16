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

class HttpUtil {
  // default options
  static const int _connectTimeout = 15000; //15s
  static const int _receiveTimeout = 15000;
  static const int _sendTimeout = 10000;

  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static var _dio;
  static HttpUtil? _httpUtil;

  static HttpUtil getInstance() => _httpUtil ??= HttpUtil();

  // 创建 dio 实例对象
   Dio _createInstance() {
    if (_dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
        // responseType: ResponseType.json,
        baseUrl: HttpPath.BaseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
      );

      //拦截器
      var interceptor = InterceptorsWrapper(
        onRequest: (options,handler){
          print("\n================================= 请求数据 =================================");
          print("method = ${options.method.toString()}");
          print("url = ${options.uri.toString()}");
          print("headers = ${options.headers}");
          print("params = ${options.queryParameters}");
          return handler.next(options);
        },
        onResponse: (response,handler,){
          print("\n================================= 响应数据开始 =================================");
          print("code = ${response.statusCode}");
          print("data = ${response.data}");
          print("================================= 响应数据结束 =================================\n");
          return handler.next(response);
        },
        onError: (e,handler){
          print("\n=================================错误响应数据 =================================");
          print("type = ${e.type}");
          print("message = ${e.message}");
          print("stackTrace = ${e.stackTrace}");
          print("\n");
          return handler.next(e);
        }
      );

      _dio = Dio(options);
      _dio.interceptors.add(interceptor);
    }
    return _dio;
  }


  Future<T> get<T>(String url, FormData? param) async {
    return _requestHttp<T>(
      url,
      param: param,
      method: GET,
    );
  }

  Future<T> post<T>(String url, FormData param) async {
    return _requestHttp<T>(
      url,
      param: param,
      method: POST,
    );
  }

    /// T is Map<String,dynamic>  or List<dynamic>
    _requestHttp<T>(String url, {param, method}) async {
    _dio = _createInstance();
    try {
      Response response = await _dio.request(
          url,
          data: param,
          options: Options(method: method));
      if (response.statusCode == 200) return response.data;

    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print("【请求出错】${e.toString()}");
      rethrow;
    }
  }

  // 清空 dio 对象
  clear() {
    _dio = null;
  }

}
