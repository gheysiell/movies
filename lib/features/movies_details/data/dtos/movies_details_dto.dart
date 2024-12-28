import 'package:movies/core/constants.dart';
import 'package:movies/features/movies/data/dtos/movies_dto.dart';
import 'package:movies/features/movies_details/domain/entities/movies_details_entity.dart';

class MovieDetailsDto extends MovieDto {
  int duration;
  String tagline;

  MovieDetailsDto({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrlPoster,
    required super.imageUrlBackdrop,
    required super.releaseDate,
    required super.voteAvg,
    required super.haveVideo,
    required super.isAdult,
    required this.duration,
    required this.tagline,
  });

  factory MovieDetailsDto.fromMap(Map<String, dynamic> map) {
    return MovieDetailsDto(
      id: map['id'],
      duration: map['runtime'],
      title: map['title'] ?? '',
      description: map['overview'] ?? '',
      tagline: map['tagline'] ?? '',
      imageUrlPoster: '${Constants.baseUrlImages}${(map['poster_path'] ?? '')}',
      imageUrlBackdrop: '${Constants.baseUrlImages}${(map['backdrop_path'] ?? '')}',
      releaseDate: map['release_date'] ?? DateTime.parse('0000-00-00'),
      voteAvg: map['vote_average'] ?? 0,
      haveVideo: map['video'] ?? false,
      isAdult: map['adult'] ?? false,
    );
  }

  @override
  MovieDetails toEntity() {
    return MovieDetails(
      id: id,
      title: title,
      description: description,
      imageUrlPoster: imageUrlPoster,
      imageUrlBackdrop: imageUrlBackdrop,
      releaseDate: DateTime.parse(releaseDate.isNotEmpty ? releaseDate : '0000-00-00'),
      voteAvg: voteAvg,
      haveVideo: haveVideo,
      isAdult: isAdult,
      duration: duration,
      tagline: tagline,
    );
  }
}
