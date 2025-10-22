// lib/screens/bios_boot_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_footer.dart';
import '../models/bios_boot_data.dart';
import '../data/tool_data.dart';

class BiosBootDetailScreen extends StatelessWidget {
  final ManufacturerInfo manufacturer;
  
  const BiosBootDetailScreen({super.key, required this.manufacturer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: manufacturer.name,
        titleIcon: Icons.keyboard,
        version: ToolVersions.biosBootTools, // Version centralisée sans préfixe supplémentaire
        showBackButton: true,
        backgroundColor: const Color(0xFF00B0FF), // Cyan, même couleur que les autres tuiles
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

              // Section BIOS
              _buildKeyCard(
                context,
                title: '🔵 BIOS / UEFI',
                keys: manufacturer.bios,
                color: const Color(0xFF00B0FF),
              ),

              const SizedBox(height: 16),

              // Section Boot
              _buildKeyCard(
                context,
                title: '🟢 Boot Menu',
                keys: manufacturer.boot,
                color: const Color(0xFF00E676),
              ),

              const SizedBox(height: 24),

              // Conseils
              if (manufacturer.tips != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Conseil', style: TextStyle(color: Colors.amber[100], fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(manufacturer.tips!, style: TextStyle(color: Colors.amber[100], fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Instructions générales
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
                        Icon(Icons.help_outline, color: Colors.black54, size: 20),
                        SizedBox(width: 8),
                        Text('Comment faire ?', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep('1', 'Éteignez complètement l\'ordinateur'),
                    _buildInstructionStep('2', 'Appuyez sur le bouton Power'),
                    _buildInstructionStep('3', 'Appuyez IMMÉDIATEMENT et RÉPÉTITIVEMENT sur la touche'),
                    _buildInstructionStep('4', 'Continuez jusqu\'à l\'apparition du menu'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bouton problème
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF2A2A2A),
                      title: const Text('Ça ne fonctionne pas ?', style: TextStyle(color: Colors.white)),
                      content: const Text(
                        'Solutions alternatives:\n\n'
                        '• Essayez un clavier USB (pas sans fil)\n'
                        '• Débranchez périphériques USB inutiles\n'
                        '• Vérifiez que Fast Boot est désactivé\n'
                        '• Sur Windows 10/11: Redémarrer en maintenant Shift',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.error_outline, color: Colors.redAccent),
                label: const Text('Ça ne fonctionne pas ?', style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Colors.redAccent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildKeyCard(BuildContext context, {
    required String title,
    required List<String> keys,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, color: color, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: keys.join(', ')));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Touches copiées: ${keys.join(', ')}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Copier',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: keys.map((key) => _buildKeyButton(key, color)).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildKeyButton(String key, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        key,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF00B0FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF00B0FF).withOpacity(0.4),
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Color(0xFF00B0FF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}