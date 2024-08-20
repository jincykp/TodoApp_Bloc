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
    on<DeleteTodoEvent>(_deleteTodo);
    on<UpdateTodoEvent>(updateTodo);
    on<FetchTodoEventById>(onFetchById);
    on<TodoEvent>((event, emit) {});
  }
  Future<void> _onFetchTodos(
      FetchTodoEvent event, Emitter<TodoState> emit) async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
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
    };
    const url = 'https://api.nstack.in/v1/todos';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(const TodoSuccess([]));
        add(FetchTodoEvent());
      } else {
        emit(TodoError(
            'Error: ${response.statusCode} - ${response.reasonPhrase}'));
      }
    } catch (error) {
      emit(TodoError('An error occurred: $error'));
    }
  }

  Future<void> _deleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    final url = 'https://api.nstack.in/v1/todos/${event.id}';
    emit(TodoLoading());
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        add(FetchTodoEvent());
      } else {
        emit(TodoError("Failed to delete todo : ${response.reasonPhrase}"));
      }
    } catch (e) {
      emit(TodoError('An error occured: $e'));
    }
  }

  Future<void> onFetchById(
      FetchTodoEventById event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final url = 'https://api.nstack.in/v1/todos/${event.id}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final todoItem = json['data'] as Map<String, dynamic>;
        emit(TodoSuccessById(todoItem));
      } else {
        emit(const TodoError('Failed to load todo'));
      }
    } catch (e) {
      emit(const TodoError('An error occured'));
    }
  }

  Future<void> updateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    final url = 'https://api.nstack.in/v1/todos/${event.id}';
    emit(TodoLoading());
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': event.title.trim(),
          'description': event.description.trim(),
        }),
      );
      if (response.statusCode == 200) {
        add(FetchTodoEvent());
      } else {
        emit(TodoError('Failed to delete todo :${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(TodoError('An error occured: $e'));
    }
  }
}
