import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/services_screen.dart';
import '../../features/auth/presentation/screens/products_screen.dart';
import '../../features/auth/presentation/screens/favorites_screen.dart';
import '../../features/auth/presentation/screens/booking_screen.dart';
import '../../features/auth/presentation/screens/cart_screen.dart';
import '../../features/auth/presentation/screens/buy_screen.dart';
import '../../features/auth/presentation/screens/orders_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    final loggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (user == null && !loggingIn) return '/login';
    if (user != null && loggingIn) return '/home';

    return null;
  },

  routes: [

    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeScreen(),
    ),
GoRoute(
  path: '/orders',
  builder: (_, __) => const OrdersScreen(),
),
    GoRoute(
      path: '/services',
      builder: (_, __) => const ServicesScreen(),
    ),

    GoRoute(
      path: '/products',
      builder: (_, __) => const ProductsScreen(),
    ),

    GoRoute(
      path: '/favorites',
      builder: (_, __) => const FavoritesScreen(),
    ),
GoRoute(
  path: '/cart',
  builder: (_, __) => const CartScreen(),
),
GoRoute(
  path: '/buy',
  builder: (context, state) {
    final name = state.extra as String;
    return BuyScreen(product: name);
  },
),
    GoRoute(
      path: '/booking',
      builder: (context, state) {
        final name = state.extra as String? ?? "Service";
        return BookingScreen(serviceName: name);
      },
    ),
  ],
);