import 'package:movies/features/movies/data/datasources/remote/movies_datasource_remote_http.dart';
import 'package:movies/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:movies/features/movies/domain/usecases/movies_usecase.dart';
import 'package:movies/features/movies/presentation/viewmodels/movies_viewmodel.dart';
import 'package:movies/features/movies_details/data/datasources/remote/movies_details_datasource_remote_http.dart';
import 'package:movies/features/movies_details/data/repositories/movies_details_repository_impl.dart';
import 'package:movies/features/movies_details/domain/usecases/movies_details_usecase.dart';
import 'package:movies/features/movies_details/presentation/viewmodels/movies_details_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  Provider(
    create: (context) => MoviesDataSourceRemoteHttpImpl(),
  ),
  Provider(
    create: (context) => MoviesRepositoryImpl(
      moviesDataSourceRemoteHttp: context.read<MoviesDataSourceRemoteHttpImpl>(),
    ),
  ),
  Provider(
    create: (context) => MoviesUseCase(
      moviesRepository: context.read<MoviesRepositoryImpl>(),
    ),
  ),
  Provider(
    create: (context) => MoviesDetailsDataSourceRemoteHttpImpl(),
  ),
  Provider(
    create: (context) => MoviesDetailsRepositoryImpl(
      moviesDetailsDataSourceRemoteHttp: context.read<MoviesDetailsDataSourceRemoteHttpImpl>(),
    ),
  ),
  Provider(
    create: (context) => MoviesDetailsUseCase(
      moviesDetailsRepository: context.read<MoviesDetailsRepositoryImpl>(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => MoviesDetailsViewModel(
      moviesDetailsUseCase: context.read<MoviesDetailsUseCase>(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => MoviesViewModel(
      moviesUseCase: context.read<MoviesUseCase>(),
    ),
  ),
];
