import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../awesome_base.dart';

abstract class BaseDebugState<T extends StatefulWidget> extends State<T> with SubscriptionMixin {
  String get host;

  String get hostTest;

  String get hostRc;

  String currentHost = '';
  bool isEncrypt = true;
  String currentTimeZone = '';
  ValueChanged<String>? timezoneChanged;

  final TextEditingController _textEditingController = TextEditingController(text: 'https://www.baidu.com');
  final TextEditingController _launchController = TextEditingController(text: 'abamobilebank://ababank.com');
  final TextEditingController _debugHostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final String proxyHost = SpUtil.getString(BaseConfig.keyDebugHost) ?? '';
    if (proxyHost.isNotEmpty) {
      _debugHostController.text = proxyHost;
    } else {
      _debugHostController.text = '192.168.10.108:8888';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('调试页面'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildCenterLogo(),
              _buildHostWidget('外网测试', hostTest),
              _buildHostWidget('内网环境', hostRc),
              _buildHostWidget('正式环境', host),
              _buildENCRYPT(),
              TextField(
                controller: _textEditingController,
              ),
              TextButton(
                child: Text(
                  '跳网页调试',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  _gotoWebView(_textEditingController.text.trim());
                },
              ),
              TextField(
                controller: _launchController,
              ),
              TextButton(
                child: Text(
                  'launch 调试',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  try {
                    _launchController.text.trim().launch();
                  } catch (e) {
                    e.toString().toast();
                    debugPrint(e.toString());
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _debugHostController,
                      // decoration: const InputDecoration(hintText: '192.168.10.128:8888'),
                    ),
                  ),
                  const Text('代理'),
                  Checkbox(
                    value: SpUtil.getBool(BaseConfig.keyDebugHostSwitch, defValue: false) ?? false,
                    onChanged: (value) {
                      SpUtil.putString(BaseConfig.keyDebugHost, (value ?? false) ? _debugHostController.text : '');
                      SpUtil.putBool(BaseConfig.keyDebugHostSwitch, value ?? false);
                      setState(() {});
                    },
                  ),
                ],
              ),
              _buildConfirmWidget(),
              30.heightSpace,
            ],
          ),
        ));
  }

  void initWebviewUrl(String url) {
    _textEditingController.text = url;
  }

  Row _buildENCRYPT() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '启用加密',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Switch(
            value: isEncrypt,
            onChanged: (ept) {
              setState(() {
                isEncrypt = ept;
                switchIsEncrypt(isEncrypt);
              });
            })
      ],
    );
  }

  GestureDetector _buildHostWidget(String title, String newHost) {
    return GestureDetector(
      onTap: () {
        selectHostItem(newHost);
        setState(() {
          currentHost = newHost;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(newHost,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                Icons.check_box,
                color: newHost == currentHost ? Colors.deepOrange : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmWidget() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            child: Text(
              '取消',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          const SizedBox(
            width: 50.0,
          ),
          TextButton(
            child: Text(
              '确认',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () async {
              await confirmPress();
              delay(100, (value) {
                SystemNavigator.pop();
              });
            },
          )
        ],
      ),
    );
  }

  Align _buildCenterLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Icon(
        Icons.star,
        size: 100.w,
        color: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _gotoWebView(String h5Url){
    h5Url.launch();
  }

  Future<void> confirmPress();

  void selectHostItem(String newHost) {
    isEncrypt = newHost != hostRc;
    switchIsEncrypt(isEncrypt);
  }

  Future<void> switchIsEncrypt(bool encrypt);
}
