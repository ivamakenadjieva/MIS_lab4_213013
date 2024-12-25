import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/exam_model.dart';
import 'shortest_route_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpcomingExamsScreen extends StatefulWidget {
  final Map<DateTime, List<Exam>> examEvents;

  UpcomingExamsScreen({required this.examEvents});

  @override
  _UpcomingExamsScreenState createState() => _UpcomingExamsScreenState();
}

class _UpcomingExamsScreenState extends State<UpcomingExamsScreen> {
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final upcomingExams = widget.examEvents.entries
        .where((entry) => entry.key.isAfter(today))
        .expand((entry) => entry.value)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Exams'),
      ),
      body: upcomingExams.isEmpty
          ? Center(child: Text('No upcoming exams'))
          : ListView.builder(
        itemCount: upcomingExams.length,
        itemBuilder: (context, index) {
          final exam = upcomingExams[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(exam.title),
              subtitle: Text(
                'Date: ${exam.dateTime}\nLocation: (${exam.latitude}, ${exam.longitude})',
              ),
              trailing: IconButton(
                icon: Icon(Icons.directions),
                onPressed: () async {
                  if (_currentPosition != null) {
                    LatLng userLocation = LatLng(_currentPosition.latitude, _currentPosition.longitude);
                    LatLng examLocation = LatLng(exam.latitude, exam.longitude);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShortestRouteScreen(
                          source: userLocation,
                          destination: examLocation,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable to get current location")));
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}