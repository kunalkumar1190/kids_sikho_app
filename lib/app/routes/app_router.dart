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
    ],
  );
}
