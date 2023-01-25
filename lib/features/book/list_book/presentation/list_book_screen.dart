import 'package:authentication_repository/authentication_repository.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../add_edit_book/presentation/add_edit_book_screen.dart';
import '../../detail_book/presentation/detail_book_screen.dart';
import '../bloc/list_book_bloc.dart';
import 'list_book_skeleton.dart';

class ListBookScreen extends StatelessWidget {
  const ListBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBookBloc(
          bookRepository: RepositoryProvider.of<BookRepository>(context))
        ..add(ListBookStarted()),
      child: BlocListener<ListBookBloc, ListBookState>(
        listener: (context, state) {
          if (state.status == ListBookStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Gagal mengambil data buku',
                      style: TextStyle(fontSize: 12))));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Book App'),
            actions: [
              IconButton(
                  onPressed: () {
                    RepositoryProvider.of<AuthenticationRepository>(context)
                        .logout();
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          floatingActionButton: BlocBuilder<ListBookBloc, ListBookState>(
            builder: (context, state) {
              return FloatingActionButton(
                onPressed: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddEditBookScreen()));

                  if (result != null) {
                    if (result) {
                      context.read<ListBookBloc>().add(ListBookStarted());
                    }
                  }
                },
                child: const Icon(Icons.add),
              );
            },
          ),
          body: BlocBuilder<ListBookBloc, ListBookState>(
            builder: (context, state) {
              if (state.status == ListBookStatus.loading ||
                  state.status == ListBookStatus.initial) {
                return const ListBookSkeleton();
              } else if (state.status == ListBookStatus.success) {
                return state.books.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.books.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.books[index].title),
                            subtitle: Text(
                              state.books[index].subtitle ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailBookScreen(
                                        book: state.books[index]),
                                  ));

                              if (result != null) {
                                if (result) {
                                  context
                                      .read<ListBookBloc>()
                                      .add(ListBookStarted());
                                }
                              }
                            },
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/no_data.svg',
                              height: 180,
                            ),
                            const SizedBox(height: 15),
                            const Text('Tidak ada data buku')
                          ],
                        ),
                      );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
