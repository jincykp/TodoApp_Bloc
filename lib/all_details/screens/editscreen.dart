import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_bloc/all_details/bloc_part/todo/bloc/todo_bloc.dart';
import 'package:todoapp_bloc/all_details/widgets/custom_textformfleds.dart';

class EditScreen extends StatelessWidget {
  final String id;
  EditScreen({super.key, required this.id});
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // foregroundColor: Colors.white,
        //  backgroundColor: const Color.fromARGB(255, 65, 44, 82),
        title: const Text(
          "Add Your Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextformFields(
                controller: titleController,
                hintText: "Enter your title here ",
                labelText: "Title",
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
                labelText: "Description",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<TodoBloc>().add(AddTaskEvent(
                              title: titleController.text,
                              description: descriptionController.text));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 136, 104, 143)),
                      child: const Text("ADD")))
            ],
          ),
        ),
      )),
    );
  }
}
