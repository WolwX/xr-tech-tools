// lib/screens/bios_boot_home_screen.dart

import 'package:flutter/material.dart';
import '../models/bios_boot_data.dart';
import '../data/bios_manufacturers_data.dart';
import 'bios_boot_category_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../data/tool_data.dart';
import '../widgets/app_footer.dart';

class BiosBootHomeScreen extends StatelessWidget {
  const BiosBootHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Touches BIOS / Boot',
        titleIcon: Icons.keyboard,
        version: ToolVersions.biosBootTools,
        showBackButton: true,
        backgroundColor: const Color(0xFF00B0FF),
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                            // Header — ligne 1: icône en haut-gauche + titre à droite. Ligne 2: texte descriptif aligné à gauche.
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00B0FF).withOpacity(0.1),
                      const Color(0xFF1A237E).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00B0FF).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Première ligne: icône à gauche et titre à droite
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B0FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: Icon(Icons.keyboard, color: Colors.white, size: 26)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: const Text(
                              'Trouver les touches BIOS / Boot',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20, // increased size to match malfunction page
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Deuxième ligne: description alignée à gauche
                    const Text(
                      'Trouvez rapidement les touches pour accéder au BIOS/UEFI ou au menu de démarrage pour ce fabricant.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
                ),
                
                const SizedBox(height: 24),
                
                // Section Favoris
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star, color: Color(0xFFFFB300), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Favoris',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Marques fréquemment consultées :',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Grille 1x4 des favoris
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: [
                          _buildFavoriteCard(
                            context,
                            logoPath: 'assets/images/logos/hp.png',
                            title: 'HP',
                            category: HardwareCategory.laptopOem,
                            categoryIcon: Icons.laptop,
                            color: const Color(0xFF00B0FF),
                          ),
                          _buildFavoriteCard(
                            context,
                            logoPath: 'assets/images/logos/dell.png',
                            title: 'Dell',
                            category: HardwareCategory.laptopOem,
                            categoryIcon: Icons.laptop,
                            color: const Color(0xFF00B0FF),
                          ),
                          _buildFavoriteCard(
                            context,
                            logoPath: 'assets/images/logos/asus.png',
                            title: 'Asus',
                            category: HardwareCategory.laptopOem,
                            categoryIcon: Icons.laptop,
                            color: const Color(0xFF00B0FF),
                          ),
                          _buildFavoriteCard(
                            context,
                            logoPath: 'assets/images/logos/msi.png',
                            title: 'MSI',
                            category: HardwareCategory.desktopMotherboard,
                            categoryIcon: Icons.desktop_windows,
                            color: const Color(0xFF00E676),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
              // Titre section
              const Text(
                'Quel type de matériel ?',
                style: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),                const SizedBox(height: 16),
                
                // Boutons de catégories en grille 2x2
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildCategoryCard(
                      context,
                      category: HardwareCategory.laptopOem,
                      icon: Icons.laptop,
                      title: 'PC Portable',
                      descriptionWidget: _buildBrandLogosRow(['hp', 'dell', 'asus']),
                      color: const Color(0xFF00B0FF),
                    ),
                    _buildCategoryCard(
                      context,
                      category: HardwareCategory.desktopMotherboard,
                      icon: Icons.desktop_windows,
                      title: 'PC Fixe',
                      descriptionWidget: _buildBrandLogosRow(['msi']),
                      color: const Color(0xFF00E676),
                    ),
                    _buildCategoryCard(
                      context,
                      category: HardwareCategory.desktopMotherboard,
                      icon: Icons.memory,
                      title: 'Carte Mère',
                      description: 'Marques de cartes mères',
                      color: const Color(0xFFFF6F00),
                    ),
                    _buildCategoryCard(
                      context,
                      category: HardwareCategory.tablet,
                      icon: Icons.tablet,
                      title: 'Tablette/Surface',
                      description: 'Microsoft Surface',
                      color: const Color(0xFF9C27B0),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
              // Section groupes
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: Offset(0,4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.group, color: Color(0xFFFFB300), size: 20),
                        SizedBox(width: 8),
                        Text('Groupes de fabricants', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...BiosManufacturersData.manufacturerGroups.map((group) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: _buildGroupItem(context, group))),
                  ],
                ),
              ),
                
                const SizedBox(height: 24),
                
              // Bouton recherche avancée
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navigation vers recherche
                },
                icon: const Icon(Icons.search, color: Colors.black87),
                label: const Text('Recherche avancée (A-Z)', style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ], // children of Column
          ), // Column
        ), // SingleChildScrollView
      ), // SafeArea
  ); // Scaffold
  }
  
  Widget _buildCategoryCard(
    BuildContext context, {
    required HardwareCategory category,
    required IconData icon,
    required String title,
    String? description,
    Widget? descriptionWidget,
    required Color color,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BiosBootCategoryScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              if (descriptionWidget != null)
                descriptionWidget
              else if (description != null)
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGroupItem(BuildContext context, ManufacturerGroup group) {
    return InkWell(
      onTap: () {
        // TODO: Afficher détails du groupe
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              group.groupName,
              style: const TextStyle(color: Colors.black87),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIOS: ${group.bios.join(", ")}',
                  style: const TextStyle(
                    color: Color(0xFF00B0FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Boot: ${group.boot.join(", ")}',
                  style: const TextStyle(
                    color: Color(0xFF00E676),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  group.description,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: group.manufacturers.map((name) => 
                    Chip(
                      label: Text(name),
                      backgroundColor: Colors.grey.withOpacity(0.12),
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    )
                  ).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: Offset(0,2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${group.manufacturers.length} marques',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.info_outline,
              color: Colors.black45,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandLogosRow(List<String> brandNames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: brandNames.map((brand) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logos/${brand.toLowerCase()}.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Si pas d'image, on affiche seulement le texte (déjà géré plus bas)
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 4),
              Text(
                brand,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required String logoPath,
    required String title,
    required HardwareCategory category,
    required IconData categoryIcon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Navigation vers la catégorie puis vers le fabricant spécifique
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BiosBootCategoryScreen(category: category),
          ),
        );
        // TODO: Dans le futur, naviguer directement vers le fabricant
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône de catégorie
            Icon(
              categoryIcon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            // Logo de la marque
            Image.asset(
              logoPath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to text if image fails to load
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      title.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}