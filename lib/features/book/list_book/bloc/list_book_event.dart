part of 'list_book_bloc.dart';

abstract class ListBookEvent extends Equatable {
  const ListBookEvent();

  @override
  List<Object> get props => [];
}

class ListBookStarted extends ListBookEvent {}
