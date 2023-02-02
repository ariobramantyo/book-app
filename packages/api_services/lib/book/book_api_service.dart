import 'dart:convert';

import 'package:api_services/api_services.dart';
import 'package:http/http.dart' as http;

abstract class BookApiService {
  Future<List<Book>> getBooks(String token);
  Future<void> addBook(
      String token,
      String isbn,
      String title,
      String subtitle,
      String author,
      String published,
      String publisher,
      String pages,
      String description,
      String website);
  Future<void> deleteBook(String token, int bookId);
  Future<void> updateBook(
      String token,
      int boodId,
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

class BookApiServiceImpl extends BookApiService {
  @override
  Future<List<Book>> getBooks(String token) async {
    final url = Uri.parse("$baseUrl/api/books");

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }

    final books = jsonDecode(response.body)['data']
        .map<Book>((book) => Book.fromJson(book))
        .toList();

    return books;
  }

  @override
  Future<void> addBook(
    String token,
    String isbn,
    String title,
    String subtitle,
    String author,
    String published,
    String publisher,
    String pages,
    String description,
    String website,
  ) async {
    final url = Uri.parse("$baseUrl/api/books/add");

    Map<String, dynamic> body = {"isbn": isbn, "title": title};

    if (subtitle.isNotEmpty) body['subtitle'] = subtitle;
    if (author.isNotEmpty) body['author'] = author;
    if (published.isNotEmpty) body['published'] = published;
    if (publisher.isNotEmpty) body['publisher'] = publisher;
    if (pages.isNotEmpty) body['pages'] = pages;
    if (description.isNotEmpty) body['description'] = description;
    if (website.isNotEmpty) body['website'] = website;

    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);

    if (response.statusCode != 200) {
      throw Exception(jsonDecode("Terjadi kesalahan"));
    }
  }

  @override
  Future<void> deleteBook(String token, int bookId) async {
    final url = Uri.parse("$baseUrl/api/books/$bookId");

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<void> updateBook(
    String token,
    int boodId,
    String isbn,
    String title,
    String subtitle,
    String author,
    String published,
    String publisher,
    String pages,
    String description,
    String website,
  ) async {
    final url = Uri.parse("$baseUrl/api/books/$boodId/edit");

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        "isbn": isbn,
        "title": title,
        "subtitle": subtitle,
        "author": author,
        "published": published,
        "publisher": publisher,
        "pages": pages,
        "description": description,
        "website": website
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
