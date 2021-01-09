import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FirebaseFirestore fs = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("History"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: fs.collection("History").orderBy("timestamp").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    if (snapshot.hasData) {
                      return new ListTile(
                        title: Text(
                          document.data()['Command'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      print("No data");
                    }
                  }).toList(),
                );
            }),
      ),
    );
  }
}
