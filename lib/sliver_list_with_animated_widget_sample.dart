import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverListWithAnimatedWidgetSample extends StatefulWidget {
  const SliverListWithAnimatedWidgetSample({super.key});

  @override
  State<SliverListWithAnimatedWidgetSample> createState() =>
      _SliverListWithAnimatedWidgetSampleState();
}

class _SliverListWithAnimatedWidgetSampleState
    extends State<SliverListWithAnimatedWidgetSample> {
  late ScrollController _scrollController;
  bool _isTopAtEdge = true;
  final GlobalKey _sliverListKey = GlobalKey();
  late double sliverListHeight;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScrolled);

    WidgetsBinding.instance.addPostFrameCallback((_) => _getSliverListHeight());
  }

  void _getSliverListHeight() {
    final RenderSliverList? renderBox =
        _sliverListKey.currentContext?.findRenderObject() as RenderSliverList?;
    if (renderBox != null) {
      setState(() {
        sliverListHeight = renderBox.geometry?.scrollExtent ?? 0.0;
      });
    }
  }

  void _onScrolled() {
    final currentPixels = _scrollController.position.pixels;
    if (currentPixels > sliverListHeight) {
      // 下方向へのスクロール
      setState(() {
        _isTopAtEdge = false;
      });
    }

    // トップの初期位置に戻った場合
    if (currentPixels <= sliverListHeight) {
      setState(() {
        _isTopAtEdge = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  void _scrollUp() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                key: _sliverListKey,
                delegate: SliverChildListDelegate(
                  [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ConfigList(),
                    ),
                  ],
                ),
              ),
              SliverList.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item : $index'),
                  );
                },
              ),
            ],
          ),
          AnimatedOpacity(
            opacity: _isTopAtEdge ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: ShowingConfigChips(
              onPressedUp: () => _scrollUp(),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfigList extends StatelessWidget {
  const ConfigList({super.key});

  @override
  Widget build(BuildContext context) {
    final titleMediumStyle = Theme.of(context).textTheme.titleMedium;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('設定項目1', style: titleMediumStyle),
          const TextField(),
          const SizedBox(
            height: 8,
          ),
          Text('設定項目2', style: titleMediumStyle),
          const TextField(),
          const SizedBox(
            height: 8,
          ),
          Text('設定項目3', style: titleMediumStyle),
          const TextField(),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}

class ShowingConfigChips extends StatelessWidget {
  const ShowingConfigChips({
    required this.onPressedUp,
    super.key,
  });

  final void Function() onPressedUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('設定項目1: 内容'),
          const SizedBox(
            width: 4,
          ),
          const Text('設定項目2: 内容'),
          const SizedBox(
            width: 4,
          ),
          const Text('設定項目3: 内容'),
          const SizedBox(
            width: 4,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: onPressedUp,
          ),
        ],
      ),
    );
  }
}
