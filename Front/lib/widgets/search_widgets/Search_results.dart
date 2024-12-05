import 'package:flutter/material.dart';
import 'package:zoovie/models/media_model.dart';
import 'package:zoovie/widgets/main_widgets/movie_box.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    super.key,
    required this.keyword,
    required this.searchResults,
    required this.isLoading,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final String keyword;
  final List<MediaModel> searchResults;
  final bool isLoading;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff4A8D81), Color(0xff717171)],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: keyword.isEmpty
          ? const Center(
              child: Text(
                '검색어를 입력하세요',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )
          : searchResults.isEmpty && isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff00FF99),
                  ),
                )
              : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: searchResults.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < searchResults.length) {
                      return MovieBox(
                        media: searchResults[index],
                        contentType: searchResults[index].mediaType,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff00FF99),
                        ),
                      );
                    }
                  },
                ),
    );
  }
}
