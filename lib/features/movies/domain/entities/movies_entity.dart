import 'package:movies/utils/functions.dart';
import 'package:movies/utils/math_functions.dart';

class Movie {
  int id;
  String title, description, imageUrlPoster, imageUrlBackdrop;
  DateTime releaseDate;
  double voteAvg;
  bool isAdult, haveVideo;

  Movie({
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

  void formatFields() {
    title = Functions.capitalFirstLetter(title);
    voteAvg = MathFunctions.roundToDown(voteAvg / 2);
  }
}
