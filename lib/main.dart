import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController scrollController;
  bool _isTopAtEdge = false;
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
      print('_isTopAtEdge: $_isTopAtEdge');
      // スクロール位置を保存
      prevPixels = currentPixels;
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    height: _isTopAtEdge ? 300 : 52,
                    duration: const Duration(milliseconds: 400),
                    color: _isTopAtEdge ? Colors.red : Colors.yellow,
                    curve: Curves.fastOutSlowIn,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
