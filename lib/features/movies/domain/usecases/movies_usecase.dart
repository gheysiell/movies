import 'package:movies/features/movies/domain/entities/movies_response_entity.dart';
import 'package:movies/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies/features/movies/domain/entities/movies_entity.dart';

class MoviesUseCase {
  MoviesRepository moviesRepository;

  MoviesUseCase({
    required this.moviesRepository,
  });

  Future<MovieResponse> getMovies(String search, int page) async {
    MovieResponse movieResponse = await moviesRepository.getMovies(search, page);

    for (Movie movie in movieResponse.movies) {
      movie.formatFields();
    }

    return movieResponse;
  }
}
