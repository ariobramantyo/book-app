part of 'detail_book_bloc.dart';

abstract class DetailBookEvent extends Equatable {
  const DetailBookEvent();

  @override
  List<Object> get props => [];
}

class DeleteBookRequested extends DetailBookEvent {
  const DeleteBookRequested(this.boodId);
  final int boodId;

  @override
  List<Object> get props => [boodId];
}
