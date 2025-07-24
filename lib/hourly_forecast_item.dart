import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget{
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.4),
      elevation: 8,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Text(time, style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8),
            Icon(
              icon,
              size: 35,
            ),
            SizedBox(height: 8),
            Text('$temperature °C')
          ],
        ),
      ),
    );
  }
}