import 'package:auto_route/auto_route.dart';
import 'package:smart_hotel_app/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: ManagerRoute.page, path: 'manager'),
        AutoRoute(page: RestaurantRoute.page, path: 'restaurant'),
      ],
    ),
    AutoRoute(page: RegistrationRoute.page, path: '/register'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
  ];
}
