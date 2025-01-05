import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/constants.dart';
import 'package:movies/features/movies/presentation/viewmodels/movies_viewmodel.dart';
import 'package:movies/features/movies_details/presentation/viewmodels/movies_details_viewmodel.dart';
import 'package:movies/features/movies_details/presentation/views/movies_details_view.dart';
import 'package:movies/shared/inputs_style.dart';
import 'package:movies/shared/palette.dart';
import 'package:movies/utils/functions.dart';
import 'package:provider/provider.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() {
    return MoviewViewState();
  }
}

class MoviewViewState extends State<MoviesView> {
  final TextEditingController controllerSearch = TextEditingController();
  final FocusNode focusSearch = FocusNode();
  final ScrollController scrollController = ScrollController();
  final double imageWidth = 100;
  final double imageHeight = 100 * 1.5;
  late MoviesViewModel moviesViewModel;
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
      moviesViewModel = context.watch<MoviesViewModel>();
      moviesDetailsViewModel = context.watch<MoviesDetailsViewModel>();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await moviesViewModel.getMovies('', 1, false);
      });

      scrollController.addListener(() async {
        if (focusSearch.hasFocus) focusSearch.unfocus();

        if (!moviesViewModel.makingSearch && moviesViewModel.searchVisible) moviesViewModel.setSearchVisible(false);

        double maxListPosition = scrollController.position.maxScrollExtent;
        double currentListPosition = scrollController.position.pixels;
        double marginListPosition = 200;

        if (currentListPosition > (maxListPosition - marginListPosition) &&
            !moviesViewModel.makingRequest &&
            moviesViewModel.hasNextPage) {
          await moviesViewModel.getMovies(controllerSearch.text, moviesViewModel.page + 1, true);
        }
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (!moviesViewModel.makingSearch) moviesViewModel.setSearchVisible(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: moviesViewModel.searchVisible
              ? TextFormField(
                  controller: controllerSearch,
                  focusNode: focusSearch,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: Palette.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 15,
                    ),
                    border: InputStyle.inputBorderSearch,
                    focusedBorder: InputStyle.inputBorderSearch,
                    enabledBorder: InputStyle.inputBorderSearch,
                    suffixIconConstraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 40,
                    ),
                    suffixIcon: moviesViewModel.makingSearch
                        ? IconButton(
                            onPressed: () async {
                              controllerSearch.clear();
                              focusSearch.unfocus();
                              await moviesViewModel.getMovies('', 1, false);
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 26,
                              color: Palette.greyMedium,
                            ),
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                  ),
                  onFieldSubmitted: (String value) async {
                    await moviesViewModel.getMovies(controllerSearch.text, 1, false);
                  },
                )
              : const Text(
                  'Movies',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Palette.white,
                  ),
                ),
          leadingWidth: 70,
          leading: Container(
            width: 55,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/icon.png',
              fit: BoxFit.contain,
              width: 55,
            ),
          ),
          titleSpacing: 0,
          actions: [
            moviesViewModel.searchVisible
                ? const SizedBox(
                    width: 10,
                  )
                : IconButton(
                    onPressed: () {
                      moviesViewModel.setSearchVisible(true);
                      focusSearch.requestFocus();
                    },
                    tooltip: 'Pesquisar',
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 30,
                      color: Palette.white,
                    ),
                  ),
          ],
          backgroundColor: Palette.primary,
          elevation: 6,
          shadowColor: Palette.black,
        ),
        backgroundColor: Palette.primary,
        body: moviesViewModel.loaderVisible
            ? const Center(
                child: CircularProgressIndicator(
                  color: Palette.secondary,
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await moviesViewModel.getMovies(controllerSearch.text, 1, false);
                },
                child: !moviesViewModel.loaderVisible && moviesViewModel.movies.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top + kToolbarHeight),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
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
                                'Filmes não encontrados',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Palette.greyMedium2,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: moviesViewModel.movies.length + (moviesViewModel.hasNextPage ? 1 : 0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return index != (moviesViewModel.movies.length) // + controlHasNextPage - controlHasNextPage
                              ? Container(
                                  margin: EdgeInsets.only(top: index == 0 ? 0 : 20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFF25233D),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Palette.black,
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: IntrinsicHeight(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MoviesDetailsView(
                                              id: moviesViewModel.movies[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        surfaceTintColor: Palette.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Functions.showNetworkImageDetails(
                                                moviesViewModel.movies[index].imageUrlPoster,
                                                context,
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: EdgeInsets.zero,
                                              fixedSize: Size.fromWidth(imageWidth),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                imageUrl: moviesViewModel.movies[index].imageUrlPoster,
                                                placeholder: (context, url) => Container(
                                                  alignment: Alignment.center,
                                                  height: imageHeight,
                                                  child: const CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  alignment: Alignment.center,
                                                  height: imageHeight,
                                                  child: const Icon(
                                                    Icons.photo_outlined,
                                                    color: Palette.greyMedium2,
                                                    size: 50,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Functions.capitalFirstLetter(moviesViewModel.movies[index].title),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Palette.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
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
                                                        moviesViewModel.movies[index].voteAvg.toString(),
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
                                                      Text(
                                                        Constants.dateFormatYear
                                                            .format(moviesViewModel.movies[index].releaseDate),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Palette.greyLight,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                const Text(
                                                  'Sinapse',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Palette.greyLight,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  moviesViewModel.movies[index].description,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Palette.greyMedium2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : moviesViewModel.hasNextPage
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : null;
                        },
                      ),
              ),
      ),
    );
  }
}
