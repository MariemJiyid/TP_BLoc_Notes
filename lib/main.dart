import 'package:bloc_notes/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteService(),
      child: MyApp(),
    ),
  );
}

