import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_sqflite/models/task_model.dart';
import 'package:todo_with_sqflite/pages/add_task_page.dart';
import 'package:todo_with_sqflite/services/sqflite_service.dart';
class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  static const String id = "task_list_page";

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat("MMM dd, yyyy");

  void _updateTaskList(){
    setState(() {
      _taskList = DBHelper().getTaskList();
    });
  }


  initState(){
    super.initState();
    _updateTaskList();
  }



  _buildItem(Task task){
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      color: Colors.indigo,
      child: ListTile(
        title: Text(task.title!, style: TextStyle(color: Colors.yellow, fontSize: 24),),
        subtitle: Text(_dateFormat.format(task.date),style: TextStyle(color: Colors.yellow, fontSize: 12),),
        trailing: Checkbox(
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool? value){},
          value: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _taskList,
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Text("Data not found");
            } else{
              return ListView.builder(
                itemCount: snapshot.data.length+1,
                itemBuilder: (context, int index){
                  if(index == 0){
                    return Container(
                      child: Text("My Tasks", style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),),
                    );
                  } else{
                    return _buildItem(snapshot.data[index-1]);
                  }
                },
              );
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage(updateTaskList: _updateTaskList))),
        child: Icon(Icons.add),
      ),
    );
  }
}
