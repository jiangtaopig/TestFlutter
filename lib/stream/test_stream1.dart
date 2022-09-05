import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    home: TestStreamWidget1(),
  ));
}

class TestStreamWidget1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestStreamWidgetState1();
  }
}

class MyEvent {
  String title;
  String content;

  MyEvent({required this.title, required this.content});
}

class _TestStreamWidgetState1 extends State<TestStreamWidget1> {
  late StreamController<MyEvent> _streamController;
  late StreamSubscription<MyEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _subscription = _streamController.stream.listen((event) {
      print(" title = ${event.title}, content = ${event.content}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test stream1'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          color: Colors.greenAccent,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<MyEvent>(
                  stream: _streamController.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<MyEvent> snapshot) {
                    return Text("${snapshot.data?.title}");
                  }),
              ElevatedButton(
                  onPressed: () {
                    _streamController.add(
                        MyEvent(title: '我是大有', content: 'hello world !!!'));
                  },
                  child: Text('change title')),
              ElevatedButton(
                  onPressed: () {
                    Get.to(StreamPage2(
                      streamController: _streamController,
                    ));
                  },
                  child: Text('jump StreamPage2'))
            ],
          ),
        ),
      ),
    );
  }
}

class StreamPage2 extends StatelessWidget {
  final StreamController<MyEvent> streamController;

  const StreamPage2({Key? key, required this.streamController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamIterator()
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamPage2'),
      ),
      body: Container(
        color: Colors.greenAccent,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  streamController.add(MyEvent(
                      title: 'hello world',
                      content: "China is a great country"));
                },
                child: Text('add data')),
          ],
        ),
      ),
    );
  }
}
