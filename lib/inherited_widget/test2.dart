import 'package:flutter/material.dart';
import 'package:flutter_demo/inherited_widget/person_inherited_widget.dart';

import 'Person.dart';

class PersonStateWidget extends StatefulWidget {
  final Person person;
  final Widget child;

  PersonStateWidget({Key? key, required this.person, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PersonStateWidgetState();
  }
}

class _PersonStateWidgetState extends State<PersonStateWidget> {
  late Person _person;

  @override
  void initState() {
    _person = widget.person;
    super.initState();
  }

  void _updateCallback(Person person) {
    if (mounted) {
      setState(() {
        _person = person;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 返回 InheritWidget
    return PersonInheritedWidget(
      person: _person,
      updateCallback: _updateCallback,
      child: widget.child,
    );
  }
}

/// 由于跨页面，`InheritedWidget`需要在`MaterialApp`的上层节点
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersonStateWidget(
        person: Person(name: "pig", age: 22),
        child: MaterialApp(
          home: FirstPage(),
        ));
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InheritedWidget"),
      ),
      body: Center(
        child: Container(
          color: Colors.greenAccent,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                PersonInheritedWidget.of(context)!.person.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(PersonInheritedWidget.of(context)!.person.age.toString(),
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SecondPage();
                    }));
                  },
                  child: Text("Jump SecondPage"))
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SecondPage"),
        ),
        body: Container(
          color: Colors.amberAccent,
          child: Column(
            children: [
              Text(
                PersonInheritedWidget.of(context)!.person.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(PersonInheritedWidget.of(context)!.person.age.toString(),
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
              ElevatedButton(
                  onPressed: () {
                    /// 在页面2 更新 Person 后，页面1和2都会改变
                    PersonInheritedWidget.of(context)!
                        .updatePerson(Person(name: "哈哈", age: 30));
                  },
                  child: Text("change person"))
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
