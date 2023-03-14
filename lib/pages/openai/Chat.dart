import 'package:flutter/material.dart';
import '../../temp/utils/common_toast.dart';
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


class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    _getModelList();
  }

  final GlobalKey _globalKey = GlobalKey();
  var choicesList = [];
  List<Widget> _initListData() {
    List<Widget> tempList=[];
    for (var i = 0; i < choicesList.length; i++) {
      tempList.add(
        ListTile(
          // leading: Image.network("http://leqee-private.oss-cn-hangzhou.aliyuncs.com/Common/userAvatar/16206126406405053.png?OSSAccessKeyId=LTAI3z0EZ9cMmLrj&Expires=2614642912&Signature=RgitrGpSZJHROnNv6guuH2xI5%2FM%3D"),
          title: Text("${choicesList[i]["role"]}"),
          subtitle: Text("${choicesList[i]["content"]}"),
        )
      );
    }
    return tempList;
  }
  
  var modelList = [];
  var _selectedModel = '';
  _getModelList () async {
    String url = 'https://chat-lab.leqee.com/index.php/bridge/OpenAiApiV1/getModels';
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
    Map params = {};
    var result  = await dio.post(url);
    // print(result); 
    String resultString = result.toString();
    var resultData = json.decode(resultString);
    // print(resultData['data']); 
    // print(resultData['data']['models']); 
    var tempModels = resultData['data']['models'];
    modelList = resultData['data']['models'];
    print(modelList);
    return tempModels;
  }
  String generateMD5(String data) {
   Uint8List content = new Utf8Encoder().convert(data);
   Digest digest = md5.convert(content);
   return digest.toString();
 }
  List<Widget> _initModelListData  () {
    List<Widget> tempList=[];
    for (var i = 0; i < modelList.length; i++) {
      tempList.add(
        SimpleDialogOption(
          onPressed: () {
            setState(() {
              _selectedModel = modelList[i]["id"];
              choicesList = [];
            });
            print(_selectedModel);
            Navigator.pop(context, "${modelList[i]["id"]}");
          },
          child: Text("${modelList[i]["id"]}"),
        ),
      );
    }
    return tempList;
  }
  
  void _simpleDialog() async {
    // _initModelListData();
    var result = await showDialog(
      barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("请选择Model"),
          children: _initModelListData()
        );
      });
  }
  
  var _prompt = '';
  var _promptController = TextEditingController();

  sendChat() async {
    String url = 'https://chat-lab.leqee.com/index.php/bridge/OpenAiApiV1/chat';
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
    var _message = {
      "role": "user",
      "content": _promptText
    };
    if (_selectedModel == '' || _selectedModel == null) {
      CommonToast.showToast('model为空');
      return ;
    }
    if (_promptText == '' || _promptText == null) {
      CommonToast.showToast('promptText为空');
      return ;
    }
    setState(() {
      _promptController.text = '';
      _prompt = _promptText;
      choicesList.add(_message);
    });
    Map params = {
      "model": _selectedModel,
      "prompt": _promptText, 
      "messages": choicesList
    };
    var result  = await dio.post(url, data: params);
    String resultString = result.toString();
    var resultData = json.decode(resultString);
    // print(resultData['data']); 
    var choices = resultData['data']['choices'];
    var responseMessage = choices[0]['message'];
    setState(() {
      // print(responseMessage);
      choicesList.add(responseMessage);
    });
    // print(choicesList);
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.more_vert),
          // ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              // flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        // color: Colors.grey
                      ),
                      child: Text(
                        "Model: $_selectedModel",
                        // style: Theme.of(context).textTheme.headline7,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                      ),
                      child: ElevatedButton(
                        onPressed: _simpleDialog,
                        child: const Text('select'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 13, 
              child: ListView(
                children: _initListData(),
              ),
            ),
            Container(
              // flex: 4,
              height: 100,
              child: SingleChildScrollView(
                  child: 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    print('发送chat');
                                    sendChat();
                                  },
                                  child: const Text('chat')
                                ),
                              ]
                            )
                          ),
                        ],
                      ),
                    ),
                )
              
            )
          ],
        )
      ),
    );
  }
}
class IconContainer extends StatelessWidget {
  Color color;
  double size;
  IconData icon;
  IconContainer(this.icon,
  {Key? key, this.color = Colors.red, this.size = 32.0})
  : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      color: color,
      child: Center(child: Icon(icon, size: size, color: Colors.white)),
    );
  }
}
class Post {
  final String title;
  final String description;
 
  Post(this.title, this.description);
 
  Post.fromJson(Map json)
      : title = json['title'],
        description = json['description'];
 
  Map tojson() => {'title': title, 'description': description};
}