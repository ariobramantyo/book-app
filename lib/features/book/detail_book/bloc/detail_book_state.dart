part of 'detail_book_bloc.dart';

abstract class DetailBookState extends Equatable {
  const DetailBookState();

  @override
  List<Object> get props => [];
}

class DetailBookInitial extends DetailBookState {}

class DetailBookLoading extends DetailBookState {}

class DetailBookSuccesfully extends DetailBookState {}

class DetailBookFailure extends DetailBookState {
  const DetailBookFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
