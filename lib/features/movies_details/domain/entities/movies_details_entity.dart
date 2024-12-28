import 'package:movies/features/movies/domain/entities/movies_entity.dart';
import 'package:movies/utils/functions.dart';
import 'package:movies/utils/math_functions.dart';

class MovieDetails extends Movie {
  int duration;
  String tagline;

  MovieDetails({
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

  @override
  void formatFields() {
    title = Functions.capitalFirstLetter(title);
    voteAvg = MathFunctions.roundToDown(voteAvg / 2);
  }
}
