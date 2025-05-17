import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart' show AppColors;
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/widgets/hotel_light_widget.dart';
import 'package:smart_hotel_app/core/widgets/hotel_structure_widget.dart';
import 'package:smart_hotel_app/core/widgets/hotel_switch.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart';

@RoutePage()
class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  // Labels for HotelToggleButtons
  final List<String> _toggleLabels = ['Living room', 'Bedroom', 'Kitchen'];
  int _selectedToggleIndex = 0;

  // State for Air Conditioner
  bool _isConditionerSelected = false;

  // List to hold parameters for each light widget
  List<HotelLightWidgetParams> _lightParamsList = [];

  // Room names for lights (can be same as _toggleLabels or different)
  // Using _toggleLabels for simplicity as requested for titles
  final List<String> _lightRoomNames = [
    'Living room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
  ]; // Added Bathroom for an even grid example

  @override
  void initState() {
    super.initState();
    // Initialize parameters for each light
    _lightParamsList = List.generate(_lightRoomNames.length, (index) {
      String roomName = _lightRoomNames[index];
      return HotelLightWidgetParams(
        title: roomName,
        currentValue: 60, // Initial brightness
        isOn: false, // Initial power state
        onChanged: (newValue) {
          setState(() {
            _lightParamsList[index] = _lightParamsList[index].copyWith(
              currentValue: newValue,
            );
          });
          // Here you can also call your backend update function
          // e.g., updateLightBrightnessOnBackend(roomName, newValue);
        },
        onStateChanged: (newState) {
          setState(() {
            _lightParamsList[index] = _lightParamsList[index].copyWith(
              isOn: newState,
            );
          });
          // Here you can also call your backend update function
          // e.g., updateLightStateOnBackend(roomName, newState);
        },
        // You can customize powerIconPath and sliderIconPath per light if needed
        // powerIconPath: 'assets/icons/custom_power.svg',
        // sliderIconPath: 'assets/icons/custom_sun.svg',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: SingleChildScrollView(
          // Outer scroll view
          child: Column(
            children: [
              // Removed Flexible from HotelToggleButtons
              HotelToggleButtons(
                selectedIndex: _selectedToggleIndex,
                labels: _toggleLabels,
                onPressed: (index) {
                  setState(() {
                    _selectedToggleIndex = index;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                // Fixed height for the Air Conditioner section
                height:
                    300, // Or whatever height is appropriate for HotelCircleSelector
                child: HotelStructureWidget(
                  trailing: HotelSwitch(
                    isSelected: _isConditionerSelected,
                    onSelect:
                        () => setState(() {
                          _isConditionerSelected = !_isConditionerSelected;
                        }),
                  ),
                  title: 'Air Conditioner',
                  subtitle: 'Samsung Ultimate Pro',
                  child: HotelCircleSelector(), // Assuming this is defined
                ),
              ),
              const SizedBox(height: 24),

              // GridView configuration for SingleChildScrollView
              SizedBox(
                height: 300,
                child: HotelStructureWidget(
                  title: 'Lights',
                  child: GridView.builder(
                    shrinkWrap:
                        true, // Important: Makes GridView size to its content
                    physics:
                        const NeverScrollableScrollPhysics(), // Important: Disables GridView's own scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 168 / 100,
                        ),
                    itemCount: _lightParamsList.length,
                    itemBuilder: (context, index) {
                      return HotelLightWidget(
                        lightParams: _lightParamsList[index],
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
