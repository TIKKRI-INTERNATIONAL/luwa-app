import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/auction_category_screen.dart';
import 'package:myapp/auction_view_screen.dart';
import 'package:myapp/dashboard_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/new_post_screen.dart';
import 'package:myapp/otp_screen.dart';
import 'package:myapp/post_view_screen.dart';
import 'package:myapp/product_registration_screen.dart';
import 'package:myapp/product_screen.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/register_screen.dart';
import 'package:myapp/signup_screen.dart';
import 'package:myapp/store_category_screen.dart';
import 'package:myapp/store_products_screen.dart';
import 'package:myapp/user_register_screen.dart';
import 'package:myapp/store_registration_screen.dart';
import 'package:myapp/auction_post_screen.dart';
import 'package:myapp/product_list_screen.dart';
import 'package:myapp/auction_list_screen.dart';
import 'package:myapp/auction_list_by_store_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/user-register',
      builder: (BuildContext context, GoRouterState state) {
        return const UserRegisterScreen();
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (BuildContext context, GoRouterState state) {
        return const OTPScreen();
      },
    ),
    GoRoute(
      path: '/product-list',
      builder: (BuildContext context, GoRouterState state) {
        return const ProductListScreen();
      },
    ),
    GoRoute(
      path: '/product/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return ProductScreen(id: id);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      path: '/stores',
      builder: (BuildContext context, GoRouterState state) {
        return const StoreCategoryScreen();
      },
    ),
    GoRoute(
      path: '/store-products/:categoryName',
      builder: (BuildContext context, GoRouterState state) {
        final categoryName = state.pathParameters['categoryName']!;
        return StoreProductsScreen(categoryName: categoryName);
      },
    ),
    GoRoute(
      path: '/auction-list',
      builder: (BuildContext context, GoRouterState state) {
        return const AuctionListScreen();
      },
    ),
    GoRoute(
      path: '/auction',
      builder: (BuildContext context, GoRouterState state) {
        return const AuctionCategoryScreen();
      },
    ),
    GoRoute(
      path: '/auction-view/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return AuctionViewScreen(id: id);
      },
    ),
    GoRoute(
      path: '/auction-post',
      builder: (BuildContext context, GoRouterState state) {
        return const AuctionPostScreen();
      },
    ),
    GoRoute(
      path: '/post-view/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return PostViewScreen(id: id);
      },
    ),
    GoRoute(
      path: '/store-registration',
      builder: (BuildContext context, GoRouterState state) {
        return const StoreRegistrationScreen();
      },
    ),
    GoRoute(
      path: '/product-registration',
      builder: (BuildContext context, GoRouterState state) {
        return const ProductRegistrationScreen();
      },
    ),
    GoRoute(
      path: '/new-post',
      builder: (BuildContext context, GoRouterState state) {
        return const NewPostScreen();
      },
    ),
    GoRoute(
      path: '/auction-list-by-store/:storeId',
      builder: (BuildContext context, GoRouterState state) {
        final storeId = state.pathParameters['storeId']!;
        return AuctionListByStoreScreen(storeId: storeId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Box Bee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
