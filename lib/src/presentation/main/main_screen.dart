import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/hotel_naviagtion_bar.dart';
import 'package:smart_hotel_app/router/router.gr.dart';
import 'package:smart_hotel_app/src/data/models/reservation/reservation.dart';
import 'package:smart_hotel_app/src/data/models/user/user.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [HomeRoute(), ManagerRoute(), RestaurantRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final List<HotelNavigationBarItem> items = [
          HotelNavigationBarItem(iconPath: AppIcons.home),
          HotelNavigationBarItem(iconPath: AppIcons.squareGrid),
          HotelNavigationBarItem(iconPath: AppIcons.food),
        ];
        return Stack(
          children: [
            UserInfoWidget(child: child),
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: HotelNavigationBar(
                  items: items,
                  currentIndex: tabsRouter.activeIndex,
                  onTap: (index) {
                    tabsRouter.setActiveIndex(index);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class UserInfoWidget extends InheritedWidget {
  const UserInfoWidget({
    super.key,
    this.user,
    this.reservation,
    required super.child,
  });

  final User? user;
  final Reservation? reservation;

  static UserInfoWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserInfoWidget>()!;
  }

  @override
  bool updateShouldNotify(UserInfoWidget oldWidget) {
    return reservation?.apartmentId != oldWidget.reservation?.apartmentId ||
        user?.email != oldWidget.user?.email;
  }
}
