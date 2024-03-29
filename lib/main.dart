import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  bool isDone = false;
  String title;
  bool isChecked = false;

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
  const TodoListPage({Key? key}) : super(key: key);
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _items = <Todo>[];
  final _todoController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  void _loadTodoList() async {
    _prefs = await SharedPreferences.getInstance();
    final todoList = _prefs.getStringList('todo_list');
    if (todoList != null) {
      setState(() {
        _items.addAll(todoList.map((title) => Todo(title)));
      });
    }
  }

  void _addTodo(Todo todo) {
    setState(() {
      _items.add(todo);
      _todoController.text = '';
      _saveTodoList();
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _items.remove(todo);
      _saveTodoList();
    });
  }

  void toggleTodo(Todo todo) {
    setState(() {
      todo.isChecked = !todo.isChecked;
      todo.isDone = !todo.isDone;
      _saveTodoList();
    });
  }

  void _saveTodoList() {
    final todoList = _items.map((todo) => todo.title).toList();
    _prefs.setStringList('todo_list', todoList);
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
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final todo = _items[index];

                      return Dismissible(
                        key: Key(todo.title),
                        onDismissed: (direction) {
                          _deleteTodo(todo);
                        },
                        background: Container(color: Colors.white10),
                        child: _buildItemWidget(todo),
                      );
                    },
                  ),
                ),
              ],
            )));
  }

  Widget _buildItemWidget(Todo todo) {
    return CheckboxListTile(
      value: todo.isChecked,
      onChanged: (bool? value) {
        toggleTodo(todo);
      },
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(todo.title,
          style: TextStyle(
            decoration: todo.isChecked
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          )),
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
