part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoSuccess extends TodoState {
  final List items;
  final bool isTaskAdded; // Add a flag to indicate if a task was added

  const TodoSuccess(this.items, {this.isTaskAdded = false}); // Default is false
  @override
  List<Object> get props => [items, isTaskAdded];
}

class TodoSuccessById extends TodoState {
  final Map<String, dynamic> todo;
  const TodoSuccessById(this.todo);
}

class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);
}

class TodoUpdateState extends TodoState {
  final List<Map<String, dynamic>> updatedDetails;
  const TodoUpdateState(this.updatedDetails);
  @override
  List<Object> get props => [updatedDetails];
}
