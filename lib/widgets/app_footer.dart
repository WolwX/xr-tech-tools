import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppFooter extends StatefulWidget {
  final bool forceWhite;
  const AppFooter({super.key, this.forceWhite = false});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
      });
    } catch (e) {
      // Fallback en cas d'erreur
      setState(() {
        _version = '1.3.071025';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Le code utilise un Wrap pour s'assurer que si l'écran est très étroit,
    // le texte passe à la ligne sans déborder.
  final Color appBarBlue = const Color(0xFF2196F3); // Couleur AppBar Flutter par défaut
  final Color textColor = widget.forceWhite ? appBarBlue : theme.colorScheme.onSurface.withOpacity(0.7);
  final Color strongColor = widget.forceWhite ? appBarBlue : theme.colorScheme.onSurface;
  final Color iconColor = widget.forceWhite ? appBarBlue.withOpacity(0.7) : theme.colorScheme.onSurface;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0, // Espacement horizontal
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Texte principal
        Text(
          "CODED WITH ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFeatures: const [FontFeature.enable('smcp')],
          ),
        ),
        // Icône du cœur
        Icon(
          Icons.favorite, 
          color: iconColor,
          size: 12
        ),
        // Texte de la signature
        Text(
          " PAR ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFeatures: const [FontFeature.enable('smcp')],
          ),
        ),
        // Signature XR avec icône d'humain sur ordinateur
        Icon(
          Icons.computer, // Icône d'humain/développeur sur ordinateur
          size: 12,
          color: iconColor,
        ),
        Text(
          "XR",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: strongColor,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFeatures: const [FontFeature.enable('smcp')],
          ),
        ),
        // Séparateur
        Text(
          " & ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFeatures: const [FontFeature.enable('smcp')],
          ),
        ),
        // Signature Claude avec icône robot
        Icon(
          Icons.smart_toy, // Icône robot Android-style
          size: 12,
          color: iconColor,
        ),
        Text(
          "CLAUDE",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: strongColor,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFeatures: const [FontFeature.enable('smcp')],
          ),
        ),
        // Numéro de version avec convention MAJEURE.MINEURE.DDMMAA
        Text(
          _version.isNotEmpty ? " - VERSION V$_version" : " - CHARGEMENT...",
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFeatures: const [FontFeature.enable('smcp')],
          ),
        ),
      ],
    );
  }
}