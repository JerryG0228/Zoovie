class MovieModel {
  final String title;
  final String keyword;
  final String poster;
  bool bookmark;

  MovieModel.fromJson(Map<String, dynamic> map)
      : title = map['title'],
        keyword = map['keyword'],
        poster = map['poster'],
        bookmark = map['bookmark'];

  @override
  String toString() => "Movie<$title:$keyword>";
}
