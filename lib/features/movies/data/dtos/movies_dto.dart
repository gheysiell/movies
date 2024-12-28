import 'package:movies/core/constants.dart';
import 'package:movies/features/movies/domain/entities/movies_entity.dart';

class MovieDto {
  int id;
  String title, description, imageUrlPoster, imageUrlBackdrop;
  String releaseDate;
  double voteAvg;
  bool isAdult, haveVideo;

  MovieDto({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrlPoster,
    required this.imageUrlBackdrop,
    required this.releaseDate,
    required this.voteAvg,
    required this.isAdult,
    required this.haveVideo,
  });

  factory MovieDto.fromMap(Map<String, dynamic> map) {
    return MovieDto(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['overview'] ?? '',
      imageUrlPoster: '${Constants.baseUrlImages}${(map['poster_path'] ?? '')}',
      imageUrlBackdrop: '${Constants.baseUrlImages}${(map['backdrop_path'] ?? '')}',
      releaseDate: map['release_date'] ?? '0000-00-00',
      voteAvg: map['vote_average'] ?? 0,
      isAdult: map['adult'] ?? false,
      haveVideo: map['video'] ?? false,
    );
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      description: description,
      imageUrlPoster: imageUrlPoster,
      imageUrlBackdrop: imageUrlBackdrop,
      releaseDate: DateTime.parse(releaseDate.isNotEmpty ? releaseDate : '0000-00-00'),
      voteAvg: voteAvg,
      isAdult: isAdult,
      haveVideo: haveVideo,
    );
  }
}
