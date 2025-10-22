// lib/screens/bios_boot_category_screen.dart

import 'package:flutter/material.dart';
import '../models/bios_boot_data.dart';
import '../data/bios_manufacturers_data.dart';
import 'bios_boot_detail_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_footer.dart';
import '../data/tool_data.dart';

enum KeyType {
  none,
  bios,
  boot,
}

class BiosBootCategoryScreen extends StatelessWidget {
  final HardwareCategory category;
  
  const BiosBootCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final standardKeys = BiosManufacturersData.standardKeysByCategory[category];
    final manufacturers = BiosManufacturersData.getByCategory(category);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: '${category.icon} ${category.displayName}',
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
              // Section touches standard (si disponibles)
              if (standardKeys != null) ...[
                const SizedBox(height: 16),
                
                // Conteneur unique pour toutes les touches avec clavier unifié
                Container(
                  width: double.infinity,
                  height: 280,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header avec titre
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00B0FF).withOpacity(0.1),
                              const Color(0xFF00E676).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard,
                              color: const Color(0xFF00B0FF),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Touches d\'accès BIOS / Boot Menu',
                              style: TextStyle(
                                color: const Color(0xFF00B0FF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Zone clavier avec touches mises en évidence
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: _buildKeyboardView(standardKeys.bios, standardKeys.boot),
                        ),
                      ),
                      // Légende des couleurs
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Texte d'instruction à gauche
                            if (standardKeys.bios.isNotEmpty || standardKeys.boot.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Appuyer sur UNE SEULE de ces touches',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            
                            // Légende des couleurs à droite
                            Row(
                              children: [
                                // BIOS/UEFI
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00B0FF),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'BIOS/UEFI',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                // Boot Menu
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00E676),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Boot Menu',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
              
              // Titre liste
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Marques concernées',
                    style: TextStyle(
                      color: Color(0xFF1A237E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${manufacturers.length} marques',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Liste des fabricants
              ...manufacturers.map((manufacturer) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildManufacturerCard(context, manufacturer),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Message si pas trouvé
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '❓ Votre marque n\'est pas dans la liste ?',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Essayez les touches standard ci-dessus, elles fonctionnent dans 80% des cas',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildKeyboardView(List<String> biosKeys, List<String> bootKeys) {
    // Collecte de toutes les touches mises en évidence
    final highlightedKeys = <String>[];
    highlightedKeys.addAll(biosKeys);
    highlightedKeys.addAll(bootKeys);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Clavier complet TKL avec toutes les touches en petit
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rangée 1: ESC + F1-F12
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!biosKeys.contains('ESC') && !bootKeys.contains('ESC'))
                        _buildKeyboardKey('ESC', KeyType.none, width: 32, height: 24, isSmall: true),
                      const SizedBox(width: 2),
                      ...List.generate(12, (index) {
                        final keyLabel = 'F${index + 1}';
                        final isHighlighted = biosKeys.contains(keyLabel) || bootKeys.contains(keyLabel);
                        if (!isHighlighted) {
                          final keyType = biosKeys.contains(keyLabel) ? KeyType.bios : (bootKeys.contains(keyLabel) ? KeyType.boot : KeyType.none);
                          return _buildKeyboardKey(keyLabel, keyType, width: 28, height: 24, isSmall: true);
                        } else {
                          return const SizedBox(width: 28); // Espace vide pour maintenir l'alignement
                        }
                      }),
                      const SizedBox(width: 2),
                      if (!biosKeys.contains('DEL') && !bootKeys.contains('DEL'))
                        _buildKeyboardKey('DEL', KeyType.none, width: 32, height: 24, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Rangée 2: Chiffres et symboles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 6), // Décalage réduit pour aligner avec les lettres
                      _buildKeyboardKey('²', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('1', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('2', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('3', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('4', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('5', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('6', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('7', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('8', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('9', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('0', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey(')', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('=', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('⌫', KeyType.none, width: 44, height: 24, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Rangée 3: Lettres A-P
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildKeyboardKey('TAB', KeyType.none, width: 40, height: 24, isSmall: true),
                      _buildKeyboardKey('A', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('Z', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('E', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('R', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('T', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('Y', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('U', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('I', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('O', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('P', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('^', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('\$', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('↲', KeyType.none, width: 40, height: 24, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Rangée 4: Verr Maj + Lettres Q-M
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildKeyboardKey('VERR\nMAJ', KeyType.none, width: 48, height: 24, isSmall: true),
                      _buildKeyboardKey('Q', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('S', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('D', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('F', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('G', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('H', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('J', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('K', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('L', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('M', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('ù', KeyType.none, width: 28, height: 24, isSmall: true),
                      _buildKeyboardKey('*', KeyType.none, width: 28, height: 24, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Rangée 5: Contrôles et espace
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildKeyboardKey('FN', KeyType.none, width: 32, height: 24, isSmall: true),
                      _buildKeyboardKey('CTRL', KeyType.none, width: 36, height: 24, isSmall: true),
                      _buildKeyboardKey('WIN', KeyType.none, width: 32, height: 24, isSmall: true),
                      _buildKeyboardKey('ALT', KeyType.none, width: 32, height: 24, isSmall: true),
                      _buildKeyboardKey('ESPACE', KeyType.none, width: 100, height: 24, isSmall: true),
                      _buildKeyboardKey('ALTGR', KeyType.none, width: 32, height: 24, isSmall: true),
                      _buildKeyboardKey('MENU', KeyType.none, width: 32, height: 24, isSmall: true),
                      _buildKeyboardKey('CTRL', KeyType.none, width: 36, height: 24, isSmall: true),
                    ],
                  ),
                ],
              ),

              // Couche des touches agrandies (effet zoom) - positionnées pour chevaucher
              ..._buildZoomedKeys(biosKeys, bootKeys, constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildZoomedKeys(List<String> biosKeys, List<String> bootKeys, double containerWidth) {
    final widgets = <Widget>[];

    // Calcul précis des positions basé sur la largeur totale du Row
    // ESC: 32px + 1px margin = 33px
    // 12 touches F: 12 × (28px + 1px margin) = 12 × 29px = 348px
    // Spacings: 13 × 2px = 26px (entre touches)
    // DEL: 32px + 1px margin = 33px
    // Total: 33 + 348 + 26 + 33 = 440px

    // Le Row étant centré, calculons le décalage
    double rowWidth = 440;
    double offsetX = (containerWidth - rowWidth) / 2;

    final keyPositions = <String, Offset>{};

    // Positions ajustées pour le centrage
    keyPositions['ESC'] = Offset(offsetX + 0, 20);
    keyPositions['F1'] = Offset(offsetX + 35, 20);   // ESC(33) + spacing(2)
    keyPositions['F2'] = Offset(offsetX + 66, 20);   // F1 + 31
    keyPositions['F3'] = Offset(offsetX + 97, 20);   // F2 + 31
    keyPositions['F4'] = Offset(offsetX + 128, 20);  // F3 + 31
    keyPositions['F5'] = Offset(offsetX + 159, 20);  // F4 + 31
    keyPositions['F6'] = Offset(offsetX + 190, 20);  // F5 + 31
    keyPositions['F7'] = Offset(offsetX + 221, 20);  // F6 + 31
    keyPositions['F8'] = Offset(offsetX + 252, 20);  // F7 + 31
    keyPositions['F9'] = Offset(offsetX + 283, 20);  // F8 + 31
    keyPositions['F10'] = Offset(offsetX + 314, 20); // F9 + 31
    keyPositions['F11'] = Offset(offsetX + 345, 20); // F10 + 31
    keyPositions['F12'] = Offset(offsetX + 376, 20); // F11 + 31
    keyPositions['DEL'] = Offset(offsetX + 407, 20); // F12(376) + spacing(2) + DEL start

    // Ajouter les touches agrandies seulement pour celles mises en évidence
    for (final entry in keyPositions.entries) {
      final keyLabel = entry.key;
      final position = entry.value;

      final keyType = biosKeys.contains(keyLabel) ? KeyType.bios : (bootKeys.contains(keyLabel) ? KeyType.boot : KeyType.none);

      if (keyType != KeyType.none) {
        widgets.add(
          Positioned(
            left: position.dx,
            top: position.dy,
            child: _buildKeyboardKey(keyLabel, keyType, width: 32, height: 28, isSmall: false),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildKeyboardKey(String label, KeyType keyType, {required double width, required double height, required bool isSmall}) {
    final isHighlighted = keyType != KeyType.none;
    final highlightColor = keyType == KeyType.bios ? const Color(0xFF00B0FF) : const Color(0xFF00E676);

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(isSmall ? 0.5 : 1),
      decoration: BoxDecoration(
        color: isHighlighted ? highlightColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(isSmall ? 2 : 3),
        border: Border.all(
          color: isHighlighted ? highlightColor.withOpacity(0.5) : Colors.grey[400]!,
          width: isHighlighted ? (isSmall ? 1.5 : 2) : 0.5,
        ),
        boxShadow: isHighlighted ? [
          BoxShadow(
            color: highlightColor.withOpacity(isSmall ? 0.2 : 0.3),
            blurRadius: isSmall ? 2 : 4,
            spreadRadius: isSmall ? 0.5 : 1,
          ),
        ] : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isHighlighted ? Colors.white : Colors.black87,
            fontSize: isSmall ? (label.contains('\n') ? 6 : 8) : (width < 40 ? 10 : 12),
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
  Widget _buildManufacturerCard(BuildContext context, ManufacturerInfo manufacturer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BiosBootDetailScreen(manufacturer: manufacturer),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF00B0FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  manufacturer.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Nom et popularité
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manufacturer.name,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < manufacturer.popularity
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Badge spécial
            if (manufacturer.isSpecial)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.4),
                  ),
                ),
                child: const Text(
                  'Spécial',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            const SizedBox(width: 8),
            
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black45,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}