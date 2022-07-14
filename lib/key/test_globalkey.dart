import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/**
 * 演示通过 GlobalKey 修改其他 Widget 状态等
 * 如下的开关控件是一个单独的控件 SwitcherWidget，如果想要在外部修改开关的状态，那么可以使用 GlobalKey
 */
void main() {
  runApp(MaterialApp(
    home: getHomePage2(),
  ));
}

class SwitcherWidget extends StatefulWidget {
  const SwitcherWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SwitcherWidgetState();
  }
}

class _SwitcherWidgetState extends State<SwitcherWidget> {
  bool isActive = false;

  void changeSwitcher() {
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      color: Colors.white10,
      padding: EdgeInsets.all(30),
      child: Switch.adaptive(
          value: isActive,
          activeColor: Colors.greenAccent,
          onChanged: (active) {
            changeSwitcher();
          }),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

/// 通过 GlobalKey 修改其他 Widget 的信息
class _HomePageState extends State<HomePage> {
  GlobalKey<_SwitcherWidgetState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GlobalKey Demo"),
      ),
      body: Container(
        child: Column(
          children: [
            SwitcherWidget(
              key: _globalKey,
            ),
            ElevatedButton(
                onPressed: () {
                  _globalKey.currentState?.changeSwitcher();
                },
                child: Text("change switcher"))
          ],
        ),
      ),
    );
  }
}

///------------------------------------------- 下面使用 Provider 来改变开关控件的开关状态 -------------------------------------
class SwitchModel with ChangeNotifier {
  bool isActive = false;

  void changeSwitchState() {
    isActive = !isActive;
    notifyListeners();
  }
}

class SwitchWidget2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SwitchWidget2State();
  }
}

class _SwitchWidget2State extends State<SwitchWidget2> {
  @override
  Widget build(BuildContext context) {
    SwitchModel model = Provider.of<SwitchModel>(context);

    return Container(
      width: 300,
      height: 200,
      color: Colors.white10,
      padding: EdgeInsets.all(30),
      child: Switch.adaptive(
          value: model.isActive,
          activeColor: Colors.greenAccent,
          onChanged: (active) {
            model.changeSwitchState();
          }),
    );
  }
}

Widget getHomePage2() {
  return ChangeNotifierProvider(
    create: (ctx) => SwitchModel(),
    child: Scaffold(
      appBar: AppBar(
        title: Text("provider 替代 globalkey"),
      ),
      body: Column(
        children: [
          SwitchWidget2(),
          Consumer(builder:
              (BuildContext context, SwitchModel model, Widget? child) {
            return Center(
                child: ElevatedButton(
              onPressed: () {
                model.changeSwitchState();
              },
              child: Text("Change Switcher"),
            ));
          })
        ],
      ),
    ),
  );
}
/// 感觉还是使用 GlobalKey 来修改开关控件的状态来的更加简单
/// ------------------------------------------------- 使用 Provider 修改开关控件 edn -------------------------------------