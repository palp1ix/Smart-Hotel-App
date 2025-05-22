import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoDatePicker
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

@RoutePage()
class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({super.key});

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  // Helper function to format DateTime to a readable string
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Не выбрано';
    }
    // Example: "пт, 15 мар. 2024 г." (Friday, Mar 15, 2024)
    // You can customize the format as you like.
    // e.g., DateFormat.yMMMd('ru_RU') for Russian month abbreviations
    // Ensure you have initialized date formatting for your locale if needed.
    // For simplicity, using default locale here.
    return DateFormat.yMMMEd().format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime? tempPickedDate;

    if (isCheckIn) {
      initialDate = _checkInDate ?? DateTime.now();
      firstDate = DateTime.now().subtract(
        const Duration(days: 1),
      ); // Allow yesterday for time zone issues, picker will clamp to minDate
    } else {
      // For check-out, initial and first date should be after check-in
      if (_checkInDate != null) {
        initialDate =
            _checkOutDate ?? _checkInDate!.add(const Duration(days: 1));
        firstDate = _checkInDate!.add(const Duration(days: 1));
      } else {
        // If check-in is not selected, prompt user or disable picking check-out
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сначала выберите дату заезда'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    // For iOS style picker on both platforms (as requested for Android too)
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250, // Adjust height as needed
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              SizedBox(
                height: 200, // Height for the picker itself
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      initialDate.isBefore(firstDate) ? firstDate : initialDate,
                  minimumDate: firstDate,
                  maximumDate: DateTime.now().add(
                    const Duration(days: 365 * 2),
                  ), // Max 2 years in future
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Готово'),
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                  if (tempPickedDate != null) {
                    setState(() {
                      if (isCheckIn) {
                        _checkInDate = tempPickedDate;
                        // If check-out date is before new check-in date, or same, reset it
                        if (_checkOutDate != null &&
                            !_checkOutDate!.isAfter(_checkInDate!)) {
                          _checkOutDate = null;
                        }
                      } else {
                        _checkOutDate = tempPickedDate;
                      }
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    // --- Alternative: Native Android Picker ---
    // If you wanted native Android picker on Android:
    // if (Platform.isAndroid) {
    //   final DateTime? picked = await showDatePicker(
    //     context: context,
    //     initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
    //     firstDate: firstDate,
    //     lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    //     // You can customize builder for theming if needed
    //   );
    //   if (picked != null) {
    //     setState(() {
    //       if (isCheckIn) {
    //         _checkInDate = picked;
    //         if (_checkOutDate != null && !_checkOutDate!.isAfter(_checkInDate!)) {
    //           _checkOutDate = null;
    //         }
    //       } else {
    //         _checkOutDate = picked;
    //       }
    //     });
    //   }
    // } else {
    //   // ... Cupertino code as above ...
    // }
  }

  @override
  void initState() {
    super.initState();
    // For Russian date formats, you might need to initialize:
    // initializeDateFormatting('ru_RU', null);
    // However, yMMMEd usually works with the system's locale.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронирование отеля'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Using ListView for potential future expansion
          children: <Widget>[
            _buildDateSelectionTile(
              context: context,
              title: 'Дата заезда',
              icon: Icons.calendar_today_outlined,
              date: _checkInDate,
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            _buildDateSelectionTile(
              context: context,
              title: 'Дата выезда',
              icon: Icons.calendar_today,
              date: _checkOutDate,
              onTap: () => _selectDate(context, false),
              enabled: _checkInDate != null, // Disable if check-in not selected
            ),
            const SizedBox(height: 32),
            if (_checkInDate != null && _checkOutDate != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выбранные даты:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Заезд: ${_formatDate(_checkInDate)}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        'Выезд: ${_formatDate(_checkOutDate)}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      if (_checkInDate!.isAfter(_checkOutDate!))
                        Text(
                          'Ошибка: Дата выезда должна быть после даты заезда!',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          'Продолжительность: ${_calculateNights()} ночей',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Подтвердить бронирование'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 16),
              ),
              onPressed:
                  (_checkInDate != null &&
                          _checkOutDate != null &&
                          _checkOutDate!.isAfter(_checkInDate!))
                      ? () {
                        // Handle confirmation logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Бронь подтверждена с ${_formatDate(_checkInDate)} по ${_formatDate(_checkOutDate)}',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                      : null, // Disable button if dates are invalid
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled ? theme.colorScheme.primary : theme.disabledColor,
        ),
        title: Text(
          title,
          style: TextStyle(color: enabled ? null : theme.disabledColor),
        ),
        subtitle: Text(
          _formatDate(date),
          style: TextStyle(
            color:
                date == null
                    ? theme.hintColor
                    : (enabled
                        ? theme.colorScheme.secondary
                        : theme.disabledColor),
            fontWeight: date == null ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.edit_calendar_outlined,
          color: enabled ? theme.colorScheme.primary : theme.disabledColor,
        ),
        onTap: enabled ? onTap : null,
        enabled: enabled,
      ),
    );
  }

  String _calculateNights() {
    if (_checkInDate == null ||
        _checkOutDate == null ||
        !_checkOutDate!.isAfter(_checkInDate!)) {
      return '0';
    }
    return _checkOutDate!.difference(_checkInDate!).inDays.toString();
  }
}
