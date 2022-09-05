import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: TestDatePicker2(),
  ));
}

class TestDatePicker2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   return TestDatePicker2State();
  }

}

class TestDatePicker2State extends State<TestDatePicker2> {

   DateTime selectedTime = DateTime.now();
   DateFormat dateFormat = DateFormat("yyyy年MM月dd日 HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test DatePicker'),
      ),
      body: Container(
        child: Column(
          children: [
            Text("选择日期: ${dateFormat.format(selectedTime)}"),
            ElevatedButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      dateFormat: "yyyy年-MM月-dd日,H时:m分",
                      minDateTime: DateTime.parse("2022-08-30 08:00:00"),
                      maxDateTime: DateTime.parse("2022-09-03 23:59:00"),
                      initialDateTime: DateTime.now(),
                      pickerMode: DateTimePickerMode.datetime,
                      onMonthChangeStartWithFirstDate: true,
                      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
                        print("date = ${dateTime}");

                        setState((){
                          selectedTime = dateTime;
                        });
                        for(int a in selectedIndex) {
                          print("a = $a");
                        }
                      });
                },
                child: Text('选择开始时间'))
          ],
        ),
      ),
    );
  }

}

class TestDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test DatePicker'),
      ),
      body: Container(
        child: Column(
          children: [
            Text("选择日期"),
            ElevatedButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      dateFormat: "yyyy年-MM月-dd日,H时:m分:s秒",
                      minDateTime: DateTime.parse("2022-08-30 08:00:00"),
                      maxDateTime: DateTime.parse("2022-09-01 23:59:00"),
                      initialDateTime: DateTime.now(),
                      pickerMode: DateTimePickerMode.datetime,
                      onMonthChangeStartWithFirstDate: true,
                      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
                    print("date = ${dateTime}");
                    for(int a in selectedIndex) {
                      print("a = $a");
                    }
                  });
                },
                child: Text('选择开始时间'))
          ],
        ),
      ),
    );
  }
}
