import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {

  final String taskName;
  final bool taskCompleted;
  final String taskPriority;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;


   const ToDoTile({
    super.key, 
    required this.taskName, 
    required this.taskCompleted, 
    required this.taskPriority,
    required this.onChanged,
    required this.deleteFunction,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(), 
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // checkbox
              Checkbox(
                value: taskCompleted, 
                onChanged: onChanged,
                activeColor: Colors.black,
                ),
        
              // task name and priority
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName,
                    style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.bold, // Add this for emphasis
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    taskPriority,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700], // Subtitle color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}