import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/constants.dart';
import 'package:movies/features/movies_details/presentation/viewmodels/movies_details_viewmodel.dart';
import 'package:movies/shared/palette.dart';
import 'package:movies/utils/functions.dart';
import 'package:provider/provider.dart';

class MoviesDetailsView extends StatefulWidget {
  final int id;

  const MoviesDetailsView({
    super.key,
    required this.id,
  });

  @override
  State<MoviesDetailsView> createState() {
    return MoviesDetailsState();
  }
}

class MoviesDetailsState extends State<MoviesDetailsView> {
  late MoviesDetailsViewModel moviesDetailsViewModel;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      moviesDetailsViewModel = context.watch<MoviesDetailsViewModel>();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await moviesDetailsViewModel.getMovieDetails(widget.id);
      });

      initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Palette.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Palette.white,
          ),
          tooltip: 'Voltar',
        ),
        backgroundColor: Palette.primary,
        elevation: 6,
        shadowColor: Palette.black,
      ),
      backgroundColor: Palette.primary,
      body: moviesDetailsViewModel.loaderVisible
          ? const Center(
              child: CircularProgressIndicator(
                color: Palette.secondary,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await moviesDetailsViewModel.getMovieDetails(widget.id);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: moviesDetailsViewModel.movieDetails == null
                    ? SizedBox(
                        height:
                            MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Container(
                              width: 155,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/icon.png',
                                fit: BoxFit.contain,
                                width: 155,
                              ),
                            ),
                            const Text(
                              'Filme não encontrado',
                              style: TextStyle(
                                fontSize: 24,
                                color: Palette.greyMedium2,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Spacer(),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: moviesDetailsViewModel.movieDetails!.imageUrlBackdrop,
                                placeholder: (context, url) => Container(
                                  height: 220,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 220,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.photo_outlined,
                                    color: Palette.greyMedium2,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Palette.primary,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: -1,
                                child: Container(
                                  height: 2,
                                  color: Palette.primary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Functions.capitalFirstLetter(moviesDetailsViewModel.movieDetails!.title),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 18,
                                        color: Colors.yellow,
                                      ),
                                      Text(
                                        moviesDetailsViewModel.movieDetails!.voteAvg.toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Palette.greyLight,
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Palette.greyMedium,
                                        indent: 4,
                                        endIndent: 4,
                                        thickness: 2,
                                        width: 14,
                                      ),
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 17,
                                        color: Palette.secondary,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        Functions.timeFormated(moviesDetailsViewModel.movieDetails!.duration),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Palette.greyLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Lançamento: ${Constants.dateFormatComplete.format(moviesDetailsViewModel.movieDetails!.releaseDate)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Palette.greyLight,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Slogan',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.greyLight,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  Functions.capitalFirstLetter(moviesDetailsViewModel.movieDetails!.tagline),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Palette.greyMedium2,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Synapse',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.greyLight,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  Functions.capitalFirstLetter(moviesDetailsViewModel.movieDetails!.description),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Palette.greyMedium2,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
