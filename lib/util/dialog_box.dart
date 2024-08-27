import 'package:flutter/material.dart';
import 'package:todoapp_task/util/my_button.dart';

class DialogBox extends StatefulWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final Function(String) onPrioritySelected;

  DialogBox({
    super.key, 
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.onPrioritySelected,
    });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String selectedPriority = "Low"; // Default priority

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      backgroundColor: Colors.yellow[300],
      content: Container(
        height: 200,
        width: 250.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          // get user input
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Add a new task",
              ),
          ),
          
          // priority dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Set a priority:",
                  style: TextStyle(fontSize: 16),
                  ),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: <String>['Low', 'Medium', 'High']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                    widget.onPrioritySelected(newValue!);
                  },
                ),
              ],
            ),

          // buttons -> save + cancel
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            // save button
            MyButton(text: "Save", onPressed: widget.onSave ),

            const SizedBox(width: 8),

            // cancel button
            MyButton(text: "Cancel", onPressed: widget.onCancel ),
          ],
          ),
        ],
        ),
      )
    );
  }
}