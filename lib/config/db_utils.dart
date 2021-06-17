import 'package:flutter/src/widgets/framework.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/config/config.dart';

Future<int> dbGetNumCoaches() async {
  if (conn != null) {
    var results = await conn!.query('select COUNT(*) from coach');
    return results.first.values![0] as int;
  } else {
    throw Error();
  }
}

Future<Results> dbGetCoaches() async {
  if (conn != null) {
    var results = await conn!.query('select id, name, image_url, desc_short from coach');
    return results;
  } else {
    throw Error();
  }
}

Future<Results> dbGetCoachDetail(int id) async {
  if (conn != null) {
    var results = await conn!.query('select desc_long, ranking from coach where id = ${id.toString()}');
    return results;
  } else {
    throw Error();
  }
}

Future<Results> dbGetClasses(int coachId) async {
  if (conn != null) {
    var results =  await conn!.query('select class_id, class_name from class where coach_id = ${coachId.toString()}');
    return results;
  } else {
    throw Error();
  }
}

Future<Results> dbGetEventsForCoach(int coachId, String date) async {
  if (conn != null) {
    String query = 'select id, class_name, time, class_length from schedule join class on schedule.class_id = class.class_id where schedule.coach_id = ${coachId.toString()} and date = \"$date\"';
    var results = await conn!.query(query);
    return results;
  } else {
    throw Error();
  }
}

void dbAddToRegistry(int userId, int scheduleId, int classId) async {
  if (conn != null) {
    await conn!.query('insert into registry (user_id, schedule_id, class_id) values (?, ?, ?)', [userId, scheduleId, classId]);
  } else {
    throw Error();
  }
}

Future<int> dbAddToSchedules(int classId, String date, String time) async {
  if (conn != null) {
    await conn!.query('insert into schedule (class_id, date, time) values (?, ?, ?)', [classId, date, time]);
    return 1;
  } else {
    throw Error();
  }
}