import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/theme.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:running_society/widgets/calendar_utils/utils.dart';
import 'package:async/async.dart';

import '../variables.dart';
import '../widgets/widgets.dart';

class ScheduleButton extends StatelessWidget {
  ScheduleButton(
      {required this.className,
      required this.beginTime,
      required this.classLength,
      required this.maxSignUps});

  final String className;
  final String beginTime;
  final int classLength;
  final int maxSignUps;

  @override
  Widget build(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              beginTime,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      "$classLength min - $className: ${maxSignUps.toString()} 人"),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: CustomTheme.lightGray,
                borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
    );
  }
}

class CoachDetailTab extends StatefulWidget {
  const CoachDetailTab({
    required this.id,
    required this.coach,
    this.imageLink,
  });

  final int id;
  final String coach;
  final String? imageLink;

  @override
  _CoachDetailTabState createState() => _CoachDetailTabState();
}

class _CoachDetailTabState extends State<CoachDetailTab> {
  late String? descLong;
  late int? rank;

  late ValueNotifier<List<Event>> _selectedEvents;
  late Results eventsRaw;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final memoizer = AsyncMemoizer();

  LinkedHashMap<DateTime, List<Event>> kEvents =
      LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  Future<void> _getDayEvents(DateTime day) async {
    eventsRaw =
        await dbGetEventsForCoach(widget.id, day.toString().substring(0, 10));
    var eventsList = List<Event>.generate(
        eventsRaw.length,
        (index) => Event(
              eventsRaw.elementAt(index).values![0] as int,
              eventsRaw.elementAt(index).values![1] as String,
              (eventsRaw.elementAt(index).values![2] as Duration)
                  .toString()
                  .substring(0, 5),
              eventsRaw.elementAt(index).values![3] as int,
            ));
    kEvents.addEntries({MapEntry(day, eventsList)});
    this.memoizer.runOnce(() async {
      _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
    });
  }

  Future<void> _getCoachDetails() async {
    _getDayEvents(DateTime.now());
    var tempCoachDetails = await (dbGetCoachDetail(widget.id));
    this.descLong = tempCoachDetails.first.values![0] as String;
    this.rank = tempCoachDetails.first.values![1] as int;
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

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: new DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset(1, 0.6),
                        image: new NetworkImage(widget.imageLink!)))), // 教练照片
            this.descLong != ""
                ? Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                        child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(this.descLong!),
                      ),
                      decoration: BoxDecoration(
                          color: CustomTheme.lightGray,
                          borderRadius: BorderRadius.circular(5)),
                    )),
                  )
                : Container(), // 教练介绍
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                height: 80,
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.star,
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(DateTime.now().month.toString() +
                                  "月排名: " +
                                  this.rank!.toString()),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                  "已签到 " + widget.coach + " 教练 0 节课, 共记 - 分钟"),
                            )
                          ],
                        )
                      ],
                    )),
                decoration: BoxDecoration(
                    color: CustomTheme.lightGray,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ), // 教练数据
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TableCalendar<Event>(
                headerVisible: false,
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: CalendarFormat.week,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  selectedDecoration: ShapeDecoration(
                    color: CustomTheme.lemonTint,
                    shape: CircleBorder(),
                  ),
                  todayDecoration: ShapeDecoration(
                    color: CustomTheme.lightGray,
                    shape: CircleBorder(),
                  ),
                  todayTextStyle: TextStyle(color: Colors.black87),
                  selectedTextStyle: TextStyle(color: Colors.black87),
                  markerSizeScale: 0.15,
                  markerDecoration: ShapeDecoration(
                    color: CustomTheme.lemonTint,
                    shape: CircleBorder(),
                  ),
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      var container = Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: ScheduleButton(
                              className: value[index].className,
                              maxSignUps: 10,
                              beginTime: value[index].classTime,
                              classLength: value[index].classLength));
                      return container;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: CustomAppBar(widget.coach, true),
        body: FutureBuilder(
          future: _getCoachDetails(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SafeArea(child: Text('Waiting'));
            } else {
              return _buildBody();
            }
          }
        )
    );
  }
}
