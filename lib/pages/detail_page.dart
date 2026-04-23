import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailPage extends StatelessWidget {
  final Note note;

  DetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détail"),
        backgroundColor:
            Color(int.parse(note.couleur.replaceFirst('#', '0xff'))),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePage(note: note),
                ),
              );

              if (updatedNote != null) {
                Navigator.pop(context, updatedNote);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, "deleted");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.titre,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Créée le: ${note.dateCreation}"),
              SizedBox(height: 20),
              Text(note.contenu),
            ],
          ),
        ),
      ),
    );
  }
}