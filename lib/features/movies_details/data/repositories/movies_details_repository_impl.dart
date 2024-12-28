import 'package:movies/core/enums.dart';
import 'package:movies/features/movies_details/data/datasources/remote/movies_details_datasource_remote_http.dart';
import 'package:movies/features/movies_details/data/dtos/movies_details_response_dto.dart';
import 'package:movies/features/movies_details/domain/entities/movies_details_response_entity.dart';
import 'package:movies/features/movies_details/domain/repositories/movies_details_repository.dart';
import 'package:movies/utils/functions.dart';

class MoviesDetailsRepositoryImpl implements MoviesDetailsRepository {
  MoviesDetailsDataSourceRemoteHttp moviesDetailsDataSourceRemoteHttp;

  MoviesDetailsRepositoryImpl({
    required this.moviesDetailsDataSourceRemoteHttp,
  });

  @override
  Future<MovieDetailsResponse> getMovieDetails(int id) async {
    if (!await Functions.checkConn()) {
      return MovieDetailsResponse(
        movieDetails: null,
        responseStatus: ResponseStatus.noConnection,
      );
    }

    MovieDetailsResponseDto movieDetailsResponseDto = await moviesDetailsDataSourceRemoteHttp.getMovieDetails(id);
    return movieDetailsResponseDto.toEntity();
  }
}
