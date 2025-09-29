import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Le code utilise un Wrap pour s'assurer que si l'écran est très étroit,
    // le texte passe à la ligne sans déborder.
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0, // Espacement horizontal
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Texte principal
        Text(
          "Coded with ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        
        // Icône du cœur
        const Icon(
          Icons.favorite, 
          color: Colors.red, 
          size: 14
        ),

        // Texte de la signature
        Text(
          " par ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),

        // Signature XR avec icône d'humain sur ordinateur
        const Icon(
          Icons.computer, // Icône d'humain/développeur sur ordinateur
          size: 14,
        ),
        Text(
          "XR",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),

        // Séparateur
        Text(
          " & ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),

        // Signature Claude avec icône robot
        const Icon(
          Icons.smart_toy, // Icône robot Android-style
          size: 14,
        ),
        Text(
          "Claude",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        
        // Numéro de version avec convention MAJEURE.MINEURE.DDMMAA
        Text(
          " - Version v1.1.280925",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}