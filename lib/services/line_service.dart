import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lemon/utilities/codes.dart';
import 'package:lemon/utilities/help_functions.dart';

class LineService {
  // METHOD: Adds a new line
  Future<void> addLine(String school, String name, String description) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final linesDocRef = FirebaseFirestore.instance
        .collection(school)
        .doc(school) // document same as school name
        .collection("Lines")
        .doc("Lines"); // single document to store all lines

    await linesDocRef.set({
      name: {
        "description": description,
        "waiting": 0,
        "open": false,
        "queue": [],
      },
    }, SetOptions(merge: true));
  }

  // METHOD: Get's the current 'Lines' collection
  Stream<DocumentSnapshot<Map<String, dynamic>>> getLines(String school) {
    return FirebaseFirestore.instance
        .collection(school)
        .doc(school)
        .collection("Lines")
        .doc("Lines")
        .snapshots();
  }

  // METHOD: With the 'lineName' adds the current user to the Line
  Future<void> joinLine(String lineName, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    final linesDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines");

    final userDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Students")
        .doc(uid);

    final lineSnapshot = await linesDocRef.get();
    final lineData = lineSnapshot.data()?[lineName];

    if (lineData == null) return;

    List<dynamic> queue = lineData['queue'] ?? [];

    if (await checkLine(lineName, context)) return;

    queue.add(user.uid);

    await linesDocRef.update({
      "$lineName.queue": queue,
      "$lineName.waiting": queue.length,
    });

    await userDocRef.update({"currentLine": lineName});
  }

  // METHOD: Remove the user from the current line
  Future<void> removeFromLine(
    String lineName,
    BuildContext context, [
    String? uid,
  ]) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (uid == "") {
      uid = user.uid;
    }

    final linesDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines");

    final userDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Students")
        .doc(uid);

    final lineSnapshot = await linesDocRef.get();
    final lineData = lineSnapshot.data()?[lineName];

    if (lineData == null) return;

    List<dynamic> queue = lineData['queue'] ?? [];

    if (!(await checkLine(lineName, context, uid))) return;

    queue.remove(uid);
    await linesDocRef.update({
      "$lineName.queue": queue,
      "$lineName.waiting": queue.length,
    });
    await userDocRef.update({'currentLine': ""});
  }

  // METHOD: Checks if the current user is in the line
  Future<bool> checkLine(
    String lineName,
    BuildContext context, [
    String? uid,
  ]) async {
    if (uid == "") {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      uid = user.uid;
    }

    final linesDoc = await FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines")
        .get();

    final data = linesDoc.data()?[lineName];

    if (data == null) {
      displayMessageToUser("Line does not exist.", context);
      return false;
    }

    final queue = List<String>.from(data['queue'] ?? []);
    return queue.contains(uid);
  }

  Future<void> openLine(String name, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final linesDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines");
    await linesDocRef.set({
      name: {"open": true},
    }, SetOptions(merge: true));
  }

  Future<void> closeLine(String name, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final linesDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines");

    await linesDocRef.set({
      name: {"open": false},
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>?> getLineStream(String lineName) {
    return FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines")
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Stream<Map<String, dynamic>?> getAllLinesStream() {
    return FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines")
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  // METHOD: Rename a line
  Future<void> renameLine(String oldName, String newName) async {
    final linesDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines");

    final snapshot = await linesDocRef.get();
    final data = snapshot.data();
    if (data == null || !data.containsKey(oldName)) return;

    final lineData = data[oldName];

    // Copy old line data to new name
    await linesDocRef.update({newName: lineData});

    // Delete the old line
    await linesDocRef.update({oldName: FieldValue.delete()});
  }

  // METHOD: Delete a line
  Future<void> deleteLine(String lineName) async {
    final linesDocRef = FirebaseFirestore.instance
        .collection(Codes().currentSchool)
        .doc(Codes().currentSchool)
        .collection("Lines")
        .doc("Lines");

    await linesDocRef.update({lineName: FieldValue.delete()});
  }
}
