import 'package:auto_route/auto_route.dart';
import 'package:smart_hotel_app/managers/auth_service.dart';
import 'package:smart_hotel_app/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainRoute.page,
      path: '/',
      guards: [MainGuard()],
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: ManagerRoute.page, path: 'manager'),
        AutoRoute(page: RestaurantRoute.page, path: 'restaurant'),
      ],
    ),
    AutoRoute(page: RegistrationRoute.page, path: '/register'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: CombinedReservationRoute.page, path: '/reservation'),
    AutoRoute(page: LoadingRoute.page, path: '/loading'),
  ];
}

class MainGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if the user is authenticated
    final authManager = AuthService();

    if (authManager.isAuntificated) {
      resolver.next();
    } else {
      router.push(LoginRoute());
    }
  }
}
