import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import './databases/rand_num_db.dart';
import './file_storage/randNum_file_storage.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int randNum = Random().nextInt(1900000);
  int loadRandNum = 0;

  DatabaseHelper randNumDB = DatabaseHelper(); // SQLite
  randNumStorage fileStorage = randNumStorage();
  int storageRandNum = 0;

  _saveFileStorage() {
    fileStorage.writeRandNum(randNum);
  }

  _loadFileStorage() {
    fileStorage.readRandNum().then((int value) => setState(() {
          storageRandNum = value;
        }));
  }

  _genRand() {
    setState(() {
      Random ran = new Random();
      randNum = ran.nextInt(1900000);
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  _saveRandSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('saved $randNum times.');
    await prefs.setInt('randNum', randNum);
    setState(() {
      loadRandNum = prefs.getInt('randNum');
    });
  }

  _loadRandSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadRandNum = prefs.getInt('randNum');
    });
  }

  Widget displayDatabaseData() {
    return FutureBuilder<int>(
        future: randNumDB.getRandNum(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Text((snapshot.data).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.green));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQFlite , Share Preferences, Storage"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Card(
            elevation: 8,
            child: Text(
              "You have generated random Number : $randNum",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
            ),
          ),
          Card(
            elevation: 7,
            child: Text(
              "You saved this number in shared preferences : $loadRandNum",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20 , color: Colors.deepPurple),
            ),
          ),
          Text(
            "The number saved in SQLite database:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.green),
          ),
          displayDatabaseData(),
          Card(
            elevation: 7,
            child: Text(
              "You saved this number in File Storage : $storageRandNum",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _loadRandSP(),
                  child: Text('Load'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _genRand(),
                  child: Text('Random'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _saveRandSP(),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    randNumDB.getRandNum();
                  }),
                  child: Text('Load from SQLite'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => randNumDB
                      .insertRandNum(RandNumData(id: 1, number: randNum)),
                  child: Text('Save to SQLite'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _loadFileStorage(),
                  child: Text('Load from File'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _saveFileStorage(),
                  child: Text('Save to File'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
