import 'package:flutter/material.dart';
import 'package:flutter_demo/my_provider/list_model.dart';
import 'package:flutter_demo/my_provider/shop.dart';

class CollectionListModel extends ChangeNotifier {
  /// 依赖 ListModel
  final ListModel _listModel;

  CollectionListModel(this._listModel);

  List<Shop> shopList = [];

  /// 添加收藏
  void add(Shop shop) {
    shopList.add(shop);
    notifyListeners();
  }

  /// 移除收藏
  void remove(Shop shop) {
    shopList.remove(shop);
    notifyListeners();
  }
}
