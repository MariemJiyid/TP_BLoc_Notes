import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/connectivity_service.dart';
import 'create_page.dart';
import 'detail_page.dart';
import 'api_notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';
  bool _estConnecte = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _verifierConnexion();
    // Écoute les changements de connexion en temps réel
    _connectivityService.onConnectivityChanged.listen((connecte) {
      setState(() {
        _estConnecte = connecte;
      });
    });
  }

  // Vérifie la connexion au démarrage
  Future<void> _verifierConnexion() async {
    final connecte = await _connectivityService.isConnected();
    setState(() {
      _estConnecte = connecte;
    });
  }

  Color _hexToColor(String hex) {
    final hexClean = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexClean', radix: 16));
  }

  void _naviguerVersCreation(BuildContext context) async {
    final note = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const CreateNotePage()),
    );
    if (note != null && context.mounted) {
      context.read<NoteService>().addNote(note);
    }
  }

  void _naviguerVersDetail(BuildContext context, Note note) async {
    final resultat = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => DetailNotePage(note: note)),
    );
    if (!context.mounted) return;
    if (resultat == 'deleted') {
      context.read<NoteService>().deleteNote(note.id);
    } else if (resultat is Note) {
      context.read<NoteService>().updateNote(resultat);
    }
  }

  // Affiche un message selon la connexion
  void _afficherStatutConnexion() {
    final message = _estConnecte
        ? '✅ Connecté — Synchronisation API disponible'
        : '❌ Hors ligne — Notes locales uniquement';
    final couleur = _estConnecte ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: couleur,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Row(
          children: [
            const Text('Mes Notes'),
            const SizedBox(width: 8),
            Consumer<NoteService>(
              builder: (_, service, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${service.count}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Icône statut connexion
          IconButton(
            icon: Icon(
              _estConnecte ? Icons.wifi : Icons.wifi_off,
              color: _estConnecte ? Colors.green : Colors.red,
            ),
            tooltip: _estConnecte ? 'Connecté' : 'Hors ligne',
            onPressed: _afficherStatutConnexion,
          ),
          // Bouton API (seulement si connecté)
          IconButton(
            icon: Icon(
              Icons.cloud,
              color: _estConnecte ? Colors.white : Colors.grey,
            ),
            tooltip: _estConnecte ? 'Notes API' : 'Connexion requise',
            onPressed: () {
              if (_estConnecte) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApiNotesPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Pas de connexion internet !'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: 'Rechercher une note...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<NoteService>(
        builder: (context, service, __) {
          final notes = _query.isEmpty
              ? service.notes.toList()
              : service.search(_query);

          if (notes.isEmpty) {
            return Center(
              child: Text(
                _query.isEmpty
                    ? 'Aucune note\nAppuyez sur + pour créer'
                    : 'Aucun résultat pour "$_query"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final couleur = _hexToColor(note.couleur);
              final apercu = note.contenu.length > 30
                  ? '${note.contenu.substring(0, 30)}...'
                  : note.contenu;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => _naviguerVersDetail(context, note),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: couleur, width: 6),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.titre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          apercu,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${note.dateCreation.day}/${note.dateCreation.month}/${note.dateCreation.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _naviguerVersCreation(context),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}