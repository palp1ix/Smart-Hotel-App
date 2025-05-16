import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Stack(
          children: [
            child,
            // TODO: Navbar
          ],
        );
      },
    );
  }
}
