import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class ApiNotesPage extends StatefulWidget {
  const ApiNotesPage({super.key});

  @override
  State<ApiNotesPage> createState() => _ApiNotesPageState();
}

class _ApiNotesPageState extends State<ApiNotesPage> {
  final ApiService _apiService = ApiService();

  // Les 3 états possibles
  List<Note> _notes = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  // Charge les notes depuis le serveur au démarrage
  Future<void> _chargerNotes() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });

    try {
      final notes = await _apiService.getAllNotes();
      setState(() {
        _notes = notes;
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreur = 'Impossible de charger les notes.\nVérifiez votre connexion.';
        _chargement = false;
      });
    }
  }

  // Crée une nouvelle note via le serveur
  Future<void> _creerNote() async {
    try {
      final note = await _apiService.createNote(
        'Nouvelle note ${DateTime.now().hour}:${DateTime.now().minute}',
        'Contenu créé via API',
      );
      setState(() {
        _notes.insert(0, note);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Note créée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erreur lors de la création'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Supprime une note via le serveur
  Future<void> _supprimerNote(Note note, int index) async {
    final succes = await _apiService.deleteNote(note.id);
    if (succes) {
      setState(() {
        _notes.removeAt(index);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Note supprimée !'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erreur lors de la suppression'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes API'),
        backgroundColor: Colors.blue,
        actions: [
          // Bouton rafraîchir
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargerNotes,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _creerNote,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    // État 1 — Chargement
    if (_chargement) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement depuis le serveur...'),
          ],
        ),
      );
    }

    // État 2 — Erreur
    if (_erreur != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _erreur!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _chargerNotes,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    // État 3 — Liste des notes
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];

        // Dismissible permet de supprimer en glissant
        return Dismissible(
          key: Key(note.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _supprimerNote(note, index),
          child: Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  note.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                note.titre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                note.contenu,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.cloud_done, color: Colors.blue),
            ),
          ),
        );
      },
    );
  }
}