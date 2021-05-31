import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:running_society/config/db_utils.dart';
import 'package:running_society/widgets/app_bar.dart';
import 'package:running_society/widgets/snackbar.dart';
import 'package:running_society/widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../theme.dart';

class AddClassTab extends StatefulWidget {

  final int coachId;
  const AddClassTab({required this.coachId});

  @override
  State<StatefulWidget> createState() => _AddClassTabState();
}

class _AddClassTabState extends State<AddClassTab> {

  late Results coachClasses;
  int? selectedClass;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: 0);
  final _memoizer = AsyncMemoizer();
  final DateFormat formatter = DateFormat('MMM d, yyyy');
  final DateFormat dbFormatter = DateFormat('yyyy-MM-d');

  Future<void> _getCoachClasses() async {
    return this._memoizer.runOnce(() async {
      coachClasses = await dbGetClasses(widget.coachId);
    });
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay result = (await showTimePicker(
        context: context,
        initialTime: selectedTime,
    ))!;
    if (result != null) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  Widget _buildBody() {
    return SafeArea(
        child: Column (
          children: [
            Padding(padding: EdgeInsets.only(top: 20, bottom: 20)),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: coachClasses.length + 1,
                itemBuilder: (context, index) {
                  return PressableColorCard(
                    color: Colors.transparent,
                    flattenAnimation: AlwaysStoppedAnimation(1),
                    child: SizedBox(
                      height: 70,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 5,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: index < coachClasses.length ? CustomTheme.lightOrangeTint : Colors.black45
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: CupertinoButton(
                                onPressed: () => this.setState(() {selectedClass = index;}),
                                child: index < coachClasses.length ? Text(
                                  coachClasses.elementAt(index).values![1] as String,
                                  style: TextStyle(color: Colors.black87),
                                ) : Text (
                                  "Create New Class",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                  );
                }
              )
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            this.selectedClass == null ? Container() : Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text("Class: ${coachClasses.elementAt(selectedClass!).values![1] as String}",
                        style: TextStyle(fontSize: 24, color: Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 40),
                      child: Row(
                        children: [
                          Text("Choose Date: ", style: TextStyle(fontSize: 18)),
                          TextButton(
                            child: Text(formatter.format(selectedDate),
                              style: TextStyle(fontSize: 18, color: CustomTheme.lemonTint,
                                  decoration: TextDecoration.underline),
                              ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 200, horizontal: 30),
                                      child: SfDateRangePicker(
                                        showActionButtons: true,
                                        selectionShape: DateRangePickerSelectionShape.rectangle,
                                        selectionColor: CustomTheme.lemonTint,
                                        enablePastDates: false,
                                        todayHighlightColor: CustomTheme.lemonTint,
                                        maxDate: DateTime.now().add(Duration(days: 14)),
                                        onSubmit: (Object value) {
                                          setState(() {
                                            selectedDate = value as DateTime;
                                          });
                                          Navigator.pop(context);
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                        backgroundColor: CustomTheme.lightGray,
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: [
                          Text("Choose Time: ", style: TextStyle(fontSize: 18)),
                          TextButton(
                              onPressed: _showTimePicker,
                              child: Text("${selectedTime.format(context)}",
                                style: TextStyle(fontSize: 18, color: CustomTheme.lemonTint,
                                    decoration: TextDecoration.underline)))
                        ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CupertinoButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: CustomTheme.lemonTint, fontSize: 24),
                        ),
                        onPressed: () async {
                          int result = await dbAddToSchedules(
                              coachClasses.elementAt(selectedClass!).values![0] as int,
                              dbFormatter.format(selectedDate),
                              DateFormat('HH:mm:ss').format(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute, 0)));
                          if (result == 1) {
                            CustomSnackBar(context, Text("Success!"));
                            setState(() {
                              selectedClass = null;
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCoachClasses(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(child: Text('Waiting'));
        } else {
          return Scaffold(
            appBar: CustomAppBar("Add Class", true),
            body: _buildBody(),
          );
        }
      });
  }
}