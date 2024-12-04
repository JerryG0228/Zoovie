class User {
  final String username;
  final String email;
  final Map<String, List<String>> bookmarked; // movie와 tv로 구분된 데이터

  User({
    required this.username,
    required this.email,
    required this.bookmarked,
  });
}
