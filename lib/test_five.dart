import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    debugPrint(' CounterDisplay build ');
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  const CounterIncrementor({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('--------- CounterIncrementor build -------- ');
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 10;

  void _increment() {
    setState(() {
      ++_counter;
      debugPrint('_CounterState _counter = $_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_CounterState ---- build ');
    return Row(
      /// row 的主轴 start --- 靠左边显示
      /// row 的交叉轴 start --- 靠上边显示
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CounterIncrementor(onPressed: _increment),
        const SizedBox(width: 36),
        CounterDisplay(count: _counter),
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.greenAccent,
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.all(10),
          child: Counter(),
        ),
      ),
    ),
  );
}
