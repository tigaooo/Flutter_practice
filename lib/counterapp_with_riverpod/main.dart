import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  //App全体でRiverpodを使用するためにProviderScopeで囲う
  runApp(const ProviderScope(child: MyApp()));
}

//StateProviderを用いてカウンターの状態を管理。初期値は0
final counterProvider = StateProvider((ref) => 0);

//Myappクラス
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MaterialAppを返す。これにより、アプリ全体のテーマとホームページを設定
    return MaterialApp(
      title: 'Flutter Demo with Riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(), // ホームページとしてMyHomePageを設定
    );
  }
}

// ConsumerWidgetのMyHomePageクラス。ここでカウンターの表示と操作を行う
class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Scaffoldを返す。これにより、アプリの主要な部分を定義
    return Scaffold(
        //AppBarのタイトルを設定
        appBar: AppBar(
          title: const Text('Flutter Demo with Riverpod'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //真ん中に配置
            children: <Widget>[
              Text('You have pushed the button this many times:'),
              CounterDisplay(), //カウント表示
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IncrementButton(ref: ref), //加算
            ResetButton(ref: ref), //0にする
            DecrementButton(ref: ref), //減算
          ],
        ));
  }
}

//カウントを表示するクラス
class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // counterProviderから現在のカウンター値を取得,watchは常に値を取得
    final count = ref.watch(counterProvider);
    // カウンター値をテキストとして表示
    return Text(
      '$count',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

//カウントをインクリメントするクラス
class IncrementButton extends StatelessWidget {
  final WidgetRef ref;
  const IncrementButton({Key? key, required this.ref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //加算ボタンを返す
    return FloatingActionButton(
      key: const Key('count_floatingActionButton'),
      //ボタンが押された時、カウンター値を増加,readはその時点での値を取得
      onPressed: () => ref.read(counterProvider.notifier).state++,
      child: const Icon(Icons.add),
    );
  }
}

//カウントをインクリメントするクラス
class DecrementButton extends StatelessWidget {
  final WidgetRef ref;
  const DecrementButton({Key? key, required this.ref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //加算ボタンを返す
    return FloatingActionButton(
      key: const Key('count_floatingActionButton'),
      //ボタンが押された時、カウンター値を増加,readはその時点での値を取得
      onPressed: () => ref.read(counterProvider.notifier).state--,
      child: const Icon(Icons.remove),
    );
  }
}

//カウントを0にするクラス
class ResetButton extends StatelessWidget {
  final WidgetRef ref;
  const ResetButton({Key? key, required this.ref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //カウントを0にするボタンを返す
    return FloatingActionButton(
      key: const Key('reset_floatingactionButton'),
      // ボタンが押された時、カウンター値を0にリセット
      onPressed: () => ref.read(counterProvider.notifier).state = 0,
      child: const Icon(Icons.refresh),
    );
  }
}
