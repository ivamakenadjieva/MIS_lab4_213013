import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/exam_model.dart';
import '../widgets/add_exam_dialog.dart';
import '../widgets/google_map_screen.dart';
import '../screens/upcoming_exams_screen.dart';

class ExamCalendarScreen extends StatefulWidget {
  @override
  _ExamCalendarScreenState createState() => _ExamCalendarScreenState();
}

class _ExamCalendarScreenState extends State<ExamCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Exam>> _examEvents = {};

  List<Exam> _getEventsForDay(DateTime day) {
    return _examEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu_book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingExamsScreen(examEvents: _examEvents),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),

          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay).map((exam) {
                return ListTile(
                  title: Text(exam.title),
                  subtitle: Text('Location: ${exam.location}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMapScreen(
                          initialPosition: LatLng(exam.latitude, exam.longitude),
                          examTitle: exam.title,
                          onLocationSelected: (LatLng selectedCoordinates) {

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddExamDialog(onAddExam: (date, title, coordinates) {
                setState(() {
                  _examEvents[date] = _examEvents[date] ?? [];
                  final newExam = Exam(
                    title: title,
                    dateTime: date,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    location: '',
                  );
                  _examEvents[date]?.add(newExam);
                });
              });
            },
          );
        },
      ),
    );
  }
}
