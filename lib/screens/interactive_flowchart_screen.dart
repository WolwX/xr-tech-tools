import 'package:flutter/material.dart';
import '../models/flowchart_models.dart';
import '../services/global_timer_service.dart';
import '../widgets/app_footer.dart';
import 'flowchart_image_viewer.dart';

class InteractiveFlowchartScreen extends StatefulWidget {
  final FlowchartInfo flowchartInfo;
  
  const InteractiveFlowchartScreen({
    super.key,
    required this.flowchartInfo,
  });

  @override
  State<InteractiveFlowchartScreen> createState() => _InteractiveFlowchartScreenState();
}

class _InteractiveFlowchartScreenState extends State<InteractiveFlowchartScreen> {
  String _currentStepId = 'start';
  final List<String> _history = ['start'];
  final Set<String> _completedSteps = {};
  
  FlowchartStep get _currentStep => widget.flowchartInfo.steps[_currentStepId]!;
  
  void _selectOption(FlowchartOption option) {
    setState(() {
      _completedSteps.add(_currentStepId);
      
      if (option.nextStepId != null) {
        _currentStepId = option.nextStepId!;
        _history.add(_currentStepId);
      } else {
        // C'est une conclusion, afficher le résultat
        _showResult(option);
      }
    });
  }
  
  void _goBack() {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
        _currentStepId = _history.last;
      });
    }
  }
  
  void _restart() {
    setState(() {
      _currentStepId = 'start';
      _history.clear();
      _history.add('start');
      _completedSteps.clear();
    });
  }
  
  void _showResult(FlowchartOption option) {
    Color resultColor;
    IconData resultIcon;
    String resultTitle;
    
    switch (option.resultType) {
      case ResultType.success:
        resultColor = Colors.green;
        resultIcon = Icons.check_circle;
        resultTitle = 'Solution trouvée';
        break;
      case ResultType.failure:
        resultColor = Colors.red;
        resultIcon = Icons.error;
        resultTitle = 'Composant défectueux';
        break;
      case ResultType.info:
      default:
        resultColor = Colors.blue;
        resultIcon = Icons.info;
        resultTitle = 'Information';
        break;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(resultIcon, color: resultColor, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(resultTitle)),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: resultColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: resultColor.withOpacity(0.3)),
          ),
          child: Text(
            option.resultMessage ?? '',
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _goBack();
            },
            child: const Text('Étape précédente'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _restart();
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Recommencer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialiser le GlobalTimerService pour qu'il puisse afficher le timer
    GlobalTimerService().initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completedSteps.length / widget.flowchartInfo.steps.length;
    
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0, // Espacement à 0 pour coller l'icône logigramme au bouton retour
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.memory,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8), // Augmenté de 2 à 8 pour espacer l'icône du titre
            Expanded(
              child: Text(
                widget.flowchartInfo.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: widget.flowchartInfo.color,
        actions: [
          IconButton(
            iconSize: 36,
            padding: EdgeInsets.zero, // Suppression complète du padding
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.restart_alt,
                color: Colors.white,
                size: 16,
              ),
            ),
            tooltip: 'Recommencer',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Recommencer ?'),
                  content: const Text('Voulez-vous recommencer le logigramme depuis le début ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _restart();
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Recommencer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (widget.flowchartInfo.imagePath != null)
            IconButton(
              iconSize: 36,
              padding: EdgeInsets.zero, // Suppression complète du padding
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade400, // Changé vers un jaune encore plus clair
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              tooltip: 'Voir le logigramme',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlowchartImageViewer(
                      title: widget.flowchartInfo.title,
                      imagePath: widget.flowchartInfo.imagePath!,
                    ),
                  ),
                );
              },
            ),
          IconButton(
            iconSize: 36,
            padding: EdgeInsets.zero, // Suppression complète du padding
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
            tooltip: 'Fermer',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Barre de progression
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: widget.flowchartInfo.color,
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Réduit le padding bottom de 16 à 8
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Carte de l'étape actuelle (espace supprimé complètement)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: widget.flowchartInfo.color,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Icône et titre côte à côte
                              Row(
                                children: [
                                  if (_currentStep.icon != null)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: widget.flowchartInfo.color.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _currentStep.icon,
                                        size: 40, // Légèrement réduit de 48 à 40
                                        color: widget.flowchartInfo.color,
                                      ),
                                    ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      _currentStep.question,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                      ),
                                      textAlign: TextAlign.left, // Aligné à gauche
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              // Encadré informatif simplifié
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: widget.flowchartInfo.color.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: widget.flowchartInfo.color.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: widget.flowchartInfo.color,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Vous pouvez suivre les étapes tel le logigramme afin de sélectionner l\'élément qui correspond le plus à votre vérification.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade600,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Badge étape actuelle amélioré avec progression
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.flowchartInfo.color.withOpacity(0.1),
                              widget.flowchartInfo.color.withOpacity(0.05),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.flowchartInfo.color.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.flowchartInfo.color.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Titre et numéro d'étape
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: widget.flowchartInfo.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_history.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Étape ${_history.length} sur ${widget.flowchartInfo.steps.length}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: widget.flowchartInfo.color,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Progression du diagnostic',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${((_history.length / widget.flowchartInfo.steps.length) * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: widget.flowchartInfo.color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Barre de progression
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _history.length / widget.flowchartInfo.steps.length,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.flowchartInfo.color,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ...List.generate(
                        _currentStep.options.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8), // Réduit de 12 à 8
                          child: _buildOptionButton(_currentStep.options[index]),
                        ),
                      ),
                      
                      const SizedBox(height: 80), // Espace pour éviter le masquage par les boutons flottants
                    ],
                  ),
                ),
              ),
              
              // Barre d'actions en bas
              if (_history.length > 1)
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 20), // Augmenté le padding bottom pour l'espace timer
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon( // Changé de OutlinedButton à ElevatedButton pour plus de visibilité
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text('Étape précédente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.flowchartInfo.color.withOpacity(0.1),
                        foregroundColor: widget.flowchartInfo.color,
                        elevation: 2,
                        shadowColor: widget.flowchartInfo.color.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(vertical: 16), // Augmenté le padding vertical
                        side: BorderSide(color: widget.flowchartInfo.color, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Coins arrondis
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
  
  Widget _buildOptionButton(FlowchartOption option) {
    final isCheckmark = option.label.startsWith('✓');
    final isCross = option.label.startsWith('✗');
    
    Color bgColor, borderColor, textColor, shadowColor;
    IconData? leadingIcon;
    
    if (isCheckmark) {
      bgColor = Colors.green.shade100;
      borderColor = Colors.green.shade400;
      textColor = Colors.green.shade800;
      shadowColor = Colors.green.shade200;
      leadingIcon = Icons.check_circle;
    } else if (isCross) {
      bgColor = Colors.red.shade100;
      borderColor = Colors.red.shade400;
      textColor = Colors.red.shade800;
      shadowColor = Colors.red.shade200;
      leadingIcon = Icons.cancel;
    } else {
      bgColor = Colors.blue.shade100;
      borderColor = Colors.blue.shade400;
      textColor = Colors.blue.shade800;
      shadowColor = Colors.blue.shade200;
      leadingIcon = Icons.arrow_forward_ios;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 4,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _selectOption(option),
          borderRadius: BorderRadius.circular(16),
          splashColor: borderColor.withOpacity(0.3),
          highlightColor: borderColor.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2.5),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  bgColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: borderColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(leadingIcon, color: textColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          option.subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: textColor.withOpacity(0.8),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chevron_right, color: textColor, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}