import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart'; // Assuming AppColors.main is defined here
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart'; // Assuming getGeistText is defined here

enum RoomType { studio, standart, family, luxury }

enum Categories { economy, business, premium, penthouse }

class RoomData {
  final String imagePath;
  final String description;
  final RoomType roomType;
  final Categories category;

  RoomData({
    required this.imagePath,
    required this.description,
    required this.roomType,
    required this.category,
  });
}

@RoutePage()
class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<RoomData> roomOptions = [
    RoomData(
      imagePath: 'assets/images/luxury_room.png',
      description:
          'A luxurious hotel room offering an elegant blend of modern design and opulent comfort, featuring premium amenities and breathtaking views.',
      roomType: RoomType.luxury,
      category: Categories.business,
    ),
    RoomData(
      imagePath: 'assets/images/family_room.png',
      description:
          'Spacious family-friendly room with extra beds and child-safe facilities, perfect for groups or families traveling together.',
      roomType: RoomType.family,
      category: Categories.premium,
    ),
    RoomData(
      imagePath: 'assets/images/standart_room.png',
      description:
          'Comfortable and cozy standard room equipped with all essential amenities for a relaxing stay.',
      roomType: RoomType.standart,
      category: Categories.economy,
    ),
    // Add more room options if needed to test scrolling
  ];

  int currentIndex = -1;
  String currentDescription = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // You can customize your AppBar further
        backgroundColor: AppColors.background,
        toolbarHeight: 0, // Уменьшаем высоту AppBar
        surfaceTintColor: AppColors.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: getGeistText('Choose your room type', size: 20, weight: 550),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 20,
              ), // Padding at the end of scroll view
              child: Column(
                children: [
                  ...List.generate(roomOptions.length, (index) {
                    final currentData = roomOptions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ), // Slight reduction in padding from RoomTypeWidget margin
                      child: RoomTypeWidget(
                        imagePath: currentData.imagePath,
                        description: currentData.description,
                        roomType: currentData.roomType,
                        category: currentData.category,
                        isSelected: currentIndex == index,
                        onTap: (description) {
                          setState(() {
                            if (currentIndex == index) {
                              // Optional: Deselect if tapping the same item
                              // currentIndex = -1;
                              // currentDescription = "";
                            } else {
                              currentIndex = index;
                              currentDescription = description;
                            }
                          });
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 15), // Spacing before description
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0, // Animates opening from the top
                          child: child,
                        ),
                      );
                    },
                    child:
                        currentDescription.isNotEmpty
                            ? DescriptionWidget(
                              // Using ValueKey ensures AnimatedSwitcher properly animates
                              // when the description content changes.
                              key: ValueKey<String>(currentDescription),
                              description: currentDescription,
                            )
                            // Use a non-empty SizedBox with a key for the "empty" state
                            // if you want AnimatedSwitcher to animate out the old widget.
                            // Otherwise, SizedBox.shrink() is fine.
                            : SizedBox.shrink(
                              key: ValueKey<String>("empty_description"),
                            ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed bottom placeholder
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 40,
              top: 10,
            ),
            child: HotelPrimaryButton(
              title: 'Continue',
              textWeight: 500,
              onPressed: () {},
              color:
                  currentIndex != -1
                      ? AppColors.main
                      : AppColors.secondContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  final String description;

  const DescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: double.infinity, // Ensure it takes available width
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          // border: Border.all(color: Colors.grey[300]!) // Optional subtle border
        ),
        child: getGeistText(
          description,
          size: 14,
          weight: 400, // Geist regular
        ),
      ),
    );
  }
}

class RoomTypeWidget extends StatelessWidget {
  const RoomTypeWidget({
    super.key,
    required this.imagePath,
    required this.description,
    required this.roomType,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final String imagePath;
  final String description;
  final RoomType roomType;
  final Categories category;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(description),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: isSelected ? 10 : 20, // Original: 10 : 20
          vertical:
              isSelected
                  ? 8
                  : 10, // Original: 5 : 10. Adjusted for slightly more breathing room.
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          border:
              isSelected
                  ? Border.all(
                    color: AppColors.main,
                    width: 2.5, // Slightly thicker border for more emphasis
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                  : null,
          boxShadow:
              isSelected
                  ? [
                    // Add a subtle shadow when selected for depth
                    BoxShadow(
                      color: AppColors.main.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : [
                    BoxShadow(
                      // Default subtle shadow
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
        ),
        width: double.infinity,
        height: 120,
        duration: Duration(milliseconds: 200), // Slightly faster animation
        child: Container(
          width: double.infinity,
          height: 120, // Match parent height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              18,
            ), // Match parent's effective radius
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(
                  0.85,
                ), // Darker for better text contrast
                Colors.black.withOpacity(0.05),
              ], // Adjusted alpha
              stops: [0.0, 0.7], // Gradient stops for smoother transition
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
              left: 20,
              right: 20,
            ), // Adjusted padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getGeistText(
                  // Capitalize first letter of roomType name
                  roomType.name[0].toUpperCase() + roomType.name.substring(1),
                  size: 18,
                  weight: 600,
                  color: Colors.white, // Ensure text is white
                ),
                SizedBox(height: 2),
                getGeistText(
                  // Capitalize first letter of category name
                  category.name[0].toUpperCase() + category.name.substring(1),
                  size: 13, // Slightly smaller size for category
                  weight: 500, // Medium weight
                  color: Colors.white.withOpacity(
                    0.85,
                  ), // Slightly less prominent
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
