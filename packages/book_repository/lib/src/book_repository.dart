import 'package:api_services/book/book_api_service.dart';
import 'package:api_services/book/model/book.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks();
  Future<void> addBooks(
      String isbn,
      String title,
      String subtitle,
      String author,
      String published,
      String publisher,
      String pages,
      String description,
      String website);
  Future<void> deleteBook(int bookId);
  Future<void> updateBook(
      int bookId,
      String isbn,
      String title,
      String subtitle,
      String author,
      String published,
      String publisher,
      String pages,
      String description,
      String website);
}

class BookRepositoryImpl extends BookRepository {
  final BookApiService bookApiService;
  final FlutterSecureStorage flutterSecureStorage;

  BookRepositoryImpl(
      {required this.bookApiService, required this.flutterSecureStorage});

  @override
  Future<List<Book>> getBooks() async {
    final token = await flutterSecureStorage.read(key: 'TOKEN');

    final books = await bookApiService.getBooks(token!);

    return books;
  }

  @override
  Future<void> addBooks(
      String isbn,
      String title,
      String subtitle,
      String author,
      String published,
      String publisher,
      String pages,
      String description,
      String website) async {
    final token = await flutterSecureStorage.read(key: 'TOKEN');

    await bookApiService.addBook(token!, isbn, title, subtitle, author,
        published, publisher, pages, description, website);
  }

  @override
  Future<void> deleteBook(int bookId) async {
    final token = await flutterSecureStorage.read(key: 'TOKEN');

    await bookApiService.deleteBook(token!, bookId);
  }

  @override
  Future<void> updateBook(
      int bookId,
      String isbn,
      String title,
      String subtitle,
      String author,
      String published,
      String publisher,
      String pages,
      String description,
      String website) async {
    final token = await flutterSecureStorage.read(key: 'TOKEN');

    await bookApiService.updateBook(token!, bookId, isbn, title, subtitle,
        author, published, publisher, pages, description, website);
  }
}
