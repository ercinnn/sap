import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_placeholder_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPlaceholderScreen(),
    ),
  ],
);
