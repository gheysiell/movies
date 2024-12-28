import 'package:movies/features/movies_details/domain/entities/movies_details_response_entity.dart';
import 'package:movies/features/movies_details/domain/repositories/movies_details_repository.dart';

class MoviesDetailsUseCase {
  MoviesDetailsRepository moviesDetailsRepository;

  MoviesDetailsUseCase({
    required this.moviesDetailsRepository,
  });

  Future<MovieDetailsResponse> getMovieDetails(int id) async {
    MovieDetailsResponse movieDetailsResponse = await moviesDetailsRepository.getMovieDetails(id);
    movieDetailsResponse.movieDetails?.formatFields();
    return movieDetailsResponse;
  }
}
