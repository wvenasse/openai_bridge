// // ignore_for_file: dead_code

// // ignore: import_of_legacy_library_into_null_safe
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// import '../config.dart';

// class DioHttp {
//   Dio _client;
//   BuildContext context;

//   static DioHttp of(BuildContext context) {
//     return DioHttp._internal(context);
//   }

//   DioHttp._internal(BuildContext context) {
//     // ignore: null_check_always_fails
//     if (_client==null!||context!=this.context) {
//       this.context = context;
//       var options = BaseOptions(
//         baseUrl: Config.BaseUrl,
//         connectTimeout: 1000*10,
//         receiveTimeout: 1000*3,
//         extra: {
//           'context': context
//         }
//       );
//       var client = Dio(options);
//       _client = client;
//     }
//   }


//   Future<Response<Map< String, dynamic>>> get (String path,
//     [Map<String, dynamic>? params, String? token]) async {
//       var options = Options(headers: {'Authorization': token});
//       return await _client.get(path, queryParameters: params, options: options);

//   }
//   Future<Response<Map< String, dynamic>>> post (String path,
//     [Map<String, dynamic>? params, String? token]) async {
//       var options = Options(headers: {'Authorization': token});
//       return await _client.post(path, data: params, options: options);

//   }
//   Future<Response<Map< String, dynamic>>> postData (String path,
//     [Map<String, dynamic>? params, String? token]) async {
//       var options = Options(contentType: ContentType.parse('multipart/form-data'), headers: {'Authorization': token});
//       return await _client.get(path, queryParameters: params, options: options);

//   }


// }

