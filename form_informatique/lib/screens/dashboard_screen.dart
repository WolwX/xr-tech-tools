import 'package:flutter/material.dart';
import '../data/tool_data.dart';
import '../widgets/app_footer.dart'; // Importe le pied de page

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adaptation dynamique du nombre de colonnes selon la largeur
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    
    return Scaffold(
      appBar: AppBar(
        // Titre plus compact
        title: const Text('XR Tech Tools \\ Dashboard'),
        // AppBar plus fine
        toolbarHeight: 50, // Réduit la hauteur de l'AppBar
      ),
      body: Column(
        children: [
          // Contenu principal qui prend l'espace disponible
          Expanded(
            child: SingleChildScrollView(
              // Padding encore plus réduit
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // 2 ou 3 colonnes selon l'écran
                      childAspectRatio: 1.4, // Plus large = tuiles plus basses
                      crossAxisSpacing: 6, // Espacement horizontal minimal
                      mainAxisSpacing: 6, // Espacement vertical minimal
                    ),
                    itemCount: availableTools.length,
                    itemBuilder: (context, index) {
                      final tool = availableTools[index];
                      return CompactToolTile(tool: tool);
                    },
                  ),
                ),
              ),
            ),
          ),
          // Footer fixe en bas, toujours visible
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const AppFooter(),
          ),
        ],
      ),
    );
  }
}

// Version compacte du ToolTile pour économiser l'espace
class CompactToolTile extends StatelessWidget {
  final dynamic tool; // Remplacez par votre type exact

  const CompactToolTile({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Ombre plus légère
      margin: EdgeInsets.zero, // Pas de marge externe
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Coins moins arrondis
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Votre logique de navigation
          if (tool.destination != null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => tool.destination),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding réduit
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône plus petite
              Icon(
                tool.icon ?? Icons.help_outline,
                size: 28, // Taille réduite de 40 à 28
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6), // Espace réduit
              // Texte plus compact
              Flexible(
                child: Text(
                  tool.name ?? 'Outil',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13, // Police plus petite
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}