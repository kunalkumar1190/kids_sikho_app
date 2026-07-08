import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/alphabet/presentation/alphabet_page.dart';
import '../../features/numbers/presentation/numbers_page.dart';

import '../../features/colors/presentation/colors_page.dart';
import '../../features/shapes/presentation/shapes_page.dart';
import '../../features/animals/presentation/animals_page.dart';
import '../../features/fruits/presentation/fruits_page.dart';
import '../../features/stories/presentation/stories_page.dart';
import '../../features/drawing/presentation/drawing_page.dart';

import '../../features/games/presentation/games_page.dart';
import '../../features/games/presentation/balloon_pop_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/games/presentation/memory_match_page.dart';
import '../../features/games/presentation/listen_and_find_page.dart';
import '../../features/games/presentation/match_the_following_page.dart';
import '../../features/homework/presentation/tracing_page.dart';
import '../../features/homework/bloc/homework_bloc.dart';
import '../../features/homework/bloc/homework_event.dart';

class Routes {
  static const String home = "/";
  static const String alphabet = "/alphabet";
  static const String numbers = "/numbers";
  static const String colors = "/colors";
  static const String shapes = "/shapes";
  static const String animals = "/animals";
  static const String fruits = "/fruits";
  static const String stories = "/stories";
  static const String drawing = "/drawing";
  static const String games = "/games";
  static const String balloonPop = "/games/balloon";
  static const String memoryMatch = "/games/memory";
  static const String findIt = "/games/find_it";
  static const String matchFollowing = "/games/match";
  static const String homework = "/homework";
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(path: Routes.home, builder: (context, state) => HomePage()),
      GoRoute(
        path: Routes.alphabet,
        builder: (context, state) => const AlphabetPage(),
      ),
      GoRoute(
        path: Routes.numbers,
        builder: (context, state) => const NumbersPage(),
      ),
      GoRoute(
        path: Routes.colors,
        builder: (context, state) => const ColorsPage(),
      ),
      GoRoute(
        path: Routes.shapes,
        builder: (context, state) => const ShapesPage(),
      ),
      GoRoute(
        path: Routes.animals,
        builder: (context, state) => const AnimalsPage(),
      ),
      GoRoute(
        path: Routes.fruits,
        builder: (context, state) => const FruitsPage(),
      ),
      GoRoute(
        path: Routes.stories,
        builder: (context, state) => const StoriesPage(),
      ),
      GoRoute(
        path: Routes.drawing,
        builder: (context, state) => const DrawingPage(),
      ),
      GoRoute(
        path: Routes.games,
        builder: (context, state) => const GamesPage(),
      ),
      GoRoute(
        path: Routes.balloonPop,
        builder: (context, state) => const BalloonPopPage(),
      ),
      GoRoute(
        path: Routes.memoryMatch,
        builder: (context, state) => const MemoryMatchPage(),
      ),
      GoRoute(
        path: Routes.findIt,
        builder: (context, state) => const ListenAndFindPage(),
      ),
      GoRoute(
        path: Routes.matchFollowing,
        builder: (context, state) => const MatchTheFollowingPage(),
      ),
      GoRoute(
        path: Routes.homework,
        builder: (context, state) => BlocProvider(
          create: (context) => HomeworkBloc()..add(LoadHomeworkEvent()),
          child: const TracingPage(),
        ),
      ),
    ],
  );
}
