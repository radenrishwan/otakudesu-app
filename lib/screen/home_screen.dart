import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                      AnimeRepository().findEpisodeDetail('smmr-episode-25-sub-indo');
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
              SizedBox(
                child: Text('Homepage', style: Theme.of(context).textTheme.titleLarge),
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

                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: kDefaultSmallPaddingSize.vertical,
                    mainAxisSpacing: kDefaultSmallPaddingSize.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      data.length,
                      (index) => AnimeCard(
                        anime: data[index],
                        onTap: () {
                          GoRouter.of(context).push('/anime/${data[index].id}');
                        },
                      ),
                    ),
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
