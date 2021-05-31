import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:running_society/widgets/calendar_utils/utils.dart';
import 'package:running_society/variables.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/theme.dart';

class ScheduleTab extends StatefulWidget {

  const ScheduleTab({Key? key, required this.classId}) : super(key: key);

  final int classId;

  @override
  _SchedulePageState createState() => _SchedulePageState();
}
class _SchedulePageState extends State<ScheduleTab>
    with SingleTickerProviderStateMixin {

  late ValueNotifier<List<Event>> _selectedEvents;
  late Results eventsRaw;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final memoizer = AsyncMemoizer();

  LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  Future<void> _getDayEvents(DateTime day) async {
    eventsRaw = await dbGetEventsForClass(widget.classId, day.toString().substring(0, 10));
    var eventsList = List<Event>.generate(eventsRaw.length, (index) => Event(
        eventsRaw.elementAt(index).values![0] as int,
        (eventsRaw.elementAt(index).values![1] as Duration).toString().substring(0, 5)));
    kEvents.addEntries({MapEntry(day, eventsList)});
    this.memoizer.runOnce(() async {
      _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    _getDayEvents(day);
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Widget _buildBody() {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 20)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                selectedDecoration: ShapeDecoration(
                  color: CustomTheme.lightOrangeTint, shape: CircleBorder(),
                ),
                todayDecoration: ShapeDecoration(
                  color: CustomTheme.lightGray, shape: CircleBorder(),
                ),
                todayTextStyle: TextStyle(color: Colors.black87),
                selectedTextStyle: TextStyle(color: Colors.black87),
                markerSizeScale: 0.15,
                markerDecoration: ShapeDecoration(
                  color: CustomTheme.lemonTint, shape: CircleBorder(),
                ),
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var container = Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: CustomTheme.lightOrangeTint,
                      ),
                      child: ListTile(
                        onTap: () {
                          // You should do something with the result of the action sheet prompt
                          // in a real app but this is just a demo.
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text('${value[index].title}'),
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: const Text('Schedule'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      dbAddToRegistry(1, value[index].scheduleId, widget.classId);
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text('Cancel'),
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              );
                            },
                          );
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('${value[index].title}',
                          style: TextStyle(fontSize: 18, color: Colors.black87),),
                        ),
                      ),
                    );
                    return container;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: _getDayEvents(DateTime.now()),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(child: Container(),);
        } else {
          return Scaffold(
            appBar: CustomAppBar("预约", true),
            body: _buildBody(),
          );
        }
    });
  }
}