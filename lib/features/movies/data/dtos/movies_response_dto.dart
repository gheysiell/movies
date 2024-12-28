import 'package:movies/core/enums.dart';
import 'package:movies/features/movies/data/dtos/movies_dto.dart';
import 'package:movies/features/movies/domain/entities/movies_response_entity.dart';

class MovieResponseDto {
  List<MovieDto> moviesDto;
  ResponseStatus responseStatus;
  bool hasNextPage;

  MovieResponseDto({
    required this.moviesDto,
    required this.responseStatus,
    required this.hasNextPage,
  });

  MovieResponse toEntity() {
    return MovieResponse(
        movies: moviesDto.map((movieDto) => movieDto.toEntity()).toList(),
        responseStatus: responseStatus,
        hasNextPage: hasNextPage);
  }
}
