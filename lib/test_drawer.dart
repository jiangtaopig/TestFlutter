import 'dart:convert';

import 'package:flutter/material.dart';

import 'dialog/custom_dialog.dart';

void main() {
  runApp(MaterialApp(
    home: TestDrawer(),
  ));
}

class TestDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestDrawerState();
  }
}

class _TestDrawerState extends State<TestDrawer> {
  String _title = 'xxx';

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  void _testFunction(int a, {String? name}) {}

  void _tt() {
    _testFunction(2, name: '22');
  }

  void showMyDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '昵称',
            enterTxt: "修改",
            callback: (res) {
              print("res = $res");
              setState(() {});
            },
            content: null,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('test drawer'),
        leading: IconButton(
          icon: Icon(Icons.accessible),
          onPressed: () => _globalKey.currentState?.openDrawer(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Text('$_title'),
            ElevatedButton(
                onPressed: () {
                  showMyDialog();
                },
                child: Text('showDialog')),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('侧边栏'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("android"),
              onTap: () {
                setState(() {
                  _title = "android";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("ios"),
              onTap: () {
                setState(() {
                  _title = "ios";
                });
                String responseBody = """{
	"extraMap": {},
	"top": {
		"center": {
			"viewAttr": {
				"title": "审批轨迹"
			}
		},
		"right": [{
			"viewAttr": {
				"type": "hiddenTrigger"
			}
		}]
	},
	"content": [{
		"viewAttr": {
			"licenseNo": "青AX0DQST",
			"cardState": "待提交",
			"type": "card_voucher_header",
			"cardTitle": "代步车服务"
		}
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"type": "labelRow",
			"title": "案件信息"
		},
		"actions": [{
			"expandFlag": "display1",
			"type": "expandable"
		}]
	}, {
		"viewAttr": {
			"expandStatus": "true",
			"textList": ["车险报案号", "46467978"],
			"expandFlag": "display1",
			"titleColor": "0xff666768",
			"type": "label"
		}
	},{
		"viewAttr": {
			"type": "divider"
		}
	}]
}""";
                Map data = Map.from(json.decode(responseBody));
                Map ss = jsonDecode("""{
		"viewAttr": {
			"expandStatus": "true",
			"textList": ["报案人联系电话", "15211252535"],
			"expandFlag": "display1",
			"titleColor": "0xff666768",
			"type": "label",
			"hiddenInfo": "phone"
		}
	}""");

                var contentMap = data['content'];
                if (contentMap != null) {
                  contentMap.add(ss);
                }
                print("content");
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
