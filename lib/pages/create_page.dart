import 'package:flutter/material.dart';
import '../models/note.dart';

class CreatePage extends StatefulWidget {
  final Note? note;

  CreatePage({this.note});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titreController = TextEditingController();
  TextEditingController contenuController = TextEditingController();

  String selectedColor = "#FFFFFF";

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titreController.text = widget.note!.titre;
      contenuController.text = widget.note!.contenu;
      selectedColor = widget.note!.couleur;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Nouvelle Note" : "Modifier Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titreController,
              maxLength: 60,
              decoration: InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: contenuController,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(labelText: "Contenu"),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _color("#FFCDD2"),
                _color("#C8E6C9"),
                _color("#BBDEFB"),
                _color("#FFE082"),
                _color("#D1C4E9"),
                _color("#FFFFFF"),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (titreController.text.isEmpty) return;

                final note = Note(
                  id: widget.note?.id ?? DateTime.now().toString(),
                  titre: titreController.text,
                  contenu: contenuController.text,
                  couleur: selectedColor,
                  dateCreation:
                      widget.note?.dateCreation ?? DateTime.now(),
                  dateModification:
                      widget.note != null ? DateTime.now() : null,
                );

                Navigator.pop(context, note);
              },
              child: Text("Sauvegarder"),
            )
          ],
        ),
      ),
    );
  }

  Widget _color(String color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: Color(int.parse(color.replaceFirst('#', '0xff'))),
        child: selectedColor == color
            ? Icon(Icons.check, color: Colors.black)
            : null,
      ),
    );
  }
}