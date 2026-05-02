import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? note;

  const CreateNotePage({super.key, this.note});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late TextEditingController _titreController;
  late TextEditingController _contenuController;
  String _couleurChoisie = '#FFE082';

  final List<String> _couleurs = [
    '#c5b074',
    '#80CBC4',
    '#EF9A9A',
    '#90CAF9',
    '#CE93D8',
    '#A5D6A7',
  ];

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.note?.titre ?? '');
    _contenuController = TextEditingController(text: widget.note?.contenu ?? '');
    if (widget.note != null) {
      _couleurChoisie = widget.note!.couleur;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    final hexClean = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexClean', radix: 16));
  }

  void _sauvegarder() {
    if (_titreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre ne peut pas être vide !')),
      );
      return;
    }

    Note note;

    if (widget.note == null) {
      note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        couleur: _couleurChoisie,
        dateCreation: DateTime.now(),
      );
    } else {
      note = widget.note!;
      note.titre = _titreController.text.trim();
      note.contenu = _contenuController.text.trim();
      note.couleur = _couleurChoisie;
      note.dateModification = DateTime.now();
    }

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    final estModification = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(estModification ? 'Modifier la note' : 'Nouvelle Note'),
        backgroundColor: _hexToColor(_couleurChoisie),
        actions: [
          IconButton(
            onPressed: _sauvegarder,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titreController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Titre de la note',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contenuController,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Contenu...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Couleur :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _couleurs.map((hex) {
                final estSelectionnee = hex == _couleurChoisie;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _couleurChoisie = hex;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _hexToColor(hex),
                      shape: BoxShape.circle,
                      border: estSelectionnee
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.transparent, width: 3),
                      boxShadow: estSelectionnee
                          ? [const BoxShadow(blurRadius: 6, color: Colors.black26)]
                          : [],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sauvegarder,
                icon: const Icon(Icons.save),
                label: Text(estModification ? 'Modifier' : 'Sauvegarder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hexToColor(_couleurChoisie),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}