import 'package:flutter/cupertino.dart';

final List<List<String>> coachClasses = [['Classes', 'Beginner Running', 'Intermediate Running', 'Advanced Running'], ['Classes', 'Road to 5k', 'Your First Half-Marathon', 'Beginning Marathon', 'Boston Marathon']];

final List<AssetImage> coachImages = [AssetImage('assets/coaches_images/daniel.jpg'), AssetImage('assets/coaches_images/elvis.jpg')];
final List<String> coachNames = ['Daniel', 'Elvis'];

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 1, kNow.day);