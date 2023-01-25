class BookResult {
  final int currentPage;
  final List<Book> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  BookResult(
      {required this.currentPage,
      required this.data,
      required this.firstPageUrl,
      required this.from,
      required this.lastPage,
      required this.lastPageUrl,
      required this.nextPageUrl,
      required this.path,
      required this.perPage,
      required this.prevPageUrl,
      required this.to,
      required this.total});

  factory BookResult.fromJson(Map<String, dynamic> json) => BookResult(
        currentPage: json['current_page'],
        // if (json['data'] != null) {
        //   data = <Data>[],
        //   json['data'].forEach((v) {
        //     data!.add(new Data.fromJson(v)),
        //   }),
        // }
        data: json['data'].map((book) => Book.fromJson(book)).toList(),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    // if (this.data != null) {
    data['data'] = this.data.map((v) => v.toJson()).toList();
    // }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Book {
  final int id;
  final int userId;
  final String isbn;
  final String title;
  String? subtitle;
  String? author;
  String? published;
  String? publisher;
  int? pages;
  String? description;
  String? website;
  String? createdAt;
  String? updatedAt;

  Book(
      {required this.id,
      required this.userId,
      required this.isbn,
      required this.title,
      this.subtitle,
      this.author,
      this.published,
      this.publisher,
      this.pages,
      this.description,
      this.website,
      this.createdAt,
      this.updatedAt});

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        userId: json['user_id'],
        isbn: json['isbn'],
        title: json['title'],
        subtitle: json['subtitle'],
        author: json['author'],
        published: json['published'],
        publisher: json['publisher'],
        pages: json['pages'],
        description: json['description'],
        website: json['website'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['isbn'] = this.isbn;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['author'] = this.author;
    data['published'] = this.published;
    data['publisher'] = this.publisher;
    data['pages'] = this.pages;
    data['description'] = this.description;
    data['website'] = this.website;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
