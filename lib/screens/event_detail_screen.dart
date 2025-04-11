import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('events').doc(eventId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Event not found.'));
          }

          final eventData = snapshot.data!.data() as Map<String, dynamic>; // Cast to Map

          // Safely access fields with null checks or default values
          final title = eventData['title'] as String? ?? 'No Title';
          final description = eventData['description'] as String? ?? 'No Description';
          final date = eventData['date'] as String? ?? 'Date TBD';
          final venue = eventData['venue'] as String? ?? 'Venue TBD'; // Assuming venue name for now
          // TODO: Add more fields like venue details, seat map reference, etc.

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Date: \$date'),
                const SizedBox(height: 8),
                Text('Venue: \$venue'),
                const SizedBox(height: 16),
                Text(description),
                // TODO: Add UI for seat selection, booking button etc. in later phases
              ],
            ),
          );
        },
      ),
    );
  }
}
