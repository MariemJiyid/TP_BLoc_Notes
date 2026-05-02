import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class ApiService {
  // Serveur de test gratuit
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET /posts — Récupère toutes les notes depuis le serveur
  Future<List<Note>> getAllNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // On prend seulement les 10 premiers pour ne pas surcharger
        return data.take(10).map((item) => Note(
          id: item['id'].toString(),
          titre: item['title'] ?? 'Sans titre',
          contenu: item['body'] ?? '',
          couleur: '#FFE082',
          dateCreation: DateTime.now(),
        )).toList();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // POST /posts — Crée une nouvelle note sur le serveur
  Future<Note> createNote(String titre, String contenu) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': titre,
          'body': contenu,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Note(
          id: data['id'].toString(),
          titre: titre,
          contenu: contenu,
          couleur: '#80CBC4',
          dateCreation: DateTime.now(),
        );
      } else {
        throw Exception('Erreur création: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // DELETE /posts/id — Supprime une note sur le serveur
  Future<bool> deleteNote(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}