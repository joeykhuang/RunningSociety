import 'package:flutter/cupertino.dart';
import 'supabase/config.dart';

final List<List<String>> coachClasses = [['Classes', 'Beginner Running', 'Intermediate Running', 'Advanced Running'], ['Classes', 'Road to 5k', 'Your First Half-Marathon', 'Beginning Marathon', 'Boston Marathon'], ['Running']];

final List<AssetImage> coachImages = [AssetImage('assets/coaches_images/daniel.jpg'), AssetImage('assets/coaches_images/elvis.jpg'), AssetImage('assets/coaches_images/kelton.jpg')];

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 1, kNow.day);

Future<List<dynamic>> getCoachNames () async {
  final response = await client
    .from('coaches')
    .select('coach_name')
    .execute();
  return response.data as List<dynamic>;
}

Future<List<dynamic>> getCoachClasses (String coach_name) async {
  final response = await client
    .from('classes')
    .select('class_name')
    .filter('coach_name', 'eq', coach_name)
    .execute();
  return response.data as List<dynamic>;
}

Future<List<dynamic>> getEvents (String class_name) async {
  final response = await client
    .from('schedules')
    .select('time, signed_up')
    .filter('class_name', 'eq', class_name)
    .execute();
  return response.data as List<dynamic>;
}