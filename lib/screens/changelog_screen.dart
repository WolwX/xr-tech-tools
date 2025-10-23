import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/app_footer.dart';
import '../widgets/custom_app_bar.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  String _changelogContent = '';
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _loadChangelog();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _showScrollToTop = _scrollController.offset > 300;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadChangelog() async {
    try {
      final content = await rootBundle.loadString('CHANGELOG.md');
      setState(() {
        _changelogContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _changelogContent = 'Erreur lors du chargement du changelog: $e';
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildChangelogWidgets(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.startsWith('# ')) {
        // Titre H1
        final title = line.substring(2);
        _sectionKeys[title] = GlobalKey();
        widgets.add(
          Padding(
            key: _sectionKeys[title],
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                height: 1.3,
              ),
            ),
          ),
        );
      } else if (line.startsWith('## ')) {
        // Titre H2
        final title = line.substring(3);
        _sectionKeys[title] = GlobalKey();
        widgets.add(
          Padding(
            key: _sectionKeys[title],
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
        );
      } else if (line.startsWith('### ')) {
        // Titre H3
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              line.substring(4),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
                height: 1.4,
              ),
            ),
          ),
        );
      } else if (line.startsWith('- ')) {
        // Liste
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 0.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: _buildRichText(line.substring(2)),
                ),
              ],
            ),
          ),
        );
      } else if (line.trim().isEmpty) {
        // Ligne vide - espacement minimal
        widgets.add(const SizedBox(height: 1));
      } else if (line.startsWith('```')) {
        // Bloc de code - on ignore les marqueurs pour l'instant
        continue;
      } else if (line.startsWith('> ')) {
        // Citation
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 4,
                ),
              ),
            ),
            child: _buildRichText(line.substring(2)),
          ),
        );
      } else {
        // Texte normal
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 0.5),
            child: _buildRichText(line),
          ),
        );
      }
    }

    return widgets;
  }

  List<Map<String, String>> _extractVersionTags(String content) {
    final lines = content.split('\n');
    final tags = <Map<String, String>>[];

    for (final line in lines) {
      if (line.startsWith('## Version ')) {
        // Format: ## Version 1.3.3 (22/10/2025) - Description
        final versionRegex = RegExp(r'## Version (\d+\.\d+\.\d+) \((\d{2}/\d{2}/\d{4})\) - (.+)');
        final match = versionRegex.firstMatch(line);
        if (match != null) {
          tags.add({
            'version': match.group(1)!,
            'date': match.group(2)!,
            'description': match.group(3)!,
            'title': '${match.group(1)} - ${match.group(3)}',
          });
        }
      }
    }

    return tags;
  }

  void _scrollToSection(String title) {
    final key = _sectionKeys[title];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildRichText(String text) {
    // Parser basique pour **gras** et *italique*
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*');
    var lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Texte avant le match
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      // Texte stylisé
      if (match.group(1) != null) {
        // **gras**
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(2) != null) {
        // *italique*
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      }

      lastIndex = match.end;
    }

    // Texte restant
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Change Log',
        titleIcon: Icons.history,
        version: '1.0',
        showBackButton: true,
        backgroundColor: const Color(0xFF00B0FF),
      ),
      bottomNavigationBar: const AppFooter(),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre principal
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.update,
                              size: 48,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Historique des Versions',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Évolution de XR Tech Tools',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sommaire
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sommaire',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: _extractVersionTags(_changelogContent).map((tag) {
                                  return InkWell(
                                    onTap: () => _scrollToSection(tag['title']!),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor.withOpacity(0.1),
                                            Theme.of(context).primaryColor.withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Version avec icône
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.new_releases,
                                                size: 14,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                tag['version']!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          // Date avec icône agenda
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 12,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                tag['date']!,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          // Description en gras (sans icône)
                                          Text(
                                            tag['description']!.length > 20
                                                ? '${tag['description']!.substring(0, 17)}...'
                                                : tag['description']!,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contenu du changelog
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildChangelogWidgets(_changelogContent),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

          // Bouton scroll-to-top flottant
          Positioned(
            bottom: 50, // Collé au footer
            right: 16,
            child: AnimatedOpacity(
              opacity: _showScrollToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                width: 40, // Taille réduite
                height: 40, // Taille réduite
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  child: const Icon(Icons.arrow_upward, size: 20), // Icône plus petite
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}