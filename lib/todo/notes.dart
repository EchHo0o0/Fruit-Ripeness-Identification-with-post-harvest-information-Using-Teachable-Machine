import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:harvi/todo/note_model.dart';
import 'package:harvi/todo/sqlite.dart';
import 'package:harvi/todo/create_note.dart'; // Adjusted path: removed extra '/'

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DatabaseHelper();
  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    notes = handler.getNotes();
    handler.initDB().whenComplete(() {
      setState(() {
        notes = getAllNotes();
      });
    });
    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotes();
  }

  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      // Scaffold background will adapt via MaterialApp theme
      appBar: AppBar(
        title: const Text(
          "Plants Observation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // AppBar background will adapt via MaterialApp theme
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNote()),
          ).then((value) {
            if (value) {
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add,
            color: Colors.white), // Icon color for visibility
        backgroundColor: theme.primaryColor, // Use primary color from theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                // Use theme's card color or a slightly different shade for search bar
                color: isDarkMode ? Colors.grey[700] : Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: keyword,
                onChanged: (value) {
                  setState(() {
                    notes = value.isNotEmpty ? searchNote() : getAllNotes();
                  });
                },
                style: TextStyle(
                    color:
                        theme.textTheme.bodyLarge?.color), // Text input color
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search,
                      color: isDarkMode ? Colors.white70 : Colors.black54),
                  hintText: "Search notes...",
                  hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<NoteModel>>(
                future: notes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      "No notes available",
                      style:
                          TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Error: ${snapshot.error}",
                      style:
                          TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ));
                  } else {
                    final items = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final note = items[index];
                        return Card(
                          // Card background color adapts to theme
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              note.noteTitle,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyLarge
                                      ?.color), // Text color
                            ),
                            subtitle: Text(
                              DateFormat("MMM d, yyyy")
                                  .format(DateTime.parse(note.createdAt)),
                              style: TextStyle(
                                  color: theme.textTheme.bodyMedium
                                      ?.color), // Text color
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility,
                                      color: isDarkMode
                                          ? Colors.blueAccent
                                          : Colors.blue),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          // AlertDialog background adapts to theme
                                          backgroundColor:
                                              theme.scaffoldBackgroundColor,
                                          title: Center(
                                            child: Text(
                                              note.noteTitle,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: theme
                                                    .primaryColor, // Keep green accent
                                              ),
                                            ),
                                          ),
                                          content: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              // Content background adapts to theme
                                              color: isDarkMode
                                                  ? Colors.grey[700]
                                                  : Colors.green[50],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            constraints: const BoxConstraints(
                                              minHeight: 180,
                                              maxHeight: 400,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 12),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                      note.noteContent,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.color, // Text color
                                                        height: 1.5,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: theme
                                                    .primaryColor, // Use primary color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                "Close",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    db.deleteNote(note.noteId!).whenComplete(
                                          () => _refresh(),
                                        );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              title.text = note.noteTitle;
                              content.text = note.noteContent;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    // AlertDialog background adapts to theme
                                    backgroundColor:
                                        theme.scaffoldBackgroundColor,
                                    title: Text(
                                      "Update Notes",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.textTheme.bodyLarge
                                            ?.color, // Text color
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: title,
                                            style: TextStyle(
                                                color: theme.textTheme.bodyLarge
                                                    ?.color),
                                            decoration: InputDecoration(
                                              labelText: "Title",
                                              labelStyle: TextStyle(
                                                  color: theme.textTheme
                                                      .bodyMedium?.color),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: isDarkMode
                                                      ? Colors.grey[600]!
                                                      : Colors.grey,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: theme.primaryColor,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: content,
                                            maxLines: 5,
                                            style: TextStyle(
                                                color: theme.textTheme.bodyLarge
                                                    ?.color),
                                            decoration: InputDecoration(
                                              labelText: "Content",
                                              labelStyle: TextStyle(
                                                  color: theme.textTheme
                                                      .bodyMedium?.color),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: isDarkMode
                                                      ? Colors.grey[600]!
                                                      : Colors.grey,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: theme.primaryColor,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: theme
                                                  .textTheme.bodyMedium?.color),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          db
                                              .updateNote(
                                            title.text,
                                            content.text,
                                            note.noteId,
                                          )
                                              .whenComplete(() {
                                            _refresh();
                                            Navigator.pop(context);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme
                                              .primaryColor, // Use primary color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text("Update",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
