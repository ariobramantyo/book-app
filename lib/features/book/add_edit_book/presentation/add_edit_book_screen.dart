import 'package:api_services/api_services.dart';
import 'package:book_app/features/book/add_edit_book/bloc/add_edit_book_bloc.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditBookScreen extends StatefulWidget {
  Book? book;
  AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  late TextEditingController isbnController;
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController authorController;
  late TextEditingController publishedController;
  late TextEditingController publisherController;
  late TextEditingController pagesController;
  late TextEditingController descController;
  late TextEditingController websiteController;

  @override
  void initState() {
    super.initState();
    isbnController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.isbn);
    titleController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.title);
    subtitleController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.subtitle);
    authorController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.author);
    publishedController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.published);
    publisherController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.publisher);
    pagesController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.pages.toString());
    descController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.description);
    websiteController = TextEditingController(
        text: widget.book == null ? '' : widget.book!.website);
  }

  @override
  void dispose() {
    isbnController.dispose();
    titleController.dispose();
    subtitleController.dispose();
    authorController.dispose();
    publishedController.dispose();
    publisherController.dispose();
    pagesController.dispose();
    descController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditBookBloc(
          bookRepository: RepositoryProvider.of<BookRepository>(context)),
      child: Scaffold(
        body: BlocConsumer<AddEditBookBloc, AddEditBookState>(
          listener: (context, state) {
            if (state is AddEditBookFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: Colors.red,
                ));
            } else if (state is AddEditBookSuccesfully) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(
                      widget.book != null
                          ? 'Berhasil mengubah data'
                          : 'Berhasil manambangkan data',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: Theme.of(context).primaryColor,
                ));
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            return ListView(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _formContent(),
                const SizedBox(height: 50),
                _formAction(),
                const SizedBox(height: 20)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue)),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Masukkan data buku',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<AddEditBookBloc, AddEditBookState>(
        builder: (context, state) {
          return ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 46),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              if (titleController.text.isEmpty && isbnController.text.isEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    content: Text('ISBN dan judul buku harus diisi',
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                    backgroundColor: Colors.red,
                  ));
              } else {
                if (widget.book != null) {
                  context.read<AddEditBookBloc>().add(EditBookRequested(
                        widget.book!.id,
                        isbnController.text,
                        titleController.text,
                        subtitleController.text,
                        authorController.text,
                        publishedController.text,
                        publisherController.text,
                        pagesController.text,
                        descController.text,
                        websiteController.text,
                      ));
                } else {
                  context.read<AddEditBookBloc>().add(AddBookRequested(
                        isbnController.text,
                        titleController.text,
                        subtitleController.text,
                        authorController.text,
                        publishedController.text,
                        publisherController.text,
                        pagesController.text,
                        descController.text,
                        websiteController.text,
                      ));
                }
              }
            },
            child: state is AddEditBookLoading
                ? Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  )
                : const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          );
        },
      ),
    );
  }

  Widget _formContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookTextField(
          title: 'ISBN',
          hint: "Tulis ISBN buku",
          controller: isbnController,
        ),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Judul',
            hint: "Tulis judul buku",
            controller: titleController),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Sub-julud',
            hint: "Tulis sub-judul buku",
            controller: subtitleController),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Penulis',
            hint: "Tulis penulis buku",
            controller: authorController),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Tanggal publish',
            hint: "Tulis tanggal publish. contoh: 2017-07-16",
            controller: publishedController),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Publisher',
            hint: "Tulis publisher buku",
            controller: publisherController),
        const SizedBox(height: 10),
        BookTextField(
          title: 'Jumlah halaman',
          hint: "Tulis jumlah halaman buku",
          controller: pagesController,
          isNumber: true,
        ),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Deskripsi',
            hint: 'Tulis deskripsi buku',
            controller: descController),
        const SizedBox(height: 10),
        BookTextField(
            title: 'Website',
            hint: 'Tulis website buku',
            controller: websiteController),
      ],
    );
  }
}

class BookTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  bool isNumber;
  BookTextField(
      {super.key,
      required this.title,
      required this.hint,
      required this.controller,
      this.isNumber = false});

  final TextStyle textStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: textStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700])),
          const SizedBox(height: 8),
          Container(
            height: 46,
            // padding: EdgeInsets.fromLTRB(5.0, 50, 5.0, 10.0),
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              style: textStyle.copyWith(color: Colors.black),
              maxLines: 1,
              // minLines: 1,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  hintStyle: textStyle.copyWith(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.1),
                  contentPadding:
                      const EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none)),
            ),
          ),
        ],
      ),
    );
  }
}
