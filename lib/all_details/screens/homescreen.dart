import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_bloc/all_details/bloc_part/todo/bloc/todo_bloc.dart';
import 'package:todoapp_bloc/all_details/screens/addscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 65, 44, 82),
        foregroundColor: Colors.white,
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
              SnackBar(content: Text('state.message')),
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
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final task = state.items[index];
                  return Card(
                    // color: Color.fromARGB(255, 126, 90, 131),
                    child: ListTile(
                      title: Text(task['title']),
                      subtitle: Text(task['description']),
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return const Center(
              child: Text('state.message'),
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
          },
          label: const Icon(Icons.add_task)),
    );
  }
}
