import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/model/LessonBean.dart';
import '../../api/muke_service.dart';

abstract class LessonEvent {}

class FetchDataEvent extends LessonEvent {}

class FetchDataSuccessEvent extends LessonEvent {}

class FetchDataFailedEvent extends LessonEvent {}

enum LoadStatus { loading, success, failed }

/// 包装类，用来包装网络请求结果和请求状态

class LessonWrap {
  LessonBean? lessonBean;
  LoadStatus status;

  LessonWrap({required this.lessonBean, required this.status});
}

class LessonBloc extends Bloc<LessonEvent, LessonWrap> {
  LessonBean? _lessonBean;

  LessonBloc(LessonWrap initial) : super(initial) {
    on<FetchDataEvent>((event, emit) {
      _requestData();
    });

    on<FetchDataSuccessEvent>((event, emit) {
      emit(LessonWrap(lessonBean: _lessonBean, status: LoadStatus.success));
    });

    on<FetchDataFailedEvent>((event, emit) {
      emit(LessonWrap(lessonBean: null, status: LoadStatus.failed));
    });

    /// 初始化 bloc 的时候就去请求数据
    add(FetchDataEvent());
  }

  void _requestData() async {
    _lessonBean = await MukeService().getPersonalLesson(7);

    /// 接口请求太快了，看不到loading圈，所以加个延时
    Timer(Duration(seconds: 2), () {
      if (_lessonBean == null) {
        add(FetchDataFailedEvent());
      } else {
        add(FetchDataSuccessEvent());
      }
    });
  }
}

class BlocInstanceWidget extends StatelessWidget {
  Widget getRow(LessonDetail detail) {
    return GestureDetector(
      child: Container(
        color: Colors.blueGrey,
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 10, left: 10, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Row >>>  ${detail.name}"),
            SizedBox(
              height: 5,
            ),
            Container(
              child: ClipRRect(
                // 圆角图片
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: NetworkImage(detail.picSmall),
                  width: 60,
                  height: 60,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              detail.description,
              style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LessonBloc lessonBloc = BlocProvider.of<LessonBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Instance'),
      ),
      body: Container(
        child: Column(
          children: [
            BlocBuilder<LessonBloc, LessonWrap>(
              builder: (context, wrap) {
                if (wrap.status == LoadStatus.loading) {
                  return Container(
                      margin: EdgeInsets.only(top: 300),
                      // color: Color(0xffFFFFFF),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: const Color(0xff2A9DFF).withOpacity(0.5),
                      ));
                } else if (wrap.status == LoadStatus.success) {
                  /// 因为 在 Column 中嵌套 ListView ,所以需要加上 Expanded ，
                  /// 否则报 Vertical viewport was given unbounded height
                  return Expanded(
                      child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: wrap.lessonBean!.data.length,
                    itemBuilder: (BuildContext context, int position) {
                      return getRow(wrap.lessonBean!.data[position]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                          height: 1.0, indent: 10, color: Colors.black);
                    },
                  ));
                } else {
                  return Text("请求数据出错!!!!");
                }
              },
              buildWhen: (previous, next) {
                /// 过滤条件，只有2次数据不一致时才刷新
                return previous.lessonBean != next.lessonBean;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  /// 由于我加了过滤条件，即上面的 buildWhen，
                  /// 因为2次刷新的数据是一样的(我重写了 LessonBean 的 hashcode 和 '==')，所以不会刷新界面
                  lessonBloc.add(FetchDataEvent());
                },
                child: Text('刷新数据')),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
      home: BlocProvider<LessonBloc>(
          create: (context) => LessonBloc(
              LessonWrap(lessonBean: null, status: LoadStatus.loading)),
          child: BlocInstanceWidget())));
}
