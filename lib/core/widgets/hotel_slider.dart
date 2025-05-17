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

    /// The current value of the slider, expected to be between 0.0 and 100.0.
    this.value = 0.0, // Default to 0.0, assuming a 0-100 range
    this.onChanged,
  });

  final double borderRadius;
  final String iconPath;
  final double value; // This is the actual value (e.g., 0-100)
  final Function(double value)? onChanged;

  @override
  State<HotelSlider> createState() => _HotelSliderState();
}

class _HotelSliderState extends State<HotelSlider> {
  late double _currentWidth; // Internal state for the slider's visual width

  // Constants for slider dimensions and value mapping
  final double _minSliderWidth = 40.0; // Minimum width of the draggable part
  final double _maxSliderWidth = 140.0; // Maximum width of the draggable part
  final double _minValue = 0.0; // Minimum logical value for the slider
  final double _maxValue = 100.0; // Maximum logical value for the slider

  @override
  void initState() {
    super.initState();
    // Initialize _currentWidth based on the initial widget.value
    _currentWidth = _calculateWidthFromValue(widget.value);
  }

  @override
  void didUpdateWidget(HotelSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the external value (widget.value) changes, update the slider's visual position
    if (widget.value != oldWidget.value) {
      // Check if the new widget.value is significantly different from what _currentWidth currently represents.
      // This avoids unnecessary setState if the change is due to rounding or small floating point inaccuracies
      // after an onChanged event that already updated the parent.
      double valueRepresentedByCurrentWidth = _calculateValueFromWidth(
        _currentWidth,
      );
      if ((widget.value - valueRepresentedByCurrentWidth).abs() > 0.01) {
        // Tolerance for double comparison
        setState(() {
          _currentWidth = _calculateWidthFromValue(widget.value);
        });
      }
    }
  }

  /// Calculates the slider's visual width based on a logical value (0-100).
  double _calculateWidthFromValue(double value) {
    // Normalize value to 0-1 range
    double normalizedValue = (value - _minValue) / (_maxValue - _minValue);
    // Scale to slider width range and add min width
    double width =
        normalizedValue * (_maxSliderWidth - _minSliderWidth) + _minSliderWidth;
    return width.clamp(
      _minSliderWidth,
      _maxSliderWidth,
    ); // Ensure it's within bounds
  }

  /// Calculates the logical value (0-100) based on the slider's visual width.
  double _calculateValueFromWidth(double width) {
    // Normalize width to 0-1 range relative to draggable area
    double normalizedWidth =
        (width - _minSliderWidth) / (_maxSliderWidth - _minSliderWidth);
    // Scale to logical value range
    double value = normalizedWidth * (_maxValue - _minValue) + _minValue;
    return value.clamp(_minValue, _maxValue); // Ensure it's within bounds
  }

  /// Gets the string representation of the current value for display (rounded).
  String _getDisplayValue(double currentWidth) {
    double logicalValue = _calculateValueFromWidth(currentWidth);
    return logicalValue.round().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      // The total width of the slider component is _maxSliderWidth
      width: _maxSliderWidth,
      decoration: BoxDecoration(
        color: AppColors.onContainer, // Background of the slider track
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // The draggable part / filled track
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                double newWidth = (_currentWidth + details.delta.dx).clamp(
                  _minSliderWidth,
                  _maxSliderWidth,
                );
                if (_currentWidth != newWidth) {
                  setState(() {
                    _currentWidth = newWidth;
                  });
                  // Calculate the corresponding logical value and notify the parent
                  double newValue = _calculateValueFromWidth(_currentWidth);
                  widget.onChanged?.call(newValue);
                }
              },
              // The visual representation of the slider's current value (filled part)
              child: Container(
                height: 20,
                width: _currentWidth, // Dynamic width based on state
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.onContainer, AppColors.main],
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                // The handle displaying the current value
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      color: AppColors.main, // Thumb color
                    ),
                    width: 20, // Width of the thumb
                    height: 20, // Height of the thumb
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: getGeistText(
                          _getDisplayValue(
                            _currentWidth,
                          ), // Display rounded value
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
          // The icon at the start of the slider
          Positioned(
            left: 0, // Icon is at the very left of the track
            top: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    AppColors.onContainer, // Background for icon, matches track
              ),
              width: 20, // Width of the icon container
              height: 20, // Height of the icon container
              child: SvgPicture.asset(widget.iconPath),
            ),
          ),
        ],
      ),
    );
  }
}
