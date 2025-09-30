import 'package:flutter/material.dart';
import 'tool.dart'; 

// Widget représentant une carte d'outil cliquable, dans un format compact (Icône + Titre).
class ToolTile extends StatelessWidget {
  final Tool tool;

  // Syntaxe correcte du constructeur.
  const ToolTile({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigue vers la destination de l'outil (sa page)
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => tool.destination,
            ),
          );
        },
        // Suppression du filtre bleu au tap
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // Retour à un padding vertical raisonnable pour la stabilité, tout en restant compact.
          // Haut: 4.0, Bas: 8.0, Gauche/Droite: 10.0
          padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 8.0), 
          child: Column(
            // Centre le contenu : icône et titre
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Icône
              Icon(
                tool.icon,
                size: 32, // Taille réduite
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4), // Espace réduit entre icône et texte
              // 2. Titre centré
              Text(
                tool.name,
                textAlign: TextAlign.center,
                // Utilisation d'un style de texte compact
                style: theme.textTheme.labelLarge?.copyWith( 
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}