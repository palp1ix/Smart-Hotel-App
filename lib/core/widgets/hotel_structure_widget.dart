import 'package:flutter/widgets.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

class HotelStructureWidget extends StatelessWidget {
  const HotelStructureWidget({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              subtitle != null
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getGeistText(title, weight: 550, size: 22),
                      getGeistText(
                        subtitle!,
                        weight: 550,
                        size: 14,
                        color: AppColors.onContainer,
                      ),
                    ],
                  )
                  : getGeistText(title, weight: 550, size: 22),

              const Spacer(),
              trailing ?? SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 15),
          Expanded(child: child),
        ],
      ),
    );
  }
}
