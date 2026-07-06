import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes/app_router.dart';
import '../core/theme/app_theme.dart';

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kids Learning',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
