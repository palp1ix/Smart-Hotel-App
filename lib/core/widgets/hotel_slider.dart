import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

/// A custom slider widget for controlling a value within a defined range.
///
/// This widget displays a slider with a draggable handle and an icon at the start.
/// The current value is displayed inside the handle.
class HotelSlider extends StatefulWidget {
  const HotelSlider({
    super.key,
    this.borderRadius = 20,

    /// The path to the SVG icon displayed at the start of the slider.
    ///
    /// This icon visually represents the function or value being controlled by the slider.
    required this.iconPath,
  });

  final double borderRadius;
  final String iconPath;

  @override
  State<HotelSlider> createState() => _HotelSliderState();
}

class _HotelSliderState extends State<HotelSlider> {
  double width = 40;

  @override
  /// Builds the visual representation of the slider.
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.onContainer,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            // The draggable area of the slider.
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(
                  () => width = (width + details.delta.dx).clamp(40, 140),
                );
              },
              // The visual representation of the slider's current value.
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.onContainer, AppColors.main],
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                // The handle displaying the current value.
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      color: AppColors.main,
                    ),
                    width: 20,
                    height: 20,
                    child: Center(
                      // Ensures the text fits within the handle.
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: getGeistText(
                          calculateCurrentValue(width),
                          // Sets the text style for the current value.
                          size: 12,
                          weight: 600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            // The icon at the start of the slider.
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onContainer,
              ),
              width: 20,
              child: SvgPicture.asset(widget.iconPath),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculates the current value based on the slider's width.
  ///
  /// The value is an integer representing the current position of the slider.
  String calculateCurrentValue(double width) {
    int value = (width - 40).toInt();
    return value.toString();
  }
}
