part of 'add_edit_book_bloc.dart';

abstract class AddEditBookEvent extends Equatable {
  const AddEditBookEvent();

  @override
  List<Object> get props => [];
}

class AddBookRequested extends AddEditBookEvent {
  const AddBookRequested(
    this.isbn,
    this.title,
    this.subtitle,
    this.author,
    this.published,
    this.publisher,
    this.pages,
    this.description,
    this.website,
  );

  final String isbn;
  final String title;
  final String subtitle;
  final String author;
  final String published;
  final String publisher;
  final String pages;
  final String description;
  final String website;

  @override
  List<Object> get props => [
        isbn,
        title,
        subtitle,
        author,
        published,
        publisher,
        pages,
        description,
        website,
      ];
}

class EditBookRequested extends AddEditBookEvent {
  const EditBookRequested(
    this.bookId,
    this.isbn,
    this.title,
    this.subtitle,
    this.author,
    this.published,
    this.publisher,
    this.pages,
    this.description,
    this.website,
  );

  final int bookId;
  final String isbn;
  final String title;
  final String subtitle;
  final String author;
  final String published;
  final String publisher;
  final String pages;
  final String description;
  final String website;

  @override
  List<Object> get props => [
        bookId,
        isbn,
        title,
        subtitle,
        author,
        published,
        publisher,
        pages,
        description,
        website,
      ];
}
