import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/calendar_utils/utils.dart';
import 'supabase/config.dart';

//final List<List<String>> coachClasses = [['Classes', 'Beginner Running', 'Intermediate Running', 'Advanced Running'], ['Classes', 'Road to 5k', 'Your First Half-Marathon', 'Beginning Marathon', 'Boston Marathon'], ['Running']];
final List<AssetImage> coachImages = [AssetImage('assets/coaches_images/daniel.jpg'), AssetImage('assets/coaches_images/elvis.jpg'), AssetImage('assets/coaches_images/kelton.jpg')];
final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 1, kNow.day);

List<String> coaches = <String>[];
HashMap<String, List<String>> classes = HashMap();
HashMap<String, List<Event>> classSchedule = HashMap();

Future<List<dynamic>> getCoachNames () async {
  final response = await client
    .from('coaches')
    .select('coach_name')
    .execute();
  return response.data as List<dynamic>;
}

Future<List<dynamic>> getCoachClasses () async {
  final response = await client
    .from('classes')
    .select('coach_name, class_name')
    .execute();
  return response.data as List<dynamic>;
}

Future<List<dynamic>> getEvents () async {
  final response = await client
    .from('schedules')
    .select('class_name, time, signed_up')
    .execute();
  return response.data as List<dynamic>;
}

Future<void> refreshData() async {
  coaches = <String>[];
  var coachNamesRaw = await getCoachNames();
  for (dynamic coachNameElem in coachNamesRaw) {
    var coachName = coachNameElem['coach_name'] as String;
    coaches.add(coachName);
    classes.addAll({coachName: <String>['']});
  }
  var coachClassesRaw = await getCoachClasses();
  for (dynamic coachClassesElem in coachClassesRaw) {
    var coachName = coachClassesElem!['coach_name'] as String;
    var className = coachClassesElem!['class_name'] as String;
    classes[coachName]!.add(className);
    classSchedule.addAll({className: <Event>[]});
  }

  var eventsRaw = await getEvents();
  for (dynamic eventsElem in eventsRaw) {
    var className = eventsElem!['class_name'] as String;
    var time = eventsElem!['time'] as String;
    classSchedule[className]!.add(Event(time.substring(11, 19)));
  }
}