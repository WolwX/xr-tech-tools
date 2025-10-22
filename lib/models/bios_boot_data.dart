// lib/models/bios_boot_data.dart

/// Modèle pour une combinaison de touches BIOS/Boot
class KeyCombination {
  final List<String> bios;
  final List<String> boot;
  
  const KeyCombination({
    required this.bios,
    required this.boot,
  });
}

/// Catégories de matériel
enum HardwareCategory {
  laptopOem('laptop_oem', 'PC Portable', '💻'),
  desktopMotherboard('desktop_motherboard', 'Carte Mère / PC Fixe', '🖥️'),
  tablet('tablet', 'Tablette / Surface', '📱'),
  special('special', 'Cas Spéciaux', '⚙️');

  final String id;
  final String displayName;
  final String icon;
  
  const HardwareCategory(this.id, this.displayName, this.icon);
}

/// Informations complètes sur un fabricant
class ManufacturerInfo {
  final String name;
  final List<String> bios;
  final List<String> boot;
  final HardwareCategory category;
  final String? logoPath;
  final int popularity; // 1-5 étoiles
  final String? tips;
  final bool isSpecial;
  final String icon;
  final List<String>? aliases; // Noms alternatifs pour la recherche
  
  const ManufacturerInfo({
    required this.name,
    required this.bios,
    required this.boot,
    this.category = HardwareCategory.laptopOem,
    this.logoPath,
    this.popularity = 3,
    this.tips,
    this.isSpecial = false,
    this.icon = '💻',
    this.aliases,
  });
  
  /// Vérifie si le fabricant correspond à une recherche
  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    if (name.toLowerCase().contains(lowerQuery)) return true;
    if (aliases != null) {
      return aliases!.any((alias) => alias.toLowerCase().contains(lowerQuery));
    }
    return false;
  }
}

/// Pattern de touches par époque
class EraPattern {
  final String period;
  final List<String> commonBios;
  final List<String> commonBoot;
  final String notes;
  
  const EraPattern({
    required this.period,
    required this.commonBios,
    required this.commonBoot,
    required this.notes,
  });
}

/// Groupe de fabricants partageant les mêmes touches
class ManufacturerGroup {
  final String groupName;
  final List<String> bios;
  final List<String> boot;
  final List<String> manufacturers;
  final String description;
  
  const ManufacturerGroup({
    required this.groupName,
    required this.bios,
    required this.boot,
    required this.manufacturers,
    required this.description,
  });
}