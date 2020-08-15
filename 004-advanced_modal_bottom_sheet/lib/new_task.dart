import 'package:flutter/material.dart';

import 'models/task.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key key}) : super(key: key);

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
  final _dateController = TextEditingController();
  Task task = new Task();
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
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
      child: Expanded(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
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
                              return "Please enter a name for your transaction";
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              key: Key("dateField"),
                              onSaved: (val) {
                                task.date = selectedDate;
                              },
                              controller: _dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                labelText: "Date",
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                isDense: true,
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please enter a date for your transaction";
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
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
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter a description for your task";
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
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
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: RaisedButton(
                    key: Key("newTransactionButton"),
                    onPressed: () {
                      _submitForm(context);
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    highlightElevation: 2,
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff36F1AC), Color(0xff2ECCAC)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Create Task",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Add loading in button when clicked
  _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }
}
