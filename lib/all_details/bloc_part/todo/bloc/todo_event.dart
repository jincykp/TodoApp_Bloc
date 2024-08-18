part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TodoEvent {
  final String title;
  final String description;
  AddTaskEvent({required this.title, required this.description});
  @override
  List<Object> get props => [title, description];
}

class FetchTodoEvent extends TodoEvent {}
