// combined_reservation_screen.dart (or your screen file)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_hotel_app/src/bloc/reservation_bloc/reservation_bloc.dart';
// Assuming reservation_bloc.dart, reservation_event.dart, reservation_state.dart are in the same directory
// or adjust the path accordingly.
// For example, if they are in 'blocs/reservation/'
// import 'package:smart_hotel_app/src/presentation/reservation/blocs/reservation/reservation_bloc.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart' show AppColors;
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/widgets/hotel_primary_button.dart';
import 'package:smart_hotel_app/core/widgets/show_progress.dart';
import 'package:smart_hotel_app/router/router.gr.dart';

// Enums and RoomData class (assuming they are defined here or imported)
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
class CombinedReservationScreen extends StatefulWidget {
  const CombinedReservationScreen({super.key});

  @override
  State<CombinedReservationScreen> createState() =>
      _CombinedReservationScreenState();
}

class _CombinedReservationScreenState extends State<CombinedReservationScreen> {
  int _currentStep = 0;
  final int _totalSteps = 2;
  final _reservationBloc = ReservationBloc();

  final List<RoomData> roomOptions = [
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
  ];
  int _selectedRoomIndex = -1;
  String _currentRoomDescription = "";

  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Не выбрано';
    }
    const List<String> weekdays = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];
    const List<String> months = [
      'янв.',
      'фев.',
      'мар.',
      'апр.',
      'мая',
      'июн.',
      'июл.',
      'авг.',
      'сен.',
      'окт.',
      'ноя.',
      'дек.',
    ];
    final day = date.day.toString();
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final year = date.year.toString();
    return '$weekday, $day $month $year г.';
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime? tempPickedDateForModal;

    if (isCheckIn) {
      initialDate = _checkInDate ?? DateTime.now();
      firstDate = DateTime.now().subtract(const Duration(days: 1));
    } else {
      if (_checkInDate != null) {
        initialDate =
            _checkOutDate ?? _checkInDate!.add(const Duration(days: 1));
        firstDate = _checkInDate!.add(const Duration(days: 1));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сначала выберите дату заезда'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    final DateTime effectiveInitialDate =
        initialDate.isBefore(firstDate) ? firstDate : initialDate;
    tempPickedDateForModal = effectiveInitialDate;

    final DateTime? pickedDate = await showCupertinoModalPopup<DateTime?>(
      context: context,
      builder: (BuildContext modalContext) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(modalContext, tempPickedDateForModal);
            return true;
          },
          child: Container(
            height: 216,
            color: CupertinoColors.systemBackground.resolveFrom(modalContext),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: effectiveInitialDate,
              minimumDate: firstDate,
              maximumDate: DateTime.now().add(const Duration(days: 365 * 2)),
              onDateTimeChanged: (DateTime newDate) {
                tempPickedDateForModal = newDate;
              },
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = pickedDate;
          if (_checkOutDate != null && !_checkOutDate!.isAfter(_checkInDate!)) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = pickedDate;
        }
      });
    }
  }

  String _calculateNights() {
    if (_checkInDate == null ||
        _checkOutDate == null ||
        !_checkOutDate!.isAfter(_checkInDate!)) {
      return '0';
    }
    return _checkOutDate!.difference(_checkInDate!).inDays.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  void _nextStep() {
    if (_currentStep == 0 && _isRoomSelectionValid()) {
      setState(() {
        _currentStep = 1;
      });
    } else if (_currentStep == 1 && _isDateSelectionValid()) {
      // Dispatch event to BLoC
      final selectedRoom = roomOptions[_selectedRoomIndex];
      _reservationBloc.add(
        CreateReservationEvent(
          checkInDate: _checkInDate!,
          checkOutDate: _checkOutDate!,
          roomType: selectedRoom.roomType,
        ),
      );
    }
  }

  bool _isRoomSelectionValid() {
    return _selectedRoomIndex != -1;
  }

  bool _isDateSelectionValid() {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _checkOutDate!.isAfter(_checkInDate!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canProceed =
        (_currentStep == 0 && _isRoomSelectionValid()) ||
        (_currentStep == 1 && _isDateSelectionValid());

    return BlocListener<ReservationBloc, ReservationState>(
      bloc: _reservationBloc,
      listener: (context, state) {
        if (state is ReservationInProgress) {
          showProgress(context);
        } else if (state is ReservationSuccess) {
          // Dismiss progress if shown
          // Assuming showProgress shows a dialog that Navigator.pop can dismiss
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          context.router.replace(HomeRoute(reservation: state.reservation));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Бронирование успешно завершено!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ReservationFailure) {
          // Dismiss progress if shown
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка бронирования'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            _currentStep == 0 ? 'Выберите тип номера' : 'Выберите даты',
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          surfaceTintColor: AppColors.background,
          leading:
              _currentStep == 1
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentStep = 0;
                      });
                    },
                  )
                  : null,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  backgroundColor: AppColors.secondContainer.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.main),
                  minHeight: 8,
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildRoomSelectionStep(context),
                  _buildDateSelectionStep(context, theme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 40,
                top: 10,
              ),
              child: HotelPrimaryButton(
                title:
                    _currentStep == 0
                        ? 'Продолжить'
                        : 'Подтвердить бронирование',
                textWeight: 500,
                onPressed: canProceed ? _nextStep : () {},
                color: canProceed ? AppColors.main : AppColors.secondContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSelectionStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 10,
            right: 20,
            bottom: 0,
          ),
          child: getGeistText(
            'Выберите подходящий тип комнаты',
            size: 20,
            weight: 500,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                ...List.generate(roomOptions.length, (index) {
                  final currentData = roomOptions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: RoomTypeWidget(
                      imagePath: currentData.imagePath,
                      description: currentData.description,
                      roomType: currentData.roomType,
                      category: currentData.category,
                      isSelected: _selectedRoomIndex == index,
                      onTap: (description) {
                        setState(() {
                          if (_selectedRoomIndex == index) {
                            // _selectedRoomIndex = -1;
                            // _currentRoomDescription = "";
                          } else {
                            _selectedRoomIndex = index;
                            _currentRoomDescription = description;
                          }
                        });
                      },
                    ),
                  );
                }),
                const SizedBox(height: 15),
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
                        axisAlignment: -1.0,
                        child: child,
                      ),
                    );
                  },
                  child:
                      _currentRoomDescription.isNotEmpty
                          ? DescriptionWidget(
                            key: ValueKey<String>(_currentRoomDescription),
                            description: _currentRoomDescription,
                          )
                          : SizedBox.shrink(
                            key: const ValueKey<String>("empty_description"),
                          ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelectionStep(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          _buildDateSelectionTile(
            context: context,
            title: 'Дата заезда',
            icon: Icons.calendar_today_outlined,
            date: _checkInDate,
            onTap: () => _selectDate(context, true),
            theme: theme,
          ),
          const SizedBox(height: 16),
          _buildDateSelectionTile(
            context: context,
            title: 'Дата выезда',
            icon: Icons.calendar_today,
            date: _checkOutDate,
            onTap: () => _selectDate(context, false),
            enabled: _checkInDate != null,
            theme: theme,
          ),
          const SizedBox(height: 32),
          if (_checkInDate != null && _checkOutDate != null)
            Card(
              color: AppColors.container,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getGeistText('Выбранные даты:', size: 16, weight: 600),
                    const SizedBox(height: 8),
                    getGeistText(
                      'Заезд: ${_formatDate(_checkInDate)}',
                      size: 15,
                    ),
                    getGeistText(
                      'Выезд: ${_formatDate(_checkOutDate)}',
                      size: 15,
                    ),
                    const SizedBox(height: 8),
                    if (_checkInDate != null &&
                        _checkOutDate != null &&
                        _checkInDate!.isAfter(_checkOutDate!))
                      getGeistText(
                        'Ошибка: Дата выезда должна быть после даты заезда!',
                        color: theme.colorScheme.error,
                        weight: 600,
                        size: 14,
                      )
                    else
                      getGeistText(
                        'Продолжительность: ${_calculateNights()} ночей',
                        size: 14,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
    required ThemeData theme,
    bool enabled = true,
  }) {
    return Card(
      color: AppColors.container,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled ? AppColors.main : theme.disabledColor,
        ),
        title: getGeistText(
          title,
          color: enabled ? Colors.white : theme.disabledColor,
          size: 16,
        ),
        subtitle: getGeistText(
          _formatDate(date),
          size: 14,
          weight: date == null ? 500 : 600,
          color:
              date == null
                  ? theme.hintColor
                  : (enabled ? AppColors.main : theme.disabledColor),
        ),
        trailing: Icon(
          Icons.edit_calendar_outlined,
          color: enabled ? AppColors.main : theme.disabledColor,
        ),
        onTap: enabled ? onTap : null,
        enabled: enabled,
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
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: getGeistText(description, size: 14, weight: 400),
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
    ImageProvider imageProvider;
    try {
      imageProvider = AssetImage(imagePath);
    } catch (e) {
      print("Error loading asset: $imagePath. Using placeholder. $e");
      imageProvider = const AssetImage('assets/images/placeholder.png');
    }

    return GestureDetector(
      onTap: () => onTap(description),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: isSelected ? 10 : 20,
          vertical: isSelected ? 8 : 10,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              print("Error in DecorationImage: $imagePath. $exception");
            },
          ),
          border:
              isSelected
                  ? Border.all(
                    color: AppColors.main,
                    width: 2.5,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                  : null,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.main.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        width: double.infinity,
        height: 120,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.85),
                Colors.black.withOpacity(0.05),
              ],
              stops: const [0.0, 0.7],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getGeistText(
                  roomType.name[0].toUpperCase() + roomType.name.substring(1),
                  size: 18,
                  weight: 600,
                  color: Colors.white,
                ),
                const SizedBox(height: 2),
                getGeistText(
                  category.name[0].toUpperCase() + category.name.substring(1),
                  size: 13,
                  weight: 600,
                  color: Colors.white.withOpacity(0.85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
