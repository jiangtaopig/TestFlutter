import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TestDialog(),
  ));
}

class TestDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestDialogState();
  }
}

class LabelData {
  String? tag;
  String? content;
}

class _TestDialogState extends State<TestDialog> {
  LabelData labelData = LabelData();

  late TextEditingController _labelTagController;

  @override
  void initState() {
    super.initState();
    _labelTagController = TextEditingController.fromValue(TextEditingValue(
        text: labelData.tag ?? "",
        selection: new TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: labelData.tag == null ? 0 : labelData.tag!.length))));
  }

  void _showLabelDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => CupertinoAlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text("输入标签的标题和内容"),
                    Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            TextField(
                              controller: _labelTagController,
                              decoration: new InputDecoration(
                                hintText: '输入标题',
                              ),
                              style: TextStyle(fontSize: 12),
                              onChanged: (data) {
                                print("1 >>> data = $data");
                                labelData.tag = data;
                              },
                            ),
                            TextField(
                              decoration: new InputDecoration(
                                hintText: '输入内容',
                              ),
                              style: TextStyle(fontSize: 12),
                              onChanged: (data) {
                                labelData.content = data;
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("确定"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("取消"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test dialog'),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  _showLabelDialog();
                },
                child: Text('showDialog'))
          ],
        ),
      ),
    );
  }
}
