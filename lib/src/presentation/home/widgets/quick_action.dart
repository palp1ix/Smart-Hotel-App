import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

class QuickActionContainer extends StatelessWidget {
  const QuickActionContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.isSelected,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconPath;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 141,
        height: 120,
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main : AppColors.container,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected ? AppColors.onMain : AppColors.onContainer,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      width: 23,
                      height: 23,

                      iconPath,
                      colorFilter: ColorFilter.mode(
                        isSelected ? Colors.black : Colors.white,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.scaleDown, // Добавлено свойство fit
                    ),
                  ),
                ),
              ),
              getGeistText(
                title,
                weight: 600,
                color: isSelected ? Colors.black : Colors.white,
              ),
              getGeistText(
                subtitle,
                weight: 400,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionModel {
  QuickActionModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconPath;
  final bool isSelected;
  final VoidCallback? onTap;
}
