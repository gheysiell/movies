import 'package:movies/features/movies_details/domain/entities/movies_details_response_entity.dart';

abstract class MoviesDetailsRepository {
  Future<MovieDetailsResponse> getMovieDetails(int id);
}
