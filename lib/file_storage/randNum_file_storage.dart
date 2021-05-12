import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class randNumStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/randNum.txt');
  }

  Future<int> readRandNum() async {
    try {
      final file = await _localFile;
      print("Loading random number from file storage");

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeRandNum(int randNum) async {
    final file = await _localFile;
    print("Saving random number to file storage");
    // Write the file
    return file.writeAsString('$randNum');
  }
}
