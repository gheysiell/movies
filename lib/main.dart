import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies/core/navigation_service.dart';
import 'package:movies/core/providers.dart';
import 'package:movies/core/theme_data.dart';
import 'package:movies/features/movies/presentation/views/movies_view.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  runApp(const Movies());
}

class Movies extends StatelessWidget {
  const Movies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: buildTheme(),
        home: const MoviesView(),
      ),
    );
  }
}
