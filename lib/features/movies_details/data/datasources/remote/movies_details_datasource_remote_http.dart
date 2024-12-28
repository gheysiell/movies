import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:movies/core/constants.dart';
import 'package:movies/core/enums.dart';
import 'package:movies/features/movies_details/data/dtos/movies_details_dto.dart';
import 'package:movies/features/movies_details/data/dtos/movies_details_response_dto.dart';

abstract class MoviesDetailsDataSourceRemoteHttp {
  Future<MovieDetailsResponseDto> getMovieDetails(int id);
}

class MoviesDetailsDataSourceRemoteHttpImpl implements MoviesDetailsDataSourceRemoteHttp {
  @override
  Future<MovieDetailsResponseDto> getMovieDetails(int id) async {
    MovieDetailsResponseDto movieDetailsResponseDto = MovieDetailsResponseDto(
      movieDetailsDto: null,
      responseStatus: ResponseStatus.success,
    );

    try {
      final Uri uri = Uri.parse('${Constants.baseUrl}movie/${id.toString()}');
      final Map<String, String> header = {
        'Authorization': 'Bearer ${Constants.apiKey}',
      };
      final response = await http.get(uri, headers: header).timeout(Constants.durationRemoteHttp);

      if (response.statusCode != 200) {
        log('${Constants.badRequestMessage} MovieDetailsDataSourceRemoteHttpImpl.getMovieDetails',
            error: 'statusCode: ${response.statusCode} | response: ${json.decode(response.body)}');
        throw Exception();
      }

      Map<String, dynamic> bodyFormatted = json.decode(response.body);

      movieDetailsResponseDto.movieDetailsDto = MovieDetailsDto.fromMap(bodyFormatted);
    } on TimeoutException {
      log('${Constants.timeoutExceptionMessage} MovieDetailsDataSourceRemoteHttpImpl.getMovieDetails');
      movieDetailsResponseDto.responseStatus = ResponseStatus.timeout;
    } catch (e) {
      log('${Constants.genericExceptionMessage} MovieDetailsDataSourceRemoteHttpImpl.getMovieDetails', error: e);
      movieDetailsResponseDto.responseStatus = ResponseStatus.error;
    }

    return movieDetailsResponseDto;
  }
}
