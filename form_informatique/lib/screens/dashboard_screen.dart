import 'package:flutter/material.dart';
import '../data/tool_data.dart';
import '../models/tool.dart';
import '../widgets/app_footer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('XR Tech Tools \\ Dashboard'),
        toolbarHeight: 50,
      ),
      body: Column(
        children: [
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