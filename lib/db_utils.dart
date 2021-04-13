import 'package:flutter/cupertino.dart';
import 'package:running_society/login/widgets/snackbar.dart';
import 'package:running_society/supabase/config.dart';

Future<void> addToRegistry(BuildContext context) async {
  if (gotrueClient.currentUser == null) {
    CustomSnackBar(context, Text('Cannot Schedule, not logged in yet'));
  } else {
    await client
        .from('registry')
        .insert({'user_id': gotrueClient.currentUser!.id})
        .execute();
  }
}

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

