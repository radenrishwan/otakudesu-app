import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:otakudesu/screen/anime_detail_screen.dart';
import 'package:otakudesu/screen/anime_list_screen.dart';
import 'package:otakudesu/screen/episode_detail_sceen.dart';
import 'package:otakudesu/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(InitialApp());
}

class InitialApp extends StatelessWidget {
  InitialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Otakudesu',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue.shade200,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.blue.shade200,
        ),
      ),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/anime-list',
        builder: (BuildContext context, GoRouterState state) {
          return const AnimeListScreen();
        },
      ),
      GoRoute(
        path: '/anime/:id',
        builder: (BuildContext context, GoRouterState state) {
          String id = state.params['id']!;

          return AnimeDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/episode/:id/:title',
        builder: (BuildContext context, GoRouterState state) {
          String id = state.params['id']!;
          String title = state.params['title']!;

          return EpisodeDetailScreen(id: id, title: title);
        },
      )
    ],
  );
}
