import 'package:flutter/material.dart';

class HeaderAnimationSample extends StatefulWidget {
  const HeaderAnimationSample({super.key, required this.title});

  final String title;

  @override
  State<HeaderAnimationSample> createState() => _HeaderAnimationSampleState();
}

class _HeaderAnimationSampleState extends State<HeaderAnimationSample> {
  late ScrollController scrollController;
  bool _isTopAtEdge = true;
  double prevPixels = 0.0;
  double scrolledPixel = 0.0;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(() {
      final currentPixels = scrollController.position.pixels;

      // 初期位置からスクロールされたかを判定
      final isInitialPixelsToDown = (prevPixels == 0.0 && currentPixels > 0.0);

      // 初期位置以外で下にスクロールされた場合
      // [現状の最終スクロール位置 - 前回の最終スクロール位置]を行い、
      // 前回のスクロール位置よりも多くなっていた場合は下にスクロールしたと判定する
      // 例1: 前回100pixel, 今回200pixel の場合は下にスクロールしたと判定 (true)
      // 例2: 前回200pixel, 今回100pixel の場合は上にスクロールしたと判定 (false)
      final scrollPixels = currentPixels - prevPixels;
      final isToDown = scrollPixels > 0.0;

      // トップのエッジを超えて(マイナスから0.0に戻った場合)スクロールされた場合は無効にする
      final isWithinRange = prevPixels > 0.0;
      if ((isInitialPixelsToDown || isToDown) && isWithinRange) {
        // 下方向へのスクロール
        setState(() {
          _isTopAtEdge = false;
        });
      }

      // トップの初期位置に戻った場合
      if (currentPixels <= 0.0) {
        setState(() {
          _isTopAtEdge = true;
        });
      }
      // スクロール位置を保存
      prevPixels = currentPixels;
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  void _scrollUp() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: HeaderWithAnimation(
                      isOpened: _isTopAtEdge,
                      openChild: const ConfigList(),
                      closeChild: ShowingConfigChips(
                        onPressedUp: _scrollUp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item : $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigList extends StatelessWidget {
  const ConfigList({super.key});

  @override
  Widget build(BuildContext context) {
    final titleMediumStyle = Theme.of(context).textTheme.titleMedium;

    return Column(
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
    return Row(
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
    );
  }
}

class HeaderWithAnimation extends StatelessWidget {
  const HeaderWithAnimation({
    required this.isOpened,
    required this.openChild,
    required this.closeChild,
    this.milliseconds = 400,
    super.key,
  });

  final bool isOpened;
  final Widget openChild;
  final Widget closeChild;
  final int milliseconds;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: milliseconds),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        final customFadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          // 70%以上の時だけアニメーションする。
          // 70%未満の間はアニメーションしないため、
          // open/closeどちらの Widget も非表示となる。
          curve: const Interval(0.7, 1.0),
        ));
        return FadeTransition(
          // opacity: animation,
          opacity: customFadeAnimation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      // 明示的に key を渡すことで、新しい Widget として再構築させることができる。
      child: isOpened
          ? KeyedSubtree(
              key: const ValueKey('openChild'),
              child: openChild,
            )
          : KeyedSubtree(
              key: const ValueKey('closeChild'),
              child: closeChild,
            ),
    );
  }
}
