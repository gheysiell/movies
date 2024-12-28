import 'package:movies/core/enums.dart';
import 'package:movies/features/movies/domain/entities/movies_entity.dart';

class MovieResponse {
  List<Movie> movies;
  ResponseStatus responseStatus;
  bool hasNextPage;

  MovieResponse({
    required this.movies,
    required this.responseStatus,
    required this.hasNextPage,
  });
}
