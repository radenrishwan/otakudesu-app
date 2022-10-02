import 'dart:convert';
import 'dart:developer';

import 'package:otakudesu/data/models/anime.dart';
import 'package:http/http.dart' as http;
import 'package:otakudesu/data/models/anime_detail.dart';
import 'package:otakudesu/data/models/anime_list.dart';
import 'package:otakudesu/data/models/episode.dart';
import 'package:otakudesu/data/models/episode_detail.dart';

class AnimeRepository {
  static final AnimeRepository _instance = AnimeRepository._();

  factory AnimeRepository() {
    return _instance;
  }

  AnimeRepository._();

  Future<List<Anime>> findHomePage() async {
    final response = await http.get(Uri.parse('https://scraping-2wepigvexa-et.a.run.app/api/home'));
    final List<Anime> result = [];

    if (response.statusCode > 200) {
      // TODO: handle error
      log('error : ${response.statusCode}');
    }

    final data = jsonDecode(response.body)['data'] as List<dynamic>;
    for (var element in data) {
      result.add(Anime.fromJson(element));
    }

    return result;
  }

  Future<AnimeDetail> findAnimeDetail(String id) async {
    final response = await http.get(Uri.parse('https://scraping-2wepigvexa-et.a.run.app/api/anime/$id'));

    if (response.statusCode > 200) {
      // TODO: handle error
      log('error : ${response.statusCode}');
    }

    final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
    var result = AnimeDetail.fromJson(data);

    data['episode'].forEach((element) {
      result.episode.add(Episode.fromJson(element));
    });

    return result;
  }

  Future<EpisodeDetail> findEpisodeDetail(String id) async {
    final response = await http.get(Uri.parse('https://scraping-2wepigvexa-et.a.run.app/api/episode/$id'));

    if (response.statusCode > 200) {
      // TODO: handle error
      log('error : ${response.statusCode}');
    }

    final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
    var result = EpisodeDetail.fromJson(data);

    return result;
  }

  Future<List<AnimeList>> findAnimeList() async {
    final response = await http.get(Uri.parse('https://scraping-2wepigvexa-et.a.run.app/api/anime-list'));
    final List<AnimeList> result = [];

    if (response.statusCode > 200) {
      // TODO: handle error
      log('error : ${response.statusCode}');
    }

    final data = jsonDecode(response.body)['data'] as List<dynamic>;
    for (var element in data) {
      result.add(AnimeList.fromJson(element));
    }

    return result;
  }
}
