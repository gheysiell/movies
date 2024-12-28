import 'package:movies/core/enums.dart';
import 'package:movies/features/movies_details/domain/entities/movies_details_entity.dart';

class MovieDetailsResponse {
  MovieDetails? movieDetails;
  ResponseStatus responseStatus;

  MovieDetailsResponse({
    required this.movieDetails,
    required this.responseStatus,
  });
}
