import 'package:flutter/material.dart';
import 'package:flutter_demo/my_provider/shop.dart';
import 'package:provider/provider.dart';

import 'collection_list_model.dart';
import 'list_model.dart';


/// 商品模型 ShopModel、商品列表模型 ListModel、收藏列表 CollectionListModel
void main() {
  runApp(MultiProvider(
    providers: [
      Provider<ListModel>(
        create: (ctx) => ListModel(),
      ),
      ChangeNotifierProxyProvider<ListModel, CollectionListModel>(
        create: (ctx) => CollectionListModel(ListModel()),
        update: (ctx, listModel, collectionModel) =>
            CollectionListModel(listModel),
      )
    ],
    child: MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: const ChangeNotifierProxyProviderDemo(),
    ),
  ));
}

class ChangeNotifierProxyProviderDemo extends StatefulWidget {
  const ChangeNotifierProxyProviderDemo({Key? key}) : super(key: key);

  @override
  _ChangeNotifierProxyProviderDemoState createState() =>
      _ChangeNotifierProxyProviderDemoState();
}

class _ChangeNotifierProxyProviderDemoState
    extends State<ChangeNotifierProxyProviderDemo> {
  int _selectedIndex = 0;
  final _pages = [const ListPage(), const CollectionPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: "商品列表"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "收藏列表")
        ],
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListModel listModel = Provider.of<ListModel>(context);
    List<Shop> shops = listModel.list;
    return Scaffold(
      appBar: AppBar(
        title: const Text("商品列表"),
      ),
      body: ListView.builder(
        itemCount: listModel.list.length,
        itemBuilder: (ctx, index) => ShopItem(
          shop: shops[index],
        ),
      ),
    );
  }
}

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionListModel collectionModel =
        Provider.of<CollectionListModel>(context);
    List<Shop> shops = collectionModel.shopList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("收藏列表"),
      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (ctx, index) => ShopItem(
          shop: shops[index],
        ),
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({Key? key, required this.shop}) : super(key: key);
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text("${shop.id}"),
      ),
      title: Text(
        shop.name,
        style: const TextStyle(fontSize: 17),
      ),
      trailing: ShopCollectionButton(
        shop: shop,
      ),
    );
  }
}

class ShopCollectionButton extends StatelessWidget {
  const ShopCollectionButton({Key? key, required this.shop}) : super(key: key);
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    CollectionListModel collectionModel =
        Provider.of<CollectionListModel>(context);
    bool contains = collectionModel.shopList.contains(shop);
    return InkWell(
      /// 测试加入购物车
      onTap: contains
          ? () => collectionModel.remove(shop)
          : () => collectionModel.add(shop),
      // onTap: () { /// 测试跳转到另外页面获取商品列表数据
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) {
      //       return TestScreen(title: "商品数量：");
      //     }),
      //   );
      // },
      child: SizedBox(
        width: 60,
        height: 60,
        child: contains
            ? const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              )
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}

/**
 * 测试跳转到另一个页面，获取商品列表
 */
class TestScreen extends StatelessWidget {
  final String title;

  TestScreen({required this.title});

  @override
  Widget build(BuildContext context) {

    // 获取 商品列表里面的数据
    ListModel listModel = Provider.of<ListModel>(context);
    List<Shop> shops = listModel.list;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(44),
        child: Text(title + " >> size = ${shops.length}"),
      ),
    );
  }
}
