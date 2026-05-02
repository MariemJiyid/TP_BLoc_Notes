import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];
  final SharedPreferences _prefs;
  static const String _cleStockage = 'notes_sauvegardees';

  // Constructeur qui reçoit SharedPreferences
  NoteService(this._prefs) {
    _loadNotes();
  }

  // Retourne une copie non-modifiable
  List<Note> get notes => List.unmodifiable(_notes);

  // Nombre total de notes
  int get count => _notes.length;

  // Charge les notes depuis SharedPreferences au démarrage
  void _loadNotes() {
    final String? donneesJson = _prefs.getString(_cleStockage);
    if (donneesJson != null) {
      final List<dynamic> liste = jsonDecode(donneesJson);
      _notes.clear();
      _notes.addAll(liste.map((item) => Note.fromJson(item)));
      notifyListeners();
    }
  }

  // Sauvegarde toutes les notes dans SharedPreferences
  Future<void> _saveNotes() async {
    final String donneesJson = jsonEncode(
      _notes.map((note) => note.toJson()).toList(),
    );
    await _prefs.setString(_cleStockage, donneesJson);
  }

  // Ajoute une note en tête de liste
  void addNote(Note note) {
    _notes.insert(0, note);
    _saveNotes();
    notifyListeners();
  }

  // Remplace la note ayant le même id
  void updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      _saveNotes();
      notifyListeners();
    }
  }

  // Supprime la note avec cet id
  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _saveNotes();
    notifyListeners();
  }

  // Retourne une note par son id
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  // Recherche par titre ou contenu
  List<Note> search(String query) {
    if (query.trim().isEmpty) return notes.toList();
    final q = query.toLowerCase();
    return _notes.where((n) {
      return n.titre.toLowerCase().contains(q) ||
             n.contenu.toLowerCase().contains(q);
    }).toList();
  }
}