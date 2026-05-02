import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailNotePage extends StatelessWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  Color _hexToColor(String hex) {
    final hexClean = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexClean', radix: 16));
  }

  String _formaterDate(DateTime date) {
    final mois = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final heure = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${mois[date.month - 1]} ${date.year} à $heure:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final couleur = _hexToColor(note.couleur);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleur,
        title: const Text('Détail de la note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final noteModifiee = await Navigator.push<Note>(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateNotePage(note: note),
                ),
              );
              if (noteModifiee != null && context.mounted) {
                Navigator.pop(context, noteModifiee);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmerSuppression(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.titre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Créée le ${_formaterDate(note.dateCreation)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            if (note.dateModification != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.edit_calendar, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Modifiée le ${_formaterDate(note.dateModification!)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              note.contenu.isEmpty ? '(Aucun contenu)' : note.contenu,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmerSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la note ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'deleted');
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}