part of 'add_edit_book_bloc.dart';

abstract class AddEditBookState extends Equatable {
  const AddEditBookState();

  @override
  List<Object> get props => [];
}

class AddEditBookInitial extends AddEditBookState {}

class AddEditBookLoading extends AddEditBookState {}

class AddEditBookSuccesfully extends AddEditBookState {}

class AddEditBookFailure extends AddEditBookState {
  const AddEditBookFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
