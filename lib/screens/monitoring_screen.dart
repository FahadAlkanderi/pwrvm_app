import 'package:flutter/material.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  final List<String> stages = const [
    "Pulping",
    "Filtering",
    "Pressing",
    "Drying",
  ];

  final int currentStage = 1; // example, stage 2: Filtering

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recycling Process")),
      body: ListView.builder(
        itemCount: stages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              index < currentStage
                  ? Icons.check_circle
                  : index == currentStage
                      ? Icons.timelapse
                      : Icons.radio_button_unchecked,
              color: index <= currentStage ? Colors.green : Colors.grey,
            ),
            title: Text(stages[index]),
          );
        },
      ),
    );
  }
}
