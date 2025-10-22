import 'package:flutter/material.dart';
import '../data/tool_data.dart';
import '../models/tool.dart';
import '../widgets/app_footer.dart';
import '../services/global_timer_service.dart';
import 'bios_boot_home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String backgroundImage;
  const DashboardScreen({super.key, required this.backgroundImage});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialiser et mettre à jour le GlobalTimerService pour qu'il puisse afficher le timer
    GlobalTimerService().updateContext(context);
    // Indiquer qu'on n'affiche aucun item spécifique (page d'accueil)
    GlobalTimerService().setCurrentPageItem(null, null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          // Bordure 3D subtile : ligne claire en haut + ligne sombre en bas
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
              bottom: BorderSide(color: Colors.black.withOpacity(0.08), width: 2),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 50,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/app-icon.png',
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'XR Tech Tools / Dashboard',
                  style: Theme.of(context).appBarTheme.titleTextStyle ?? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          // Filtre blanc pour éclaircir
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.45),
            ),
          ),
          // Contenu principal
          Column(
            children: [
              // Marge sous l'AppBar
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.4,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
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
              // Footer avec bordure 3D subtile
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
                    bottom: BorderSide(color: Colors.black.withOpacity(0.08), width: 2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const AppFooter(forceWhite: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CompactToolTile extends StatelessWidget {
  final Tool tool;

  const CompactToolTile({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final bool isActive = tool.version != null;
    
    return Opacity(
      opacity: isActive ? 1.0 : 0.5, // Option 1: Opacité globale
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => tool.destination),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Option 2: Icône en gris si inactif
                Icon(
                  tool.icon,
                  size: 28,
                  color: isActive 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.shade400,
                ),
                const SizedBox(height: 6),
                
                // Option 2: Texte en gris si inactif
                Flexible(
                  child: Text(
                    tool.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive 
                        ? Theme.of(context).colorScheme.onSurface 
                        : Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Option 3: Badge version ou "Bientôt"
                if (isActive) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tool.version!,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Bientôt',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}