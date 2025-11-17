import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
import '../widgets/custom_app_bar.dart';
import '../services/training_access_service.dart';

// Import conditionnel pour WebView
import 'package:webview_flutter/webview_flutter.dart'
    show WebViewController, JavaScriptMode, NavigationDelegate, WebResourceError, WebViewWidget;

// Import pour le web (conditional)
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class TrainingAccessScreen extends StatefulWidget {
  const TrainingAccessScreen({super.key});

  @override
  State<TrainingAccessScreen> createState() => _TrainingAccessScreenState();
}

class _TrainingAccessScreenState extends State<TrainingAccessScreen> {
  late String _currentUrl;
  bool _isLoading = true;
  bool _showWebContent = false;
  late WebViewController _webViewController;
  final TextEditingController _urlController = TextEditingController();
  bool _isWeb = false;
  final String _iframeId = 'training-iframe';

  @override
  void initState() {
    super.initState();
    _isWeb = identical(0, 0.0); // Détecte si on est sur le web
    _loadUrl();
    
    // Initialiser le WebViewController uniquement si ce n'est pas le web
    if (!_isWeb) {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              // Optionnel : faire quelque chose quand la page commence à charger
            },
            onPageFinished: (String url) {
              // Optionnel : faire quelque chose quand la page est chargée
            },
            onWebResourceError: (WebResourceError error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur de chargement : ${error.description}')),
              );
            },
          ),
        );
    } else {
      // Créer l'iframe pour le web
      _createIframe();
    }
  }

  void _createIframe() {
    ui.platformViewRegistry.registerViewFactory(
      _iframeId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = _currentUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..setAttribute('sandbox', 'allow-same-origin allow-scripts allow-forms allow-popups allow-presentation');
        return iframe;
      },
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadUrl() async {
    final url = await TrainingAccessService.getUrl();
    setState(() {
      _currentUrl = url;
      _urlController.text = url;
      _isLoading = false;
    });
  }

  Future<void> _saveUrl() async {
    final newUrl = _urlController.text.trim();
    
    if (newUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\'URL ne peut pas être vide')),
      );
      return;
    }

    // Valider l'URL
    if (!newUrl.startsWith('http://') && !newUrl.startsWith('https://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\'URL doit commencer par http:// ou https://')),
      );
      return;
    }

    await TrainingAccessService.setUrl(newUrl);
    setState(() {
      _currentUrl = newUrl;
      if (_showWebContent && _isWeb) {
        // Recréer l'iframe si on est en mode affichage web
        _createIframe();
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL mise à jour avec succès'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuration - Accès Formation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Entrez l\'URL de la page web à afficher :',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'https://example.com',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
                labelText: 'URL',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            Text(
              'URL actuelle : $_currentUrl',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: _saveUrl,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _openWebView() {
    setState(() {
      _showWebContent = true;
    });
    if (!_isWeb) {
      _webViewController.loadRequest(Uri.parse(_currentUrl));
    }
  }

  void _closeWebView() {
    setState(() {
      _showWebContent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Accès Formation',
        titleIcon: Icons.school,
        version: '1.0',
        showBackButton: true,
        backgroundColor: Colors.green.shade600,
        additionalActions: [
          if (!_showWebContent)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: _showSettingsDialog,
              tooltip: 'Configurer l\'URL',
            ),
          if (_showWebContent)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _closeWebView,
              tooltip: 'Fermer le contenu web',
            ),
        ],
      ),
      bottomNavigationBar: const AppFooter(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : !_showWebContent
              ? _buildConfigurationView()
              : _buildWebView(),
    );
  }

  Widget _buildConfigurationView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte d'information
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Accès à vos ressources de formation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Accédez directement à votre plateforme de formation. Vous pouvez configurer l\'adresse web à tout moment en cliquant sur l\'icône de réglage en haut à droite.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bouton principal d'accès
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openWebView,
              icon: const Icon(Icons.language, size: 24),
              label: const Text(
                'Accéder à la formation',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Affichage de l'URL actuelle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'URL configurée',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _currentUrl,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[600],
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _showSettingsDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section d'aide
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                      Icons.help_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Aide',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Cliquez sur le bouton "Accéder à la formation" pour afficher le site dans l\'application\n'
                  '• Utilisez l\'icône de réglage (⚙️) en haut à droite pour configurer une nouvelle URL\n'
                  '• Cliquez sur l\'icône ✕ en haut à droite pour fermer le contenu web\n'
                  '• L\'URL doit commencer par http:// ou https://',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    if (_isWeb) {
      // Sur le web, utiliser UiKitView avec iframe
      return UiKitView(
        viewType: _iframeId,
        key: UniqueKey(),
      );
    } else {
      // Sur mobile/desktop, utiliser WebViewWidget
      return WebViewWidget(controller: _webViewController);
    }
  }
}
