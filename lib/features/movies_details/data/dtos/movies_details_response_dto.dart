import 'package:movies/core/enums.dart';
import 'package:movies/features/movies_details/data/dtos/movies_details_dto.dart';
import 'package:movies/features/movies_details/domain/entities/movies_details_response_entity.dart';

class MovieDetailsResponseDto {
  MovieDetailsDto? movieDetailsDto;
  ResponseStatus responseStatus;

  MovieDetailsResponseDto({
    required this.movieDetailsDto,
    required this.responseStatus,
  });

  MovieDetailsResponse toEntity() {
    return MovieDetailsResponse(
      movieDetails: movieDetailsDto?.toEntity(),
      responseStatus: responseStatus,
    );
  }
}
