import 'package:book_app/features/book/detail_book/bloc/detail_book_bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'detail_book_bloc_test.mocks.dart';

@GenerateMocks([BookRepository])
void main() {
  late DetailBookBloc bloc;
  late BookRepository bookRepository;

  const tBookId = 1;

  setUp(
    () {
      bookRepository = MockBookRepository();
      bloc = DetailBookBloc(bookRepository: bookRepository);
    },
  );

  test(
    'initial bloc state should be DetailBookInitial',
    () {
      expect(bloc.state, isA<DetailBookInitial>());
    },
  );

  group(
    'delete book bloc',
    () {
      void setUpDeleteBookSuccess() {
        when(bookRepository.deleteBook(tBookId)).thenAnswer((_) async => () {});
      }

      test(
        'should perform delete book from book repository',
        () async {
          setUpDeleteBookSuccess();

          bloc.add(const DeleteBookRequested(tBookId));
          await untilCalled(bookRepository.deleteBook(tBookId));

          verify(bookRepository.deleteBook(tBookId));
        },
      );

      test(
        'should emit [DetailBookLoading, DetailBookSuccessfully] when delete book is success',
        () {
          setUpDeleteBookSuccess();

          final expected = [DetailBookLoading(), DetailBookSuccesfully()];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const DeleteBookRequested(tBookId));
        },
      );

      test(
        'should emit [DetailBookLoading, DetailBookFailure] when delete book is failed',
        () {
          when(bookRepository.deleteBook(tBookId)).thenThrow(Exception);

          final expected = [
            DetailBookLoading(),
            const DetailBookFailure(
                'Terjadi kesalahan, silahkan coba lagi nanti')
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const DeleteBookRequested(tBookId));
        },
      );
    },
  );
}
