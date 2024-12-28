import 'package:flutter/material.dart';
import 'package:movies/core/enums.dart';
import 'package:movies/features/movies/domain/entities/movies_entity.dart';
import 'package:movies/features/movies/domain/entities/movies_response_entity.dart';
import 'package:movies/features/movies/domain/usecases/movies_usecase.dart';
import 'package:movies/utils/functions.dart';

class MoviesViewModel extends ChangeNotifier {
  List<Movie> movies = [];
  bool loaderVisible = false;
  bool searchVisible = false;
  bool makingSearch = false;
  bool makingRequest = false;
  bool hasNextPage = false;
  int page = 1;
  MoviesUseCase moviesUseCase;

  MoviesViewModel({
    required this.moviesUseCase,
  });

  void setMovies(List<Movie> value) {
    movies = value;
    notifyListeners();
  }

  void setLoaderVisible(bool value) {
    loaderVisible = value;
    notifyListeners();
  }

  void setSearchVisible(bool value) {
    searchVisible = value;
    notifyListeners();
  }

  void setMakingSearch(bool value) {
    makingSearch = value;
    notifyListeners();
  }

  void setMakingRequest(bool value) {
    makingRequest = value;
    notifyListeners();
  }

  void setHasNextPage(bool value) {
    hasNextPage = value;
    notifyListeners();
  }

  void setPage(int value) {
    page = value;
    notifyListeners();
  }

  Future<void> getMovies(String search, int page, bool isPagination) async {
    setMakingRequest(true);
    setMakingSearch(search.isNotEmpty);
    setSearchVisible(search.isNotEmpty);

    if (!isPagination) setLoaderVisible(true);

    MovieResponse movieResponse = await moviesUseCase.getMovies(search, page);

    if (!isPagination) setLoaderVisible(false);

    List<Movie> moviesFormatted = isPagination ? movies + movieResponse.movies : movieResponse.movies;

    setMovies(moviesFormatted);
    setHasNextPage(movieResponse.responseStatus == ResponseStatus.success ? movieResponse.hasNextPage : true);

    if (movieResponse.responseStatus != ResponseStatus.success && !isPagination) {
      await Functions.showMessageResponseStatus(
        movieResponse.responseStatus,
        'buscar',
        'os',
        'filmes',
      );
    }

    if (movieResponse.responseStatus == ResponseStatus.success) setPage(page);

    setMakingRequest(false);
  }
}
