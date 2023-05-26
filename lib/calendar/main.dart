import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Table Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CalendarPage(),
    );
  }
}

final calendarFormatProvider =
    StateProvider<CalendarFormat>((ref) => CalendarFormat.month);
final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDayProvider = StateProvider<DateTime?>((ref) => null);

class CalendarPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDay = ref.watch(focusedDayProvider);
    final selectedDay = ref.watch(selectedDayProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Table Calendar Demo'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
        ),
        eventLoader: (date) {
          return sampleMap[date] ?? [];
        },
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          ref.read(selectedDayProvider.notifier).state = selectedDay;
          ref.read(focusedDayProvider.notifier).state = focusedDay;
        },
        onPageChanged: (newFocusedDay) {
          ref.read(focusedDayProvider.notifier).state = newFocusedDay;
        },
      ),
    );
  }
}

final sampleMap = {
  DateTime.utc(2023, 5, 27): ['firstEvent', 'secodnEvent'],
  DateTime.utc(2023, 5, 5): ['thirdEvent', 'fourthEvent']
};

List<String> _selectedEvents = [];