import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab4/widgets/google_map_screen.dart';
class AddExamDialog extends StatefulWidget {
  final Function(DateTime, String, LatLng) onAddExam;

  AddExamDialog({required this.onAddExam});

  @override
  State<AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  LatLng? _coordinates;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Exam'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Exam Title'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoogleMapScreen(
                    initialPosition: _coordinates ?? LatLng(42.004208966924224, 21.409778363032753),
                    examTitle: 'Pick Exam Location',
                    onLocationSelected: (LatLng selectedCoordinates) {
                      setState(() {
                        _coordinates = selectedCoordinates;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: Text('Pick Location on Map'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Text('Select Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _coordinates != null) {
              widget.onAddExam(
                _selectedDate,
                _titleController.text,
                _coordinates!,
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please provide all required details.')),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}