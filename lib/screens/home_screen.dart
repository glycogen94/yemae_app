import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // Import for better date formatting (add to pubspec if needed)
import 'event_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Helper function to format Firestore Timestamp to a readable string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Date not available';
    }
    // Basic formatting, consider using 'intl' package for better localization and formats
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    // Example using intl (after adding dependency and importing):
    // return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final confirmLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              if (confirmLogout ?? false) {
                 await _logout();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // Specify type for better type safety
        // Order events by date, assuming 'event_datetime' field exists
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('event_datetime', descending: false) // Order by date
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Use toString() for the error object for better debugging
          if (snapshot.hasError) {
            // Displaying the actual error might be helpful during development
            print('Firestore Error: ${snapshot.error}'); // Log the error
            return Center(child: Text('Error loading events: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No upcoming events found.'));
          }

          // Map Firestore documents to a list of event data maps
          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              // Get the data map from the document snapshot
              final eventData = events[index].data();
              final eventId = events[index].id; // Get the document ID

              // Safely access fields from the data map
              final title = eventData['title'] as String? ?? 'No Title';
              final posterUrl = eventData['poster_image_url'] as String?; // Can be null
              final eventTimestamp = eventData['event_datetime'] as Timestamp?; // Access as Timestamp

              // Format the timestamp
              final formattedDate = _formatTimestamp(eventTimestamp);

              return Card( // Use Card for better visual separation
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: posterUrl != null && posterUrl.isNotEmpty
                      ? Image.network( // Display poster image
                          posterUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          // Add error handling for image loading
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                          loadingBuilder: (context, child, loadingProgress) {
                             if (loadingProgress == null) return child;
                             return const SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()));
                          },
                        )
                      : const SizedBox(width: 50, height: 50, child: Icon(Icons.event, size: 40)), // Placeholder if no image
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Date: $formattedDate'),
                  trailing: const Icon(Icons.arrow_forward_ios), // Indicate tappable
                  onTap: () {
                     // Make sure eventId is not null before navigating
                    if (eventId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(eventId: eventId),
                          ),
                      );
                    } else {
                       print("Error: Event ID is empty for item at index $index");
                       // Optionally show a snackbar or message to the user
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Could not open event details.'))
                       );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Ensure EventDetailScreen exists and accepts eventId
// Example placeholder for EventDetailScreen:
// class EventDetailScreen extends StatelessWidget {
//   final String eventId;
//   const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Event Details')), // Use provided title
//       body: Center(child: Text('Details for event ID: $eventId')), // Corrected variable name
//     );
//   }
// }
