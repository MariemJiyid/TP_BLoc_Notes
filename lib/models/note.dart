class Note {
  final String id;
  String titre;
  String contenu;
  String couleur;
  final DateTime dateCreation;
  DateTime? dateModification;

  Note({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.couleur,
    required this.dateCreation,
    this.dateModification,
  });

  // Convertit une Note en Map (pour la sauvegarder)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'couleur': couleur,
      'dateCreation': dateCreation.toIso8601String(),
      'dateModification': dateModification?.toIso8601String(),
    };
  }

  // Crée une Note depuis une Map (pour la charger)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      titre: json['titre'],
      contenu: json['contenu'],
      couleur: json['couleur'],
      dateCreation: DateTime.parse(json['dateCreation']),
      dateModification: json['dateModification'] != null
          ? DateTime.parse(json['dateModification'])
          : null,
    );
  }
}