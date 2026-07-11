import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';

import 'routes/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/settings/settings_cubit.dart';

class KidsLearningApp extends StatefulWidget {
  const KidsLearningApp({super.key});

  @override
  State<KidsLearningApp> createState() => _KidsLearningAppState();
}

class _KidsLearningAppState extends State<KidsLearningApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint("In-app update error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'seekho Basic App',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
