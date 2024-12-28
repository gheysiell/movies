import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:movies/core/constants.dart';
import 'package:movies/core/enums.dart';
import 'package:movies/features/movies/data/dtos/movies_dto.dart';
import 'package:movies/features/movies/data/dtos/movies_response_dto.dart';

abstract class MoviesDataSourceRemoteHttp {
  Future<MovieResponseDto> getMovies(String search, int page);
}

class MoviesDataSourceRemoteHttpImpl implements MoviesDataSourceRemoteHttp {
  @override
  Future<MovieResponseDto> getMovies(String search, int page) async {
    MovieResponseDto movieResponseDto = MovieResponseDto(
      moviesDto: [],
      responseStatus: ResponseStatus.success,
      hasNextPage: false,
    );

    try {
      final String endpoint = search.isEmpty ? 'movie/popular?page=$page' : 'search/multi?query=$search&page=$page';
      final Uri uri = Uri.parse('${Constants.baseUrl}$endpoint');
      final Map<String, String> header = {
        'Authorization': 'Bearer ${Constants.apiKey}',
      };

      final response = await http.get(uri, headers: header).timeout(Constants.durationRemoteHttp);

      if (response.statusCode != 200) {
        log(Constants.badRequestMessage, error: 'statusCode: ${response.statusCode} | response: ${response.body}');
        throw Exception();
      }

      Map<dynamic, dynamic> body = json.decode(response.body);
      List movies = body['results'];

      movieResponseDto.moviesDto = movies.map((movie) => MovieDto.fromMap(movie)).toList();
      movieResponseDto.hasNextPage = !(body['page'] == body['total_pages']);
    } on TimeoutException {
      log('${Constants.timeoutExceptionMessage} MoviesDataSourceRemoteHttp.getMovies');
      movieResponseDto.responseStatus = ResponseStatus.timeout;
    } catch (e) {
      log('${Constants.genericExceptionMessage} MoviesDataSourceRemoteHttp.getMovies', error: e);
      movieResponseDto.responseStatus = ResponseStatus.error;
    }

    return movieResponseDto;
  }
}
