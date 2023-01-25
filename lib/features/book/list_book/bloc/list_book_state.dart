part of 'list_book_bloc.dart';

enum ListBookStatus { initial, loading, success, failure }

class ListBookState extends Equatable {
  final List<Book> books;
  final ListBookStatus status;

  ListBookState({List<Book>? books, this.status = ListBookStatus.initial})
      : books = books ?? List<Book>.empty();

  ListBookState copyWith({
    List<Book>? books,
    ListBookStatus? status,
  }) {
    return ListBookState(
        books: books ?? this.books, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [books, status];
}
