import 'package:flutter/material.dart';

class ModelList extends StatefulWidget {
  const ModelList({super.key});

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登录页面")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("登录跳转演示,执行登录后返回到上一个页面"),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: () {
              //返回到上一级页面
              Navigator.of(context).pop();
            }, child: const Text("执行登录"))
          ],
        ),
      ),
    );
  }
}
