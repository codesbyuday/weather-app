import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget{
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem({super.key,
    required this.icon,
    required this. label,
    required this.value
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 15)),
        SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      ],
    );
  }
}