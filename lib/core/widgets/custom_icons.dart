import 'package:flutter/material.dart';

class CustomIcons {
  static const IconData dentistry = IconData(0xe900, fontFamily: 'CustomIcons');
  
  static Icon dentistryIcon({
    double? size,
    Color? color,
  }) {
    return Icon(
      Icons.medical_services, // Fallback to medical_services icon
      size: size,
      color: color,
    );
  }
} 