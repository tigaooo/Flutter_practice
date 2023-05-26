import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context,  watch) {
    return MaterialApp(
      title: 'Memo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoListPage(),
    );
  }
}

class Memo {
  Memo({required this.id, required this.content});

  final String id;
  String content;
}


final memoListProvider = StateProvider<List<Memo>>((ref) => []);

class MemoListPage extends ConsumerWidget {
  const MemoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoList = ref.watch(memoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo List'),
      ),
      body: ListView.builder(
        itemCount: memoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(memoList[index].content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoEditPage(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemoEditPage(null),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MemoEditPage extends ConsumerWidget {
  MemoEditPage(this.index);

  final int? index;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final memoList = ref.watch(memoListProvider);
    if (index != null) {
      _controller.text = memoList[index!].content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Memo'),
        actions: [
          if (index != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                memoList.removeAt(index!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Write your memo here...',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (index == null) {
            memoList.add(
              Memo(
                id: DateTime.now().toString(),
                content: _controller.text,
              ),
            );
          } else {
            memoList[index!].content = _controller.text;
          }
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
