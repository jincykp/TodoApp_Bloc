import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<FetchTodoEvent>(_onFetchTodos);
    on<AddTaskEvent>(_onSubmitTodoEvent);

    on<TodoEvent>((event, emit) {});
  }
  Future<void> _onFetchTodos(
      FetchTodoEvent event, Emitter<TodoState> emit) async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    emit(TodoLoading());
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json['items'] as List;
        emit(TodoSuccess(result));
      } else {
        emit(const TodoError('Failed to load todos'));
      }
    } catch (e) {
      emit(TodoError('An error occurred: $e'));
    }
  }

  Future<void> _onSubmitTodoEvent(
      AddTaskEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final body = {
      "title": event.title.trim(),
      "description": event.description.trim(),
      "is_completed": false,
    };
    const url = 'https://api.nstack.in/v1/todos';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // emit(const TodoSuccess([]));
        add(FetchTodoEvent());
      } else {
        emit(TodoError(
            'Error: ${response.statusCode} - ${response.reasonPhrase}'));
      }
    } catch (error) {
      emit(TodoError('An error occurred: $error'));
    }
  }
}
