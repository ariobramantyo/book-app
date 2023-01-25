import 'package:api_services/api_services.dart';
import 'package:bloc/bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:equatable/equatable.dart';

part 'list_book_event.dart';
part 'list_book_state.dart';

class ListBookBloc extends Bloc<ListBookEvent, ListBookState> {
  final BookRepository _bookRepository;

  ListBookBloc({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(ListBookState()) {
    on<ListBookStarted>((event, emit) async {
      emit(state.copyWith(status: ListBookStatus.loading));
      try {
        final books = await _bookRepository.getBooks();

        emit(state.copyWith(
            books: List.from(books), status: ListBookStatus.success));
      } on Exception catch (e) {
        emit(state.copyWith(status: ListBookStatus.failure));
      } catch (e) {
        emit(state.copyWith(status: ListBookStatus.failure));
      }
    });
  }
}
