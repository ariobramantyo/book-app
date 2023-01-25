import 'package:api_services/api_services.dart';
import 'package:book_app/features/book/add_edit_book/presentation/add_edit_book_screen.dart';
import 'package:book_app/features/book/detail_book/bloc/detail_book_bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailBookScreen extends StatelessWidget {
  final Book book;
  const DetailBookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBookBloc(
          bookRepository: RepositoryProvider.of<BookRepository>(context)),
      child: BlocConsumer<DetailBookBloc, DetailBookState>(
        listener: (context, state) {
          if (state is DetailBookFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message,
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: Colors.red,
              ));
          } else if (state is DetailBookSuccesfully) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: const Text('Data buku berhasil dihapus',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: Theme.of(context).primaryColor,
              ));
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: ListView(
              children: [
                _buildHeader(context),
                _buildBookCard(context),
                _dataBox('Sub-julud', book.subtitle),
                const SizedBox(height: 10),
                _dataBox('Penulis', book.author),
                const SizedBox(height: 10),
                _dataBox('Tanggal publish', book.published),
                const SizedBox(height: 10),
                _dataBox('Publisher', book.publisher),
                const SizedBox(height: 10),
                _dataBox('Jumlah halaman',
                    book.pages == null ? '-' : book.pages.toString()),
                const SizedBox(height: 10),
                _dataBox('Deskripsi', book.description),
                const SizedBox(height: 10),
                _dataBox('Website', book.website),
                const SizedBox(height: 30),
                _buildBookActions(context),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 14, left: 17, right: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
          ),
          const Center(
            child: Text(
              'Detail Buku',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: const Icon(Icons.menu_book, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 2 / 3,
                child: Text(
                  book.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          Text(
            book.isbn,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildBookActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditBookScreen(book: book),
                    ));
                if (result != null) {
                  Navigator.pop(context, true);
                }
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width / 3, 48),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue[300])),
              child: Row(
                children: const [
                  Icon(Icons.edit),
                  SizedBox(width: 5),
                  Text('Edit')
                ],
              )),
          const SizedBox(width: 20),
          BlocBuilder<DetailBookBloc, DetailBookState>(
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    context
                        .read<DetailBookBloc>()
                        .add(DeleteBookRequested(book.id));
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 3, 48),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: state is DetailBookLoading
                      ? const Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(width: 5),
                            Text('Delete')
                          ],
                        ));
            },
          )
        ],
      ),
    );
  }

  Widget _dataBox(String label, String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700])),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.blue[50],
            child: Text(
                content == null
                    ? '-'
                    : content.isEmpty
                        ? '-'
                        : content,
                style: const TextStyle(fontSize: 14)),
          )
        ],
      ),
    );
  }
}
