import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otakudesu/bloc/anime_complete_bloc.dart';
import 'package:otakudesu/bloc/anime_on_going_bloc.dart';
import 'package:otakudesu/data/repository/anime_repository.dart';
import 'package:otakudesu/helper/constant.dart';
import 'package:otakudesu/widget/anime_card.dart';
import 'package:otakudesu/widget/loading_widget.dart';
import 'package:search_page/search_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otakudesu"),
        actions: [
          IconButton(
            onPressed: () async {
              final animeList = await AnimeRepository().findAnimeList();

              // Getting data from anime-list
              showSearch(
                context: context,
                delegate: SearchPage(
                  onQueryUpdate: print,
                  items: animeList,
                  searchLabel: 'Search Anime',
                  suggestion: const Center(
                    child: Text('Search Anime'),
                  ),
                  failure: const Center(
                    child: Text('No Anime Found'),
                  ),
                  filter: (anime) => [anime.title],
                  sort: (a, b) => a.title.compareTo(b.title),
                  builder: (anime) => ListTile(
                    title: Text(anime.title),
                    onTap: () => GoRouter.of(context).push('/anime/${anime.id}'),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: kDefaultLargePaddingSize,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final animeList = await AnimeRepository().findAnimeList();

                      // Getting data from anime-list
                      showSearch(
                        context: context,
                        delegate: SearchPage(
                          onQueryUpdate: print,
                          items: animeList,
                          searchLabel: 'Search Anime',
                          suggestion: const Center(
                            child: Text('Search Anime'),
                          ),
                          failure: const Center(
                            child: Text('No Anime Found'),
                          ),
                          filter: (anime) => [anime.title],
                          sort: (a, b) => a.title.compareTo(b.title),
                          builder: (anime) => ListTile(
                            title: Text(anime.title),
                            onTap: () => GoRouter.of(context).push('/anime/${anime.id}'),
                          ),
                        ),
                      );
                    },
                    child: const Chip(
                      label: Text('Search'),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(width: kDefaultLargePaddingSize.left),
                  InkWell(
                    onTap: () => GoRouter.of(context).push('/anime-list'),
                    child: const Chip(
                      label: Text('Anime List'),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(width: kDefaultLargePaddingSize.left),
                  InkWell(
                    onTap: () {
                      AnimeRepository().findAnimeByGenre('action', 1);
                    },
                    child: const Chip(
                      label: Text('Genre List'),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(width: kDefaultLargePaddingSize.left),
                  const Chip(
                    label: Text('Bookmark'),
                    padding: EdgeInsets.all(0),
                  ),
                ],
              ),
              SizedBox(height: kDefaultSmallPaddingSize.left),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text('On-Going Anime', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AnimeOnGoingBloc>().add(AnimeOnGoingFetched());
                      GoRouter.of(context).push('/anime/ongoing');
                    },
                    child: const Text('More'),
                  ),
                ],
              ),
              SizedBox(height: kDefaultLargePaddingSize.left),
              FutureBuilder(
                future: AnimeRepository().findHomePage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }
                  final data = snapshot.data!;

                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: kDefaultSmallPaddingSize.vertical,
                        mainAxisSpacing: kDefaultSmallPaddingSize.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          data.length ~/ 2,
                          (index) => AnimeCard(
                            anime: data[index],
                            onTap: () {
                              GoRouter.of(context).push('/anime/${data[index].id}');
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: kDefaultSmallPaddingSize.left),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Text('Complete Anime', style: Theme.of(context).textTheme.titleMedium),
                          ),
                          TextButton(
                              onPressed: () {
                                context.read<AnimeCompleteBloc>().add(AnimeCompleteFetched());
                                GoRouter.of(context).push('/anime/complete');
                              },
                              child: const Text('More'))
                        ],
                      ),
                      SizedBox(height: kDefaultLargePaddingSize.left),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: kDefaultSmallPaddingSize.vertical,
                        mainAxisSpacing: kDefaultSmallPaddingSize.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          data.length ~/ 2,
                          (index) => AnimeCard(
                            anime: data[index * 2],
                            onTap: () {
                              GoRouter.of(context).push('/anime/${data[index * 2].id}');
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
