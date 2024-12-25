import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  final LatLng initialPosition;
  final String examTitle;
  final Function(LatLng) onLocationSelected;

  GoogleMapScreen({
    required this.initialPosition,
    required this.examTitle,
    required this.onLocationSelected,
  });

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}


class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition;
  }

  void _onMapTapped(LatLng coordinates) {
    setState(() {
      _currentPosition = coordinates;
    });
    widget.onLocationSelected(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.examTitle),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition,
            zoom: 14.0,
          ),
          onTap: (LatLng newLocation) {
            widget.onLocationSelected(newLocation);
          },
          markers: Set.of([
            Marker(
              markerId: MarkerId('examLocation'),
              position: widget.initialPosition,
            ),
          ]),
        )
    );
  }
}