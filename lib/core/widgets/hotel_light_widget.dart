import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart'; // Assuming HotelSlider, HotelIconSwitch are here

// Ensure HotelLightWidgetParams is in this file or imported correctly
// class HotelLightWidgetParams { ... } // Your existing class definition

class HotelLightWidget extends StatelessWidget {
  const HotelLightWidget({super.key, required this.lightParams});
  final HotelLightWidgetParams lightParams;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 15,
          bottom: 10,
          right: 10,
        ), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min, // Useful if height wasn't fixed
          children: [
            Row(
              children: [
                Expanded(
                  child: getGeistText(
                    lightParams.title,
                    weight: 600,
                    size: 17, // Slightly reduced size for better fit
                  ),
                ),
                const SizedBox(width: 4), // Spacing before switch
                HotelIconSwitch(
                  isSelected: lightParams.isOn, // To reflect current state
                  onSelect: () => lightParams.onStateChanged(true),
                  onUnSelect: () => lightParams.onStateChanged(false),
                  iconPath: lightParams.powerIconPath, // Use from params
                  size: 25,
                ),
              ],
            ),
            const SizedBox(height: 3), // Adjusted spacing
            Row(
              children: [
                getGeistText(
                  lightParams.isOn ? 'On' : 'Off',
                  weight: 500,
                  size: 13, // Slightly reduced size
                ),
                getGeistText(
                  ' - ${lightParams.currentValue}%', // Corrected string interpolation & added %
                  weight: 500,
                  size: 13, // Slightly reduced size
                ),
              ],
            ),
            const SizedBox(height: 3), // Adjusted spacing
            // The HotelSlider needs to be very compact to fit in the remaining space.
            // If HotelSlider is too big, it will cause an overflow.
            // Using Expanded will make it take the remaining vertical space.
            SizedBox(
              height: 20,
              child: HotelSlider(
                iconPath: lightParams.sliderIconPath, // Use from params
                value:
                    lightParams.currentValue.toDouble(), // Pass current value
                onChanged: (double newValue) {
                  // Assuming HotelSlider onChanged provides a double
                  lightParams.onChanged(newValue.round());
                },
                // You might need to ensure HotelSlider has min: 0, max: 100,
                // and is visually compact.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Your HotelLightWidgetParams class remains the same:
class HotelLightWidgetParams {
  final int currentValue;
  final Function(int) onChanged; // Callback for slider value change
  final String title;
  final bool isOn;
  final Function(bool) onStateChanged; // Callback for power switch state change
  final String powerIconPath;
  final String sliderIconPath;

  const HotelLightWidgetParams({
    required this.currentValue,
    required this.onChanged,
    required this.title,
    required this.isOn,
    required this.onStateChanged,
    this.powerIconPath = 'assets/icons/power.svg', // Default value
    this.sliderIconPath = 'assets/icons/sun.svg', // Default value
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HotelLightWidgetParams &&
        other.currentValue == currentValue &&
        other.onChanged == onChanged &&
        other.title == title &&
        other.isOn == isOn &&
        other.onStateChanged == onStateChanged &&
        other.powerIconPath == powerIconPath &&
        other.sliderIconPath == sliderIconPath;
  }

  @override
  int get hashCode {
    return currentValue.hashCode ^
        onChanged.hashCode ^
        title.hashCode ^
        isOn.hashCode ^
        onStateChanged.hashCode ^
        powerIconPath.hashCode ^
        sliderIconPath.hashCode;
  }

  HotelLightWidgetParams copyWith({
    int? currentValue,
    Function(int)? onChanged,
    String? title,
    bool? isOn,
    Function(bool)? onStateChanged,
    String? powerIconPath,
    String? sliderIconPath,
  }) {
    return HotelLightWidgetParams(
      currentValue: currentValue ?? this.currentValue,
      onChanged: onChanged ?? this.onChanged,
      title: title ?? this.title,
      isOn: isOn ?? this.isOn,
      onStateChanged: onStateChanged ?? this.onStateChanged,
      powerIconPath: powerIconPath ?? this.powerIconPath,
      sliderIconPath: sliderIconPath ?? this.sliderIconPath,
    );
  }
}
