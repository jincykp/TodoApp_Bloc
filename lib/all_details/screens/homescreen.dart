import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_bloc/all_details/bloc_part/todo/bloc/todo_bloc.dart';
import 'package:todoapp_bloc/all_details/screens/addscreen.dart';
import 'package:todoapp_bloc/all_details/screens/editscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TodoBloc>().add(FetchTodoEvent());
    return Scaffold(
      appBar: AppBar(
        //  backgroundColor: const Color.fromARGB(255, 65, 44, 82),
        //   foregroundColor: Colors.white,
        title: const Center(
            child: Text(
          "TASK LIST",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('updated successfully')),
            );
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodoSuccess) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final task = state.items[index];
                  return Card(
                    color: Colors.black,
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}")),
                      title: Text(task['title']),
                      subtitle: Text(task['description']),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditScreen(
                                          id: task['_id'],
                                          initialTitle: task['title'],
                                          initialDescription:
                                              task['description'],
                                        ))).then((_) {
                              context.read<TodoBloc>().add(FetchTodoEvent());
                            });
                          } else if (value == 'delete') {
                            context
                                .read<TodoBloc>()
                                .add(DeleteTodoEvent(task['_id']));
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                                value: 'delete', child: Text('Delete'))
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const Center(
            child: Text('No tasks available'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddScreen()));
            context.read<TodoBloc>().add(FetchTodoEvent());
          },
          label: const Icon(Icons.add_task)),
    );
  }
}
