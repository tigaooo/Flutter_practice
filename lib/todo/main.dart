import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter ToDo Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: AddTodoView(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TodoListView(),
          ),
        ],
      ),
    );
  }
}

class AddTodoView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return TextField(
      controller: controller,
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          ref.read(todoListProvider.notifier).add(value);
          controller.clear();
        }
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.add),
      ),
    );
  }
}

class TodoListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);

    return ListView.builder(
      itemCount: todoList.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          ref.read(todoListProvider.notifier).remove(index);
        },
        child: Card(
          child: ListTile(
            title: Text(
              todoList[index],
              style: const TextStyle(fontSize: 20.0),
            ),
            leading: CircleAvatar(
              child: Text(
                (index + 1).toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final todoListProvider =
    StateNotifierProvider<TodoList, List<String>>((ref) => TodoList());

class TodoList extends StateNotifier<List<String>> {
  TodoList() : super([]);

  void add(String item) {
    state = [...state, item];
  }

  void remove(int index) {
    state = List.from(state)..removeAt(index);
  }
}