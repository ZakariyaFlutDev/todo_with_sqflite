import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_sqflite/models/task_model.dart';
import 'package:todo_with_sqflite/services/sqflite_service.dart';

class AddTaskPage extends StatefulWidget {

  final Function? updateTaskList;

  const AddTaskPage({this.updateTaskList});

  static const String id ="add_task";

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  String _priority = "Low";
  DateTime _date = DateTime.now();

  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ["Low", "Medium", "High"];

  _handleDataPicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));

    if (date != _date) {
      setState(() {
        _date = date as DateTime;
      });
      _dateController.text = _dateFormat.format(date!);
    }
  }

  _submit(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      Task task = new Task(title: _title, date: _date, priority: _priority);

      task.status =0;
      DBHelper().insertTask(task);
      if(widget.updateTaskList != null) widget.updateTaskList!();
      Navigator.pop(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                "Create Task",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: "Title"),
                      onSaved: (input) => _title = input,
                      validator: (input) => input!.trim().isEmpty
                          ? "Please enter task title"
                          : null,
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(labelText: "Date"),
                      onTap: _handleDataPicker,
                      controller: _dateController,
                    ),
                    DropdownButtonFormField(
                      icon: Icon(Icons.arrow_drop_down),
                        decoration: InputDecoration(labelText: "Priority"),
                        items: _priorities.map((prop){
                          return DropdownMenuItem<String>(
                            value: prop,
                            child: Text(prop, style: TextStyle(color: Colors.black),),
                          );
                        }).toList(),
                        onChanged: (String? value){
                          setState(() {
                            _priority = value! as String;
                          });
                        },
                        value: _priority,

                    )
                  ],
                ),
              ),
              TextButton(onPressed: _submit, child: Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
