import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Custom.dart';
import 'DatabaseHelper.dart';

class ButtonChoice extends StatefulWidget {
  final CustomState parent;
  ButtonChoiceState state;
  ButtonChoice(this.parent);

  @override
  ButtonChoiceState createState() {
    this.state = new ButtonChoiceState();
    return this.state;
  }
}

class ButtonChoiceState extends State<ButtonChoice> {
  String alphabet = 'A';
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Select Button Type:',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      this.widget.parent.setState(() {
                        this.widget.parent.buttonList.add(CustomButton(
                            this.widget.parent,
                            this.widget.parent.buttonList.length,
                            alphabet));
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Alphabet (' + alphabet + ')',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  Slider(
                    value: alphabet.codeUnitAt(0).toDouble(),
                    min: 'A'.codeUnitAt(0).toDouble(),
                    max: 'Z'.codeUnitAt(0).toDouble(),
                    divisions: 30,
                    activeColor: Colors.red,
                    inactiveColor: Colors.black,
                    onChanged: (double newValue) {
                      setState(() {
                        alphabet = String.fromCharCode(newValue.toInt());
                      });
                    },
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      this.widget.parent.setState(() {
                        this.widget.parent.buttonList.add(CustomButton(
                            this.widget.parent,
                            this.widget.parent.buttonList.length,
                            'space'));
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Space',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      this.widget.parent.setState(() {
                        this.widget.parent.buttonList.add(CustomButton(
                            this.widget.parent,
                            this.widget.parent.buttonList.length,
                            'shift'));
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Shift',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LayoutSave extends StatefulWidget {
  final CustomState parent;
  LayoutSaveState state;
  LayoutSave(this.parent);

  @override
  LayoutSaveState createState() {
    this.state = new LayoutSaveState();
    return this.state;
  }
}

class LayoutSaveState extends State<LayoutSave> {
  TextEditingController layoutName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 400.0,
        width: 300.0,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: layoutName,
                decoration:
                    InputDecoration(labelText: 'Enter the name of the layout'),
                validator: (value) {
                  // value = value.trim();
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    String name = '$value';
                    for (int i = 0; i < name.length; i++) {
                      var ch = name.codeUnitAt(i);
                      if (ch != 32 &&
                          !(ch >= 48 && ch <= 57) &&
                          !(ch >= 65 && ch <= 90) &&
                          !(ch >= 97 && ch <= 122))
                        return 'Layout name must only consist of digits, alphabets and spaces';
                    }
                  }
                  return null;
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                    onPressed: () async{
                      if (_formKey.currentState.validate()) {
                        var check = await createTable(layoutName.text);
                        if(check){
                          this.widget.parent.layoutName = layoutName.text;
                          this.widget.parent.scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                'Created and saved layout "${layoutName.text}"'),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.pop(context);
                        }
                        else{
                          this.widget.parent.scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                'There already exists a layout with name "${layoutName.text}"'),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

