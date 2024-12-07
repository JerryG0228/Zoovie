import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/search_widgets/Search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Dio dio = Dio();
  List<MediaModel> searchResults = [];
  String keyword = '';
  int currentPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> searchMedia() async {
    if (keyword.isEmpty || isLoading) return;

    isLoading = true;

    try {
      final response = await dio
          .get('http://127.0.0.1:5000/search/search/$keyword/$currentPage');
      final data = response.data;

      if (response.statusCode == 200) {
        final List<dynamic> results = data['results'];
        setState(() {
          searchResults.addAll(
            results.map((item) => MediaModel.fromJson(item)).toList(),
          );
          currentPage++;
        });
      }
    } catch (e) {
      print('Error searching media: $e');
    } finally {
      isLoading = false;
    }
  }

  void loadMore() {
    if (isLoading) return;
    searchMedia();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      keyword = '';
      currentPage = 1;
      searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff4A8D81),
          elevation: 4.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      keyword = value.trim();
                      currentPage = 1;
                      searchResults.clear();
                      if (keyword.isNotEmpty) {
                        searchMedia();
                      }
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '검색창',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          )),
      body: SearchResults(
          keyword: keyword,
          searchResults: searchResults,
          isLoading: isLoading,
          scrollController: _scrollController),
    );
  }
}
