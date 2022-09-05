import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/api/muke_service.dart';
import 'package:flutter_demo/model/LessonBean.dart';
import 'package:flutter_demo/test_override_hashcode.dart';
import 'package:get/get.dart' as getx;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// 要使用 BlocProvider
      home: BlocProvider<CounterBloc>(
        create: (BuildContext context) {
          return CounterBloc(0);
        },
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);
    print(
        "---------------------- CounterPage build ----------------------- ${counterBloc.hashCode}");
    return Scaffold(
      appBar: AppBar(
        title: Text('test bloc '),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            /// 当增加或者减少计数时，只会局部更新 BlocBuilder ，不会整个刷新 build
            BlocBuilder<CounterBloc, int>(
              builder: (BuildContext context, int count) {
                print(
                    "---------------------- BlocBuilder build -----------------------");
                return Text(
                  '当前计数: $count',
                  style: TextStyle(fontSize: 24),
                );
              },
              buildWhen: (previous, next) {
                /// 这样写只有 increment 才有用，用来控制触发刷新的逻辑
                return previous < next;
              },
            ),

            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                counterBloc.add(IncrementEvent());
              },
              child: Text(
                'increment',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                counterBloc.add(DecrementEvent());
                var data = await MukeService().getPersonalLesson(4);
                print('data size = ${data?.data.length}');

                Student s1 = Student(name: "小米", age: 23);
                Student s2 = Student(name: "小米", age: 23);

                print(
                    "s1 == s2 ? ${s1 == s2}, s1 hashcode = ${s1.hashCode}, s2 hashcode = ${s2.hashCode}");

                List<LessonDetail> lessonList = [];
                LessonDetail d1 = LessonDetail(
                    id: 1,
                    name: "语文",
                    picSmall: "picSmall",
                    picBig: "picBig",
                    description: "description");
                LessonDetail d2 = LessonDetail(
                    id: 2,
                    name: "数学",
                    picSmall: "picSmall",
                    picBig: "picBig",
                    description: "description");
                lessonList.add(d1);
                lessonList.add(d2);

                LessonBean l1 =
                    LessonBean(status: 200, msg: "OK", data: lessonList);
                LessonBean l2 =
                    LessonBean(status: 200, msg: "OK", data: lessonList);

                print(
                    "l1 == l2 ? >> ${l1 == l2}, l1 hashcode = ${l1.hashCode}, l2 hashcode = ${l2.hashCode}");
              },
              child: Text(
                'decrement',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                /// 需要 BlocProvider 的 context , 且 BlocProvider 的  create 中返回当前的 counterBloc
                /// 如果你在 create 中 重新 new 一个 CounterBloc ，那么在 page2 中增加计数，不会刷新本页面的计数
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider<CounterBloc>(
                    create: (BuildContext context) {
                      return counterBloc;
                    },
                    child: BlocPage2(),
                  );
                }));
              },
              child: Text(
                'jump page 2',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlocPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);
    print('xxxxxxxxxxxxxxx ${counterBloc.hashCode} ');

    return Scaffold(
      appBar: AppBar(
        title: Text('BlocPage2'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            BlocBuilder<CounterBloc, int>(
                builder: (BuildContext context, int count) {
              return Text(
                'page2 当前计数: $count',
                style: TextStyle(fontSize: 24),
              );
            }),
            ElevatedButton(
                onPressed: () {
                  counterBloc.add(IncrementEvent());
                },
                child: Text('add')),
          ],
        ),
      ),
    );
  }
}

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc(int initialState) : super(initialState) {
    on<DecrementEvent>((event, emit) {
      emit(state - 1);
    });
    on<IncrementEvent>((event, emit) {
      emit(state + 1);
    });
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    print(
        'Current: ${transition.currentState}, Next: ${transition.nextState}, Event: ${transition.event}');
    super.onTransition(transition);
  }
}
