import 'package:flutter/material.dart';
import 'package:keepnotes/colors.dart';
import 'package:keepnotes/services/db.dart';
import 'package:keepnotes/home.dart';
import 'package:keepnotes/model/note_model.dart';

class EditNoteView extends StatefulWidget {
  final Note? note;
  const EditNoteView({super.key, required this.note});

  @override
  _EditNoteViewState createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late String newTitle;
  late String newNoteDet;

  @override
  void initState() {
    super.initState();
    newTitle = widget.note!.title.toString();
    newNoteDet = widget.note!.content.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              Note newNote = Note(
                  uniqueId: widget.note!.uniqueId,
                  content: newNoteDet,
                  title: newTitle,
                  createdTime: widget.note!.createdTime,
                  isArchive: widget.note!.isArchive,
                  pin: widget.note!.pin,
                  id: widget.note!.id);
              await NotesDatabase.instance.updateNote(newNote);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
            icon: const Icon(
              Icons.save_outlined,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                initialValue: newTitle,
                cursorColor: white,
                onChanged: (value) {
                  newTitle = value;
                },
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            Container(
              height: 300,
              child: Form(
                child: TextFormField(
                  onChanged: (value) {
                    newNoteDet = value;
                  },
                  initialValue: newNoteDet,
                  cursorColor: white,
                  keyboardType: TextInputType.multiline,
                  minLines: 50,
                  maxLines: null,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Note',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
