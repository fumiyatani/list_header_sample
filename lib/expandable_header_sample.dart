import 'package:flutter/material.dart';

class ExpandableHeaderSample extends StatelessWidget {
  const ExpandableHeaderSample({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold で囲わないと、DrawerNavigationScreen の context を取得してしまい、
    // SliverAppBar に Menu が表示される。
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                leading: null,
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      Text('Demo'),
                    ],
                  ),
                ),
              ),
              SliverFixedExtentList(
                itemExtent: 50.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * (index % 9)],
                      child: Text('List Item $index'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _customStickyHeader(
  bool isOpened,
  Widget openChild,
  Widget closeChild,
  int milliseconds,
) {
  return SliverList.list(
    children: [
      openChild,
    ],
  );
}
