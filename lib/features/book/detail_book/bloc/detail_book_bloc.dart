import 'package:bloc/bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:equatable/equatable.dart';

part 'detail_book_event.dart';
part 'detail_book_state.dart';

class DetailBookBloc extends Bloc<DetailBookEvent, DetailBookState> {
  final BookRepository _bookRepository;

  DetailBookBloc({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(DetailBookInitial()) {
    on<DeleteBookRequested>((event, emit) async {
      emit(DetailBookLoading());
      try {
        await _bookRepository.deleteBook(event.boodId);
        emit(DetailBookSuccesfully());
      } on Exception catch (e) {
        emit(DetailBookFailure(e.toString()));
      } catch (e) {
        emit(DetailBookFailure('Terjadi kesalahan, silahkan coba lagi nanti'));
      }
    });
  }
}
