import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../models/note.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = "";

  @override
  Widget build(BuildContext context) {
    final noteService = context.watch<NoteService>();

    final notes = _query.isEmpty
        ? noteService.notes
        : noteService.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Notes (${notes.length})"),
        actions: [  PopupMenuButton<SortType>(
    onSelected: (type) {
      context.read<NoteService>().setSortType(type);
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: SortType.dateDesc,
        child: Text("Date (récent → ancien)"),
      ),
      PopupMenuItem(
        value: SortType.dateAsc,
        child: Text("Date (ancien → récent)"),
      ),
      PopupMenuItem(
        value: SortType.titleAsc,
        child: Text("Titre (A → Z)"),
      ),
      PopupMenuItem(
        value: SortType.titleDesc,
        child: Text("Titre (Z → A)"),
      ),
    ],
  ),],
      ),

      body: Column(
        children: [
          // 🔍 BARRE DE RECHERCHE
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),

          // 📋 LISTE
          Expanded(
            child: notes.isEmpty
                ? Center(child: Text("Aucun résultat"))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Card(
                        child: ListTile(
                          title: Text(note.titre),
                          subtitle: Text(
                            note.contenu.length > 30
                                ? note.contenu.substring(0, 30) + "..."
                                : note.contenu,
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(note: note),
                              ),
                            );

                            if (result == "deleted") {
                              context
                                  .read<NoteService>()
                                  .deleteNote(note.id);
                            } else if (result is Note) {
                              context
                                  .read<NoteService>()
                                  .updateNote(result);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );

          if (newNote != null) {
            context.read<NoteService>().addNote(newNote);
          }
        },
      ),
    );
  }
}