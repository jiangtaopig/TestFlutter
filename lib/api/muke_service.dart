import 'dart:convert';

import '../model/LessonBean.dart';
import '../util/http_util.dart';

class MukeService {
  Future<LessonBean?> getPersonalLesson(int pages) async {
    var response = await HttpUtil.getDioInstance()
        .get('http://www.imooc.com/api/teacher?type=4&num=$pages');
    if (response.statusCode == 200) {
      return LessonBean.fromJson(jsonDecode(response.data));
    }
    return null;
  }
}
