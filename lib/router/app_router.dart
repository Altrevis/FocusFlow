import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/ref/ref_screen.dart';
import '../screens/ref/ref_detail_screen.dart';
import '../screens/log/log_screen.dart';
import '../screens/log/log_add_screen.dart';
import '../screens/bugs/bugs_screen.dart';
import '../screens/bugs/bug_add_screen.dart';
import '../screens/courses/courses_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/ref',
          builder: (context, state) => const RefScreen(),
        ),
        GoRoute(
          path: '/log',
          builder: (context, state) => const LogScreen(),
        ),
        GoRoute(
          path: '/bugs',
          builder: (context, state) => const BugsScreen(),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const CoursesScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/ref/detail/:id',
      builder: (context, state) =>
          RefDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/log/add',
      builder: (context, state) => const LogAddScreen(),
    ),
    GoRoute(
      path: '/log/edit/:id',
      builder: (context, state) =>
          LogAddScreen(editId: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/bugs/add',
      builder: (context, state) => const BugAddScreen(),
    ),
    GoRoute(
      path: '/bugs/edit/:id',
      builder: (context, state) =>
          BugAddScreen(editId: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
