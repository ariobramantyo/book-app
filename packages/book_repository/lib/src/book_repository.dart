import 'package:api_services/book/book_api_service.dart';
import 'package:api_services/book/model/book.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookRepository {
  final BookApiService _bookApiService;
  final FlutterSecureStorage _flutterSecureStorage;

  BookRepository(
      {BookApiService? bookApiService,
      FlutterSecureStorage? flutterSecureStorage})
      : _bookApiService = bookApiService ?? BookApiService(),
        _flutterSecureStorage =
            flutterSecureStorage ?? const FlutterSecureStorage();

  Future<List<Book>> getBooks() async {
    final token = await _flutterSecureStorage.read(key: 'TOKEN');

    final books = await _bookApiService.getBooks(token!);

    return books;
  }

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
    final token = await _flutterSecureStorage.read(key: 'TOKEN');

    await _bookApiService.addBook(token!, isbn, title, subtitle, author,
        published, publisher, pages, description, website);
  }

  Future<void> deleteBook(int bookId) async {
    final token = await _flutterSecureStorage.read(key: 'TOKEN');

    await _bookApiService.deleteBook(token!, bookId);
  }

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
    final token = await _flutterSecureStorage.read(key: 'TOKEN');

    await _bookApiService.updateBook(token!, bookId, isbn, title, subtitle,
        author, published, publisher, pages, description, website);
  }
}
