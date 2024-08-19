import 'package:flutter/material.dart';
import 'package:todoapp_bloc/all_details/bloc_part/todo/bloc/todo_bloc.dart';
import 'package:todoapp_bloc/all_details/widgets/custom_textformfleds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 65, 44, 82),
        title: const Text(
          "Add Your Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<TodoBloc>().add(AddTaskEvent(
                      title: titleController.text,
                      description: descriptionController.text));
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.save,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextformFields(
                controller: titleController,
                hintText: "Enter your title here ",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Titile can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextformFields(
                minLines: 8,
                maxLines: 12,
                controller: descriptionController,
                hintText: "Enter Description here",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Titile can't be empty";
                  } else {
                    return null;
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
