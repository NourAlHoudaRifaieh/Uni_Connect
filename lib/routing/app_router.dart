import 'package:go_router/go_router.dart';
import 'package:uni_connect/core/widgets/admin_layout_screen.dart';
import 'package:uni_connect/core/widgets/main_layout_screen.dart';
import 'package:uni_connect/features/auth/presentation/splash_screen.dart';
import 'package:uni_connect/features/feed/presentation/admin_dashboard_screen.dart';
// import 'package:uni_connect/features/feed/presentation/home_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation//register_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MainLayoutScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => AdminLayoutScreen(),
      ),
    ],
);