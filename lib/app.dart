import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nasi_cleaning/screens/home_screen.dart';
import 'package:nasi_cleaning/screens/services_screen.dart';
import 'package:nasi_cleaning/screens/splash_screen.dart';
import 'package:nasi_cleaning/screens/login_screen.dart';
import 'package:nasi_cleaning/screens/orders_screen.dart';
import 'package:nasi_cleaning/screens/profile_screen.dart';
import 'package:nasi_cleaning/screens/not_found.dart';
import 'package:nasi_cleaning/screens/customer_orders_screen.dart';
import 'package:nasi_cleaning/screens/customer_cart_screen.dart';
import 'package:nasi_cleaning/screens/customer_checkout_screen.dart';
import 'package:nasi_cleaning/screens/vendor_screen.dart';
import 'package:nasi_cleaning/screens/order_screen_detail.dart';
import 'providers/auth_provider.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/top_navigation.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Nasi Cleaning Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      routerConfig: _router(ref),
    );
  }
}

GoRouter _router(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.user != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute && state.matchedLocation != '/splash') {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          );
        },
      ),
      ShellRoute(
        pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: TopNavigation(
                  showUser: true,
                  showBack: true,
                ),
              ),
              body: child,
              bottomNavigationBar: const BottomNavigation(),
            ),
          );
        },
        routes: <RouteBase>[
          // Home screen with nested routes
          GoRoute(
            path: '/home',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const HomeScreen(),
              );
            },
            routes: [
              GoRoute(
                path: 'vendors',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: const VendorsScreen(),
                  );
                },
              ),
            ],
          ),
          // In your router configuration
          GoRoute(
            path: '/home/vendors/:vendorId/services',
            builder: (context, state) {
              final vendorId = state.pathParameters['vendorId']!;
              return ServicesScreen(vendorId: vendorId);
            },
          ),

          // Cart screen
          GoRoute(
            path: '/cart',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const CustomerCartScreen(),
              );
            },
          ),

          // Checkout screen
          GoRoute(
            path: '/checkout',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const CustomerCheckoutScreen(),
              );
            },
          ),

          // Customer orders screen with nested order details
          GoRoute(
            path: '/customer-orders',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const CustomerOrdersScreen(),
              );
            },
            routes: [
              GoRoute(
                path: ':orderId',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final orderId = state.pathParameters['orderId']!;
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: OrderDetailsScreen(orderId: orderId),
                  );
                },
              ),
            ],
          ),

          // Vendor orders screen
          GoRoute(
            path: '/orders',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const OrdersScreen(),
              );
            },
          ),

          // Payment screen


          // Profile screen
          GoRoute(
            path: '/profile',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const ProfileScreen(),
              );
            },
          ),

          // Earning screen


          // Map screen

        ],
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      return MaterialPage<void>(
        key: state.pageKey,
        child: Scaffold(
          body: const NotFoundPage(),
          bottomNavigationBar: const BottomNavigation(),
        ),
      );
    },
  );
}