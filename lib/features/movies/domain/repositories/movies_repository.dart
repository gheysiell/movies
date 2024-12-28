import 'package:movies/features/movies/domain/entities/movies_response_entity.dart';

abstract class MoviesRepository {
  Future<MovieResponse> getMovies(String search, int page);
}
