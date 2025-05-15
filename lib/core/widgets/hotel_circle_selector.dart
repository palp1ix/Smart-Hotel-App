import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart'; // For HapticFeedback
// Assuming AppColors is defined elsewhere, e.g.:
// import 'package:smart_hotel_app/core/colors/colors.dart';

class HotelCircleSelector extends StatefulWidget {
  const HotelCircleSelector({
    super.key,
    this.knobSize = const Size(200, 200),
    this.greenCircleSize = const Size(130, 130),
  });

  final Size knobSize;
  final Size greenCircleSize;

  @override
  State<HotelCircleSelector> createState() => _HotelCircleSelectorState();
}

class _HotelCircleSelectorState extends State<HotelCircleSelector> {
  double _rotation = pi; // Initial rotation (draws half a circle downwards)
  double _startAngle = 0.0;
  double _initialRotation = 0.0;

  // For haptic feedback
  late int _lastTriggeredHapticDegree;
  final double _hapticDegreeStep =
      1.0; // Haptic feedback for every 1 degree of sweep angle change
  late final double _hapticRadianStep;

  @override
  void initState() {
    super.initState();
    _hapticRadianStep = _hapticDegreeStep * pi / 180.0;
    // Initialize _lastTriggeredHapticDegree based on the initial _rotation
    _lastTriggeredHapticDegree = (_rotation / _hapticRadianStep).round();
  }

  void _performHapticFeedbackIfNeeded(double currentRotation) {
    final int currentDegreeUnit = (currentRotation / _hapticRadianStep).round();
    if (currentDegreeUnit != _lastTriggeredHapticDegree) {
      HapticFeedback.lightImpact(); // Light haptic feedback
      // Or HapticFeedback.selectionClick(); for a "selection" feel
      _lastTriggeredHapticDegree = currentDegreeUnit;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size blackCircleSize = Size(
      widget.greenCircleSize.width - 40,
      widget.greenCircleSize.height - 40,
    );

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            final center = Offset(
              widget.knobSize.width / 2,
              widget.knobSize.height / 2,
            );
            // Calculate the angle of the touch point relative to the center
            _startAngle = atan2(
              details.localPosition.dy - center.dy,
              details.localPosition.dx - center.dx,
            );
            // Store the current rotation of the widget
            _initialRotation = _rotation;
            // Ensure haptic starting point is current for the new gesture
            _lastTriggeredHapticDegree =
                (_rotation / _hapticRadianStep).round();
          },
          onPanUpdate: (details) {
            final center = Offset(
              widget.knobSize.width / 2,
              widget.knobSize.height / 2,
            );
            // Calculate the current angle of the touch point
            final currentAngle = atan2(
              details.localPosition.dy - center.dy,
              details.localPosition.dx - center.dx,
            );

            double angleDelta = currentAngle - _startAngle;

            // Normalize angleDelta to represent the shortest path
            if (angleDelta > pi) {
              angleDelta -= 2 * pi;
            } else if (angleDelta < -pi) {
              angleDelta += 2 * pi;
            }

            final newRotation = _initialRotation + angleDelta;
            if (_rotation != newRotation) {
              // Update state and check for haptics only if the value actually changed
              setState(() {
                _rotation = newRotation.clamp(0, 2 * pi);
              });
              _performHapticFeedbackIfNeeded(_rotation);
            }
          },
          child: CustomPaint(
            painter: SelectorRing(rotation: _rotation),
            size: Size(widget.knobSize.width, widget.knobSize.height),
          ),
        ),
        Positioned(
          left: (widget.knobSize.width - widget.greenCircleSize.width) / 2,
          top: (widget.knobSize.height - widget.greenCircleSize.height) / 2,
          child: Container(
            width: widget.greenCircleSize.width,
            height: widget.greenCircleSize.height,
            decoration: BoxDecoration(
              color: AppColors.main,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: (widget.knobSize.width - blackCircleSize.width) / 2,
          top: (widget.knobSize.height - blackCircleSize.height) / 2,
          child: Container(
            width: blackCircleSize.width,
            height: blackCircleSize.height,
            decoration: BoxDecoration(
              color: AppColors.secondContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: getGeistText(
                '${_rotationToDegrees(_rotation).toStringAsFixed(1)}°C',
                weight: 600,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _rotationToDegrees(double rotation) {
    return 5 + (rotation / (2 * pi)) * 25;
  }
}

class SelectorRing extends CustomPainter {
  const SelectorRing({required this.rotation});
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );

    final paint =
        Paint()
          ..color = AppColors.onContainer
          ..style = PaintingStyle.fill;

    // 3 * pi / 2 is 270 degrees (12 o'clock position), the startAngle for drawArc.
    // The sweep angle is 'rotation'.
    // 'true' for useCenter means it will draw a sector (pie slice).
    canvas.drawArc(rect, 3 * pi / 2, rotation, true, paint);
  }

  @override
  bool shouldRepaint(covariant SelectorRing oldDelegate) =>
      oldDelegate.rotation != rotation;
}
