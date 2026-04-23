import 'package:flutter/material.dart';
import '../models/note.dart';

SortType _sortType = SortType.dateDesc;
enum SortType {
  dateDesc,
  dateAsc,
  titleAsc,
  titleDesc,
}
class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];

  void setSortType(SortType type) {
  _sortType = type;
  notifyListeners();
}

  List<Note> search(String query) {
  if (query.isEmpty) return _notes;

  return _notes.where((note) {
    return note.titre.toLowerCase().contains(query.toLowerCase()) ||
           note.contenu.toLowerCase().contains(query.toLowerCase());
  }).toList();
}

  List<Note> get notes {
  List<Note> sorted = List.from(_notes);

  switch (_sortType) {
    case SortType.dateDesc:
      sorted.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
      break;

    case SortType.dateAsc:
      sorted.sort((a, b) => a.dateCreation.compareTo(b.dateCreation));
      break;

    case SortType.titleAsc:
      sorted.sort((a, b) => a.titre.compareTo(b.titre));
      break;

    case SortType.titleDesc:
      sorted.sort((a, b) => b.titre.compareTo(a.titre));
      break;
  }

  return sorted;
}

  int get count => _notes.length;

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(Note note) {
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }
}