import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/services/firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

//open a dialoge box to add a note

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          // style: const TextStyle(color: Colors.orange),
          controller: textController,
        ),
        actions: [
          //button to savce
          ElevatedButton(
              onPressed: () {
                //add a new value
                if (docID == null) {
                  firestoreService.addNote(textController.text);
                } else {
                  firestoreService.updateNote(docID, textController.text);
                }

                //clear the text controller
                textController.clear();

                //close the box
                Navigator.pop(context);
              },
              child: const Text('Add'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent.shade100,
          title: const Text(
            'Notes',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openNoteBox,
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getNotesStream(),
            builder: (context, snapshot) {
//if we have data get all the docs
              if (snapshot.hasData) {
                List notesList = snapshot.data!.docs;

                // display as a list tile
                return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    //get each individual doc
                    DocumentSnapshot document = notesList[index];
                    String docID = document.id;

                    //get note from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String noteText = data['note'];

                    //display as list title

                    return ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => openNoteBox(docID: docID),
                              icon: const Icon(Icons.edit),
                            ),

                            //delete button

                            IconButton(
                              onPressed: () =>
                                  firestoreService.deleteNotes(docID),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ));
                  },
                );
              } else {
                //if no data then return nothing
                return const Text('No Data Found');
              }
            }));
  }
}
