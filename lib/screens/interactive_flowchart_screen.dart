import 'package:flutter/material.dart';
import '../models/flowchart_models.dart';
import '../services/global_timer_service.dart';

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
              backgroundColor: widget.flowchartInfo.color,
              foregroundColor: Colors.white,
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
        title: Text(widget.flowchartInfo.title),
        backgroundColor: widget.flowchartInfo.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Recommencer',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Recommencer ?'),
                  content: const Text('Voulez-vous recommencer l\'organigramme depuis le début ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _restart();
                      },
                      child: const Text('Recommencer'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.red.shade400,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Badge étape actuelle
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.flowchartInfo.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.flowchartInfo.color.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Étape ${_history.length} / ${widget.flowchartInfo.steps.length}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.flowchartInfo.color,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Carte de l'étape actuelle
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
                              if (_currentStep.icon != null)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: widget.flowchartInfo.color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _currentStep.icon,
                                    size: 48,
                                    color: widget.flowchartInfo.color,
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Text(
                                _currentStep.question,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_currentStep.description != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, 
                                        size: 20, 
                                        color: Colors.blue.shade700
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _currentStep.description!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue.shade900,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Options de réponse
                      Text(
                        'Sélectionnez votre situation :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      ...List.generate(
                        _currentStep.options.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOptionButton(_currentStep.options[index]),
                        ),
                      ),
                      
                      const SizedBox(height: 24), // Espace pour les organigrammes
                    ],
                  ),
                ),
              ),
              
              // Barre d'actions en bas
              if (_history.length > 1)
                Container(
                  padding: const EdgeInsets.all(16),
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
                    child: OutlinedButton.icon(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Étape précédente'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: widget.flowchartInfo.color),
                        foregroundColor: widget.flowchartInfo.color,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildOptionButton(FlowchartOption option) {
    final isCheckmark = option.label.startsWith('✓');
    final isCross = option.label.startsWith('✗');
    
    Color bgColor, borderColor, textColor;
    IconData? leadingIcon;
    
    if (isCheckmark) {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green.shade300;
      textColor = Colors.green.shade900;
      leadingIcon = Icons.check_circle_outline;
    } else if (isCross) {
      bgColor = Colors.red.shade50;
      borderColor = Colors.red.shade300;
      textColor = Colors.red.shade900;
      leadingIcon = Icons.cancel_outlined;
    } else {
      bgColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade300;
      textColor = Colors.blue.shade900;
      leadingIcon = Icons.arrow_forward;
    }
    
    return InkWell(
      onTap: () => _selectOption(option),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, color: textColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: textColor),
          ],
        ),
      ),
    );
  }
}