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
      body: Center(
        child: Column(
          children: [
            Text(PersonInheritedWidget.of(context)!.person.name),
            Text(PersonInheritedWidget.of(context)!.person.age.toString()),
          ],
        ),
      ),
    );
  }
}
