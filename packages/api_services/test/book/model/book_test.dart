import 'dart:convert';

import 'package:api_services/api_services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tBookModel = Book(
      id: 1,
      userId: 1,
      isbn: '9781491943533',
      title: 'Practical Modern JavaScript',
      subtitle: "Dive into ES6 and the Future of JavaScript",
      author: "Nicolás Bevacqua",
      published: "2017-07-16 00:00:00",
      publisher: "O'Reilly Media",
      pages: 334,
      description:
          "To get the most out of modern JavaScript, you need learn the latest features of its parent specification, ECMAScript 6 (ES6). This book provides a highly practical look at ES6, without getting lost in the specification or its implementation details.",
      website: "https://github.com/mjavascript/practical-modern-javascript",
      createdAt: "2023-01-12T14:50:05.000000Z",
      updatedAt: "2023-01-12T14:50:05.000000Z");

  group(
    'book model',
    () {
      test(
        'should return a valid book model when converting from json',
        () {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('specific_book.json'));

          final result = Book.fromJson(jsonMap);

          expect(result, tBookModel);
        },
      );

      test(
        'should return a valid json map when converting from model',
        () {
          final result = tBookModel.toJson();

          final expectedMap = json.decode(fixture('specific_book.json'));

          expect(result, expectedMap);
        },
      );

      test(
        'should return a valid book model when the json only contain id, userId, isbn and title',
        () {
          final jsonMap = {
            "id": 1,
            "user_id": 1,
            "isbn": "9781491943533",
            "title": "Practical Modern JavaScript",
          };

          final expectedBookResult = Book(
              id: 1,
              userId: 1,
              isbn: "9781491943533",
              title: 'Practical Modern JavaScript');

          final result = Book.fromJson(jsonMap);

          expect(result, expectedBookResult);
        },
      );
    },
  );

  group(
    'book result model',
    () {
      final tBookResultModel = BookResult(
          currentPage: 1,
          data: [tBookModel, tBookModel],
          firstPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=1",
          from: 1,
          lastPage: 2,
          lastPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=2",
          nextPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=2",
          path: "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books",
          perPage: 10,
          prevPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=1",
          to: 10,
          total: 16);

      final tBookResultModelWithEmptyBooks = BookResult(
          currentPage: 1,
          data: [],
          firstPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=1",
          from: 1,
          lastPage: 2,
          lastPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=2",
          nextPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=2",
          path: "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books",
          perPage: 10,
          prevPageUrl:
              "https://basic-book-crud-e3u54evafq-et.a.run.app/api/books?page=1",
          to: 10,
          total: 16);

      test(
        'should return a valid book result model when converting from json',
        () {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('books.json'));

          final result = BookResult.fromJson(jsonMap);

          expect(result, tBookResultModel);
        },
      );

      test(
        'should return a valid book result model from json when the data is empty list',
        () {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('empty_data_books.json'));

          final result = BookResult.fromJson(jsonMap);

          expect(result, tBookResultModelWithEmptyBooks);
        },
      );

      test(
        'should return a json containing the proper data',
        () {
          final jsonMap = tBookModel.toJson();

          final expectedJsonMap = jsonDecode(fixture('specific_book.json'));

          expect(jsonMap, expectedJsonMap);
        },
      );

      test(
        'should return a json containing the proper data with empty books',
        () {
          final jsonMap = tBookResultModelWithEmptyBooks.toJson();

          final expectedJsonMap = jsonDecode(fixture('empty_data_books.json'));

          expect(jsonMap, expectedJsonMap);
        },
      );
    },
  );
}
