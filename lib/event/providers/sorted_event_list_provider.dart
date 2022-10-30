import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/event/class/event.dart';
import 'package:myecl/event/providers/event_list_provider.dart';
import 'package:myecl/event/tools/functions.dart';

final sortedEventListProvider = Provider<Map<String, List<Event>>>((ref) {
  final eventList = ref.watch(eventListProvider);
  final sortedEventList = <String, List<Event>>{};
  final dateTitle = <String, DateTime>{};
  DateTime now = DateTime.now();
  now = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
  return eventList.when(
      data: (events) {
        for (final event in events) {
          List<DateTime> normalizedDates = [];
          if (event.recurrenceRule.isEmpty) {
            normalizedDates.add(DateTime(event.start.year, event.start.month,
                event.start.day, 0, 0, 0, 0, 0));
          } else {
            normalizedDates =
                getDateInRecurrence(event.recurrenceRule, event.start)
                    .map(
                      (x) => DateTime(x.year, x.month, x.day, 0, 0, 0, 0, 0),
                    )
                    .toList();
          }
          for (final normalizedDate in normalizedDates) {
            String formatedDelay = formatDelayToToday(normalizedDate, now);
            final e = event.copyWith(
                start: DateTime(
                    normalizedDate.year,
                    normalizedDate.month,
                    normalizedDate.day,
                    event.start.hour,
                    event.start.minute,
                    event.start.second,
                    event.start.millisecond),
                end: DateTime(
                    normalizedDate.year,
                    normalizedDate.month,
                    normalizedDate.day,
                    event.end.hour,
                    event.end.minute,
                    event.end.second,
                    event.end.millisecond));
            dateTitle[formatedDelay] = normalizedDate;
            if (sortedEventList.containsKey(formatedDelay)) {
              final index = sortedEventList[formatedDelay]!
                  .indexWhere((element) => element.start.isAfter(e.start));
              if (index == -1) {
                sortedEventList[formatedDelay]!.add(e);
              } else {
                sortedEventList[formatedDelay]!.insert(index, e);
              }
            } else {
              sortedEventList[formatedDelay] = [e];
            }
          }
        }
        final sortedkeys = sortedEventList.keys.toList(growable: false)
          ..sort((k1, k2) => dateTitle[k1]!.compareTo(dateTitle[k2]!));
        return {for (var k in sortedkeys) k: sortedEventList[k]!};
      },
      loading: () => {},
      error: (error, stack) => {});
});
