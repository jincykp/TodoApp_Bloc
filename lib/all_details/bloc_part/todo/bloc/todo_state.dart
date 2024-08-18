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
  const TodoSuccess(this.items);
  @override
  List<Object> get props => [items];
}

class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);
}
