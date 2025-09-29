import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// CORRECTION : Assurer que le chemin de l'écran est correct
import 'screens/introduction_screen.dart'; 

// Définition d'une couleur d'accent pour l'ensemble de l'application (le bleu)
const MaterialColor primaryBlue = MaterialColor(
  0xFF00B0FF, // Valeur principale
  <int, Color>{
    50: Color(0xFFE0F7FF),
    100: Color(0xFFB3E5FF),
    200: Color(0xFF80D8FF),
    300: Color(0xFF4DD0FF),
    400: Color(0xFF26C6FF),
    500: Color(0xFF00B0FF), // Notre couleur actuelle
    600: Color(0xFF00A2E6),
    700: Color(0xFF0091CC),
    800: Color(0xFF0081B3),
    900: Color(0xFF006399),
  },
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration plein écran immersif - garde la barre de statut
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.top], // Garde seulement la barre de statut (batterie, heure)
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XR Tech Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 1. Définition de la palette de couleurs
        primarySwatch: primaryBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryBlue,
          // La couleur de fond des Scaffolds (le gris très clair)
          backgroundColor: Colors.grey.shade50, 
        ).copyWith(
          // La couleur des accents et des boutons (notre bleu)
          primary: primaryBlue, 
          // La couleur utilisée pour les icônes sur la couleur principale
          onPrimary: Colors.white, 
        ),
        
        // 2. Thème pour l'AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // 3. Thème pour les ElevatedButton (boutons principaux)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Couleur du texte du bouton (blanc)
            backgroundColor: primaryBlue, // Couleur de fond du bouton (bleu)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        
        useMaterial3: true,
      ),
      // Retrait du 'const' devant IntroductionScreen() pour éviter l'erreur de constructeur
      home: IntroductionScreen(),
    );
  }
}