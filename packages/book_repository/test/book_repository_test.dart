import 'package:api_services/api_services.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'book_repository_test.mocks.dart';

@GenerateMocks([BookApiService, FlutterSecureStorage])
void main() {
  late BookRepositoryImpl repository;
  late MockBookApiService apiService;
  late MockFlutterSecureStorage flutterSecureStorage;

  final tBooks = [
    Book(id: 1, userId: 1, isbn: '0000000000', title: 'test book 1'),
    Book(id: 2, userId: 1, isbn: '0000000001', title: 'test book 2'),
  ];
  const tToken = 'token';

  const tBookId = 1;
  const tIsbn = '000000000';
  const tTitle = 'title';
  const tSubtitle = 'subtitle';
  const tAuthor = 'author';
  const tPublished = 'published';
  const tPublisher = 'publisher';
  const tPages = 'pages';
  const tDescription = 'description';
  const tWebsite = 'website';

  setUp(() async {
    apiService = MockBookApiService();
    flutterSecureStorage = MockFlutterSecureStorage();
    repository = BookRepositoryImpl(
      bookApiService: apiService,
      flutterSecureStorage: flutterSecureStorage,
    );
  });

  group(
    'flutterSecureStorage',
    () {
      test(
        'should return string when read a token from FlutterSecureStorage success',
        () async {
          // arrange
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          // act
          final result = await flutterSecureStorage.read(key: 'TOKEN');

          // assert
          expect(result, tToken);
        },
      );

      test(
        'should return null when read a token from FlutterSecureStorage failed',
        () async {
          // arrange
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => null);

          // act
          final result = await flutterSecureStorage.read(key: 'TOKEN');

          // assert
          expect(result, null);
        },
      );
    },
  );

  group(
    'getBooks',
    () {
      test(
        'should return list of books when the call to remote data source is successful',
        () async {
          // arrange
          when(apiService.getBooks(tToken)).thenAnswer((_) async => tBooks);

          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          // act
          final result = await repository.getBooks();

          // assert
          verify(flutterSecureStorage.read(key: 'TOKEN'));
          verify(apiService.getBooks(tToken));
          expect(result, equals(tBooks));
        },
      );

      test(
        'should throw exception when the call to remote data source is failed',
        () async {
          // arrange
          when(apiService.getBooks(tToken)).thenThrow(Exception);

          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          // assert
          verifyZeroInteractions(apiService);
          expect(() async => await repository.getBooks(), throwsA(Exception));
        },
      );
    },
  );

  group(
    'addBooks',
    () {
      test(
        'should call bookApiService when add book',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          await repository.addBooks(tIsbn, tTitle, tSubtitle, tAuthor,
              tPublished, tPublisher, tPages, tDescription, tWebsite);

          verify(flutterSecureStorage.read(key: 'TOKEN'));
          verify(apiService.addBook(tToken, tIsbn, tTitle, tSubtitle, tAuthor,
              tPublished, tPublisher, tPages, tDescription, tWebsite));
        },
      );

      test(
        'should throw exception when add book is failed',
        () async {
          when(apiService.addBook(tToken, tIsbn, tTitle, tSubtitle, tAuthor,
                  tPublished, tPublisher, tPages, tDescription, tWebsite))
              .thenThrow(Exception);
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          expect(
              () async => await repository.addBooks(
                  tIsbn,
                  tTitle,
                  tSubtitle,
                  tAuthor,
                  tPublished,
                  tPublisher,
                  tPages,
                  tDescription,
                  tWebsite),
              throwsA(Exception));
        },
      );
    },
  );

  group(
    'updateBook',
    () {
      test(
        'should call bookApiService when update book',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          await repository.updateBook(tBookId, tIsbn, tTitle, tSubtitle,
              tAuthor, tPublished, tPublisher, tPages, tDescription, tWebsite);

          verify(flutterSecureStorage.read(key: 'TOKEN'));
          verify(apiService.updateBook(
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
              tWebsite));
        },
      );

      test(
        'should throw exception when call api service update book failed',
        () async {
          when(apiService.updateBook(
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
                  tWebsite))
              .thenThrow(Exception);
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          expect(
              () async => await repository.updateBook(
                  tBookId,
                  tIsbn,
                  tTitle,
                  tSubtitle,
                  tAuthor,
                  tPublished,
                  tPublisher,
                  tPages,
                  tDescription,
                  tWebsite),
              throwsA(Exception));
        },
      );
    },
  );

  group(
    'deleteBook',
    () {
      test(
        'should call bookApiService when delete book',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          await repository.deleteBook(tBookId);

          verify(flutterSecureStorage.read(key: 'TOKEN'));
          verify(apiService.deleteBook(tToken, tBookId));
        },
      );

      test(
        'should throw exception when call api service delete book failed',
        () async {
          when(apiService.deleteBook(tToken, tBookId)).thenThrow(Exception);
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          expect(() async => await repository.deleteBook(tBookId),
              throwsA(Exception));
        },
      );
    },
  );
}
