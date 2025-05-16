import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/hotel_naviagtion_bar.dart';
import 'package:smart_hotel_app/router/router.gr.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [HomeRoute(), ManagerRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final List<HotelNavigationBarItem> items = [
          HotelNavigationBarItem(iconPath: AppIcons.home),
          HotelNavigationBarItem(iconPath: AppIcons.squareGrid),
          HotelNavigationBarItem(iconPath: AppIcons.food),
        ];
        return Stack(
          children: [
            child,
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
