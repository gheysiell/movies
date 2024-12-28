import 'package:flutter/material.dart';
import 'package:movies/core/enums.dart';
import 'package:movies/features/movies_details/domain/entities/movies_details_entity.dart';
import 'package:movies/features/movies_details/domain/entities/movies_details_response_entity.dart';
import 'package:movies/features/movies_details/domain/usecases/movies_details_usecase.dart';
import 'package:movies/utils/functions.dart';

class MoviesDetailsViewModel extends ChangeNotifier {
  bool loaderVisible = false;
  MoviesDetailsUseCase moviesDetailsUseCase;
  MovieDetails? movieDetails;

  MoviesDetailsViewModel({
    required this.moviesDetailsUseCase,
  });

  void setMovieDetails(MovieDetails? value) {
    movieDetails = value;
    notifyListeners();
  }

  void setLoaderVisible(bool value) {
    loaderVisible = value;
    notifyListeners();
  }

  Future<void> getMovieDetails(int id) async {
    setLoaderVisible(true);

    MovieDetailsResponse movieDetailsResponse = await moviesDetailsUseCase.getMovieDetails(id);

    setLoaderVisible(false);

    setMovieDetails(movieDetailsResponse.movieDetails);

    if (movieDetailsResponse.responseStatus != ResponseStatus.success) {
      await Functions.showMessageResponseStatus(
        movieDetailsResponse.responseStatus,
        'buscar',
        'os',
        'detalhes do filme',
      );
    }
  }
}
