import 'package:flutter/material.dart';

class Tool {
  final String name;
  final String description;
  final IconData icon;
  final Widget destination;
  final String? version;  // NOUVEAU paramètre optionnel

  const Tool({
    required this.name,
    required this.description,
    required this.icon,
    required this.destination,
    this.version,  // NOUVEAU
  });
}