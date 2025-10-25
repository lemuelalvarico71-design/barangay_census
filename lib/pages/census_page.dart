import 'package:flutter/material.dart';

class CensusPage extends StatelessWidget {
  const CensusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Census',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
