import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class Constants {
  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const String baseUrlImages = 'https://image.tmdb.org/t/p/w500';
  static final String apiKey = dotenv.env['API_KEY']!;
  static const String timeoutExceptionMessage = 'timeout exception in';
  static const String genericExceptionMessage = 'generic exception in';
  static const String badRequestMessage = 'bad request in';
  static const Duration durationRemoteHttp = Duration(seconds: 10);
  static DateFormat dateFormatComplete = DateFormat("dd/MM/yyyy");
  static DateFormat dateFormatYear = DateFormat("yyyy");
}
