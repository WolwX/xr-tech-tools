import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionDisplay extends StatefulWidget {
  const VersionDisplay({super.key});

  @override
  State<VersionDisplay> createState() => _VersionDisplayState();
}

class _VersionDisplayState extends State<VersionDisplay> {
  String _version = '';
  String _buildDate = '';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    
    // Récupère la version : ex "1.3.1"
    final version = packageInfo.version;
    
    // Récupère le build number : ex "20251021"
    final buildNumber = packageInfo.buildNumber;
    
    // Convertit le build number en date lisible
    final buildDate = _formatBuildDate(buildNumber);
    
    setState(() {
      _version = version;
      _buildDate = buildDate;
    });
  }

  String _formatBuildDate(String buildNumber) {
    // buildNumber format: 20251021 (YYYYMMDD)
    // ou format: 251021 (YYMMDD)
    
    if (buildNumber.length == 8) {
      // Format: YYYYMMDD (20251021)
      final year = buildNumber.substring(0, 4);
      final month = buildNumber.substring(4, 6);
      final day = buildNumber.substring(6, 8);
      return '$day/$month/$year';
    } else if (buildNumber.length == 6) {
      // Format: YYMMDD (251021)
      final year = '20${buildNumber.substring(0, 2)}';
      final month = buildNumber.substring(2, 4);
      final day = buildNumber.substring(4, 6);
      return '$day/$month/$year';
    } else {
      // Format inconnu, retourne tel quel
      return buildNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Version $_version',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Build du $_buildDate',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}