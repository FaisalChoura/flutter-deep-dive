import 'package:date_time_field/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewTaskForm extends StatefulWidget {
  NewTaskForm({Key key}) : super(key: key);

  @override
  _NewTaskFormState createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  Task task = new Task();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _dateController.text = date;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            children: [
              TextFormField(
                onSaved: (val) => task.name = val,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  icon: Icon(Icons.account_circle),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    onSaved: (val) {
                      task.date = selectedDate;
                    },
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      icon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter a date for your task";
                      return null;
                    },
                  ),
                ),
              ),
              FlatButton(
                child: Text("Submit"),
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
