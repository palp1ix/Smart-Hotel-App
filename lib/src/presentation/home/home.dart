import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/widgets/hotel_structure_widget.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart';
import 'package:smart_hotel_app/src/presentation/home/widgets/quick_action.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listScenes = {
    'Reading': 'assets/icons/book.svg',
    'Relax': 'assets/icons/bed.svg',
    'Brightly': 'assets/icons/sunrise.svg',
    'Romantic': 'assets/icons/heart.svg',
    'Film': 'assets/icons/tv.svg',
    'Sunrise': 'assets/icons/sunrise.svg',
  };

  final _listActions = [
    QuickActionModel(
      title: 'Lightning',
      subtitle: '6 lights',
      iconPath: 'assets/icons/lightbulb.max.svg',
    ),
    QuickActionModel(
      title: 'Manage room',
      subtitle: '204',
      iconPath: 'assets/icons/arrow.up.rightsvg.svg',
    ),
    QuickActionModel(
      title: 'Sound',
      subtitle: '3 devices',
      iconPath: 'assets/icons/play.house.svg',
    ),
  ];

  int _selectedItemIndex = -1;
  @override
  Widget build(BuildContext context) {
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
                ],
              ),
              SizedBox(height: 20),
              UserInfoCard(
                userInfo: UserInfo(
                  name: 'Artem',
                  temperature: 30.2,
                  doorClosed: true,
                  room: '204',
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 171,
                child: HotelStructureWidget(
                  title: 'Quick Actions',
                  trailing: HotelTextButton(onPressed: () {}, text: 'See all'),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _listActions.length,
                      itemBuilder: (context, index) {
                        final title = _listActions[index].title;
                        final subtitle = _listActions[index].subtitle;
                        final iconPath = _listActions[index].iconPath;

                        return QuickActionContainer(
                          title: title,
                          subtitle: subtitle,
                          iconPath: iconPath,
                          isSelected: true,
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
                  trailing: HotelTextButton(onPressed: () {}, text: 'See all'),
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
  const UserInfoCard({super.key, required this.userInfo});

  final UserInfo userInfo;

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Column(
                    children: [
                      getGeistText(
                        userInfo.name,
                        weight: 600,
                        size: 22,
                        color: Colors.white,
                      ),
                      getGeistText(
                        'Name',
                        weight: 600,
                        size: 16,
                        color: AppColors.onContainer,
                      ),
                    ],
                  ),
                  SizedBox.shrink(),
                  SizedBox.shrink(),

                  Column(
                    children: [
                      getGeistText(
                        userInfo.room,
                        weight: 600,
                        size: 24,
                        color: AppColors.main,
                      ),
                      getGeistText(
                        'Room ',
                        weight: 600,
                        size: 16,
                        color: AppColors.onContainer,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      getGeistText(
                        '${userInfo.temperature}°C',
                        weight: 600,
                        size: 20,
                        color: Colors.white,
                      ),
                      getGeistText(
                        'Temperature',
                        weight: 600,
                        size: 16,
                        color: AppColors.onContainer,
                      ),
                    ],
                  ),
                  SizedBox.shrink(),
                  SizedBox.shrink(),
                  SizedBox.shrink(),

                  Column(
                    children: [
                      getGeistText(
                        userInfo.doorClosed ? 'Closed' : 'Open',
                        weight: 600,
                        size: 20,
                        color: Colors.white,
                      ),
                      getGeistText(
                        'Door',
                        weight: 600,
                        size: 16,
                        color: AppColors.onContainer,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              HotelPrimaryButton(
                title: 'Open door',
                color: AppColors.onContainer,
                onPressed: () {},
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo {
  UserInfo({
    required this.name,
    required this.temperature,
    required this.doorClosed,
    required this.room,
  });

  final String name;
  final double temperature;
  final bool doorClosed;
  final String room;
}
