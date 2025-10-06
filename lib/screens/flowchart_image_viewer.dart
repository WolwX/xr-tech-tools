import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/global_timer_service.dart';

class FlowchartImageViewer extends StatefulWidget {
  final String title;
  final String imagePath;
  
  const FlowchartImageViewer({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  State<FlowchartImageViewer> createState() => _FlowchartImageViewerState();
}

class _FlowchartImageViewerState extends State<FlowchartImageViewer> {
  bool _isFullscreen = false;

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      if (_isFullscreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        // Masquer le timer flottant en mode plein écran
        GlobalTimerService().hideTimer();
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        // Restaurer le timer flottant
        GlobalTimerService().showTimer();
      }
    });
  }

  void _exitFullscreen() {
    if (_isFullscreen) {
      setState(() {
        _isFullscreen = false;
      });
      // Restaurer le timer flottant si on était en plein écran
      GlobalTimerService().showTimer();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      // Mode plein écran : seulement l'image avec tap pour sortir
      return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleFullscreen,
          child: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: _buildImageWidget(),
            ),
          ),
        ),
      );
    }

    // Mode normal avec AppBar et boutons
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Logigramme - ${widget.title}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            tooltip: 'Mode plein écran',
            onPressed: _toggleFullscreen,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fermer',
            onPressed: _exitFullscreen,
          ),
        ],
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            // Restaurer le timer si on ferme en mode plein écran
            if (_isFullscreen) {
              GlobalTimerService().showTimer();
            }
          }
        },
        child: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageWidget(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showImageInfo(context);
        },
        backgroundColor: Colors.amber.shade600, // Jaune au lieu de bleu
        mini: true, // Plus petit
        child: const Icon(Icons.info_outline, color: Colors.white, size: 20), // Taille réduite
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // En bas à gauche
    );
  }

  Widget _buildImageWidget() {
    return FutureBuilder<bool>(
      future: _imageExists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        }
        
        if (snapshot.data == true) {
          // Vérifier si c'est un SVG ou une image classique
          if (widget.imagePath.toLowerCase().endsWith('.svg')) {
            return SvgPicture.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            return Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            );
          }
        } else {
          return _buildErrorWidget();
        }
      },
    );
  }

  Future<bool> _imageExists() async {
    try {
      await rootBundle.load(widget.imagePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 64,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Image du logigramme non disponible',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'L\'image sera ajoutée prochainement',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.5)),
            ),
            child: Text(
              'Chemin : ${widget.imagePath}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('Informations'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre : ${widget.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Chemin : ${widget.imagePath}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('• Pincer pour zoomer/dézoomer'),
                  Text('• Glisser pour déplacer l\'image'),
                  Text('• Bouton plein écran pour masquer l\'interface'),
                  Text('• Toucher l\'écran en mode plein écran pour revenir'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}