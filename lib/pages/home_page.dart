import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp_task/util/dialog_box.dart';
import '../data/database.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {

    // if this is the 1st time ever opening the app, then create default data
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else{
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  

  String selectedPriority = "Low"; // default priority

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false, selectedPriority]);
      _controller.clear();
      sortTasks();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // handle priority selection
  void handlePrioritySelected(String priority) {
    selectedPriority = priority;
  }


  // create a new task
  void createNewTask(){
    showDialog
    (context: context, 
    builder: (context){
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
        onPrioritySelected: handlePrioritySelected,
      );
    },
    );
  }

  // delete a task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  // sort the task list by priority and name
   void sortTasks() {
  setState(() {
    db.toDoList.sort((a, b) {
      int priorityA = _getPriorityValue(a[2]);
      int priorityB = _getPriorityValue(b[2]);

      int priorityComparison = priorityA.compareTo(priorityB);
      if (priorityComparison != 0) return priorityComparison;
      return a[0].compareTo(b[0]); // Compare names if priority is the same
    });
  });
  db.updateDataBase();
}

// Helper function to assign numerical values to priorities
int _getPriorityValue(String priority) {
  switch (priority) {
    case "High":
      return 1;
    case "Medium":
      return 2;
    case "Low":
      return 3;
    default:
      return 4; // In case of an unexpected value, though it shouldn't happen
  }
}

  @override
  Widget build(BuildContext context) {
    
    int totalTasks = db.toDoList.length;
    int completedTasks = db.toDoList.where((task) => task[1] == true).length;

    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('TO DO'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
        shape: const CircleBorder(),
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Total Tasks: $totalTasks | Completed: $completedTasks"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0], 
                  taskCompleted: db.toDoList[index][1],
                  taskPriority: db.toDoList[index][2], 
                  onChanged:(value) => checkBoxChanged(value, index),
                  deleteFunction: (p0) => deleteTask(index),
            );
          },
        ),
      ),
      ],
      ),
    );
  }
}