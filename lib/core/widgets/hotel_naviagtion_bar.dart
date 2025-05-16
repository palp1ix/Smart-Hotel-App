import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';

class HotelNavigationBar extends StatelessWidget {
  const HotelNavigationBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  }) : assert(items.length > 2 && items.length < 5);

  final int currentIndex;
  final List<HotelNavigationBarItem> items;
  final Function(int) onTap;

  final double kHeight = 61;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(items.length, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: _HotelNavigationBarItemWidget(
                  item: items[index],
                  isSelected: currentIndex == index,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _HotelNavigationBarItemWidget extends StatelessWidget {
  const _HotelNavigationBarItemWidget({
    required this.item,
    required this.isSelected,
  });

  final HotelNavigationBarItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item.selectedIconPath != null
            ? SvgPicture.asset(
              isSelected ? item.selectedIconPath! : item.iconPath,
              colorFilter:
                  isSelected
                      ? ColorFilter.mode(AppColors.main, BlendMode.srcIn)
                      : ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )
            : SvgPicture.asset(
              item.iconPath,
              colorFilter:
                  isSelected
                      ? ColorFilter.mode(AppColors.main, BlendMode.srcIn)
                      : ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
      ],
    );
  }
}

class HotelNavigationBarItem {
  HotelNavigationBarItem({required this.iconPath, this.selectedIconPath});

  final String iconPath;
  final String? selectedIconPath;
}
