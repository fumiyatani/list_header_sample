import 'package:flutter/material.dart';
import 'package:sticky_header_sample/expandable_header_sample.dart';
import 'package:sticky_header_sample/header_animation_sample.dart';

class DrawerNavigationScreen extends StatefulWidget {
  const DrawerNavigationScreen({super.key});

  @override
  State createState() => _DrawerNavigationScreen();
}

class _DrawerNavigationScreen extends State<DrawerNavigationScreen> {
  int _selectedIndex = 0;

  void onTappedListItem(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });

    Scaffold.of(context).closeDrawer();
  }

  Widget _selectedBody(int index) {
    switch (index) {
      case 0:
        return const HeaderAnimationSample(
          title: 'HeaderAnimationSample',
        );
      case 1:
        return const ExpandableHeaderSample();
      default:
        return const HeaderAnimationSample(
          title: 'HeaderAnimationSample',
        );
    }
  }

  String _selectedTitle(int index) {
    switch (index) {
      case 0:
        return 'HeaderAnimationSample';
      case 1:
        return 'ExpandableHeaderSample';
      default:
        return 'HeaderAnimationSample';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_selectedTitle(_selectedIndex)),
        // 前提として、 Scaffold.of では Scaffold の Context が必要である。
        // ただ、build メソッドの context を使うと、
        // 上位の BuildContext (_DrawerNavigationScreen が継承している StatelessWidget の BuildContext) となってしまうため、
        // Scaffold の BuildContext が取得できない。
        // なので、Scaffold の子 Widget として定義することで、Scaffold の BuildContext を呼び出す。
        // 子 Widget として定義できるようにするのが、 Builder という Utility。
        leading: Builder(
          builder: (context) {
            // ここで Scaffold の BuildContext にアクセスする。
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: [
                  Text('Samples'),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  title: const Text("HeaderAnimationSample"),
                  onTap: () => onTappedListItem(context, 0),
                  selected: _selectedIndex == 0,
                );
              },
            ),
            Builder(
              builder: (context) {
                return ListTile(
                  title: const Text("ExpandableHeaderSample"),
                  onTap: () => onTappedListItem(context, 1),
                  selected: _selectedIndex == 1,
                );
              },
            ),
          ],
        ),
      ),
      body: _selectedBody(_selectedIndex),
    );
  }
}
