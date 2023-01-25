import 'package:bloc/bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:equatable/equatable.dart';

part 'add_edit_book_event.dart';
part 'add_edit_book_state.dart';

class AddEditBookBloc extends Bloc<AddEditBookEvent, AddEditBookState> {
  final BookRepository _bookRepository;

  AddEditBookBloc({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(AddEditBookInitial()) {
    on<AddBookRequested>((event, emit) async {
      emit(AddEditBookLoading());

      try {
        await _bookRepository.addBooks(
            event.isbn,
            event.title,
            event.subtitle,
            event.author,
            event.published,
            event.publisher,
            event.pages,
            // event.pages.isEmpty ? 0 : int.parse(event.pages),
            event.description,
            event.website);
        emit(AddEditBookSuccesfully());
      } on Exception catch (e) {
        emit(AddEditBookFailure(e.toString()));
      } catch (e) {
        emit(const AddEditBookFailure(
            'Terjadi kesalahan, silahkan coba lagi nanti'));
      }
    });

    on<EditBookRequested>((event, emit) async {
      emit(AddEditBookLoading());

      try {
        await _bookRepository.updateBook(
            event.bookId,
            event.isbn,
            event.title,
            event.subtitle,
            event.author,
            event.published,
            event.publisher,
            event.pages,
            event.description,
            event.website);
        emit(AddEditBookSuccesfully());
      } on Exception catch (e) {
        emit(AddEditBookFailure(e.toString()));
      } catch (e) {
        emit(const AddEditBookFailure(
            'Terjadi kesalahan, silahkan coba lagi nanti'));
      }
    });
  }
}
