import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/widgets/hotel_icon_switch.dart';
import 'package:smart_hotel_app/core/widgets/hotel_structure_widget.dart';

class RestaurantItemData {
  final String imagePath;
  final String name;
  final String weightOfFood;
  final double rating;

  RestaurantItemData({
    required this.imagePath,
    required this.name,
    required this.weightOfFood,
    required this.rating,
  });
}

// Mock data list
final List<RestaurantItemData> mockRestaurantItems = [
  RestaurantItemData(
    imagePath: 'assets/images/food1.png',
    name: 'Holiday Salad',
    weightOfFood: '400g',
    rating: 4.8,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food2.png',
    name: 'Caesar Salad',
    weightOfFood: '350g',
    rating: 4.5,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food3.png',
    name: 'Grilled Salmon',
    weightOfFood: '500g',
    rating: 4.9,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food4.png',
    name: 'Pasta Carbonara',
    weightOfFood: '450g',
    rating: 4.7,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food5.png',
    name: 'Cheeseburger',
    weightOfFood: '550g',
    rating: 4.6,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food6.png',
    name: 'Margherita Pizza',
    weightOfFood: '600g',
    rating: 4.4,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food7.png',
    name: 'Steak Frites',
    weightOfFood: '650g',
    rating: 4.9,
  ),
  RestaurantItemData(
    imagePath: 'assets/images/food8.png',
    name: 'Chocolate Cake',
    weightOfFood: '250g',
    rating: 4.3,
  ),
];

@RoutePage()
class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Expanded(
              child: HotelStructureWidget(
                title: 'Restaurant', // Corrected typo: Restaraunt -> Restaurant
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 164 / 200,
                  ),
                  itemCount:
                      mockRestaurantItems.length, // Use the length of mock data
                  itemBuilder: (context, index) {
                    final item =
                        mockRestaurantItems[index]; // Get item from mock data
                    return RestaurantContainer(
                      imagePath: item.imagePath,
                      name: item.name,
                      weightOfFood: item.weightOfFood,
                      rating: item.rating,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantContainer extends StatelessWidget {
  const RestaurantContainer({
    super.key,
    required this.imagePath,
    required this.name,
    required this.weightOfFood,
    required this.rating,
  });

  final String imagePath;
  final String name;
  final String weightOfFood;
  final double rating;

  @override
  Widget build(BuildContext context) {
    Widget nameWidget = getGeistText(name, size: 18, weight: 600);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.secondContainer,
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 4.0,
                top: 4.0,
                bottom: 4.0,
              ), // Немного асимметричный padding для кнопки
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    // Этот Expanded для Column с текстом
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Оборачиваем виджет имени в Flexible, чтобы он не выталкивал кнопку
                        Flexible(
                          child:
                              nameWidget, // Используем nameWidget, который должен быть настроен на ellipsis
                        ),
                        const SizedBox(height: 0),
                        Row(
                          children: [
                            getGeistText(
                              weightOfFood,
                              color: AppColors.onContainer,
                              weight: 600,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.star,
                              color: AppColors.onContainer,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            getGeistText(
                              rating.toString(),
                              color: AppColors.onContainer,
                              weight: 600,
                              size: 13,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(width: 8) было здесь, но лучше дать Expanded больше места
                  HotelIconSwitch(
                    isSelected: true,
                    onSelect: () {},
                    onUnSelect: () {},
                    iconPath: 'assets/icons/plus.svg',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
