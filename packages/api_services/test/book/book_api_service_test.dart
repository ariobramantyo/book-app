import 'dart:convert';

import 'package:api_services/api_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../fixtures/fixture_reader.dart';
import 'book_api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late http.Client httpClient;
  late BookApiServiceImpl bookApiService;

  const tBookId = 1;

  const tToken = 'token';
  const getBooksUrl = '$baseUrl/api/books';
  const addBookUrl = '$baseUrl/api/books/add';
  const specificBookUrl = "$baseUrl/api/books/$tBookId";
  const updateBookUrl = "$baseUrl/api/books/$tBookId/edit";

  const tIsbn = '000000000';
  const tTitle = 'title';
  const tSubtitle = 'subtitle';
  const tAuthor = 'author';
  const tPublished = 'published';
  const tPublisher = 'publisher';
  const tPages = 'pages';
  const tDescription = 'description';
  const tWebsite = 'website';

  final bookBody = {
    "isbn": tIsbn,
    "title": tTitle,
    'subtitle': tSubtitle,
    'author': tAuthor,
    'published': tPublished,
    'publisher': tPublisher,
    'pages': tPages,
    'description': tDescription,
    'website': tWebsite,
  };

  final tBooks = jsonDecode(fixture('books.json'))['data']
      .map<Book>((book) => Book.fromJson(book))
      .toList();

  setUp(
    () {
      httpClient = MockClient();
      bookApiService = BookApiServiceImpl(client: httpClient);
    },
  );

  group(
    'getBooks',
    () {
      void setUpMockHttpClientGetBooksSuccess200() {
        when(
          httpClient.get(Uri.parse(getBooksUrl),
              headers: {'Authorization': 'Bearer $tToken'}),
        ).thenAnswer((_) async => http.Response(fixture('books.json'), 200));
      }

      void setUpMockHttpClientGetBooksFailed404() {
        when(
          httpClient.get(Uri.parse(getBooksUrl),
              headers: {'Authorization': 'Bearer $tToken'}),
        ).thenAnswer((_) async => http.Response(fixture('error.json'), 404));
      }

      test(
        'should perform a GET request on a URL for get books and with authorization bearer token',
        () async {
          setUpMockHttpClientGetBooksSuccess200();

          await bookApiService.getBooks(tToken);

          verify(httpClient.get(Uri.parse(getBooksUrl),
              headers: {'Authorization': 'Bearer $tToken'}));
        },
      );

      test(
        'should return list of books when the response code is 200 (success)',
        () async {
          setUpMockHttpClientGetBooksSuccess200();

          final result = await bookApiService.getBooks(tToken);

          expect(result, tBooks);
        },
      );

      test(
        'should throw an exception when the response code is 404 (failed)',
        () async {
          setUpMockHttpClientGetBooksFailed404();

          try {
            await bookApiService.getBooks(tToken);
            fail("exception not thrown");
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );

  group(
    'addBook',
    () {
      void setUpMockHttpClientAddBookSuccess200() {
        when(
          httpClient.post(Uri.parse(addBookUrl),
              headers: {'Authorization': 'Bearer $tToken'}, body: bookBody),
        ).thenAnswer(
            (_) async => http.Response(fixture('add_book_response.json'), 200));
      }

      void setUpMockHttpClientAddBookFailed404() {
        when(
          httpClient.post(Uri.parse(addBookUrl),
              headers: {'Authorization': 'Bearer $tToken'}, body: bookBody),
        ).thenAnswer((_) async => http.Response(fixture('error.json'), 404));
      }

      test(
        'should perform a POST request on a URL for add book and with authorization bearer token',
        () async {
          setUpMockHttpClientAddBookSuccess200();

          await bookApiService.addBook(tToken, tIsbn, tTitle, tSubtitle,
              tAuthor, tPublished, tPublisher, tPages, tDescription, tWebsite);

          verify(
            httpClient.post(Uri.parse(addBookUrl),
                headers: {'Authorization': 'Bearer $tToken'}, body: bookBody),
          );
        },
      );

      test(
        'should throw exception when add book response code is 404',
        () async {
          setUpMockHttpClientAddBookFailed404();

          try {
            await bookApiService.addBook(
                tToken,
                tIsbn,
                tTitle,
                tSubtitle,
                tAuthor,
                tPublished,
                tPublisher,
                tPages,
                tDescription,
                tWebsite);
            fail("exception not thrown");
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );

  group(
    'delete book',
    () {
      test(
        'should perform a DELETE request on a URL for delete book and with authorization bearer token',
        () async {
          when(httpClient.delete(
            Uri.parse(specificBookUrl),
            headers: {'Authorization': 'Bearer $tToken'},
          )).thenAnswer((_) async =>
              http.Response(fixture('add_book_response.json'), 200));

          await bookApiService.deleteBook(tToken, tBookId);

          verify(httpClient.delete(
            Uri.parse(specificBookUrl),
            headers: {'Authorization': 'Bearer $tToken'},
          ));
        },
      );

      test(
        'should throw exception when delete book response code is 404 (failed)',
        () async {
          when(httpClient.delete(
            Uri.parse(specificBookUrl),
            headers: {'Authorization': 'Bearer $tToken'},
          )).thenAnswer((_) async => http.Response(fixture('error.json'), 404));

          try {
            await bookApiService.deleteBook(tToken, tBookId);
            fail('exception not thrown');
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );

  group(
    'update book',
    () {
      test(
        'should perform a PUT request on a URL for update book and with authorization bearer token',
        () async {
          when(httpClient.put(
            Uri.parse(updateBookUrl),
            headers: {'Authorization': 'Bearer $tToken'},
            body: bookBody,
          )).thenAnswer((_) async =>
              http.Response(fixture('add_book_response.json'), 200));

          await bookApiService.updateBook(
              tToken,
              tBookId,
              tIsbn,
              tTitle,
              tSubtitle,
              tAuthor,
              tPublished,
              tPublisher,
              tPages,
              tDescription,
              tWebsite);

          verify(httpClient.put(
            Uri.parse(updateBookUrl),
            headers: {'Authorization': 'Bearer $tToken'},
            body: bookBody,
          ));
        },
      );

      test(
        'should throw exception when update book response code is 404 (failed)',
        () async {
          when(httpClient.put(
            Uri.parse(updateBookUrl),
            headers: {'Authorization': 'Bearer $tToken'},
            body: bookBody,
          )).thenAnswer((_) async => http.Response(fixture('error.json'), 404));

          try {
            await bookApiService.updateBook(
                tToken,
                tBookId,
                tIsbn,
                tTitle,
                tSubtitle,
                tAuthor,
                tPublished,
                tPublisher,
                tPages,
                tDescription,
                tWebsite);
            fail('exception not thrown');
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );
}
