import 'package:flutter/material.dart';

import 'models/task.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, top: 24, left: 16, right: 16),
                  child: Text(
                    "New Transaction",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            NewTaskForm(),
          ],
        ),
      ),
    );
  }
}

class NewTaskForm extends StatefulWidget {
  const NewTaskForm({
    Key key,
  }) : super(key: key);

  @override
  NewTaskFormState createState() => NewTaskFormState();
}

class NewTaskFormState extends State<NewTaskForm> {
  final _formKey = GlobalKey<FormState>();
  Task task = new Task();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: TextFormField(
                    key: Key("nameField"),
                    onSaved: (val) => task.name = val,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter a name for your task";
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: TextFormField(
                    onSaved: (val) => task.dueDate = val,
                    decoration: InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: TextFormField(
                    key: Key("descriptionField"),
                    onSaved: (val) => task.description = val,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: TextFormField(
                    maxLines: 4,
                    onSaved: (val) => task.notes = val,
                    decoration: InputDecoration(
                      labelText: "Notes",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("Create Task"),
                  onPressed: () => _submitForm(context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _submitForm(BuildContext context) {
    // More to be added here
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }
}
