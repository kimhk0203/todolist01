import 'package:flutter/material.dart';

class Todo {
  bool isDone = false;
  String title;
  bool ischeckd = false;

  Todo(this.title);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _items = <Todo>[];
  final _todoController = TextEditingController();

  void _addTodo(Todo todo) {
    setState(() {
      _items.add(todo);
      _todoController.text = '';
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _items.remove(todo);
    });
  }

  void toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('남은 할  일'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (() => _addTodo(
                          Todo(_todoController.text),
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '추가하기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children:
                      _items.map((todo) => _buildItemWidget(todo)).toList(),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildItemWidget(Todo todo) {
    return CheckboxListTile(
      value: false,
      onChanged: (bool? value) {},
      controlAffinity: ListTileControlAffinity.leading,

      // onTap: () => toggleTodo(todo),
      // trailing: IconButton(
      //   icon: const Icon(Icons.delete),
      //   onPressed: ((() => _deleteTodo(todo))),
      // ),
      title: Text(
        todo.title,
        style: todo.isDone
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic,
              )
            : null,
      ),
    );
  }
}

  // Widget _buildItemWidget(Todo todo) {
  //   return ListTile(
  //     onTap: () => toggleTodo(todo),
  //     trailing: IconButton(
  //       icon: const Icon(Icons.delete),
  //       onPressed: ((() => _deleteTodo(todo))),
  //     ),
  //     title: Text(
  //       todo.title,
  //       style: todo.isDone
  //           ? const TextStyle(
  //               decoration: TextDecoration.lineThrough,
  //               fontStyle: FontStyle.italic,
  //             )
  //           : null,
  //     ),
  //   );
  // }