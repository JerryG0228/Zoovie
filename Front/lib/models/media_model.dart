class MediaModel {
  final String title;
  final String posterPath;
  final double? voteAverage;
  final String? releaseDate;
  final int id;
  String mediaType; // 'movie' 또는 'tv'
  bool bookmark;

  MediaModel({
    required this.title,
    required this.posterPath,
    this.voteAverage,
    this.releaseDate,
    required this.id,
    required this.mediaType,
    this.bookmark = false,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: json['vote_average']?.toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      mediaType: json['media_type'] ?? 'movie',
      bookmark: json['bookmark'] ?? false,
    );
  }

  @override
  String toString() => "Media<$mediaType:$title:$id>";
}
