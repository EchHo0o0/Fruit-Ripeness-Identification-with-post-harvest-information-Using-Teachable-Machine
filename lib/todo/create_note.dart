import 'package:flutter/material.dart';
import 'package:harvi/todo/note_model.dart';
import 'package:harvi/todo/sqlite.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes your next work",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                db
                    .createNote(NoteModel(
                  noteTitle: title.text,
                  noteContent: content.text,
                  createdAt: DateTime.now().toIso8601String(),
                ))
                    .whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              }
            },
            icon: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          // Makes content scrollable
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                16.0, // Adjust padding when keyboard appears
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: title,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a title" : null,
                decoration: InputDecoration(
                  hintText: "Enter work title",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Content",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: content,
                validator: (value) =>
                    value!.isEmpty ? "Please enter content" : null,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Enter your work information",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      db
                          .createNote(NoteModel(
                        noteTitle: title.text,
                        noteContent: content.text,
                        createdAt: DateTime.now().toIso8601String(),
                      ))
                          .whenComplete(() {
                        Navigator.of(context).pop(true);
                      });
                    }
                  },
                  child: const Text(
                    "Save Notes",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
