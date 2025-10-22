// lib/data/bios_manufacturers_data.dart

import '../models/bios_boot_data.dart';

class BiosManufacturersData {
  
  // ========================================
  // TOUCHES STANDARDS PAR CATÉGORIE
  // ========================================
  
  static const Map<HardwareCategory, KeyCombination> standardKeysByCategory = {
    HardwareCategory.laptopOem: KeyCombination(
      bios: ['F2', 'F10'],
      boot: ['F12', 'F9', 'ESC'],
    ),
    HardwareCategory.desktopMotherboard: KeyCombination(
      bios: ['DEL', 'F2'],
      boot: ['F11', 'F12'],
    ),
    HardwareCategory.tablet: KeyCombination(
      bios: ['Volume+'],
      boot: ['Volume+'],
    ),
  };
  
  // ========================================
  // GROUPES DE FABRICANTS (TOUCHES IDENTIQUES)
  // ========================================
  
  static const List<ManufacturerGroup> manufacturerGroups = [
    ManufacturerGroup(
      groupName: 'Groupe F2 + F12',
      bios: ['F2'],
      boot: ['F12'],
      manufacturers: [
        'Asus', 'Dell', 'Lenovo (IdeaPad)', 'Samsung', 'Sony', 
        'Toshiba', 'Fujitsu', 'Packard Bell'
      ],
      description: 'Le groupe le plus commun - majorité des PC portables',
    ),
    ManufacturerGroup(
      groupName: 'Groupe DEL + F11',
      bios: ['DEL'],
      boot: ['F11'],
      manufacturers: [
        'ASRock', 'Biostar', 'ECS', 'EVGA', 'Foxconn'
      ],
      description: 'Cartes mères pour PC assemblés',
    ),
    ManufacturerGroup(
      groupName: 'Groupe F10 / F9',
      bios: ['F10', 'ESC'],
      boot: ['F9', 'ESC'],
      manufacturers: ['HP', 'Compaq'],
      description: 'Fabricants HP et marques associées',
    ),
    ManufacturerGroup(
      groupName: 'Groupe DEL + F12',
      bios: ['DEL'],
      boot: ['F12'],
      manufacturers: ['Gigabyte', 'Intel'],
      description: 'Cartes mères gaming et Intel',
    ),
  ];
  
  // ========================================
  // BASE DE DONNÉES COMPLÈTE DES FABRICANTS
  // ========================================
  
