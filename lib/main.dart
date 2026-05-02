import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'services/note_service.dart';

void main() async {
  // Obligatoire avant d'utiliser async dans main()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise SharedPreferences AVANT de lancer l'app
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(BlocNotesApp(prefs: prefs));
}

class BlocNotesApp extends StatelessWidget {
  final SharedPreferences prefs;

  const BlocNotesApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // On passe prefs au NoteService
      create: (_) => NoteService(prefs),
      child: MaterialApp(
        title: 'Bloc-Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}