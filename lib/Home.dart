import 'package:TerminalApp/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller;
  FirebaseFirestore fs = FirebaseFirestore.instance;
  String output = "";

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: Text("TerminalApp"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
              },
              iconSize: 30,
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Container(
                        child: Text(
                          output,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 280,
                    margin: EdgeInsets.only(
                        left: 30, top: 10, bottom: 20, right: 20),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hoverColor: Colors.red,
                        focusColor: Colors.green,
                        fillColor: Colors.white24,
                        filled: true,
                      ),
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    iconSize: 50,
                    color: Colors.green,
                    onPressed: () => getoutput(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getoutput() async {
    var r = await http
        .get("http://192.168.43.20/cgi-bin/terminal.py?cmd=${controller.text}");
    print(r.body);
    fs
        .collection("History")
        .add({"Command": controller.text, "timestamp": Timestamp.now()});

    setState(() {
      output = "\n" + r.body;
      controller.clear();
    });
  }
}
