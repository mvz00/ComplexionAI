import 'package:flutter/material.dart';

class AnalysisHistoryPage extends StatelessWidget {
  const AnalysisHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text('Score: ${74 - index * 2}'),
              subtitle: Text('${index + 1} week${index > 0 ? 's' : ''} ago'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
