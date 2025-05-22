import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
// Assuming getGeistText is defined in fonts.dart or widgets.dart
// If it's in fonts.dart:
import 'package:smart_hotel_app/core/fonts/fonts.dart';
// If it's in widgets.dart (and re-exports fonts or defines it directly):
import 'package:smart_hotel_app/core/widgets/widgets.dart';
import 'package:smart_hotel_app/core/widgets/hotel_structure_widget.dart';
import 'package:smart_hotel_app/managers/auth_service.dart';
import 'package:smart_hotel_app/managers/backend_service.dart';
import 'package:smart_hotel_app/managers/blue_manager.dart';
import 'package:smart_hotel_app/router/router.gr.dart';
import 'package:smart_hotel_app/src/data/models/reservation/reservation.dart';
import 'package:smart_hotel_app/src/data/models/user/user.dart';
import 'package:smart_hotel_app/src/presentation/home/widgets/quick_action.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.user, this.reservation});

  final User? user;
  final Reservation? reservation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final User _currentUser;
  final _listScenes = {
    'Reading': 'assets/icons/book.svg',
    'Relax': 'assets/icons/bed.svg',
    'Brightly': 'assets/icons/sunrise.svg',
    'Romantic': 'assets/icons/heart.svg',
    'Film': 'assets/icons/tv.svg',
    'Sunrise': 'assets/icons/sunrise.svg',
  };

  bool isSelected = false;

  bool isDoorClosed = true;

  int _selectedItemIndex = -1;

  @override
  void initState() {
    super.initState();
    final authService = AuthService();
    _currentUser = authService.currentUser ?? User(email: 'email@com');
  }

  @override
  Widget build(BuildContext context) {
    final listActions = [
      QuickActionModel(
        title: 'Lightning',
        subtitle: '6 lights',
        iconPath: 'assets/icons/lightbulb.max.svg',
        isSelected: isSelected,
        onTap: () {
          setState(() {
            final blueManager = GetIt.I<BlueManager>();
            isSelected ? blueManager.turnLightOff() : blueManager.turnLightOn();
            isSelected = !isSelected;
          });
        },
      ),
      QuickActionModel(
        title: 'Generate link',
        subtitle: 'Link for open door',
        iconPath: 'assets/icons/link.svg',
        onTap: () async {
          final backendService = BackendService();
          final link = await backendService.generateLink();
          if (link != null) {
            await Share.shareUri(Uri.parse(link));
          }
        },
      ),
      QuickActionModel(
        title: 'Manage room',
        subtitle: '204',
        iconPath: 'assets/icons/arrow.up.rightsvg.svg',
        onTap: () => AutoTabsRouter.of(context).setActiveIndex(1),
      ),
      QuickActionModel(
        title: 'Sound',
        subtitle: '3 devices',
        iconPath: 'assets/icons/play.house.svg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 20),
                  getGeistText(
                    'Hello, ',
                    weight: 600,
                    color: Colors.white,
                    size: 24,
                  ),
                  getGeistText(
                    'Guest',
                    weight: 600,
                    color: AppColors.main,
                    size: 24,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final authManager = AuthService();
                      await authManager.signOut();
                      context.router.replace(LoginRoute());
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/icons/minus.svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20),
              UserInfoCard(
                userInfo: UserInfo(
                  name: _currentUser.firstName ?? "John",
                  surname: _currentUser.lastName ?? 'Wickendov',
                  temperature: 30.2,
                  doorClosed: isDoorClosed,
                  room: '204',
                ),
                onTap: () {
                  setState(() {
                    isDoorClosed = !isDoorClosed;
                  });
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 171,
                child: HotelStructureWidget(
                  title: 'Quick Actions',
                  trailing: HotelTextButton(
                    onPressed: () {
                      context.router.push(LoadingRoute());
                    },
                    text: 'See all',
                  ),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listActions.length,
                      itemBuilder: (context, index) {
                        final title = listActions[index].title;
                        final subtitle = listActions[index].subtitle;
                        final iconPath = listActions[index].iconPath;
                        final isSelected = listActions[index].isSelected;
                        final onTap = listActions[index].onTap;

                        return QuickActionContainer(
                          title: title,
                          subtitle: subtitle,
                          iconPath: iconPath,
                          isSelected: isSelected,
                          onTap: onTap,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 300,
                child: HotelStructureWidget(
                  title: 'Scenes',
                  trailing: HotelTextButton(
                    onPressed: () {
                      context.router.push(LoadingRoute());
                    },
                    text: 'See all',
                  ),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      childAspectRatio: 114 / 81,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _listScenes.length,
                    itemBuilder: (context, index) {
                      final title = _listScenes.keys.toList()[index];
                      final iconPath =
                          _listScenes.entries.toList()[index].value;
                      return HotelButtonContainer(
                        index: index,
                        isSelected: _selectedItemIndex == index,
                        onTap: (buttonIndex) {
                          setState(() {
                            // OFF
                            if (buttonIndex == _selectedItemIndex) {
                              _selectedItemIndex = -1;
                            } else {
                              _selectedItemIndex = buttonIndex;
                            }
                          });
                        },
                        width: 114,
                        height: 81,
                        iconPath: iconPath,
                        text: title,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key, required this.userInfo, this.onTap});

  final UserInfo userInfo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 207,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.secondContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InfoItemWidget(value: userInfo.name, label: 'Name'),
                  SizedBox(width: 40),
                  InfoItemWidget(
                    value: userInfo.surname,
                    label:
                        'Name', // As per original code, consider changing to 'Surname'
                  ),
                  SizedBox(width: 30),
                  InfoItemWidget(
                    value: userInfo.room,
                    label: 'Room ',
                    valueSize: 24,
                    valueColor: AppColors.main,
                    alignment:
                        CrossAxisAlignment.center, // To match original layout
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoItemWidget(
                    value: '${userInfo.temperature}°C',
                    label: 'Temperature',
                    valueSize: 20,
                  ),
                  SizedBox(width: 30),
                  InfoItemWidget(
                    value: userInfo.doorClosed ? 'Closed' : 'Open',
                    label: 'Door',
                    valueSize: 20,
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  try {
                    final blueManager = GetIt.I<BlueManager>();
                    userInfo.doorClosed
                        ? await blueManager.openDoor()
                        : await blueManager.closeDoor();
                  } catch (e) {}
                  onTap?.call();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: double.infinity,
                  height: 48,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      getGeistText(
                        userInfo.doorClosed ? 'Open door' : 'Close door',
                        weight: 600,
                        size: 17,
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.all(4),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.onMain,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            fit: BoxFit.contain,
                            'assets/icons/key.svg',
                            // ignore: deprecated_member_use
                            color:
                                Colors.white, // For older flutter_svg versions
                            // colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn), // For newer versions
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable widget to display a value and its corresponding label.
class InfoItemWidget extends StatelessWidget {
  const InfoItemWidget({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = Colors.white,
    this.valueSize = 22.0,
    this.valueWeight = 600,
    this.alignment = CrossAxisAlignment.start,
  });

  final String value;
  final String label;
  final Color valueColor;
  final double valueSize;
  final int valueWeight;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        getGeistText(
          value,
          weight: valueWeight.toDouble(),
          size: valueSize,
          color: valueColor,
        ),
        getGeistText(
          label,
          weight: 600, // Consistent label style
          size: 16, // Consistent label style
          color: AppColors.onContainer, // Consistent label style
        ),
      ],
    );
  }
}

class UserInfo {
  UserInfo({
    required this.name,
    required this.surname,
    required this.temperature,
    required this.doorClosed,
    required this.room,
  });

  final String name;
  final String surname;
  final double temperature;
  final bool doorClosed;
  final String room;
}
