import 'package:book_app/features/book/add_edit_book/bloc/add_edit_book_bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_edit_book_bloc_test.mocks.dart';

@GenerateMocks([BookRepository])
void main() {
  late MockBookRepository bookRepository;
  late AddEditBookBloc bloc;

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

  setUp(
    () {
      bookRepository = MockBookRepository();
      bloc = AddEditBookBloc(bookRepository: bookRepository);
    },
  );

  test(
    'inistial state should be AddEditStateInitial',
    () {
      // assert
      expect(bloc.state, isA<AddEditBookInitial>());
    },
  );

  group(
    'add new book bloc',
    () {
      void setUpAddBookSuccess() {
        when(bookRepository.addBooks(tIsbn, tTitle, tSubtitle, tAuthor,
                tPublished, tPublisher, tPages, tDescription, tWebsite))
            .thenAnswer((_) async => () {});
      }

      const addBookRequested = AddBookRequested(tIsbn, tTitle, tSubtitle,
          tAuthor, tPublished, tPublisher, tPages, tDescription, tWebsite);

      test(
        'should perform add book from book repository',
        () async {
          setUpAddBookSuccess();

          bloc.add(addBookRequested);
          await untilCalled(bookRepository.addBooks(tIsbn, tTitle, tSubtitle,
              tAuthor, tPublished, tPublisher, tPages, tDescription, tWebsite));

          verify(bookRepository.addBooks(tIsbn, tTitle, tSubtitle, tAuthor,
              tPublished, tPublisher, tPages, tDescription, tWebsite));
        },
      );

      test(
        'should emit [AddEditBookLoading, AddEditBookSuccesfully] when add book is success',
        () {
          setUpAddBookSuccess();

          bloc.add(addBookRequested);

          final expected = [AddEditBookLoading(), AddEditBookSuccesfully()];
          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );

      test(
        'should emit [AddEditBookLoading, AddEditBookFailure] when add book is failed',
        () {
          when(bookRepository.addBooks(tIsbn, tTitle, tSubtitle, tAuthor,
                  tPublished, tPublisher, tPages, tDescription, tWebsite))
              .thenThrow(Exception);

          bloc.add(addBookRequested);

          final expected = [
            AddEditBookLoading(),
            const AddEditBookFailure(
                'Terjadi kesalahan, silahkan coba lagi nanti')
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );
    },
  );

  group(
    'edit book bloc',
    () {
      void setUpEditBookSuccess() {
        when(bookRepository.updateBook(
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
            .thenAnswer((_) async => () {});
      }

      const editBookRequested = EditBookRequested(
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

      test(
        'should perform update book from book repository',
        () async {
          setUpEditBookSuccess();

          bloc.add(editBookRequested);
          await untilCalled(bookRepository.updateBook(
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

          verify(bookRepository.updateBook(tBookId, tIsbn, tTitle, tSubtitle,
              tAuthor, tPublished, tPublisher, tPages, tDescription, tWebsite));
        },
      );

      test(
        'should emit [AddEditBookLoading, AddEditBookSuccesfully] when edit book is success',
        () {
          setUpEditBookSuccess();

          bloc.add(editBookRequested);

          final expected = [AddEditBookLoading(), AddEditBookSuccesfully()];
          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );

      test(
        'should emit [AddEditBookLoading, AddEditBookFailure] when edit book is failed',
        () {
          when(bookRepository.updateBook(
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

          bloc.add(editBookRequested);

          final expected = [
            AddEditBookLoading(),
            const AddEditBookFailure(
                'Terjadi kesalahan, silahkan coba lagi nanti')
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );
    },
  );
}
