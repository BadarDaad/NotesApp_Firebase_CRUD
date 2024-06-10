import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //create: add a new one

  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //read : Get notes from database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //update: update notes given a doc id
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //delete: deleting note given a sdoc id
  Future<void> deleteNotes(String docID) {
    return notes.doc(docID).delete();
  }
}
