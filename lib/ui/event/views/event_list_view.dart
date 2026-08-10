import 'package:flutter/material.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventListView'),
      ),
      body: const Center(
        child: Text('EventListView'),
      ),
    );
  }
}