  static const List<ManufacturerInfo> allManufacturers = [
    
    // ===== PC PORTABLES (OEM) =====
    
    ManufacturerInfo(
      name: 'Asus',
      bios: ['F2', 'DEL'],
      boot: ['F8', 'ESC'],
      category: HardwareCategory.laptopOem,
      popularity: 5,
      tips: 'Sur certains modèles : DEL pour BIOS',
      aliases: ['Asus ROG', 'Asus ZenBook', 'Asus VivoBook'],
    ),
    
    ManufacturerInfo(
      name: 'Dell',
      bios: ['F2'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 5,
      tips: 'Appuyer dès l\'apparition du logo Dell',
      aliases: ['Dell Inspiron', 'Dell XPS', 'Dell Latitude', 'Dell OptiPlex'],
    ),
    
    ManufacturerInfo(
      name: 'HP',
      bios: ['F10', 'ESC'],
      boot: ['F9', 'ESC'],
      category: HardwareCategory.laptopOem,
      popularity: 5,
      tips: 'ESC ouvre un menu avec plusieurs options (F10 pour BIOS, F9 pour Boot)',
      aliases: ['HP Pavilion', 'HP EliteBook', 'HP ProBook', 'HP Envy'],
    ),
    
    ManufacturerInfo(
      name: 'Lenovo (IdeaPad / Yoga)',
      bios: ['F2'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 5,
      aliases: ['Lenovo IdeaPad', 'Lenovo Yoga', 'Lenovo Legion'],
    ),
    
    ManufacturerInfo(
      name: 'Lenovo (ThinkPad)',
      bios: ['Enter puis F1'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 4,
      isSpecial: true,
      tips: '⚠️ Série professionnelle : Appuyer ENTER puis F1 (2 touches séquentielles)',
      aliases: ['ThinkPad', 'Lenovo ThinkPad'],
    ),
    
    ManufacturerInfo(
      name: 'Acer',
      bios: ['F2'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 4,
      tips: '⚠️ Sur certains modèles, F12 doit être activé dans le BIOS',
      aliases: ['Acer Aspire', 'Acer Swift', 'Acer Nitro', 'Acer Predator'],
    ),
    
    ManufacturerInfo(
      name: 'Samsung',
      bios: ['F2'],
      boot: ['ESC', 'F12'],
      category: HardwareCategory.laptopOem,
      popularity: 3,
      tips: 'Ativ Book : F2 pour Boot également',
    ),
    
    ManufacturerInfo(
      name: 'Toshiba',
      bios: ['F2'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 3,
    ),
    
    ManufacturerInfo(
      name: 'Sony',
      bios: ['F2', 'F3'],
      boot: ['F11', 'ESC'],
      category: HardwareCategory.laptopOem,
      popularity: 2,
      aliases: ['Sony Vaio'],
    ),
    
    ManufacturerInfo(
      name: 'Fujitsu',
      bios: ['F2'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 3,
    ),
    
    ManufacturerInfo(
      name: 'Packard Bell',
      bios: ['F2'],
      boot: ['F12'],
      category: HardwareCategory.laptopOem,
      popularity: 2,
    ),
    
    // ===== CARTES MÈRES / PC FIXES =====
    
    ManufacturerInfo(
      name: 'MSI',
      bios: ['DEL'],
      boot: ['F11'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 5,
      aliases: ['MSI Gaming', 'MSI MPG', 'MSI MAG'],
    ),
    
    ManufacturerInfo(
      name: 'Gigabyte',
      bios: ['DEL'],
      boot: ['F12'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 5,
      aliases: ['Gigabyte Aorus'],
    ),
    
    ManufacturerInfo(
      name: 'ASRock',
      bios: ['F2', 'DEL'],
      boot: ['F11'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 4,
    ),
    
    ManufacturerInfo(
      name: 'Asus (Carte Mère)',
      bios: ['DEL', 'F2'],
      boot: ['F8'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 5,
      aliases: ['Asus ROG Strix', 'Asus TUF', 'Asus Prime'],
    ),
    
    ManufacturerInfo(
      name: 'Intel',
      bios: ['F2'],
      boot: ['F10'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 3,
      aliases: ['Intel Desktop Board'],
    ),
    
    ManufacturerInfo(
      name: 'Biostar',
      bios: ['DEL'],
      boot: ['F11'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 2,
    ),
    
    ManufacturerInfo(
      name: 'ECS',
      bios: ['DEL'],
      boot: ['F11'],
      category: HardwareCategory.desktopMotherboard,
      popularity: 2,
      aliases: ['Elitegroup'],
    ),
    
    // ===== CAS SPÉCIAUX =====
    
    ManufacturerInfo(
      name: 'Microsoft Surface',
      bios: ['Volume Up (maintenu au démarrage)'],
      boot: ['Volume Up (maintenu)'],
      category: HardwareCategory.tablet,
      popularity: 4,
      isSpecial: true,
      icon: '📱',
      tips: '⚠️ Maintenir le bouton Volume+ enfoncé pendant le démarrage complet',
      aliases: ['Surface Pro', 'Surface Laptop', 'Surface Book'],
    ),
    
    ManufacturerInfo(
      name: 'Apple Mac',
      bios: ['Cmd + R (Recovery)', 'Cmd + Opt + P + R'],
      boot: ['Option (⌥)'],
      category: HardwareCategory.special,
      popularity: 5,
      isSpecial: true,
      icon: '',
      tips: 'Architecture EFI différente. Cmd+R pour Recovery, Option pour Boot Selection',
      aliases: ['MacBook', 'iMac', 'Mac Mini', 'Mac Pro'],
    ),
    
    ManufacturerInfo(
      name: 'Compaq',
      bios: ['F10'],
      boot: ['F9', 'ESC'],
      category: HardwareCategory.laptopOem,
      popularity: 2,
      tips: 'Marque rachetée par HP - mêmes touches',
    ),
  ];
  
  // ========================================
  // MÉTHODES UTILITAIRES
  // ========================================
  
  /// Récupère tous les fabricants d'une catégorie
  static List<ManufacturerInfo> getByCategory(HardwareCategory category) {
    return allManufacturers
        .where((m) => m.category == category)
        .toList()
      ..sort((a, b) => b.popularity.compareTo(a.popularity));
  }
  
  /// Recherche par nom
  static List<ManufacturerInfo> search(String query) {
    if (query.isEmpty) return allManufacturers;
    return allManufacturers
        .where((m) => m.matchesSearch(query))
        .toList()
      ..sort((a, b) => b.popularity.compareTo(a.popularity));
  }
  
  /// Récupère les fabricants populaires (4-5 étoiles)
  static List<ManufacturerInfo> getPopular() {
    return allManufacturers
        .where((m) => m.popularity >= 4)
        .toList()
      ..sort((a, b) => b.popularity.compareTo(a.popularity));
  }
  
  /// Récupère les cas spéciaux
  static List<ManufacturerInfo> getSpecialCases() {
    return allManufacturers.where((m) => m.isSpecial).toList();
  }
}