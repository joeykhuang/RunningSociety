import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/calendar_utils/utils.dart';

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 1, kNow.day);

int numCoaches = 0;

List<String> coaches = <String>[];
HashMap<String, List<String>> classes = HashMap();
HashMap<String, HashMap<DateTime, List<Event>>> classSchedule = HashMap();

Future<void> refreshData() async {}

//Future<void> refreshData() async {
//  coaches = <String>[];
//  numCoaches = 0;
//  var coachNamesRaw = await getCoachNames();
//  for (dynamic coachNameElem in coachNamesRaw) {
//    var coachName = coachNameElem['coach_name'] as String;
//    coaches.add(coachName);
//    numCoaches++;
//    classes.addAll({coachName: <String>['']});
//  }
//  var coachClassesRaw = await getCoachClasses();
//  for (dynamic coachClassesElem in coachClassesRaw) {
//    var coachName = coachClassesElem!['coach_name'] as String;
//    var className = coachClassesElem!['class_name'] as String;
//    classes[coachName]!.add(className);
//  }
//
//  var eventsRaw = await getEvents();
//  var groupbyClass = groupBy(eventsRaw, (dynamic obj) => obj!['class_name']);
//  groupbyClass.forEach((eachClass, list) {
//    var eachClassMap = HashMap<DateTime, List<Event>>();
//    var groupbyDate = groupBy(list, (dynamic obj) => obj['time'].substring(0, 10));
//    groupbyDate.forEach((date, dateStringList) {
//      var dateVar = DateTime.parse(date as String);
//      eachClassMap[dateVar] = [];
//      for (dynamic dateString in dateStringList){
//        eachClassMap[dateVar]!.add(Event((dateString['time'] as String).substring(11, 19)));
//      }
//    });
//    classSchedule[eachClass as String] = eachClassMap;
//  });
//}