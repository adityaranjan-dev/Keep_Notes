import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keepnotes/services/db.dart';
import 'package:keepnotes/model/note_model.dart';
import 'package:keepnotes/services/login_info.dart';

class FireDB {
  //CRUD
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == 'true') {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection('NOTES')
            .doc(currentUser!.email)
            .collection('USERNOTES')
            .doc(note.uniqueId)
            .set({
          'TITLE': note.title,
          'UNIQUEID': note.uniqueId,
          'CONTENT': note.content,
          'DATE': note.createdTime,
        }).then((_) {
          //print('Data added successfully');
        });
      }
    });
  }

  getAllStoredNotes() async {
    final User? currentUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection('NOTES')
        .doc(currentUser!.email)
        .collection('USERNOTES')
        .orderBy('DATE')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map note = result.data();
        NotesDatabase.instance.insertEntry(
          Note(
              title: note['TITLE'],
              uniqueId: note['UNIQUEID'],
              content: note['CONTENT'],
              createdTime: note['DATE'],
              pin: false,
              isArchive: false),
        ); //Add Notes In Database
      });
    });
  }

  updateNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == 'true') {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection('NOTES')
            .doc(currentUser!.email)
            .collection('USERNOTES')
            .doc(note.uniqueId.toString())
            .update({
          'TITLE': note.title.toString(),
          'CONTENT': note.content
        }).then((_) {});
      }
    });
  }

  deleteNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == 'true') {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection('NOTES')
            .doc(currentUser!.email.toString())
            .collection('USERNOTES')
            .doc(note.uniqueId.toString())
            .delete()
            .then((_) {});
      }
    });
  }
}
