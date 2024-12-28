import 'package:movies/core/enums.dart';
import 'package:movies/features/movies/data/datasources/remote/movies_datasource_remote_http.dart';
import 'package:movies/features/movies/data/dtos/movies_response_dto.dart';
import 'package:movies/features/movies/domain/entities/movies_response_entity.dart';
import 'package:movies/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies/utils/functions.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesDataSourceRemoteHttp moviesDataSourceRemoteHttp;

  MoviesRepositoryImpl({
    required this.moviesDataSourceRemoteHttp,
  });

  @override
  Future<MovieResponse> getMovies(String search, int page) async {
    if (!await Functions.checkConn()) {
      return MovieResponse(
        movies: [],
        responseStatus: ResponseStatus.noConnection,
        hasNextPage: false,
      );
    }

    MovieResponseDto movieResponseDto = await moviesDataSourceRemoteHttp.getMovies(search, page);
    return movieResponseDto.toEntity();
  }
}
