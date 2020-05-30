import 'globals.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'config.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/services.dart';
import 'dart:math';
void tilt(){
  final subscription = accelerometerEvents.listen((AccelerometerEvent event) {
    gcurr = event.y;
  });
}

void _send(char) {
  print("Sending " + char);
  sock.write('wasd'+'&'+char+'%');
}
void tsend(){
  if(gcurr>0.6){
    String s = (min(gcurr/7,1)*min(gcurr/7,1)).toString();
    sock.write("tilt&+&"+s+'%');
  }else if(gcurr<-0.6){
    String s =  (min((-1*gcurr)/7,1)*min((-1*gcurr)/7,1)).toString();
    sock.write("tilt&-&"+s+'%');
  }else{
    sock.write("tilt&+&"+'0'+'%');
  } 
}
class Gyro extends StatefulWidget{
  @override
  _GyroState createState() => _GyroState();
}
class _GyroState extends State<Gyro> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tiltcontrol = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    if(!ovisit){
      tilt();
      Timer.periodic(Duration(milliseconds:50),(Timer t){
        if(tiltcontrol){
          tsend();
        }
      });
      ovisit=true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilt to Control"),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              setState((){
                tiltcontrol = !tiltcontrol;
              });
              if(!tiltcontrol)
                    sock.write("tilt&0%");
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Tilting mode has been turned ' + (tiltcontrol?'ON':'OFF'))));
            },
            icon: Icon(Icons.rotate_left, color:tiltcontrol?Colors.green:Colors.red),
          )
        ],
      ),
      body:Padding(padding: EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child:GestureDetector(
                onPanStart: (details) {
                  _send('down&s');
                  print('start');
                },
                onPanEnd: (details) {
                  _send('up&s');
                  print('end');
                },
                child: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(80.0),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 45.0,
                  ),
                ),
              ),
            ),
            Center(
              child:GestureDetector(
                onPanStart: (_) {
                  _send('down&w');
                },
                onPanEnd: (_) {
                  _send('up&w');
                },
                child: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(80.0),
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 45.0,
                  ),
                ),
              ),
            ),
        ]
    )
    )
    );
  }
}